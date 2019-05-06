/*******************************************************************************************************************************
Program: 				CHmaster.do
Purpose: 				Master file for the Child Health Chapter. 
						The master file will call other do files that will produce the CH indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				
Date last modified:		

*******************************************************************************************************************************/

*local user 39585	//change employee id number to personalize path
local user 33697
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap10_CH"

global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* KR Files
global krdata "UGKR7AFL"
* MMKR71FL TJKR70FL GHKR72FL UGKR7AFL

global irdata "UGIR7AFL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL
****************************

* KR file variables

* open dataset
use "$datapath//$krdata.dta", clear

gen file=substr("$krdata", 3, 2)
gen srvy=substr("$krdata", 1, 6)

do CH_SIZE.do
*Purpose: 	Code child size indicators

do CH_VAC.do
*Purpose: 	Code vaccination indicators

do CH_ARI_FV.do
*Purpose: 	Code ARI indicators

do CH_DIAR.do
*Purpose: 	Code diarrhea indicators

*do CH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* IR file variables

/* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do CH_KNOW_ORS.do
*Purpose: 	Code knowledge of ORS

*do CH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

