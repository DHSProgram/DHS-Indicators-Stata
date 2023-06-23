/*******************************************************************************************************************************
Program: 				RHmain.do - DHS8 update
Purpose: 				Main file for the Reporductive Health Chapter. 
						The main file will call other do files that will produce the RH indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.
Author: 				Shireen Assaf 
Date last modified:		Dec 1, 2022 by Shireen Assaf
Note:					In DHS8 we use the NR file which is the pregnancy history file instead of the IR or BR files.				
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

global user 33697

cd "C:/Users/$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap09_RH/DHS8"

global datapath "C:/Users/$user//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey
* NR Files
global nrdata "CINR80FL"

* IR Files
global irdata "CIIR80FL"

* MR Files
global mrdata "CIMR80FL"

****************************

* open dataset
use "$datapath//$nrdata.dta", clear

cap label define yesno 0"No" 1"Yes"

gen file=substr("$nrdata", 3, 2)

*keep if birth if under 24 months and is last live birth or last still birth
keep if p19 < 24 & (m80 == 1 | m80 == 3)

/*! Note: the ANC and PNC indicators have three denominators reported in the DHS Final reports.
To match the livebirths only, tabulate the indicators with the condition m80==1
To match the stillbirths only, tabulate the indicators with the condition m80==3
To match live births and stillbirths, tabulate the indicators with the condition (_n == 1 | caseid != caseid[_n-1]) to keep either the last livebirth or last stillbirth.
For ANC components indicators there is an additional condition to select for women who have had at least one ANC visit or all women. 
*/

*
do RH_ANC.do
*Purpose: 	Code ANC indicators

*
do RH_PNC.do
*Purpose: 	Code PNC indicators for mother and newborn

*
do RH_tables.do
*Purpose: 	Produce tables ANC and PNC indicators computed from above do files. 

**********************************

* reopen NR file to select cases for new denominators
use "$datapath//$nrdata.dta", clear

cap label define yesno 0"No" 1"Yes"

*added "2" for second denominator to identify this in the tables do file. 
gen file=substr("$nrdata", 3, 2) + "2"

*keep if birth if under 24 months and is not a miscarriage or abortion
keep if p19 < 24 & m80 <5
	
*
do RH_DEL.do
*Purpose: 	Code delivery indicators

*
do RH_tables.do
*Purpose: 	Produce tables for delivery indicators computed from above do file. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* open IR dataset
use "$datapath//$irdata.dta", clear

cap label define yesno 0"No" 1"Yes"

gen file=substr("$irdata", 3, 2)

*
do RH_HLTH.do
*Purpose: 	Code indicators on health indicators and problems accessing health care for women

do RH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* open MR dataset
use "$datapath//$mrdata.dta", clear

cap label define yesno 0"No" 1"Yes"

gen file=substr("$mrdata", 3, 2)

*
do RH_MEN.do
*Purpose: 	Code indicators on men's involvement in maternal health care

do RH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
