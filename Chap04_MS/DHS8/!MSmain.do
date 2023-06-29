/*******************************************************************************************************************************
Program: 				MSmain.do - DHS8 update
Purpose: 				Main file for the Marriage and Sexual Activity Chapter. 
						The main file will call other do files that will produce the MS indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Courtney Allen
Date last modified:		June 29, 2023 by Shireen Assaf

*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
local user 33697

* change working path
cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap04_MS/DHS8"

* change data path
global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

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

*Purpose: 	Code marital status variables
cap program drop calc_median_age
do MS_MAR.do

*Purpose: 	Code sexual activity variables
cap program drop calc_median_age
do MS_SEX.do

*Purpose: 	Produce tables for indicators computed from above do files. 
do MS_tables.do

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

cap program drop calc_median_age
do MS_MAR.do
*Purpose: 	Code marital status variables

cap program drop calc_median_age
do MS_SEX.do
*Purpose: 	Code sexual activity variables

do MS_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

