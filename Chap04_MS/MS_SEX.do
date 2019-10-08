/*******************************************************************************
Program: 			MS_SEX.do
Purpose: 			Code to create sexual activity indicators
Data inputs: 		IR and MR survey list
Data outputs:		coded variables and scalars
Author:				Courtney Allen for code share project
Date last modified: September, 2019 by Courtney Allen 
Note:				
*********************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
	
mms_afs_15		"First sexual intercourse by age 15"
ms_afs_18		"First sexual intercourse by age 18"
ms_afs_20		"First sexual intercourse by age 20"
ms_afs_22		"First sexual intercourse by age 22"
ms_afs_25		"First sexual intercourse by age 25"
ms_mafs_25		 Median age at first sexual intercourse among age 25-49" (scalar, not a variable)
ms_sex_never	"Never had intercourse"

----------------------------------------------------------------------------*/

/* NOTES
		sp50 is the integer-valued median produced by summarize, detail;
		what we need is an interpolated or fractional value of the median.

		In the program, "age" is reset as age at first cohabitation.
		
		sL and sU are the cumulative values of the distribution that straddle
		the integer-valued median.
		
		The final result is stored as a scalar.
		
		Medians can found for subgroups by adding to the variable list below in 
		the same manner (i.e. subgroup1 = var ; subgroup2 = var etc, then subgroup
		names must be added to the local on line 55
		**************************************************************************/


//Define program to calculate median age
*********************************************************************************
program define calc_median_age

local subgroup region education wealth residence all

foreach y in `subgroup' {
	levelsof `y', local(`y'lv)
	foreach x of local `y'lv {
	
local a= beg_age
local b= end_age
cap summarize age [fweight=weightvar] if agevar>= beg_age & agevar<= end_age & `y'==`x', detail

scalar sp50=r(p50)

gen dummy=.
replace dummy=0 if agevar>= beg_age & agevar<= end_age & `y'==`x'
replace dummy=1 if agevar>= beg_age & agevar<= end_age & `y'==`x' & age<sp50 
summarize dummy [fweight=weightvar]
scalar sL=r(mean)

replace dummy=.
replace dummy=0 if agevar>= beg_age & agevar<= end_age &`y'==`x'
replace dummy=1 if agevar>= beg_age & agevar<= end_age & `y'==`x' & age<=sp50
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
gen mafs_`a'`b'_`y'`x'=smedian 

//label subgroup categories
	label var mafs_`a'`b'_`y'`x' "Median age at first sex among `a' to `b' yr olds, `y'"

	if "`y'" != "all" {
	local lab_val: value label `y'
	local lab_cat : label `lab_val' `x'
	label var mafs_`a'`b'_`y'`x' "Median age at first sex among `a' to `b' yr olds, `y': `lab_cat'"
	}
	
	//replace median with O and label "NA" if no median can be calculated for age group
	replace mafs_`a'`b'_`y'`x' = 0 if mafs_`a'`b'_`y'`x'>beg_age
	if mafs_`a'`b'_`y'`x' ==0 {
	label val mafs_`a'`b'_`y'`x' NA
	}

}
}


scalar drop smedian

end
*********************************************************************************



if file=="IR" {

//Median age at first sex
	//make subgroups here//
	gen all = 1
	clonevar region = v024
	clonevar wealth = v190
	clonevar education = v149
	clonevar residence = v025
	label define NA 0 "NA" //for sub groups where no median can be defined

	
	//setup variables for median age at first sex calculated from v531, for women age 20 to 49
	gen afs=v531
	replace afs=99 if v531==0 
	gen age=afs
	gen agevar = v012
	gen weightvar = v005

	//create median age at first sex for each 5 yr age group
	tokenize 	  19 24 29 34 39 44 49 49 49
	foreach x in  15 20 25 30 35 40 45 20 25 {
				scalar beg_age = `x'
				scalar end_age = `1'
				calc_median_age
				
				macro shift
				}
				
//Never had sex
gen ms_sex_never = 0
replace ms_sex_never = 1 if v531==0
label var ms_sex_never "Never had sex"



//Had sex by specific ages
recode v531 (97 . =0) (1/14 = 1 "yes") (15/49 = 0 "no"), gen (ms_afs_15)
label var ms_afs_15 "First sex by age 15"

recode v531 (97 .=0) (1/17 = 1 "yes") (18/49 = 0 "no"), gen (ms_afs_18)
replace ms_afs_18 = . if v012<18
label var ms_afs_18 "First sex by age 18"

recode v531 (97 .=0) (1/19 = 1 "yes") (20/49 = 0 "no"), gen (ms_afs_20)
replace ms_afs_20 = . if v012<20
label var ms_afs_20 "First sex by age 20"

recode v531 (97 .=0) (1/21 = 1 "yes") (22/49 = 0 "no"), gen (ms_afs_22)
replace ms_afs_22 = . if v012<22
label var ms_afs_22 "First sex by age 22"

recode v531 (97 .=0) (1/24 = 1 "yes") (25/49 = 0 "no"), gen (ms_afs_25)
replace ms_afs_25 = . if v012<25
label var ms_afs_25 "First sex by age 25"

}




*****************************************************************************************************




* indicators from MR file
if file=="MR" {

//Median age at first sex
	//make subgroups here//
	gen all = 1
	clonevar region = mv024
	clonevar wealth = mv190
	clonevar education = mv149
	clonevar residence = mv025
	label define NA 0 "NA" //for sub groups where no median can be defined

	
	//setup variables for median age at first sex calculated from v531, for women age 20 to 49
	gen afs=mv531
	replace afs=99 if mv531==0
	gen age=afs
	gen agevar = mv012
	gen weightvar = mv005

	//create median age at first sex for each 5 yr age group - Men typically have higher age groups
	tokenize 	  19 24 29 34 39 44 49 49 49 59 59 59
	foreach x in  15 20 25 30 35 40 45 20 25 20 25 30{
				scalar beg_age = `x'
				scalar end_age = `1'
				calc_median_age
				
				macro shift
				}


	
//Never had sex
gen ms_sex_never = 0
replace ms_sex_never = 1 if mv531==0
label var ms_sex_never "Never had sex"



//Had sex by specific ages
recode mv531 (97 .=0) (1/14 = 1 "yes") (15/max = 0 "no"), gen (ms_afs_15)
label var ms_afs_15 "First sex by age 15"

recode mv531 (97 .=0) (1/17 = 1 "yes") (18/max = 0 "no"), gen (ms_afs_18)
replace ms_afs_18 = . if mv012<18
label var ms_afs_18 "First sex by age 18"

recode mv531 (97 .=0) (1/19 = 1 "yes") (20/max = 0 "no"), gen (ms_afs_20)
replace ms_afs_20 = . if mv012<20
label var ms_afs_20 "First sex by age 20"

recode mv531 (97 .=0) (1/21 = 1 "yes") (22/max = 0 "no"), gen (ms_afs_22)
replace ms_afs_22 = . if mv012<22
label var ms_afs_22 "First sex by age 22"

recode mv531 (97 .=0) (1/24 = 1 "yes") (25/max = 0 "no"), gen (ms_afs_25)
replace ms_afs_25 = . if mv012<25
label var ms_afs_25 "First sex by age 25"

}