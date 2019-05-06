/*****************************************************************************************************
Program: 			CM_RISK_birth.do
Purpose: 			Code to compute high risk births
Data inputs: 		BR survey list
Data outputs:		coded variables
Author:				Thomas Pullum with modifications by Shireen Assaf
Date last modified: April 29 2019 by Shireen Assaf 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
cm_riskb_none			"Births not in any high risk category"
cm_riskb_unavoid		"Births with unavoidable risk- first order birth between age 18 and 34"
cm_riskb_any_avoid		"Births in any avoidable high-risk category"
	
cm_riskb_u18			"Births to mothers less than 18 years"
cm_riskb_o34			"Births to mothers over 34 years"
cm_riskb_interval		"Births born <24mos since preceding birth"
cm_riskb_order			"Births with a birth order 4 or higher"
cm_riskb_any_single		"Birth with any single high-risk category"
	
cm_riskb_mult1			"Births with multiple risks - under age 18 and short interval"
cm_riskb_mult2			"Births with multiple risks - over age 34 and short interval"
cm_riskb_mult3			"Births with multiple risks - over age 34 and high order"
cm_riskb_mult4			"Births with multiple risks - over age 34 and short interval and high order"
cm_riskb_mult5			"Births with multiple risks - short interval and high order"
cm_riskb_any_mult		"Births with any multiple risk category"
	
cm_riskb_u18_avoid		"Births with individual avoidable risk - mothers less than 18 years"
cm_riskb_o34_avoid		"Births with individual avoidable risk - mothers over 34 years"
cm_riskb_interval_avoid	"Births with individual avoidable risk - born <24mos since preceding birth"
cm_riskb_order_avoid	"Births with individual avoidable risk - birth order 4 or higher"
----------------------------------------------------------------------------*/

*** Percentage of births among birth in the last 5 years ***

* mother's age
gen age_of_mother=int((b3-v011)/12)

* Adjustment for multiple births to give the same order as that of the first in multiples;
* b0 is sequence in the multiple birth if part of a multiple birth; b0=0 if not a multiple birth;
* only shift the second (or later) birth within a multiple birth.
gen bord_adj=bord
replace bord_adj=bord-b0+1 if b0>1

*** Single risk categories, initial definition ***

* Four basic criteria
gen young=0
gen old=0
gen soon=0
gen many=0

replace young=1 if age_of_mother<18
replace old=1 if age_of_mother>34
replace soon=1 if b11<24
replace many=1 if bord_adj>3

//Births with unavoidable risk- first birth order and mother age 18 and 34
gen cm_riskb_unavoid=0
replace cm_riskb_unavoid=1 if bord_adj==1 & young==0 & old==0
label var cm_riskb_unavoid "Births with unavoidable risk- first order birth between age 18 and 34"

//Birth risks - under 18
gen cm_riskb_u18=0 
replace cm_riskb_u18=1 if young==1 & old==0 & soon==0 & many==0
label var cm_riskb_u18 "Births to mothers less than 18 years"

//Birth risks - over 34
gen cm_riskb_o34=0
replace cm_riskb_o34=1 if young==0 & old==1 & soon==0 & many==0 
label var cm_riskb_o34 "Births to mothers over 34 years"

//Birth risk - interval <24months
gen cm_riskb_interval=0
replace cm_riskb_interval=1 if young==0 & old==0 & soon==1 & many==0
label var cm_riskb_interval "Births born <24mos since preceding birth"

//Birth risk - birth order of 4 or more
gen cm_riskb_order=0
replace cm_riskb_order=1 if young==0 & old==0 & soon==0 & many==1
label var cm_riskb_order "Births with a birth order 4 or higher"

//Any single high-risk category
gen cm_riskb_any_single=0
replace cm_riskb_any_single=1 if cm_riskb_u18+cm_riskb_o34+cm_riskb_interval+cm_riskb_order>0
label var cm_riskb_any_single "Birth with any single high-risk category"


*** Construct the five multiple-risk categories ***

//Birth risk - mother too young and short interval
gen cm_riskb_mult1=0
replace cm_riskb_mult1=1 if young==1 & old==0 & soon==1 & many==0
replace cm_riskb_mult1=1 if young==1 & old==0 & soon==0 & many==1
replace cm_riskb_mult1=1 if young==1 & old==0 & soon==1 & many==1
label var cm_riskb_mult1 "Births with multiple risks - under age 18 and short interval"

