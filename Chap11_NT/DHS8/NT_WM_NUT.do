/*****************************************************************************************************
Program: 			NT_WM_NUT.do
Purpose: 			Code to compute anthropometry and anemia indicators in women - DHS8 update
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Novmeber 16, 2022 by Shireen Assaf 
Note:				30 new indicators for DH8, see below. 
					In DHS-8, two sets of anthropometry indicators are produced for women age 20-49 and women age 15-19. 
					In addition, in DHS8, indicators are included to measure women's food and liquid intake the night before the survey.
					
					For ever-married sample surveys or if you cannot find the variables required below in the IR file, use the PR file.
					Please check the guide to DHS statistics for calculations: 
					For anemia using the PR file, use the variables ha57, hv103, and ha55 to produce the estimates
					For anthropometry using PR file, use the variables ha3, ha40, and hv103.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

nt_wm_any_anem		"Any anemia - women"
nt_wm_mild_anem		"Mild anemia - women"
nt_wm_mod_anem		"Moderate anemia - women"
nt_wm_sev_anem		"Severe anemia - women"

nt_wm_ht			"Height under 145cm - women age 20-49"	
nt_wm_bmi_mean		"Mean BMI  - women age 20-49"
nt_wm_norm			"Normal BMI - women age 20-49"
nt_wm_thin			"Thin BMI - women age 20-49"
nt_wm_mthin			"Mildly thin BMI  - women age 20-49"
nt_wm_modsevthin	"Moderately and severely thin BMI - women age 20-49"
nt_wm_ovobese		"Overweight or obese BMI  - women age 20-49"
nt_wm_ovwt			"Overweight BMI  - women age 20-49"
nt_wm_obese			"Obese BMI  - women age 20-49"

nt_wm2_stunt		"Stunted women age 15-19" - NEW Indicator in DHS8
nt_wm2_bmi_mean		"Mean BMI  - women age 15-19" - NEW Indicator in DHS8
nt_wm2_norm			"Normal BMI - women age 15-19" - NEW Indicator in DHS8
nt_wm2_thin			"Thin BMI - women age 15-19" - NEW Indicator in DHS8
nt_wm2_mthin		"Mildly thin BMI  - women age 15-19" - NEW Indicator in DHS8
nt_wm2_modsevthin	"Moderately and severely thin BMI - women age 15-19" - NEW Indicator in DHS8
nt_wm2_ovobese		"Overweight or obese BMI  - women age 15-19" - NEW Indicator in DHS8
nt_wm2_ovwt			"Overweight BMI  - women age 15-19" - NEW Indicator in DHS8
nt_wm2_obese		"Obese BMI  - women age 15-19" - NEW Indicator in DHS8
	
nt_wm_grains		"Woman had grains in day/night before survey" - NEW Indicator in DHS8
nt_wm_root			"Woman had roots or tubers in day/night before survey" - NEW Indicator in DHS8
nt_wm_beans			"Woman had beans, peas, or lentils in day/night before survey" - NEW Indicator in DHS8
nt_wm_nuts			"Woman had nuts or seeds in day/night before survey" - NEW Indicator in DHS8
nt_wm_dairy			"Woman had milk, cheese, or yogurt in day/night before survey" - NEW Indicator in DHS8
nt_wm_meatfish		"Woman had meat, fish, shellfish, poultry, or organ meats  in day/night before survey" - NEW Indicator in DHS8
nt_wm_eggs			"Woman had eggs in day/night before survey" - NEW Indicator in DHS8
nt_wm_dkgreens		"Woman had dark gren leafy vegetables in day/night before survey" - NEW Indicator in DHS8
nt_wm_vita			"Woman had vitamin A rich food in day/night before survey" - NEW Indicator in DHS8
nt_wm_veg			"Woman had other vegetables in day/night before survey" - NEW Indicator in DHS8
nt_wm_fruit			"Woman had other fruits in day/night before survey" - NEW Indicator in DHS8
nt_wm_insect		"Woman had insects or other small protein in day/night before survey" - NEW Indicator in DHS8
nt_wm_palm			"Woman had palm oil in day/night before survey" - NEW Indicator in DHS8
nt_wm_sweets		"Woman had sweet foods in day/night before survey" - NEW Indicator in DHS8
nt_wm_salty			"Woman had salty foods in day/night before survey" - NEW Indicator in DHS8
nt_wm_juice			"Woman had juice in day/night before survey" - NEW Indicator in DHS8
nt_wm_soda			"Woman had soda, sports, or energy drink in day/night before survey" - NEW Indicator in DHS8
nt_wm_teacoff		"Woman had tea, coffee, or herbal drink in day/night before survey" - NEW Indicator in DHS8
	
nt_wm_mdd			"Woman with minimum dietary diversity, 5 out of 8 food groups" - NEW Indicator in DHS8
nt_wm_swt_drink		"Woman had sweet beverage in day/night before survey" - NEW Indicator in DHS8
nt_wm_unhlth_food	"Woman had unhealhty foods in day/night before survey" - NEW Indicator in DHS8
----------------------------------------------------------------------------*/

