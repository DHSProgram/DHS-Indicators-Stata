/*****************************************************************************************************
Program: 			WE_ASSETS.do
Purpose: 			Code to compute employment, earnings, and asset ownership in men and women
Data inputs: 		IR or MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Oct 17, 2019 by Shireen Assaf 
Note:				The indicators below can be computed for men and women. 
					For women and men the indicator is computed for age 15-49 in line 33 and 111. This can be commented out if the indicators are required for all women/men.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
we_empl				"Employment status in the last 12 months among those currently in a union"
we_empl_earn		"Type of earnings among those employed in the past 12 months and currently in a union"
we_earn_wm_decide	"Who descides on wife's cash earnings for employment in the last 12 months"
we_earn_wm_compare	"Comparison of cash earnings with husband's cash earnings"
we_earn_mn_decide	"Who descides on husband's cash earnings for employment in the last 12 months among men currently in a union"
we_earn_hs_decide	"Who descides on husband's cash earnings for employment in the last 12 months among women currently in a union"
we_own_house		"Ownership of housing"
we_own_land			"Ownership of land"
we_house_deed		"Title or deed possesion for owned house"
we_land_deed		"Title or deed possesion for owned land"
we_bank				"Use an account in a bank or other financial institution"
we_mobile			"Own a mobile phone"
we_mobile_finance	"Use mobile phone for financial transactions"
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

* limiting to women age 15-49
drop if v012>49

cap label define yesno 0"No" 1"Yes"

*** Employment and earnings ***

//Employment in the last 12 months
recode v731 (0=0 "No") (1/3=1 "Yes") (8/9=.) if v502==1, gen(we_empl)
label var we_empl "Employment status in the last 12 months among those currently in a union"

//Employment by type of earnings
gen we_empl_earn=v741 if inlist(v731,1,2,3) & v502==1
label values we_empl_earn V741
label var we_empl_earn "Type of earnings among those employed in the past 12 months and currently in a union"

//Control over earnings
gen we_earn_wm_decide=v739 if inlist(v731,1,2,3) & inlist(v741,1,2) & v502==1
label values we_earn_wm_decide V739
label var we_earn_wm_decide "Who descides on wife's cash earnings for employment in the last 12 months"

//Comparison of earnings with husband/partner
gen we_earn_wm_compare=v746 if inlist(v731,1,2,3) & inlist(v741,1,2) & v502==1
label values we_earn_wm_compare V746
replace we_earn_wm_compare=4 if v743f==7 & v746!=. & v502==1
label var we_earn_wm_compare "Comparison of cash earnings with husband's cash earnings"

//Who decides on how husband's cash earnings are used
gen we_earn_hs_decide=v743f if v746!=4 & v743f!=7 & v502==1
replace we_earn_hs_decide=9 if v743f==8
cap label define v743f 9"Don't know/Missing", modify
label values we_earn_hs_decide V743F
label var we_earn_hs_decide	"Who descides on husband's cash earnings for employment in the last 12 months among women currently in a union"

*** Ownership of assets ***

//Own a house
gen we_own_house = v745a
label values we_own_house V745A
label var we_own_house "Ownership of housing"

//Own land
gen we_own_land = v745b
label values we_own_land V745B
label var we_own_land "Ownership of land"

//Ownership of house deed
recode v745c (1=1 "Respondent's name on title/deed") (2=2 "Respondent's name is not on title/deed") (0=0 "Does not have title/deed") (3 8 9=9 "Don't know/missing") if inlist(v745a,1,2,3), gen(we_house_deed)
label var we_house_deed "Title or deed possesion for owned house"

//Ownership of land deed
recode v745d (1=1 "Respondent's name on title/deed") (2=2 "Respondent's name is not on title/deed") (0=0 "Does not have title/deed") (3 8 9=9 "Don't know/missing") if inlist(v745b,1,2,3), gen(we_land_deed)
label var we_land_deed "Title or deed possesion for owned land"

//Own a bank account
gen we_bank=v170
replace we_bank=0 if v170==8 | v170==9
label values we_bank yesno
label var we_bank "Use an account in a bank or other financial institution"

//Own a mobile phone
gen we_mobile=v169a
replace we_mobile=0 if v169a==8 | v169a==9
label values we_mobile yesno 
label var we_mobile "Own a mobile phone"

//Use mobile for finances
gen we_mobile_finance=v169b if v169a==1 
replace we_mobile_finance=0 if v169b==8 | v169b==9
replace we_mobile_finance=. if v169a==8 | v169a==9
label values we_mobile_finance yesno 
label var we_mobile_finance "Use mobile phone for financial transactions"

}


* indicators from MR file
if file=="MR" {
* limiting to men age 15-49
drop if mv012>49

label define yesno 0"No" 1"Yes"

*** Employment and earnings ***

//Employment in the last 12 months
recode mv731 (0=0 "No") (1/3=1 "Yes") (8/9=.) if mv502==1, gen(we_empl)
label var we_empl "Employment status in the last 12 months among those currently in a union"

//Employment by type of earnings
gen we_empl_earn=mv741 if inlist(mv731,1,2,3) & mv502==1
label values we_empl_earn MV741
label var we_empl_earn "Type of earnings among those employed in the past 12 months and currently in a union"

//Who decides on how husband's cash earnings are used
gen we_earn_mn_decide=mv739 if inlist(mv731,1,2,3) & inlist(mv741,1,2) & mv502==1
replace we_earn_mn_decide=9 if mv739==8
cap label define mv739 9"Don't know/Missing", modify
label values we_earn_mn_decide MV739
label var we_earn_mn_decide	"Who descides on husband's cash earnings for employment in the last 12 months among men currently in a union"

*** Ownership of assets ***

//Own a house
gen we_own_house = mv745a
label values we_own_house MV745A
label var we_own_house "Ownership of housing"

//Own land
gen we_own_land = mv745b
label values we_own_land MV745B
label var we_own_land "Ownership of land"

//Ownership of house deed
recode mv745c (1=1 "Respondent's name on title/deed") (2=2 "Respondent's name is not on title/deed") (0=0 "Does not have title/deed") (3 8 9=9 "Don't know/missing") if inlist(mv745a,1,2,3), gen(we_house_deed)
label var we_house_deed "Title or deed possesion for owned house"

//Ownership of land deed
recode mv745d (1=1 "Respondent's name on title/deed") (2=2 "Respondent's name is not on title/deed") (0=0 "Does not have title/deed") (3 8 9=9 "Don't know/missing") if inlist(mv745b,1,2,3), gen(we_land_deed)
label var we_land_deed "Title or deed possesion for owned land"

//Own a bank account
gen we_bank=mv170
replace we_bank=0 if mv170==8 | mv170==9
label values we_bank yesno
label var we_bank "Use an account in a bank or other financial institution"

//Own a mobile phone
gen we_mobile=mv169a
replace we_mobile=0 if mv169a==8 | mv169a==9
label values we_mobile yesno 
label var we_mobile "Own a mobile phone"

//Use mobile for finances
gen we_mobile_finance=mv169b if mv169a==1 
replace we_mobile_finance=0 if mv169b==8 | mv169b==9
replace we_mobile_finance=. if mv169a==8 | mv169a==9
label values we_mobile_finance yesno 
label var we_mobile_finance "Use mobile phone for financial transactions"
}
