/******************************************* **********************************************************
Program: 			ML_NETS_source.do - DHS8 update
Purpose: 			Code indicators for source of nets and reasons why not using nets
Data inputs: 		HR dataset
Data outputs:		coded variables and the table Tables_Net_Source.xls and Tables_NoNet_Reason for the tabulations for the indicators
Author:				Cameron Taylor and modified by Shireen Assaf for the code share project
Date last modified: July 7 2023 by Cameron Taylor and July 11 by Shireen Assaf for DHS8 updates

					2 indicators in DHS8
					Also in DHS8, the indicators are tabulation for three seperate denominators: 1. ITNs, 2. Non-ITN, and 3. All mosquito nets.
					The default selection is ITN on like 27. To tabulate for other denominators, change the selection. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_net_dist		"Received a net from mass distribution, ANC, immunization, or at birth"
ml_net_source	"Source of mosquito net"

ml_not_used 	"Mosquito net not used" - NEW Indicator in DHS8
ml_net_reasons	"Reason net was not used the night" - NEW Indicator in DHS8

----------------------------------------------------------------------------*/

*Reshaping the dataset to a long format to tabulate among nets in household
reshape long hml10_ hml21_ hml22_ hml23_ hml24_ ,i(hhid) j(idx)

*** Three denominators for tables in DHS8 tabplan ***
* ITNs
gen select = hml10_==1

* Non-ITN
*gen select = hml10_==0

* All mosquito nets
*gen select==1
******************************************

//Number of mosquito nets 
gen ml_numnet=0
replace ml_numnet=1 if hml22_>=0 & hml22_<=99
lab var ml_numnet "Number of mosquito nets"

drop if ml_numnet==0

//Received a mosquito net obtained from campaign, anc, or immunization 
gen ml_net_dist=0
replace ml_net_dist=1 if hml22_>=1
lab var ml_net_dist "Received a net from mass distribution, ANC, immunization, or at birth"

//Source of net
*Note hml23_ can have several country specific categories. Pleace check and adjust the code accordingly. 
*In the code below, several country specific categories were grouped in category 9. 
gen ml_net_source=.
replace ml_net_source=5 if hml23_==10 | hml23_==11 | hml23_==12 | hml23_==13
replace ml_net_source=6 if hml23_>=20 & hml23_<30
replace ml_net_source=7 if hml23_==31
replace ml_net_source=8 if hml23_==32
replace ml_net_source=9 if hml23_ >32 & hml23_ <96
replace ml_net_source=10 if hml23_==96
replace ml_net_source=11 if hml23_>97
replace ml_net_source=1 if hml22_==1
replace ml_net_source=2 if hml22_==2
replace ml_net_source=3 if hml22_==3
replace ml_net_source=4 if hml22_==4
label define source 1 "mass distribution campaign" 2"ANC visit" 3"immunisation visit" 4"at birth" ///
					5"gov. facility" 6"private facility" 7"pharmacy" 8"shop/market" 9"other country specific" 10"other" 11"don'tknow/missing"
label values ml_net_source source
label var ml_net_source "Source of mosquito net"


*** Table for source ***
cap gen wt=hv005/1000000
//Mosquito nets obtained from mass distribution

*residence
tab hv025 ml_net_source [iw=wt], row nofreq 

*region
tab hv024 ml_net_source [iw=wt], row nofreq 

*wealth
tab hv270 ml_net_source [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_net_source if select==1 using Tables_HH_ITN.xls [iw=wt] , c(row) f(1) append 

****************************************************

* Mosquito net not used and reasons why

drop if hml21_==.

//Net not used
gen ml_not_used= hml21_==0
lab var ml_not_used "Mosquito net not used"

//Reasons did not use net
gen ml_net_reasons=.
replace ml_net_reasons=hml24_
label define reasons 1 "too hot" 2"don't like net shape/color/size" 3"don't like smell" 4"unable to hang net" ///
					5"slept outdoors" 6"usual user didn't sleep here" 7"no mosquitoes/no malaria" ///
					8"extra net/saving for later" 9"net too small/short" 10"net brought bedbugs" 96"other"
label values ml_net_reasons reasons
label var ml_net_reasons "Reason net was not used the night"


*** Tables for reasons ***
cap gen wt=hv005/1000000


//Not used the night before the survey

*residence
tab hv025 ml_not_used if select==1 [iw=wt], row nofreq 

*region
tab hv024 ml_not_used if select==1 [iw=wt], row nofreq 

*wealth
tab hv270 ml_not_used if select==1 [iw=wt], row nofreq 


* output to excel
tabout hv025 hv024 hv270 ml_not_used if select==1 using Tables_NoNet_Reason.xls [iw=wt] , c(row) f(1) replace 



//ITNs reasons not used

*residence
tab hv025 ml_net_reasons if select==1 [iw=wt], row nofreq 

*region
tab hv024 ml_net_reasons if select==1  [iw=wt], row nofreq 

*wealth
tab hv270 ml_net_reasons if select==1  [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_net_reasons if select==1 using Tables_NoNet_Reason.xls [iw=wt] , c(row) f(1) append 

****************************************************