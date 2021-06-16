/*****************************************************************************************************
Program: 			HK_CIRCUM.do
Purpose: 			Code for indicators on male circumcision
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Nov 1, 2019 by Shireen Assaf 
Note:				The indicators are computed for all men. No age selection is made here. 
			
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_circum				"Circumcised"
hk_circum_status_prov	"Circumcision status and provider"
	
----------------------------------------------------------------------------*/

* Indicators from MR file

cap label define yesno 0"No" 1"Yes"

**************************

//Circumcised
gen hk_circum = mv483==1
label values hk_circum yesno
label var hk_circum "Circumcised"

//Circumcision status and provider
gen hk_circum_status_prov= mv483b 
replace hk_circum_status_prov=3 if mv483b>2
replace hk_circum_status_prov=0 if mv483==0
replace hk_circum_status_prov=9 if mv483==8
label define hk_circum_status_prov 0"Not circumsised" 1"Traditional practitioner, family member, or friend" 2"Health work or health professional" 3 "Other/dont know/missing" 9"Dont know/missing circumcision status"
label values hk_circum_status_prov hk_circum_status_prov
label var hk_circum_status_prov "Circumcision status and provider"







