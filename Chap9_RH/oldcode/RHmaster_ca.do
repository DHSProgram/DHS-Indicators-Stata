/*******************************************************************************************************************************
Program: 				Chap9_RHmaster.do
Purpose: 				Master file for the Reporductive Health Chapter. 
						The master file will call other do files that will produce the RH indicators and produce tables.
Data outputs:			coded variables and table output on screen. There will be no saved data files or output to excel. 
Author: 				Shireen Assaf 
Date last modified:		Jan 9th by Shireen Assaf
Notes:					
*******************************************************************************************************************************/

*local user 39585	//change employee id number to personalize path
local user 33697
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/ShareCodeProject/Chap9_RH"

global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "GHIR72FL"
* MMIR71FL TJIR70FL
* KR Files
global brdata "GHBR72FL"
* MMBR71FL TJIR70FL
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do "RH_age_period.do" 
*Purpose:	Compute the age variable and set the period for the analysis. Period currently set at 5 years.

*
do RH_ANC.do
*Purpose: 	Code ANC indicators

*
*do RH_PNC_wm.do
*Purpose: 	Code PNC indicators for women 

*
do RH_Probs.do
*Purpose: 	Code indicators for problems accessing health care 

*
do RH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. This will output 3 excel files for these indicators.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

/* BR file variables

* open dataset
use "$datapath//$brdata.dta", clear

gen file=substr("$brdata", 3, 2)

do "RH_age_period.do" 
*Purpose:	Compute the age variable and set the period for the analysis. Period currently set at 5 years.

*
do RH_DEL.do
*Purpose: 	Code Delivery indicators

*
*do RH_PNC_nb.do
*Purpose: 	Code PNC indicators for newborns 

do RH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. This will output 2 excel files for these indicators.


*/
*******************************************************************************************************************************
*******************************************************************************************************************************

