/*****************************************************************************************************
Program: 			NT_WM_NUT.do
Purpose: 			Code to compute anthropometry and anemia indicators in women
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: July 2, 2020 by Shireen Assaf 
Note:				For ever-married sample surveys please use the PR file instead of the IR file for anemia and anthropometry indicators.
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

nt_wm_ht			"Height under 145cm - women"	

nt_wm_bmi_mean		"Mean BMI  - women"
nt_wm_norm			"Normal BMI - women"
nt_wm_thin			"Thin BMI - women"
nt_wm_mthin			"Mildly thin BMI  - women"
nt_wm_modsevthin	"Moderately and severely thin BMI - women"
nt_wm_ovobese		"Overweight or obese BMI  - women"
nt_wm_ovwt			"Overweight BMI  - women"
nt_wm_obese			"Obese BMI  - women"

nt_wm_micro_iron	"Number of days women took iron supplements during last pregnancy"
nt_wm_micro_dwm		"Women who took deworming medication during last pregnancy"
nt_wm_micro_iod		"Women living in hh with iodized salt"

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

*** Anthropometry indicators ***

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
label values nt_wm_ht yesno
label var nt_wm_ht "Height under 145cm - women"

//Mean BMI
gen bmi=v445/100
summarize bmi if inrange(bmi,12,60) & (v213!=1 & (v208==0 | age>=2)) [iw=wt]
gen nt_wm_bmi_mean=round(r(mean),0.1)
label var nt_wm_bmi_mean "Mean BMI  - women"

//Normal weight
gen nt_wm_norm= inrange(v445,1850,2499) if inrange(v445,1200,6000)
replace nt_wm_norm=. if (v213==1 | age<2)
label values nt_wm_norm yesno
label var nt_wm_norm "Normal BMI - women"

//Thin
gen nt_wm_thin= inrange(v445,1200,1849) if inrange(v445,1200,6000)
replace nt_wm_thin=. if (v213==1 | age<2)
label values nt_wm_thin yesno
label var nt_wm_thin "Thin BMI - women"

//Mildly thin
gen nt_wm_mthin= inrange(v445,1700,1849) if inrange(v445,1200,6000)
replace nt_wm_mthin=. if (v213==1 | age<2)
label values nt_wm_mthin yesno
label var nt_wm_mthin "Mildly thin BMI  - women"

//Moderately and severely thin
gen nt_wm_modsevthin= inrange(v445,1200,1699) if inrange(v445,1200,6000)
replace nt_wm_modsevthin=. if (v213==1 | age<2)
label values nt_wm_modsevthin yesno
label var nt_wm_modsevthin "Moderately and severely thin BMI - women"

//Overweight or obese
gen nt_wm_ovobese= inrange(v445,2500,6000) if inrange(v445,1200,6000)
replace nt_wm_ovobese=. if (v213==1 | age<2)
label values nt_wm_ovobese yesno
label var nt_wm_ovobese "Overweight or obese BMI  - women"

//Overweight
gen nt_wm_ovwt= inrange(v445,2500,2999) if inrange(v445,1200,6000)
replace nt_wm_ovwt=. if (v213==1 | age<2)
label values nt_wm_ovwt yesno
label var nt_wm_ovwt "Overweight BMI  - women"

//Obese
gen nt_wm_obese= inrange(v445,3000,6000) if inrange(v445,1200,6000)
replace nt_wm_obese=. if (v213==1 | age<2)
label values nt_wm_obese yesno
label var nt_wm_obese "Obese BMI  - women"

//Took iron supplements during last pregnancy
gen nt_wm_micro_iron= .
replace nt_wm_micro_iron=0 if m45_1==0
replace nt_wm_micro_iron=1 if inrange(m46_1,0,59)
replace nt_wm_micro_iron=2 if inrange(m46_1,60,89)
replace nt_wm_micro_iron=3 if inrange(m46_1,90,300)
replace nt_wm_micro_iron=4 if m45_1==8 | m45_1==9 | m46_1==998 | m46_1==999
replace nt_wm_micro_iron= . if v208==0
label define nt_wm_micro_iron 0"None" 1"<60" 2"60-89" 3"90+" 4"Don't know/missing"
label values nt_wm_micro_iron nt_wm_micro_iron
label var nt_wm_micro_iron "Number of days women took iron supplements during last pregnancy"

//Took deworming medication during last pregnancy
gen nt_wm_micro_dwm= m60_1==1
replace nt_wm_micro_dwm= . if v208==0
label var nt_wm_micro_dwm "Women who took deworming medication during last pregnancy"

//Woman living in household with idodized salt 
gen nt_wm_micro_iod= hv234a==1
replace nt_wm_micro_iod=. if v208==0 | hv234a>1 
label var nt_wm_micro_iod "Women living in hh with iodized salt"
