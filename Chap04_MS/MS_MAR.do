/*******************************************************************************
Program: 			MS_MAR.do
Purpose: 			Code to create marital indicators
Data inputs: 		IR and MR dataset
Data outputs:		coded variables and scalars
Author:				Thomas Pullum and Courtney Allen for code share project
Date last modified: September, 2019 by Courtney Allen 
Note:				
*********************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
	
ms_mar_stat		"Current marital status"
ms_mar_union	"Currently in union"
ms_mar_never	"Never in union"
ms_afm_15		"First marriage by age 15"
ms_afm_18		"First marriage by age 18"
ms_afm_20		"First marriage by age 20"
ms_afm_22		"First marriage by age 22"
ms_afm_25		"First marriage by age 25"
ms_mafm_20		"Median age at first marriage among age 20-49" (this is a scalar, not a variable)
ms_mafm_25		"Median age at first marriage among age 25-49" (this is a scalar, not a variable)

ONLY IN IR FILES:
ms_cowives_num	"Number of co-wives"
ms_cowives_any	"One or more co-wives"

ONLY IN MR FILES:
ms_wives_num	"Number of wives"

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
gen mafm_`a'`b'_`y'`x'=smedian 

//label subgroup categories
	label var mafm_`a'`b'_`y'`x' "Median age at first marriage among `a' to `b' yr olds, `y'"

	if "`y'" != "all" {
	local lab_val: value label `y'
	local lab_cat : label `lab_val' `x'
	label var mafm_`a'`b'_`y'`x' "Median age at first marriage among `a' to `b' yr olds, `y': `lab_cat'"
	}
	
	//replace median with O and label "NA" if no median can be calculated for age group
	replace mafm_`a'`b'_`y'`x' = 0 if mafm_`a'`b'_`y'`x'>beg_age
	if mafm_`a'`b'_`y'`x' ==0 {
	label val mafm_`a'`b'_`y'`x' NA
	}

}
}


scalar drop smedian

end
*********************************************************************************



if file=="IR" {

//Median age at first marriage
	//make subgroups here//
	gen all = 1
	clonevar region = v024
	clonevar wealth = v190
	clonevar education = v149
	clonevar residence = v025
	label define NA 0 "NA" //for sub groups where no median can be defined

	
	//setup variables for median age at first marriage calculated from v511, for women age 20 to 49
	gen afm=v511
	replace afm=99 if v511==. 
	gen age=afm
	gen agevar = v012
	gen weightvar = v005
	//create median age at first marriage for each 5 yr age group
	tokenize 	  19 24 29 34 39 44 49 49 49
	foreach x in  15 20 25 30 35 40 45 20 25 {
				scalar beg_age = `x'
				scalar end_age = `1'
				calc_median_age
				
				macro shift
				}
				
//Marital status
recode v501 (0=0 "Never married") (1=1 "Married") (2=2 "Living together") ///
(3=3 "Widowed") (4=4 "Divorced") (5=5 "Separated"), gen(ms_mar_stat)
label var ms_mar_stat "Current marital status"

recode v501 (0 3/5 =0 "Not in union") (1/2=1 "In union"), gen(ms_mar_union)
label var ms_mar_union "Currently in union"

gen ms_mar_never = 0
replace ms_mar_never = 1 if v501==0
label var ms_mar_never "Never in union"


//Co-wives
recode v505 (0=0 "None") (1=1 "1") (2/97 = 2 "2+") (98=98 "Don't know"), gen(ms_cowives_num)
label var ms_cowives_num "Number of co-wives"

recode v505 (0 98 = 0 "None or DK") (1/97 = 1 "1+"), gen(ms_cowives_any)
label var ms_cowives_any "One or more co-wives"


//Married by specific ages
recode v511 (.=0) (0/14 = 1 "yes") (15/49 = 0 "no"), gen (ms_afm_15)
label var ms_afm_15 "First marriage by age 15"

recode v511 (.=0) (0/17 = 1 "yes") (18/49 = 0 "no"), gen (ms_afm_18)
replace ms_afm_18 = . if v012<18
label var ms_afm_18 "First marriage by age 18"

recode v511 (.=0) (0/19 = 1 "yes") (20/49 = 0 "no"), gen (ms_afm_20)
replace ms_afm_20 = . if v012<20
label var ms_afm_20 "First marriage by age 20"

recode v511 (.=0) (0/21 = 1 "yes") (22/49 = 0 "no"), gen (ms_afm_22)
replace ms_afm_22 = . if v012<22
label var ms_afm_22 "First marriage by age 22"

recode v511 (.=0) (0/24 = 1 "yes") (25/49 = 0 "no"), gen (ms_afm_25)
replace ms_afm_25 = . if v012<25
label var ms_afm_25 "First marriage by age 25"

drop all region residence education wealth age agevar weightvar
label drop NA
}




*****************************************************************************************************




* indicators from MR file
if file=="MR" {

//Median age at first marriage
	//make subgroups here//
	gen all = 1
	clonevar region = mv024
	clonevar wealth = mv190
	clonevar education = mv149
	clonevar residence = mv025
	label define NA 0 "NA" //for sub groups where no median can be defined

	
	//setup variables for median age at first marriage calculated from v511, for women age 20 to 49
	gen afm=mv511
	replace afm=99 if mv511==. 
	gen age=afm
	gen agevar = mv012
	gen weightvar = mv005

	//create median age at first marriage for each 5 yr age group - Men typically have higher age groups
	tokenize 	  19 24 29 34 39 44 49 49 49 59 59 59
	foreach x in  15 20 25 30 35 40 45 20 25 20 25 30{
				scalar beg_age = `x'
				scalar end_age = `1'
				calc_median_age
				
				macro shift
				}


	
//Marital status
recode mv501 (0=0 "Never married") (1=1 "Married") (2=2 "Living together") ///
(3=3 "Widowed") (4=4 "Divorced") (5=5 "Separated"), gen(ms_mar_stat)
label var ms_mar_stat "Current marital status"

recode mv501 (0 3/5 =0 "Not in union") (1/2=1 "In union"), gen(ms_mar_union)
label var ms_mar_union "Currently in union"

gen ms_mar_never = 0
replace ms_mar_never = 1 if mv501==0
label var ms_mar_never "Never in union"


//Number of wives
recode mv505 (1=1 "1") (2/97 = 2 "2+") (98=98 "Don't know"), gen(ms_wives_num)
label var ms_wives_num "Number of wives"


//Married by specific ages
recode mv511 (.=0) (0/14 = 1 "yes") (15/max = 0 "no"), gen (ms_afm_15)
label var ms_afm_15 "First marriage by age 15"

recode mv511 (.=0) (0/17 = 1 "yes") (18/max = 0 "no"), gen (ms_afm_18)
replace ms_afm_18 = . if mv012<18
label var ms_afm_18 "First marriage by age 18"

recode mv511 (.=0) (0/19 = 1 "yes") (20/max = 0 "no"), gen (ms_afm_20)
replace ms_afm_20 = . if mv012<20
label var ms_afm_20 "First marriage by age 20"

recode mv511 (.=0) (0/21 = 1 "yes") (22/max = 0 "no"), gen (ms_afm_22)
replace ms_afm_22 = . if mv012<22
label var ms_afm_22 "First marriage by age 22"

recode mv511 (.=0) (0/24 = 1 "yes") (25/max = 0 "no"), gen (ms_afm_25)
replace ms_afm_25 = . if mv012<25
label var ms_afm_25 "First marriage by age 25"

drop all region residence education wealth age agevar weightvar
label drop NA
}