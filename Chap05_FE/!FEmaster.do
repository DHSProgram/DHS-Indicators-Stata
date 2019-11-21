/*******************************************************************************************************************************
Program: 				FEmaster.do
Purpose: 				Master file for the Fertility Chapter. 
						The master file will call other do files that will produce the FE indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Courtney Allen
Date last modified:		November 20, 2019

*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

global user 39585	//change employee id number to personalize path

* change working path
cd "C:/Users//$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap05_FE"

* change data path
global datapath "C:/Users//$user//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "MWIR7HFL"
*TJIR72FL GHIR72FL TJBR72FL
global prdata  "MWPR7HFL"
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do FE_FERT.do
*Purpose: 	Code fertility indicators about first birth, pregnancy, menopause and children born

do FE_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 



* Fertility do files
do FE_TFR.do
*Purpose: 	Code fertility rates. This do file will create tables.

* REopen dataset
use "$datapath//$irdata.dta", clear

do FE_ASFR_10_14.do
*Purpose: 	Code ASFR for 10-14 year olds. This file will create tables.



* PR file variables

* open dataset
use "$datapath//$prdata.dta", clear

do FE_CBR.do
*Purpose: 	Code crude birth rates. This file will create tables.



*/
*******************************************************************************************************************************
