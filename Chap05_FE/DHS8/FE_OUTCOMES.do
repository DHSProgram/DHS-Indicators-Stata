/*******************************************************************************
Program: 		FE_OUTCOMES.do - DHS8 update
Purpose: 		Creates distribution of pregnancy outcomes by covariates with the NR file				
using the NR file (the cases are pregnancies)
Data outputs:	coded variables, table output on screen, and in excel tables.  
Author: 		Tom Pullum 
Date last modified:	May 1, 2024 for DHS8 by Tom Pullum


*******************************************************************************/

* Subprograms begin here
********************************************************************************

program define make_table_5pt14

use "$datapath//$nrdata.dta", clear

* Table 5.14, distribution of pregnancy outcomes

* Construct binary variables for each outcome
forvalues lout=1/4 {
gen     out`lout'=0
replace out`lout'=100 if p32==`lout'
}
gen wt=v005/1000000

* Construct covariates not already in gcovars
* Total
gen total=1
label variable total "Total"
label define total 1 "Total"
label values total total

* Woman's age at outcome, 5 cats
gen age=int((p3-v011)/12)

gen age_5cats=1
replace age_5cats=2 if age>=20
replace age_5cats=3 if age>=25
replace age_5cats=4 if age>=35
replace age_5cats=5 if age>=45
label variable age_5cats "Age Group"

label define age_5cats 1 "<20" 2 "20-24" 3 "25-34" 4 "35-44" 5 "45-49"
label values age_5cats age_5cats

* Recoded pregnancy order, truncated at 5
gen     pordr=pord
replace pordr=5 if pord>5
label variable pordr "Pregnancy order"
label define pordr 1 "First" 2 "Second" 3 "Third" 4 "Fourth" 5 "Fifth+"
label values pordr pordr

local lcovars age_5cats pordr $gcovars

keep wt out* `lcovars'
gen cases=1
save "$resultspath/temp.dta", replace

* Save the variable and value labels
foreach lc of local lcovars { 
local llabel : variable label `lc'
scalar slabel_`lc'="`llabel'"

levelsof `lc', local(levels_`lc')
  foreach li of local levels_`lc' {
  local llabel : label (`lc') `li'
  scalar slabel_`lc'_`li'="`llabel'"
  }
}

clear

* Loop through the covariates, collapsing and appending subtables
scalar scounter=1
scalar svariable_sequence=1
quietly foreach lc of local lcovars {
use "$resultspath/temp.dta", clear
collapse (mean) out* (sum) cases [iweight=wt], by(`lc')
gen str40 covariate="`lc'"
gen str40 covariate_label=slabel_`lc'
gen category=`lc'
gen str30 category_label="."

  foreach li of local levels_`lc' {
  replace category_label=slabel_`lc'_`li' if category==`li'
  }

drop `lc'
gen variable_sequence=svariable_sequence
  if scounter>1 {
  append using "$resultspath/temp0.dta"
  }
save "$resultspath/temp0.dta", replace

scalar scounter=scounter+1
scalar svariable_sequence=svariable_sequence+1
}

* Cleanup
order covariate* category*
sort variable_sequence category
drop variable_sequence
format out* cases %8.1fc
list, table clean

* Save the table as a dta file
save "$resultspath/table_5pt14.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.14") sheetreplace firstrow(var)

erase "$resultspath/temp.dta
erase "$resultspath/temp0.dta

end

********************************************************************************

program define table_5pt15_setup

* Version of setup that matches the fertility rates program but uses p3 and p32

use "$datapath//$irdata.dta", clear

* Save any covariates that are needed. The standard table only includes v025 and total.
keep v001-v013 v025 awfact* p3_* p32_* 

gen total=1
label variable total "Total"
label define total 1 "Total"
label values total total

gen wt=v005/1000000

rename *_0* *_*

* Specify the window of time
gen UT=v008-1
gen LT=v008-36

save "$resultspath/IRtemp.dta", replace

* Calculate the numbers of outcomes
reshape long p3_ p32_ , i(v001 v002 v003) j(pidx)
rename *_ *
drop if p3==.

* Restrict to outcomes in the window of time
drop if p3<LT | p3>UT

* age at outcome in single years
gen age=int((p3-v011)/12)

* age at outcome in 5-year intervals, except for 12, 13, 14
gen age5=age if age<15
foreach la in 15 20 25 30 35 40 45 {
replace age5=`la' if age>=`la'& age<`la'+5
}

* Numbers of outcomes by age
forvalues lout=1/4 {
gen nout`lout'=0
replace nout`lout'=1 if p32==`lout' & age>=15

* Inflation of the numerators and denominators for ages 12, 13, 14 is required
*  for all of the outcomes, as in the procedure for under-15 fertility

* Inflate the numbers of outcomes appropriately for ages below 15 
replace nout`lout'=6/1 if p32==`lout' & age==12
replace nout`lout'=6/3 if p32==`lout' & age==13
replace nout`lout'=6/5 if p32==`lout' & age==14
}

