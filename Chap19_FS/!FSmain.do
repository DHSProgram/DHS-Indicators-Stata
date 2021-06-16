/*******************************************************************************************************************************
Program: 				FSmain.do
Purpose: 				Main file for the Fistula Chapter. 
						The main file will call other do files that will produce the FS indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		October 22, 2020 by Shireen Assaf
Note:					This Chapter is a module and not part of the core questionnaire. 
						Please check if the survey you are interested in has included this module in the survey. 
						
						IMPORTANT!
						The variables for this chapter are not standardized and you would need to search for the variable names used in the survey of interest. 
						The Afghanistan 2015 survey was used in the code. 
						The FS_FIST.do file contains notes on how to find the correct variables according the variable labels. The same code can then be used for the survey. 
						
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*change employee id number to personalize path
global user 33697

*working directory
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap19_FS"

*data path where data files are stored
global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"


* select your survey

* IR Files
global irdata "AFIR71FL"


*******************************************************************************************************************************
*******************************************************************************************************************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do FS_FIST.do
*Purpose: 	Calculate fistula indicators among women

do FS_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.
* Note:		This will drop any women not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