cap label define yesno 0"No" 1"Yes"
gen wt=v005/1000000

*** Anemia indicators ***

//Any anemia
gen nt_wm_any_anem=0 if v042==1 & v455==0
replace nt_wm_any_anem=1 if v457<4
label values nt_wm_any_anem yesno
label var nt_wm_any_anem "Any anemia - women"

//Mild anemia
gen nt_wm_mild_anem=0 if v042==1 & v455==0
replace nt_wm_mild_anem=1 if v457==3
label values nt_wm_mild_anem yesno
label var nt_wm_mild_anem "Mild anemia - women"

//Moderate anemia
gen nt_wm_mod_anem=0 if v042==1 & v455==0
replace nt_wm_mod_anem=1 if v457==2
label values nt_wm_mod_anem yesno
label var nt_wm_mod_anem "Moderate anemia - women"

//Severe anemia
gen nt_wm_sev_anem=0 if v042==1 & v455==0
replace nt_wm_sev_anem=1 if v457==1
label values nt_wm_sev_anem yesno
label var nt_wm_sev_anem "Severe anemia - women"

*** Anthropometry indicators among women age 20-49***

* age of most recent child
gen age = v008 - b3_01
	
	* to check if survey has b19, which should be used instead to compute age. 
	scalar b19_included=1
		capture confirm numeric variable b19_01, exact 
		if _rc>0 {
		* b19 is not present
		scalar b19_included=0
		}
		if _rc==0 {
		* b19 is present; check for values
		summarize b19_01
		  if r(sd)==0 | r(sd)==. {
		  scalar b19_included=0
		  }
		}

	if b19_included==1 {
	drop age
	gen age=b19_01
	}


//Height less than 145cm
gen nt_wm_ht= v438<1450 if inrange(v438,1300,2200)
replace nt_wm_ht =. if v012<20
label values nt_wm_ht yesno
label var nt_wm_ht "Height under 145cm - women age 20-49"

//Mean BMI
gen bmi=v445/100
replace bmi =. if v012<20
summarize bmi if inrange(bmi,12,60) & (v213!=1 & (v208==0 | age>=2)) [iw=wt]
gen nt_wm_bmi_mean=round(r(mean),0.1)
label var nt_wm_bmi_mean "Mean BMI  - women age 20-49"

//Normal weight
gen nt_wm_norm= inrange(v445,1850,2499) if inrange(v445,1200,6000)
replace nt_wm_norm=. if (v213==1 | age<2) | v012<20
label values nt_wm_norm yesno
label var nt_wm_norm "Normal BMI - women age 20-49"

//Thin
gen nt_wm_thin= inrange(v445,1200,1849) if inrange(v445,1200,6000)
replace nt_wm_thin=. if (v213==1 | age<2) | v012<20
label values nt_wm_thin yesno
label var nt_wm_thin "Thin BMI - women age 20-49"

//Mildly thin
gen nt_wm_mthin= inrange(v445,1700,1849) if inrange(v445,1200,6000)
replace nt_wm_mthin=. if (v213==1 | age<2) | v012<20
label values nt_wm_mthin yesno
label var nt_wm_mthin "Mildly thin BMI  - women age 20-49"

//Moderately and severely thin
gen nt_wm_modsevthin= inrange(v445,1200,1699) if inrange(v445,1200,6000)
replace nt_wm_modsevthin=. if (v213==1 | age<2) | v012<20
label values nt_wm_modsevthin yesno
label var nt_wm_modsevthin "Moderately and severely thin BMI - women age 20-49"

//Overweight or obese
gen nt_wm_ovobese= inrange(v445,2500,6000) if inrange(v445,1200,6000)
replace nt_wm_ovobese=. if (v213==1 | age<2) | v012<20
label values nt_wm_ovobese yesno
label var nt_wm_ovobese "Overweight or obese BMI  - women age 20-49"

//Overweight
gen nt_wm_ovwt= inrange(v445,2500,2999) if inrange(v445,1200,6000)
replace nt_wm_ovwt=. if (v213==1 | age<2) | v012<20
label values nt_wm_ovwt yesno
label var nt_wm_ovwt "Overweight BMI  - women age 20-49"

//Obese
gen nt_wm_obese= inrange(v445,3000,6000) if inrange(v445,1200,6000)
replace nt_wm_obese=. if (v213==1 | age<2) | v012<20
label values nt_wm_obese yesno
label var nt_wm_obese "Obese BMI  - women age 20-49"