replace age5=10 if age>=12 & age<15

collapse (sum) nout1 nout2 nout3 nout4, by(v001 v002 v003 age5)

* Reshape wide to get counts for each value of age5 all on a single record

rename nout* nout*_
reshape wide nout1_ nout2_ nout3_ nout4_ , i(v001 v002 v003) j(age5)

save "$resultspath/outcomes.dta", replace

* Reopen the reduced IR file to calculate exposure for all cases
use "$resultspath/IRtemp.dta", clear
drop p*

* Calculate the lower and upper cmc's of each age interval for each woman
quietly foreach la in 12 13 14 15 20 25 30 35 40 45 {
gen LA_`la'=v011+12*`la'

* There is uncertainty about which of the single years 12-14 will actually show up

* Single-year intervals for age 12-14
if `la'<15 {
gen UA_`la'=LA_`la'+11
}

* 5-year intervals for age 15+
if `la'>=15 {
gen UA_`la'=LA_`la'+59
}

gen exp_years_`la'=min(UT,UA_`la') - max(LT,LA_`la') + 1
replace exp_years_`la'=0 if exp_years_`la'<0
replace exp_years_`la'=exp_years_`la'/12
}

* Inflate the exposure appropriately for ages below 15
replace exp_years_12=(6/1)*exp_years_12
replace exp_years_13=(6/3)*exp_years_13
replace exp_years_14=(6/5)*exp_years_14

* Aggregate the re-weighted exposure for ages 12-14
gen exp_years_10=exp_years_12+exp_years_13+exp_years_14
drop *_12 *_13 *_14

* Merge numbers of outcomes with exposure to each interval
merge 1:1 v001 v002 v003 using "$resultspath/outcomes.dta
drop LA* UA*

* After the merge, must replace each nout with 0 if it is .
* This applies to women who had no outcomes within the window.
quietly foreach la in 10 15 20 25 30 35 40 45 {
  forvalues lout=1/4 {
  capture confirm numeric variable nout`lout'_`la', exact 
    if _rc>0 {
    gen nout`lout'_`la'=0
    }
  replace nout`lout'_`la'=0 if nout`lout'_`la'==.
  }
}

drop _merge

* This is a file with outcomes and exposure for each age interval in the window of time.
* One record per woman. Includes v005, aw factors, and covariates 
save "$resultspath/outcomes_and_exposure.dta", replace

erase "$resultspath/IRtemp.dta"
erase "$resultspath/outcomes.dta"

end

********************************************************************************

program define table_5pt15_loop


* Specify the covariates
local lcovars v025 total
*local lcovars total

* construct a local for a reshape long and reshape wide command
scalar snouts="nout1_ nout2_ nout3_ nout4_ "
local  lnouts=snouts

* Construct another local for another reshape wide command
scalar srates="rate1_ rate2_ rate3_ rate4_ "
scalar svarlist=snouts+" exp_years_ "+srates
local  lvarlist=svarlist

* Short segment to construct locals and scalars for labels
use "$resultspath/outcomes_and_exposure.dta", clear

* Save the variable and value labels
foreach lc of local lcovars { 
local llabel : variable label `lc'
scalar slabel_`lc'="`llabel'"

levelsof `lc', local(levels_`lc')
  foreach lcat of local levels_`lc' {
  local llabel : label (`lc') `lcat'
  scalar slabel_`lc'_`lcat'="`llabel'"
  }
}

* scount is a counter for the loops
scalar scount=0
*********************************************************
* BEGIN LOOP OVER CATEGORIES OF COVARIATES FOR THIS TABLE
*********************************************************
foreach lc of local lcovars {
foreach lcat of local levels_`lc' {

scalar sc="`lc'"
scalar scat=`lcat'
scalar list sc scat

* Save the cases if a specific category of a covariate
keep if `lc'==`lcat'

quietly foreach la in 10 15 20 25 30 35 40 45 {
  if "`lc'"=="total" {
  replace exp_years_`la'=exp_years_`la'*(awfactt/100)
  }
  if "`lc'"=="v025" {
  replace exp_years_`la'=exp_years_`la'*(awfactu/100)
  }
* You must add other awfactors for other covariates in EMW surveys
}

collapse (sum) nout* exp_years* [iweight=wt]
gen dummy=1
reshape long `lnouts' exp_years_ , i(dummy) j(age5)
drop dummy

* Remove underscore
rename nout*_ nout*
rename exp_years_ exp_years 

forvalues lout=1/4 {
gen rate`lout'=1000*nout`lout'/exp_years
}

