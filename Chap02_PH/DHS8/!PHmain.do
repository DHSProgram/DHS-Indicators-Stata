/*******************************************************************************************************************************
Program: 				PHmain.do
Purpose: 				Main file for the Population and Housing Chapter. 
						The main file will call other do files that will produce the PH indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf
Date last modified:		September 9, 2020 by Courtney Allen
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

global user 33697	//change employee id number to personalize path

cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap02_PH"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* HR Files
global hrdata "ZWHR72FL"
* GHHR72FL  MMHR71FL UGHR7BFL ZMHR71FL  NGHR7AFL

* PR Files
global prdata "ZWPR72FL"
* GHPR72FL  MMPR71FL UGPR7BFL ZMPR71FL  NGPR7AFL

* BR Files
global brdata "ZWBR72FL"
* GHBR72FL  MMBR71FL UGBR7BFL ZMBR71FL  NGBR7AFL

****************************

* HR file variables (use for indicators where households is the unit of measurement)

* open dataset
use "$datapath//$hrdata.dta", clear

gen file=substr("$hrdata", 3, 2)
gen filename=strlower(substr("$hrdata", 1, 6))

do PH_SANI.do
* Purpose: 	Code Sanitation indicators

do PH_WATER.do
* Purpose: 	Code Water Source indicators

do PH_HOUS.do
* Purpose:	Code housing indicators such as house material, assets, cooking fuel and place, and smoking in the home

do PH_tables.do
* Purpose: 	Produce tables for indicators computed from the above do files. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* PR file variables (use for indicators where the population is the unit of measurement)

* open dataset
use "$datapath//$prdata.dta", clear

gen file=substr("$prdata", 3, 2)

do PH_HNDWSH.do
* Purpose:	Code handwashing indicators

do PH_tables.do
* Purpose: 	Produce tables for indicators computed from the above do files.

do PH_SCHOL.do
* Purpose:	Code eduation and schooling indicators. 
* Note: This code will merge BR and PR files and drop some cases. It will also produce the excel file Tables_schol 

* open dataset again since cases were droped in PH_EDU.do
use "$datapath//$prdata.dta", clear

do PH_POP.do
* Purpose: 	Code to compute population characteristics, birth registration, education levels, household composition, orphanhood, and living arrangments
* Warning: This do file will collapse the data and therefore some indicators produced will be lost. However, they are saved in the file PR_temp_children.dta and this data file will be used to produce the tables for these indicators in the PH_table code. This do file will produce the Tables_hh_comps for household composition (usually Table 2.8 or 2.9 in the Final Report). 

do PH_tables2.do
* Purpose: 	Produce tables for indicators computed from the PH_POP.do file

*
do PH_GINI.do
* Purpose:	Code to produce Gini index table. 
* Note: 	This code will collapse the data and produce the table Table_gini.xls

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

