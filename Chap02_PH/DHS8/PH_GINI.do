/*****************************************************************************************************
Program: 			PH_GINI.do - no changes in DHS8
Purpose: 			Code to compute the Gini coefficient
Data inputs: 		PR dataset
Data outputs:		coded variables
Author:				Tom Pullum, modified by Shireen Assaf for this project
Date last modified: May 8, 2020 by Shireen Assaf 
Note:				This program will collapse the data and export the results to a talble called Table_gini.xls. 
					The programs below contain many notes to describe how the Gini coefficient was computed. 

**If you want to add other country specific covariates such as state (ex shstate in NGPR7A survey), add this to lines 158 and 214
*****************************************************************************************************/

program drop _all

program define prepare_data

* Keep one case per household (e.g. hvidx=1 or hv101=1 or hvidx=hv003) in households with at least one de jure member
keep if hv101==1 & hv012>0

*tab hv270 [iweight=hv012*hv005/1000000]
* Distribution of hv270 and n, match the report

* Can construct the wealth quintiles (this will match hv270 exactly), using the de jure total
* xtile quintile=hv271 [pweight=hv012*hv005], nquantiles(5)
* tab quintile [iweight=hv012*hv005/1000000]
* However, use hv270, which is already constructed

* Each household has hv012 de jure members
gen cases=hv012*hv005/1000000

save PR_temp_gini.dta, replace

end

***************************************************************************************

program define calc_gini

* Can get the distribution of the wealth quintiles at this point if desired
* Save however desired
* tab hv270 [iweight=hv012*hv005/1000000]

quietly summarize hv271
scalar min=r(min)
scalar max=r(max)

* The formula in the Guide is incomplete and has unbalanced parentheses: ((hv271-min)/((max-min)/(n-1))+1.
* Instead calculate with "int". Note that these intervals are not percentiles. They are equal-width intervals. 

gen category=1+int(99*(hv271-min)/(max-min))

* The following command would give percentiles but that's not what DHS uses
*xtile category=hv271 [pweight=hv012*hv005], nquantiles(100)

* IMPORTANT! The assets for the household are weighted by hv005 but not multiplied by the number of household members
gen assets=(hv271-min)*hv005/1000000
collapse (sum) cases assets, by(category)

* Note: some categories may be empty; best to renumber them; must be certain they are in sequence
replace category=_n
quietly summarize category
scalar ncats=r(max)

* Can check against Stata routines such as conindex and ineqdeco (not built in; must download); 

total cases assets
matrix B=e(b)

* calculate proportions
gen  cases_prop= cases/B[1,1]
gen assets_prop=assets/B[1,2]

* Calculate the DHS version of the Gini but with proportions rather than difference of cumulative proportions
* for the first factor in the product. 

* Calculate cumulative proportions for cases and assets. 
gen  cases_cumprop= cases_prop     if category==1
gen assets_cumprop=assets_prop     if category==1
gen term=cases_prop*assets_cumprop if category==1

scalar si=2
while si<=ncats {
quietly replace  cases_cumprop= cases_cumprop[si-1]+ cases_prop[si]       if category==si
quietly replace assets_cumprop=  assets_cumprop[si-1]+assets_prop[si]     if category==si
quietly replace term=cases_prop*(assets_cumprop[si-1]+assets_cumprop[si]) if category==si
*quietly replace term=(cases_cumprop[si]-cases_cumprop[si-1])*(assets_cumprop[si]+assets_cumprop[si-1]) if category==si
scalar si=si+1
}

* term is the base times the mean height (x2) for each trapezoid under the diagonal. The factor of 2 washes out
* because the Gini is defined in terms of half the area in the square, i.e. the area under the diagonal.
* The width or base of each trapezoid is the proportion of the cases in the interval.
* Empty intervals would have no impact on the sum.

total term
matrix B=e(b)
scalar Gini=abs(1-B[1,1])
scalar list Gini

*list, table clear

end

***************************************************************************************

program define save_values

* This routine puts the calculated Gini values into a small data file

clear

local lindex=index

set obs `lindex'
gen survey=survey
gen str8 var="."
gen level=.
gen Gini=.

local li=1
while `li'<=index {
quietly replace var=svar_`li' if _n==`li'
quietly replace level=slevel_`li' if _n==`li'
quietly replace Gini=sGini_`li' if _n==`li'
local li=`li'+1
}

* optional rounding
* quietly replace Gini=round(Gini,.01)

rename var covariate

* optional save
* save.....

end

***************************************************************************************

program define main

prepare_data

* Total
use PR_temp_gini.dta, clear
calc_gini
scalar svar_1="Total"
scalar slevel_1=.
scalar sGini_1=Gini

* This loop is unusual because we re-open the data file within the loop, at the end of the loop. 
* Required because of combination of levelsof and collapse; collapse drops the labels.
* index is a counter for the rows of table 2.6. The total is calculated first but appears at the bottom.
scalar index=1
* Categories of covariates
* You will want to link to category labels
local lvars "hv024 hv025"
*local lvars "hv025 hv024"
use PR_temp_gini.dta, clear
foreach lvar of local lvars {
scalar svar="`lvar'"
levelsof `lvar', local(levels)
  foreach level of local levels {
  scalar index=index+1
  local li=index
  scalar slevel=`level'
  keep if `lvar'==`level'

********************
  calc_gini
********************

  scalar svar_`li'=svar
  scalar slevel_`li'=slevel
  scalar sGini_`li'=Gini
  scalar list svar slevel Gini
  use PR_temp_gini.dta, clear
  }
}

save_values

end

***************************************************************************************
***************************************************************************************

* EXECUTION BEGINS HERE

set more off

* It can happen that the hh head (hv101=1) is not de jure and it can happen that no one in the household
* is de jure (hv012=0)

* cases  is like the number of people in a wealth category   
* assets is like the amount of wealth in that wealth category 
* category is a categorization of cases, ordered by wealth; could be quintiles or deciles or percentiles.
* In the DHS calculation for Table 2.6 the full range of hv271 scores is broken into 100 intervals that
* have equal width but do not include equal numbers of cases, i.e. they are not percentiles.
* It can happen that some intervals are empty, especially for sub populations, but this would not affect the calculation.
* The categories could be numbered low to high or high to low. Makes no difference, except in the sign of the coefficient,
* and we always take the absolute value of the coefficient.

* This version uses the PR file but then reduces to just the household head and multiplies the weight by hv012.

* The "keep" line is outside the subprograms because it must include any special identifiers for regions in Table 2.6

use "$datapath//$prdata.dta", clear
scalar survey=substr("$prdata",1,2)+substr("$prdata",5,2)
scalar list survey
*label list HV024
*label list SHSTATE
keep hv005 hv012 hv024 hv025 hv101 hv270 hv271

quietly main

***************************************************************************************
***************************************************************************************

* Exporting results

* Show results
list, table clean noobs

*output to excel
export excel using Table_gini.xls, firstrow(variables) keepcellfmt replace 

*erase temporary file
erase PR_temp_gini.dta