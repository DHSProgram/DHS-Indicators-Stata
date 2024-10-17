
/*******************************************************************************
Program: 		CM_RISK_birth.do - DHS8 update
Purpose: 		Code to compute high risk births
Data inputs: 		BR dataset
Data outputs:		coded variables
Author:			Thomas Pullum and modified by Shireen Assaf for the code share project
Date last modified: April 29, 2019 by Shireen Assaf for DHS7 and May 2024 by Tom Pullum for DHS8
********************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
p_none			"Births not in any high risk category"
p_unavoid		"Births with unavoidable risk- first order birth between age 18 and 34"
p_any_avoid		"Births in any avoidable high-risk category"
	
p_u18			"Births to mothers less than 18 years"
p_o34			"Births to mothers over 34 years"
p_interval		"Births born <24mos since preceding birth"
p_order			"Births with a birth order 4 or higher"
p_any_single		"Birth with any single high-risk category"
	
p_mult1			"Births with multiple risks - under age 18 and short interval"
p_mult2			"Births with multiple risks - over age 34 and short interval"
p_mult3			"Births with multiple risks - over age 34 and high order"
p_mult4			"Births with multiple risks - over age 34 and short interval and high order"
p_mult5			"Births with multiple risks - short interval and high order"
p_any_mult		"Births with any multiple risk category"
	
p_u18_avoid		"Births with individual avoidable risk - mothers less than 18 years"
p_o34_avoid		"Births with individual avoidable risk - mothers over 34 years"
p_interval_avoid	"Births with individual avoidable risk - born <24mos since preceding birth"
p_order_avoid		"Births with individual avoidable risk - birth order 4 or higher"

Variables with the prefix "p" give the percentages of births  in each risk category.
Variables with the prefix "d" give the proportion of children in each risk category who died.
Variables with the prefix "w" give the percentages of women   in each risk category.

----------------------------------------------------------------------------*/


*********************************************************************************
program define prepare_KR_file

* Routine to initialize variables for births in the KR file

gen wt=v005/1000000

keep v001 v002 v003 v011 wt bord b0 b3 b5 b11 
* mother's age
gen age_of_mother=int((b3-v011)/12)

* Adjustment for multiple births to give the same order as that of the first in multiples;
* b0 is sequence in the multiple birth if part of a multiple birth; b0=0 if not a multiple birth;
* only shift the second (or later) birth within a multiple birth.
gen bord_adj=bord
replace bord_adj=bord-b0+1 if b0>1

* Single risk categories, initial definition ***
gen young=0
gen old=0
gen soon=0
gen many=0

replace young=1 if age_of_mother<18
replace old=1   if age_of_mother>34
replace soon=1  if b11<24
replace many=1  if bord_adj>3

keep wt bord_adj young old soon many b5

end

********************************************************************************

program define prepare_IR_file

* Routine to initialize variables for women in the IR file

gen wt=v005/1000000

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

* For the woman, bord_adj=1 identifies the first birth
gen bord_adj=1 if (v201==0) & (v312!=6)

keep wt bord_adj young old soon many

end

********************************************************************************

program define construct_risk_categories

* This routine calculates the proportions of births, and then of women, in each risk category

//Births with unavoidable risk- first birth order and mother age 18 and 34
gen p_unavoid=0
replace p_unavoid=1 if bord_adj==1 & young==0 & old==0
scalar s_unavoid="Births with unavoidable risk- first order birth between age 18 and 34"

//Birth risks - under 18
gen p_u18=0 
replace p_u18=1 if young==1 & old==0 & soon==0 & many==0
scalar s_u18="Births to mothers less than 18 years"

//Birth risks - over 34
gen p_o34=0
replace p_o34=1 if young==0 & old==1 & soon==0 & many==0 
scalar s_o34="Births to mothers over 34 years"

//Birth risk - interval <24months
gen p_interval=0
replace p_interval=1 if young==0 & old==0 & soon==1 & many==0
scalar s_interval="Births born <24mos since preceding birth"

//Birth risk - birth order of 4 or more
gen p_order=0
replace p_order=1 if young==0 & old==0 & soon==0 & many==1
scalar s_order="Births with a birth order 4 or higher"

//Any single high-risk category
gen p_any_single=0
replace p_any_single=1 if p_u18+p_o34+p_interval+p_order>0
scalar s_any_single="Birth with any single high-risk category"


*** Construct the five multiple-risk categories ***

//Birth risk - mother too young and short interval
gen p_mult1=0
replace p_mult1=1 if young==1 & old==0 & soon==1 & many==0
replace p_mult1=1 if young==1 & old==0 & soon==0 & many==1
replace p_mult1=1 if young==1 & old==0 & soon==1 & many==1
scalar s_mult1="Births with multiple risks - under age 18 and short interval"

//Birth risk - mother older and short interval
gen p_mult2=0
replace p_mult2=1 if young==0 & old==1 & soon==1 & many==0
scalar s_mult2="Births with multiple risks - over age 34 and short interval"

//Birth risk - mother older and high birth order
gen p_mult3=0
replace p_mult3=1 if young==0 & old==1 & soon==0 & many==1
scalar s_mult3="Births with multiple risks - over age 34 and high order"

