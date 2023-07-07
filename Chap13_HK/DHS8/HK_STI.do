/*****************************************************************************************************
Program: 			HK_STI.do - DHS8 update
Purpose: 			Code for STI indicators
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: July 6, 2023 by Shireen Assaf
Note:				The indicators below can be computed for men and women. No age selection is made here. 
			
					Several indicators have also been discontiued in DHS8. Please check the excel indicator list for these indicators. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_sti				"Had an STI in the past 12 months"
hk_gent_disch		"Had an abnormal (or bad-smelling) genital discharge in the past 12 months"
hk_gent_sore		"Had a genital sore or ulcer in the past 12 months"
hk_sti_symp			"Had an STI or STI symptoms in the past 12 months"
	
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

}




