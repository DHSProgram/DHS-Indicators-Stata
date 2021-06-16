/*****************************************************************************************************
Program: 			HK_KNW_ATD.do
Purpose: 			Code to compute HIV-AIDS related knowledge and attitude indicators 
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Oct 29, 2019 by Shireen Assaf 
Note:				The indicators below can be computed for men and women. No age selection is made here. 
					
					Indicator hk_knw_hiv_hlth_2miscp (line 85) is country specific, please check the final report for the two most common misconceptions. 
					Currently coded as rejecting that HIV can be transmitted by mosquito bites and supernatural means.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_ever_heard			"Have ever heard of HIV or AIDS"
hk_knw_risk_cond		"Know you can reduce HIV risk by using condoms at every sex"
hk_knw_risk_sex			"Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners"
hk_knw_risk_condsex		"Know you can reduce HIV risk by using condoms at every sex and limiting to one uninfected partner with no other partner"
hk_knw_hiv_hlth			"Know that a healthy looking person can have HIV"
hk_knw_hiv_mosq			"Know that HIV cannot be transmitted by mosquito bites"
hk_knw_hiv_supernat		"Know that HIV cannot be transmitted by supernatural means"
hk_knw_hiv_food			"Know that cannot become infected by sharing food with a person who has HIV"
hk_knw_hiv_hlth_2miscp	"Know that a healthy looking person can have HIV and reject the two most common local misconceptions"
hk_knw_comphsv			"Have comprehensive knowledge about HIV"
	
hk_knw_mtct_preg		"Know that HIV mother to child transmission can occur during pregnancy"
hk_knw_mtct_deliv		"Know that HIV mother to child transmission can occur during delivery"
hk_knw_mtct_brfeed		"Know that HIV mother to child transmission can occur by breastfeeding"
hk_knw_mtct_all3		"Know that HIV mother to child transmission can occur during pregnancy, delivery, and by breastfeeding"
hk_knw_mtct_meds		"Know that risk of HIV mother to child transmission can be reduced by the mother taking special drugs"
	
hk_atd_child_nosch		"Think that children living with HIV should not go to school with HIV negative children"
hk_atd_shop_notbuy		"Would not buy fresh vegetables from a shopkeeper who has HIV"
hk_atd_discriminat		"Have discriminatory attitudes towards people living with HIV"
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

cap label define yesno 0"No" 1"Yes"

*** HIV related knowledge ***
//Ever heard of HIV/AIDS
gen hk_ever_heard= v751==1
label values hk_ever_heard yesno
label var hk_ever_heard "Have ever heard of HIV or AIDS"

//Know reduce risk - use condoms
gen hk_knw_risk_cond= v754cp==1
label values hk_knw_risk_cond yesno
label var hk_knw_risk_cond "Know you can reduce HIV risk by using condoms at every sex"

//Know reduce risk - limit to one partner
gen hk_knw_risk_sex= v754dp==1
label values hk_knw_risk_sex yesno
label var hk_knw_risk_sex "Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners"

//Know reduce risk - use condoms and limit to one partner
gen hk_knw_risk_condsex= v754cp==1 & v754dp==1
label values hk_knw_risk_condsex yesno
label var hk_knw_risk_condsex "Know you can reduce HIV risk by using condoms at every sex and limiting to one uninfected partner with no other partner"

//Know healthy person can have HIV
gen hk_knw_hiv_hlth= v756==1
label values hk_knw_hiv_hlth yesno
label var hk_knw_hiv_hlth "Know that a healthy looking person can have HIV"

//Know HIV cannot be transmitted by mosquito bites
gen hk_knw_hiv_mosq= v754jp==0
label values hk_knw_hiv_mosq yesno
label var hk_knw_hiv_mosq "Know that HIV cannot be transmitted by mosquito bites"

//Know HIV cannot be transmitted by supernatural means
gen hk_knw_hiv_supernat= v823==0
label values hk_knw_hiv_supernat yesno
label var hk_knw_hiv_supernat "Know that HIV cannot be transmitted by supernatural means"

//Know HIV cannot be transmitted by sharing food with HIV infected person
gen hk_knw_hiv_food= v754wp==0
label values hk_knw_hiv_food yesno
label var hk_knw_hiv_food "Know that cannot become infected by sharing food with a person who has HIV"

//Know healthy person can have HIV and reject two common local misconceptions
gen hk_knw_hiv_hlth_2miscp= v756==1 & v754jp==0 & v823==0
label values hk_knw_hiv_hlth_2miscp yesno
label var hk_knw_hiv_hlth_2miscp "Know that a healthy looking person can have HIV and reject the two most common local misconceptions"

//HIV comprehensive knowledge
gen hk_knw_comphsv= v754cp==1 & v754dp==1 & v756==1 & v754jp==0 & v823==0
label values hk_knw_comphsv yesno
label var hk_knw_comphsv "Have comprehensive knowledge about HIV"

//Know that HIV MTCT can occur during pregnancy
gen hk_knw_mtct_preg= v774a==1
label values hk_knw_mtct_preg yesno
label var hk_knw_mtct_preg "Know that HIV mother to child transmission can occur during pregnancy"

//Know that HIV MTCT can occur during delivery
gen hk_knw_mtct_deliv= v774b==1
label values hk_knw_mtct_deliv yesno
label var hk_knw_mtct_deliv "Know that HIV mother to child transmission can occur during delivery"

//Know that HIV MTCT can occur during breastfeeding
gen hk_knw_mtct_brfeed= v774c==1
label values hk_knw_mtct_brfeed yesno
label var hk_knw_mtct_brfeed "Know that HIV mother to child transmission can occur by breastfeeding"

//Know all three HIV MTCT
gen  hk_knw_mtct_all3= v774a==1 & v774b==1 & v774c==1
label values hk_knw_mtct_all3 yesno
label var hk_knw_mtct_all3 "Know that HIV mother to child transmission can occur during pregnancy, delivery, and by breastfeeding"

//Know risk of HIV MTCT can be reduced by meds
gen hk_knw_mtct_meds= v824==1
label values hk_knw_mtct_meds yesno
label var hk_knw_mtct_meds "Know that risk of HIV mother to child transmission can be reduced by the mother taking special drugs"

*** Attitudes ***

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

}


* indicators from MR file
if file=="MR" {

cap label define yesno 0"No" 1"Yes"

*** HIV related knowledge ***
//Ever heard of HIV/AIDS
gen hk_ever_heard=mv751==1
label values hk_ever_heard yesno
label var hk_ever_heard "Have ever heard of HIV or AIDS"

//Know reduce risk - use condoms
gen hk_knw_risk_cond= mv754cp==1
label values hk_knw_risk_cond yesno
label var hk_knw_risk_cond "Know you can reduce HIV risk by using condoms at every sex"

//Know reduce risk - limit to one partner
gen hk_knw_risk_sex= mv754dp==1
label values hk_knw_risk_sex yesno
label var hk_knw_risk_sex "Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners"

//Know reduce risk - use condoms and limit to one partner
gen hk_knw_risk_condsex= mv754cp==1 & mv754dp==1
label values hk_knw_risk_condsex yesno
label var hk_knw_risk_condsex "Know you can reduce HIV risk by using condoms at every sex and limiting to one uninfected partner with no other partner"

//Know healthy person can have HIV
gen hk_knw_hiv_hlth= mv756==1
label values hk_knw_hiv_hlth yesno
label var hk_knw_hiv_hlth "Know that a healthy looking person can have HIV"

//Know HIV cannot be transmitted by mosquito bites
gen hk_knw_hiv_mosq= mv754jp==0
label values hk_knw_hiv_mosq yesno
label var hk_knw_hiv_mosq "Know that HIV cannot be transmitted by mosquito bites"

//Know HIV cannot be transmitted by supernatural means
gen hk_knw_hiv_supernat= mv823==0
label values hk_knw_hiv_supernat yesno
label var hk_knw_hiv_supernat "Know that HIV cannot be transmitted by supernatural means"

//Know HIV cannot be transmitted by sharing food with HIV infected person
gen hk_knw_hiv_food= mv754wp==0
label values hk_knw_hiv_food yesno
label var hk_knw_hiv_food "Know that cannot become infected by sharing food with a person who has HIV"

//Know healthy person can have HIV and reject two common local misconceptions
gen hk_knw_hiv_hlth_2miscp= mv756==1 & mv754jp==0 & mv823==0
label values hk_knw_hiv_hlth_2miscp yesno
label var hk_knw_hiv_hlth_2miscp "Know that a healthy looking person can have HIV and reject the two most common local misconceptions"

//HIV comprehensive knowledge
gen hk_knw_comphsv= mv754cp==1 & mv754dp==1 & mv756==1 & mv754jp==0 & mv823==0
label values hk_knw_comphsv yesno
label var hk_knw_comphsv "Have comprehensive knowledge about HIV"

//Know that HIV MTCT can occur during pregnancy
gen hk_knw_mtct_preg= mv774a==1
label values hk_knw_mtct_preg yesno
label var hk_knw_mtct_preg "Know that HIV mother to child transmission can occur during pregnancy"

//Know that HIV MTCT can occur during delivery
gen hk_knw_mtct_deliv= mv774b==1
label values hk_knw_mtct_deliv yesno
label var hk_knw_mtct_deliv "Know that HIV mother to child transmission can occur during delivery"

//Know that HIV MTCT can occur during breastfeeding
gen hk_knw_mtct_brfeed= mv774c==1
label values hk_knw_mtct_brfeed yesno
label var hk_knw_mtct_brfeed "Know that HIV mother to child transmission can occur by breastfeeding"

//Know all three HIV MTCT
gen  hk_knw_mtct_all3= mv774a==1 & mv774b==1 & mv774c==1
label values hk_knw_mtct_all3 yesno
label var hk_knw_mtct_all3 "Know that HIV mother to child transmission can occur during pregnancy, delivery, and by breastfeeding"

//Know risk of HIV MTCT can be reduced by meds
gen hk_knw_mtct_meds= mv824==1
label values hk_knw_mtct_meds yesno
label var hk_knw_mtct_meds "Know that risk of HIV mother to child transmission can be reduced by the mother taking special drugs"

*** Attitudes ***

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

}
