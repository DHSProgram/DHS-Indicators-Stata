/*****************************************************************************************************
Program: 			NT_MN_NUT.do
Purpose: 			Code to compute anthropometry and anemia indicators in men - DHS8 update
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: November 16, 2022 by Shireen Assaf 
Note:				11 new indicators for DH8, see below.
					In DHS-8, two sets of anthropometry indicators are produced for men age 20-49 and men age 15-19.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

nt_mn_any_anem		"Any anemia - men"
nt_mn_mild_anem		"Mild anemia - men" - NEW Indicator in DHS8
nt_mn_mod_anem		"Moderate anemia - men" - NEW Indicator in DHS8
nt_mn_sev_anem		"Severe anemia - men" - NEW Indicator in DHS8

nt_mn_bmi_mean		"Mean BMI  - men age 20-49"
nt_mn_norm			"Normal BMI - men age 20-49"
nt_mn_thin			"Thin BMI - men age 20-49"
nt_mn_mthin			"Mildly thin BMI  - men age 20-49"
nt_mn_modsevthin	"Moderately and severely thin BMI - men age 20-49"
nt_mn_ovobese		"Overweight or obese BMI  - men age 20-49"
nt_mn_ovwt			"Overweight BMI  - men age 20-49"
nt_mn_obese			"Obese BMI  - men age 20-49"
	
nt_mn2_bmi_mean		"Mean BMI  - men age 15-19" - NEW Indicator in DHS8
nt_mn2_norm			"Normal BMI - men age 15-19" - NEW Indicator in DHS8
nt_mn2_thin			"Thin BMI - men age 15-19" - NEW Indicator in DHS8
nt_mn2_mthin		"Mildly thin BMI  - men age 15-19" - NEW Indicator in DHS8
nt_mn2_modsevthin	"Moderately and severely thin BMI - men age 15-19" - NEW Indicator in DHS8
nt_mn2_ovobese		"Overweight or obese BMI  - men age 15-19" - NEW Indicator in DHS8
nt_mn2_ovwt			"Overweight BMI  - men age 15-19" - NEW Indicator in DHS8
nt_mn2_obese		"Obese BMI  - men age 15-19" - NEW Indicator in DHS8
----------------------------------------------------------------------------*/

cap label define yesno 0"No" 1"Yes"
gen wt=mv005/1000000

*** Anemia indicators ***

//Any anemia - NEW Indicator in DHS8
gen nt_mn_any_anem=0 
replace nt_mn_any_anem=1 if hb57<4 
replace nt_mn_any_anem=. if hv103==0 | hv042!=1 | hb55!=0
label values nt_mn_any_anem yesno
label var nt_mn_any_anem "Any anemia - men"

//Mild anemia - NEW Indicator in DHS8
gen nt_mn_mild_anem=0 
replace nt_mn_mild_anem=1 if hb57==3 
replace nt_mn_mild_anem=. if hv103==0 | hv042!=1 | hb55!=0
label values nt_mn_mild_anem yesno
label var nt_mn_mild_anem "Mild anemia - men"

//Moderate anemia - NEW Indicator in DHS8
gen nt_mn_mod_anem=0 
replace nt_mn_mod_anem=1 if hb57==2 
replace nt_mn_mod_anem=. if hv103==0 | hv042!=1 | hb55!=0
label values nt_mn_mod_anem yesno
label var nt_mn_mod_anem "Moderate anemia - men"

//Severe anemia - NEW Indicator in DHS8
gen nt_mn_sev_anem=0 
replace nt_mn_sev_anem=1 if hb57==1 
replace nt_mn_sev_anem=. if hv103==0 | hv042!=1 | hb55!=0
label values nt_mn_sev_anem yesno
label var nt_mn_sev_anem "Severe anemia - men"

*** Anthropometry indicators among men age 20-49 ***

//Mean BMI - men 20-49
gen bmi=hb40/100
replace bmi=. if !inrange(mv012,20,49)
summarize bmi if inrange(bmi,12,60) [iw=wt]
gen nt_mn_bmi_mean=round(r(mean),0.1)
label var nt_mn_bmi_mean "Mean BMI  - men 20-49"

//Mean BMI - men 20 years and above
gen bmi2=hb40/100
replace bmi2=. if mv012<20
summarize bmi2 if inrange(bmi2,12,60) [iw=wt]
gen nt_mn_bmi_mean_all=round(r(mean),0.1)
label var nt_mn_bmi_mean_all "Mean BMI  - men age 20+"

