/*******************************************************************************************************************************
Program: 				NTmaster.do
Purpose: 				Master file for the Nutrition Chapter. 
						The master file will call other do files that will produce the NT indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				
Date last modified:		

*******************************************************************************************************************************/

*local user 39585	//change employee id number to personalize path
local user 33697
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap11_FP"

global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* KR Files
global krdata "UGKR7AFL"
* MMKR71FL TJKR70FL GHKR72FL UGKR7AFL

global prdata "UGPR7AFL"
* MMPR71FL TJPR70FL GHPR72FL UGPR7AFL

* IR Files
global irdata "UGIR7AFL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL

* MR Files
global mrdata "UGMR7AFL"
* MMMR71FL TJMR70FL GHMR72FL UGMR7AFL

* HR Files
global hrdata "UGHR7AFL"
* MMHR71FL TJHR70FL GHHR72FL UGHR7AFL
****************************

* KR file variables

* open dataset
use "$datapath//$krdata.dta", clear

gen file=substr("$krdata", 3, 2)

do NT_BRST_FED.do
*Purpose: 	Code breastfeeding indicators

do NT_MICRO_ch.do
*Purpose: 	Code micronutrient indicators

do NT_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
* PR file variables

* open dataset
use "$datapath//$prdata.dta", clear

gen file=substr("$prdata", 3, 2)

do NT_NUT_ch.do
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

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

do NT_NUT_mn.do
*Purpose: 	Code men's anthropometric indicators

do NT_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do NT_NUT_wn.do
*Purpose: 	Code women's anthropometric indicators

do NT_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

