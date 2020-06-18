/*******************************************************************************************************************************
Program: 				NTmain.do
Purpose: 				Main file for the Nutrition Chapter. 
						The main file will call other do files that will produce the NT indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		

*******************************************************************************************************************************/
set more off

*local user 39585	//change employee id number to personalize path
local user 39585
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap11_NT"

global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* KR Files
global krdata "TJKR71FL"
* MMKR71FL TJKR70FL GHKR72FL TLKR71FL 

global prdata "TJPR71FL"
* MMPR71FL TJPR70FL GHPR72FL TLPR71FL 

* IR Files
global irdata "TJIR71FL"
* MMIR71FL TJIR70FL GHIR72FL TLIR71FL 

* MR Files
global mrdata "TJMR71FL"
* MMMR71FL TJMR70FL GHMR72FL TLMR71FL 

* HR Files
global hrdata "TJHR71FL"
* MMHR71FL TJHR70FL GHHR72FL TLHR71FL  
****************************

* KR file variables

* Note: For the NT_MICRO do file, you need to merge the KR with the HR file. 
* The merge will be performed before running any of the do files below. 

use "$datapath//$hrdata.dta", clear
rename (hv001 hv002) (v001 v002)
keep v001 v002 hv234a
save temp.dta, replace
* open KR dataset
use "$datapath//$krdata.dta", clear
merge m:1 v001 v002 using temp.dta
keep if _merge==3

gen file=substr("$krdata", 3, 2)

label define yesno 0"No" 1"Yes"

**** child's age ****
gen age = v008 - b3
	
	* to check if survey has b19, which should be used instead to compute age. 
	scalar b19_included=1
		capture confirm numeric variable b19, exact 
		if _rc>0 {
		* b19 is not present
		scalar b19_included=0
		}
		if _rc==0 {
		* b19 is present; check for values
		summarize b19
		  if r(sd)==0 | r(sd)==. {
		  scalar b19_included=0
		  }
		}

	if b19_included==1 {
	drop age
	gen age=b19
	}

*******************
*/
do NT_BRST_FED.do
*Purpose: 	Code breastfeeding indicators
*
do NT_CH_MICRO.do
*Purpose: 	Code micronutrient indicators

do NT_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

* Note: The following do files select for the youngest child under 2 years living with the mother. Therefore some cases will be dropped. 

* Selecting for youngest child under 24 months and living with mother
keep if age < 24 & b9 == 0
* if caseid is the same as the prior case, then not the last born
keep if _n == 1 | caseid != caseid[_n-1]

do NT_IYCF
*Purpose: 			Code to compute infant and child feeding indicators

do NT_tables2.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
/* PR file variables

* open dataset
use "$datapath//$prdata.dta", clear

gen file=substr("$prdata", 3, 2)

do NT_CH_NUT.do
*Purpose: 	Code child's anthropometry indicators

do NT_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

/* HR file variables

* open dataset
use "$datapath//$hrdata.dta", clear

gen file=substr("$hrdata", 3, 2)

do NT_SALT.do
*Purpose: 	Code salt indicators

do NT_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

/* IR file variables

* A merge with the HR file is required to compute one of the indicators. 

use "$datapath//$hrdata.dta", clear
rename (hv001 hv002) (v001 v002)
keep v001 v002 hv234a
save temp.dta, replace
* open IR dataset
use "$datapath//$irdata.dta", clear
merge m:1 v001 v002 using temp.dta
keep if _merge==3
gen file=substr("$irdata", 3, 2)

do NT_WM_NUT.do
*Purpose: 	Code women's anthropometric indicators

do NT_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

/* MR file variables

* A merge with the PR file is required to compute the indicators below.

use "$datapath//$prdata.dta", clear
rename (hv001 hv002 hvidx) (mv001 mv002 mv003)
keep mv001 mv002 mv003 hv042 hb55 hb56 hb57 hb40 hv103
save temp.dta, replace
* open MR dataset
use "$datapath//$mrdata.dta", clear
merge 1:1 mv001 mv002 mv003 using temp.dta
* only keep merged cases
keep if _merge==3

gen file=substr("$mrdata", 3, 2)

do NT_MN_NUT.do
*Purpose: 	Code men's anthropometric indicators

do NT_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/

*******************************************************************************************************************************
*******************************************************************************************************************************

cap erase temp.dta