
/*******************************************************************************
Program: 		FE_RATES.do - DHS8 update
Purpose: 		Code to compute fertility rates, including asfrs, TFR, and GFR
Data inputs: 	IR dataset
Data outputs:	coded variables
Author:			Thomas Pullum and modified by Courtney Allen for the codeshare project
Date last modified: January 31, 2024 by Tom Pullum for DHS8
*******************************************************************************/


/*------------------------------------------------------------------------------
Variables created in this file:
ASFR		"age specific fertility rates"
TFR			"fertility rates"
GFR			"general fertility rate"
DHSGFR		"DHS general fertility rates"
------------------------------------------------------------------------------*/

/*NOTES on terminology----------------------------------------------------------
EMW: ever-married women's survey, this is a survey that only included ever-married women as respondents
AWFACT: all women factor to adjust ever-married samples to estimate statistics based on all women.
See the Guide To Statistics, Chapter 1 for more information on all women factors. (https://dhsprogram.com/Data/Guide-to-DHS-Statistics/index.htm)
------------------------------------------------------------------------------*/



program define reshape_wide_and_append

list, table clean noobs abbrev(15)

local lcov=scov

* reshape wide and add

foreach lv in births exposure rate {
rename `lv' `lv'_
}

gen dummy=1
reshape wide exposure_ births_ rate_, i(dummy) j(age)
drop dummy

gen run=srun
gen lw=lw
gen uw=uw
gen str10 variable=scov
gen value=scat

order run lw uw 

if srun>1 {
append using "$workingpath//fertility_rates.dta"
}

save "$workingpath//fertility_rates.dta", replace

scalar srun=srun+1

end

**********************************************************************

program define calculate_rates

local lpath=spath

*use "$workingpath//exposure_and_births.dta", clear

collapse (sum) yexp_* births_*
gen dummy=1
reshape long yexp_ births_, i(dummy) j(age)
rename *_ * 
rename yexp exposure
drop dummy

sort age

label define age 0 "10-14" 1 "15-19" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49" 8 "15-49" 100 "TFR" 200 "GFR"
label values age age

* Fertility rates
gen rate=1000*births/exposure
save "$workingpath//rates_by_age.dta", replace

* Terms for the totals (and the TFR)
* Collapse to get totals

* Construct a row for the TFR
use "$workingpath//rates_by_age.dta", clear
drop if age==0
collapse (sum) rate
replace rate=5*rate/1000
gen age=100
save "$workingpath//TFR.dta", replace

* Construct a row for the GFR
use "$workingpath//rates_by_age.dta", clear
gen exposure_15to44=0
replace exposure_15to44=exposure if age>=1 & age<=6
collapse (sum) births exposure_15to4
gen rate        =1000*births/exposure_15to44
gen age=200
keep age rate
sort age
save "$workingpath//GFR.dta", replace

use "$workingpath//rates_by_age.dta", clear
append using "$workingpath//TFR.dta"
append using "$workingpath//GFR.dta"

* Append this run to the output file
reshape_wide_and_append

erase "$workingpath//TFR.dta"
erase "$workingpath//GFR.dta"
erase "$workingpath//rates_by_age.dta"

end

**********************************************************************

program define make_exposure_and_births

* Exposure comes from the IR file

local lpath=spath

use "$workingpath//IRtemp.dta", clear
gen wt=v005/1000000

* Adjust wt with awfact*, just for the exposure, if this is an Ever-married women's (EMW) survey
* If you use covariates other than those below, you must construct new awfactors first
* Here the use of awfacte for v149, not just v106, is an approximation

if sEMW==1 {
  if scov=="total"{
  replace wt=wt*awfactt/100
  }
 
  if scov="v024" {
  replace wt=wt*awfactr/100
  }

  if scov=="v025"{
  replace wt=wt*awfactu/100
  }

  if scov="v106" {
  replace wt=wt*awfacte/100
  }

  if scov="v149" {
  replace wt=wt*awfacte/100
  }

  if scov=="v190"{
  replace wt=wt*awfactw/100
  }
}

