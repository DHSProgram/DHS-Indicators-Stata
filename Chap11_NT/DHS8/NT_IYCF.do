/*****************************************************************************************************
Program: 			NT_IYCF.do
Purpose: 			Code to compute infant and child feeding indicators - DHS8 update
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: November 15, 2022 by Shireen Assaf	
					22 new indicators for DH8, see below. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_bf_status		"Breastfeeding status - youngest child age 0-5 months"
nt_ebf				"Exclusively breastfed - youngest child age 0-5 months"
nt_milkmix			"Fed breastmillk and formula and/or animal milk - youngest children age 0-5 months" - NEW Indicator in DHS8
nt_predo_bf			"Predominantly breastfed - youngest child age 0-5 months"
nt_ageapp_bf		"Age-appropriately breastfed - youngest under 2 years"
nt_food_bf			"Introduced to solid, semi-solid, or soft foods - youngest child age 6-8 months"

nt_water			"Child given plain water in day/night before survey - youngest child under 2 years"	- NEW Indicator in DHS8
nt_formula			"Child given infant formula in day/night before survey - youngest under 2 years"
nt_milk				"Child given fresh, powedered, or packaged animal milk in day/night before survey- youngest child under 2 years"
nt_smilk			"Child given sweet or flavored animal milk in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_yogurt			"Child given any yogurt drink in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_syogdrink		"Child given sweet or flavored yogurt drinks in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_nutmilk			"Child given soy or nut milks in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_snutmilk			"Child given sweet or flavored soy or nut milks in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_juice			"Child given fruit juice in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_soda				"Child given soda, sports, or energy drink in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_teacoff			"Child given tea, coffee, or herbal drink in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_steacoff			"Child given sweetened tea, coffee, or herbal drink in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_soup				"Child given clear broth or soup in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8
nt_liquids			"Child given other liquids in day/night before survey- youngest under 2 years"
nt_sliquids			"Child given other sweetened liquids in day/night before survey- youngest child under 2 years" - NEW Indicator in DHS8

nt_grains			"Child given grains in day/night before survey- youngest under 2 years"
nt_vita				"Child given vitamin A rich food in day/night before survey- youngest under 2 years"
nt_frtveg			"Child given other fruits or vegetables in day/night before survey- youngest under 2 years"
nt_root				"Child given roots or tubers in day/night before survey- youngest under 2 years"
nt_nuts				"Child given beans, peas, lentils, nuts, or seeds in day/night before survey- youngest child under 2 years"
nt_meatfish			"Child given meat, fish, shellfish, or poultry in day/night before survey- youngest under 2 years"
nt_eggs				"Child given eggs in day/night before survey- youngest under 2 years"
nt_dairy			"Child given cheese, yogurt, or other milk products in day/night before survey- youngest under 2 years"
nt_insect			"Child given insects or other small protein in day/night before survey- youngest child under 2 years"  - NEW Indicator in DHS8
nt_palm				"Child given palm oil in day/night before survey- youngest child under 2 years"  - NEW Indicator in DHS8
nt_sweets			"Child given sweet foods in day/night before survey- youngest child under 2 years"  - NEW Indicator in DHS8
nt_salty			"Child given salty foods in day/night before survey- youngest child under 2 years"  - NEW Indicator in DHS8
nt_osolids			"Child given any other solid or semisolid food in day/night before survey- youngest under 2 years"

nt_egg_flesh		"Child given egg and/or flesh food in day/night before survey- youngest child age 6-23 months" - NEW Indicator in DHS8
nt_swt_drink		"Child given sweet beverage in day/night before survey- youngest child age 6-23 months" - NEW Indicator in DHS8
nt_unhlth_food		"Child given unhealhty foods in day/night before survey- youngest child age 6-23 months" - NEW Indicator in DHS8
nt_zvf				"Child not fed any vegetables or fruits in day/night before survey- youngest child age 6-23 months" - NEW Indicator in DHS8

nt_milkfeeds		"Non breastfed child given at least two milk feeds in day/night before survey- youngest child age 6-23 months" 
nt_mdd				"Child with minimum dietary diversity- youngest 6-23 months"
nt_mmf				"Child with minimum meal frequency- youngest 6-23 months"
nt_mad				"Child with minimum acceptable diet- youngest 6-23 months"
	
nt_counsel_iycf		"Mothers who received IYCF counseling in last 6 months - mothers of youngest children age 6-23 months" - NEW Indicator in DHS8
----------------------------------------------------------------------------*/

