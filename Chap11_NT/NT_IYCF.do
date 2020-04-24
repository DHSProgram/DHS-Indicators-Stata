/*****************************************************************************************************
Program: 			NT_IYCF.do
Purpose: 			Code to compute infant and child feeding indicators
Data inputs: 		KR file
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: January 9, 2020 by Shireen Assaf 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_bf_status		"Breastfeeding status for last-born child under 2 years"
nt_ebf				"Exclusively breastfed - last-born under 6 months"
nt_predo_bf			"Predominantly breastfed - last-born under 6 months"
nt_ageapp_bf		"Age-appropriately breastfed - last-born under 2 years"
nt_food_bf			"Introduced to solid, semi-solid, or soft foods - last-born 6-8 months"
	
nt_bf_curr			"Currently breastfeeding - last-born under 2 years"
nt_bf_cont_1yr		"Continuing breastfeeding at 1 year (12-15 months) - last-born under 2 years"
nt_bf_cont_2yr		"Continuing breastfeeding at 2 year (20-23 months) - last-born under 2 years"
	
nt_formula			"Child given infant formula in day/night before survey - last-born under 2 years"
nt_milk				"Child given other milk in day/night before survey- last-born under 2 years"
nt_liquids			"Child given other liquids in day/night before survey- last-born under 2 years"
nt_bbyfood			"Child given fortified baby food in day/night before survey- last-born under 2 years"
nt_grains			"Child given grains in day/night before survey- last-born under 2 years"
nt_vita				"Child given vitamin A rich food in day/night before survey- last-born under 2 years"
nt_frtveg			"Child given other fruits or vegetables in day/night before survey- last-born under 2 years"
nt_root				"Child given roots or tubers in day/night before survey- last-born under 2 years"
nt_nuts				"Child given legumes or nuts in day/night before survey- last-born under 2 years"
nt_meatfish			"Child given meat, fish, shellfish, or poultry in day/night before survey- last-born under 2 years"
nt_eggs				"Child given eggs in day/night before survey- last-born under 2 years"
nt_dairy			"Child given cheese, yogurt, or other milk products in day/night before survey- last-born under 2 years"
nt_solids			"Child given any solid or semisolid food in day/night before survey- last-born under 2 years"

nt_fed_milk			"Child given milk or milk products- last-born 6-23 months"
nt_mdd				"Child with minimum dietary diversity- last-born 6-23 months"
nt_mmf				"Child with minimum meal frequency- last-born 6-23 months"
nt_mad				"Child with minimum acceptable diet- last-born 6-23 months"

nt_ch_micro_vaf		"Youngest children age 6-23 mos living with mother given Vit A rich food"
nt_ch_micro_irf		"Youngest children age 6-23 mos living with mother given iron rich food"

----------------------------------------------------------------------------*/

*** Breastfeeding and complemenatry feeding ***

//currently breastfed
gen nt_bf_curr= m4==95
label values nt_bf_curr yesno
label var nt_bf_curr "Currently breastfeeding - last-born under 2 years"

//breastfeeding status
	gen water=0
	gen liquids=0
	gen milk=0
	gen solids=0

	*Child is given water
	replace water=1 if (v409>=1 & v409<=7)
		   
	*Child given liquids
	foreach xvar of varlist v409a v410 v410a v412c v413*{
	replace liquids=1 if `xvar'>=1 & `xvar'<=7
	}

	*Given powder/tinned milk, formula, or fresh milk
	foreach xvar of varlist v411 v411a {
	replace milk=1 if `xvar'>=1 & `xvar'<=7
	}

	*Given any solid food
	foreach xvar of varlist v414* {
	replace solids=1 if `xvar'>=1 & `xvar'<=7
	}
	replace solids=1 if v412a==1 | v412b==1 | m39a==1
	gen nt_bf_status=1
	replace nt_bf_status=2 if water==1
	replace nt_bf_status=3 if liquids==1
	replace nt_bf_status=4 if milk==1
	replace nt_bf_status=5 if solids==1
	replace nt_bf_status=0 if nt_bf_curr==0
	label define bf_status 0"not bf" 1"exclusively bf" 2"bf & plain water" 3"bf & non-milk liquids" 4"bf & other milk" 5"bf & complemenatry foods"
	label values nt_bf_status bf_status
	label var nt_bf_status "Breastfeeding status for last-born child under 2 years"

