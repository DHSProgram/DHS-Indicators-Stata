/*****************************************************************************************************
Program: 			FE_FERT.do - DHS8 update
Purpose: 			Code currenty fertility indicators
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Tom Pullum
Date last modified: May 1, 2024 by Tom Pullum for DHS8
*****************************************************************************************************/

/*______________________________________________________________________________
Variables created in this file:

//FERTILITY
	fe_preg		"Currently pregnant"
	fe_ceb_num	"Number of children ever born (CEB)"
	fe_ceb_mean	"Mean number of CEB"
	fe_ceb_comp  	"Completed fertility - Mean number of CEB to women age 40-49"
	fe_live_mean	"Mean number of living children"

//MENARCHE
	fe_mens			"Age at first menstruation"

//MENOPAUSE
	fe_meno			"Menopausal"
	fe_meno_age		"Age intervals for table 5.9"

//TEEN PREGNANCY AND MOTHERHOOD; note changes from DHS7
* These variables are defined separately for age 15-19
	fe_teen_birth	"Teens who have had a live birth"
	fe_teen_preg	"Teens pregnant"
	fe_teen_beg	"Teens who have begun childbearing"
	fe_teen_loss	"Teens who have had a pregnancy loss"

	fe_teen_sex_before_15	"Teens who had sexual intercourse before age 15"
	fe_teen_mar_before_15	"Teens who were married before age 15"
	fe_teen_birth_before_15 "Teens who had a birth before 15"
	fe_teen_preg_before_15	"Teens who were pregnant before age 15"

//FIRST BIRTH
	fe_birth_never		"Never had a birth"
	fe_afb_15		"First birth by age 15"
	fe_afb_18		"First birth by age 18"
	fe_afb_20		"First birth by age 20"
	fe_afb_22		"First birth by age 22"
	fe_afb_25		"First birth by age 25"

______________________________________________________________________________*/

*********************************************************************************

program define construct_indicators

use "$datapath//$irdata.dta", clear
gen total=1
label variable total "Total"
label define total 1 "Total"
label values total total

keep v005 v011 v012 v013 v201 v211 v212 v213 v218 v226 v245 v246 v249 v405 v502 v511 v531 p3_0* p20_0* $gcovars
rename *_0* *_* 
gen wt=v005/1000000

**FERTILITY VARIABLES

	//Currently Pregnant
	gen fe_preg = v213 
	label val fe_preg yesnolabel 
	label var fe_preg "Currently pregnant"
		
	//Number of children ever born (CEB)
	recode v201 (0=0 "0") (1=1 "1") (2=2 "2") (3=3 "3") (4=4 "4") (5=5 "5") (6=6 "6") (7=7 "7") (8=8 "8") (9=9 "9") (10/max = 10 "10+"), gen(fe_ceb_num) 
	label var fe_ceb_num "Number of children ever born"

	//Mean number of children ever born (CEB)
			/*-------------------------------------------------------
			NOTE: Though this gives you the mean estimate, ignore 
			standard errors and confidence intervals because this data
			has not been survey set. Whenever standard errors are needed, 
			survey data must be survey set for robust estimates of standard
			errors.
			-------------------------------------------------------*/
		  
	//Completed fertility, mean number of CEB among women age 40-49
	gen fe_ceb_comp=v201 if v013>=6
	label var fe_ceb_comp "Mean CEB among women age 40-49"

		
	//Mean number of CEB among all women
	gen fe_ceb_mean=v201
	label var fe_ceb_mean "Mean CEB"

		
	//Mean number of living children among all women
	gen fe_live_mean= v218
	label var fe_live_mean "Mean number of living children"
	
		
