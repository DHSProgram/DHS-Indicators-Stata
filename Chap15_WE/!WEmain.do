/*******************************************************************************************************************************
Program: 				WEmain.do
Purpose: 				Main file for the Women's Empowerment Chapter. 
						The main file will call other do files that will produce the WE indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		October 17 2019 by Shireen Assaf
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap15_WE"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "ETIR70FL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7BFL KEIR71FL

global mrdata "ETMR70FL"
* MMMR71FL GHMR72FL UGMR7BFL
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do WE_ASSETS.do
*Purpose: 	Code employment, earnings, and asset ownership for women
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do WE_EMPW.do
*Purpose: 	Code decision making and justification of violence among women
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do WE_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

do WE_ASSETS.do
*Purpose: 	Code employment, earnings, and asset ownership for men
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do WE_EMPW.do
*Purpose: 	Code decision making and justification of violence among men
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do WE_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