//Breastfeeding status
* Note: the variables liquids, milk, solids, and dkliqsolid are not indicators but variables needed for the construction of the bf status indicator. 
	*Child given non-milk liquids 
	gen liquids=0
	foreach xvar of varlist v413a v413b v413c v410 v413d v410a v412c v413 {	
	replace liquids=1 if `xvar'>=1 & `xvar'<=7
	}
	
	*Child given milk liquids
	gen milk=0
	foreach xvar of varlist v411 v411a {
	replace milk=1 if `xvar'>=1 & `xvar'<=7
	}

	*Child given any solid food
	gen solids=0
	replace solids =1 if v414v==1 & v413a!=1
	foreach xvar of varlist v414e v414i v414f v414j v414a v414k v414l v414m v414b v414h v414g v414n v414o v414c v414p v414d v414r v414t v414u v414s v414w {
	replace solids=1 if `xvar'>=1 & `xvar'<=7
	}
	
	*Unknown for liquids or solids consumption, i.e. don't know responses
	gen dkliqsolid=0
	foreach xvar of varlist v409 v413a v413b v413c v410 v413d v410a v412c v413 v411 v411a v414v v414e v414i v414f v414j v414a v414k v414l v414m v414b v414h v414g v414n v414o v414c v414p v414d v414r v414t v414u v414s v414w {
	replace dkliqsolid =1 if `xvar'==8
	}
	
	gen nt_bf_status=1
	replace nt_bf_status=2 if v409==1
	replace nt_bf_status=3 if liquids==1
	replace nt_bf_status=4 if milk==1
	replace nt_bf_status=5 if solids==1
	replace nt_bf_status=6 if dkliqsolid==1
	replace nt_bf_status=0 if m4!=95 
	replace nt_bf_status=. if age>=6
	label define bf_status 0"not bf" 1"exclusively bf" 2"bf & plain water" 3"bf & non-milk liquids" 4"bf & other milk" 5"bf & complemenatry foods" 6"unknown"
	label values nt_bf_status bf_status
	label var nt_bf_status "Breastfeeding status - youngest child age 0-5 months"

	//exclusively breastfed
	recode nt_bf_status (1=1) (else=0) if age<6, gen(nt_ebf)
	label values nt_ebf yesno
	label var nt_ebf "Exclusively breastfed - youngest child age 0-5 months"

	//child given mixed milk: breastmilk, formula, and/or animal milk - NEW Indicator in DHS8
	gen nt_milkmix = m4==95 & (v411a==1 | v411==1)
	replace nt_milkmix=. if age>=6
	label values nt_milkmix yesno
	label var nt_milkmix "Fed breastmillk and formula and/or animal milk - youngest children age 0-5 months" 

	//predominantly breastfeeding
	recode nt_bf_status (1/3=1) (else=0) if age<6, gen(nt_predo_bf)
	label values nt_predo_bf yesno
	label var nt_predo_bf "Predominantly breastfed - youngest child age 0-5 months"

	//age appropriate breastfeeding
	gen nt_ageapp_bf=0
	replace nt_ageapp_bf=1 if nt_ebf==1
	replace nt_ageapp_bf=1 if nt_bf_status==5 & inrange(age,6,23)
	label values nt_ageapp_bf yesno
	label var nt_ageapp_bf "Age-appropriately breastfed - youngest under 2 years"
	
	//introduced to food
	gen nt_food_bf = 0
	replace nt_food_bf=1 if (v412a==1 | v412b==1 | m39a==1)
		foreach i in a b c d e f g h i j k l m n o p q r s t u v w {
		replace nt_food_bf=1 if v414`i'==1
		} 
	replace nt_food_bf=. if !inrange(age,6,8) | b5!=1
	label values nt_food_bf yesno
	label var nt_food_bf "Introduced to solid, semi-solid, or soft foods - youngest child age 6-8 months"
	
