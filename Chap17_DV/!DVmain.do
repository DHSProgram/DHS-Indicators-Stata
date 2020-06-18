/*******************************************************************************************************************************
Program: 				DVmain.do
Purpose: 				Main file for the Domesitc Violence Chapter. 
						The main file will call other do files that will produce the DV indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Courtney Allen
Date last modified:		December 11 2019 by Courtney Allen
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 39585
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap16_DV"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* IR Files
global irdata "ETIR70FL"
* MMIR71FL TJIR70FL GHIR72FL UGIR7BFL KEIR71FL

global mrdata "ETMR70FL"
* MMMR71FL GHMR72FL UGMR7BFL
****************************

* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do DV_viol.do
*Purpose: 	
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

do DV_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