label variable nout1 "Live births"
label variable nout2 "Stillbirths"
label variable nout3 "Miscarriages"
label variable nout4 "Abortions"
label variable exp_years "Exposure"
label variable rate1 "Live births"
label variable rate2 "Stillbirths"
label variable rate3 "Miscarriages"
label variable rate4 "Abortions"

list, table clean

rename age5 age
save "$resultspath/temp2.dta", replace

* Add rows

* 97: Totals for General Rates (all ages for numerators, 15-44 for exposure);
*     also totals for TFR before multiplying by 5/1000
* 98: Total Rates: sum of rates for 15-49
* 99: General Rates: ratio of numerators to exposure in 97
* General rate (DHS version): nout for ALL AGES divided by exposure for age 15-44

* Totals need for Total and General rates
* Total rate adds the rates for 15-49
* General rate includes all ages in numerator and 15-44 in denominator
use "$resultspath/temp2.dta", clear
replace exp_years=0 if age==10 | age==45
  forvalues lout=1/4 {
  replace rate`lout'=0 if age==10
  }
collapse (sum) nout* exp_years* rate*
gen age=97
save "$resultspath/row97.dta", replace

* Total rates  
use "$resultspath/row97.dta", clear
  forvalues lout=1/4 {
  replace rate`lout'=5*rate`lout'/1000
  }
drop nout* exp_years*
replace age=98
save "$resultspath/row98.dta", replace


* General rates
use "$resultspath/row97.dta", clear
  forvalues lout=1/4 {
  replace rate`lout'=1000*nout`lout'/exp_years
  }
drop nout* exp_years*
replace age=99
save "$resultspath/row99.dta", replace

use "$resultspath/temp2.dta", clear
append using "$resultspath/row97.dta"
append using "$resultspath/row98.dta"
append using "$resultspath/row99.dta"
sort age

list, table clean

label variable age "Age group"
label define age 10 "<15" 15 "15-19" 20 "20-24" 25 "25-29" 30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" 96 "Sum 15-44" 97 "Subtotals" 98 "Total rates" 99 "General rates"
label values age age
gen str12 covariate="`lc'"
gen str40 covariate_label=slabel_`lc'
order covariate*

* Optional save
*save "$resultspath/table_5pt15_`lc'_`lcat'.dta", replace

keep age rate4
drop if age==97

* Insert a number into the variable name that can be used for re-ordering the variables
local lcount=scount
scalar snewlabel="v`lcount'_"+slabel_`lc'_`lcat'
local lnewlabel=snewlabel

rename rate4 `lnewlabel'

  if scount>0 {
  merge 1:1 age using "$resultspath/temp3.dta"
  drop _merge
  }

save "$resultspath/temp3.dta", replace
scalar scount=scount+1

* At the end of the loop, open the file again
use "$resultspath/outcomes_and_exposure.dta", clear

*********************************************************
* END LOOP OVER CATEGORIES OF COVARIATES FOR THIS TABLE
*********************************************************
}
}

* save the max value of scount
local lcount_max=scount-1
use "$resultspath/temp3.dta", clear
*list, table clean

* We need to re-sequence the columns from the merge
order age *_*, sequential

* remove the v*_ part of the variable name that was used for order; clumsy but works
forvalues lc=0/`lcount_max' {
rename v`lc'_* *
}

list, table clean

rename *, proper

save "$resultspath/table_5pt15.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.15") sheetreplace firstrow(var)

erase "$resultspath/outcomes_and_exposure.dta"
erase "$resultspath/row97.dta"
erase "$resultspath/row98.dta"
erase "$resultspath/row99.dta"
erase "$resultspath/temp2.dta"
erase "$resultspath/temp3.dta"

end

*********************************************************************

program define make_table_5pt15

* Make table 5.15, induced abortion rates for urban, rural, total

/*
This table uses the IR file for both the numerators and the denominators of the rates.

The NR file cannot be used for this table. The reference period for the NR file is p19 = 0 to 35.
The reference period for this table is calendar months 1 to 36 before the calendar month of interview.

Induced abortion is outcome #4 of p32. This program produces results for all foure outcomes (births,
  stillbirths, miscarriages) but only saves #4.

This is a relatively complex routine, even though the table has few numbers in it. It 
  is general with respect to outcomes and possible covariates.

The only covariates actually included here are v025 and total but others could be added.

The reference time interval is the past 3 years. It could be changed. Instead of using the
  NR file, you would construct a similar file by reshaping the p variables in the IR file.
*/

* Specify the default day of the woman's birth
scalar sday=1

scalar scid=substr("$irdata",1,2)

table_5pt15_setup
table_5pt15_loop


end

*********************************************************************
*********************************************************************
*********************************************************************
*********************************************************************
*********************************************************************
* Execution begins here

make_table_5pt14
make_table_5pt15

*program drop _all
