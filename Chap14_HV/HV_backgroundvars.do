/*****************************************************************************************************
Program: 			HV_backgroundvars.do
Purpose: 			compute the background variables needed for the HV_tables 
Author:				Shireen Assaf
Date last modified: Nov 7 2019 by Shireen Assaf 

*****************************************************************************************************/

* Generate background variable that are not standard variables in the date files
* These variables are used for the tabulations of HIV prevalence in the final reports

* employed in the last 12 months
recode v731 (0=0 "Not employed") (1/3=1 "Employed") (8/9=.), gen(empl)
label var empl "Employment in the past 12 months"

*polygamy for women
gen poly_w=.
replace poly_w=0 if v502!=1
replace poly_w=1 if v502==1 & v505==0
replace poly_w=2 if v502==1 & v505>0
label define poly 0"Not currently in union" 1 "In non-polygynous union" 2 "In polygynous union"
label values poly_w poly 
label var poly_w "Type of union"

*polygamy for men
gen poly_m=.
replace poly_m=0 if v502!=1
replace poly_m=1 if v502==1 & v035==1
replace poly_m=2 if v502==1 & v035>1
label values poly_m poly 
label var poly_m "Type of union"

*polygamy for total
gen poly_t =1
replace poly_t=0 if v502!=1
replace poly_t=2 if poly_w==2 & poly_m==2
label values poly_t poly 
label var poly_m "Type of union"

*Times slept away from home in the past 12 months
recode v167 (0=0 "None") (1/2=1 " 1-2") (3/4=2 " 3-4") (5/90=3 " 5+") (98/99=.) , gen(timeaway)
label var timeaway "Times slept away from home in past 12 months"

* Time away in the past 12 months for more than 1 month
gen timeaway12m =.
replace timeaway12m=1 if v167>0 & v168==1
replace timeaway12m=2 if v167>0 & v168==0
replace timeaway12m=3 if v167==0
label define timeaway12m 1"Away for more than 1 month at a time" 2"Away only for less than 1 month at a time" 3"Not away"
label values timeaway12m timeaway12m
label var timeaway12m "Time away in the past 12 months"

*currently pregnant
recode v213 (0 =0 "No") (1 8=1 "Yes") (9=.) , gen(preg)
label var preg "Currently pregnant"

*ANC for last birth in the past 3 years
*need age of most recent child to limit to 3 years
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

gen ancplace = 0 if m2n_1==1 | age>=36
	foreach i in e f g h i j k l {
	replace ancplace=1 if m14_1>0 &age<=36 & m57`i'_1==1
	}	
	foreach i in a b c d m n o p q r s t u v x  {
	replace ancplace=2 if m14_1>0 &age<=36 & m57`i'_1==1
	}	
label define ancplace 0"No ANC/No birth n past 3 years" 1"ANC provided by public sector" 2"ANC provided by other than public sector"
label values ancplace ancplace
label var ancplace "ANC for last birth in past 3 years"

*age at first sex
recode v531 (1/15=1 " <16") (16/17=2 " 16-17") (18/19=3 " 18/19") (20/96=4 " 20+") (97/99=.) if v531>0, gen(agesex)
label var agesex "Age at first sexual intercourse"

*Number of lifetime partners
recode v836 (1=1 " 1") (2=2 " 2") (3/4=3 " 3-4") (5/9=4 " 5-9") (10/95=5 " 10+") (98/99=.) if v531>0, gen(numprtnr)
label var numprtnr "Number of lifetime partners"

*Multiple sexual partners in the past 12 months
gen multisex= . 
replace multisex=0 if v766b==0
replace multisex=1 if (inrange(v527,100,251) | inrange(v527,300,311)) & v766b==1
replace multisex=2 if (inrange(v527,100,251) | inrange(v527,300,311)) & inrange(v766b,2,99)
replace multisex=. if v531==0
label define multisex 0" 0" 1" 1" 2 " 2+"
label values multisex multisex
label var multisex "Multiple sexual partners in past 12 months"

*Non-marital, non-cohabiting partner in the past 12 months
recode v766a (0=0 " 0") (1=1 " 1") (2/95=2 " 2+") (98/99=.) if v531>0, gen(prtnrcohab)

*Condom use at last sexual intercourse in past 12 months
gen condomuse=.
replace condomuse=0 if v766b==0
replace condomuse=1 if v761==0 
replace condomuse=2 if v761==1 
replace condomuse=. if v531==0
label define condomuse 0"No sex in past 12 months" 1"Did not use condom" 2"Used condom"
label values condomuse condomuse
label var condomuse "Condom use at last sexual intercourse in the past 12 months"

*Paid for sex in the past 12 months
gen paidsex= v793
replace paidsex=2 if v793a==0  
replace paidsex=. if v793==. | v531==0
label define paidsex 0"No" 1"Yes-Used condom" 2"Yes-Did not use condom"
label values paidsex paidsex
label var paidsex "Paid for sexual intercourse in the past 12 months"

*STI in the past 12 months
gen sti12m= v763a==1 | v763b==1 | v763c==1 
replace sti12m=. if v531==0 | v531==99 | v531==.
label values sti12m yesno
label var sti12m "Had an STI or STI symptoms in the past 12 months"

*Had prior HIV test and whether they received results
gen test_prior = .
replace test_prior = 1 if v781==1 & v828==1
replace test_prior = 2 if v781==1 & v828==0
replace test_prior = 3 if v781==0 
replace test_prior =. if v531==0
label define test_prior 1"Tested and received results" 2"Tested and did not receive results" 3"Never tested"
label values test_prior test_prior
label var test_prior "Prior HIV testing status and whether received test result"

* new age variable among young. 
recode v012 (15/17=1 " 15-17") (18/19=2 " 18-19") (20/22=3 " 20-22") (23/24=4 " 23-24") (else=.), gen(age_yng)