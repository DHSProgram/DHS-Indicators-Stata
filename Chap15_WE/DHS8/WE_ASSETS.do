/*****************************************************************************************************
Program: 			WE_ASSETS.do - DHS8 update
Purpose: 			Code to compute employment, earnings, and asset ownership in men and women
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: August 10, 2023 by Shireen Assaf 
Note:				The indicators below can be computed for men and women. 
					3 new indicators in DHS8 see below. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
we_empl				"Employment status in the last 12 months among those currently in a union"
we_empl_earn		"Type of earnings among those employed in the past 12 months and currently in a union"
we_earn_wm_decide	"Who decides on wife's cash earnings for employment in the last 12 months"
we_earn_wm_compare	"Comparison of cash earnings with husband's cash earnings"
we_earn_mn_decide	"Who decides on husband's cash earnings for employment in the last 12 months among men currently in a union"
we_earn_hs_decide	"Who decides on husband's cash earnings for employment in the last 12 months among women currently in a union"

we_own_house		"Ownership of housing"
we_own_land			"Ownership of land"
we_house_deed		"Title or deed possession for owned house"
we_land_deed		"Title or deed possession for owned land"

we_bank				"Use an account in a bank or other financial institution"
we_bank_use			"Deposited or withdrew money from their own bank account in the last 12 months" - NEW Indicator in DHS8
we_mobile			"Own a mobile phone"
we_mobile_smart		"Own a mobile smartphone" - NEW Indicator in DHS8
we_mobile_finance	"Use mobile phone for financial transactions in the last 12 months"
we_bank_mobile_use	"Use a bank account or a mobile phone for financial transactions in the last 12 months" - NEW Indicator in DHS8
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

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
label var we_earn_wm_decide "Who decides on wife's cash earnings for employment in the last 12 months"

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
label var we_earn_hs_decide	"Who decides on husband's cash earnings for employment in the last 12 months among women currently in a union"

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
recode v745c (1=1 "Respondent's name on title/deed") (2=2 "Respondent's name is not on title/deed") (0=0 "Does not have title/deed") (3 8 9=9 "Don't know/missing") if inrange(v745a,1,4), gen(we_house_deed)
label var we_house_deed "Title or deed possession for owned house"

//Ownership of land deed
recode v745d (1=1 "Respondent's name on title/deed") (2=2 "Respondent's name is not on title/deed") (0=0 "Does not have title/deed") (3 8 9=9 "Don't know/missing") if inrange(v745b,1,4), gen(we_land_deed)
label var we_land_deed "Title or deed possession for owned land"

//Own a bank account
gen we_bank=v170
replace we_bank=0 if v170==8 | v170==9
label values we_bank yesno
label var we_bank "Use an account in a bank or other financial institution"

//Deposited or withdrew money from their own bank account - NEW Indicator in DHS8
gen we_bank_use=v170==1 & v177==1
label values we_bank_use yesno
label var we_bank_use "Deposited or withdrew money from their own bank account in the last 12 months" 

//Own a mobile phone
gen we_mobile=v169a==1
label values we_mobile yesno 
label var we_mobile "Own a mobile phone"

//Own a smartphone - NEW Indicator in DHS8
gen we_mobile_smart=v169c==1
label values we_mobile_smart yesno 
label var we_mobile_smart "Own a mobile smartphone" 

//Use mobile for finances
gen we_mobile_finance=v169b==1
label values we_mobile_finance yesno 
label var we_mobile_finance "Use mobile phone for financial transactions in the last 12 months"

//Use bank or mobile for financial transactions in the last 12 months - NEW Indicator in DHS8
gen we_bank_mobile_use=v170==1 | v169b==1
label values we_bank_mobile_use yesno 
label var we_bank_mobile_use "Use a bank account or a mobile phone for financial transactions in the last 12 months" 
}


* indicators from MR file
if file=="MR" {

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
gen we_earn_mn_decide=mv739 if inlist(mv731,1,2) & inlist(mv741,1,2) & mv502==1
replace we_earn_mn_decide=9 if mv739==8
cap label define mv739 9"Don't know/Missing", modify
label values we_earn_mn_decide MV739
label var we_earn_mn_decide	"Who decides on husband's cash earnings for employment in the last 12 months among men currently in a union"

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
recode mv745c (1=1 "Respondent's name on title/deed") (2=2 "Respondent's name is not on title/deed") (0=0 "Does not have title/deed") (3 8 9=9 "Don't know/missing") if inrange(mv745a,1,4), gen(we_house_deed)
label var we_house_deed "Title or deed possession for owned house"

//Ownership of land deed
recode mv745d (1=1 "Respondent's name on title/deed") (2=2 "Respondent's name is not on title/deed") (0=0 "Does not have title/deed") (3 8 9=9 "Don't know/missing") if inrange(mv745b,1,4), gen(we_land_deed)
label var we_land_deed "Title or deed possession for owned land"

//Own a bank account
gen we_bank=mv170==1
label values we_bank yesno
label var we_bank "Use an account in a bank or other financial institution"

//Deposited or withdrew money from their own bank account - NEW Indicator in DHS8
gen we_bank_use=mv170==1 & mv177==1
label values we_bank_use yesno
label var we_bank_use "Deposited or withdrew money from their own bank account in the last 12 months" 

//Own a mobile phone
gen we_mobile=mv169a==1
label values we_mobile yesno 
label var we_mobile "Own a mobile phone"

//Own a smartphone - NEW Indicator in DHS8
gen we_mobile_smart=mv169c==1
label values we_mobile_smart yesno 
label var we_mobile_smart "Own a mobile smartphone" 

//Use mobile for finances
gen we_mobile_finance=mv169b==1
label values we_mobile_finance yesno 
label var we_mobile_finance "Use mobile phone for financial transactions in the last 12 months"

//Use bank or mobile for financial transactions in the last 12 months - NEW Indicator in DHS8
gen we_bank_mobile_use=mv170==1 | mv169b==1
label values we_bank_mobile_use yesno 
label var we_bank_mobile_use "Use a bank account or a mobile phone for financial transactions in the last 12 months" 
}
