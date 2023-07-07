/*****************************************************************************************************
Program: 			HK_TEST_COVG.do
Purpose: 			Code for coverage of HIV testing
Data inputs: 		PR file merged with AR file
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Nov 5, 2019 by Shireen Assaf 
Note:				
			
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

hv_hiv_test_wm	"Testing status among wommen eligible for HIV testing"
hv_hiv_test_mn	"Testing status among men eligible for HIV testing"
hv_hiv_test_tot	"Testing status among total eligible for HIV testing"
	
----------------------------------------------------------------------------*/

* Note: The denominator is among de facto population that is selected for HIV testing. 
* Here hv027 (selected for men's survey) are those selected for HIV. 

//HIV testing status among women
gen test=. 
replace test=1 if ha63==1 & (hiv03!=8 | hiv03==.) 
replace test=2 if ha63==3 
replace test=3 if ha63==2 
replace test=4 if inlist(ha63,4,5,6,9) | hiv03==8
replace test=. if hv103==0 | hv027==0 

recode ha65 (1=1) (2/7=2), gen(interv)
egen hv_hiv_test_wm= group(test interv)

label define teststat 1"DHS tested/interviewed" 2"DHS tested/not interveiwed" 3"Refused to give blood/interviewed" 4"Refused to give blood/not interviewed" 5"Not available for blood collection/interveiwed" 6"Not available for blood collection/not interveiwed" 7"Other or missing/interviewed" 8"Other or missing/not interveiwed"
label values hv_hiv_test_wm teststat
label var hv_hiv_test_wm "Testing status among wommen eligible for HIV testing"

drop test interv

//HIV testing status among men
gen test=. 
replace test=1 if hb63==1 & (hiv03!=8 | hiv03==.) 
replace test=2 if hb63==3 
replace test=3 if hb63==2 
replace test=4 if inlist(hb63,4,5,6,9) | hiv03==8
replace test=. if hv103==0 | hv027==0 

recode hb65 (1=1) (2/7=2), gen(interv)
egen hv_hiv_test_mn= group(test interv)
label values hv_hiv_test_mn teststat
label var hv_hiv_test_mn "Testing status among men eligible for HIV testing"

drop test interv

//HIV testing status among total population (men and women)
gen hv_hiv_test_tot = .
replace hv_hiv_test_tot= hv_hiv_test_wm if hv104==2
replace hv_hiv_test_tot= hv_hiv_test_mn if hv104==1
label values hv_hiv_test_tot teststat
label var hv_hiv_test_tot "Testing status among total eligible for HIV testing"

*check
*tab1 hv_hiv_test_wm hv_hiv_test_mn hv_hiv_test_tot if hv105>=15 & hv105<50 