/*******************************************************************************************************************************
Program: 				FFmain.do
Purpose: 				Main file for the Fertility Preferences Chapter. 
						The main file will call other do files that will produce the FF indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		June 21 2019 by Shireen Assaf
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap06_FF"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "UGIR60FL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7BFL KEIR71FL

* MR Files
global mrdata "UGMR60FL"
* MMMR71FL TJMR70FL GHMR72FL UGMR7BFL
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do FF_PREF.do
*Purpose: 	Code desire for children and ideal number of children for women

do FF_tables.do
*Purpose: 	Produce tables for indicators computed from FF_PREF.do file. 

do FF_PLAN.do
*Purpose: 	Code fertility planning status indicator and produce table Table_FFplan

do FF_WANT_TFR.do
*Purpose: 	Code wanted fertility and produces table Table_WANT_TFR.do to match the final report. 
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
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