**TEENAGE PREGNANCY AND MOTHERHOOD

	//Teens (women age 15-19) who have had a live birth
	gen     fe_teen_birth = v201
	replace fe_teen_birth=1 if v201>0
	replace fe_teen_birth=. if v013>1
	
	//Teens (women age 15-19) who have ever had a pregnancy loss
	gen     fe_teen_loss = 0 if v013==1
	replace fe_teen_loss = 1 if v013==1 & v245>0
	label val fe_teen_loss yesnolabel 
	label var fe_teen_loss "Teens who have had a pregnancy loss"

	//Teens (women age 15-19) who are currently pregnant
	gen     fe_teen_preg = 0 if v013==1
	replace fe_teen_preg = 1 if v013==1 & v213==1
	label val fe_teen_preg yesnolabel 
	label var fe_teen_preg "Teens currently pregnant"

	//Teens (women age 15-19) who were ever pregnant
	gen     fe_teen_ever_preg = 0 if v013==1
	replace fe_teen_ever_preg = 1 if v013==1 & (v201>0 | v213==1 | v245>0)
	label val fe_teen_ever_preg yesnolabel 
	label var fe_teen_ever_preg "Teens who were ever pregnant"

	//Teens (women age 15-19) who had sexual intercourse before age 15
	gen     fe_teen_sex_before_15 = 0 if v013==1 
	replace fe_teen_sex_before_15 = 1 if v013==1 & v531>0 & v531<15

	//Teens (women age 15-19) who were married before age 15
	gen     fe_teen_mar_before_15 = 0 if v013==1
	replace fe_teen_mar_before_15 = 1 if v013==1 & v511<15

	//Teens (women age 15-19) who had a birth before 15
	gen     fe_teen_birth_before_15 = 0 if v013==1
	replace fe_teen_birth_before_15 = 1 if v013==1 & v211<(v011+15*12)

	//Teens (women age 15-19) who were pregnant before age 15
	* Assume that the maximum value of v246 for v013=1 is 6
	gen     fe_teen_preg_before_15 = 0 if v013==1
	forvalues li=1/6 {
	replace fe_teen_preg_before_15 = 1 if v013==1 & v246==`li' & (p3_`li'-p20_`li')<(v011+15*12) 
	}

**MENOPAUSE
	
	//Women age 30-49 experiencing menopause (exclude pregnant or those with postpartum amenorrhea) 
	gen fe_meno = 0 if  v013>3
	replace fe_meno = 1 if (v226>5 & v226<997) & v213==0 & v405==0  & v013>3
	label val fe_meno yesnolabel 
	label var fe_meno "Experienced menopause"

	//Menopausal age group, 30-49, two-year intervals after 40
	egen fe_meno_age = cut(v012), at(0 30 35 40 42 44 46 48 50)
	label define fe_meno_age 30 "30-34" 35 "35-39" 40 "40-41" ///
						   42 "42-43" 44 "44-45" 46 "46-47" 48 "48-49"
	label val fe_meno_age fe_meno_age
	label var fe_meno_age "Age groups for menopause"

**AGE AT MENARCHE

gen fe_mens=v249
* Must omit codes 96 and 99 from the mean age (the last column of table 5.8)
replace fe_mens=. if fe_mens>=96

	gen     fe_mens_cat=1 if v249<=10
	replace fe_mens_cat=2 if v249==11
	replace fe_mens_cat=3 if v249==12
	replace fe_mens_cat=4 if v249==13
	replace fe_mens_cat=5 if v249==14
	replace fe_mens_cat=6 if v249>=15
	replace fe_mens_cat=8 if v249==96
	replace fe_mens_cat=9 if v249==98
label variable  fe_mens_cat "Age at menarche"
label define    fe_mens_cat 1 "<=10" 2 "11" 3 "12" 4 "13" 5 "14" 6 "15+" 8 "DK" 9 "Never"
label values    fe_mens_cat fe_mens_cat
	
**AGE AT FIRST BIRTH

	//First birth by specific ages
	recode v212 (.=0) (0/14 = 1 "yes") (15/49 = 0 "no"), gen (fe_afb_15)
	label var fe_afb_15 "First birth by age 15"

	recode v212 (.=0) (0/17 = 1 "yes") (18/49 = 0 "no"), gen (fe_afb_18)
	replace fe_afb_18 = . if v012<18
	label var fe_afb_18 "First birth by age 18"

	recode v212 (.=0) (0/19 = 1 "yes") (20/49 = 0 "no"), gen (fe_afb_20)
	replace fe_afb_20 = . if v012<20
	label var fe_afb_20 "First birth by age 20"

	recode v212 (.=0) (0/21 = 1 "yes") (22/49 = 0 "no"), gen (fe_afb_22)
	replace fe_afb_22 = . if v012<22
	label var fe_afb_22 "First birth by age 22"

	recode v212 (.=0) (0/24 = 1 "yes") (25/49 = 0 "no"), gen (fe_afb_25)
	replace fe_afb_25 = . if v012<25
	label var fe_afb_25 "First birth by age 25"

	//Never had a first birth
	gen fe_birth_never = 0
	replace fe_birth_never = 1 if v201==0
	label val fe_birth_never yesnolabel
	label var fe_birth_never "Never had a birth"
	
