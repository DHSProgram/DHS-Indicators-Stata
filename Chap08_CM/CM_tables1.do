/*****************************************************************************************************
Program: 			CM_tables1.do
Purpose: 			produce tables for child mortality and perinatal mortality
Author:				Shireen Assaf
Date last modified: April 30, 2019 by Shireen Assaf 

*Note this do file will produce the following tables in excel:
	1. 	Tables_child_mort:	Contains the child mortality tables (Tables 1-3 in Chapter 8). See Table variable for the table number. 	
	2. 	Tables_PMR:			Contains the tables perinatal mortality. You need to multiply the rates in the tables by 10 to get the correct rate. 
*****************************************************************************************************/

**************************************************************************************************
* Child mortality tables: excel file Tables_child_mort will be produced
**************************************************************************************************
local svry=substr("$irdata", 1, 2)+substr("$irdata", 5, 2)

*open mortality data file produced by CM_CHILD.do file. This file also contains confidence intervals. 
use "`svry'_mortality_rates_with_ci.dta", clear

keep covariate label value lw uw NNMR PNNMR IMR CMR U5MR

gen refperiod=string(-1*uw)+"-"+string(-1*lw)

gen Table=.
replace Table=1 if covariate=="All" & refperiod!="0-9"
replace Table=2 if covariate=="child_sex" | covariate=="v025" 
replace Table=3 if Table==.

gen uw2=-1*uw
sort Table covariate value uw2
drop uw2 lw uw

export excel "Tables_child_mort.xlsx" , firstrow(var) replace

**************************************************************************************************
* Perinatal mortality: 
**************************************************************************************************
* open PMR data file produced by CM_PMR.do file
use CM_PMRdata.dta, clear

gen wt=v005/1000000

*mother's age at birth
tab mo_age_at_birth cm_peri [iw=wt], row nofreq 

*residence
tab v025 cm_peri [iw=wt], row nofreq 

*region
tab v024 cm_peri [iw=wt], row nofreq 

*education
tab v106 cm_peri [iw=wt], row nofreq 

*wealth
tab v190 cm_peri [iw=wt], row nofreq 

* output to excel
tabout mo_age_at_birth v025 v106 v024 v190 cm_peri using Tables_PMR.xls [iw=wt] , c(row) f(1) replace 

**************************************************************************************************
