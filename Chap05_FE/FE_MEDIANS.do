/*******************************************************************************
Program: 				FE_MEDIANS.do
Purpose: 				Creates the indicators for median duration of amenorrhea,
						postpartum abstinence, and pp insusceptibility fertility 
						Chapter	using the KR file (the cases are births)
Data outputs:			coded variables, table output on screen, and in excel tables.  
Author: 				Tom Pullum and Courtney Allen
Date last modified:		Courtney Allen July 6, 2020 for codeshare project

*******************************************************************************/

/* Notes -----------------------------------------------------------------------
	- Children from multiple births are dropped, except for the first one; drop if b0>1

	- "months_since_birth" is b19 (is age in months if the child is alive)

	- In surveys that do not include b19, months_since_birth is v008-b3

	- group2 is a grouping into 2-month intervals

	- DHS_phase is the version of DHS.  Could be taken from the 3rd character of
	  v000 but is based on whether b19 is present;
	  just use DHS_phase=6 if it is not and DHSphase=7 if it is present.  
	  Only relevant for the midpoints of group2.

	- Midpoints:
		For DHS6, the midpoints are supposed to be .75, 2.5, 4.5, 6.5, etc.
		For DHS7, the midpoints are supposed to be 1, 3, 5, 7, etc.

	- It is possible that b19 is present but the DHS6 coding is used for the 
	  midpoints (such as in ET 2016 survey).
------------------------------------------------------------------------------*/
use "$datapath//$krdata.dta", clear

gen file=substr("$krdata", 6, 1)

program drop _all
*********************************************************************

//SETUP PROGRAM: setup_and_recodes
program define setup_and_recodes

	scalar scid=substr(file,1,2)
	scalar spv=substr(file,5,2)
	local lcid=scid
	local lpv=spv

	keep caseid v0* b* v405 v406 v106 v190 

	// Identify the correct children and construct the two relevant age distributions
		* v405: Currently amenorrheic
		* v406: Currently abstaining


	//Set DHS_phase at 6 for <=6 or at 7 for >=7

		scalar DHS_phase=7
		capture confirm numeric variable b19, exact 
		if _rc>0 {
		scalar DHS_phase=6
		}

		// For DHS-6 and earlier
		if DHS_phase<=6 {
		gen months_since_birth=v008-b3
		}

		// For DHS-7 and later
		if DHS_phase>=7 {
		gen months_since_birth=b19
		}

		// SPECIAL LINE MAY BE NEEDED FOR UNIQUE SURVEYS, LIKE ET71
		if scid=="ET" & spv=="71" {
		scalar DHS_phase=6
		}

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
	gen unwtdn=1
	gen wtdn=v005/1000000

	tab bidx b0 [iweight=v005/1000000]


	/* NOTE FOR FOLLOWING CODE--------------------------------------------------
		Table 5.6 refers children born in the past 36 months but does not duplicate 
		children from multiple births.
		I want to keep singletons and the LAST birth of a set of multiple births, 
		but I cannot tell whether a birth is the most recent or LAST birth of a 
		set of multiple births unless I develop another code for the number of 
		births in a multiple birth. 
		----------------------------------------------------------------------*/

	// Break to calculate a code for the number of births in a multiple birth

	sort v001 v002 v003 months_since_birth
	save temp1_recodes.dta, replace
	keep v001 v002 v003 v005 bidx b0 months_since_birth
	gen n_tuple=1
	collapse (sum) n_tuple, by(v001 v002 v003 months_since_birth)
	tab n_tuple
	sort v001 v002 v003 months_since_birth
	quietly merge v001 v002 v003 months_since_birth using temp1_recodes.dta
	drop _merge
	sort v001 v002 v003 bidx b0 
	*list v001 v002 v003 bidx b0 b19 n_tuple if n_tuple>1, table clean

	// Now we can select on singletons or the last birth in n-tuple
	keep if b0==0 | b0==n_tuple

		/* NOTE ------------------------------------------------------------------------
			following code does not match with m6=96 for amenorrheic; must use v405=1 to 
			get a match. DOES match with m8=96 for abstaining, but use v406=1 for consistency
			--------------------------------------------------------------------------*/

	local lvars amen abst insusc
	foreach lvar of local lvars {
	gen `lvar'=0
	}

	***************************************************
	// IMPORTANT: construction of amen, abst, and insusc
	replace amen=1 if bidx==1 & v405==1
	replace abst=1 if bidx==1 & v406==1
	replace insusc=1 if amen>0 | abst>0
	***************************************************

	foreach lvar of local lvars {
	gen pct_`lvar'_wtd=100*`lvar'*wtdn
	}

	gen All=1
	label define All 1 "All"
	label values All All
	save temp1_recodes.dta, replace
	end
********************************************************************************

program define make_table_5pt6
	/* NOTE --------------------------------------------------------------------
	This table should reflect DHS standard table 5.7
	--------------------------------------------------------------------------*/