end

*********************************************************************************

program define calc_median_age

* MEDIAN AGE AT FIRST BIRTH

	local a= beg_age
	local b= end_age
	cap summarize age [fweight=weightvar] if agevar>= beg_age & agevar<= end_age, detail

	scalar sp50=r(p50)

	gen dummy=.
	replace dummy=0 if agevar>= beg_age & agevar<= end_age
	replace dummy=1 if agevar>= beg_age & agevar<= end_age & age<sp50 
	summarize dummy [fweight=weightvar]
	scalar sL=r(mean)

	replace dummy=.
	replace dummy=0 if agevar>= beg_age & agevar<= end_age 
	replace dummy=1 if agevar>= beg_age & agevar<= end_age & age<=sp50
	summarize dummy [fweight=weightvar]
	scalar sU=r(mean)
	drop dummy

	scalar smedian=round(sp50+(.5-sL)/(sU-sL),.01)
	scalar list sp50 sL sU smedian

	// warning if sL and sU are miscalculated
	if sL>.5 | sU<.5 {
	//ERROR IN CALCULATION OF L AND/OR U
	}

	//create variable for median
	gen mafb_`a'`b'=smedian 

	//label subgroup categories
	label var mafb_`a'`b' "Median age at first birth among `a' to `b' yr olds"

end

*********************************************************************************

program define median_age

	//setup variables for median age at first birth calculated from v212
	gen afb=v212
	replace afb=99 if v212==. 
	gen age=afb
	gen agevar = v012
	gen weightvar = v005
	
	//create median age at first birth for each 5 yr age group
	tokenize     19 24 29 34 39 44 49 49 49
	foreach x in 15 20 25 30 35 40 45 20 25 {
				scalar beg_age = `x'
				scalar end_age = `1'
				quietly calc_median_age
				
				macro shift
				}

save "$resultspath/fertility_variables.dta", replace

end

**********************************************************************

program define make_tables_with_covariates

* This routine constructs the tables from the IR file with covariates in chapter 5: 
* Table 5.2 (columns 2 and 3, fe_preg and fe_ceb_comp)
* Table 5.11 (median age at first birth)
* Table 5.12 (teenage pregnancy/fertility)
* For Table 5.12 we need an extra covariate, age in single years 15-19

* The stub and relevant columns can then be extracted for each of these tables

local lfevars fe_preg fe_ceb_comp
local lfeteenvars fe_teen_birth fe_teen_loss fe_teen_preg fe_teen_ever_preg

use "$resultspath/fertility_variables.dta", clear

keep wt v005 v012 v013 $gcovars `lfevars' afb `lfeteenvars'

* For Table 5.11 we need some setup to be able to run calc_median_age
gen keep_mafb_2049=.
gen keep_mafb_2549=.
gen weightvar=v005
scalar end_age=49

* For Table 5.12 we need an extra covariate, age in single years 15-19
gen teenage=v012
replace teenage=. if v012>=20
label variable teenage "Age"

save "$resultspath/temp0.dta", replace

scalar svar_sequence=1

* Define a local that includes teenage as well as the standard covariates in gcovars
local lcovars teenage $gcovars

