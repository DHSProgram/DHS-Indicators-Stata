/*******************************************************************************
Program:		CMmain.do - DHS8 update
Purpose:		Main file for the Child Mortality Chapter. 
				The main file will call other do files that will produce the CM indicators and produce tables.
Data outputs:	coded variables and table output on screen and in excel tables.  
Note:			You must rename the dta and excel files or they will be over-written in the next run.
Author:			Tom Pullum and Shireen Assaf 			
Date last modified:		September 2024 for DHS8
*******************************************************************************/

set more off

* Username for internal DHS use. Please disregard and adjust paths to your own.
global user 39585	

* Specify data path
global datapath "C:/Users//$user//ICF/Analysis - Shared Resources/Data/DHSdata"

* Specify working path
global workingpath "C:/Users//$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap08_CM/DHS8"

* Specify results path
global resultspath "C:/Users//$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap08_CM/DHS8"

cd "$workingpath"

* Specify a basic list of background variables for table 8.4
* The oldest surveys do not include v190; use whichever of the following is appropriate or modify
global gcovars "v025 v024 v106 v149 v190 total"

* select your survey

* IR File
global irdata "NPIR82FL"

* BR file
global brdata "NPBR82FL"

* KR file
global krdata "NPKR82FL"

* GR file
global grdata "NPGR82FL"
****************************

do CM_CHILD.do
*Purpose: Code child mortality rates for tables 8.1, 8.2, and 8.3 including one-month ENMR 
* Uses the BR file

do CM_PMR.do
*Purpose: Code stillbirths, early neonatal deaths, and perinatal mortality rate for table 8.4
* Uses the GR file

do CM_RISK.do
*Purpose: Code high risk birth indicators and risk ratios for table 8.5
* Uses both the KR file and the IR file