//exclusively breastfed
recode nt_bf_status (1=1) (else=0) if age<6, gen(nt_ebf)
label values nt_ebf yesno
label var nt_ebf "Exclusively breastfed - last-born under 6 months"

//predominantly breastfeeding
recode nt_bf_status (1/3=1) (else=0) if age<6, gen(nt_predo_bf)
label values nt_predo_bf yesno
label var nt_predo_bf "Predominantly breastfed - last-born under 6 months"

//age appropriate breastfeeding
gen nt_ageapp_bf=0
replace nt_ageapp_bf=1 if nt_ebf==1
replace nt_ageapp_bf=1 if nt_bf_status==5 & inrange(age,6,23)
label values nt_ageapp_bf yesno
label var nt_ageapp_bf "Age-appropriately breastfed - last-born under 2 years"

//introduced to food
gen nt_food_bf = 0
replace nt_food_bf=1 if (v412a==1 | v412b==1 | m39a==1)
	foreach i in a b c d e f g h i j k l m n o p q r s t u v w {
	replace nt_food_bf=1 if v414`i'==1
	} 
replace nt_food_bf=. if !inrange(age,6,8)
label values nt_food_bf yesno
label var nt_food_bf "Introduced to solid, semi-solid, or soft foods - last-born 6-8 months"
	

//continuing breastfeeding at 1 year
gen nt_bf_cont_1yr= m4==95 if inrange(age,12,15)
label values nt_bf_cont_1yr yesno
label var nt_bf_cont_1yr "Continuing breastfeeding at 1 year (12-15 months) - last-born under 2 years"

//continuing breastfeeding at 2 years
gen nt_bf_cont_2yr= m4==95 if inrange(age,20,23)
label values nt_bf_cont_2yr yesno
label var nt_bf_cont_2yr "Continuing breastfeeding at 2 year (20-23 months) - last-born under 2 years"

*** Foods consumed ***

*country specific foods. These can be added to the foods below based on the survey.
*see examples in lines 186 and 200
gen food1= v414a==1
gen food2= v414b==1
gen food3= v414c==1
gen food4= v414d==1

//Given formula
gen nt_formula= v411a==1
label values nt_formula yesno
label var nt_formula "Child given infant formula in day/night before survey - last-born under 2 years"

//Given other milk
gen nt_milk= v411==1
label values nt_milk yesno 
label var nt_milk "Child given other milk in day/night before survey- last-born under 2 years"

//Given other liquids
gen nt_liquids= v410==1 | v412c==1 | v413==1
label values nt_liquids yesno 
label var nt_liquids "Child given other liquids in day/night before survey- last-born under 2 years"

//Give fortified baby food
gen nt_bbyfood= v412a==1
label values nt_bbyfood yesno 
label var nt_bbyfood "Child given fortified baby food in day/night before survey- last-born under 2 years"

//Given grains
gen nt_grains= v412a==1 | v414e==1
label values nt_grains yesno 
label var nt_grains "Child given grains in day/night before survey- last-born under 2 years"

//Given Vit A rich foods
gen nt_vita= v414i==1 | v414j==1 | v414k==1
label values nt_vita yesno 
label var nt_vita "Child given vitamin A rich food in day/night before survey- last-born under 2 years"

//Given other fruits or vegetables
gen nt_frtveg= v414l==1
label values nt_frtveg yesno 
label var nt_frtveg "Child given other fruits or vegetables in day/night before survey- last-born under 2 years"

//Given roots and tubers
gen nt_root= v414f==1
label values nt_root yesno 
label var nt_root "Child given roots or tubers in day/night before survey- last-born under 2 years"
* country specific for Uganda 2016 DHS
if v000=="UG7" {
	replace nt_root=1 if food1==1
	}

//Given nuts or legumes
gen nt_nuts= v414o==1
label values nt_nuts yesno 
label var nt_nuts "Child given legumes or nuts in day/night before survey- last-born under 2 years"

//Given meat, fish, shellfish, or poultry
gen nt_meatfish= v414h==1 | v414m==1 | v414n==1
label values nt_meatfish yesno 
label var nt_meatfish "Child given meat, fish, shellfish, or poultry in day/night before survey- last-born under 2 years"
* country specific for Uganda 2016 DHS
if v000=="UG7" {
	replace nt_meatfish=1 if food2==1
	}
	
//Given eggs
gen nt_eggs= v414g==1
label values nt_eggs yesno 
label var nt_eggs "Child given eggs in day/night before survey- last-born under 2 years"

//Given dairy
gen nt_dairy= v414p==1 | v414v==1 
label values nt_dairy yesno 
label var nt_dairy "Child given cheese, yogurt, or other milk products in day/night before survey- last-born under 2 years"

//Given other solid or semi-solid foods
gen nt_solids= nt_bbyfood==1 | nt_grains==1 | nt_vita==1 | nt_frtveg==1 | nt_root==1 | nt_nuts==1 | nt_meatfish==1 | nt_eggs==1 | nt_dairy==1 | v414s==1
label values nt_solids yesno 
label var nt_solids "Child given any solid or semisolid food in day/night before survey- last-born under 2 years"


*** Minimum feeding indicators ***

//Fed milk or milk products
gen totmilkf = 0
replace totmilkf=totmilkf + v469e if v469e<8
replace totmilkf=totmilkf + v469f if v469f<8
replace totmilkf=totmilkf + v469x if v469x<8
gen nt_fed_milk= ( totmilkf>=2 | m4==95) if inrange(age,6,23)
label values nt_fed_milk yesno
label var nt_fed_milk "Child given milk or milk products- last-born 6-23 months"

//Min dietary diversity
	* 8 food groups
	*1. breastmilk
	gen group1= m4==95

	*2. infant formula, milk other than breast milk, cheese or yogurt or other milk products
	gen group2= nt_formula==1 | nt_milk==1 | nt_dairy==1

	*3. foods made from grains, roots, tubers, and bananas/plantains, including porridge and fortified baby food from grains
	gen group3= nt_grains==1 | nt_root==1 | nt_bbyfood==1
	 
	*4. vitamin A-rich fruits and vegetables
	gen group4= nt_vita==1

	*5. other fruits and vegetables
	gen group5= nt_frtveg==1

	*6. eggs
	gen group6= nt_eggs==1

	*7. meat, poultry, fish, and shellfish (and organ meats)
	gen group7= nt_meatfish==1

	*8. legumes and nuts
	gen group8= nt_nuts==1

* add the food groups
egen foodsum = rsum(group1 group2 group3 group4 group5 group6 group7 group8) 
recode foodsum (1/4 .=0 "No") (5/8=1 "Yes"), gen(nt_mdd)
replace nt_mdd=. if age<6
label values nt_mdd yesno 
label var nt_mdd "Child with minimum dietary diversity, 5 out of 8 food groups- last-born 6-23 months"
/*older surveys are 4 out of 7 food groups, can use code below
egen foodsum = rsum(group2 group3 group4 group5 group6 group7 group8) 
recode foodsum (1/3 .=0 "No") (4/7=1 "Yes"), gen(nt_mdd)
*/

//Min meal frequency
gen feedings=totmilkf
replace feedings= feedings + m39 if m39>0 & m39<8
gen nt_mmf = (m4==95 & inrange(m39,2,7) & inrange(age,6,8)) | (m4==95 & inrange(m39,3,7) & inrange(age,9,23)) | (m4!=95 & feedings>=4 & inrange(age,6,23))
replace nt_mmf=. if age<6
label values nt_mmf yesno
label var nt_mmf "Child with minimum meal frequency- last-born 6-23 months"

//Min acceptable diet
egen foodsum2 = rsum(nt_grains nt_root nt_nuts nt_meatfish nt_vita nt_frtveg nt_eggs)
gen nt_mad = (m4==95 & nt_mdd==1 & nt_mmf==1) | (m4!=95 & foodsum2>=4 & nt_mmf==1 & totmilkf>=2)
replace nt_mad=. if age<6
label values nt_mad yesno
label var nt_mad "Child with minimum acceptable diet- last-born 6-23 months"

//Consumed Vit A rich food
gen nt_ch_micro_vaf= 0
foreach i in g h i j k m n {
	replace nt_ch_micro_vaf=1 if v414`i'==1
	} 
replace nt_ch_micro_vaf=. if !inrange(age,6,23)
label values nt_ch_micro_vaf yesno 
label var nt_ch_micro_vaf "Youngest children age 6-23 mos living with mother given Vit A rich food"

//Consumed iron rich food
gen nt_ch_micro_irf=0
foreach i in g h m n {
	replace nt_ch_micro_irf=1 if v414`i'==1
	} 
replace nt_ch_micro_irf=. if !inrange(age,6,23)
label values nt_ch_micro_irf yesno 
label var nt_ch_micro_irf "Youngest children age 6-23 mos living with mother given iron rich food"

