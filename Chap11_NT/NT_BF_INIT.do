/*****************************************************************************************************
Program: 			NT_BF_INIT.do
Purpose: 			Code to compute initial breastfeeding indicators
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 10, 2020 by Courtney Allen
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_bf_ever			"Ever breastfed - last-born in the past 2 years"
nt_bf_start_1hr		"Started breastfeeding within one hour of birth - last-born in the past 2 years"
nt_bf_start_1day	"Started breastfeeding within one day of birth - last-born in the past 2 years"
nt_bf_prelac		"Received a prelacteal feed - last-born in the past 2 years ever breast fed"

nt_bottle			"Drank from a bottle with a nipple yesterday - under 2 years"
----------------------------------------------------------------------------*/

// INITIAL BREASTFEEDING

	//Ever breastfed
	gen nt_bf_ever= (m4!=94 & m4!=99) if ( b19<24)
	label values nt_bf_ever yesno 
	label var nt_bf_ever "Ever breastfed - last-born in the past 2 years"
	
	//Start breastfeeding within 1 hr
	gen nt_bf_start_1hr= (inrange(m34,0,100)) if (midx==1 & age<24)
	label values nt_bf_start_1hr yesno
	label var nt_bf_start_1hr "Started breastfeeding within one hour of birth - last-born in the past 2 years"

	//Start breastfeeding within 1 day
	gen nt_bf_start_1day= (inrange(m34,0,123)) if (midx==1 & age<24)
	label values nt_bf_start_1day  yesno
	label var nt_bf_start_1day	"Started breastfeeding within one day of birth - last-born in the past 2 years"

	//Given prelacteal feed
	gen nt_bf_prelac= (m4!=94 & m4!=99) & m55==1 if (midx==1 & age<24 & m4!=94 & m4!=99)
	label values nt_bf_prelac yesno
	label var nt_bf_prelac "Received a prelacteal feed - last-born in the past 2 years ever breast fed"

	//Using bottle with nipple 
	gen nt_bottle= m38==1 if b5==1 & age<24
	label values nt_bottle yesno
	label var nt_bottle "Drank from a bottle with a nipple yesterday - under 2 years"
