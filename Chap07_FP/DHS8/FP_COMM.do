/*****************************************************************************************************
Program: 			FP_COMM.do - DHS8 update
Purpose: 			Code communication related indicators: exposure to FP messages, decision on use/nonuse, discussions. 
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: November 8, 2022  by Shireen Assaf 
Notes:				Eight new indicators for DH8, see below. 
					For men (MR file) only the FP messages indicators are created. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
fp_message_radio		"Exposure to family planning message by radio"
fp_message_tv			"Exposure to family planning message by TV"
fp_message_paper		"Exposure to family planning message by newspaper/magazine"
fp_message_mobile		"Exposure to family planning message by mobile phone"
fp_message_socialm		"Exposure to family planning message by social media" - NEW Indicator in DHS8
fp_message_poster		"Exposure to family planning message by poster/leaflet/brochure" - NEW Indicator in DHS8
fp_message_signs		"Exposure to family planning message by outdoor sign/billboard" - NEW Indicator in DHS8
fp_message_comnty		"Exposure to family planning message by community meetings or events" - NEW Indicator in DHS8
fp_message_noneof8		"Not exposed to any of the eight media sources" - NEW Indicator in DHS8

fp_dec_who				"Who makes the decision to use or not use family planning" - NEW Indicator in DHS8
fp_dec_wm				"Woman participated in decisionmaking about family planning" - NEW Indicator in DHS8

fp_preg_pressure		"Pressured by husbands/partners or other family to get pregnant when they did not want to" - NEW Indicator in DHS8

fp_fpvisit_discuss		"Women non-users that were visited by a FP worker in last 12 months who discussed FP"
fp_hf_discuss			"Women non-users who visited a health facility in last 12 months and discussed FP"
fp_hf_notdiscuss		"Women non-users who visited a health facility in last 12 months and did not discuss FP"
fp_any_notdiscuss		"Women non-users who did not discuss FP neither with FP worker or in a health facility in last 12 months"
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

*** Family planning messages ***

//Family planning messages by radio
gen fp_message_radio = v384a==1
label var fp_message_radio "Exposure to family planning message by radio"

//Family planning messages by TV
gen fp_message_tv = v384b==1
label var fp_message_tv "Exposure to family planning message by TV"

//Family planning messages by newspaper and/or magazine
gen fp_message_paper = v384c==1
label var fp_message_paper "Exposure to family planning message by newspaper/magazine"

//Family planning messages by mobile
gen fp_message_mobile = v384d==1
label var fp_message_mobile "Exposure to family planning message by mobile phone"

//Family planning messages by social media - NEW Indicator in DHS8
gen fp_message_socialm = v384e==1
label var fp_message_socialm "Exposure to family planning message by social media" 

//Family planning messages by poster/leaflet/brochure - NEW Indicator in DHS8
gen fp_message_poster = v384f==1
label var fp_message_poster	"Exposure to family planning message by poster/leaflet/brochure" 

//Family planning messages by  outdoor sign/billboard" - NEW Indicator in DHS8
gen fp_message_signs = v384g==1
label var fp_message_signs "Exposure to family planning message by outdoor sign/billboard" 

//Family planning messages by community meetings or events - NEW Indicator in DHS8
gen fp_message_comnty = v384h==1
label var fp_message_comnty	"Exposure to family planning message by community meetings or events" 

//Did not hear a family planning message from any of the eight media sources - NEW Indicator in DHS8
gen fp_message_noneof8=0
replace fp_message_noneof8 =1 if (v384a!=1 & v384b!=1 & v384c!=1 & v384d!=1 & v384e!=1 & v384f!=1 & v384g!=1 & v384h!=1)
label var fp_message_noneof8 "Not exposed to any of the eight media sources" 

*** Family Planning decision making and discussion ***

//Who makes decision to use family planning - NEW Indicator in DHS8
gen fp_dec_who = v632 
replace fp_dec_who = 4 if fp_dec_who==6
replace fp_dec_who = . if (v502!=1 | v213!=0)
label values fp_dec_who V632
label var fp_dec_who "Who makes the decision to use or not use family planning" 

//Woman participated in decisionmaking about family planning - NEW Indicator in DHS8
gen fp_dec_wm = v632==1 | v632==3 
replace fp_dec_wm = . if (v502!=1 | v213!=0)
label var fp_dec_wm	"Woman participated in decisionmaking about family planning" 

//Pressured to get pregnant - NEW Indicator in DHS8
gen fp_preg_pressure = v636==1
replace fp_preg_pressure=. if v502!=1 
label var fp_preg_pressure "Pressured by husbands/partners or other family to get pregnant when they did not want to" 

//Discussed with FP worker
gen fp_fpvisit_discuss = v393a==1
replace fp_fpvisit_discuss = . if v312!=0
label var fp_fpvisit_discuss "Women non-users that were visited by a FP worker in last 12 months who discussed FP"

//Discussed FP in a health facility
gen fp_hf_discuss = (v394==1 & v395==1)
replace fp_hf_discuss=. if v312!=0
label var fp_hf_discuss "Women non-users who visited a health facility in last 12 months and discussed FP"

//Did not discuss FP in health facility
gen fp_hf_notdiscuss = (v394==1 & v395!=1)
replace fp_hf_notdiscuss=. if v312!=0
label var fp_hf_notdiscuss "Women non-users who visited a health facility in last 12 months and did not discuss FP"

//Did not discuss FP in health facility or with FP worker
gen fp_any_notdiscuss = (v393a!=1 & v395!=1)
replace fp_any_notdiscuss=. if v312!=0
label var fp_any_notdiscuss "Women non-users who did not discuss FP neither with FP worker or in a health facility in last 12 months"

}

* indicators from MR file
if file=="MR" {

*** Family planning messages ***

//Family planning messages by radio
gen fp_message_radio = mv384a==1
label var fp_message_radio "Exposure to family planning message by radio"

//Family planning messages by TV
gen fp_message_tv = mv384b==1
label var fp_message_tv "Exposure to family planning message by TV"

//Family planning messages by newspaper and/or magazine
gen fp_message_paper = mv384c==1
label var fp_message_paper "Exposure to family planning message by newspaper/magazine"

//Family planning messages by mobile
cap gen fp_message_mobile = mv384d==1
cap label var fp_message_mobile "Exposure to family planning message by mobile phone"

//Family planning messages by social media - NEW Indicator in DHS8
gen fp_message_socialm = mv384e==1
label var fp_message_socialm "Exposure to family planning message by social media" 

//Family planning messages by poster/leaflet/brochure - NEW Indicator in DHS8
gen fp_message_poster = mv384f==1
label var fp_message_poster	"Exposure to family planning message by poster/leaflet/brochure" 

//Family planning messages by  outdoor sign/billboard" - NEW Indicator in DHS8
gen fp_message_signs = mv384g==1
label var fp_message_signs "Exposure to family planning message by outdoor sign/billboard" 

//Family planning messages by community meetings or events - NEW Indicator in DHS8
gen fp_message_comnty = mv384h==1
label var fp_message_comnty	"Exposure to family planning message by community meetings or events" 

//Did not hear a family planning message from any of the eight media sources - NEW Indicator in DHS8
gen fp_message_noneof8=0
replace fp_message_noneof8 =1 if (mv384a!=1 & mv384b!=1 & mv384c!=1 & mv384d!=1 & mv384e!=1 & mv384f!=1 & mv384g!=1 & mv384h!=1)
label var fp_message_noneof8 "Not exposed to any of the eight media sources" 

}
