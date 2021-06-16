/*******************************************************************************************************************************
Program: 				CHmain.do
Purpose: 				Main file for the Child Health Chapter. 
						The main file will call other do files that will produce the CH indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf	
Date last modified:		May 14 2019 by Shireen Assaf

*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*local user 39585	//change employee id number to personalize path
local user 33697
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap10_CH"

global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* KR Files
global krdata "UGKR7AFL"
* MMKR71FL TJKR70FL GHKR72FL UGKR7AFL

* IR Files
global irdata "UGIR7AFL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL
****************************

* KR file variables

* open dataset
use "$datapath//$krdata.dta", clear

gen file=substr("$krdata", 3, 2)

*** Child's age ***
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
**************************
	
do CH_SIZE.do
*Purpose: 	Code child size indicators

do CH_ARI_FV.do
*Purpose: 	Code ARI indicators

do CH_DIAR.do
*Purpose: 	Code diarrhea indicators

do CH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

do CH_VAC.do
*Purpose: 	Code vaccination indicators
*Note: This do file drops children that are not in a specific age group. 

do CH_tables_vac.do
*Purpose: 	Produce tables for vaccination indicators.

do CH_STOOL.do
*Purpose:	Safe disposal of stool
*Notes:				This do file will drop cases. 
*					This is because the denominator is the youngest child under age 2 living with the mother. 			
*					The do file will also produce the tables for these indicators. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do CH_KNOW_ORS.do
*Purpose: 	Code knowledge of ORS

do CH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 
* Note:		This will drop any women not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

