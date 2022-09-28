/*****************************************************************************************************
Program: 			FG_GIRLS.do
Purpose: 			Code to compute female circumcision indicators among girls 0-14
Data inputs: 		BR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: November 12, 2020 by Shireen Assaf 
Note:				This code only uses the BR file. Older surveys may not information about the daughter's circumcision in the BR file. 
					The information may instead be in the IR file. In that case please use the FG_GIRLS_merge.do file. 
					This code also produces the tables for circumcision indicators among girls age 0-14
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
	
fg_fcircum_gl	"Circumcised among girls age 0-14"	
fg_age_gl		"Age at circumcision among girls age 0-14"
fg_who_gl		"Person who performed the circumcision among girls age 0-14"
fg_sewn_gl		"Female circumcision type is sewn closed among girls age 0-14"
----------------------------------------------------------------------------*/

*select for girls age 0-14 
keep if b4==2 & b5==1 & b8<=14

*dropping cases where the mother was not asked whether she ever heard of circumcision
drop if g100==.

*yesno label
cap label define yesno 0"No" 1"Yes"

//Circumcised girls 0-14
gen fg_fcircum_gl = g121==1
label values fg_fcircum_gl yesno
label var fg_fcircum_gl	"Circumcised among girls age 0-14"	

//Age circumcision among girls 0-14
gen fg_age_gl = 0 
replace fg_age_gl = 1 if g122==0
replace fg_age_gl = 2 if inrange(g122,1,4) 
replace fg_age_gl = 3 if inrange(g122,5,9) 
replace fg_age_gl = 4 if inrange(g122,10,14) 
replace fg_age_gl = 9 if g122==98 | g122==99
replace fg_age_gl = 0 if g121==0
label define fg_age 0"not circumcised" 1"<1" 2"1-4" 3"5-9" 4"10-14" 9"Don't know/missing"
label values fg_age_gl fg_age
label var fg_age_gl "Age at circumcision among girls age 0-14"

//Person performing the circumcision among girls age 0-14
recode g124 (21=1 "traditional circumciser") (22=2 "traditional birth attendant") (26=3 "other traditional agent") ///
			(11=4 "doctor") (12=5 "nurse/midwife") (16=6 "other health professional") (96=7 "other") ///
			(98/99=9 "don't know/missing") if g121==1, gen(fg_who_gl)
label var fg_who_gl "Person who performed the circumcision among girls age 0-14"

//Type of circumcision among girls age 0-14
recode g123 (0=0 "not sewn close") (1=1 "sewn close") (8/9=9 "don't know/missing") if g121==1, gen(fg_sewn_gl)
label var fg_sewn_gl "Female circumcision type is sewn closed among girls age 0-14"

**************************************************************************************************
**************************************************************************************************

* Produce Tables_Circum_gl excel file which contains the tables for the indicators of female circumcision among girls age 0-14

gen wt=v005/1000000

*age groups for girls 
gen age5=1+int(b8/5)
label define age5 1 " 0-4" 2 " 5-9" 3 " 10-14"
label values age5 age5

//Prevalence of circumcision and age of circumcision

* Age of circumcision by current age
tab age5 fg_age_gl [iw=wt], row

* output to excel
tabout age5 fg_age_gl using Tables_Circum_gl.xls [iw=wt] , c(row) f(1) replace 

* Prevalence of circumcision by current age
tab age5 fg_fcircum_gl [iw=wt], row

* output to excel
tabout age5 fg_fcircum_gl using Tables_Circum_gl.xls [iw=wt] , c(row freq) f(1) append 

**************************************************************************************************

//Prevalence of circumcision by mother's background characteristics

*Circumcised mother
gen fg_fcircum_wm = g102
label values fg_fcircum_wm yesno
label var fg_fcircum_wm	"Circumcised among women age 15-49"

***** Among girls age 0-4 *****

*residence
tab v025 fg_fcircum_gl if age5==1 [iw=wt], row

*region
tab v024 fg_fcircum_gl if age5==1 [iw=wt], row

*education
tab v106 fg_fcircum_gl if age5==1 [iw=wt], row

*mother's circumcision status
tab fg_fcircum_wm fg_fcircum_gl if age5==1 [iw=wt], row

*wealth
tab v190 fg_fcircum_gl if age5==1 [iw=wt], row

* output to excel
tabout v025 v106 v024 fg_fcircum_wm v190 fg_fcircum_gl if age5==1 using Tables_Circum_gl.xls [iw=wt] , clab(Among_age_0_4) c(row) f(1) append 

***** Among girls age 5-9 *****

*residence
tab v025 fg_fcircum_gl if age5==2 [iw=wt], row

*region
tab v024 fg_fcircum_gl if age5==2 [iw=wt], row

*education
tab v106 fg_fcircum_gl if age5==2 [iw=wt], row

*mother's circumcision status
tab fg_fcircum_wm fg_fcircum_gl if age5==2 [iw=wt], row

*wealth
tab v190 fg_fcircum_gl if age5==2 [iw=wt], row

* output to excel
tabout v025 v106 v024 fg_fcircum_wm v190 fg_fcircum_gl if age5==2 using Tables_Circum_gl.xls [iw=wt] , clab(Among_age_5_9) c(row) f(1) append 

***** Among girls age 10-14 *****

*residence
tab v025 fg_fcircum_gl if age5==3 [iw=wt], row

*region
tab v024 fg_fcircum_gl if age5==3 [iw=wt], row

*education
tab v106 fg_fcircum_gl if age5==3 [iw=wt], row

*mother's circumcision status
tab fg_fcircum_wm fg_fcircum_gl if age5==3 [iw=wt], row

*wealth
tab v190 fg_fcircum_gl if age5==3 [iw=wt], row

* output to excel
tabout v025 v106 v024 fg_fcircum_wm v190 fg_fcircum_gl if age5==3 using Tables_Circum_gl.xls [iw=wt] , clab(Among_age_10_14) c(row) f(1) append 

***** Among girls age 0-14 : Total *****

*residence
tab v025 fg_fcircum_gl [iw=wt], row

*region
tab v024 fg_fcircum_gl [iw=wt], row

*education
tab v106 fg_fcircum_gl [iw=wt], row

*mother's circumcision status
tab fg_fcircum_wm fg_fcircum_gl [iw=wt], row

*wealth
tab v190 fg_fcircum_gl [iw=wt], row

* output to excel
tabout v025 v106 v024 fg_fcircum_wm v190 fg_fcircum_gl using Tables_Circum_gl.xls [iw=wt] , clab(Among_age_0_14) c(row) f(1) append 
**************************************************************************************************

//Person performing the circumcision among women girls 0-14 and type of circumcision

tab fg_who_gl age5  [iw=wt],col

* output to excel
tabout fg_who_gl age5 using Tables_Circum_gl.xls [iw=wt], c(col) f(1) append 
*/

****
//Sewn close
tab fg_sewn_gl age5  [iw=wt],col

* output to excel
tabout fg_sewn_gl age5 using Tables_Circum_gl.xls [iw=wt],  c(col) f(1) append 