//Liquids consumed by child in the day or night before the survey

	//Child is given water - NEW Indicator in DHS8
	gen nt_water= v409==1  
	label var nt_water "Child given plain water in day/night before survey - youngest child under 2 years"
	
	//Given formula
	gen nt_formula= v411a==1
	label values nt_formula yesno
	label var nt_formula "Child given infant formula in day/night before survey - youngest under 2 years"
	
	//Given other milk
	gen nt_milk= v411==1
	label values nt_milk yesno 
	label var nt_milk "Child given fresh, powedered, or packaged animal milk in day/night before survey- youngest child under 2 years"

	//Given sweetened milk - NEW Indicator in DHS8
	gen nt_smilk= v411s==1
	label values nt_smilk yesno 
	label var nt_smilk "Child given sweet or flavored animal milk in day/night before survey- youngest child under 2 years"
	
	//Given yogurt drinks - NEW Indicator in DHS8
	gen nt_yogurt = v413a==1
	label values nt_yogurt yesno 
	label var nt_yogurt "Child given any yogurt drink in day/night before survey- youngest child under 2 years"
	
	//Given sweetened yogurt drinks - NEW Indicator in DHS8
	gen nt_syogdrink = v413as==1
	label values nt_syogdrink yesno 
	label var nt_syogdrink "Child given sweet or flavored yogurt drinks in day/night before survey- youngest child under 2 years"
	
	//Given soy or nut milk - NEW Indicator in DHS8
	gen nt_nutmilk = v413b==1
	label values nt_nutmilk yesno 
	label var nt_nutmilk "Child given soy or nut milks in day/night before survey- youngest child under 2 years"
	
	//Given sweetened soy or nut milk - NEW Indicator in DHS8
	gen nt_snutmilk = v413bs==1
	label values nt_snutmilk yesno 
	label var nt_snutmilk "Child given sweet or flavored soy or nut milks in day/night before survey- youngest child under 2 years"
	
	//Given juice - NEW Indicator in DHS8
	gen nt_juice = v410==1
	label values nt_juice yesno 
	label var nt_juice "Child given fruit juice in day/night before survey- youngest child under 2 years" 
	
	//Given soda or engery drink - NEW Indicator in DHS8
	gen nt_soda = v413d==1
	label values nt_soda yesno 
	label var nt_soda "Child given soda, sports, or energy drink in day/night before survey- youngest child under 2 years" 
	
	//Given tea, coffee, or herbal drink - NEW Indicator in DHS8
	gen nt_teacoff = v410a==1
	label values nt_teacoff yesno 
	label var nt_teacoff "Child given tea, coffee, or herbal drink in day/night before survey- youngest child under 2 years" 
	
	//Given sweetened tea, coffee, or herbal drink - NEW Indicator in DHS8
	gen nt_steacoff = v410as==1
	label values nt_steacoff yesno 
	label var nt_steacoff "Child given sweetened tea, coffee, or herbal drink in day/night before survey- youngest child under 2 years" 
	
	//Given soup or clear broth - NEW Indicator in DHS8
	gen nt_soup = v412c==1
	label values nt_soup yesno 
	label var nt_soup "Child given clear broth or soup in day/night before survey- youngest child under 2 years" 
	
	//Given other liquids
	gen nt_oliquids= v413c==1 | v413==1
	label values nt_oliquids yesno 
	label var nt_oliquids "Child given other liquids in day/night before survey- youngest under 2 years"

	//Given other sweetened liquids - NEW Indicator in DHS8
	gen nt_sliquids= v413s==1
	label values nt_sliquids yesno 
	label var nt_sliquids "Child given other sweetened liquids in day/night before survey- youngest child under 2 years" 
	
