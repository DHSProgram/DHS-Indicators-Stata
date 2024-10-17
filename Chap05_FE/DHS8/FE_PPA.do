/*******************************************************************************
Program: 				FE_PPA.do - DHS8 update
Purpose: 				Creates the indicators for median duration of postpartum amenorrhea,
						abstinence, and insusceptibility following a pregnancy 
						using the NR file (the cases are pregnancies)
Data outputs:			coded variables, table output on screen, and excel tables.  
Author: 				Tom Pullum and Courtney Allen
Date last modified:		Tom Pullum May 1, 2024 for DHS8

*******************************************************************************/

/* Notes -----------------------------------------------------------------------
	
	- Before DHS8 these indicators used births and the KR file rather than pregnancies and the NR file;
	  some terminology refers to births rather than pregnancies

	- Children from multiple pregnancies are dropped, except for the first one; drop if p0>1

	- "months_since_birth" is b19 (age in months if the child is alive)

	- In older surveys that do not include b19, months_since_birth is v008-b3

	- group2 is a grouping into 2-month intervals

	- DHS_phase is the version of DHS.  Could be taken from the 3rd character of
	  v000 but is based on whether b19 is present;
	  just use DHS_phase=6 if it is not and DHSphase=7 if it is present.  
	  Only relevant for the midpoints of group2.

	- Midpoints:
		Up to and including DHS6, the midpoints are supposed to be .75, 2.5, 4.5, 6.5, etc.
		After DHS6, the midpoints are supposed to be 1, 3, 5, 7, etc.

	- It can happen that b19 is present but the DHS6 coding was used for the 
	  midpoints in the tables (such as in ET 2016 survey).
------------------------------------------------------------------------------*/


*********************************************************************

program define construct_indicators

use "$datapath//$nrdata.dta", clear

* reduce to births and stillbirths
keep if p32<=2 & p19<36
gen total=1
label variable total "Total"
label define total 1 "Total"
label values total total
	keep caseid v001 v002 v003 v005 pidxb v013 p* v405 v406 $gcovars 

	// Identify the correct children and construct the two relevant age distributions
		* v405: Currently amenorrheic
		* v406: Currently abstaining


gen months_since_birth=p19


	// group2 is the code for the two-month age groups: 0-1, 2-3, etc.
	* Needed for overall value
	gen group2=1+int(months_since_birth/2) if months_since_birth<=35
	drop if group2==.

	//midpoint2 (before smoothing) is not needed, but if it were, this is what it would be
	*gen midpoint2=2*group2-1
	
	label define group2 	1 "0-1"    2 "2-3"    3 "4-5"    4 "6-7"    5 "8-9" 	///
							6 "10-11"  7 "12-13"  8 "14-15"  9 "16-17" 10 "18-19"  	///
							11 "20-21" 12 "22-23" 13 "24-25" 14 "26-27" 15 "28-29" 	///
							16 "30-31" 17 "32-33" 18 "34-35" 100 "Total" 200 "Median" 300 "Mean"
	label values group2 group2
	

	// create unweighted and weighted denominators
	gen cases=1
	gen wt=v005/1000000

	/* NOTE FOR FOLLOWING CODE--------------------------------------------------
		Table 5.6 refers children born in the past 36 months but does not duplicate 
		children from multiple births.
		I want to keep singletons and the LAST birth of a set of multiple births, 
		but I cannot tell whether a birth is the most recent or LAST birth of a 
		set of multiple births unless I develop another code for the number of 
		births in a multiple birth. 
		----------------------------------------------------------------------*/

	// Break to calculate a code for the number of births in a multiple birth

