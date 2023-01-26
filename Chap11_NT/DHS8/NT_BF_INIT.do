/*****************************************************************************************************
Program: 			NT_BF_INIT.do
Purpose: 			Code to compute initial breastfeeding indicators - DHS8 update
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: November 11, 2022 by Shireen Assaf
Note:				One new indicator for DH8, see below. 
					Three indicators for currently and continued breastfeeding were moved to this do file from the IYCF do file in pervious version of the code. These indicators no longer select for the youngest child living with the mother but is for all children but with specific age groups for each indicator. 
			
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_bf_ever			"Ever breastfed - children age 0-23 months"
nt_bf_start_1hr		"Started breastfeeding within one hour of birth - children age 0-23 months"
nt_bf_start_1day	"Started breastfeeding within one day of birth - children age 0-23 months"
nt_bf_prelac		"Received a prelacteal feed - ever breast fed children age 0-23 months"
nt_bottle			"Drank from a bottle with a nipple yesterday - children age 0-23 months"
nt_ebf_2days		"Exclusively breastfed in the first 2 days after birth - children 0-23 months" - NEW Indicator in DHS8

nt_bf_curr			"Currently breastfeeding - children age 12-23 months"
nt_bf_cont_1yr		"Continuing breastfeeding at 1 year"
nt_bf_cont_2yr		"Continuing breastfeeding at 2 year"
----------------------------------------------------------------------------*/
cap label define yesno 0"No" 1"Yes"

// INITIAL BREASTFEEDING

	//Ever breastfed
	gen nt_bf_ever= (m4!=94 & m4!=99) if (age<24)
	label values nt_bf_ever yesno 
	label var nt_bf_ever "Ever breastfed - children age 0-23 months"

	//Start breastfeeding within 1 hr
	gen nt_bf_start_1hr= (inrange(m34,0,100)) if (age<24)
	label values nt_bf_start_1hr yesno
	label var nt_bf_start_1hr "Started breastfeeding within one hour of birth - children age 0-23 months"

	//Start breastfeeding within 1 day
	gen nt_bf_start_1day= (inrange(m34,0,123)) if (age<24)
	label values nt_bf_start_1day  yesno
	label var nt_bf_start_1day	"Started breastfeeding within one day of birth - children age 0-23 months"

	//Given prelacteal feed
	gen nt_bf_prelac= (m4!=94 & m4!=99) & m55==1 if (age<24 & m4!=94 & m4!=99)
	label values nt_bf_prelac yesno
	label var nt_bf_prelac "Received a prelacteal feed - ever breast fed children age 0-23 months"

	//Using bottle with nipple 
	gen nt_bottle= m38==1 if age<24
	label values nt_bottle yesno
	label var nt_bottle "Drank from a bottle with a nipple yesterday - children age 0-23 months"

	//Exclusively breastfed in the first 2 days after birth - NEW Indicator in DHS8
	gen nt_ebf_2days= (m4!=94 & m4!=99 & m55==0 ) if (age<24)
	label values nt_ebf_2days yesno
	label var nt_ebf_2days "Exclusively breastfed in the first 2 days after birth - children 0-23 months"
	
	//Currently breastfed
	gen nt_bf_curr= m4==95 
	replace nt_bf_curr=. if !inrange(age,12,23)
	label values nt_bf_curr yesno
	label var nt_bf_curr "Currently breastfeeding - children age 12-23 months"
	
	//Continuing breastfeeding at 1 year
	gen nt_bf_cont_1yr= m4==95 
	replace nt_bf_cont_1yr=. if !inrange(age,12,15)
	label values nt_bf_cont_1yr yesno
	label var nt_bf_cont_1yr "Continuing breastfeeding at 1 year (12-15 months)"

	//Continuing breastfeeding at 2 years
	gen nt_bf_cont_2yr= m4==95 
	replace nt_bf_cont_2yr=. if !inrange(age,20,23)
	label values nt_bf_cont_2yr yesno
	label var nt_bf_cont_2yr "Continuing breastfeeding at 2 year (20-23 months)"
	