/*******************************************************************************************************************************
Program: 				CHmain.do - DHS8 update
Purpose: 				Main file for the Child Health Chapter. 
						The main file will call other do files that will produce the CH indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf	
Date last modified:		Jan 24, 2023 by Shireen Assaf

*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

global user 33697

cd "C:/Users/$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap10_CH/DHS8"

global datapath "C:/Users/$user//ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* NR Files
global nrdata "CINR80FL"

* KR Files
global krdata "CIKR80FL"

****************************

* open dataset
use "$datapath//$nrdata.dta", clear

gen file=substr("$nrdata", 3, 2)

cap label define yesno 0"No" 1"Yes"

do CH_SIZE.do
*Purpose: 	Code child size indicators

do CH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

****************************
* KR file variables

* open dataset
use "$datapath//$krdata.dta", clear

gen file=substr("$krdata", 3, 2)

cap label define yesno 0"No" 1"Yes"
	
do CH_ARI_FV.do
*Purpose: 	Code ARI indicators

do CH_DIAR.do
*Purpose: 	Code diarrhea indicators

do CH_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 

do CH_VAC.do
*Purpose: 	Code vaccination indicators
*!!!! Note: This do file drops children that are not in a specific age group. So if you need all children for your analysis you need to reopen the KR file.

do CH_tables_vac.do
*Purpose: 	Produce tables for vaccination indicators.
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

