/*******************************************************************************************************************************
Program: 				DVmain.do
Purpose: 				Main file for the Domesitc Violence Chapter. 
						The main file will call other do files that will produce the DV indicators and produce tables.
Data outputs:			Coded variables and table output on screen and in excel tables.  
Author: 				Courtney Allen
Date last modified:		September 24 2020 by Courtney Allen
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 39585

*working directory
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap17_DV"

*data path where data files are stored
global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"



* select your survey

* IR Files
global irdata "NGIR7AFL"

****************************



* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)

do DV_VIOL.do
*Purpose: 	Calculate violence indicators, such as age at first violence, ever experienced violence

do DV_PRTNR.do
*Purpose: 	Calculate violence indicators that have to do with spousal/partner violence and seeking help

do DV_CNTRL.do
*Purpose: 	Calculate violence indicators that have to do with spousal/partner violence and seeking help

do DV_tables.do
*Purpose: 	Produce tables for indicators computed from the above do files.
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