//Foods consumed by child in the day or night before the survey
	*country specific foods. These can be added to the foods below based on the survey. See example code for nt_grains.
	gen food1= v414wa==1
	gen food2= v414wb==1
	gen food3= v414wc==1
	gen food4= v414wd==1
	gen food5= v414we==1

	//Given grains
	gen nt_grains= v414e==1
	label values nt_grains yesno 
	label var nt_grains "Child given grains in day/night before survey- youngest under 2 years"
	* example of country specific food
	if v000=="ZZ8" {
		replace nt_root=1 if food1==1
		}
		
	//Given roots and tubers
	gen nt_root= v414f==1
	label values nt_root yesno 
	label var nt_root "Child given roots or tubers in day/night before survey- youngest under 2 years"

	//Given beans, peas, lentils, nuts, or seeds
	gen nt_nuts= v414o==1 | v414c==1
	label values nt_nuts yesno 
	label var nt_nuts "Child given beans, peas, lentils, nuts, or seeds in day/night before survey- youngest child under 2 years"

	//Given dairy
	gen nt_dairy= (v414v==1 & v413a!=1) | v414p==1 
	label values nt_dairy yesno 
	label var nt_dairy "Child given cheese, yogurt, or other milk products in day/night before survey- youngest under 2 years"
	*Note: for some sureys this indicator may need to be coded as: gen nt_dairy= v414v==1 | v414p==1 
	
	//Given meat, fish, shellfish, or poultry
	gen nt_meatfish= v414b==1 | v414h==1 | v414m==1 | v414n==1 
	label values nt_meatfish yesno 
	label var nt_meatfish "Child given meat, fish, shellfish, or poultry in day/night before survey- youngest under 2 years"
	
	//Given eggs
	gen nt_eggs= v414g==1
	label values nt_eggs yesno 
	label var nt_eggs "Child given eggs in day/night before survey- youngest under 2 years"

	//Given Vit A rich foods
	gen nt_vita= v414i==1 | v414j==1 | v414k==1
	label values nt_vita yesno 
	label var nt_vita "Child given vitamin A rich food in day/night before survey- youngest under 2 years"

	//Given other fruits or vegetables
	gen nt_frtveg= v414a==1 | v414l==1
	label values nt_frtveg yesno 
	label var nt_frtveg "Child given other fruits or vegetables in day/night before survey- youngest under 2 years"

	//Given insects or other small protein - NEW Indicator in DHS8
	gen nt_insect= v414d==1 
	label values nt_insect yesno 
	label var nt_insect "Child given insects or other small protein in day/night before survey- youngest child under 2 years"  

	//Given palm oil - NEW Indicator in DHS8
	gen nt_palm= v414u==1 
	label values nt_palm yesno 
	label var nt_palm "Child given palm oil in day/night before survey- youngest child under 2 years"  

	//Given sweet foods - NEW Indicator in DHS8
	gen nt_sweets= v414r==1 
	label values nt_sweets yesno 
	label var nt_sweets "Child given sweet foods in day/night before survey- youngest child under 2 years"  

	//Given salty foods - NEW Indicator in DHS8
	gen nt_salty= v414t==1 
	label values nt_salty yesno 
	label var nt_salty "Child given salty foods in day/night before survey- youngest child under 2 years" 
	
	//Given other solid or semi-solid foods
	gen nt_osolids= v414s==1
	label values nt_osolids yesno 
	label var nt_osolids "Child given any other solid or semisolid food in day/night before survey- youngest under 2 years"

	//Given egg or flesh food - NEW Indicator in DHS8
	gen nt_egg_flesh= nt_eggs==1 | nt_meatfish==1
	replace nt_egg_flesh=. if age<6 
	label values nt_egg_flesh yesno 
	label var nt_egg_flesh "Child given egg and/or flesh food in day/night before survey- youngest child age 6-23 months" 

	//Given sweet drinks - NEW Indicator in DHS8
	gen nt_swt_drink= nt_smilk==1 | nt_syogdrink==1 | nt_snutmilk==1 | nt_juice==1 | v413c==1 | nt_soda==1 | nt_steacoff==1 | nt_sliquids==1
	replace nt_swt_drink=. if age<6 
	label values nt_swt_drink yesno 
	label var nt_swt_drink "Child given sweet beverage in day/night before survey- youngest child age 6-23 months" 

	//Given unhealhty food - NEW Indicator in DHS8
	gen nt_unhlth_food= nt_sweets==1 | nt_salty==1 | v414w==1 
	replace nt_unhlth_food=. if age<6 
	label values nt_unhlth_food yesno 
	label var nt_unhlth_food "Child given unhealhty foods in day/night before survey- youngest child age 6-23 months" 

	//Given zero vegetables or fruits - NEW Indicator in DHS8
	gen nt_zvf= nt_vita!=1 & nt_frtveg!=1 
	replace nt_zvf=. if age<6 
	label values nt_zvf yesno 
	label var nt_zvf "Child not fed any vegetables or fruits in day/night before survey- youngest child age 6-23 months" 
	
	
