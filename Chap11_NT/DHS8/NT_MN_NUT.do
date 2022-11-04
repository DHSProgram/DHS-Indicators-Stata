/*****************************************************************************************************
Program: 			NT_MN_NUT.do
Purpose: 			Code to compute anthropometry and anemia indicators in men
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 26, 2019 by Shireen Assaf 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

nt_mn_any_anem		"Any anemia - men"

nt_mn_bmi_mean		"Mean BMI  - men 15-49"
nt_mn_bmi_mean_all 	"Mean BMI  - all men"
nt_mn_norm			"Normal BMI - men"
nt_mn_thin			"Thin BMI - men"
nt_mn_mthin			"Mildly thin BMI  - men"
nt_mn_modsevthin	"Moderately and severely thin BMI - men"
nt_mn_ovobese		"Overweight or obese BMI  - men"
nt_mn_ovwt			"Overweight BMI  - men"
nt_mn_obese			"Obese BMI  - men"

----------------------------------------------------------------------------*/

cap label define yesno 0"No" 1"Yes"
gen wt=mv005/1000000

*** Anemia indicators ***

//Any anemia
gen nt_mn_any_anem=0 
replace nt_mn_any_anem=1 if hb56<130 
replace nt_mn_any_anem=. if hv103==0 | hv042!=1 | hb55!=0
label values nt_mn_any_anem yesno
label var nt_mn_any_anem "Any anemia - men"

*** Anthropometry indicators ***

//Mean BMI - men 15-49
gen bmi=hb40/100
summarize bmi if inrange(bmi,12,60) & mv013<8 [iw=wt]
gen nt_mn_bmi_mean=round(r(mean),0.1)
label var nt_mn_bmi_mean "Mean BMI  - men 15-49"

//Mean BMI - all men
summarize bmi if inrange(bmi,12,60) [iw=wt]
gen nt_mn_bmi_mean_all=round(r(mean),0.1)
label var nt_mn_bmi_mean_all "Mean BMI  - all men"

//Normal weight
gen nt_mn_norm= inrange(hb40,1850,2499) if inrange(hb40,1200,6000)
label values nt_mn_norm yesno
label var nt_mn_norm "Normal BMI - men"

//Thin
gen nt_mn_thin= inrange(hb40,1200,1849) if inrange(hb40,1200,6000)
label values nt_mn_thin yesno
label var nt_mn_thin "Thin BMI - men"

//Mildly thin
gen nt_mn_mthin= inrange(hb40,1700,1849) if inrange(hb40,1200,6000)
label values nt_mn_mthin yesno
label var nt_mn_mthin "Mildly thin BMI  - men"

//Moderately and severely thin
gen nt_mn_modsevthin= inrange(hb40,1200,1699) if inrange(hb40,1200,6000)
label values nt_mn_modsevthin yesno
label var nt_mn_modsevthin "Moderately and severely thin BMI - men"

//Overweight or obese
gen nt_mn_ovobese= inrange(hb40,2500,6000) if inrange(hb40,1200,6000)
label values nt_mn_ovobese yesno
label var nt_mn_ovobese "Overweight or obese BMI  - men"

//Overweight
gen nt_mn_ovwt= inrange(hb40,2500,2999) if inrange(hb40,1200,6000)
label values nt_mn_ovwt yesno
label var nt_mn_ovwt "Overweight BMI  - men"

//Obese
gen nt_mn_obese= inrange(hb40,3000,6000) if inrange(hb40,1200,6000)
label values nt_mn_obese yesno
label var nt_mn_obese "Obese BMI  - men"

