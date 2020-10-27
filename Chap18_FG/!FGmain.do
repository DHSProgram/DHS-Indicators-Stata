/*******************************************************************************************************************************
Program: 				FGmain.do
Purpose: 				Main file for the Female Genital Cutting Chapter. 
						The main file will call other do files that will produce the DV indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		October 22, 2020 by Shireen Assaf
Note:					This Chapter is a module and not part of the core questionnaire. 
						Please check if the survey you are interested in has included this module in the survey. 
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*change employee id number to personalize path
global user 33697

*working directory
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap18_FG"

*data path where data files are stored
global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"


* select your survey

* IR Files
global irdata "ETIR71FL"

* BR Files
global brdata "ETBR71FL"

* MR Files
global mrdata "ETMR71FL"

****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do FG_CIRCUM.do
*Purpose: 	Calculate female circumcision indicators among women

do FG_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.
*/
*******************************************************************************************************************************

* BR file variables

* To compute female circumcision among girls 0-14, we need to merge the IR and BR files
* The code below will reshape the IR file and merge with the BR file so we create a file for daughters. 
* The information on female circumcision of daughter is reported by the mother in the IR file

do FG_GIRLS.do
*Purpose: 	Calculate female circumcision indicators among girls age 0-14
*			This do file will also create the tables for these indicators


*/
*******************************************************************************************************************************

* MR file variables

* open dataset
use "$datapath//$mrdata.dta", clear

gen file=substr("$mrdata", 3, 2)

do FG_CIRCUM.do
*Purpose: 	Calculate female circumcision indicators among men (related to knowledge and opinion)

do FG_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.
*/