*** Minimum feeding indicators ***

//Min dietary diversity - min of 5 out of 8 food groups
	*1. breastmilk
	gen group1= m4==95

	*2. infant formula, milk other than breast milk, cheese or yogurt or other milk products
	gen group2= v411a==1 | v411==1 | v413a==1 | v414v==1 | v414p==1
	
	*3. foods made from grains and roots, tubers, and bananas/plantains
	gen group3= nt_grains==1 | nt_root==1 
	 
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
label var nt_mdd "Child with minimum dietary diversity - youngest 6-23 months"

//Fed milk or milk products 
gen totmilkf = 0
replace totmilkf=totmilkf + v469e if v469e<8
replace totmilkf=totmilkf + v469f if v469f<8
replace totmilkf=totmilkf + v469x if v469x<8
gen nt_milkfeeds= ( totmilkf>=2 | m4==95) if inrange(age,6,23)
replace nt_milkfeeds=. if m4==95
label values nt_milkfeeds yesno
label var nt_milkfeeds "Non-breastfed child given at least two milk feeds in day/night before survey- youngest child age 6-23 months"

//Min meal frequency
gen feedings=totmilkf
replace feedings= feedings + m39 if m39>0 & m39<8
gen nt_mmf = (m4==95 & inrange(m39,2,7) & inrange(age,6,8)) | (m4==95 & inrange(m39,3,7) & inrange(age,9,23)) | (m4!=95 & feedings>=4 & inrange(age,6,23))
replace nt_mmf=. if age<6 
label values nt_mmf yesno
label var nt_mmf "Child with minimum meal frequency- youngest child 6-23 months"

//Min acceptable diet
egen foodsum2 = rsum(group3 group4 group5 group6 group7 group8)
gen nt_mad = (m4==95 & nt_mdd==1 & nt_mmf==1) | (m4!=95 & foodsum2>=4 & nt_mmf==1 & totmilkf>=2)
replace nt_mad=. if age<6 
label values nt_mad yesno
label var nt_mad "Child with minimum acceptable diet- youngest child 6-23 months"

//Mothers who received IYCF counseling in the last 6 months - NEW Indicator in DHS8
gen nt_counsel_iycf= v486==1 
replace nt_counsel_iycf=. if age<6 
label values nt_counsel_iycf yesno 
label var nt_counsel_iycf "Mothers who received IYCF counseling in last 6 months - mothers of youngest children age 6-23 months" 
