/*******************************************************************************************************************************
Program: 				MSmaster.do
Purpose: 				Master file for the Marriage and Sexual Activity Chapter. 
						The master file will call other do files that will produce the MS indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				
Date last modified:		

*******************************************************************************************************************************/

*local user 39585	//change employee id number to personalize path
local user 33697
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap4_FP"

global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "UGIR7AFL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL

global mrdata "UGMR7AFL"
* MMMR71FL TJMR70FL GHMR72FL UGMR7AFL
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do MS_MAR.do
*Purpose: 	Code marital status variables

do MS_SEX.do
*Purpose: 	Code sexual activity variables

do MS_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

do MS_MAR.do
*Purpose: 	Code marital status variables

do MS_SEX.do
*Purpose: 	Code sexual activity variables

do MS_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

