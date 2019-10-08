/*****************************************************************************************************
Program: 			FP_COMM.do
Purpose: 			Code communication related indicators: exposure to FP messages, decision on use/nonuse, discussions. 
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Feb 5 2019 by Shireen Assaf, added men's code 

Notes:				For men (MR file) only the FP messages indicators are created. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
fp_message_radio		"Exposure to family planning message by radio"
fp_message_tv			"Exposure to family planning message by TV"
fp_message_paper		"Exposure to family planning message by newspaper/magazine"
fp_message_mobile		"Exposure to family planning message by mobile phone"
fp_message_noneof4		"Not exposed to any of the four media sources"
fp_message_noneof3 		"Not exposed to TV, radio, or paper media sources"

fp_decyes_user			"Who makes the decision to use family planning among users"
fp_decno_nonuser		"Who makes decision not to use family planning among non-users"

fp_fpvisit_discuss		"Women non-users that were visited by a FP worker who discussed FP"
fp_hf_discuss			"Women non-users who visited a health facility in last 12 months and discussed FP"
fp_hf_notdiscuss		"Women non-users who visited a health facility in last 12 months and did not discuss FP"
fp_any_notdiscuss		"Women non-users who did not discuss FP neither with FP worker or in a health facility"
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
cap gen fp_message_mobile = v384d==1
cap label var fp_message_mobile "Exposure to family planning message by mobile phone"

//Did not hear a family planning message from any of the 4 media sources
cap gen fp_message_noneof4 = 0
cap replace fp_message_noneof4 =1 if (v384a!=1 & v384b!=1 & v384c!=1 &v384d!=1)
cap label var fp_message_noneof4 "Not exposed to any of the four media sources (TV, radio, paper, mobile)"

//Did not hear a family planning message from radio, TV or paper
gen fp_message_noneof3=0
replace fp_message_noneof3 =1 if (v384a!=1 & v384b!=1 & v384c!=1)
label var fp_message_noneof3 "Not exposed to TV, radio, or paper media sources"

*** Family Planning decision making and discussion ***

//Decision to use among users
gen fp_decyes_user = v632
replace fp_decyes_user = . if (v502!=1 | v213!=0 | v312==0)
label values fp_decyes_user V632
label var fp_decyes_user "Who makes the decision to use family planning among users"

//Decision to not use among non users
gen fp_decno_nonuser = v632a
replace fp_decno_nonuser = . if (v502!=1 | v213!=0 | v312!=0)
label values fp_decno_nonuser V632
label var fp_decno_nonuser "Who makes decision not to use family planning among non-users"

//Discussed with FP worker
gen fp_fpvisit_discuss = v393a==1
replace fp_fpvisit_discuss = . if v312!=0
label var fp_fpvisit_discuss "Women non-users that were visited by a FP worker who discussed FP"

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
label var fp_any_notdiscuss "Women non-users who did not discuss FP neither with FP worker or in a health facility"

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

//Did not hear a family planning message from any of the 4 media sources
cap gen fp_message_noneof4 = 0
cap replace fp_message_noneof4 = 1 if (mv384a!=1 & mv384b!=1 & mv384c!=1 & mv384d!=1)
cap label var fp_message_noneof4 "Not exposed to any of the four media sources"

//Did not hear a family planning message from radio, TV or paper
gen fp_message_noneof3 = 0
replace fp_message_noneof3 = 1 if (mv384a!=1 & mv384b!=1 & mv384c!=1)
label var fp_message_noneof3 "Not exposed to TV, radio, or paper media sources"

}