//Normal weight
gen nt_mn_norm= inrange(hb40,1850,2499) if inrange(hb40,1200,6000) & inrange(mv012,20,49)
label values nt_mn_norm yesno
label var nt_mn_norm "Normal BMI - men age 20-49"

//Thin
gen nt_mn_thin= inrange(hb40,1200,1849) if inrange(hb40,1200,6000) & inrange(mv012,20,49)
label values nt_mn_thin yesno
label var nt_mn_thin "Thin BMI - men age 20-49"

//Mildly thin
gen nt_mn_mthin= inrange(hb40,1700,1849) if inrange(hb40,1200,6000) & inrange(mv012,20,49)
label values nt_mn_mthin yesno
label var nt_mn_mthin "Mildly thin BMI  - men age 20-49"

//Moderately and severely thin
gen nt_mn_modsevthin= inrange(hb40,1200,1699) if inrange(hb40,1200,6000) & inrange(mv012,20,49)
label values nt_mn_modsevthin yesno
label var nt_mn_modsevthin "Moderately and severely thin BMI - men age 20-49"

//Overweight or obese
gen nt_mn_ovobese= inrange(hb40,2500,6000) if inrange(hb40,1200,6000) & inrange(mv012,20,49)
label values nt_mn_ovobese yesno
label var nt_mn_ovobese "Overweight or obese BMI  - men age 20-49"

//Overweight
gen nt_mn_ovwt= inrange(hb40,2500,2999) if inrange(hb40,1200,6000) & inrange(mv012,20,49)
label values nt_mn_ovwt yesno
label var nt_mn_ovwt "Overweight BMI  - men age 20-49"

//Obese
gen nt_mn_obese= inrange(hb40,3000,6000) if inrange(hb40,1200,6000) & inrange(mv012,20,49)
label values nt_mn_obese yesno
label var nt_mn_obese "Obese BMI  - men age 20-49"


*** Anthropometry indicators among men age 15-19 ***

//Mean BMI - men 15-19 - NEW Indicator in DHS8
gen bmi3=hb73/100
replace bmi3=. if !inrange(mv012,15,19) | hb73>=9990
summarize bmi3 [iw=wt]
gen nt_mn2_bmi_mean=round(r(mean),0.1)
label var nt_mn2_bmi_mean "Mean BMI  - men 15-19"

//Normal weight - NEW Indicator in DHS8
gen nt_mn2_norm= inrange(hb73,-100,100) if hb73<9990 
replace nt_mn2_norm=. if mv012>19
label values nt_mn2_norm yesno
label var nt_mn2_norm "Normal BMI - men age 15-19"

//Thin - NEW Indicator in DHS8
gen nt_mn2_thin= hb73<-100  if hb73<9990 
replace nt_mn2_thin=. if mv012>19
label values nt_mn2_thin yesno
label var nt_mn2_thin "Thin BMI - men age 15-19"

//Mildly thin - NEW Indicator in DHS8
gen nt_mn2_mthin= inrange(hb73,-200,-100) if hb73<9990 
replace nt_mn2_mthin=. if mv012>19
label values nt_mn2_mthin yesno
label var nt_mn2_mthin "Mildly thin BMI  - men age 15-19"

//Moderately and severely thin - NEW Indicator in DHS8
gen nt_mn2_modsevthin= hb73<-200 if hb73<9990 
replace nt_mn2_modsevthin=. if mv012>19
label values nt_mn2_modsevthin yesno
label var nt_mn2_modsevthin "Moderately and severely thin BMI - men age 15-19"

//Overweight or obese - NEW Indicator in DHS8
gen nt_mn2_ovobese= hb73>100 if hb73<9990 
replace nt_mn2_ovobese=. if mv012>19
label values nt_mn2_ovobese yesno
label var nt_mn2_ovobese "Overweight or obese BMI  - men age 15-19"

//Overweight - NEW Indicator in DHS8
gen nt_mn2_ovwt= inrange(hb73,100,200) if hb73<9990 
replace nt_mn2_ovwt=. if mv012>19
label values nt_mn2_ovwt yesno
label var nt_mn2_ovwt "Overweight BMI  - men age 15-19"

//Obese - NEW Indicator in DHS8
gen nt_mn2_obese= hb73>200 if hb73<9990 
replace nt_mn2_obese=. if mv012>19
label values nt_mn2_obese yesno
label var nt_mn2_obese "Obese BMI  - men age 15-19"