*** Anthropometry indicators among women age 15-19***

//Stunted women age 15-19 - NEW Indicator in DHS8
gen nt_wm2_stunt= 0 
replace nt_wm2_stunt=1 if v446a<-200 
replace nt_wm2_stunt=. if v446a>=9996 | v012>19
label values nt_wm2_stunt yesno
label var nt_wm2_stunt "Stunted women age 15-19"

//Mean BMI - NEW Indicator in DHS8
gen bmi2=v446d /100
replace bmi2 =. if v012>19 | v446d>=9990
summarize bmi2 if (v213!=1 & (v208==0 | age>=2)) [iw=wt]
gen nt_wm2_bmi_mean=round(r(mean),0.1)
label var nt_wm2_bmi_mean "Mean BMI  - women age 15-19"

//Normal - NEW Indicator in DHS8 
gen nt_wm2_norm= inrange(v446d,-100,100) if v446d<9990
replace nt_wm2_norm=. if (v213==1 | age<2) | v012>19 
label values nt_wm2_norm yesno
label var nt_wm2_norm "Normal BMI - women age 15-19"

//Thin - NEW Indicator in DHS8
gen nt_wm2_thin= v446d<-100 if v446d<9990
replace nt_wm2_thin=. if (v213==1 | age<2) | v012>19 
label values nt_wm2_thin yesno
label var nt_wm2_thin "Thin BMI - women age 15-19"

//Mildly thin - NEW Indicator in DHS8
gen nt_wm2_mthin= inrange(v446d,-200,-100) if v446d<9990
replace nt_wm2_mthin=. if (v213==1 | age<2) | v012>19 
label values nt_wm2_mthin yesno
label var nt_wm2_mthin "Mildly thin BMI  - women age 15-19"

//Moderately and severely thin - NEW Indicator in DHS8
gen nt_wm2_modsevthin= v446d<-200 if v446d<9990
replace nt_wm2_modsevthin=. if (v213==1 | age<2) | v012>19 
label values nt_wm2_modsevthin yesno
label var nt_wm2_modsevthin "Moderately and severely thin BMI - women age 15-19"

//Overweight or obese - NEW Indicator in DHS8
gen nt_wm2_ovobese= v446d>100 if v446d<9990
replace nt_wm2_ovobese=. if (v213==1 | age<2) | v012>19 
label values nt_wm2_ovobese yesno
label var nt_wm2_ovobese "Overweight or obese BMI  - women age 15-19"

//Overweight - NEW Indicator in DHS8
gen nt_wm2_ovwt= inrange(v446d,100,200) if v446d<9990
replace nt_wm2_ovwt=. if (v213==1 | age<2) | v012>19 
label values nt_wm2_ovwt yesno
label var nt_wm2_ovwt "Overweight BMI  - women age 15-19"

//Obese - NEW Indicator in DHS8
gen nt_wm2_obese= v446d>200 if v446d<9990
replace nt_wm2_obese=. if (v213==1 | age<2) | v012>19 
label values nt_wm2_obese yesno
label var nt_wm2_obese "Obese BMI  - women age 15-19"

