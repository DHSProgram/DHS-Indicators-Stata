/*******************************************************************************************************************************
Program: 				FEmaster.do
Purpose: 				Master file for the Fertility Chapter. 
						The master file will call other do files that will produce the FE indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				
Date last modified:		

*******************************************************************************************************************************/

*local user 39585	//change employee id number to personalize path
local user 33697
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/ShareCodeProject/Chap5_FP"

global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "UGIR7AFL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL

global brdata "UGBR7AFL"
* MMBR71FL TJBR70FL GHBR72FL UGBR7AFL
****************************

** Courtney I think some of these do files can be combined. Tom's code i believe produces the ASFR and GFR in the same code for example

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do FE_ASFR.do
*Purpose: 	Code age-specific fertility rates

do FE_GFR.do
*Purpose: 	Code general fertilty rate

do FE_ASFRT.do
*Purpose: 	Code age-specific fertility rates

do FE_BIRTHS.do
*Purpose: 	Code risky birth related indicators.

do FE_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
