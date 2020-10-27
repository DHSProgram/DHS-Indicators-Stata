/*****************************************************************************************************
Program: 			CM_tables1.do
Purpose: 			produce tables for child mortality and perinatal mortality
Author:				Shireen Assaf
Date last modified: April 30, 2019 by Shireen Assaf 

*Note this do file will produce the following tables in excel:
	1. 	Tables_child_mort:	Contains the child mortality tables (Tables 1-3 in Chapter 8). See Table variable for the table number. 	
	2. 	Tables_PMR:			Contains the tables for number of stillbirths, number of early neonatal deaths, and perinatal mortality rate. 
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
* Stillbirths, early neonatal deaths, and perinatal mortality
**************************************************************************************************
* open PMR data file produced by CM_PMR.do file
use CM_PMRdata.dta, clear

gen wt=v005/1000000
svyset v001 [pw=wt], strata(v023) singleunit(centered)  //this is needed to show the perinatal as a rate
**************************************************************************************************
//Stillbirths, tables are for the number of stillbirths

*mother's age at birth
tab mo_age_at_birth stillbirths [iw=wt]

*prenancy interval
tab preg_interval stillbirths [iw=wt]

*residence
tab v025 stillbirths [iw=wt]

*region
tab v024 stillbirths [iw=wt]

*education
tab v106 stillbirths [iw=wt]

*wealth
tab v190 stillbirths [iw=wt]

* output to excel, only showing the number of stillbirths
tabout mo_age_at_birth preg_interval v025 v106 v024 v190 stillbirths using Tables_PMR.xls [iw=wt] , c(freq) f(0) replace 
**************************************************************************************************

//Early neonatal deaths, tables are for the number of early neonatal deaths

*mother's age at birth
tab mo_age_at_birth earlyneonatal [iw=wt]

*prenancy interval
tab preg_interval earlyneonatal [iw=wt]

*residence
tab v025 earlyneonatal [iw=wt]

*region
tab v024 earlyneonatal [iw=wt]

*education
tab v106 earlyneonatal [iw=wt]

*wealth
tab v190 earlyneonatal [iw=wt]

* output to excel, only showing the number of early neonatal deaths
tabout mo_age_at_birth preg_interval v025 v106 v024 v190 earlyneonatal using Tables_PMR.xls [iw=wt] , c(freq) f(0) append 

**************************************************************************************************
// Perinatal mortality rate per 1000

*mother's age at birth
svy: mean cm_peri, over(mo_age_at_birth) 

*prenancy interval
tab preg_interval cm_peri [iw=wt], row nofreq 
svy: mean cm_peri, over(preg_interval) 

*residence
tab v025 cm_peri [iw=wt], row nofreq 
svy: mean cm_peri, over(v025) 

*region
tab v024 cm_peri [iw=wt], row nofreq 
svy: mean cm_peri, over(v024) 

*education
tab v106 cm_peri [iw=wt], row nofreq 
svy: mean cm_peri, over(v106) 

*wealth
tab v190 cm_peri [iw=wt], row nofreq 
svy: mean cm_peri, over(v190) 

* output to excel
tabout mo_age_at_birth preg_interval v025 v106 v024 v190 using Tables_PMR.xls [aw=wt], oneway c(mean cm_peri) f(0) sum append
**************************************************************************************************
