/*******************************************************************************************************************************
Program: 				CMmaster.do
Purpose: 				Master file for the Child Mortality Chapter. 
						The master file will call other do files that will produce the CM indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				
Date last modified:		

*******************************************************************************************************************************/

*local user 39585	//change employee id number to personalize path
global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/ShareCodeProject/Chap8_CM"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "UGIR7AFL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL

global brdata "UGBR7AFL"
* MMBR71FL TJBR70FL GHBR72FL UGBR7AFL
****************************

* IR file variables

*do CM_CHILD.do
*Purpose: 	Code child mortality indicators
*Code contains programs that will produce an excel file and data file with the mortality rates overall and by background variables with confidence interals
*The outputs will be manipulated to produce tables that match the tables in the reports.  

* open dataset
use "$datapath//$irdata.dta", clear

do CM_PMR.do
*Purpose: 	Code perinatal mortality

*do CM_RISK_births.do
*Purpose: 	Code high risk birth indicators

*do CM_RISK_wm.do
*Purpose: 	Code high risk pregnancy indicators

*do CM_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

/* BR file variables

* open dataset
use "$datapath//$brdata.dta", clear

gen file=substr("$brdata", 3, 2)


*/
*******************************************************************************************************************************
*******************************************************************************************************************************

