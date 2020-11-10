/*****************************************************************************************************
Program: 			FG_CIRCUM.do
Purpose: 			Code  to compute female circumcision indicators indicators among women and knowledge and opinion on female circumcision among men
Data inputs: 		IR or MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: October 22, 2020 by Shireen Assaf 

Note:				Heard of female cirucumcision and opinions on female cirucumcision can be computed for men and women
					In older surveys there may be altnative variable names related to female circumcision. 
					Please check Chapter 18 in Guide to DHS Statistics and the section "Changes over Time" to find alternative names.
					Link:				https://www.dhsprogram.com/Data/Guide-to-DHS-Statistics/index.htm#t=Knowledge_of_Female_Circumcision.htm%23Percentage_of_women_and8bc-1&rhtocid=_21_0_0
					
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

fg_heard			"Heard of female circumcision"
	
fg_fcircum_wm		"Circumcised among women age 15-49"
fg_type_wm			"Type of female circumcision among women age 15-49"
fg_age_wm			"Age at circumcision among women age 15-49"
fg_sewn_wm			"Female circumcision type is sewn closed among women age 15-49"	
fg_who_wm			"Person who performed the circumcision among women age 15-49"
	
fg_relig			"Opinion on whether female circumcision is required by their religion" 
fg_cont				"Opinion on whether female circumcision should continue" 

----------------------------------------------------------------------------*/


* indicators from IR file
if file=="IR" {

cap label define yesno 0"No" 1"Yes"

//Heard of female circumcision
gen fg_heard = g100 
replace fg_heard =1 if g101==1
label values fg_heard yesno
label var fg_heard "Heard of female circumcision"

//Circumcised women
gen fg_fcircum_wm = g102==1
replace fg_fcircum_wm=. if g100==.
label values fg_fcircum_wm yesno
label var fg_fcircum_wm	"Circumcised among women age 15-49"

//Type of circumcision
gen fg_type_wm = 9 if g102==1
replace fg_type_wm = 1 if g104==1 & g105!=1
replace fg_type_wm = 2 if g103==1 & g105!=1
replace fg_type_wm = 3 if g105==1 
label define fg_type 1"No flesh removed" 2"Flesh removed"  3"Sewn closed" 9"Don't know/missing"
label values fg_type_wm fg_type
label var fg_type_wm "Type of female circumcision among women age 15-49"

//Age at circumcision
gen fg_age_wm = 9 if g102==1
replace fg_age_wm = 1 if inrange(g106,0,4) | g106==95
replace fg_age_wm = 2 if inrange(g106,5,9) 
replace fg_age_wm = 3 if inrange(g106,10,14) 
replace fg_age_wm = 4 if inrange(g106,15,49) 
replace fg_age_wm = 9 if g106==98
label define fg_age 1"<5" 2"5-19" 3"10-14" 4"15+" 9"Don't know/missing"
label values fg_age_wm fg_age
label var fg_age_wm "Age at circumcision among women age 15-49"

//Sewn close
gen fg_sewn_wm = g105 if g102==1
label values fg_sewn_wm G105
label var fg_sewn_wm "Female circumcision type is sewn closed among women age 15-49"	

//Person performing the circumcision among women age 15-49
recode g107 (21=1 "traditional circumciser") (22=2 "traditional birth attendant") (26=3 "other traditional agent") ///
			(11=4 "doctor") (12=5 "nurse/midwife") (16=6 "other health professional") (96=7 "other") ///
			(98/99=9 "don't know/missing") if g102==1, gen(fg_who_wm)
label var fg_who_wm "Person who performed the circumcision among women age 15-49"

//Opinion on whether female circumcision is required by their religion
gen fg_relig = g118 if fg_heard==1
replace fg_relig =8 if g118==9
label values fg_relig G118
label var fg_relig "Opinion on whether female circumcision is required by their religion" 

//Opinion on whether female circumcision should continue
gen fg_cont = g119 if fg_heard==1
replace fg_cont =8 if g119==9
label values fg_cont G119
label var fg_cont "Opinion on whether female circumcision should continue" 
}


* indicators from MR file
if file=="MR" {

cap label define yesno 0"No" 1"Yes"

//Heard of female circumcision
gen fg_heard = mg100==1 | mg101==1
label values fg_heard yesno
label var fg_heard "Heard of female circumcision"

//Opinion on whether female circumcision is required by their religion
gen fg_relig = mg118 if fg_heard==1
replace fg_relig =8 if mg118==9
label values fg_relig MG118
label var fg_relig "Opinion on whether female circumcision is required by their religion" 

//Opinion on whether female circumcision should continue
gen fg_cont = mg119 if fg_heard==1
replace fg_cont =8 if mg119==9
label values fg_cont MG119
label var fg_cont "Opinion on whether female circumcision should continue" 
}