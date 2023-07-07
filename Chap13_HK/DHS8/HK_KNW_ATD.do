/*****************************************************************************************************
Program: 			HK_KNW_ATD.do - DHS8 update
Purpose: 			Code to compute HIV-AIDS related knowledge and attitude indicators 
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: July 6, 2023 by Shireen Assaf
Note:				The indicators below can be computed for men and women. No age selection is made here. 
					
					Indicator hk_knw_hiv_hlth_2miscp (line 85) is country specific, please check the final report for the two most common misconceptions. 
					Currently coded as rejecting that HIV can be transmitted by mosquito bites and supernatural means.
					
					In DHS8 knowledge of HIV prevention indicators are only reported among women and men age 15-24. Updates to these indicators include replacing as missing values women and men age 25 or older.
					Several indicators have also been discontiued in DHS8. Please check the excel indicator list for these indicators. 
					
					12 new indicators in DHS8, see below
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_ever_heard		"Have ever heard of HIV or AIDS"

hk_knw_arv			"Heard of ARVs that treat HIV"  - NEW Indicator in DHS8
hk_knw_mtct_meds	"Know that risk of HIV mother to child transmission can be reduced by the mother taking special medicines"
hk_knw_PrEP			"Heard of PrEP"  - NEW Indicator in DHS8
hk_aprov_PrEP		"Heard of PrEP and approve of people who take PrEP to reduce their risk of HIV"  - NEW Indicator in DHS8
	
hk_atd_child_nosch	"Think that children living with HIV should not go to school with HIV negative children"
hk_atd_shop_notbuy	"Would not buy fresh vegetables from a shopkeeper who has HIV"
hk_atd_discriminat	"Have discriminatory attitudes towards people living with HIV"

hk_disclos_hiv			"Self-reported as HIV positive and disclosed their HIV status to anyone" - NEW Indicator in DHS8
hk_asham_hiv			"Self-reported as HIV positive and felt ashamed of their HIV status" - NEW Indicator in DHS8
hk_tlkbad_hiv			"Self-reported as HIV positive and report that people talk badly about them because of HIV status in the past 12 months" - NEW Indicator in DHS8
hk_othr_disclos_hiv		"Self-reported as HIV positive and report that someone else disclosed their status without their permission in the past 12 months" - NEW Indicator in DHS8
hk_harass_hiv			"Self-reported as HIV positive and report being verbally insulted/harassed/theratened because of their HIV status in the past 12 months" - NEW Indicator in DHS8
hk_stigma_hiv			"Self-reported as HIV positive and report experiencing stigma in a community setting in the past 12 months" - NEW Indicator in DHS8
hk_hlthwrk_tlkbad_hiv	"Self-reported as HIV positive and report that healthcare workers talked badly because of HIV status in the past 12 months" - NEW Indicator in DHS8
hk_hlthwrk_vrbabuse_hiv	"Self-reported as HIV positive and report that healthcare workers verbally abused them because of HIV status in the past 12 months" - NEW Indicator in DHS8

*** the indicators below were updated to the denominator of youth age 15-24 ***
hk_knw_risk_cond	"Know you can reduce HIV risk by using condoms at every sex among youth age 15-24"
hk_knw_risk_sex		"Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners among youth age 15-24"
hk_knw_hiv_hlth		"Know that a healthy looking person can have HIV among youth age 15-24"
hk_knw_hiv_mosq		"Know that HIV cannot be transmitted by mosquito bites among youth age 15-24"
hk_knw_hiv_food		"Know that cannot become infected by sharing food with a person who has HIV among youth age 15-24"
hk_knw_all 			"Have all reported knowledge about HIV prevention among youth age 15-24" - NEW Indicator in DHS8
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

cap label define yesno 0"No" 1"Yes"

//Ever heard of HIV/AIDS
gen hk_ever_heard= v751==1
label values hk_ever_heard yesno
label var hk_ever_heard "Have ever heard of HIV or AIDS"

//Heard of ARVs - NEW Indicator in DHS8
gen hk_knw_arv= v837==1
label values hk_knw_arv yesno
label var hk_knw_arv "Heard of ARVs that treat HIV"  

//Know risk of HIV MTCT can be reduced by meds
gen hk_knw_mtct_meds= v824==1
label values hk_knw_mtct_meds yesno
label var hk_knw_mtct_meds "Know that risk of HIV mother to child transmission can be reduced by the mother taking special medicines"

//Heard of PrEP - NEW Indicator in DHS8
gen hk_knw_PrEP= inrange(v859,1,3) 
label values hk_knw_PrEP yesno
label var hk_knw_PrEP "Heard of PrEP"  

//Heard of PrEP and approve of people who take PrEP - NEW Indicator in DHS8
gen hk_aprov_PrEP= v859==1 if inrange(v859,1,3) 
label values hk_aprov_PrEP yesno
label var hk_aprov_PrEP "Heard of PrEP and approve of people who take PrEP to reduce their risk of HIV"  

//Think that children with HIV should not go to school with HIV negative children
gen hk_atd_child_nosch= v857a==0 
replace hk_atd_child_nosch=. if v751==0
label values hk_atd_child_nosch yesno	
label var hk_atd_child_nosch "Think that children living with HIV should not go to school with HIV negative children"

//Would not buy fresh vegetabels from a shopkeeper who has HIV
gen hk_atd_shop_notbuy= v825==0 
replace hk_atd_shop_notbuy=. if v751==0
label values hk_atd_shop_notbuy yesno
label var hk_atd_shop_notbuy "Would not buy fresh vegetables from a shopkeeper who has HIV"

//Have discriminatory attitudes towards people living with HIV-AIDS
gen hk_atd_discriminat= (v857a==0 | v825==0) 
replace hk_atd_discriminat=. if v751==0
label values hk_atd_discriminat yesno
label var hk_atd_discriminat "Have discriminatory attitudes towards people living with HIV"

//Disclosed their HIV status to anyone - NEW Indicator in DHS8
gen hk_disclos_hiv= v865==1 if v861==1
label values hk_disclos_hiv yesno
label var hk_disclos_hiv "Self-reported as HIV positive and disclosed their HIV status to anyone" 

//Felt ashamed of their HIV status - NEW Indicator in DHS8
gen hk_asham_hiv= v866==1 if v861==1
label values hk_asham_hiv yesno
label var hk_asham_hiv "Self-reported as HIV positive and felt ashamed of their HIV status" 

//Report that people talk badly about them because of HIV status  - NEW Indicator in DHS8
gen hk_tlkbad_hiv= v867a==1 if v861==1
label values hk_tlkbad_hiv yesno
label var hk_tlkbad_hiv "Self-reported as HIV positive and report that people talk badly about them because of HIV status in the past 12 months" 

//Report that someone else disclosed their status without their permission  - NEW Indicator in DHS8
gen hk_othr_disclos_hiv= v867b==1 if v861==1
label values hk_othr_disclos_hiv yesno
label var hk_othr_disclos_hiv "Self-reported as HIV positive and report that someone else disclosed their status without their permission in the past 12 months" 

//Report being verbally insulted/harassed/theratened because of their HIV status  - NEW Indicator in DHS8
gen hk_harass_hiv= v867c==1 if v861==1
label values hk_harass_hiv yesno
label var hk_harass_hiv "Self-reported as HIV positive and report being verbally insulted/harassed/theratened because of their HIV status in the past 12 months" 

//Report experiencing stigma in a community setting  - NEW Indicator in DHS8
gen hk_stigma_hiv= (v867a==1|v867b==1|v867c==1) if v861==1
label values hk_stigma_hiv yesno
label var hk_stigma_hiv "Self-reported as HIV positive and report experiencing stigma in a community setting in the past 12 months" 

//Report that healthcare workers talked badly because of HIV status  - NEW Indicator in DHS8
gen hk_hlthwrk_tlkbad_hiv= v867d==1 if v861==1
label values hk_hlthwrk_tlkbad_hiv yesno
label var hk_hlthwrk_tlkbad_hiv "Self-reported as HIV positive and report that healthcare workers talked badly because of HIV status in the past 12 months" 

//Report that healthcare workers verbally abused them because of HIV status  - NEW Indicator in DHS8
gen hk_hlthwrk_vrbabuse_hiv= v867d==1 if v861==1
label values hk_hlthwrk_vrbabuse_hiv yesno
label var hk_hlthwrk_vrbabuse_hiv "Self-reported as HIV positive and report that healthcare workers verbally abused them because of HIV status in the past 12 months" 


*** Indicators among youth age 15-24 ***

//Know reduce risk - use condoms
gen hk_knw_risk_cond= v754cp==1
replace hk_knw_risk_cond=. if v012>24
label values hk_knw_risk_cond yesno
label var hk_knw_risk_cond "Know you can reduce HIV risk by using condoms at every sex among youth age 15-24"

//Know reduce risk - limit to one partner
gen hk_knw_risk_sex= v754dp==1
replace hk_knw_risk_sex=. if v012>24
label values hk_knw_risk_sex yesno
label var hk_knw_risk_sex "Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners among youth age 15-24"

//Know healthy person can have HIV
gen hk_knw_hiv_hlth= v756==1
replace hk_knw_hiv_hlth=. if v012>24
label values hk_knw_hiv_hlth yesno
label var hk_knw_hiv_hlth "Know that a healthy looking person can have HIV among youth age 15-24"

//Know HIV cannot be transmitted by mosquito bites
gen hk_knw_hiv_mosq= v754jp==0
replace hk_knw_hiv_mosq=. if v012>24
label values hk_knw_hiv_mosq yesno
label var hk_knw_hiv_mosq "Know that HIV cannot be transmitted by mosquito bites among youth age 15-24"

//Know HIV cannot be transmitted by sharing food with HIV infected person
gen hk_knw_hiv_food= v754wp==0
replace hk_knw_hiv_food=. if v012>24
label values hk_knw_hiv_food yesno
label var hk_knw_hiv_food "Know that cannot become infected by sharing food with a person who has HIV among youth age 15-24"

//Knowledge of all reported HIV prevention items - NEW Indicator in DHS8
gen hk_knw_all= v754cp==1 & v754dp==1 & v756==1 & v754jp==0 & v754wp==0 
replace hk_knw_all=. if v012>24
label values hk_knw_all yesno
label var hk_knw_all "Have all reported knowledge about HIV prevention among youth age 15-24"

}


* indicators from MR file
if file=="MR" {

cap label define yesno 0"No" 1"Yes"

//Ever heard of HIV/AIDS
gen hk_ever_heard=mv751==1
label values hk_ever_heard yesno
label var hk_ever_heard "Have ever heard of HIV or AIDS"

//Heard of ARVs - NEW Indicator in DHS8
gen hk_knw_arv= mv837==1
label values hk_knw_arv yesno
label var hk_knw_arv "Heard of ARVs that treat HIV"  

//Know risk of HIV MTCT can be reduced by meds
gen hk_knw_mtct_meds= mv824==1
label values hk_knw_mtct_meds yesno
label var hk_knw_mtct_meds "Know that risk of HIV mother to child transmission can be reduced by the mother taking special medicines"

//Heard of PrEP - NEW Indicator in DHS8
gen hk_knw_PrEP= inrange(mv859,1,3) 
label values hk_knw_PrEP yesno
label var hk_knw_PrEP "Heard of PrEP"  

//Heard of PrEP and approve of people who take PrEP - NEW Indicator in DHS8
gen hk_aprov_PrEP= mv859==1 if inrange(mv859,1,3) 
label values hk_aprov_PrEP yesno
label var hk_aprov_PrEP "Heard of PrEP and approve of people who take PrEP to reduce their risk of HIV"  

//Think that children with HIV should not go to school with HIV negative children
gen hk_atd_child_nosch= mv857a==0 
replace hk_atd_child_nosch=. if mv751==0
label values hk_atd_child_nosch yesno	
label var hk_atd_child_nosch "Think that children living with HIV should not go to school with HIV negative children"

//Would not buy fresh vegetabels from a shopkeeper who has HIV
gen hk_atd_shop_notbuy= mv825==0 
replace hk_atd_shop_notbuy=. if mv751==0
label values hk_atd_shop_notbuy yesno
label var hk_atd_shop_notbuy "Would not buy fresh vegetables from a shopkeeper who has HIV"

//Have discriminatory attitudes towards people living with HIV-AIDS
gen hk_atd_discriminat= (mv857a==0 | mv825==0) 
replace hk_atd_discriminat=. if mv751==0
label values hk_atd_discriminat yesno
label var hk_atd_discriminat "Have discriminatory attitudes towards people living with HIV"

//Disclosed their HIV status to anyone - NEW Indicator in DHS8
gen hk_disclos_hiv= mv865==1 if mv861==1
label values hk_disclos_hiv yesno
label var hk_disclos_hiv "Self-reported as HIV positive and disclosed their HIV status to anyone" 

//Felt ashamed of their HIV status - NEW Indicator in DHS8
gen hk_asham_hiv= mv866==1 if mv861==1
label values hk_asham_hiv yesno
label var hk_asham_hiv "Self-reported as HIV positive and felt ashamed of their HIV status" 

//Report that people talk badly about them because of HIV status  - NEW Indicator in DHS8
gen hk_tlkbad_hiv= mv867a==1 if mv861==1
label values hk_tlkbad_hiv yesno
label var hk_tlkbad_hiv "Self-reported as HIV positive and report that people talk badly about them because of HIV status in the past 12 months" 

//Report that someone else disclosed their status without their permission  - NEW Indicator in DHS8
gen hk_othr_disclos_hiv= mv867b==1 if mv861==1
label values hk_othr_disclos_hiv yesno
label var hk_othr_disclos_hiv "Self-reported as HIV positive and report that someone else disclosed their status without their permission in the past 12 months" 

//Report being verbally insulted/harassed/theratened because of their HIV status  - NEW Indicator in DHS8
gen hk_harass_hiv= mv867c==1 if mv861==1
label values hk_harass_hiv yesno
label var hk_harass_hiv "Self-reported as HIV positive and report being verbally insulted/harassed/theratened because of their HIV status in the past 12 months" 

//Report experiencing stigma in a community setting  - NEW Indicator in DHS8
gen hk_stigma_hiv= (mv867a==1|mv867b==1|mv867c==1) if mv861==1
label values hk_stigma_hiv yesno
label var hk_stigma_hiv "Self-reported as HIV positive and report experiencing stigma in a community setting in the past 12 months" 

//Report that healthcare workers talked badly because of HIV status  - NEW Indicator in DHS8
gen hk_hlthwrk_tlkbad_hiv= mv867d==1 if mv861==1
label values hk_hlthwrk_tlkbad_hiv yesno
label var hk_hlthwrk_tlkbad_hiv "Self-reported as HIV positive and report that healthcare workers talked badly because of HIV status in the past 12 months" 

//Report that healthcare workers verbally abused them because of HIV status  - NEW Indicator in DHS8
gen hk_hlthwrk_vrbabuse_hiv= mv867d==1 if mv861==1
label values hk_hlthwrk_vrbabuse_hiv yesno
label var hk_hlthwrk_vrbabuse_hiv "Self-reported as HIV positive and report that healthcare workers verbally abused them because of HIV status in the past 12 months" 

*** Indicators among youth age 15-24 ***

//Know reduce risk - use condoms
gen hk_knw_risk_cond= mv754cp==1
replace hk_knw_risk_cond=. if mv012>24
label values hk_knw_risk_cond yesno
label var hk_knw_risk_cond "Know you can reduce HIV risk by using condoms at every sex among youth age 15-24"

//Know reduce risk - limit to one partner
gen hk_knw_risk_sex= mv754dp==1
replace hk_knw_risk_sex=. if mv012>24
label values hk_knw_risk_sex yesno
label var hk_knw_risk_sex "Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners among youth age 15-24"

//Know healthy person can have HIV
gen hk_knw_hiv_hlth= mv756==1
replace hk_knw_hiv_hlth=. if mv012>24
label values hk_knw_hiv_hlth yesno
label var hk_knw_hiv_hlth "Know that a healthy looking person can have HIV among youth age 15-24"

//Know HIV cannot be transmitted by mosquito bites
gen hk_knw_hiv_mosq= mv754jp==0
replace hk_knw_hiv_mosq=. if mv012>24
label values hk_knw_hiv_mosq yesno
label var hk_knw_hiv_mosq "Know that HIV cannot be transmitted by mosquito bites among youth age 15-24"

//Know HIV cannot be transmitted by sharing food with HIV infected person
gen hk_knw_hiv_food= mv754wp==0
replace hk_knw_hiv_food=. if mv012>24
label values hk_knw_hiv_food yesno
label var hk_knw_hiv_food "Know that cannot become infected by sharing food with a person who has HIV among youth age 15-24"

//Knowledge of all reported HIV prevention items - NEW Indicator in DHS8
gen hk_knw_all= mv754cp==1 & mv754dp==1 & mv756==1 & mv754jp==0 & mv754wp==0 
replace hk_knw_all=. if mv012>24
label values hk_knw_all yesno
label var hk_knw_all "Have all reported knowledge about HIV prevention among youth age 15-24"

}
