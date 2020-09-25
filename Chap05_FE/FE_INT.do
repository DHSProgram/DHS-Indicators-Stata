/*******************************************************************************
Program: 			FE_INT.do
Purpose: 			Code fertility indicators from birth history reflecting birth intervals 
Data inputs: 		BR data files
Data outputs:		coded variables
Author:				Courtney Allen 
Date last modified: September 4, 2020
*******************************************************************************/

/*______________________________________________________________________________
Variables created in this file:

//BIRTH INTERVALS
fe_int			"Birth interval of recent non-first births"
fe_age_int		"Age groups for birth interval table"
fe_bord			"Birth order"
fe_int_med		"Median number of mos since preceding birth"
fe_pre_sex		"Sex of preceding birth"
fe_pre_surv		"Survival of preceding birth"
med_mo_subgroup "Median months since previous birth"

//OTHER INSTRUCTIONS
Change subgroups on line 42-49 and line 165 if other subgroups are needed for mean and medians
______________________________________________________________________________*/
*-->EDIT subgroups here if other subgroups are needed. 
****Subgroups currently include: Residence, region, education, and wealth.
	gen all = 1
	clonevar region = v024
	clonevar wealth = v190
	clonevar education = v149
	clonevar residence = v025
	label define NA 0 "NA" //for sub groups where no median can be defined
	label define yesnolabel 0 "no" 1 "yes" //for all yes/no binary variables
	
	local subgroup region education wealth residence

//generate weight variable
cap drop wt
gen wt = v005/1000000

**BIRTH INTERVALS

	//Group mother's age groups for birth interval table
	recode v013 (1=1 "15-19") (2/3 = 2 "20-29") (4/5 = 3 "30-39") (6/7 = 4 "40-49"), gen(fe_age_int) label(fe_age_int_lab)
	label var fe_age_int "Age groups for birth intervals table"

	//Create birth interval, excluding first births and their multiples
	gen fe_bord = bord if b0 < 2
	replace fe_bord = bord - b0 + 1 if b0 > 1
	recode fe_bord (1 =1 "1") (2/3 = 2 "2-3") (4/6 = 4 "4-6") (7/max = 7 "7+"), gen(fe_bord_cat) label(fe_bord_lab)
	label var fe_bord_cat "Birth order categories"
	
	//Birth interval, number of months since preceding birth
	recode b11 (min/17= 1 "less than 17 months") (18/23 = 2 "18-23 months") ///
			  (24/35 = 3 "24-35 months") (36/47 = 4 "36-47 months") (48/59 = 5 "48-59 months") ///
			  (60/max = 6 "60+ months"), gen(fe_int) label(fe_int_lab)
	label var fe_int "Months since preceding birth"
		
	//Sex of preceding birth, created for subcategory in final tables
	sort caseid bord
	gen fe_pre_sex = b4[_n-1] if caseid==caseid[_n-1]
	*replace fe_pre_sex = b4[_n-2]
	label define sexlabel 1 "male" 2 "female"
	label val fe_pre_sex sexlabel
	label var fe_pre_sex "Sex of preceding birth"
	
	//Survival of preceding birth, created for subcategory in final tables
	sort caseid bord
	gen fe_pre_surv = b5[_n-1] if caseid==caseid[_n-1]
	label define alivelabel 0 "not alive" 1 "alive"
	label val fe_pre_surv alivelabel
	label var fe_pre_surv "Survival of preceding birth"

	//now drop of children over 59 months, no longer needed for tabulations
	drop if b19>59
*********************************************************************************
program define calc_median_mo

*-->EDIT subgroups here if other subgroups are needed. 
	local subgroup fe_age_int fe_pre_sex fe_pre_surv fe_bord_cat region education wealth residence all

	foreach y in `subgroup' {
		levelsof `y', local(`y'lv)
		foreach x of local `y'lv {
		
	summarize time [fweight=weightvar] if  `y'==`x', detail

	scalar sp50=r(p50)

	gen dummy=.
	replace dummy=0 if  `y'==`x'
	replace dummy=1 if  `y'==`x' & time<sp50 
	summarize dummy[fweight=weightvar]
	scalar sL=r(mean)

	replace dummy=.
	replace dummy=0 if `y'==`x'
	replace dummy=1 if  `y'==`x' & time<=sp50
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
	gen med_mo_`y'`x'=smedian 

	//label subgroup categories
	label var med_mo_`y'`x' "Median months since previous birth, `y'"

	if "`y'" != "all" {
	local lab_val: value label `y'
	local lab_cat : label `lab_val' `x'
	label var med_mo_`y'`x' "Median months since previous birth, `y': `lab_cat'"
		}
		}
	}


	scalar drop smedian

end
*********************************************************************************
	
	//setup variables for median number of months since previous birth calculated from b11
	gen fe_month_prev=b11
	drop if fe_month_prev==.
	gen time=fe_month_prev
	gen weightvar = v005
	calc_median_mo
	
	program drop calc_median_mo
	