quietly foreach lc of local lcovars {
use "$resultspath/temp0.dta", clear

* For table 5.11, calculate mafb 20-49 and 25-49 within each category of each covariate
gen age=afb

levelsof `lc', local(levels_`lc')
  foreach li of local levels_`lc' {
  scalar beg_age=20
  gen agevar=.
  replace agevar=v012 if `lc'==`li' & v012>=20
  calc_median_age
  drop agevar mafb* 
  replace keep_mafb_2049=smedian if `lc'==`li' & v012>=20
  scalar beg_age=25
  gen agevar=.
  replace agevar=v012 if `lc'==`li' & v012>=25
  calc_median_age
  drop agevar mafb*
  replace keep_mafb_2549=smedian if `lc'==`li' & v012>=25
}

rename keep_* *
collapse (mean) fe* mafb* [iweight=wt],by(`lc')

gen var_sequence=svar_sequence
gen variable="`lc'"
gen value=`lc'

* Put the variable labels into a new string variable
local llabel : variable label `lc'
gen str40 variable_label="`llabel'"

* Put the value labels into a new string variable
gen str20 value_label="."
levelsof `lc', local(levels)
foreach li of local levels {
local lname : label (`lc') `li'
replace value_label="`lname'" if `lc'==`li'
}

drop `lc'
if svar_sequence>1 {
append using "$resultspath/temp1.dta"
}

save"$resultspath/temp1.dta", replace
scalar svar_sequence=svar_sequence+1
}

replace fe_preg=100*fe_preg

foreach lf of local lfeteenvars {
replace `lf'=100*`lf'
}

replace variable_label=strproper(variable_label)
replace value_label=strproper(value_label)

sort var_sequence value
order var_sequence variable value variable_label value_label `lfevars' `lfeteenvars'
format fe* %5.2f

sort var_sequence value
list, table clean

local lvars variable value variable_label value_label
save "$resultspath/tables_with_covariates.dta", replace

keep `lvars' `lfevars'
keep if variable~="teenage"
list, table clean
save "$resultspath/table_5pt2.dta", replace
export excel if variable~="teenage" using "$resultspath/FE_tables.xlsx", sheet("Table 5.2 cols 2&3") sheetreplace firstrow(var)

use "$resultspath/tables_with_covariates.dta", clear
keep `lvars' mafb*
keep if value<.
drop if variable=="teenage"
list, table clean
save "$resultspath/table_5pt11.dta", replace
export excel if value<. using "$resultspath/FE_tables.xlsx", sheet("Table 5.11") sheetreplace firstrow(var)

use "$resultspath/tables_with_covariates.dta", clear
keep `lvars' `lfeteenvars'
keep if value<.
list, table clean
save "$resultspath/table_5pt12.dta", replace
export excel if value<. using "$resultspath/FE_tables.xlsx", sheet("Table 5.12") sheetreplace firstrow(var)

erase "$resultspath/temp0.dta"

end

*********************************************************************************

program define make_table_5pt4

use "$resultspath/fertility_variables.dta", clear

keep wt v005 v013 v502 fe_ceb_num fe_ceb_mean fe_live_mean

forvalues lc=0/10 {
gen ceb`lc'=0
replace ceb`lc'=1 if fe_ceb_num==`lc'
}
gen cases=1
save "$resultspath//temp0.dta", replace

use "$resultspath//temp0.dta", clear
collapse (mean) ceb0-ceb10 (sum) cases (mean) fe_*_mean [iweight=wt], by(v013) 
save "$resultspath//temp1.dta", replace

use "$resultspath//temp0.dta", clear
collapse (mean) ceb0-ceb10 (sum) cases (mean) fe_*_mean [iweight=wt] 
gen v013=100
save "$resultspath//temp2.dta", replace

use "$resultspath//temp0.dta", clear
collapse (mean) ceb0-ceb10 (sum) cases (mean) fe_*_mean [iweight=wt] if v502==1, by(v013) 
save "$resultspath//temp3.dta", replace

use "$resultspath/temp0.dta", clear
collapse (mean) ceb0-ceb10 (sum) cases (mean) fe_*_mean [iweight=wt] if v502==1
gen v013=100
save "$resultspath//temp4.dta", replace

use "$resultspath//temp1.dta", clear
append using "$resultspath//temp2.dta"
append using "$resultspath//temp3.dta"
append using "$resultspath//temp4.dta"

forvalues lc=0/10 {
replace ceb`lc'=100*ceb`lc'
}

