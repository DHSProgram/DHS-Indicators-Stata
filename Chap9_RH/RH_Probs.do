/*****************************************************************************************************
Program: 			RH_probs.do
Purpose: 			Code indicators on problems accessing health care for women
Data inputs: 		IR survey list
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
	recode v467b (0 2 9 = 0 "no prob") (1 = 1 "prob"), gen(rh_prob_permit)
	label var rh_prob_permit "Problem health care access: permission to go"

//getting money
	recode v467c (0 2 9 = 0 "no prob") (1 = 1 "prob"), gen(rh_prob_money)
	label var rh_prob_money "Problem health care access: getting money"
	
//distance to facility
	recode v467d (0 2 9 = 0 "no prob") (1 = 1 "prob"), gen(rh_prob_dist)
	label var rh_prob_dist "Problem health care access: distance to facility"
	
//not wanting to go alone
	recode v467f (0 2 9 = 0 "no prob") (1 = 1 "prob"), gen(rh_prob_alone)
	label var rh_prob_alone "Problem health care access: not wanting to go alone"
	
//at least one problem
	gen rh_prob_minone = rh_prob_permit+rh_prob_money+rh_prob_dist+rh_prob_alone
	replace rh_prob_minone = 1 if rh_prob_minone>1 
	label var rh_prob_minone "At least one problem in accessing health care"
	
 
 
 