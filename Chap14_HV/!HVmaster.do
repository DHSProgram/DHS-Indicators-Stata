/*******************************************************************************************************************************
Program: 				HVmaster.do
Purpose: 				Master file for HIV Prevalence
						The master file will call other do files that will produce the HV indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		November 5 28, 2019 by Shireen Assaf
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap14_HV"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "MWIR7AFL"
*GHIR72FL 

*MR files
global mrdata "MWMR7AFL"
*GHMR72FL

*CR files
global crdata "MWCR7AFL"
*GHMR72FL

*PR files
global prdata "MWPR7AFL"
*GHPR72FL

*AR files - files with HIV test results
global ardata "MWAR7AFL"
*GHAR72FL
****************************

/* PR file variables

* merge AR file to PR file
use "$datapath//$ardata.dta", clear
rename (hivclust hivnumb hivline) (hv001 hv002 hvidx)
save temp.dta, replace
* open PR dataset
use "$datapath//$prdata.dta", clear
merge 1:1 hv001 hv002 hvidx using temp.dta

gen file=substr("$prdata", 3, 2)

do HV_TEST_COVG.do
*Purpose: 	Code to compute HIV testing status

do HV_tables.do
*Purpose: 	Produce tables for indicators computed from the above do file.

*/
*******************************************************************************************************************************

* IR, MR, AR file

* A merge of the IR and MR files with the AR file is needed to produce the Total HIV prevalence and present them by background variables present in the IR and MR files
* The following merge sequence will produce an IRMRARmerge.dta file for the survey of interest

* merge AR file to IR file
use "$datapath//$ardata.dta", clear
rename (hivclust hivnumb hivline) (v001 v002 v003)
save temp.dta, replace
use "$datapath//$irdata.dta", clear
merge 1:1 v001 v002 v003 using temp.dta
gen sex=2
rename _merge IRmerge
keep if IRmerge==3
save IRARtemp.dta, replace

* merge AR file to MR file
use "$datapath//$ardata.dta", clear
rename (hivclust hivnumb hivline) (mv001 mv002 mv003)
save temp.dta, replace
use "$datapath//$mrdata.dta", clear
merge 1:1 mv001 mv002 mv003 using temp.dta
gen sex=1
rename _merge MRmerge
keep if MRmerge==3
save MRARtemp.dta, replace

* append IRARtemp and MRARtemp
use MRARtemp.dta, clear
*IMPORTANT! we are renaming all mv* variables to v* variables. 
rename mv* v*
append using IRARtemp.dta
label define sex 1 "man" 2 "woman"
label values sex sex
save IRMRARmerge.dta, replace

*erase the temporary files. Comment out if you would like to keep these merged files. 
erase IRARtemp.dta
erase MRARtemp.dta
erase temp.dta

* limiting to age 15-49, you can comment this out if you want all men
drop if v012>49

gen file=substr("$mrdata", 3, 2)

do HV_PREV.do
*Purpose: 	Code for HIV prevalence

do HV_CIRCUM.do
*Purpose:	Code for HIV prevalence by circumcision indicators

do HV_backgroundvars.do
*Purpose:	Code the background variables needed for the HV_tables


save IRMRARmerge.dta, replace

*do HV_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.

* erase merged file. Comment out if you would like to keep this file
*erase IRMRARmerge.dta

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

/* CR file variables

* merge CR and AR files
use "$datapath//$ardata.dta", clear
rename (hivclust hivnumb hivline hiv03) (v001 v002 v003 w_hiv03)
keep v001 v002 v003 w_hiv03 hiv05
sort v001 v002 v003
save w_temp.dta, replace

use "$datapath//$ardata.dta", clear
rename (hivclust hivnumb hivline hiv03) (mv001 mv002 mv003 m_hiv03)
keep mv001 mv002 mv003 m_hiv03
sort mv001 mv002 mv003
save m_temp.dta, replace

use "$datapath//$crdata.dta", clear
sort v001 v002 v003
merge v001 v002 v003 using w_temp.dta
keep if _merge ==3
rename _merge w_merge
sort mv001 mv002 mv003
merge mv001 mv002 mv003 using m_temp.dta
keep if _merge ==3
rename _merge m_merge

gen file=substr("$crdata", 3, 2)

do HV_PREV.do
*Purpose: 	Code for HIV prevalence among couples

do HV_tables.do
*Purpose: 	Produce tables for indicators computed from the above do file.

* erase temporary files
erase w_temp.dta
erase m_temp.dta

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