gen total=100
label define V013 100 "Total", modify
order v013 ceb* total cases fe*_mean
format ceb* fe* %6.2f
format cases %8.1fc
list, table clean

erase "$resultspath//temp1.dta"
erase "$resultspath//temp2.dta"
erase "$resultspath//temp3.dta"
erase "$resultspath//temp4.dta"

save "$resultspath//table_5pt4.dta", replace
export excel using "$resultspath//FE_tables.xlsx", sheet("Table 5.4") sheetreplace firstrow(var)

end

*********************************************************************************

program define make_table_5pt8

* Make Table 5.8
* The abbreviation "mens" refers to "menstruation", not "men's"

use "$resultspath//fertility_variables.dta", clear
keep wt v013 fe_mens_cat fe_mens
gen cases=1
levelsof fe_mens_cat, local(label_mens_cat)
foreach li of local label_mens_cat {
gen fe_mens_cat_`li'=0 if fe_mens_cat<.
replace fe_mens_cat_`li'=100 if fe_mens_cat==`li'
* =100 instead of =1 so the means will be percentages
}

save "$resultspath//temp0.dta", replace
collapse (mean) fe_mens_cat_* fe_mens (sum) cases [iweight=wt], by(v013)
save "$resultspath//table_5pt8.dta", replace

use "$resultspath//temp0.dta", clear
collapse (mean) fe_mens_cat_* fe_mens (sum) cases [iweight=wt]
gen v013=100
append using "$resultspath//table_5pt8.dta"
sort v013
label define V013 100 "Total", modify
label values v013 V013
gen total=100
order v013 fe_mens_cat_* total cases fe_mens

label variable fe_mens_cat_1 "<=10"
label variable fe_mens_cat_2 "11"
label variable fe_mens_cat_3 "12"
label variable fe_mens_cat_4 "13"
label variable fe_mens_cat_5 "14"
label variable fe_mens_cat_6 "15+"
label variable fe_mens_cat_8 "DK"
label variable fe_mens_cat_9 "Never"

format fe_mens* %6.2f
format cases %8.1fc
list, table clean

save "$resultspath/table_5pt8.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.8") sheetreplace firstrow(var)

end

*********************************************************************************

program define make_table_5pt9

use "$resultspath/fertility_variables.dta", clear
keep wt fe_meno*
gen cases=1
drop if fe_meno==.
save "$resultspath/temp0.dta", replace

collapse (mean) fe_meno (sum) cases [iweight=wt], by(fe_meno_age)
save "$resultspath/table_5pt9.dta", replace

use "$resultspath/temp0.dta", clear
collapse (mean) fe_meno (sum) cases [iweight=wt]
gen fe_meno_age=100

append using "$resultspath/table_5pt9.dta"
replace fe_meno=100*fe_meno
label define fe_meno_age 100 "Total", modify
label values fe_meno_age fe_meno_age

sort fe_meno_age
order fe_meno_age fe_meno cases
format fe_meno %6.1f
format cases %8.1fc
save "$resultspath/table_5pt9.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.9") sheetreplace firstrow(var)

list, table clean

erase "$resultspath/temp0.dta"

end

*********************************************************************************

program define make_table_5pt10

use "$resultspath/fertility_variables.dta", clear

keep wt v013 fe_afb* fe_birth_never afb mafb_*
gen cases=1

gen mafb=.
replace mafb=mafb_1519 if v013==1
replace mafb=mafb_2024 if v013==2
replace mafb=mafb_2529 if v013==3
replace mafb=mafb_3034 if v013==4
replace mafb=mafb_3539 if v013==5
replace mafb=mafb_4044 if v013==6
replace mafb=mafb_4549 if v013==7


save "$resultspath/temp0.dta", replace

use "$resultspath/temp0.dta", clear
collapse (mean) fe_afb_* fe_birth_never (sum) cases (mean) afb mafb [iweight=wt], by(v013)
save "$resultspath/temp1.dta", replace

use "$resultspath/temp0.dta", clear
drop if v013<=1
collapse (mean) fe_afb_* fe_birth_never (sum) cases (mean) afb mafb_2049 [iweight=wt]
gen v013=8
rename mafb_2049 mafb
save "$resultspath/temp2.dta", replace

