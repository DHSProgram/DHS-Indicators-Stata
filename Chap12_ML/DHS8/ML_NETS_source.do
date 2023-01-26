/*****************************************************************************************************
Program: 			ML_NETS_source.do
Purpose: 			Code indicators for source of nets
Data inputs: 		HR dataset
Data outputs:		coded variables and the table Tables_Net_Source.xls for the tabulations for the indicators
Author:				Cameron Taylor and modified by Shireen Assaf for the code share project
Date last modified: May 20 2019 by Shireen Assaf
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_net_dist		"Received a net from mass distribution, ANC, immunization, or at birth"
ml_net_source	"Source of mosquito net"
----------------------------------------------------------------------------*/
*open HR file
use "$datapath//$hrdata.dta", clear

*Reshaping the dataset to a long format to tabulate among nets in household
reshape long hml22_ hml23_  ,i(hhid) j(idx)

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
replace ml_net_source=5 if hml23_==11 | hml23_==12 | hml23_==13
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

* Table for source
gen wt=hv005/1000000
//Mosquito nets obtained from mass distribution

*residence
tab hv025 ml_net_source [iw=wt], row nofreq 

*region
tab hv024 ml_net_source [iw=wt], row nofreq 

*wealth
tab hv270 ml_net_source [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_net_source using Tables_HH_ITN.xls [iw=wt] , c(row) f(1) append 

****************************************************
