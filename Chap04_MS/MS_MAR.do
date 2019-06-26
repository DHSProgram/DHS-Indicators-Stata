/********************************************************************
*Program: 				Medians - Age at first marriage and birth.do
*Purpose: 				computes age at first marriage and first birth
*Data inputs: 			IR files
*Data outputs:			none 
						Run the code all way to the end will scalars that store estimates
*Date last modified: 	October 2018 by Courtney Allen (original by Tom Pullum) for making subgroups
**********************************************************************/
clear all
* Before you start - change the data path at the bottom of do file

* Calculation of median age at first marriage and at first birth

set more off

local subgroup

*******************************************************
program define calc_median_age

local subgroup evermar wealth edu urbrur

foreach y in `subgroup' {
	levelsof `y', local(`y'lv)
	foreach x of local `y'lv {
	
local beg_age 25 //set lower bound
local end_age 49 //set upper age bound

summarize age [fweight=v005] if v012>=`beg_age' & v012<=`end_age' & `y'==`x', detail

scalar sp50=r(p50)

gen dummy=.
replace dummy=0 if v012>=`beg_age' & v012<=`end_age' & `y'==`x'
replace dummy=1 if v012>=`beg_age' & v012<=`end_age' & `y'==`x' & age<sp50 
summarize dummy [fweight=v005]
scalar sL=r(mean)

replace dummy=.
replace dummy=0 if v012>=`beg_age' & v012<=`end_age' &`y'==`x'
replace dummy=1 if v012>=`beg_age' & v012<=`end_age' & `y'==`x' & age<=sp50
summarize dummy [fweight=v005]
scalar sU=r(mean)
drop dummy

scalar smedian=round(sp50+(.5-sL)/(sU-sL),.01)
scalar list sp50 sL sU smedian


* warning if sL and sU are miscalculated
if sL>.5 | sU<.5 {
*ERROR IN CALCULATION OF L AND/OR U
}

*label all scalars with subgroup and level. Use variable first to decide whether it's first marraige (afm) or first birth (afb)
if first == 1 {
scalar safm_`y'`x'=smedian
} 
else {
scalar safb_`y'`x'=smedian
}

}
}
drop age
drop first

end

*******************************************************
*******************************************************
*******************************************************
*******************************************************
*******************************************************
*******************************************************
* EXECUTION BEGINS HERE

* sp50 is the integer-valued median produced by summarize, detail;
*   what we need is an interpolated or fractional value of the median.

* In the program, "age" is reset as age at first cohabitation or age at first birth;
*   with modifications, other possibilities would require modifications.

* sL and sU are the cumulative values of the distribution that straddle the integer-valued median

* v011 date of woman's birth (cmc)
* v211 date of first child's birth (cmc)
* v511 age at first cohabitation 

set maxvar 10000
cd "C:\Users\39585\Desktop\Complex Indicator Workshop Stata"
use IDIR63FL.dta, clear

*make subgroups here*****

*make evermarried group
gen evermar = .
replace evermar = 1 if v502!=0

*wealth, education, urban/rural
gen wealth = v190
gen edu = v149
gen urbrur = v025


* age at first marriage calculated from v511
gen afm=v511
replace afm=99 if v511==. 
gen age=afm
gen first = 1 //this variable helps label scalars at the end for marraige or birth
calc_median_age


*age at first birth
gen afb=int((v211-v011)/12)
replace afb=99 if v211==. 
gen age=afb
gen first = 2
calc_median_age
scalar safb_median=smedian


scalar list







