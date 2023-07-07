/*******************************************************************************************************************************
Program: 				HKmain.do - DHS8 update
Purpose: 				Main file for the HIV-AIDS Related Knowledge, Attitudes, and Behaviors . 
						The main file will call other do files that will produce the HK indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		July 5, 2023 by Shireen Assaf
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap13_HK/DHS8"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "KHIR81FL"

* MR Files
global mrdata "KHMR81FL"
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do HK_KNW_ATD.do
*Purpose: 	Code to compute HIV-AIDS related knowledge and attitude indicators 
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do HK_RSKY_BHV.do
*Purpose: 	Code to compute Multiple Sexual Partners, Higher-Risk Sexual Partners, and Condom Use
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do HK_TEST_CONSL.do
*Purpose: 	Code for indicators on HIV prior testing and counseling 
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do HK_STI.do
*Purpose: 	Code for STI indicators
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do HK_BHV_YNG.do
*Purpose: 	Code for sexual behaviors among young people
*Note:		The do file focuses on young people. 

do HK_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.


*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

do HK_KNW_ATD.do
*Purpose: 	Code to compute HIV-AIDS related knowledge and attitude indicators 
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do HK_RSKY_BHV.do
*Purpose: 	Code to compute Multiple Sexual Partners, Higher-Risk Sexual Partners, and Condom Use
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do HK_TEST_CONSL.do
*Purpose: 	Code for indicators on HIV prior testing and counseling 
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do HK_CIRCUM.do
*Purpose: 	Code for indicators on male circumcision
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. This do file is only for men. 

do HK_STI.do
*Purpose: 	Code for STI indicators
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do HK_BHV_YNG.do
*Purpose: 	Code for sexual behaviors among young people
*Note:		The do file focuses on young people. 

do HK_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

