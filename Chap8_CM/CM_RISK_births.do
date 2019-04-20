/*****************************************************************************************************
Program: 			CM_RISK_birth.do
Purpose: 			Code to compute high risk births
Data inputs: 		BR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: April 19 2019 by Shireen Assaf 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
cm_risk_none		"Mortality risk ratio - 2nd or 3rd birth order and mother age 18 and 34"
cm_risk_u18			"Mortality risk ratio - mothers less than 18 years"
cm_risk_o34			"Mortality risk ratio - mothers over 35 years"
cm_risk_ord			"Mortality risk ratio - birth order 4 or higher"
cm_risk_unavoid		"Mortality risk ratio - unavoidable risk - first birth order and mother age 18 to 34"
cm_risk_int			"Mortality risk ratio - born <24mos since preceding birth"
	
cm_riskb_none		"Births - 2nd or 3rd birth order and mother between 18 and 34"
cm_riskb_u18		"Births - mothers less than 18 years"
cm_riskb_o34		"Births - mothers over 34 years"
cm_riskb_order		"Births - birth order 4 or higher"
cm_riskb_interval	"Births - born <24mos since preceding birth"
cm_riskb_unavoid	"Births -unavoidable risk- first birth order and mother age 18 and 34"
	
cm_riskb_mult1		"Births - mult. risks - under age 18, and high order"
cm_riskb_mult2		"Births - mult. risks - under age 18, and short interval"
cm_riskb_mult3		"Births - mult. risks - over age 34, and short interval"
cm_riskb_mult4		"Births - mult. risks - over age 34, and high order"
cm_riskb_mult5		"Births - mult. risks - over age 34, and short interval and high order"
cm_riskb_mult6		"Births - mult. risks - short interval and high order"

----------------------------------------------------------------------------*/

gen age = v008 - b3
	
	* to check if survey has b19, which should be used instead to compute age. 
	scalar b19_included=1
		capture confirm numeric variable b19, exact 
		if _rc>0 {
		* b19 is not present
		scalar b19_included=0
		}
		if _rc==0 {
		* b19 is present; check for values
		summarize b19
		  if r(sd)==0 | r(sd)==. {
		  scalar b19_included=0
		  }
		}

	if b19_included==1 {
	drop age
	gen age=b19
	}

keep if age<60

gen agem_birth = b3-v011
*****************************************************************************

* Tom's code

gen age_of_mother=int((b3-v011)/12)

* Adjustment for multiple births to give the same order as that of the first in multiples;
* b0 is sequence in the multiple birth IF part of a multiple birth; b0=0 if not a multiple birth;
* only shift the second (or later) birth within a multiple birth.

gen bord_adj=bord
*replace bord_adj=bord-1 if b0==2
*replace bord_adj=bord-2 if b0==3

replace bord_adj=bord-b0+1 if b0>1


* Single risk categories, initial definition

* Four basic criteria
gen young=0
gen old=0
gen soon=0
gen many=0

replace young=1 if age_of_mother<18
replace old=1 if age_of_mother>34
replace soon=1 if b11<24
replace many=1 if bord_adj>3

gen unavoidable_risk=0
replace unavoidable_risk=1 if bord_adj==1 & young==0 & old==0

* Construct the four single-risk categories
gen too_young=0 
gen too_old=0
gen too_soon=0
gen too_many=0

replace too_young=1 if young==1 & old==0 & soon==0 & many==0
replace too_old =1 if young==0 & old==1 & soon==0 & many==0 
replace too_soon =1 if young==0 & old==0 & soon==1 & many==0
replace too_many =1 if young==0 & old==0 & soon==0 & many==1

* Pooling of single risk categories
gen single_risk=0
replace single_risk=1 if too_young+too_old+too_soon+too_many>0

* Construct the five multiple-risk categories
gen too_young_too_soon=0
gen too_old_too_soon=0
gen too_old_too_many=0
gen too_old_too_soon_too_many=0
gen too_soon_too_many=0

replace too_young_too_soon =1 if young==1 & old==0 & soon==1 & many==0
replace too_old_too_soon =1 if young==0 & old==1 & soon==1 & many==0
replace too_old_too_many =1 if young==0 & old==1 & soon==0 & many==1
replace too_old_too_soon_too_many=1 if young==0 & old==1 & soon==1 & many==1
replace too_soon_too_many =1 if young==0 & old==0 & soon==1 & many==1

* Pooling of multiple risk categories
gen multiple_risk=0
replace multiple_risk=1 if too_young_too_soon+too_old_too_soon+too_old_too_many+too_old_too_soon_too_many+too_soon_too_many >0

* Pooling of any avoidable risk
gen any_avoidable_risk=0
replace any_avoidable_risk=1 if single_risk+multiple_risk>0

* No risk is the residual
gen no_risk=0
replace no_risk=1 if unavoidable_risk==0 & any_avoidable_risk==0


* Give results
format %6.3f too* single* multiple* any* un* no*
mean no un too* single* multiple* any [iweight=v005/1000000]

* If you want confidence intervals, use prop and look at the lines for the value 1; make survey adjustments
*prop no un too* single* multiple* any [iweight=v005/1000000]




******************************************************************************
// Births at risk - mothers less than 18 years
gen cm_riskb_u18= (b3 - v011 < 216) & b11>=24
* 216 months is 18 years
label var cm_riskb_u18 "Births - mothers less than 18 years"




gen norisk=(bord== 2|3) & (agem_birth>=216 & agem_birth<=419)

gen test=0 if b5==0 & ((b3 - v011 >= 216) & b11>=24)
replace test=1 if b5==0 & ((b3 - v011 < 216) & b11>=24)
*****************************************************************************

* Coding covariates

* age at birth
gen ageb=(b3-v011)/12
gen agebirth=1 if ageb<18
replace agebirth=2 if ageb>=18 & ageb<35
replace agebirth=3 if ageb>=35 & ageb<40
replace agebirth=4 if ageb>=40 
label var agebirth "Age at Birth,cat"
lab define agebirth2  1 "<18 years" 2 "18-34 years" 3 "35-39 years" 4 "40+ years"
lab val agebirth agebirth2

*under18
gen under18=(agebirth==1)
ta agebirth under18 , mis
lab define under18_2  0 "No" 1 "Yes <18" 
lab val under18 under18_2

*over40
gen over40=(agebirth==4)
ta agebirth over40 , mis
lab define over40  0 "No" 1 "Yes >40" 
lab val over40 over40

* parity
recode bord (4/16=4 "4+"), gen(parity)

***Most recent birth was the fourth or greater
gen bord4=(bord>3)
label var bord4 "Parity of 4 or more"

****birth interval less than 24 months birth to birth (this is "high risk"
**less than 36 months would be medium risk, as per HRB report 
gen bint24=(b11<24)
label var bint "Birth interval <24 months"

**less than 36 months would be medium risk, as per HRB report 
gen bint36=(b11<36)
label var bint36 "Birth interval <36 months"

**bintcat, as per HRB report 
gen bintcat= 1 if b11<24
replace bintcat= 2 if b11>23 & b11<36
replace bintcat= 3 if b11>35 & b11<48
replace bintcat= 4 if b11>47 
lab define bintcat  1 "<24 mo" 2 "24-35 mo" 3 "36-47 mo" 4 "48+ mo"
lab val bintcat bintcat
lab var bintcat "Preceding birth interval"


***avoiable high risk birth (woman young or old, short interval or multiple birth) using 36 months as cutoff (not 36 months like Shea)
gen hrb=(agebirth==1|agebirth==1|bint36==1|bord4==1)
label var hrb "Avoidable high risk birth"