* specify the lower and upper cmc's of the window using lw, uw, and v008
gen ucmc=v008+12*uw-1
gen lcmc=v008+12*lw-12

* Calculate lcmc_n and ucmc_n, the lower and upper cmc for five-year age interval n
forvalues ln=0/7 {
gen lcmc_`ln'=v011+180+60*(`ln'-1)
gen ucmc_`ln'=lcmc_`ln'+59
}
 
* Exposure
forvalues ln=0/7 {
gen mexp_`ln'=0
replace mexp_`ln'= min(ucmc, ucmc_`ln') - max(lcmc, lcmc_`ln') + 1 

* replace any negative exposures by 0
replace mexp_`ln'=0 if mexp_`ln'<0

* Convert from months to years of exposure and include wt
* Include the appropriate awfact* for an EMW survey
gen yexp_`ln'=wt*mexp_`ln'/12
}

* Change the weight back to the unadjusted value
replace wt=v005/1000000

* Births
forvalues ln=0/7 {
gen births_`ln'=0
  forvalues lb=1/20 {
  replace births_`ln'=births_`ln'+1 if b3_`lb'>=max(lcmc, lcmc_`ln') & b3_`lb'<=min(ucmc, ucmc_`ln')
  }
replace births_`ln'=wt*births_`ln'
}

save "$workingpath//exposure_and_births.dta", replace

end

******************************************************************************

program define wanted_fertility

* Note: for "wanted" fertility, the "keep" statement must include b5_*, b6_*, b7_*, and v613  

*v613            byte    %8.0g      V613       ideal number of children

* Loop through the birth history
* Assume that v613 has never changed from the beginning of childbearing to the present
* Classify a birth as unwanted if, when the pregnancy occurred, the number of living children was >=v613 

* Need to calculate the number of living children that the woman had at the beginning of every pregnancy.
* Work backwards from bidx=1 

* The coding does not use current pregnancy status in any way
* It is possible that the last child was not wanted, but died, and now the woman has her desired number; survival status of the last child is not used
* The coding is only relevant if v613<v201 

* wanted is 1 if birth was wanted at the time of conception, . if not wanted

* nlc_`li' is the number of living children at the point of conception of birth li
* wanted_status_`li' is 0 if nlc_`li'>=v613

keep v001 v002 v003 v005 v008 v011 b3_* b5_* b6_* b7_* v613 awfact* $gcovars

* Initialize and construct cmc of death for children who died
local li=1
while `li'<=20 {
gen nlc_`li'=0
gen     cmc_of_death_`li'=.
replace cmc_of_death_`li'=b3_`li'+b7_`li'   if int(b6_`li'/100)<3
replace cmc_of_death_`li'=b3_`li'+b7_`li'+6 if int(b6_`li'/100)==3
local li=`li'+1
}

local li=1
while `li'<=19 {
  local lii=`li'+1
  while `lii'<=20 {
  replace nlc_`li'= nlc_`li'+1 if (b5_`lii'==0 & cmc_of_death_`lii'>=b3_`li'-9) | b5_`lii'==1
  local lii=`lii'+1
  }

***UPPER LIMIT USED IN JORDAN 2012 AND SOME OTHER SURVEYS
*gen wanted_`li'=1 if nlc_`li'<v613 & v613<=90

***UPPER LIMIT USED IN MOST OTHER SURVEYS AND STAT COMPILER
gen wanted_`li'=1 if nlc_`li'<v613 & v613<=98

replace b3_`li'=. if wanted_`li'==.
local li=`li'+1
}

drop cmc_of_death_* nlc_* wanted_*

end

**********************************************************************

program define main

local lpath=spath

use "$datapath//$irdata.dta", clear
rename *_0* *_*

gen total=1
label variable total "Total"
label define total 1 "Total"
label values total total

****************
* THE SCALAR sWANTED_FERTILITY_RATES WAS DEFINED EARLIER IN THE EXECUTION OF THIS PROGRAM
****************
if sWANTED_FERTILITY_RATES==1 {
wanted_fertility
}
****************
****************

* If you want more covariates, specify them in the keep command
keep v001 v002 v003 v005 v008 v011 b3_* awfact* $gcovars

* If you want to recode any covariates, insert the recodes here

* Check whether this is an EMW survey. If it is, you can only include
*   covariates for which the aw factors are in the data
scalar sEMW=0
quietly summarize awfactt
if r(mean)>100 {
scalar sEMW=1
}

* We can drop the aw factors if this is not an EMW survey
if sEMW==0 {
drop awfact*
}

save "$workingpath//IRtemp.dta", replace

* Need to specify a full list of the covariates at this point
foreach lcov of global gcovars {
levelsof `lcov', local(lcats_`lcov')
}


