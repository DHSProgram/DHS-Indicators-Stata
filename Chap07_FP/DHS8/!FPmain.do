/*******************************************************************************************************************************
Program: 				FPmain.do
Purpose: 				Main file for the Family Planning Chapter. 
						The main file will call other do files that will produce the FP indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf 
Date last modified:		June 20 by Courtney Allen to add discontinuation section
						October 27, 2022 by Shireen Assaf to add condition for currently married women to run discontinuation code. 

Notes:					Indicators for men only cover knowledge of contraceptive methods and exposure to family planning messages.
						Indicators are coded for all women/all men unless indicated otherwise. 
						In the tables do file you can select other populations of interest (ex: among those currently in a union)
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*local user 39585	//change employee id number to personalize path
local user 33697
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap07_FP"

global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "MRIR71FL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7BFL

* MR Files
global mrdata "MRMR71FL"
* MMMR71FL TJMR70FL GHMR72FL UGMR7BFL
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do FP_KNOW.do
*Purpose: 	Code contraceptive knowledge variables

do FP_USE.do
*Purpose: 	Code contraceptive use variables (ever use and current use)

do FP_NEED.do
* Purpose: 	Code contraceptive unmet need, met need, demand satisfied, intention to use

do FP_COMM.do
* Purpose: 	Code communication related indicators: exposure to FP messages, decision on use/nonuse, discussions. 

do FP_tables.do
* Purpose: 	Produce tables for indicators computed from above do files. 
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.


*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

do FP_KNOW.do
*Purpose: 	Code contraceptive knowledge variables

do FP_COMM.do
*Purpose: 	Code communication related indicators: exposure to FP messages indicators only for men. 

do FP_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* Discontinuation rates - need IR file

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

gen cntry=substr("$irdata", 1, 2)

*For some surveys (example Mauritania DHS 2019-2021), the discontinuation estimates are only for currently married women. 
*The estimates can only be produced if we keep currently married women. 

	if cntry=="MR"{
	keep if v502==1
	}

do FP_EVENTS.do
* Purpose: 	Create an event file where the episode of contraceptive use is the unit of analysis.

do FP_DISCONT.do
* Purpose: 	Code discontinuation variables (discontinuaution rates and reasons for discontinuation) and create discontinuation tables
* Note: This do file will create the discontinuation results table Tables_Discont_12m.xlsx and a Stata dataset eventsfile.dta for the survey. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
