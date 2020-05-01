/*******************************************************************************************************************************
Program: 				PHmaster.do
Purpose: 				Master file for the Population and Housing Chapter. 
						The master file will call other do files that will produce the PH indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		May 1 2020 by Shireen Assaf
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap02_PH"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global hrdata "ZMHR71FL"
* GHHR72FL  MMHR71FL UGHR7BFL NGHR7AFL

global prdata "ZMPR71FL"
* GHPR72FL  MMPR71FL UGPR7BFL NGPR7AFL
****************************

cap label define yesno 0"No" 1"Yes"

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

do PH_tables.do
* Purpose: 	Produce tables for indicators computed from the above do files. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* PR file variables

* open dataset
use "$datapath//$prdata.dta", clear

gen file=substr("$prdata", 3, 2)

do PH_HNDWSH.do
* Purpose:	Code handwashing indicators

do PH_tables.do
* Purpose: 	Produce tables for indicators computed from the above do files.

do PH_POP.do
* Purpose: 	Code to compute population characteristics, birth registration, household composition, orphanhood, and living arrangments
* Warning: This do file will collapse the data and therefore some indicators produced will be lost. However, they are saved in the file PR_temp_children.dta and this data file will be used to produce the tables for these indicators in the PH_table code. This do file will produce the Tables_hh_comps for household composition (usually Table 2.8 or 2.9 in the Final Report). 

do PH_tables2.do
* Purpose: 	Produce tables for indicators computed from the PH_POP.do file

*do PH_EDU.do
* Purpose:	Code eduation and schooling indicators

 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

