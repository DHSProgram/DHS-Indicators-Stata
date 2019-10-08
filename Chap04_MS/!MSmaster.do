/*******************************************************************************************************************************
Program: 				MSmaster.do
Purpose: 				Master file for the Marriage and Sexual Activity Chapter. 
						The master file will call other do files that will produce the MS indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Courtney Allen
Date last modified:		September 24, 2019

*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust change paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697

* change working path
cd "C:/Users/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap04_MS"

* change data path
global datapath "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "GHIR72FL"

global mrdata "GHMR71FL"
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

*
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

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

