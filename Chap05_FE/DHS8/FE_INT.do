/*******************************************************************************
Program: 			FE_INT.do - DHS8 update
Purpose: 			Code fertility indicators from birth history reflecting birth intervals 
Data inputs: 		BR dataset
Data outputs:		coded variables, output on screen, Excel tables
Author:				Tom Pullum and Courtney Allen
Date last modified: May 1, 2024 by Tom Pullum for DHS8
*******************************************************************************
______________________________________________________________________________
Variables created in this file:

//BIRTH INTERVALS
fe_int			"Birth interval of recent non-first births"
fe_age_int		"Age groups for birth interval table"
fe_bord			"Birth order"
fe_bord_cat		"Birth order"
fe_pre_sex		"Sex of preceding birth"
fe_pre_surv		"Survival of preceding birth"
*/

*********************************************************************************

program define construct_indicators

use "$datapath//$brdata.dta", clear

gen total=1
label variable total "Total"
label define total 1 "Total"
label values total total

keep caseid v005 v013 b* $gcovars 
gen wt = v005/1000000

* Construct outcome: categories of birth interval
	//Birth interval, number of months since preceding birth
	recode b11 (min/17= 1 "less than 17 months") (18/23 = 2 "18-23 months") ///
			  (24/35 = 3 "24-35 months") (36/47 = 4 "36-47 months") (48/59 = 5 "48-59 months") ///
			  (60/max = 6 "60+ months"), gen(fe_int) label(fe_int_lab)
	label var fe_int "Months since preceding birth"


* Construct extra covariates: mother's age, sex of preceding birth, survival of preceding birth, and categories of birth order

* Construct age groups for mother
	recode v013 (1=1 "15-19") (2/3 = 2 "20-29") (4/5 = 3 "30-39") (6/7 = 4 "40-49"), gen(fe_age_int) label(fe_age_int)
	label var fe_age_int "Mother's age"
label values fe_age_int fe_age_int


* Construct categories of birth order
	//Create birth interval, excluding first births and their multiples
	gen fe_bord = bord if b0 < 2
	replace fe_bord = bord - b0 + 1 if b0 > 1
	recode fe_bord (1 =1 "1") (2/3 = 2 "2-3") (4/6 = 4 "4-6") (7/max = 7 "7+"), gen(fe_bord_cat) label(fe_bord_lab)
	label var fe_bord_cat "Birth order categories"

* Construct sex and survival of preceding birth
	//Sex of preceding birth
	sort caseid bord
	gen fe_pre_sex = b4[_n-1] if caseid==caseid[_n-1]
	*replace fe_pre_sex = b4[_n-2]
	label define sexlabel 1 "Male" 2 "Female"
	label val fe_pre_sex sexlabel
	label var fe_pre_sex "Sex of preceding birth"
	
	//Survival of preceding birth	sort caseid bord
	gen fe_pre_surv = b5[_n-1] if caseid==caseid[_n-1]
	label define alivelabel 0 "Dead" 1 "Living"
	label val fe_pre_surv alivelabel
	label var fe_pre_surv "Survival of preceding birth"

	//now drop children over 59 months, no longer needed for tabulations
	drop if b19>59 

* Drop children who were first births or were second births but also the second of twins
        drop if bord==1 | (bord==2 & b0==2)

keep wt v005 b11 $gcovars fe_* 
save "$resultspath/birth_interval_variables.dta", replace

end

*********************************************************************************
program define calc_median_months

	summarize time [fweight=weightvar], detail

	scalar sp50=r(p50)

	gen dummy=0 
	replace dummy=1 if time<sp50 
	summarize dummy [fweight=weightvar]
	scalar sL=r(mean)

	replace dummy=0
	replace dummy=1 if time<=sp50
	summarize dummy [fweight=weightvar]
	scalar sU=r(mean)
	drop dummy

	scalar smedian=round(sp50+(.5-sL)/(sU-sL),.01)
	scalar list sp50 sL sU smedian

	// warning if sL and sU are miscalculated
	if sL>.5 | sU<.5 {
	//ERROR IN CALCULATION OF L AND/OR U
	}

end

*********************************************************************************

program define make_table_5pt5

* Construct Table 5.5

use "$resultspath/birth_interval_variables.dta", clear

local lcovars fe_age_int fe_pre_sex fe_pre_surv fe_bord_cat $gcovars

gen str40 variable_label="."
gen str20 value_label="."

foreach lc of local lcovars {
* Put the variable labels into a new string variable

* Put the value labels into a new string variable
levelsof `lc', local(levels_`lc')
  foreach li of local levels_`lc' {
  local lname : label (`lc') `li'
  replace value_label="`lname'" if `lc'==`li'
  }
}

* Construct the table row by row

forvalues lcat=1/6 {
gen interval`lcat'=0
replace interval`lcat'=1 if fe_int==`lcat'
}
drop fe_int
gen weightvar=v005
gen cases=1
gen time=b11

scalar svariable_sequence=1
save "$resultspath/0.dta", replace

scalar scounter=1
quietly foreach lc of local lcovars {

foreach li of local levels_`lc' {
use "$resultspath/0.dta" 

local llabel : variable label `lc'
scalar svariable_label="`llabel'"

local lname : label (`lc') `li'
scalar svalue_label="`lname'"

keep if `lc'==`li'

*************************** 
* Segment for each line of the table
calc_median_months
collapse (mean) interval* (sum) cases [iweight=wt]
gen median_months=smedian
gen variable_sequence=svariable_sequence
gen str10 variable="`lc'"
gen value=`li'
gen str40 variable_label=svariable_label
gen str40 value_label=svalue_label
*************************** 

if scounter>1 {
append using "$resultspath//1.dta"
} 
save "$resultspath/1.dta", replace
scalar scounter=scounter+1
}
scalar svariable_sequence=svariable_sequence+1
}

sort variable_sequence value
forvalues lcat=1/6 {
replace interval`lcat'=100*interval`lcat'
}

label variable interval1 " 7-17 months"
label variable interval2 "18-23 months"
label variable interval3 "24-35 months"
label variable interval4 "36-47 months"
label variable interval5 "48-59 months"
label variable interval6 "60+ months"
gen total=100
label variable total "Total"
label variable median_months "Median months since preceding birth"
replace variable_label=strproper(variable_label)
replace value_label=strproper(value_label)
order variable value variable_label value_label interval* total cases median_months
format interval* total median_months %6.1f
format cases %8.1fc 

list, table clean noobs
save "$resultspath//table_5pt5.dta", replace
export excel using "$resultspath//FE_tables.xlsx", sheet("Table 5.5") sheetreplace firstrow(var)

erase "$resultspath//0.dta"
erase "$resultspath//1.dta"
erase "$resultspath//birth_interval_variables.dta"

end

*********************************************************************************
*********************************************************************************
*********************************************************************************
*********************************************************************************
*********************************************************************************
* Execution begins here


construct_indicators
make_table_5pt5

program drop _all


