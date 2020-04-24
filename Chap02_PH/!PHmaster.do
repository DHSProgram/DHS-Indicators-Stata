/*******************************************************************************************************************************
Program: 				PHmaster.do
Purpose: 				Master file for the Population and Housing Chapter. 
						The master file will call other do files that will produce the PH indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		April 8 2020 by Shireen Assaf
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap02_PH"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global hrdata "UGHR7BFL"
* MMHR71FL GHHR72FL  

global prdata "UGPR7BFL"
* MMPR71FL GHPR72FL 
****************************

label define yesno 0"No" 1"Yes"

* HR file variables

* open dataset
use "$datapath//$hrdata.dta", clear

gen file=substr("$hrdata", 3, 2)

*do PH_WATER.do
* Purpose: 	Code water indicators
* Note:		

*do PH_SANIT.do
* Purpose: 	Code Sanitation indicators

do PH_HOUS.do
* Purpose:	Code housing indicators such as house material, assets, cooking fuel and place, and smoking in the home

do PH_HNDWSH.do
* Purpose:	Code handwashing indicators

*do PH_tables.do
* Purpose: 	Produce tables for indicators computed from the above do files. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

/* PR file variables

* open dataset
use "$datapath//$prdata.dta", clear

gen file=substr("$prdata", 3, 2)

do PH_POP.do
* Purpose: 	Code population characteristics indicators

*do PH_EDU.do
* Purpose:	Code eduation and schooling indicators

*do PH_tables.do
* Purpose: 	Produce tables for indicators computed from the above do files. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