*** Food and liquids consumed among women age 15-49***

	//Had grains - NEW Indicator in DHS8
	gen nt_wm_grains= v472e==1
	label values nt_wm_grains yesno 
	label var nt_wm_grains "Woman had grains in day/night before survey"
	
	//Had roots and tubers - NEW Indicator in DHS8
	gen nt_wm_root= v472f==1
	label values nt_wm_root yesno 
	label var nt_wm_root "Woman had roots or tubers in day/night before survey"

	//Had beans, peas, lentils - NEW Indicator in DHS8
	gen nt_wm_beans= v472o==1 
	label values nt_wm_beans yesno 
	label var nt_wm_beans "Woman had beans, peas, or lentils in day/night before survey"
	
	//Had nuts, or seeds - NEW Indicator in DHS8
	gen nt_wm_nuts= v472c==1
	label values nt_wm_nuts yesno 
	label var nt_wm_nuts "Woman had nuts or seeds in day/night before survey"

	//Had dairy - NEW Indicator in DHS8
	gen nt_wm_dairy= v472p==1 
	label values nt_wm_dairy yesno 
	label var nt_wm_dairy "Woman had milk, cheese, or yogurt in day/night before survey"

	//Had meat, fish, shellfish, poultry, or organ meats - NEW Indicator in DHS8
	gen nt_wm_meatfish= v472b==1 | v472h==1 | v472m==1 | v472n==1 
	label values nt_wm_meatfish yesno 
	label var nt_wm_meatfish "Woman had meat, fish, shellfish, poultry, or organ meats in day/night before survey"
	
	//Had eggs - NEW Indicator in DHS8
	gen nt_wm_eggs= v472g==1
	label values nt_wm_eggs yesno 
	label var nt_wm_eggs "Woman had eggs in day/night before survey"

	//Had dark green leafy vegetables - NEW Indicator in DHS8
	gen nt_wm_dkgreens= v472j==1
	label values nt_wm_dkgreens yesno 
	label var nt_wm_dkgreens "Woman had dark gren leafy vegetables in day/night before survey"
	
	//Had Vit A rich foods - NEW Indicator in DHS8
	gen nt_wm_vita= v472i==1 | v472k==1
	label values nt_wm_vita yesno 
	label var nt_wm_vita "Woman had vitamin A rich food in day/night before survey"
	
	//Had vegetables - NEW Indicator in DHS8
	gen nt_wm_veg= v472a==1 
	label values nt_wm_veg yesno 
	label var nt_wm_veg "Woman had other vegetables in day/night before survey"
	
	//Had fruits - NEW Indicator in DHS8
	gen nt_wm_fruit= v472l==1
	label values nt_wm_fruit yesno 
	label var nt_wm_fruit "Woman had other fruits in day/night before survey"
	
	//Had insects or other small protein - NEW Indicator in DHS8
	gen nt_wm_insect= v472d==1 
	label values nt_wm_insect yesno 
	label var nt_wm_insect "Woman had insects or other small protein in day/night before survey"  

	//Had palm oil - NEW Indicator in DHS8
	gen nt_wm_palm= v472u==1 
	label values nt_wm_palm yesno 
	label var nt_wm_palm "Woman had palm oil in day/night before survey"  

	//Had sweet foods - NEW Indicator in DHS8
	gen nt_wm_sweets= v472r==1 | v472w==1 
	label values nt_wm_sweets yesno 
	label var nt_wm_sweets "Woman had sweet foods in day/night before survey"  

	//Had salty foods - NEW Indicator in DHS8
	gen nt_wm_salty= v472t==1 
	label values nt_wm_salty yesno 
	label var nt_wm_salty "Woman had salty foods in day/night before survey" 
	
	//Had juice - NEW Indicator in DHS8
	gen nt_wm_juice = v471e==1
	label values nt_wm_juice yesno 
	label var nt_wm_juice "Woman had fruit juice in day/night before survey" 
	
	//Had soda or engery drink - NEW Indicator in DHS8
	gen nt_wm_soda = v471d==1
	label values nt_wm_soda yesno 
	label var nt_wm_soda "Woman had soda, sports, or energy drink in day/night before survey" 
	
	//Had tea, coffee, or herbal drinks - NEW Indicator in DHS8
	gen nt_wm_teacoff= v471b==1
	label values nt_wm_teacoff yesno 
	label var nt_wm_teacoff "Woman had tea, coffee, or herbal drink in day/night before survey"
	
	//Had sweetened drinks - NEW Indicator in DHS8
	gen nt_wm_swt_drink= v471cs==1 | v471d==1 | v471e==1 | v471b==1
	label values nt_wm_swt_drink yesno 
	label var nt_wm_swt_drink "Woman had sweet beverage in day/night before survey" 

	//Had unhealhty food - NEW Indicator in DHS8
	gen nt_wm_unhlth_food= nt_wm_sweets==1 | nt_wm_salty==1 | v472w==1 
	label values nt_wm_unhlth_food yesno 
	label var nt_wm_unhlth_food "Woman had unhealhty foods in day/night before survey" 


//Minimum dietary diversity - min 5 out of 10 food groups - NEW Indicator in DHS8

	*1. Foods made from grains, roots, tubers, and bananas/plantains
	gen group1= nt_wm_grains==1 | nt_wm_root==1

	*2. Beans, peas lentils
	gen group2= nt_wm_beans==1
	
	*3. nuts and seeds
	gen group3= nt_wm_nuts==1
	
	*4. dairy
	gen group4= nt_wm_dairy
	 
	*5. meat, poultry, fish, and shellfish (and organ meats)
	gen group5= nt_wm_meatfish==1
	
	*6. eggs
	gen group6= nt_wm_eggs==1
	
	*7. dark leafy vegetables
	gen group7= nt_wm_dkgreens==1
	
	*8. vitamin A-rich fruits and vegetables
	gen group8= nt_wm_vita==1

	*9. other vegetables
	gen group9= nt_wm_veg==1

	*10. other fruits
	gen group10= nt_wm_fruit==1

* add the food groups
egen foodsum = rsum(group1 group2 group3 group4 group5 group6 group7 group8 group9 group10) 
recode foodsum (1/4 .=0 "No") (5/10=1 "Yes"), gen(nt_wm_mdd)
label values nt_wm_mdd yesno 
label var nt_wm_mdd	"Woman with minimum dietary diversity, 5 out of 10 food groups"