/*  COME BACK TO THIS SEGMENT
	sort v001 v002 v003 months_since_birth
	save "$resultspath/temp1_recodes.dta", replace
	keep v001 v002 v003 v005 pidxb p0 months_since_birth
	gen n_tuple=1
	collapse (sum) n_tuple, by(v001 v002 v003 months_since_birth)
	tab n_tuple
	sort v001 v002 v003 months_since_birth
	quietly merge v001 v002 v003 months_since_birth using "$resultspath/temp1_recodes.dta"
	drop _merge
	sort v001 v002 v003 pidxb p0 
	*list v001 v002 v003 pidxb p0 b19 n_tuple if n_tuple>1, table clean
	cap erase "$resultspath/temp1_recodes.dta"
	
	// Now we can select on singletons or the last birth in n-tuple
	keep if p0==0 | p0==n_tuple
*/
		/* NOTE ------------------------------------------------------------------------
			following code does not match with m6=96 for amenorrheic; must use v405=1 to 
			get a match. DOES match with m8=96 for abstaining, but use v406=1 for consistency
			--------------------------------------------------------------------------*/

	local lvars amen abst insusc
	foreach lvar of local lvars {
	gen `lvar'=0
	}

	***************************************************
	// Construction of amen, abst, and insusc
	replace amen=1 if pidx==1 & v405==1
	replace abst=1 if pidx==1 & v406==1
	replace insusc=1 if amen>0 | abst>0
	***************************************************

* Could drop if p0=1 or p0=2.  Any difference?
drop if p0>1

	save "$resultspath/PPA_variables.dta", replace

	end
********************************************************************************

program define make_table_5pt6

* Make Table 5.6  

* Construct the table with collapse (a second time to get total, and a third time to get a mean)
*   and save to excel; not the only way to do it!

local loutcomes amen abst insusc

* Calculate the body of the table with collapse
use "$resultspath/PPA_variables.dta", clear
collapse (mean) `loutcomes' (sum) cases [iweight=wt], by(group2)
save "$resultspath/table_5pt6.dta", replace

* Calculate the row for the total
use "$resultspath/PPA_variables.dta", clear
collapse (mean) `loutcomes' (sum) cases [iweight=wt]
gen group2=100
save "$resultspath/total_row.dta", replace

* The mean is calculated as 1+2 * the sum of the proportions in each column
use "$resultspath/table_5pt6.dta", clear
foreach lout of local loutcomes {
total `lout'
matrix B=e(b)
scalar smean_`lout'=1+2*B[1,1]
scalar list smean_`lout'
}

* Construct the row for the mean
clear
set obs 1
gen group2=300
foreach lout of local loutcomes {
gen `lout'=smean_`lout'
}
save "$resultspath/mean_row.dta", replace

use "$resultspath/table_5pt6.dta", clear
append using "$resultspath/total_row.dta"

* Convert to percentages before adding the row for means
foreach lout of local loutcomes {
replace `lout'=100* `lout'
}

append using  "$resultspath/mean_row.dta"

label variable group2 "Months since birth"
label variable amen   "Amenorrheic"
label variable abst   "Abstaining"
label variable insusc "Insusceptible"
label variable cases  "Number of births"

sort  group2
order group2

* The median row comes from table 5.7 and is not calculated here

label define group2 100 "Total" 200 "Median" 300 "Mean", modify
label values group2 group2
format `loutcomes' %6.1f
format cases %8.1fc

list, table clean

save "$resultspath/table_5pt6.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.6") sheetreplace firstrow(var)

end

*********************************************************************

program define smoothed_distribution

	/*NOTE --------------------------------------------------------------------
	The following procedure reproduces the smoothing with a moving average described
	in the Guide to DHS Statistics. 
	
	It constructs group2_smoothed, median2_smoothed, and wt_smoothed.
	Runs on the smoothed data should use group2_smoothed in place of group2 
	(and median2_smoothed in place of median2) and should use wt_smoothed in place
	of wt_original (usually v005).

	It is not necessary to repeat this smoothing for different outcomes.
	v005 is an integer but wt_smoothed (which also includes a factor of 1000000) 
	may not be an integer

	It will still be possible to produce the original distribution using group2 
	(or median2) and wt.
	  ------------------------------------------------------------------------*/

	drop if group2==100
	summarize group2
	scalar sgroup2_max=r(max)
	scalar sgroup2_min=1
	save "$resultspath/temp.dta", replace

	gen triplet=1
	quietly append using "$resultspath/temp.dta"
	replace triplet=2 if triplet==.
	quietly append using "$resultspath/temp.dta"
	replace triplet=3 if triplet==.

	gen group2_smoothed=.
	replace group2_smoothed=group2 if triplet==1
	replace group2_smoothed=group2+1 if triplet==2
	replace group2_smoothed=group2-1 if triplet==3

	replace group2_smoothed=. if group2_smoothed<sgroup2_min | group2_smoothed>sgroup2_max
	replace group2_smoothed=. if (group2_smoothed==sgroup2_min & triplet>1) | (group2_smoothed==sgroup2_max & triplet>1)

	gen midpoint2_smoothed=2*group2_smoothed-1

/*
	// DHS6 and earlier midpoints (and exceptions during DHS7)
	if DHS_phase<=6 {
	gen midpoint2_smoothed=2*group2_smoothed-1.5
	replace midpoint2_smoothed=.75 if group2_smoothed==1
	}
*/

	gen wt_smoothed=0
	replace wt_smoothed=wt/3 if group2_smoothed>sgroup2_min  & group2_smoothed<sgroup2_max
	replace wt_smoothed=wt   if group2_smoothed==sgroup2_min | group2_smoothed==sgroup2_max

	// Table with smoothed age or duration distribution, with the median for each row
	tab midpoint2_smoothed [iweight=wt_smoothed]

end

*********************************************************************

program define calc_median

	/*NOTE --------------------------------------------------------------------
	This version of calc_median is for a current status variable which declines 
	with duration, such as EBF or amenorrhea.
	
	For a current status variable it is possible that the decline is not monotonic,
	so we must find the first value of x for which the percentage having the outcome
	y is LESS THAN than 50%.

	x is the measure of duration
	y is the outcome, coded 0 and 100 (100, not 1!)
	wt_temp is the weight variable

	sL and sU are the values that straddle the median:
		sL is the highest value of x for which the % is <50
		sU is the  lowest value of x for which the % is >50
	  ------------------------------------------------------------------------*/

	// "sfilter" is a scalar to indicate that the 50% level has been reached (for the first time, at least)
	scalar sfilter=0
	scalar slagged_x=0
	scalar slagged_y=100

	levelsof x, local(levels)
	foreach lcat of local levels {
	scalar scat=`lcat'

	quietly summarize y if x==scat [iweight=wt_temp]
	  if sfilter==0 & r(mean)<50 {
	  scalar sU_x=scat
	  scalar sU_y=r(mean)
	  scalar sL_x=slagged_x
	  scalar sL_y=slagged_y
	  scalar sfilter=1
	  }
	scalar slagged_x=scat
	scalar slagged_y=r(mean)
	}

	scalar list sU_x sU_y sL_x sL_y

	scalar sx_median=sL_x+(sU_x-sL_x)*(50-sL_y)/(sU_y-sL_y)
	