use "$resultspath/temp0.dta", clear
drop if v013<=2
collapse (mean) fe_afb_* fe_birth_never (sum) cases (mean) afb mafb_2549 [iweight=wt]
gen v013=9
rename mafb_2549 mafb
save "$resultspath/temp3.dta", replace

use "$resultspath/temp1.dta", clear
append using "$resultspath/temp2.dta"
append using "$resultspath/temp3.dta"

foreach lc in 15 18 20 22 25 {
replace fe_afb_`lc'=100*fe_afb_`lc'
}
replace fe_birth_never=100*fe_birth_never
replace afb=100*afb
replace mafb=. if mafb>=50
label define V013 8 "20-49" 9 "25-49", modify
label values v013 V013 

format fe* afb mafb %6.2f
format cases %8.1fc
list, table clean

erase "$resultspath/temp0.dta"
erase "$resultspath/temp1.dta"
erase "$resultspath/temp2.dta"
erase "$resultspath/temp3.dta"

save "$resultspath/table_5pt10.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.10") sheetreplace firstrow(var)

end

*********************************************************************************

program define make_table_5pt13_women

* Make the first row of Table 5.13

use "$resultspath/fertility_variables.dta", clear
keep if v013==1
keep wt fe_teen_*_before_15
gen cases=1

collapse (mean) fe_teen_*_before_15 (sum) cases [iweight=wt]

local types sex mar birth preg
foreach lt of local types {
replace fe_teen_`lt'_before_15=100*fe_teen_`lt'_before_15
}

format fe* %6.2f
format cases %8.2fc
gen sex=2
label define sex 1 "Men" 2 "Women"
label values sex sex
gen sequence=1
order sequence sex fe_teen* cases
list, table clean

save "$resultspath/table_5pt13_women.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.13_women") sheetreplace firstrow(var)

end

*********************************************************************************

program define make_table_5pt13_men

* Make the second row of Table 5.13
* This is the only place in Chapter 5 which requires the MR file.
* All of the file preparation is done within this routine.

use "$datapath//$mrdata.dta", clear
gen wt=mv005/1000000
gen cases=1
keep if mv013==1

keep wt cases mv011 mv212 mv511 mv531

	//Teens (men age 15-19) who had sexual intercourse before age 15
	gen     fe_teen_sex_before_15 = 0  
	replace fe_teen_sex_before_15 = 1 if mv531>0 & mv531<15

	//Teens (men age 15-19) who were married before age 15
	gen     fe_teen_mar_before_15 = 0 
	replace fe_teen_mar_before_15 = 1 if mv511<15

	//Teens (men age 15-19) who had a birth before 15
	gen     fe_teen_birth_before_15 = 0 
	replace fe_teen_birth_before_15 = 1 if mv212<15

collapse (mean) fe_teen* (sum) cases [iweight=wt]
gen fe_teen_preg_before_15 = .

local types sex mar birth
foreach lt of local types {
replace fe_teen_`lt'_before_15=100*fe_teen_`lt'_before_15
}

format fe* %6.2f
format cases %8.2fc
gen sex=1
label define sex 1 "Men" 2 "Women"
label values sex sex
gen sequence=2
order sequence sex fe_teen* cases
format fe* %6.2f
format cases %8.1fc
list, table clean
 
save "$resultspath/table_5pt13_men.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.13_men") sheetreplace firstrow(var)

* table_5pt13_men.dta can be appended to table_5pt13_women.dta and sorted on "sequence" to get table 5.13

end

*********************************************************************************
*********************************************************************************
*********************************************************************************
*********************************************************************************
*********************************************************************************
*********************************************************************************
* Execution begins here
	

quietly construct_indicators
quietly median_age

* The following produces tables 5.2 (cols 2 and 3), 5.11, 5.12
make_tables_with_covariates
make_table_5pt4
make_table_5pt8
make_table_5pt9
make_table_5pt10
make_table_5pt13_women
make_table_5pt13_men

erase "$resultspath/fertility_variables.dta"
erase "$resultspath/tables_with_covariates.dta"

program drop _all

