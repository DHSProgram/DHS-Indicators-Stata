/********************************************************************************
Program: 			FE_ASFR_10_14.do - DHS8 update
Purpose: 			Program to calculated a fertility rate for age 12-14 in the past 3 years. 
Data outputs:		Coded variables, table output on screen, and an excel table.  
Author: 			Tom Pullum and Courtney Allen
Date last modified:	May 1, 2024 by Tom Pullum
********************************************************************************/

/*
This is a concise program to calculate fertility rates for age 10-14, urban, rural, and total
The executable lines begin after the multiple lines of asterisks
Rates are calculated for age 12, 13, 14 (single years) and then Lexis-adjusted

It would be possible to consolidate this program with the one for the asfrs for
  ages 15-49 but it seems better to have a specialized program for 10-14 

Tom Pullum, tom.pullum@icf.com, January 2024

*/
**********************************************************************

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
append using "$resultspath//fertility_rates.dta"
}

save "$resultspath//fertility_rates.dta", replace

scalar srun=srun+1


end
**********************************************************************

program define calculate_rates

use "$resultspath//exposure_and_births.dta", clear

collapse (sum) yexp_* births_*
gen dummy=1
reshape long yexp_ births_, i(dummy) j(age)
rename *_ * 
rename yexp exposure
drop dummy

sort age

label define age_12_13_14 12 "12" 13 "13" 14 "14"
label values age age

gen rate=1000*births/exposure
reshape_wide_and_append

end

**********************************************************************

program define make_exposure_and_births

* Exposure comes from the IR file

use "$resultspath//IRtemp.dta", clear
gen wt=v005/1000000

* Adjust wt with awfact*, just for the exposure, if this is an EMW survey
if sEMW==1 {
 
  if scov=="v025"{
  replace wt=wt*awfactu/100
  }
}

* specify the lower and upper cmc's of the window using lw, uw, and v008
gen ucmc=v008+12*uw-1
gen lcmc=v008+12*lw-12

* Calculate lcmc_n and ucmc_n, the lower and upper cmc for single-year age n (=12, 13, 14)
forvalues ln=12/14 {
gen lcmc_`ln'=v011+12*`ln'
gen ucmc_`ln'=lcmc_`ln'+11
}
 
* Exposure
forvalues ln=12/14 {
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
forvalues ln=12/14 {
gen births_`ln'=0
  forvalues lb=1/20 {
  replace births_`ln'=births_`ln'+1 if b3_`lb'>=max(lcmc, lcmc_`ln') & b3_`lb'<=min(ucmc, ucmc_`ln')
  }
replace births_`ln'=wt*births_`ln'
}

save "$resultspath//exposure_and_births.dta", replace

end

**********************************************************************

program define main

use "$datapath//$irdata.dta", clear

* If you want more covariates, specify them in the keep command

* Restrict to age 15-17, the only women with exposure to 10-14 in the past 3 years
keep if v012>=15 & v012<=17

keep v001 v002 v003 v005 v008 v011 b3_* awfact* v025
rename *_0* *_*

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

save "$resultspath//IRtemp.dta", replace

* Need to specify a full list of the covariates at this point
foreach lcov in v025 {
levelsof `lcov', local(lcats_`lcov')
}


/* 
Specify the time interval for the estimates; default is the past 3 years.
lw and uw specify the months ago for the lower and upper end of the window,
  in years, inclusive

                  lw    uw
Past 3 years:      0    -2
*/ 


* Calculate rates for total and categories of covariates, all for 0-2 years ago
scalar lw=-2
scalar uw=0
scalar srun=1
scalar list lw uw
quietly make_exposure_and_births

scalar scov="v025"
local lcov=scov
  quietly foreach lcat of local lcats_`lcov' {
  scalar scat=`lcat'
  scalar list scov scat
  use "$resultspath//exposure_and_births.dta", clear
  keep if `lcov'==`lcat'
  calculate_rates
  }

drop run lw uw
sort value
save "$resultspath//fertility_rates_10_14.dta", replace
list, table clean noobs

end

**********************************************************************

program define make_table_5pt1_age_10to14

* For table 5.1, make a revised row for age 10-14

use "$resultspath//fertility_rates_10_14.dta", clear
drop rate*

* Reshape to get rows for age 12, 13, 14 and columns for urban, rural
reshape long exposure_ births_, i(value) j(age)
reshape wide exposure_ births_, i(age) j(value)

rename *_1 *_urban
rename *_2 *_rural
* Now insert the Lexis weights

gen Lexis_wt=.
replace Lexis_wt=6/1 if age==12
replace Lexis_wt=6/3 if age==13
replace Lexis_wt=6/5 if age==14

foreach li in urban rural {
gen wtd_exposure_`li'=Lexis_wt*exposure_`li'
gen wtd_births_`li'=Lexis_wt*births_`li'
}

collapse (sum) *exposure* *births*
gen exposure_total=exposure_urban + exposure_rural
gen births_total  =births_urban   + births_rural
gen wtd_exposure_total=wtd_exposure_urban + wtd_exposure_rural
gen wtd_births_total  =wtd_births_urban   + wtd_births_rural

* The unadjusted rates were calculated earlier but it is ok to re-do them here
foreach li in urban rural total {
gen rate_`li'=1000*births_`li'/exposure_`li'
gen wtd_rate_`li'=1000*wtd_births_`li'/wtd_exposure_`li'
}

list *urban, table clean
list *rural, table clean
list *total, table clean

list *rate_urban *rate_rural *rate_total, table clean

save "$resultspath//table_5pt1_age_10to14.dta", replace
export excel *rate_urban *rate_rural *rate_total using "$resultspath//FE_tables.xlsx", sheet("Table 5.1_age_10to14") sheetreplace firstrow(var)

end

**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************
* Execution begins here

* Specify workspace
cd "$workingpath"

* srun is a counter for the run, helpful for saving the results
scalar srun=1

main
make_table_5pt1_age_10to14

erase "$resultspath//IRtemp.dta"
erase "$resultspath//exposure_and_births.dta"
program drop _all
