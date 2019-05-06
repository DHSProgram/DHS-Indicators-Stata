/*****************************************************************************************************
Program: 			CM_RISK_wm.do
Purpose: 			Code to compute high risk birth in women
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and Thomas Pullum
Date last modified: April 30, 2019 by Shireen Assaf 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
cm_riskw_none			"Currently married women not in any high-risk category"
cm_riskw_unavoid		"Currently married women with unavoidable risk- first order birth between age 18 and 34"
cm_riskw_any_avoid		"Currently married women in any avoidable high-risk category"
	
cm_riskw_u18			"Currently married women less than 18 years"
cm_riskw_o34			"Currently married women over 34 years"
cm_riskw_interval		"Currently married women with <24mos since preceding birth"
cm_riskw_order			"Currently married women with a birth order 4 or higher"
cm_riskw_any_single		"Currently married women in any single high-risk category"
	
cm_riskw_mult1			"Currently married women with multiple risks - under age 18 and short interval"
cm_riskw_mult2			"Currently married women with multiple risks - over age 34 and short interval"
cm_riskw_mult3			"Currently married women with multiple risks - over age 34 and high order"
cm_riskw_mult4			"Currently married women with multiple risks - over age 34 and short interval and high order"
cm_riskw_mult5			"Currently married women with multiple risks - short interval and high order"
cm_riskw_any_mult		"Currently married women in any multiple risk category"
	
cm_riskw_u18_avoid		"Currently married women with individual avoidable risk - less than 18 years"
cm_riskw_o34_avoid		"Currently married women with individual avoidable risk - over 34 years"
cm_riskw_interval_avoid	"Currently married women with individual avoidable risk - <24mos since preceding birth"
cm_riskw_order_avoid	"Currently married women with individual avoidable risk - birth order 4 or higher"
----------------------------------------------------------------------------*/

*** Indicators are computed for currently married women ***
keep if v502==1

* woman's age
gen age_of_mother=(v008-v011)

*** Single risk categories, initial definition ***

* Four basic criteria
gen young=0
gen old=0
gen soon=0
gen many=0
gen firstbirth=0

* Women are assigned risk categories according to the status they would have at the birth of a child if they were to conceive at the time of the survey
* Sterilzed women (v312==6) have no risk
replace young=1	if age_of_mother<((17*12)+3) & (v312!=6)
replace old=1	if age_of_mother>((34*12)+2) & (v312!=6)
replace soon=1	if (v222<15) & (v312!=6)
replace many=1	if (v201>2) & (v312!=6)
replace firstbirth=1 if (v201==0) & (v312!=6)

//Currently married women with unavoidable risk- first birth order and mother age 18 and 34
gen cm_riskw_unavoid=0
replace cm_riskw_unavoid=1 if firstbirth==1 & young==0 & old==0 & soon==0 & many==0
label var cm_riskw_unavoid "Currently married women with unavoidable risk - first order birth between age 18 and 34"

//Birth risks - under 18
gen cm_riskw_u18=0 
replace cm_riskw_u18=1 if young==1 & old==0 & soon==0 & many==0
label var cm_riskw_u18 "Currently married women less than 18 years"

//Birth risks - over 34
gen cm_riskw_o34=0
replace cm_riskw_o34=1 if young==0 & old==1 & soon==0 & many==0 
label var cm_riskw_o34 "Currently married women over 34 years"

//Birth risk - interval <24months
gen cm_riskw_interval=0
replace cm_riskw_interval=1 if young==0 & old==0 & soon==1 & many==0
label var cm_riskw_interval "Currently married women with <24mos since preceding birth"

//Birth risk - birth order of 4 or more
gen cm_riskw_order=0
replace cm_riskw_order=1 if young==0 & old==0 & soon==0 & many==1
label var cm_riskw_order "Currently married women with a birth order 4 or higher"

//Any single high-risk category
gen cm_riskw_any_single=0
replace cm_riskw_any_single=1 if cm_riskw_u18+cm_riskw_o34+cm_riskw_interval+cm_riskw_order>0
label var cm_riskw_any_single "Currently married women in any single high-risk category"


*** Construct the five multiple-risk categories ***

//Birth risk - too young and short interval
gen cm_riskw_mult1=0
replace cm_riskw_mult1=1 if young==1 & old==0 & soon==1 & many==0
replace cm_riskw_mult1=1 if young==1 & old==0 & soon==0 & many==1
replace cm_riskw_mult1=1 if young==1 & old==0 & soon==1 & many==1
label var cm_riskw_mult1 "Currently married women with multiple risks - under age 18 and short interval"

//Birth risk - older and short interval
gen cm_riskw_mult2=0
replace cm_riskw_mult2=1 if young==0 & old==1 & soon==1 & many==0
label var cm_riskw_mult2 "Currently married women with multiple risks - over age 34 and short interval"

//Birth risk - older and high birth order
gen cm_riskw_mult3=0
replace cm_riskw_mult3=1 if young==0 & old==1 & soon==0 & many==1
label var cm_riskw_mult3 "Currently married women with multiple risks - over age 34 and high order"

//Birth risk - older and short interval and high birth order
gen cm_riskw_mult4=0
replace cm_riskw_mult4=1 if young==0 & old==1 & soon==1 & many==1
label var cm_riskw_mult4 "Currently married women with multiple risks - over age 34 and short interval and high order"

//Birth risk - short interval and high birth order
gen cm_riskw_mult5=0
replace cm_riskw_mult5=1 if young==0 & old==0 & soon==1 & many==1
label var cm_riskw_mult5 "Currently married women with multiple risks - short interval and high order"

//Any multiple risk
gen cm_riskw_any_mult=0
replace cm_riskw_any_mult=1 if cm_riskw_mult1+cm_riskw_mult2+cm_riskw_mult3+cm_riskw_mult4+cm_riskw_mult5 >0
label var cm_riskw_any_mult "Currently married women in any multiple risk category"

//Any avoidable risk
gen cm_riskw_any_avoid=0
replace cm_riskw_any_avoid=1 if cm_riskw_any_single+cm_riskw_any_mult>0
label var cm_riskw_any_avoid "Currently married women in any avoidable high-risk category"

//No risk
gen cm_riskw_none=0
replace cm_riskw_none=1 if cm_riskw_unavoid==0 & cm_riskw_any_avoid==0 & firstbirth==0
label var cm_riskw_none	"Currently married women not in any high-risk category"

*** Individual avoidable high risk category ***

//Avoidable birth risk - under 18
gen  cm_riskw_u18_avoid=young
label var cm_riskw_u18_avoid "Currently married women with individual avoidable risk - mothers less than 18 years"

//Avoidable birth risks - over 34
gen cm_riskw_o34_avoid=old
label var cm_riskw_o34_avoid "Currently married women with individual avoidable risk - mothers over 34 years"

//Avoidable birth risk - interval <24months
gen cm_riskw_interval_avoid=soon
label var cm_riskw_interval_avoid "Currently married women with individual avoidable risk - born <24mos since preceding birth"

//Avoidable birth risk - birth order of 4 or more
gen cm_riskw_order_avoid=many
label var cm_riskw_order_avoid "Currently married women with individual avoidable risk - birth order 4 or higher"
