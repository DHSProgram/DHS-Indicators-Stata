/*****************************************************************************************************
Program: 			HK_RSKY_BHV.do - DHS8 update
Purpose: 			Code to compute Multiple Sexual Partners, Higher-Risk Sexual Partners, and Condom Use
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: July 5, 2023 by Shireen Assaf
Note:				The indicators below can be computed for men and women. No age selection is made here. 	
					
					For the indicator hk_cond_notprtnr, please see the DHS guide to statistics for changes over time.
					The current code will only match recent surveys. 		
					
					Several indicators have been discontiued in DHS8. Please check the excel indicator list for these indicators. 

*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_sex_2plus		"Have two or more sexual partners in the past 12 months"
hk_sex_notprtnr		"Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months"
hk_cond_2plus		"Have two or more sexual partners in the past 12 months and used a condom at last sex"
hk_cond_notprtnr	"Used a condom at last sex with a partner that is not their spouce and does not live with them in the past 12 months"
hk_sexprtnr_mean 	"Mean number of lifetime sexual partners" - this is a scalar not a variable
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

cap label define yesno 0"No" 1"Yes"

**********************************
//Two or more sexual partners
gen hk_sex_2plus= (inrange(v527,100,251) | inrange(v527,300,311)) & inrange(v766b,2,99) 
label values hk_sex_2plus yesno
label var hk_sex_2plus "Have two or more sexual partners in the past 12 months"

//Had sex with a person that was not their partner
*last partner
gen risk1= (inrange(v527,100,251) | inrange(v527,300,311)) & (inrange(v767a,2,6) | v767a==96)
*next-to-last-partner
gen risk2= (inrange(v527,100,251) | inrange(v527,300,311)) & (inrange(v767b,2,6) | v767b==96)
*third-to-last-partner
gen risk3= (inrange(v527,100,251) | inrange(v527,300,311)) & (inrange(v767c,2,6) | v767c==96)
*combining all partners
gen hk_sex_notprtnr=risk1>0|risk2>0|risk3>0
label values hk_sex_notprtnr yesno
label var hk_sex_notprtnr "Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months"

//Have two or more sexual partners and used condom at last sex
gen hk_cond_2plus= (inrange(v527,100,251) | inrange(v527,300,311)) & inrange(v766b,2,99) & v761==1
replace hk_cond_2plus=. if v766b<2
label values hk_cond_2plus yesno
label var hk_cond_2plus "Have two or more sexual partners in the past 12 months and used a condom at last sex"

//Had sex with a person that was not their partner and used condom
gen hk_cond_notprtnr=0 if hk_sex_notprtnr==1
*see risk1, risk2, and risk3 variables above
replace hk_cond_notprtnr=1 if risk1==1 & v761==1
replace hk_cond_notprtnr=1 if risk1!=1 & risk2==1 & v761b==1
replace hk_cond_notprtnr=1 if risk1!=1 & risk2!=1 & risk3==1 & v761c==1
label values hk_cond_notprtnr yesno
label var hk_cond_notprtnr "Used a condom at last sex with a partner that is not their spouce and does not live with them in the past 12 months"

//Mean number of lifetime sexual partners
summarize v836 if inrange(v836,1,95) [fweight=v005], detail
gen hk_sexprtnr_mean=r(mean)
label var hk_sexprtnr_mean "Mean number of lifetime sexual partners"

}


* indicators from MR file
if file=="MR" {

cap label define yesno 0"No" 1"Yes"
***********************************

//Two or more sexual partners
gen hk_sex_2plus= (inrange(mv527,100,251) | inrange(mv527,300,311)) & inrange(mv766b,2,99) 
label values hk_sex_2plus yesno
label var hk_sex_2plus "Have two or more sexual partners in the past 12 months"

//Had sex with a person that was not their partner
*last partner
gen risk1= (inrange(mv527,100,251) | inrange(mv527,300,311)) & (inrange(mv767a,2,6) | mv767a==96)
*next-to-last-partner
gen risk2= (inrange(mv527,100,251) | inrange(mv527,300,311)) & (inrange(mv767b,2,6) | mv767b==96)
*third-to-last-partner
gen risk3= (inrange(mv527,100,251) | inrange(mv527,300,311)) & (inrange(mv767c,2,6) | mv767c==96)
*combining all partners
gen hk_sex_notprtnr=risk1>0|risk2>0|risk3>0
label values hk_sex_notprtnr yesno
label var hk_sex_notprtnr "Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months"

//Have two or more sexual partners and used condom at last sex
gen hk_cond_2plus= (inrange(mv527,100,251) | inrange(mv527,300,311)) & inrange(mv766b,2,99) & mv761==1
replace hk_cond_2plus=. if mv766b<2
label values hk_cond_2plus yesno
label var hk_cond_2plus "Have two or more sexual partners in the past 12 months and used a condom at last sex"

//Had sex with a person that was not their partner and used condom
gen hk_cond_notprtnr=0 if hk_sex_notprtnr==1
*see risk1, risk2, and risk3 variables above
replace hk_cond_notprtnr=1 if risk1==1 & mv761==1
replace hk_cond_notprtnr=1 if risk1!=1 & risk2==1 & mv761b==1
replace hk_cond_notprtnr=1 if risk1!=1 & risk2!=1 & risk3==1 & mv761c==1
label values hk_cond_notprtnr yesno
label var hk_cond_notprtnr "Used a condom at last sex with a partner that is not their spouse and does not live with them in the past 12 months"

//Mean number of lifetime sexual partners
summarize mv836 if inrange(mv836,1,95) [fweight=mv005], detail
gen hk_sexprtnr_mean=r(mean)
label var hk_sexprtnr_mean "Mean number of lifetime sexual partners"

}
