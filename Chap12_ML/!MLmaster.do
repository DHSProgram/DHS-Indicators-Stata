/*******************************************************************************************************************************
Program: 				MLmaster.do
Purpose: 				Master file for the Malaria Chapter. 
						The master file will call other do files that will produce the ML indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf		
Date last modified:		May 21, 2019
*******************************************************************************************************************************/
set more off

*local user 39585	//change employee id number to personalize path
global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap12_ML"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey
* HR Files
global hrdata "MWHR7IFL"
* GHHR7BFL

* PR files
global prdata "MWPR7IFL"

* IR files
global irdata "MWIR7IFL"

* KR files
global krdata "MWKR7IFL"

****************************
* do files that use the HR files

* open dataset
use "$datapath//$hrdata.dta", clear

gen file=substr("$hrdata", 3, 2)

do ML_NETS_HH.do
*Purpose: Code household net indicators

do ML_tables.do
* Purpose: will produce the tables for ML_NETS_HH.do file indicators

do ML_NETS_source.do
*Purpose: code source of mosquito net.
*Note: This code reshaps the date file and produces the table for this indicator that is appended to Tables_HH_ITN.xls file produced by the ML_tables.do file. 
*The data file would need to be reopened to code other variables at the household level. 
*/
*******************************************************************************************************************************
* do files that use the PR files

* open dataset
use "$datapath//$prdata.dta", clear
gen file=substr("$prdata", 3, 2)

do ML_NETS_use.do
*Purpose:	Code net use in population. In the ML_tables do file, the indicators will be outputed for the 
* 			population, children under 5, and pregnant women.

do ML_BIOMARKERS.do
*Purpose: 	Code anemia and malaria testing prevalence in children under 5

do ML_tables.do
* Purpose: 	Will produce the tables for indiators produced from the above two do files.

do ML_NETS_access.do
*Purpse: code population access to ITN
*Note: This code will produce an HRPR file and will also produce the tables for these indicators
*/
*******************************************************************************************************************************

* do files that use IR file variables

* open dataset
use "$datapath//$irdata.dta", clear
gen file=substr("$irdata", 3, 2)

do ML_IPTP.do
*Purpose:	Code malaria IPTP indicators

do ML_tables.do
*Purpose: 	Will produce the tables for indiators produced from the above do file

*/
*******************************************************************************************************************************

* do files that use KR file variables

* open dataset
use "$datapath//$krdata.dta", clear
gen file=substr("$krdata", 3, 2)

do ML_FEVER.do
*Purpose:	Code indicators on fever, fever care-seeking, and antimalarial drugs

do ML_tables.do
*Purpose: 	Will produce the tables for indiators produced from the above do file

*/
*******************************************************************************************************************************