* Construct the table with collapse (a second time to get total, and a third time to get a mean) and save to excel; not the only way to do it!

local loutcomes amen abst insusc

use temp1_recodes.dta, clear
collapse (sum) pct* *wtdn, by(group2)

	//calculate percentages for each outcome by group
	foreach loutcome of local loutcomes {
	gen pct_`loutcome'=pct_`loutcome'_wtd/wtdn
	total pct_`loutcome'
	replace pct_`loutcome'=round(pct_`loutcome',.1)
	}

	save temp2_recodes.dta, replace

	//calculate total percentages
	use temp1_recodes.dta, clear
	collapse (sum) pct* *wtdn
		foreach loutcome of local loutcomes {
		gen pct_`loutcome'=round(pct_`loutcome'_wtd/wtdn,.1)
		}

	replace wtdn=round(wtdn)

	gen group2=100
	append using temp2_recodes.dta
	save temp3_recodes.dta, replace


	//create means
		/*NOTE -----------------------------------------------------------------
		For means calculate the sum of each weighted percentage, times by the 
		appropropriate width (either 0.75, 1.5, 1.75, or 2) and divide by 100, 
		for the so-called "Mean". 
		----------------------------------------------------------------------*/

	use temp2_recodes.dta, clear

	//create widths according to DHS6 or DHS7 (see Guide to DHS Statistics for more explanation)
	*For DHS-6 and earlier
	if DHS_phase<=6 {
		gen width = 2	
		replace width = 0.75 if group2==1
		replace width = 1.50 if group2==2
		replace width = 1.75 if group2==3
		local width1 = 0.75
		}

	*For DHS-7 
	if DHS_phase>=7{
		gen width = 2	
		local width1 = 1
		}
		

	//multiply the proportion of each outcome by the width 
	foreach loutcome of local loutcomes {
		replace pct_`loutcome' = (pct_`loutcome'/100) * width
	}
	
	//sum to create the means
	collapse (sum) pct* *wtdn
	foreach loutcome of local loutcomes {
		replace pct_`loutcome' = pct_`loutcome' + `width1'
	}

	gen group2=300
	sort group2
	append using temp3_recodes.dta


	
	* Note that pct_`loutcome' is weighted but the suffix _wtd has been dropped
	drop pct*wtd

	order group2 pct_amen pct_abst pct_insusc unwtdn wtdn
	label values group2 group2
	list, table clean noobs


	export excel using Tables_FE_5pt6.xlsx, firstrow(var) replace
	save FE_5pt6.dta, replace

	/*NOTE --------------------------------------------------------------------
		The overall median appears in both tables 5.6 and 5.7; is calculated with 
		the other numbers for 5.7. 
	  ------------------------------------------------------------------------*/
 
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
	gen wt=v005

	save temp.dta, replace

	gen triplet=1
	quietly append using temp.dta
	replace triplet=2 if triplet==.
	quietly append using temp.dta
	replace triplet=3 if triplet==.

	gen group2_smoothed=.
	replace group2_smoothed=group2 if triplet==1
	replace group2_smoothed=group2+1 if triplet==2
	replace group2_smoothed=group2-1 if triplet==3

	replace group2_smoothed=. if group2_smoothed<sgroup2_min | group2_smoothed>sgroup2_max
	replace group2_smoothed=. if (group2_smoothed==sgroup2_min & triplet>1) | (group2_smoothed==sgroup2_max & triplet>1)

	// DHS7+ midpoints
	if DHS_phase>=7 {
	gen midpoint2_smoothed=2*group2_smoothed-1
	}

	// DHS6 and earlier midpoints (and exceptions during DHS7)
	if DHS_phase<=6 {
	gen midpoint2_smoothed=2*group2_smoothed-1.5
	replace midpoint2_smoothed=.75 if group2_smoothed==1
	}

	gen wt_smoothed=0
	replace wt_smoothed=wt/3 if group2_smoothed>sgroup2_min  & group2_smoothed<sgroup2_max
	replace wt_smoothed=wt   if group2_smoothed==sgroup2_min | group2_smoothed==sgroup2_max

	// Table with smoothed age or duration distribution, with the median for each row
	tab midpoint2_smoothed [iweight=wt_smoothed/1000000]

	/*
	* If desired, numbers similiar to those in table 5.6 but with the smoothed distribution
	tab midpoint2_smoothed amen   [iweight=wt_smoothed/1000000], row
	tab midpoint2_smoothed abst   [iweight=wt_smoothed/1000000], row
	tab midpoint2_smoothed insusc [iweight=wt_smoothed/1000000], row

	label values group2_smoothed group2
	tab group2_smoothed amen   [iweight=wt_smoothed/1000000], row
	tab group2_smoothed abst   [iweight=wt_smoothed/1000000], row
	tab group2_smoothed insusc [iweight=wt_smoothed/1000000], row
	*/

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

	quietly summarize y if x==scat [iweight=wt_temp/1000000]
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
	*scalar list sx_median

	*scalar sx_median=round(sx_median,.1)
	*scalar sx_median=round(sx_median,.01)
	scalar sx_median=round(sx_median,.001)
	
end

*******************************************************

//SETUP PROGRAM: final_save
program define final_save

	local loutcomes amen abst insusc

	local lobs=nlines
	clear
	set obs `lobs'

	gen str12 var="."
	gen value=.
	gen str12 label="."
	
	foreach loutcome of local loutcomes {
	gen `loutcome'_median=.
	}

	local li=1
	quietly while `li'<=nlines {
	replace var=svar_`li' if _n==`li'
	replace value=svalue_`li' if _n==`li'
	replace label=label_`li' if _n==`li'
	  foreach loutcome of local loutcomes {
	  replace `loutcome'_median=s`loutcome'_median_`li' if _n==`li'
	  }
	local li=`li'+1
	}

	sort var value
	save FE_5pt7.dta, replace

	//Should labels for the variables and the values
	list, table clean

end

*******************************************************

program define make_table_5pt7

	/*NOTE ---------------------------------------------------------------------
	This table should reflect DHS standard table 5.7
	For this table, use the two-month grouping (group2), as on page 1.46 of the 
	Guide to DHS Statistics (https://dhsprogram.com/Data/Guide-to-DHS-Statistics/index.cfm), 
	with a 3-interval moving total for the numerators and denominators separately.
	Here it is implemented with a revised case-level weight.
	--------------------------------------------------------------------------*/

	local loutcomes "amen abst insusc"
	local lcovars "mo_age v025 v024 v106 v190 All"

	use temp1_recodes.dta, clear

	smoothed_distribution

	keep v001 v002 v003 v013 v024 v025 v106 v190 All *amen *abst *insusc *smooth*
	gen mo_age=1
	replace mo_age=2 if v013>=4

	label define mo_age 1 "15-29" 2 "30-49"
	label values mo_age mo_age 

	* These lines specify the variables used in "calc_median"
	gen x=midpoint2_smoothed
	gen y=.
	gen wt_temp=wt_smoothed

	foreach loutcome of local loutcomes {
	gen pct_`loutcome'=100*`loutcome'
	}

	save temp_smoothed.dta, replace

	/*NOTE ---------------------------------------------------------------------
	The following groups of lines are a  way to get the medians for subgroups of
	covariates.	Labels are not included.
	It is not necessary to repeat the smoothing for different covariates
	--------------------------------------------------------------------------*/
	scalar sline=0

	local loutcomes "amen abst insusc"
	local lcovars "mo_age v024 v025 v106 v190 All"
	
	foreach lcovar of local lcovars {
	  scalar svar="`lcovar'"
	  scalar list svar
	  levels `lcovar', local(`lcovar'levels)
	
	  foreach cat of local `lcovar'levels {
	  scalar svalue=`cat'
	  use temp_smoothed.dta, clear
	  keep if `lcovar'==svalue
	  scalar sline=sline+1
	  local li=sline
	  local lcovar=svar
	  scalar svar_`li'="`lcovar'"
	  scalar svalue_`li'=svalue
	  
	  //get covariate labels
	  cap local lcovar_lab : value label `lcovar'
	  cap local l`cat': label `lcovar_lab' `cat'
	  cap scalar label_`li'=proper("`l`cat''")
	  cap scalar list label_`li'
	  
	  
	
		foreach loutcome of local loutcomes {
		replace y=pct_`loutcome'  
		quietly calc_median
		scalar s`loutcome'_median_`li'=sx_median
		

		}
	  }
	}


	//Move to the next line in the results to be saved, and save nlines as the number of lines
	scalar nlines=sline
	local li=nlines

	final_save

	* Note: this table does not include labels
	export excel using Tables_FE_5pt7.xlsx, firstrow(var) replace

end

*********************************************************************
*********************************************************************
*********************************************************************
*********************************************************************
*********************************************************************
* Execution begins here


//specify a location that can be used for the output and for working files that will be deleted
cd "C:\Users\39585\ICF\Analysis - Shared Resources\Code\DHS-Indicators-Stata\Chap05_FE"


	/*NOTE ---------------------------------------------------------------------
	It is essential to identify the phase. This is equivalent to finding 
	whether b19 is in the data. If it is not, and b3-v008 is used instead of
	b19 to get the child's current age in months, then an adjustment of .5 
	has to be made. 
	The scalar "DHS_phase" is set at 6 (for <=6) or 7 (for >=7) within the setup routine
	--------------------------------------------------------------------------*/

scalar survey="$krdata"

setup_and_recodes
make_table_5pt6
make_table_5pt7


//get rid of extra files
erase temp.dta
erase temp_smoothed.dta
forvalues i=1/3 {
	erase temp`i'_recodes.dta
}