/*******************************************************************************************************************************
Program: 				MLmain.do - DHS8 update
Purpose: 				Main file for the Malaria Chapter. 
						The main file will call other do files that will produce the ML indicators and produce tables.
Data outputs:			coded variables and table output on screen and in excel tables.  
Author: 				Shireen Assaf		
Date last modified:		July 11, 2023 by Shireen Assaf
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

global user 33697
cd "C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap12_ML/DHS8"

global datapath "C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"

* select your survey

* HR Files
global hrdata "KEHR8AFL"

* PR files
global prdata "KEPR8AFL"

* NR files
global nrdata "KENR8AFL"

* KR files
global krdata "KEKR8AFL"

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
*Purpose: code source of mosquito net and reason why not using nets.
*Note: This code reshaps the date file and produces the table for the source indicator that is appended to Tables_HH_ITN.xls file produced by the ML_tables.do file. 
* The do file will also produce the Tables_NoNet_Reason.xls file for the new DHS8 indicators for reasons nets were not used. 
*In DHS8 there are three different denominators for reported the indicators in this do file. Please see the notes in the do file and make the selection for denominator of interest.  
*The data file would need to be reopened to code other variables at the household level. 

* open file again because the data was reshaped in the previous do file
use "$datapath//$hrdata.dta", clear

do ML_EXISTING_ITN.do
* Purpose: Code indicators for source of nets and produce tables for these indicators. 
*Note: This code reshaps the date file and produces the table for this indicator that is appended to Tables_HH_ITN.xls file produced by the ML_tables.do file. 
*The data file would need to be reopened to code other variables at the household level


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
use "$datapath//$nrdata.dta", clear
gen file=substr("$nrdata", 3, 2)

* keep only live birth and/or stillbirth in the 2 years before the survey
keep if p19 < 24 & inlist(m80,1,3)

do ML_IPTP.do
*Purpose:	Code malaria IPTP indicators

do ML_tables.do
*Purpose: 	Will produce the tables for indiators produced from the above do file
* Note:		This will drop any women not in 15-49 age range. You can change this selection. Please check the notes in the do file.

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
