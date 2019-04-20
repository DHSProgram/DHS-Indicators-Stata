/*******************************************************************************************************************************
Program: 				FPmaster.do
Purpose: 				Master file for the Family Planning Chapter. 
						The master file will call other do files that will produce the FP indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf 
Date last modified:		Jan 31 by Shireen Assaf

Notes:					Indicators for men only cover knowledge of contraceptive methods and exposure to family planning messages.
*******************************************************************************************************************************/

*local user 39585	//change employee id number to personalize path
local user 33697
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/ShareCodeProject/Chap7_FP"

global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "UGIR7AFL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL

* MR Files
global mrdata "UGMR7AFL"
* MMMR71FL TJMR70FL GHMR72FL UGMR7AFL
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)
gen srvy=substr("$irdata", 1, 6)

do FP_KNOW.do
*Purpose: 	Code contraceptive knowledge variables

do FP_USE.do
*Purpose: 	Code contraceptive use variables (ever use and current use)

do FP_DISCONT.do
*Purpose: 	Code discontinuation variables (discontinuaution rates and reasons for discontinuation)

do FP_NEED.do
*Purpose: 	Code contraceptive unmet need, met need, demand satisfied, intention to use

do FP_COMM.do
*Purpose: 	Code communication related indicators: exposure to FP messages, decision on use/nonuse, discussions. 

do FP_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

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

