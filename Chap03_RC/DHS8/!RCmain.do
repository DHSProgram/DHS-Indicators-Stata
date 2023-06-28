/*******************************************************************************************************************************
Program: 				RCmain.do - DHS8 update
Purpose: 				Main file for the Respondents' Characteristics Chapter. 
						The main file will call other do files that will produce the RC indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		June 27 2023 by Shireen Assaf
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

global user 33697

cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap03_RC/DHS8"

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

do RC_CHAR.do
*Purpose: 	Code respondent characteristic indicators for women

do RC_tables.do
*Purpose: 	Produce tables for indicators computed from RC_CHAR.do file. 
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

do RC_CHAR.do
*Purpose: 	Code respondent characteristic indicators for men

do RC_tables.do
*Purpose: 	Produce tables for indicators computed from RC_CHAR.do file. 
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

