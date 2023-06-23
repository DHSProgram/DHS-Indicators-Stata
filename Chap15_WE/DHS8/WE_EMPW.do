/*****************************************************************************************************
Program: 			WE_EMPW.do
Purpose: 			Code to compute decision making and justification of violence among in men and women
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Oct 17, 2019 by Shireen Assaf 
Note:				The indicators below can be computed for men and women. 
					The indicators we_decide_all and we_decide_none have different variable labels for men compared to women. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
we_decide_health			"Decides on own health care"
we_decide_hhpurch			"Decides on large household purchases"
we_decide_visits			"Decides on visits to family or relatives"
we_decide_health_self		"Decides on own health care either alone or jointly with partner"
we_decide_hhpurch_self		"Decides on large household purchases either alone or jointly with partner"
we_decide_visits_self		"Decides on visits to family or relatives either alone or jointly with partner"
we_decide_all				"Decides on all three: health, purchases, and visits  either alone or jointly with partner" (for women)
							"Decides on both health and purchases either alone or jointly with partner" (for men)
we_decide_none				"Does not decide on any of the three decisions either alone or jointly with partner" (for women)
							"Does not decide on health or purchases either alone or jointly with partner" (for men)
	
we_dvjustify_burn			"Agree that husband is justified in hitting or beating his wife if she burns food"
we_dvjustify_argue			"Agree that husband is justified in hitting or beating his wife if she argues with him"
we_dvjustify_goout			"Agree that husband is justified in hitting or beating his wife if she goes out without telling him"
we_dvjustify_neglect		"Agree that husband is justified in hitting or beating his wife if she neglects the children"
we_dvjustify_refusesex		"Agree that husband is justified in hitting or beating his wife if she refuses to have sexual intercourse with him"
we_dvjustify_onereas		"Agree that husband is justified in hitting or beating his wife for at least one of the reasons"
	
we_justify_refusesex		"Believe a woman is justified to refuse sex with her husband if she knows he's having sex with other women"
we_justify_cond				"Believe a women is justified in asking that her husband to use a condom if she knows that he has an STI"
we_havesay_refusesex		"Can say no to their husband if they do not want to have sexual intercourse"
we_havesay_condom			"Can ask their husband to use a condom"
	
we_num_decide				"Number of decisions made either alone or jointly with husband among women currently in a union"
we_num_justifydv			"Number of reasons for which wife beating is justified among women currently in a union"
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

cap label define yesno 0"No" 1"Yes"

*** Decision making ***

//Decides on own health
gen we_decide_health= v743a if v502==1
label values we_decide_health V743A
label var we_decide_health "Decides on own health care"

//Decides on household purchases
gen we_decide_hhpurch= v743b if v502==1
label values we_decide_hhpurch V743B
label var we_decide_hhpurch "Decides on large household purchases"

//Decides on visits
gen we_decide_visits= v743d if v502==1
label values we_decide_visits V743D
label var we_decide_visits "Decides on visits to family or relatives"

//Decides on own health either alone or jointly
gen we_decide_health_self= inlist(v743a,1,2) if v502==1
label values we_decide_health_self yesno
label var we_decide_health_self "Decides on own health care either alone or jointly with partner"

//Decides on household purchases either alone or jointly
gen we_decide_hhpurch_self= inlist(v743b,1,2) if v502==1
label values we_decide_hhpurch_self yesno
label var we_decide_hhpurch_self "Decides on large household purchases either alone or jointly with partner"

//Decides on visits either alone or jointly
gen we_decide_visits_self= inlist(v743d,1,2) if v502==1
label values we_decide_visits_self yesno
label var we_decide_visits_self "Decides on visits to family or relatives either alone or jointly with partner"

//Decides on all three: health, purchases, and visits  either alone or jointly with partner
gen we_decide_all= inlist(v743a,1,2) & inlist(v743b,1,2) & inlist(v743d,1,2) if v502==1
label values we_decide_all yesno
label var we_decide_all "Decides on all three: health, purchases, and visits  either alone or jointly with partner"

//Does not decide on any of the three decisions either alone or jointly with partner
gen we_decide_none= 0 if v502==1
replace we_decide_none=1 if (v743a!=1 & v743a!=2) & (v743b!=1 & v743b!=2) & (v743d!=1 & v743d!=2)& v502==1
label values we_decide_none yesno
label var we_decide_none "Does not decide on any of the three decisions either alone or jointly with partner"

*** Justification of violence ***

//Justify violence - burned food
gen we_dvjustify_burn= v744e==1
label values we_dvjustify_burn yesno
label var we_dvjustify_burn "Agree that husband is justified in hitting or beating his wife if she burns food"

//Justify violence - argues
gen we_dvjustify_argue= v744c==1
label values we_dvjustify_argue yesno
label var we_dvjustify_argue "Agree that husband is justified in hitting or beating his wife if she argues with him"

//Justify violence - goes out without saying
gen we_dvjustify_goout= v744a==1
label values we_dvjustify_goout yesno
label var we_dvjustify_goout "Agree that husband is justified in hitting or beating his wife if she goes out without telling him"

//Justify violence - neglects children 
gen we_dvjustify_neglect= v744b==1
label values we_dvjustify_neglect yesno
label var we_dvjustify_neglect "Agree that husband is justified in hitting or beating his wife if she neglects the children"

//Justify violence - no sex
gen we_dvjustify_refusesex= v744d==1
label values we_dvjustify_refusesex yesno
label var we_dvjustify_refusesex "Agree that husband is justified in hitting or beating his wife if she refuses to have sexual intercourse with him"

//Justify violence - at least one reason
gen we_dvjustify_onereas=0 
replace we_dvjustify_onereas=1 if v744a==1 | v744b==1 | v744c==1 | v744d==1 | v744e==1
label values we_dvjustify_onereas yesno
label var we_dvjustify_onereas "Agree that husband is justified in hitting or beating his wife for at least one of the reasons"
	
//Justify to reuse sex - he's having sex with another woman
gen we_justify_refusesex= v633b==1
label values we_justify_refusesex yesno
label var we_justify_refusesex "Believe a woman is justified to refuse sex with her husband if she knows he's having sex with other women"

//Justify to ask to use condom - he has STI
gen we_justify_cond= v822==1
label values we_justify_cond yesno
label var we_justify_cond "Believe a women is justified in asking that her husband to use a condom if she knows that he has an STI"

//Can refuse sex with husband
gen we_havesay_refusesex= v850a==1 if v502==1
label values we_havesay_refusesex yesno
label var we_havesay_refusesex "Can say no to their husband if they do not want to have sexual intercourse"

//Can ask husband to use condom
gen we_havesay_condom= v850b==1 if v502==1
label values we_havesay_condom yesno
label var we_havesay_condom "Can ask their husband to use a condom"

//Number of decisions wife makes alone or jointly
	foreach x in a b d {
	gen v743`x'2= 0
	replace v743`x'2=1 if v743`x' <3
	}
gen decisions= v743a2+v743b2+v743d2 
recode decisions (0=0 " 0") (1/2=1 " 1-2") (3=2 " 3") if v502==1, gen(we_num_decide)
label var we_num_decide "Number of decisions made either alone or jointly with husband among women currently in a union"
	drop decisions
	drop v743a2-v743d2

//Number of reasons wife beating is justified
	foreach x in a b c d e {
	gen v744`x'2=0
	replace v744`x'2=1 if v744`x'==1
	}
gen reasons= v744a2 + v744b2 + v744c2 + v744d2 + v744e2
recode reasons (0=0 " 0") (1/2=1 " 1-2") (3/4=2 " 3-4") (5=3 " 5") if v502==1, gen(we_num_justifydv)
label var we_num_justifydv "Number of reasons for which wife beating is justified among women currently in a union"
	drop reasons
	drop v744a2-v744e2
}


* indicators from MR file
if file=="MR" {

cap label define yesno 0"No" 1"Yes"

*** Decision making ***

//Decides on own health
gen we_decide_health= mv743a if mv502==1
label values we_decide_health MV743A
label var we_decide_health "Decides on own health care"

//Decides on household purchases
gen we_decide_hhpurch= mv743b if mv502==1
label values we_decide_hhpurch MV743B
label var we_decide_hhpurch "Decides on large household purchases"

//Decides on visits
gen we_decide_visits= mv743d if mv502==1
label values we_decide_visits MV743D
label var we_decide_visits "Decides on visits to family or relatives"

//Decides on own health either alone or jointly
gen we_decide_health_self= inlist(mv743a,1,2) if mv502==1
label values we_decide_health_self yesno
label var we_decide_health_self "Decides on own health care either alone or jointly with partner"

//Decides on household purchases either alone or jointly
gen we_decide_hhpurch_self= inlist(mv743b,1,2) if mv502==1
label values we_decide_hhpurch_self yesno
label var we_decide_hhpurch_self "Decides on large household purchases either alone or jointly with partner"

//Decides on visits either alone or jointly
gen we_decide_visits_self= inlist(mv743d,1,2) if mv502==1
label values we_decide_visits_self yesno
label var we_decide_visits_self "Decides on visits to family or relatives either alone or jointly with partner"

//Decides on both health and household purchases either alone or jointly
gen we_decide_all= inlist(mv743a,1,2) & inlist(mv743b,1,2) if mv502==1
label values we_decide_all yesno
label var we_decide_all "Decides on both health and purchases either alone or jointly with partner"

//Does not decide on health or household purchases
gen we_decide_none= 0 if mv502==1
replace we_decide_none=1 if (mv743a!=1 & mv743a!=2) & (mv743b!=1 & mv743b!=2) & mv502==1
label values we_decide_none yesno
label var we_decide_none "Does not decide on health or purchases either alone or jointly with partner"

*** Justification of violence ***

//Jusity violence - burned food
gen we_dvjustify_burn= mv744e==1
label values we_dvjustify_burn yesno
label var we_dvjustify_burn "Agree that husband is justified in hitting or beating his wife if she burns food"

//Jusity violence - argues
gen we_dvjustify_argue= mv744c==1
label values we_dvjustify_argue yesno
label var we_dvjustify_argue "Agree that husband is justified in hitting or beating his wife if she argues with him"

//Jusity violence - goes out without saying
gen we_dvjustify_goout= mv744a==1
label values we_dvjustify_goout yesno
label var we_dvjustify_goout "Agree that husband is justified in hitting or beating his wife if she goes out without telling him"

//Jusity violence - neglects children 
gen we_dvjustify_neglect= mv744b==1
label values we_dvjustify_neglect yesno
label var we_dvjustify_neglect "Agree that husband is justified in hitting or beating his wife if she neglects the children"

//Jusity violence - no sex
gen we_dvjustify_refusesex= mv744d==1
label values we_dvjustify_refusesex yesno
label var we_dvjustify_refusesex "Agree that husband is justified in hitting or beating his wife if she refuses to have sexual intercourse with him"

//Jusity violence - at least one reason
gen we_dvjustify_onereas=0 
replace we_dvjustify_onereas=1 if mv744a==1 | mv744b==1 | mv744c==1 | mv744d==1 | mv744e==1
label values we_dvjustify_onereas yesno
label var we_dvjustify_onereas "Agree that husband is justified in hitting or beating his wife for at least one of the reasons"

//Jusity to reuse sex - he's having sex with another woman
gen we_justify_refusesex= mv633b==1
label values we_justify_refusesex yesno
label var we_justify_refusesex "Believe a woman is justified to refuse sex with her husband if she knows he's having sex with other women"

//Jusity to ask to use condom - he has STI
gen we_justify_cond= mv822==1
label values we_justify_cond yesno
label var we_justify_cond "Believe a women is justified in asking that her husband to use a condom if she knows that he has an STI"

}
