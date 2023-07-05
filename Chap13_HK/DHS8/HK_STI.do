/*****************************************************************************************************
Program: 			HK_STI.do
Purpose: 			Code for STI indicators
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Nov 4, 2019 by Shireen Assaf 
Note:				The indicators below can be computed for men and women. No age selection is made here. 
			
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_sti				"Had an STI in the past 12 months"
hk_gent_disch		"Had an abnormal (or bad-smelling) genital discharge in the past 12 months"
hk_gent_sore		"Had a genital sore or ulcer in the past 12 months"
hk_sti_symp			"Had an STI or STI symptoms in the past 12 months"
hk_sti_trt_doc		"Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a clinic/hospital/private doctor"
hk_sti_trt_pharm	"Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a pharmacy"
hk_sti_trt_other	"Had an STI or STI symptoms in the past 12 months and sought advice or treatment from any other source"
hk_sti_notrt		"Had an STI or STI symptoms in the past 12 months and sought no advice or treatment"
	
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

cap label define yesno 0"No" 1"Yes"

**************************

//STI in the past 12 months
gen hk_sti= v763a==1
replace hk_sti=. if v525==0 | v525==99 | v525==.
label values hk_sti yesno
label var hk_sti "Had an STI in the past 12 months"

//Discharge in the past 12 months
gen hk_gent_disch= v763c==1
replace hk_gent_disch=. if v525==0 | v525==99 | v525==.
label values hk_gent_disch yesno
label var hk_gent_disch "Had an abnormal (or bad-smelling) genital discharge in the past 12 months"

//Genital sore in past 12 months
gen hk_gent_sore= v763b==1
replace hk_gent_sore=. if v525==0 | v525==99 | v525==.
label values hk_gent_sore yesno
label var hk_gent_sore "Had a genital sore or ulcer in the past 12 months"

//STI or STI symptoms in the past 12 months
gen hk_sti_symp= v763a==1 | v763b==1 | v763c==1 
replace hk_sti_symp=. if v525==0 | v525==99 | v525==.
label values hk_sti_symp yesno
label var hk_sti_symp "Had an STI or STI symptoms in the past 12 months"

//Sought care from clinic/hospital/private doctor for STI
gen hk_sti_trt_doc = 0 if v763a==1 | v763b==1 | v763c==1
foreach cr in a b c d e f g h i j k l n o p q r s {
replace hk_sti_trt_doc=1 if v770`cr'==1
}
label values hk_sti_trt_doc yesno
label var hk_sti_trt_doc "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a clinic/hospital/private doctor"

//Sought care from pharmacy for STI
gen  hk_sti_trt_pharm = 0 if v763a==1 | v763b==1 | v763c==1
replace hk_sti_trt_pharm=1 if v770m==1 | v770t==1
label values hk_sti_trt_pharm yesno
label var hk_sti_trt_pharm "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a pharmacy"

//Sought care from any other source for STI
gen hk_sti_trt_other = 0 if v763a==1 | v763b==1 | v763c==1
replace hk_sti_trt_other =1 if v770u==1 | v770v==1 | v770w==1 | v770x==1
label values hk_sti_trt_other yesno
label var hk_sti_trt_other "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from any other source"

//Did not seek care for STI
gen hk_sti_notrt = 0 if v763a==1 | v763b==1 | v763c==1
replace hk_sti_notrt=1 if v770==0
label values  hk_sti_notrt yesno
label var hk_sti_notrt "Had an STI or STI symptoms in the past 12 months and sought no advice or treatment"

}


* indicators from MR file
if file=="MR" {

cap label define yesno 0"No" 1"Yes"

**************************

//STI in the past 12 months
gen hk_sti= mv763a==1
replace hk_sti=. if mv525==0 | mv525==99 | mv525==.
label values hk_sti yesno
label var hk_sti "Had an STI in the past 12 months"

//Discharge in the past 12 months
gen hk_gent_disch= mv763c==1
replace hk_gent_disch=. if mv525==0 | mv525==99 | mv525==.
label values hk_gent_disch yesno
label var hk_gent_disch "Had an abnormal (or bad-smelling) genital discharge in the past 12 months"

//Genital sore in past 12 months
gen hk_gent_sore= mv763b==1
replace hk_gent_sore=. if mv525==0 | mv525==99 | mv525==.
label values hk_gent_sore yesno
label var hk_gent_sore "Had a genital sore or ulcer in the past 12 months"

//STI or STI symptoms in the past 12 months
gen hk_sti_symp= mv763a==1 | mv763b==1 | mv763c==1 
replace hk_sti_symp=. if mv525==0 | mv525==99 | mv525==.
label values hk_sti_symp yesno
label var hk_sti_symp "Had an STI or STI symptoms in the past 12 months"

//Sought care from clinic/hospital/private doctor for STI
gen hk_sti_trt_doc = 0 if mv763a==1 | mv763b==1 | mv763c==1
foreach cr in a b c d e f g h i j k l n o p q r s {
replace hk_sti_trt_doc=1 if mv770`cr'==1
}
label values hk_sti_trt_doc yesno
label var hk_sti_trt_doc "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a clinic/hospital/private doctor"

//Sought care from pharmacy for STI
gen  hk_sti_trt_pharm = 0 if mv763a==1 | mv763b==1 | mv763c==1
replace hk_sti_trt_pharm=1 if mv770m==1 | mv770t==1
label values hk_sti_trt_pharm yesno
label var hk_sti_trt_pharm "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a pharmacy"

//Sought care from any other source for STI
gen hk_sti_trt_other = 0 if mv763a==1 | mv763b==1 | mv763c==1
replace hk_sti_trt_other =1 if mv770u==1 | mv770v==1 | mv770w==1 | mv770x==1
label values hk_sti_trt_other yesno
label var hk_sti_trt_other "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from any other source"

//Did not seek care for STI
gen hk_sti_notrt = 0 if mv763a==1 | mv763b==1 | mv763c==1
replace hk_sti_notrt=1 if mv770==0
label values  hk_sti_notrt yesno
label var hk_sti_notrt "Had an STI or STI symptoms in the past 12 months and sought no advice or treatment"

}




