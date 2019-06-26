/*****************************************************************************************************
Program: 			ML_EXISTING_ITN.do
Purpose: 			Code indicators for source of nets
Data inputs: 		HR survey list
Data outputs:		coded variables and the tables for the indicator produced which will be saved in the Tables_HH_ITN.xls excel file
Author:				Cameron Taylor and modified by Shireen Assaf
Date last modified: May 20 2019 by Shireen Assaf
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_sleepnet 		"Someone slept under net last night"
----------------------------------------------------------------------------*/
use "$datapath//$hrdata.dta", clear

*Reshaping the dataset to a long format to tabulate amoung nets
reshape long hml10_ hml21_ ,i(hhid) j(idx)

//Identifying if the net was used 
gen ml_sleepnet=0
replace ml_sleepnet=1 if hml21_==1
lab var ml_sleepnet "Someone slept under net last night"

//Net is an ITN
gen ml_ownnet=0
replace ml_ownnet=1 if hml10_==1
lab var ml_ownnet "Net is an ITN"

* Tables for these indicators

//ITN was used by anyone the night before the survey

*residence
tab hv025 ml_sleepnet if ml_ownnet==1 [iw=wt], row nofreq 

*region
tab hv024 ml_sleepnet if ml_ownnet==1 [iw=wt], row nofreq 

*wealth
tab hv270 ml_sleepnet if ml_ownnet==1 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_sleepnet if ml_ownnet==1 using Tables_HH_ITN.xls [iw=wt] , c(row) f(1) append 