end

*******************************************************

program define make_table_5pt7


	/*---------------------------------------------------------------------
	Construct standard table 5.7, line by line
	For this table, use the two-month grouping (group2), as on page 1.46 of the 
	Guide to DHS Statistics (https://dhsprogram.com/Data/Guide-to-DHS-Statistics/index.cfm), 
	with a 3-interval moving total for the numerators and denominators separately.
	Here it is implemented with a revised case-level weight.
	--------------------------------------------------------------------------*/

	local loutcomes amen abst insusc

	use "$resultspath/PPA_variables.dta", clear

	smoothed_distribution

	gen mo_age=1
	replace mo_age=2 if v013>=4
	label variable mo_age "Mother's age"
	label define mo_age 1 "15-29" 2 "30-49"
	label values mo_age mo_age 

	local lcovars mo_age $gcovars
	keep `lcovars' *amen *abst *insusc *smooth*


	* These lines specify the variables used in "calc_median"
	gen x=midpoint2_smoothed
	gen y=.
	gen wt_temp=wt_smoothed
	save "$resultspath/smoothed.dta", replace

	* It is not necessary to repeat the smoothing for different covariates


* Loop over the rows of the table, calculating the medians for every cell
* First save the variable and value labels
foreach lc of local lcovars { 
local llabel : variable label `lc'
scalar slabel_`lc'="`llabel'"

levelsof `lc', local(levels_`lc')
  foreach li of local levels_`lc' {
  local llabel : label (`lc') `li'
  scalar slabel_`lc'_`li'="`llabel'"
  }
}
clear

* Now loop over the rows
scalar scounter=1
scalar svariable_sequence=1
quietly foreach lc of local lcovars {
foreach li of local levels_`lc' {

use "$resultspath/smoothed.dta", clear
keep if `lc'==`li'

save "$resultspath/temp0.dta", replace

  foreach lout of local loutcomes {
  replace y=100*`lout'  
  quietly calc_median
  scalar smedian_`lout'=sx_median
  }

* Save the current line into a file
clear
set obs 1

gen variable_sequence=svariable_sequence
gen str20 variable="`lc'"
gen value=`li'
gen str40 variable_label=slabel_`lc'
gen str40 value_label   =slabel_`lc'_`li'


* Within each row, loop over the outcomes
  foreach lout of local loutcomes {
  gen `lout'=smedian_`lout'
  }

  if scounter>1 {
  append using "$resultspath/table_5pt7.dta"
  }

* Save and append the row
save "$resultspath/table_5pt7.dta", replace


scalar scounter=scounter+1
scalar list scounter
}
scalar svariable_sequence=svariable_sequence+1
}

sort variable_sequence value
replace variable_label=strproper(variable_label)
replace value_label=strproper(value_label)
drop variable_sequence
order variable value variable_label value_label `loutcomes'
format `loutcomes' %8.2f

list, table clean

save "$resultspath/table_5pt7.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.7") sheetreplace firstrow(var)

end

*********************************************************************
*********************************************************************
*********************************************************************
*********************************************************************
*********************************************************************
* Execution begins here

quietly construct_indicators
make_table_5pt6
make_table_5pt7

erase "$resultspath/temp.dta"
erase "$resultspath/temp0.dta"
erase "$resultspath/total_row.dta"
erase "$resultspath/mean_row.dta"
erase "$resultspath/smoothed.dta"
erase "$resultspath/PPA_variables.dta"
program drop _all
