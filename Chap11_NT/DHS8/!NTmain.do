/*******************************************************************************************************************************
Program: 				NTmain.do
Purpose: 				Main file for the Nutrition Chapter - DHS8 update
						The main file will call other do files that will produce the NT indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf and Courtney Allen
Date last modified:		November 2, 2022

*******************************************************************************************************************************/
set more off

global user 33697

cd "C:/Users//$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap11_NT"

*global datapath "C:/Users/$user//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* KR Files
global krdata "CIKR80FL"

* PR Files
global prdata "CIPR80FL"

* IR Files
global irdata "CIIR80FL"

* MR Files
global mrdata "CIMR80FL"

* HR Files
global hrdata "CIHR80FL" 
****************************

* KR file variables

* open KR dataset
use "$datapath//$krdata.dta", clear

gen file=substr("$krdata", 3, 2)
	
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
do NT_CH_GWTH.do
*Purpose: 	Code child growth monitoring indicators

do NT_CH_MICRO.do
*Purpose: 	Code micronutrient indicators

do NT_BF_INIT.do
*PUrpose:   Code initial breastfeeding indicators

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


*******************************************************************************************************************************
*******************************************************************************************************************************
* Reopen KR dataset for mean and median breastfeeding indicators

use "$datapath//$krdata.dta", clear
merge m:1 v001 v002 using temp.dta
keep if _merge==3

	* gen substring for country code
	gen cc=substr("$krdata", 1, 2)

	* gen substring for file version
	gen fv=substr("$krdata", 5, 2)

	* gen substring for country code and file version
	gen cc_fv = cc + fv
	

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

do NT_BF_MED.do
*Purpose: 	Code breastfeeding indicators


*/
*******************************************************************************************************************************
*******************************************************************************************************************************
* PR file variables

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

* HR file variables

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

* IR file variables

* open IR dataset
use "$datapath//$irdata.dta", clear

do NT_WM_NUT.do
*Purpose: 	Code women's anthropometric indicators if they are available in the IR File. If not use the PR file. 

do NT_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* A merge with the PR file is required to compute the indicators below.

use "$datapath//$prdata.dta", clear
rename (hv001 hv002 hvidx) (mv001 mv002 mv003)
cap keep mv001 mv002 mv003 hv042 hb* hv103
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
* Note:		This will drop any men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/

*******************************************************************************************************************************
*******************************************************************************************************************************

cap erase temp.dta