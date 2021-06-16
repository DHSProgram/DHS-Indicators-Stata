/*****************************************************************************************************
Program: 			NT_CH_NUT.do
Purpose: 			Code to compute anthropometry and anemia indicators in children
Data inputs: 		PR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 24, 2019 by Shireen Assaf 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_ch_sev_stunt		"Severely stunted child under 5 years"
nt_ch_stunt			"Stunted child under 5 years"
nt_ch_mean_haz		"Mean z-score for height-for-age for children under 5 years"
nt_ch_sev_wast		"Severely wasted child under 5 years"
nt_ch_wast			"Wasted child under 5 years"
nt_ch_ovwt_ht		"Overweight for heigt child under 5 years"
nt_ch_mean_whz		"Mean z-score for weight-for-height for children under 5 years"
nt_ch_sev_underwt	"Severely underweight child under 5 years"
nt_ch_underwt		"Underweight child under 5 years"
nt_ch_ovwt_age		"Overweight for age child under 5 years"
nt_ch_mean_waz		"Mean weight-for-age for children under 5 years"
	
nt_ch_any_anem		"Any anemia - child 6-59 months"
nt_ch_mild_anem		"Mild anemia - child 6-59 months"
nt_ch_mod_anem		"Moderate anemia - child 6-59 months"
nt_ch_sev_anem		"Severe anemia - child 6-59 months"
----------------------------------------------------------------------------*/

cap label define yesno 0"No" 1"Yes"
gen wt=hv005/1000000

*** Anthropometry indicators ***

//Severely stunted
gen nt_ch_sev_stunt= 0 if hv103==1
replace nt_ch_sev_stunt=. if hc70>=9996
replace nt_ch_sev_stunt=1 if hc70<-300 & hv103==1 
label values nt_ch_sev_stunt yesno
label var nt_ch_sev_stunt "Severely stunted child under 5 years"

//Stunted
gen nt_ch_stunt= 0 if hv103==1
replace nt_ch_stunt=. if hc70>=9996
replace nt_ch_stunt=1 if hc70<-200 & hv103==1 
label values nt_ch_stunt yesno
label var nt_ch_stunt "Stunted child under 5 years"

//Mean haz
gen haz=hc70/100 if hc70<996
summarize haz if hv103==1 [iw=wt]
gen nt_ch_mean_haz=round(r(mean),0.1)
label var nt_ch_mean_haz "Mean z-score for height-for-age for children under 5 years"

//Severely wasted 
gen nt_ch_sev_wast= 0 if hv103==1
replace nt_ch_sev_wast=. if hc72>=9996
replace nt_ch_sev_wast=1 if hc72<-300 & hv103==1 
label values nt_ch_sev_wast yesno
label var nt_ch_sev_wast "Severely wasted child under 5 years"

//Wasted
gen nt_ch_wast= 0 if hv103==1
replace nt_ch_wast=. if hc72>=9996
replace nt_ch_wast=1 if hc72<-200 & hv103==1 
label values nt_ch_wast yesno
label var nt_ch_wast "Wasted child under 5 years"

//Overweight for height
gen nt_ch_ovwt_ht= 0 if hv103==1
replace nt_ch_ovwt_ht=. if hc72>=9996
replace nt_ch_ovwt_ht=1 if hc72>200 & hc72<9996 & hv103==1 
label values nt_ch_ovwt_ht yesno
label var nt_ch_ovwt_ht "Overweight for height child under 5 years"

//Mean whz
gen whz=hc72/100 if hc72<996
summarize whz if hv103==1 [iw=wt]
gen nt_ch_mean_whz=round(r(mean),0.1)
label var nt_ch_mean_whz "Mean z-score for weight-for-height for children under 5 years"

//Severely underweight
gen nt_ch_sev_underwt= 0 if hv103==1
replace nt_ch_sev_underwt=. if hc71>=9996
replace nt_ch_sev_underwt=1 if hc71<-300 & hv103==1 
label values nt_ch_sev_underwt yesno
label var nt_ch_sev_underwt	"Severely underweight child under 5 years"

//Underweight
gen nt_ch_underwt= 0 if hv103==1
replace nt_ch_underwt=. if hc71>=9996
replace nt_ch_underwt=1 if hc71<-200 & hv103==1 
label values nt_ch_underwt yesno
label var nt_ch_underwt "Underweight child under 5 years"

//Overweight for age
gen nt_ch_ovwt_age= 0 if hv103==1
replace nt_ch_ovwt_age=. if hc71>=9996
replace nt_ch_ovwt_age=1 if hc71>200 & hc71<9996 & hv103==1 
label values nt_ch_ovwt_age yesno
label var nt_ch_ovwt_age "Overweight for age child under 5 years"

//Mean waz
gen waz=hc71/100 if hc71<996
summarize waz if hv103==1 [iw=wt]
gen nt_ch_mean_waz=round(r(mean),0.1)
label var nt_ch_mean_waz "Mean weight-for-age for children under 5 years"

*** Anemia indicators ***

//Any anemia
gen nt_ch_any_anem=0 if hv103==1 & hc1>5 & hc1<60
replace nt_ch_any_anem=1 if hc56<110 & hv103==1 & hc1>5 & hc1<60
replace nt_ch_any_anem=. if hc56==.
label values nt_ch_any_anem yesno
label var nt_ch_any_anem "Any anemia - child 6-59 months"

//Mild anemia
gen nt_ch_mild_anem=0 if hv103==1 & hc1>5 & hc1<60
replace nt_ch_mild_anem=1 if hc56>99 & hc56<110 & hv103==1 & hc1>5 & hc1<60
replace nt_ch_mild_anem=. if hc56==.
label values nt_ch_mild_anem yesno
label var nt_ch_mild_anem "Mild anemia - child 6-59 months"

//Moderate anemia
gen nt_ch_mod_anem=0 if hv103==1 & hc1>5 & hc1<60
replace nt_ch_mod_anem=1 if hc56>69 & hc56<100 & hv103==1 & hc1>5 & hc1<60
replace nt_ch_mod_anem=. if hc56==.
label values nt_ch_mod_anem yesno
label var nt_ch_mod_anem "Moderate anemia - child 6-59 months"

//Severe anemia
gen nt_ch_sev_anem=0 if hv103==1 & hc1>5 & hc1<60
replace nt_ch_sev_anem=1 if hc56<70 & hv103==1 & hc1>5 & hc1<60
replace nt_ch_sev_anem=. if hc56==.
label values nt_ch_sev_anem yesno
label var nt_ch_sev_anem "Severe anemia - child 6-59 months"