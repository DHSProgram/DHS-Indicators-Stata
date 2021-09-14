/*****************************************************************************************************
Program: 			RH_probs.do
Purpose: 			Code indicators on problems accessing health care for women
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 21 2018 by Shireen Assaf 
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:
rh_prob_permit		"Problem health care access: permission to go"
rh_prob_money		"Problem health care access: getting money"
rh_prob_dist		"Problem health care access: distance to facility"
rh_prob_alone		"Problem health care access: not wanting to go alone"
rh_prob_minone		"At least one problem in accessing health care"
/----------------------------------------------------------------------------*/


//Permission to go 
	recode v467b (0 2 9 = 0 "No") (1 = 1 "Yes"), gen(rh_prob_permit)
	label var rh_prob_permit "Problem health care access: permission to go"

//Getting money
	recode v467c (0 2 9 = 0 "No") (1 = 1 "Yes"), gen(rh_prob_money)
	label var rh_prob_money "Problem health care access: getting money"
	
//Distance to facility
	recode v467d (0 2 9 = 0 "No") (1 = 1 "Yes"), gen(rh_prob_dist)
	label var rh_prob_dist "Problem health care access: distance to facility"
	
//Not wanting to go alone
	recode v467f (0 2 9 = 0 "No") (1 = 1 "Yes"), gen(rh_prob_alone)
	label var rh_prob_alone "Problem health care access: not wanting to go alone"
	
//At least one problem
	gen rh_prob_minone = rh_prob_permit+rh_prob_money+rh_prob_dist+rh_prob_alone
	replace rh_prob_minone = 1 if rh_prob_minone>=1 
	cap label define yesno 0 "No" 1 "Yes"
	label values rh_prob_minone yesno
	label var rh_prob_minone "At least one problem in accessing health care"
	
 
 
 