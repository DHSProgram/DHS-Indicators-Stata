/*****************************************************************************************************
Program: 			FG_GIRLS.do
Purpose: 			Code to compute female circumcision indicators among girls 0-14
Data inputs: 		IR and BR survey list
Data outputs:		coded variables
Author:				Tom Pullum and Shireen Assaf
Date last modified: October 22, 2020 by Shireen Assaf 
Note:				Women in the IR file are asked about the circumcision of their daughters.
					However, we need to reshape the file so that the data file uses daughters as the unit of analysis. 
					We also need to merge the IR and BR file to include all daughters 0-14 in the denominator.
					All the daughters age 0-14 must be in the denominator, including those whose mothers have
					g100=0; just those with g121=1 go into the numerator
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
	
fg_fcircum_gl	"Circumcised among girls age 0-14"	
fg_age_gl		"Age at circumcision among girls age 0-14"
fg_who_gl		"Person who performed the circumcision among girls age 0-14"
fg_sewn_gl		"Female circumcision type is sewn closed among girls age 0-14"
	
----------------------------------------------------------------------------*/

***************** Creating a file for daughters age 0-14 *********************
* Prepare the IR file for merging
use v001 v002 v003 g* using "$datapath//$irdata.dta" , clear

rename *_0* *_*

* Reshape the IR file so there is one record per daughter 
reshape long gidx_ g121_ g122_ g123_ g124_ , i(v001 v002 v003) j(sequence)
drop sequence
rename *_ *
drop if gidx==.
rename gidx bidx
gen in_IR=1

sort v001 v002 v003 bidx
save IRtemp.dta, replace

* Prepare the BR file 
use "$datapath//$brdata.dta", clear
* Identify girls, living and age 0-14 (b15==1 is redundant)
keep if b4==2 & b5==1 & b8<=14

* Crucial line to drop the mothers and daughters who did not get the long questionnaire
* drop the girl if the g question were not asked of her mother
drop if g100==.

keep v001-v025 v106 v190 bidx b8
gen age5=1+int(b8/5)
label define age5 1 " 0-4" 2 " 5-9" 3 " 10-14"
label values age5 age5

* in_BR identifies a daughter who is eligible for a g121 code
gen in_BR=1

* MERGE THE BR FILE WITH THE RESHAPED IR FILE
sort v001 v002 v003 bidx
merge v001 v002 v003 bidx using  IRtemp.dta
drop _merge

* Some girls in the BR file do not have a value on g121 because their mothers had not heard of female circumcision.
* Crucial line to get the correct denominator
replace g121=0 if in_IR==. & in_BR==1

*drop if in_BR==.

erase IRtemp.dta
******************************************************************************

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
gen fg_fcircum_wm = g102==1
replace fg_fcircum_wm=. if g100==.
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

//Person performing the circumcision among women girls 0-14 and type of cirucumcision

tab age5 fg_who_gl [iw=wt],col

* output to excel
tabout fg_who_gl age5 using Tables_Circum_gl.xls [iw=wt], c(col) f(1) append 
*/

****
//Sewn close

* output to excel
tabout fg_sewn_gl age5 using Tables_Circum_gl.xls [iw=wt],  c(col) f(1) append 
