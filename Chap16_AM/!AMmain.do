/********************************************************************************
Program: 				AMmain.do
Purpose: 				Main file for the Mortality Chapter. 
						The main file will call other do files that will produce
						the AM indicators and produce tables.
Data outputs:			coded variables, table output on screen, and in excel tables.  
Author: 				Courtney Allen
Date last modified:		September 29, 2020

********************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 
global user 39585	//change employee id number to personalize path

* change working path
global workingpath "C:/Users//$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap16_AM"

* change data path
global datapath "C:/Users//$user//ICF/Analysis - Shared Resources/Data/DHSdata"


cd "$workingpath"

* select your survey

	* IR Files
	global irdata "ZMIR71FL"
	
	* MR Files
	global mrdata "ZMMR71FL"
	
	* PR Files
	global prdata "ZMPR71FL"

********************************************************************************
	
* IR file variables
program drop _all

* open dataset
use "$datapath//$irdata.dta", clear
gen file=substr("$irdata", 3, 2)

* ASFR and GFR do files
do AM_gfr.do
*Purpose: 	Code fertility rates and general fertility rate for mortality calculations.

* Mortality Rate do files
do AM_rates.do
*Purpose: 	Code fertility rates. This do file will create tables.

*/
*******************************************************************************************************************************
