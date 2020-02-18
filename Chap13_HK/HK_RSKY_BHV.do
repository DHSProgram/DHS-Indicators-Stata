/*****************************************************************************************************
Program: 			HK_RSKY_BHV.do
Purpose: 			Code to compute Multiple Sexual Partners, Higher-Risk Sexual Partners, and Condom Use
Data inputs: 		IR or MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Oct 29, 2019 by Shireen Assaf 
Note:				The indicators below can be computed for men and women. 
					For women and men the indicators are computed for age 15-49 in line 34 and 83. 
					This can be commented out if the indicators are required for all women/men or can be changed to select for age 15-24.	
					
					For the indicator hk_cond_notprtnr, please see the DHS guide to statistics for changes over time.
					The current code will only match recent surveys. 					
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_sex_2plus		"Have two or more sexual partners in the past 12 months"
hk_sex_notprtnr		"Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months"
hk_cond_2plus		"Have two or more sexual partners in the past 12 months and used a condom at last sex"
hk_cond_notprtnr	"Used a condom at last sex with a partner that is not their spouce and does not live with them in the past 12 months"
hk_sexprtnr_mean 	"Mean number of sexual partners"

*only among men	
hk_paid_sex_ever	"Ever paid for sex among men 15-49"
hk_paid_sex_12mo	"Paid for sex in the past 12 months among men 15-49"
hk_paid_sex_cond	"Used a condom at last paid sexual intercourse in the past 12 months among men 15-49"
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

* limiting to women age 15-49
drop if v012>49

cap label define yesno 0"No" 1"Yes"

**********************************
//Two or more sexual partners
gen hk_sex_2plus= (inrange(v527,100,251) | inrange(v527,300,311)) & inrange(v766b,2,99) 
label values hk_sex_2plus yesno
label var hk_sex_2plus "Have two or more sexual partners in the past 12 months"

//Had sex with a person that was not their partner
*last partner
gen risk1= (inrange(v527,100,251) | inrange(v527,300,311)) & (inrange(v767a,2,6) | inlist(v767a,8,96))
*next-to-last-partner
gen risk2= (inrange(v527,100,251) | inrange(v527,300,311)) & (inrange(v767b,2,6) | inlist(v767b,8,96))
*third-to-last-partner
gen risk3= (inrange(v527,100,251) | inrange(v527,300,311)) & (inrange(v767c,2,6) | inlist(v767c,8,96))
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

//Mean number of sexual partners
summarize v836 if inrange(v836,1,95) [fweight=v005], detail
gen hk_sexprtnr_mean=r(mean)
label var hk_sexprtnr_mean "Mean number of sexual partners"

}


* indicators from MR file
if file=="MR" {

* limiting to men age 15-49
drop if mv012>49

cap label define yesno 0"No" 1"Yes"
***********************************

//Two or more sexual partners
gen hk_sex_2plus= (inrange(mv527,100,251) | inrange(mv527,300,311)) & inrange(mv766b,2,99) 
label values hk_sex_2plus yesno
label var hk_sex_2plus "Have two or more sexual partners in the past 12 months"

//Had sex with a person that was not their partner
*last partner
gen risk1= (inrange(mv527,100,251) | inrange(mv527,300,311)) & (inrange(mv767a,2,6) | inlist(mv767a,8,96))
*next-to-last-partner
gen risk2= (inrange(mv527,100,251) | inrange(mv527,300,311)) & (inrange(mv767b,2,6) | inlist(mv767b,8,96))
*third-to-last-partner
gen risk3= (inrange(mv527,100,251) | inrange(mv527,300,311)) & (inrange(mv767c,2,6) | inlist(mv767c,8,96))
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

//Mean number of sexual partners
summarize mv836 if inrange(mv836,1,95) [fweight=mv005], detail
gen hk_sexprtnr_mean=r(mean)
label var hk_sexprtnr_mean "Mean number of sexual partners"

//Ever paid for sex
gen hk_paid_sex_ever= mv791==1
label values hk_paid_sex_ever yesno	
label var hk_paid_sex_ever "Ever paid for sex among men 15-49"

//Paid for sex in the last 12 months
gen hk_paid_sex_12mo= mv793==1
label values hk_paid_sex_12mo yesno
label var hk_paid_sex_12mo "Paid for sex in the past 12 months among men 15-49"

//Used a condom at last paid sex in the last 12 months
gen hk_paid_sex_cond= 0 if mv793==1 
replace hk_paid_sex_cond= 1 if mv793a==1
label values hk_paid_sex_cond yesno
label var hk_paid_sex_cond "Used a condom at last paid sexual intercourse in the past 12 months among men 15-49"

}