//Birth risk - mother older and short interval
gen cm_riskb_mult2=0
replace cm_riskb_mult2=1 if young==0 & old==1 & soon==1 & many==0
label var cm_riskb_mult2 "Births with multiple risks - over age 34 and short interval"

//Birth risk - mother older and high birth order
gen cm_riskb_mult3=0
replace cm_riskb_mult3=1 if young==0 & old==1 & soon==0 & many==1
label var cm_riskb_mult3 "Births with multiple risks - over age 34 and high order"

//Birth risk - mother older and short interval and high birth order
gen cm_riskb_mult4=0
replace cm_riskb_mult4=1 if young==0 & old==1 & soon==1 & many==1
label var cm_riskb_mult4 "Births with multiple risks - over age 34 and short interval and high order"

//Birth risk - short interval and high birth order
gen cm_riskb_mult5=0
replace cm_riskb_mult5=1 if young==0 & old==0 & soon==1 & many==1
label var cm_riskb_mult5 "Births with multiple risks - short interval and high order"

//Any multiple risk
gen cm_riskb_any_mult=0
replace cm_riskb_any_mult=1 if cm_riskb_mult1+cm_riskb_mult2+cm_riskb_mult3+cm_riskb_mult4+cm_riskb_mult5 >0
label var cm_riskb_any_mult "Births with any multiple risk category"

//Any avoidable risk
gen cm_riskb_any_avoid=0
replace cm_riskb_any_avoid=1 if cm_riskb_any_single+cm_riskb_any_mult>0
label var cm_riskb_any_avoid "Births in any avoidable high-risk category"

//No risk
gen cm_riskb_none=0
replace cm_riskb_none=1 if cm_riskb_unavoid==0 & cm_riskb_any_avoid==0
label var cm_riskb_none	"Births not in any high risk category"

*** Individual avoidable high risk category ***

//Avoidable birth risk - under 18
gen  cm_riskb_u18_avoid=young
label var cm_riskb_u18_avoid "Births with individual avoidable risk - mothers less than 18 years"

//Avoidable birth risks - over 34
gen cm_riskb_o34_avoid=old
label var cm_riskb_o34_avoid "Births with individual avoidable risk - mothers over 34 years"

//Avoidable birth risk - interval <24months
gen cm_riskb_interval_avoid=soon
label var cm_riskb_interval_avoid "Births with individual avoidable risk - born <24mos since preceding birth"

//Avoidable birth risk - birth order of 4 or more
gen cm_riskb_order_avoid=many
label var cm_riskb_order_avoid "Births with individual avoidable risk - birth order 4 or higher"

*mean cm* [iweight=v005/1000000]

******************************************************************************

*** Risk ratios among births in the last 5 years ***

* These will be stored as scalars. The names of the scalars will be in the format `var'_RR, where `var' are all the variables computed above. 
 
scalar drop _all
* To view these scalars use the command: scalar list _all

* create a list of all the variables computed
#delimit ; 
global risk_categories "cm_riskb_none cm_riskb_unavoid cm_riskb_any_avoid cm_riskb_u18 cm_riskb_o34 cm_riskb_interval cm_riskb_order
cm_riskb_any_single cm_riskb_mult1 cm_riskb_mult2 cm_riskb_mult3 cm_riskb_mult4 cm_riskb_mult5 cm_riskb_any_mult
cm_riskb_u18_avoid cm_riskb_o34_avoid cm_riskb_interval_avoid cm_riskb_order_avoid" ;
#delimit cr

* obtain the proportion of no risks for the denominator
proportion b5 if cm_riskb_none==1 [iweight=v005/1000000]
matrix T=r(table)
scalar denom=T[1,1]

* for each varaible divide the proportion in the risk category (the numerator) by the denomiator above. 
quietly foreach lcat in $risk_categories {
	proportion b5 if `lcat'==1 [iweight=v005/1000000]
	matrix T=r(table)
	scalar num=T[1,1]
	scalar `lcat'_RR=round(num/denom,.01)
	
	qui proportion b5 if `lcat'==1
	scalar Nobs=e(N)
	
	* check if there are low number of observations (less than 25) that should not be displayed.
		if e(N)<25 {
		scalar `lcat'_RR="*"
		}
	
	* check if there 25-50 observations that should be displayed in parenthesis.
		if e(N)>=25 & e(N)<50 {
		scalar `lcat'_RR="(" + string(`lcat'_RR) + ")"
		}
}

* risk ratios
scalar list _all
