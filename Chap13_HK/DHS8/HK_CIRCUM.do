/*****************************************************************************************************
Program: 			HK_CIRCUM.do  - DHS8 update
Purpose: 			Code for indicators on male circumcision
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: July 6, 2023 by Shireen Assaf
Note:				The indicators are computed for men. No age selection is made here. 
			
					1 new indicators in DHS8, see below	
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_circum		"Circumcised traditionally or medically"
hk_circum_type	"Type of circumcision" - NEW Indicator in DHS8
----------------------------------------------------------------------------*/

* Indicators from MR file

cap label define yesno 0"No" 1"Yes"

**************************

//Circumcised
gen hk_circum = mv483==1
label values hk_circum yesno
label var hk_circum "Circumcised traditionally or medically"

//Circumcision status and provider - NEW Indicator in DHS8
gen hk_circum_type= 0
replace hk_circum_type=1 if mv483d==1 & mv483e==0
replace hk_circum_type=2 if mv483d==0 & mv483e==1
replace hk_circum_type=3 if mv483d==1 & mv483e==1
replace hk_circum_type=0 if mv483==0 | mv483==8
label define hk_circum_type 0"Not circumsised or don't know" 1"Traditional only" 2"Medical only" 3 "Both traditionally and medically" 
label values hk_circum_type hk_circum_type
label var hk_circum_type "Type of circumcision"






