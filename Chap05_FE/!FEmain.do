/********************************************************************************
Program: 				FEmain.do
Purpose: 				Main file for the Fertility Chapter. 
						The main file will call other do files that will produce
						the FE indicators and produce tables.
Data outputs:			coded variables, table output on screen, and in excel tables.  
Author: 				Courtney Allen
Date last modified:		November 21, 2019

********************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

global user 39585	//change employee id number to personalize path

* change working path
global workingpath "C:/Users//$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap05_FE"

* change data path
global datapath "C:/Users//$user//ICF/Analysis - Shared Resources/Data/DHSdata"


cd "$workingpath"

* select your survey

	* IR Files
	global irdata "TJIR71FL"
	*TJIR72FL GHIR72FL TJBR72FL
	
	*PR Files
	global prdata  "TJPR71FL"
	
	*KR Files
	global krdata "TJKR71FL"

	*BR Files
	global brdata "TJBR71FL"

********************************************************************************
	
* IR file variables

* open dataset
use "$datapath//$irdata.dta", clear
gen file=substr("$irdata", 3, 2)

* Fertility Rate do files
do FE_TFR.do
*Purpose: 	Code fertility rates. This do file will create tables.

* Reopen dataset for ASFR 10 to 14
use "$datapath//$irdata.dta", clear

*do FE_ASFR_10_14.do
*Purpose: 	Code ASFR for 10-14 year olds. This file will create tables.

*/
* Reopen dataset for curr ent fertility indicators.
use "$datapath//$irdata.dta", clear

gen file=substr("$irdata", 3, 2)
 
do FE_FERT.do
*Purpose: 	Code fertility indicators about first birth, pregnancy, menopause and children born

do FE_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 





* PR file variables

* open dataset
use "$datapath//$prdata.dta", clear

gen file=substr("$prdata", 3, 2)

do FE_CBR.do
* Purpose: 	Code crude birth rates. This file will create tables. This do file 
* must be run after the FE_TFR.do file is run as it uses the scalars created.




* KR file variables
*/
use "$datapath//$krdata.dta", clear

gen file=substr("$krdata", 6, 1)

do FE_temp.do
* Purpose: Code 

* Reopen dataset for the other do files
use "$datapath//$krdata.dta", clear

gen file=substr("$krdata", 3, 2)

do FE_POST.do
* Purpose: Code indicators reflecting birth intervals and postpartum experience.

do FE_tables.do
*Purpose: 	Produce tables for indicators computed from above do files. 



*/
*******************************************************************************************************************************