/* 
Specify the time interval for the estimates; the default is the past 3 years
lw and uw specify the months ago for the lower and upper end of the window,
  in years, inclusive

                  lw    uw
Past 3 years:      0    -2
 0- 4 years ago:   0    -4
 5- 9 years ago:  -5    -9
10-14 years ago: -10   -14
*/ 

* Must run "make_exposure_and_births" each time that the time interval is re-set

* Calculate rates for total and categories of covariates, all for 0-2 years ago
scalar lw=-2
scalar uw=0
scalar list lw uw
quietly make_exposure_and_births

foreach lcov of global gcovars {
scalar scov="`lcov'"
scalar list scov
  quietly foreach lcat of local lcats_`lcov' {
  scalar scat=`lcat'
  use "$workingpath//exposure_and_births.dta", clear
  keep if `lcov'==`lcat'
  calculate_rates
  }
}

* Calculate for the total for 0-4, 5-9, 10-14, and 15-19 years ago
scalar scov="total"
scalar list scov
scalar lw=-4
scalar uw=0
scalar list lw uw
quietly make_exposure_and_births
quietly calculate_rates

scalar lw=-9
scalar uw=-5
scalar list lw uw
quietly make_exposure_and_births
quietly calculate_rates

scalar lw=-14
scalar uw=-10
scalar list lw uw
quietly make_exposure_and_births
quietly calculate_rates

scalar lw=-19
scalar uw=-15
scalar list lw uw
quietly make_exposure_and_births
quietly calculate_rates


* All rates have been produced; save the data locally
sort run
save "$workingpath//fertility_rates.dta", replace
list run lw uw variable value rate_*, table clean noobs

erase "$workingpath//IRtemp.dta"
erase "$workingpath//exposure_and_births.dta"

end

**********************************************************************

program define make_table_5pt1

* Make table 5.1, need to add the CBR in another program
use "$workingpath//fertility_rates.dta", clear
keep if lw==-2 & uw==0
keep if variable=="total" | variable=="v025"
keep variable value rate_*
list, table clean
reshape long rate_, i(variable value) j(age)
save "$workingpath//temp0.dta", replace

keep if variable=="v025" & value==1
rename rate_ rate_urban
sort age
save "$workingpath//temp_urban.dta", replace

use "$workingpath//temp0.dta", clear
keep if variable=="v025" & value==2
rename rate_ rate_rural
sort age
save "$workingpath//temp_rural.dta", replace

use "$workingpath//temp0.dta", clear
keep if variable=="total" & value==1
rename rate_ rate_total
sort age
save "$workingpath//temp_total.dta", replace

quietly merge 1:1 age using "$workingpath//temp_urban.dta"
drop _merge
sort age
quietly merge 1:1 age using "$workingpath//temp_rural.dta"
drop _merge value variable

order age rate_urban rate_rural rate_total
list, table clean noobs
save "$workingpath//table_5pt1_current_fertility.dta", replace
export excel using "$workingpath//FE_tables.xlsx", sheet("Table 5.1 Current fertility") sheetreplace firstrow(var)

erase "$workingpath//temp0.dta"
erase "$workingpath//temp_urban.dta"
erase "$workingpath//temp_rural.dta"
erase "$workingpath//temp_total.dta"

end

**********************************************************************

program define make_table_5pt2

* This routine constructs the tables with covariates in chapter 5: 

* Table 5.2 (column 1)

* The next few lines are used in order to get the variable labels and
*  value labels for the covariates.

