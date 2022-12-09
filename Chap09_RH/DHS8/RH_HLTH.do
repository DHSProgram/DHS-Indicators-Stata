/*****************************************************************************************************
Program: 			RH_HLTH.do - DHS8 update
Purpose: 			Code indicators on health indicators and problems accessing health care for women
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 9, 2022 by Shireen Assaf 
Notes:				Four new indicators in DHS8, see below. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:

rh_brst_cncr_exam	"Ever examined by health worker for breast cancer" - NEW Indicator in DHS8
rh_cervc_cancr_test	"Ever tested for cervical cancer" - NEW Indicator in DHS8

rh_traveltime_hlthfacil	"Travel time to nearest health facility" - NEW Indicator in DHS8
rh_transport_hlthfacil	"Means of transport to nearest facility" - NEW Indicator in DHS8

rh_prob_permit		"Problem health care access: permission to go"
rh_prob_money		"Problem health care access: getting money"
rh_prob_dist		"Problem health care access: distance to facility"
rh_prob_alone		"Problem health care access: not wanting to go alone"
rh_prob_minone		"At least one problem in accessing health care"
/----------------------------------------------------------------------------*/

//Ever had breast cancer exam - NEW Indicator in DHS8
gen rh_brst_cncr_exam = v484a ==1
label values rh_brst_cncr_exam yesno
label var rh_brst_cncr_exam	"Ever examined by health worker for breast cancer"

//Ever had cervical cancer test - NEW Indicator in DHS8
gen rh_cervc_cancr_test = v484b ==1
label values rh_cervc_cancr_test yesno
label var rh_cervc_cancr_test "Ever tested for cervical cancer"

//Travel time to nearest health facility - NEW Indicator in DHS8
recode v483a (0/29=1 " <30mins") (30/59=2 " 30-59mins") (60/119=3 "  60-119mins") (120/900=4 " >=2 hours") , gen(rh_traveltime_hlthfacil)
label var rh_traveltime_hlthfacil	"Travel time to nearest health facility"

//Means of transport to nearest facility - NEW Indicator in DHS8
recode v483b (11/19=1 "motorized") (21/29=2 "not motorized") (96=3 "other"), gen(rh_transport_hlthfacil)
label var rh_transport_hlthfacil "Means of transport to nearest facility"


*** Problems accessing health care for self ***

//Permission to go 
	recode v467b (0 2 9 .= 0 "No") (1 = 1 "Yes"), gen(rh_prob_permit)
	label var rh_prob_permit "Problem health care access: permission to go"

//Getting money
	recode v467c (0 2 9 . = 0 "No") (1 = 1 "Yes"), gen(rh_prob_money)
	label var rh_prob_money "Problem health care access: getting money"
	
//Distance to facility
	recode v467d (0 2 9 . = 0 "No") (1 = 1 "Yes"), gen(rh_prob_dist)
	label var rh_prob_dist "Problem health care access: distance to facility"
	
//Not wanting to go alone
	recode v467f (0 2 9 .= 0 "No") (1 = 1 "Yes"), gen(rh_prob_alone)
	label var rh_prob_alone "Problem health care access: not wanting to go alone"
	
//At least one problem
	gen rh_prob_minone = rh_prob_permit+rh_prob_money+rh_prob_dist+rh_prob_alone
	replace rh_prob_minone = 1 if rh_prob_minone>=1 
	cap label define yesno 0 "No" 1 "Yes"
	label values rh_prob_minone yesno
	label var rh_prob_minone "At least one problem in accessing health care"
	
 
 
 