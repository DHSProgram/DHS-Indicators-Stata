/*******************************************************************************************************************************
Program: 				FPmaster.do
Purpose: 				Master file for the Family Planning Chapter. 
						The master file will call other do files that will produce the FP indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf 
Date last modified:		June 20 by Courtney Allen to add discontinuation section

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
global irdata "UGIR60FL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL

* MR Files
global mrdata "UGMR60FL"
* MMMR71FL TJMR70FL GHMR72FL UGMR7AFL
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
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* Discontinuation rates - need IR file

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do FP_EVENTS.do
* Purpose: 	Create an event file where the episode of contraceptive use is the unit of analysis.

do FP_DISCONT.do
* Purpose: 	Code discontinuation variables (discontinuaution rates and reasons for discontinuation) and create discontinuation tables

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