use "$datapath//$irdata.dta", clear
gen total=1
label variable total "Total"
label define total 1 "Total"
label values total total

label copy V024 v024

keep $gcovars 
foreach lc of global gcovars {

* Put the variable labels into scalars
local llabel : variable label `lc'
scalar svariable_label_`lc'="`llabel'"


* Put the value labels into scalars
levelsof `lc', local(levels_`lc')
  foreach li of local levels_`lc' {
  local lname : label (`lc') `li'
  scalar svalue_label_`lc'_`li'="`lname'" 
  }
}

use "$workingpath//fertility_rates.dta", clear
keep if lw==-2
rename rate_100 TFR
keep variable value TFR

gen str40 variable_label="."
gen str40 value_label="."
gen var_sequence=.

scalar svar_sequence=1
foreach lc of global gcovars {
replace variable_label=svariable_label_`lc' if variable=="`lc'"

  foreach li of local levels_`lc' {
  replace value_label=svalue_label_`lc'_`li' if variable=="`lc'" & value==`li'
  }
replace var_sequence=svar_sequence if variable=="`lc'"
scalar svar_sequence=svar_sequence+1
}

replace variable_label=strproper(variable_label)
replace value_label=strproper(value_label)

sort var_sequence value
order var_sequence variable value variable_label value_label TFR
keep variable value variable_label value_label TFR
format TFR %5.2f
list, table clean

local lvars variable value variable_label value_label

save "$workingpath//table_5pt2_TFR.dta", replace
export excel `lvars' TFR using "$workingpath//FE_tables.xlsx", sheet("Table 5.2 TFR") sheetreplace firstrow(var)

end

**********************************************************************

program define make_table_5pt3pt1

* Make table 5.3.1, rates for 5-year windows going back in time
use "$workingpath//fertility_rates.dta", clear
keep if variable=="total"
tab lw
drop if lw==-2
drop run variable value *_100 *_200 exposure_* births_*
reshape long rate_, i(lw uw) j(age)
save "$workingpath//temp0.dta", replace

use "$workingpath//temp0.dta", clear
keep if lw==-4 & uw==0
rename rate_ rate_0to4
sort age
save "$workingpath//temp_0to4.dta", replace

use "$workingpath//temp0.dta", clear
keep if lw==-9 & uw==-5
rename rate_ rate_5to9
sort age
save "$workingpath//temp_5to9.dta", replace

use "$workingpath//temp0.dta", clear
keep if lw==-14 & uw==-10
rename rate_ rate_10to14
sort age
save "$workingpath//temp_10to14.dta", replace

use "$workingpath//temp0.dta", clear
keep if lw==-19 & uw==-15
rename rate_ rate_15to19
sort age
save "$workingpath//temp_15to19.dta", replace

quietly merge 1:1 age using "$workingpath//temp_0to4.dta"
drop _merge
sort age
quietly merge 1:1 age using "$workingpath//temp_5to9.dta"
drop _merge
sort age
quietly merge 1:1 age using "$workingpath//temp_10to14.dta"
drop _merge lw uw
order age rate_0to4 rate_5to9 rate_10to14 rate_15to19
list, table clean noobs
save "$workingpath//table_5pt3pt1_ASFR.dta", replace
export excel using "$workingpath//FE_tables.xlsx", sheet("Table 5.3.1 ASFR") sheetreplace firstrow(var)

erase "$workingpath//temp0.dta"
erase "$workingpath//temp_0to4.dta"
erase "$workingpath//temp_5to9.dta"
erase "$workingpath//temp_10to14.dta"
erase "$workingpath//temp_15to19.dta"

end

**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************
* Execution begins here

* Specify workspace
scalar spath="$workingpath"

/* NOTE: If you want wanted fertility rates, rather than the usual rates, set
   the following scalar to 1. Otherwise, be sure it is set to 0.
* The scalar appears in "!FEmain.do". If it is 1, then "wanted_fertility" is called.*/


* srun is a counter for the run, helpful for saving the results
scalar srun=1

main
make_table_5pt1
make_table_5pt2
make_table_5pt3pt1

program drop _all