//Birth risk - mother older and short interval and high birth order
gen p_mult4=0
replace p_mult4=1 if young==0 & old==1 & soon==1 & many==1
scalar s_mult4="Births with multiple risks - over age 34 and short interval and high order"

//Birth risk - short interval and high birth order
gen p_mult5=0
replace p_mult5=1 if young==0 & old==0 & soon==1 & many==1
scalar s_mult5="Births with multiple risks - short interval and high order"

//Any multiple risk
gen p_any_mult=0
replace p_any_mult=1 if p_mult1+p_mult2+p_mult3+p_mult4+p_mult5 >0
scalar s_any_mult="Births with any multiple risk category"

//Any avoidable risk
gen p_any_avoid=0
replace p_any_avoid=1 if p_any_single+p_any_mult>0
scalar s_any_avoid="Births in any avoidable high-risk category"

//No risk
gen p_none=0
replace p_none=1 if p_unavoid==0 & p_any_avoid==0
scalar s_none="Births not in any high risk category"

*** Individual avoidable high risk category ***

//Avoidable birth risk - under 18
gen  p_u18_avoid=young
scalar s_u18_avoid="Births with individual avoidable risk - mothers less than 18 years"

//Avoidable birth risks - over 34
gen p_o34_avoid=old
scalar s_o34_avoid="Births with individual avoidable risk - mothers over 34 years"

//Avoidable birth risk - interval <24months
gen p_interval_avoid=soon
scalar s_interval_avoid="Births with individual avoidable risk - born <24mos since preceding birth"

//Avoidable birth risk - birth order of 4 or more
gen p_order_avoid=many
scalar s_order_avoid="Births with individual avoidable risk - birth order 4 or higher"

end

************************************************************************************

program define other_births_vars

* get the proportions of children who died 

local lgroup1 none unavoid any_avoid		
local lgroup2 u18 o34 interval order any_single		
local lgroup3 mult1 mult2 mult3 mult4 mult5 any_mult		
local lgroup4 u18_avoid o34_avoid interval_avoid order_avoid

local ln=1
quietly forvalues lg=1/4 {
  foreach lt of local lgroup`lg' {

* calculate the death rate in each category
  summarize b5 if p_`lt'==1 [iweight=wt]
  scalar sd_`ln'=1-r(mean)

* should the risk ratio be suppressed because of small unweighted n?
  summarize b5 if p_`lt'==1
  scalar sn_`ln'=r(N)
local ln=`ln'+1
  }
}

gen cases_b=1

end

************************************************************************************

program define make_table_8pt5

* This routine combines and collapses the data for births and for women
*  and saves a dta file and an xlsx file

local lgroup1 none unavoid any_avoid		
local lgroup2 u18 o34 interval order any_single		
local lgroup3 mult1 mult2 mult3 mult4 mult5 any_mult		
local lgroup4 u18_avoid o34_avoid interval_avoid order_avoid

use "$resultspath/women.dta", clear
keep   p_* wt
rename p_* w_*

gen cases_w=1
append using "$resultspath/births.dta"

* Manipulate the file to get the format of table 8.5 in the final reports
collapse (mean) p_* w_* (sum) cases* [iweight=wt]

local ln=1
  quietly forvalues lg=1/4 {
  foreach lt of local lgroup`lg' {
  rename p_`lt' p_`ln'
  rename w_`lt' w_`ln'
  gen str15 risk_category_`ln'="`lt'"
  local ln=`ln'+1
  }
}
rename cases_b p_`ln'
rename cases_w w_`ln'
gen str12 risk_category_`ln'="cases"

gen dummy=1
reshape long risk_category_ p_ w_, i(dummy) j(line)
drop dummy
rename p_ pct_births
replace pct_births=100*pct_births if line<`ln'
rename w_ pct_women
replace pct_women=100*pct_women if line<`ln'
rename risk_category_ risk_category

gen risk=.
gen unwtd_births=.

gen str30 fullname="."

  forvalues ln=1/18 {
  replace risk  =sd_`ln'       if line==`ln'
  replace unwtd_births=sn_`ln' if line==`ln'
  local ls=risk_category[`ln']
  replace fullname=s_`ls'      if line==`ln'
  }

gen str2 suppress="  "
replace  suppress="()" if unwtd_births<=50
replace  suppress=" *" if unwtd_births<25 

scalar srefrisk=risk[1]
gen risk_ratio=risk/srefrisk
format pct_* %8.1fc
format risk_ratio %6.2f
format risk %8.4f
format unwtd_births %7.0fc
replace risk_category=strproper(risk_category)
drop line
order risk_category pct_births risk risk_ratio unwtd_births suppress pct_women fullname

save "$resultspath/CM_RISK.dta", replace
list, table clean noobs ab(15)
save "$resultspath/table_8pt5.dta", replace
export excel "$resultspath/CM_tables.xlsx", sheet("Table 8.5") sheetreplace firstrow(var)

* optional: erase files
erase "$resultspath/births.dta"
erase "$resultspath/women.dta"

end

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
* Execution begins here

use "$datapath//$krdata.dta", clear
prepare_KR_file
construct_risk_categories
other_births_vars
save "$resultspath/births.dta", replace

* Repeat the calculation or percentages for the currently married women
use "$datapath//$irdata.dta", clear
prepare_IR_file
construct_risk_categories
save "$resultspath/women.dta", replace

make_table_8pt5


