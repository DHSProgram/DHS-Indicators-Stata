/*******************************************************************************************************************************
Program: 				RCmain.do
Purpose: 				Main file for the Respondents' Characteristics Chapter. 
						The main file will call other do files that will produce the RC indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		October 1 2019 by Shireen Assaf
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap03_RC"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "ETIR71FL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7BFL KEIR71FL

* MR Files
global mrdata "ETMR71FL"
* MMMR71FL GHMR72FL UGMR7BFL
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do RC_CHAR.do
*Purpose: 	Code respondent characteristic indicators for women
* Note:		This will drop any women over age 49. You can change this selection. Please check the notes in the do file.

do RC_tables.do
*Purpose: 	Produce tables for indicators computed from RC_CHAR.do file. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

do RC_CHAR.do
*Purpose: 	Code respondent characteristic indicators for men
* Note:		This will drop any men over age 49. You can change this selection. Please check the notes in the do file.

do RC_tables.do
*Purpose: 	Produce tables for indicators computed from RC_CHAR.do file. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

