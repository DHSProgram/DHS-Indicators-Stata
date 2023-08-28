/*******************************************************************************************************************************
Program: 				FFmain.do - DHS8 update
Purpose: 				Main file for the Fertility Preferences Chapter. 
						The main file will call other do files that will produce the FF indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		August 28 2023 by Shireen Assaf
						There are no new indictors in DHS8, only the Fertility planning table in the FF_PLAN.do file has been updated for DHS8. 
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap06_FF/DHS8"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "KHIR81FL"

* MR Files
global mrdata "KHMR81FL"
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do FF_PREF.do
*Purpose: 	Code desire for children and ideal number of children for women

do FF_tables.do
*Purpose: 	Produce tables for indicators computed from FF_PREF.do file. 
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

do FF_PLAN.do
*Purpose: 	Code fertility planning status indicator and produce table Table_FFplan

do FF_WANT_TFR.do
*Purpose: 	Code wanted fertility and produces table Table_WANT_TFR.xls to match the final report. 
			* Important note: you will also need to change the paths in this program. See the notes in the do file. 

*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

do FF_PREF.do
*Purpose: 	Code desire for children and ideal number of children for men

do FF_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

