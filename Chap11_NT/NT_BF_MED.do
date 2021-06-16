/*****************************************************************************************************
Program: 			NT_BRST_FED.do
Purpose: 			Code to compute breastfeeding indicators
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 10, 2020 by Courtney Allen
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_med_any_bf		"Median duration in months of breastfeeding for any breastfeeding - born last 3yrs"
nt_med_ebf			"Median duration in months of breastfeeding for exclusive breastfeed - born last 3yrs"
nt_med_predom_bf	"Median duration in months of breastfeeding for predominant breastfeeding - born last 3yrs"
mean 				"Mean duration in months of breastfeeding of all children"

----------------------------------------------------------------------------*/

// INITIAL BREASTFEEDING

	//Ever breastfed
	gen nt_bf_ever= (m4!=94 & m4!=99) if (midx==1 & age<24)
	label values nt_bf_ever yesno 
	label var nt_bf_ever "Ever breastfed - last-born in the past 2 years"

	//Start breastfeeding within 1 hr
	gen nt_bf_start_1hr= (m4!=94 & m4!=99) & (inrange(m34,0,100)) if (midx==1 & age<24)
	label values nt_bf_start_1hr yesno
	label var nt_bf_start_1hr "Started breastfeeding within one hour of birth - last-born in the past 2 years"

	//Start breastfeeding within 1 day
	gen nt_bf_start_1day= (m4!=94 & m4!=99) & (inrange(m34,0,123)) if (midx==1 & age<24)
	label values nt_bf_start_1day  yesno
	label var nt_bf_start_1day	"Started breastfeeding within one day of birth - last-born in the past 2 years"

	//Given prelacteal feed
	gen nt_bf_prelac= (m4!=94 & m4!=99) & m55==1 if (midx==1 & age<24 & m4!=94 & m4!=99)
	label values nt_bf_prelac yesno
	label var nt_bf_prelac "Received a prelacteal feed - last-born in the past 2 years ever breast fed"

	//using bottle with nipple 
	gen nt_bottle= m38==1 if b5==1 & age<24
	label values nt_bottle yesno
	label var nt_bottle "Drank from a bottle with a nipple yesterday - under 2 years"

********************************************************************************

program define DHS_EBF_routine

	// EBF syntax DHS V Recode
		*NOTE: This routine is called by setup_and_recodes

	// Calculations for breastfeeding status.

	gen water=0
	gen liquids=0
	gen milk=0
	gen solids=0
	gen breast=0
	gen bottle=0

	// TO DETERMINE IF CHILD IS GIVEN WATER, SUGAR WATER, JUICE, TEA OR OTHER.
	replace water=1 if (v409>=1 & v409<=7) 
				   
	// IF GIVEN OTHER LIQUIDS
	foreach xvar of varlist v409a v410 v410* v413 {
	replace liquids=1 if `xvar'>=1 & `xvar'<=7
	}
							 
	// IF GIVEN POWDER/TINNED milk, FORMULA OR FRESH milk
	foreach xvar of varlist v411 v411a v412 v414p {
	replace milk=1 if `xvar'>=1 & `xvar'<=7
	}

	// IF STILL BREASTFEEDING
	replace breast=1 if m4==95 

	// IF WAS EVER BOTTLE FED
	replace bottle=1 if m38==1 
	tab bottle

	// IF GIVEN ANY SOLID FOOD
	*This is different than analyzing recode m39; look for country specific foods
	foreach xvar of varlist v414* {
	replace solids=1 if `xvar'>=1 & `xvar'<=7
	}

	replace solids=1 if v412a==1 | v412b==1 

	tab1 water liquids milk solids breast bottle

	gen diet=7
	replace diet=0 if breast==1 & water==0 & liquids==0 & milk==0 & solids==0
	replace diet=1 if breast==1 & water==1 & liquids==0 & milk==0 & solids==0
	replace diet=2 if breast==1 &            liquids==1 & milk==0 & solids==0 
	replace diet=3 if breast==1 &                         milk==1 & solids==0 
	replace diet=4 if breast==1 &                         milk==0 & solids==1 
	replace diet=5 if breast==1 &                         milk==1 & solids==1 
	replace diet=6 if breast==0 
	tab diet,m

	label define diet 	0 "Breastfed Only" ///
						1 "Breastmilk and Water" ///
						2 "Breastmilk and Liquids"  	///
						3 "Breastmilk and Other Milk" 	///
						4 "Breastmilk and Solids" 		///
						5 "Breastmilk, Milk and Solids" ///
						6 "Weaned"


	label values diet diet

	tab diet [iweight=v005/1000000]

	// Define the outcomes for table 11.4 on breastfeeding medians

	// Not breastfeeding 
	gen notbf=0
	replace notbf=100 if diet==6

	// categories 1, 2, 3, 4+5 of "diet"
	local lcat=1
	while `lcat'<=5 {
	gen diet`lcat'=0
	replace diet`lcat'=100 if diet==`lcat'
	local lcat=`lcat'+1
	}

	// Note: categories 4 and 5 are mutually exclusive
	gen diet4and5=diet4+diet5

	local lbftypes nt_med_any_bf nt_med_ebf nt_med_predom_bf 
	foreach lbf of local lbftypes {
	gen `lbf'=0
	}

	// Any breastfeeding
	replace nt_med_any_bf=100 if diet<=5
	label variable nt_med_any_bf    "Any breastfeeding"

	// Exclusive breastfeeding
	replace nt_med_ebf=100 if diet==0
	label variable nt_med_ebf      "Exclusive breastfeeding"

	// Predominant breastfeeding
	replace nt_med_predom_bf=100 if diet<=2 
	label variable nt_med_predom_bf "Predominant breastfeeding"

	/*--------------------------------------------------------------------------
	NOTE
	bf=0 for all types of bf for children who have died 
	bf=0 for all types of bf for children wno are not living with the mother
	bf=0 for all types of bf for all non-last born children
	nt_med_ebf=0 and nt_med_predom_bf=0 for all children age 24+ months
	nt_med_any_bf=100 if age 24+ months and m4=95
	--------------------------------------------------------------------------*/
	
	/*--------------------------------------------------------------------------
	NOTE
	In order to match table 11.4, breastfeeding medians:
	Include children born 24-35 months ago, with the three types of bf set to 0
	Include children who have died, with the three types of bf set to 0
	BUT if the lastborn child is living with the mother and has m4=95, set nt_med_any_bf=100 
	There is an additional modification for multiple births.
	--------------------------------------------------------------------------*/

	foreach lbf of local lbftypes {
	replace `lbf'=0 if b5==0
	replace `lbf'=0 if b9>0
	replace `lbf'=0 if bidx>1
	replace `lbf'=0 if age_in_months>=24
	}

	replace nt_med_any_bf=100 if b9==0 & bidx==1 & age_in_months>=24 & m4==95

	/*--------------------------------------------------------------------------
	NOTE: 
	MODIFICATION for multiple births.  Not described in the Guide or in the table 
	notes.
	
	m4=95 only applies to the youngest child.  Sometimes this is the youngest 
	child in a multiple birth, but if there is a multiple birth, all surviving 
	children who live with the mother should share the same bf value.

	Assume that all surviving and coresiding children from a multiple birth have 
	the same bf as the youngest one. 

	This contradicts this note: "It is assumed that...all non-last-born children
	are not currently breastfeeding". 
	--------------------------------------------------------------------------*/
	
	// identify n-tuples (usually 1 child)
	egen ntuple=group(v001 v002 v003 b19)

	// count how many children are in the ntuple (usually one)
	egen nch_in_ntuple=count(b0), by(ntuple)

	// indicator that one child in the ntuple is still breastfeeding

	gen test=.
	replace test=1 if age_in_months>=24 & m4==95
	egen stillbf=count(test), by(ntuple)

	tab nt_med_any_bf b4 if age_in_months>=24 & age_in_months<=35, m

	// transfer that value to any other child in the ntuple who is alive and living with the mother
	replace nt_med_any_bf=100 if b0>0 & b0<nch_in_ntuple & stillbf>0 & b9==0 & age_in_months>=24

	tab nt_med_any_bf b4 if age_in_months>=24 & age_in_months<=35, m

	// In ET70, for example, 8 children are affected.  Their twin is still bf so they should be too.
	*list v001 v002 v003 b19 b0 b5 b9 m4 ntuple nch_in_ntuple stillbf nt_med_any_bf if b0>0 & age_in_months>=24, table clean

	drop ntuple nch_in_ntuple test stillbf

end

********************************************************************************

// Define and setup variables 
program define setup_and_recodes

	scalar scid=substr(survey,1,2)
	scalar spv=substr(survey,3,2)
	local lcid=scid
	local lpv=spv

	use "$datapath//$krdata.dta", clear

	keep caseid v0* b* v409* v410* v411* v412* v413* v414* m4* m38* v106 v190 


	
	/*--------------------------------------------------------------------------
	NOTE
	v016 is day of interview
	v005 is month of interview
	v007 is year of interview
	hc16 is day of birth in the PR file but not in the KR file
	hc30 is month of birth in the PR file, matches b1 in the KR file 
	hc31 is year of birth in the PR file, matches b2 in the KR file
	b1 is month of birth
	b2 is year of birth
	--------------------------------------------------------------------------*/

	// Set DHS_phase at 6 for <=6 or at 7 for >=7


	scalar DHS_phase=7
	capture confirm numeric variable b19, exact 
	if _rc>0 {
	scalar DHS_phase=6
	}

	// For DHS-6 and earlier
	if DHS_phase<=6 {
	gen age_in_months=v008-b3
	}

	// For DHS-7 and later
	if DHS_phase>=7 {
	gen age_in_months=b19
	}

	// SPECIAL LINE FOR ET70
	if scid=="ET" & spv=="70" {
	scalar DHS_phase=6
	}

	*************************
	drop if age_in_months>=36
	*************************

	DHS_EBF_routine

	// Identify the correct children and construct the two relevant age distributions
	
	// Recodes for table 11.3
	// group1 is the grouping of ages used in table 11.3

	// The "under2" criterion means under 2 AND living
	gen under2=0
	replace under2=1 if b5==1 & age_in_months<24

	gen group1=.
	replace group1=1 if age_in_months==0  | age_in_months==1
	replace group1=2 if age_in_months==2  | age_in_months==3
	replace group1=3 if age_in_months==4  | age_in_months==5
	replace group1=4 if age_in_months>=6  & age_in_months<=8
	replace group1=5 if age_in_months>=9  & age_in_months<=11
	replace group1=6 if age_in_months>=12 & age_in_months<=17
	replace group1=7 if age_in_months>=18 & age_in_months<=23

	label define group1 1 "0-1 months" 2 "2-3 months" 3 "4-5 months" 4 "6-8 months" 5 "9-11 months" 6 "12-17 months" 7 "18-23 months"
	label values group1 group1

	tab group1 [iweight=v005/1000000]


	// Other intervals used in table 11.3: 0-3, 0-5, 6-9, 12-15, 12-23, 20-23
	gen age_0_3_months=1 if age_in_months>=0 & age_in_months<=3
	label variable age_0_3_months "Age 0-3 months"

	gen age_0_5_months=1 if age_in_  >=0 & age_in_months<=5
	label variable age_0_5_months "Age 0-5 months"

	gen age_6_9_months=1 if age_in_months>=6 & age_in_months<=9
	label variable age_6_9_months "Age 6-9 months"

	gen age_12_15_months=1 if age_in_months>=12 & age_in_months<=15
	label variable age_12_15_months "Age 12-15 months"

	gen age_12_23_months=1 if age_in_months>=12 & age_in_months<=23
	label variable age_12_23_months "Age 12-23 months"

	gen age_20_23_months=1 if age_in_months>=20 & age_in_months<=23
	label variable age_20_23_months "Age 20-23 months"

	gen with_mother=0
	replace with_mother=1 if b9==0

	sort caseid bidx
	save temp.dta, replace

	// find the youngest child, among children who are under 2 and living with the mother
	keep if age_in_months<=23 & b9==0
	sort caseid age_in_months 
	egen sequence=seq(), by(caseid)
	gen youngest_under2_with_mother=1 if sequence==1
	sort caseid bidx
	quietly merge caseid bidx using temp.dta
	replace youngest_under2_with_mother=0 if youngest_under2_with_mother==.
	drop sequence _merge

	/*

	// Not needed; see below
	// find the youngest child, among children who are under 3 and living with the mother
	keep if age_in_months<=35 & b9==0
	sort caseid age_in_months 
	egen sequence=seq(), by(caseid)
	gen youngest_under3_with_mother=1 if sequence==1
	sort caseid bidx
	quietly merge caseid bidx using temp.dta
	replace youngest_under3_with_mother=0 if youngest_under3_with_mother==.
	drop sequence _merge
	*/

	// Also need the two columns of frequencies in table 11.3

	gen freq1=v005/1000000 if youngest_under2_with_mother==1
	label variable freq1 "Youngest child under 2 living with mother"

	gen freq2=v005/1000000 if under2==1
	label variable freq2 "Child under2"

	// the following distribution will be the weighted number of youngest children
	//   under two years living with the mother, matching table 11.3
	tab group1 [iweight=v005/1000000]

	// the following distribution will be the unweighted number of youngest children
	//   under two years living with the mother, matching table 11.3
	tab group1 

	// Age group "a-b" is interpreted as extending from exact age a-.5 to exact age b+.5.  This is not
	//  the only possible interpretation, but let's accept it. Then the midpoint is [(a-.5)+(b+.5)]/2, 
	//  or (a+b)/2.  For example the midpoint of "4-5" is 4.5 and the midpoint of "6-8" is 7.
	// Age interval 0-1 extends from 0 to 1.5 and the midpoint is at (0+1.5)/2 or 0.75.

	gen midpoint1=.
	replace midpoint1= 1    if group1==1
	replace midpoint1= 2.5  if group1==2
	replace midpoint1= 4.5  if group1==3
	replace midpoint1= 7    if group1==4
	replace midpoint1=10    if group1==5
	replace midpoint1=14.5  if group1==6
	replace midpoint1=20.5  if group1==7

	// if DHS-6 or earlier:
	if DHS_phase<=6 {
	replace midpoint1=  .75 if group1==1
	}

	save workfile.dta, replace
	keep if under2==1
	save NT_bf_table_11pt3.dta, replace

	use workfile.dta, clear


	// Recodes for table 11.4

	// The "under3" criterion is 0-35 months since birth but not necessarily still living
	gen under3=0
	replace under3=1 if age_in_months<36


	/*

	// The following alternative to b9=1 and bidx=1 does not improve the match

	/*--------------------------------------------------------------------------
	NOTE
	Is if possible that the following line should not refer to a child with 
	b9==0 & bidx==1, but to the youngest living child living with the mother?
	
	replace nt_med_any_bf=100 if b9==0 & bidx==1 & age_in_months>=24 & m4==95
	--------------------------------------------------------------------------*/
	
	gen lastborn_with_mother=0
	replace lastborn_with_mother=1 if b9==0 & bidx==1
	tab lastborn_with_mother youngest_under3_with_mother if age_in_months>=24

	replace nt_med_any_bf=0 if age_in_months>=24
	replace nt_med_any_bf=100 if youngest_under3_with_mother==1 & age_in_months>=24 & m4==95
	*/

	// group2 is the code for the two-month age groups that are used for the smoothing procedure: 0-1, 2-3, etc.

	// Needed for overall value
	gen All=1

	gen group2=1+int(age_in_months/2) if age_in_months<=35
	gen midpoint2=2*group2-1 if age_in_months<=35

	#delimit ;
	  label define group2
	  1 "0-1"    2 "2-3"    3 "4-5"    4 "6-7"    5 "8-9"    6 "10-11"  7 "12-13"  8 "14-15"  9 "16-17" 10 "18-19"
	 11 "20-21" 12 "22-23" 13 "24-25" 14 "26-27" 15 "28-29" 16 "30-31" 17 "32-33" 18 "34-35" ;
	#delimit cr

	label values group2 group2

	// Criteria for table 11.4

	keep if under3==1

	save temp.dta, replace


	// notbf is in table 11.3 (<24 months) but not 11.4 (<36 months). 
	// If needed for 11.4 it can be recalculated as  nobf=100-nt_med_any_bf.

	tab1 *bf,m

	drop youngest
	save NT_bf_median.dta, replace

end

*********************************************************************

program define smoothed_distribution

	/*--------------------------------------------------------------------------
	This routine is called by "make_table_11.4"

	The following procedure reproduces the smoothing with a moving average 
	described in the Guide to DHS Statistics. 

	It constructs group2_smoothed, median2_smoothed, and wt_smoothed.

	Runs on the smoothed data should use group2_smoothed in place of group2 
	(or median2_smoothed in place of median2)
	and should use wt_smoothed in place of wt_original (usually v005).

	Note that it is not necessary to repeat this smoothing for different outcomes
	
	v005 is an integer but wt_smoothed (which also includes a factor of 1000000)
	may not be an integer

	It will still be possible to produce the original distribution using group2 
	(or median2) and wt.
	--------------------------------------------------------------------------*/

	// drop if group2==100
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
	gen midpoint2_smoothed=2*group2_smoothed-1 if age_in_months<=35
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
	tab midpoint2_smoothed nt_med_ebf [iweight=wt_smoothed/1000000], row

end

*********************************************************************

program define calc_median

	// This routine is called by "make_table_11.4"

	/*--------------------------------------------------------------------------
	NOTE
	This version of calc_median is for a current status variable which declines
	with duration, such as EBF or amenorrhea
	
	For a current status variable it is possible that the decline is not monotonic,
	so we must find the first value of x for which the percentage having the 
	outcome y is LESS THAN than 50%.

	-- x is the measure of duration
	-- y is the outcome, coded 0 and 100 (100, not 1!)
	-- wt_temp is the weight variable

	--   sL and sU are the values that straddle the median:
	--   sL is the highest value of x for which the % is <50
	--   sU is the  lowest value of x for which the % is >50

	-- "sfilter" is a scalar to indicate that the 50% level has been reached 
	(for the first time, at least)
	--------------------------------------------------------------------------*/
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

	scalar sx_median=sL_x+(sU_x-sL_x)*(50-sL_y)/(sU_y-sL_y)

end

*********************************************************************

program define make_table_11pt3

	/*--------------------------------------------------------------------------
	NOTE
	This routine produces all the numbers in table 11.3 EXCEPT the "Total" and
	the column "Percentage using a bottle with a nipple"

	nobf:  Not breastfeeding
	nt_med_ebf:   exlusive breastfeeding
	diet1: breastfeeding and consuming plain water only
	diet2: breastfeeding and consuming non milk solids
	diet3: breastfeeding and consuming other milk
	diet4and5: breastfeeding and consuming complementary foods
	nt_med_any_bf: currently breastfeeding 
	freq1: number of youngest children under age 2 living with the mother
	freq2: number of all children under 2
	--------------------------------------------------------------------------*/

	use NT_bf_table_11pt3.dta, clear

	format nt_med_ebf notbf %5.1f

	local lvars group1 age_0_3_months age_0_5_months age_6_9_months age_12_15_months age_12_23_months age_20_23_months

	foreach lv of local lvars {
	tabstat notbf nt_med_ebf diet1 diet2 diet3 diet4and5 nt_med_any_bf [fweight=v005] if youngest_under2_with_mother==1, statistics(mean) by(`lv') nototal format(%5.1f)
	tabstat freq1 freq2, statistics(sum) by(`lv') nototal format(%5.0f)
	}

	// export to excel 
	*export excel "NT_table_11pt3.xlsx", firstrow(variable) replace


end

*******************************************************

program define make_table_11pt4

	/*--------------------------------------------------------------------------
	NOTE 
	For this table, use the two-month grouping (group2), as on page 1.46 of the 
	Guide to DHS Statistics,  with a 3-interval moving total for the numerators 
	and denominators separately.
	
	Here it is implemented with a revised case-level weight in the routine 
	"smoothed_distribution".

	nt_med_any_bf:    any           breastfeeding
	nt_med_ebf:       exclusive     breastfeeding
	nt_med_predom_bf: predominantly breastfeeding

	Table 11.4 includes living and deceased children
	--------------------------------------------------------------------------*/

	*/

	use NT_bf_median.dta, clear

	local lbftypes nt_med_any_bf nt_med_ebf nt_med_predom_bf

	quietly smoothed_distribution

	// These three lines specify the variables used in "calc_median"
	gen x=midpoint2_smoothed
	gen wt_temp=wt_smoothed

	save temp_smoothed.dta, replace

	/*--------------------------------------------------------------------------
	NOTE 
	The following groups of lines are a clumsy way to get the medians for 
	categories of covariates.
	
	Labels are not included.
	It is not necessary to repeat the earlier parts of the procedure.
	In particular, the smoothing procedure does not need to be repeated.
	--------------------------------------------------------------------------*/

	scalar sline=0

	local lvars b4 v025 v024 v106 v190 All
	*local lvars "b4 v025 v190 All"

	foreach lvar of local lvars {
	levelsof `lvar', local(`lvar'_levels)
	}

	foreach lvar of local lvars {
	  scalar svar="`lvar'"
	  scalar list svar

	  quietly foreach lcat of local `lvar'_levels {
		use temp_smoothed.dta, clear
		keep if `lvar'==`lcat'
		scalar sline=sline+1
		local li=sline
		scalar svar_`li'=svar
		scalar svalue_`li'=`lcat'

		foreach lbf of local lbftypes {
		gen y=`lbf'  
		quietly calc_median
		scalar s`lbf'_median_`li'=sx_median
		drop y
		}
	  }
	}

	/*--------------------------------------------------------------------------
	NOTE 
	Need the overall mean. Calculate as the sum of the respective proportions times
	the widths of the interval, with special term for the first interval.  
	Description in the Guide is opaque and should be expanded / clarified

	The proportions are the percentages divided by 100.  The intervals have a width of 2.
	--------------------------------------------------------------------------*/

	// Move to the next line (after the end of the loop) in the results to be saved
	scalar sline=sline+1
	scalar nlines=sline
	local li=sline

	scalar svar_`li'="Mean"
	scalar svalue_`li'=1

	// The proportions are the percentages divided by 100.

	foreach lbf of local lbftypes {
	replace `lbf'=`lbf'/100
	}
	collapse (sum) *bf 

	// The intervals have a width of 2.
	* Note: the following are means, not medians! I label them medians so they can be within the loop below

	foreach lbf of local lbftypes {
	scalar s`lbf'_median_`li'=2*`lbf'[1]
	}

	// The remainder of this routine is about the construction and exporting of table 11.4 on breastfeeding medians
	* The scalars calculated above are inserted into the appropriate cells. There are no labels.

	local li=sline
	clear
	set obs `li'

	gen str12 var="."
	gen value=.

	foreach lbf of local lbftypes {
	gen `lbf'_median=.
	}

	local li=1
	quietly while `li'<=sline {
	  replace var=svar_`li' if _n==`li'
	  replace value=svalue_`li' if _n==`li'

	  foreach lbf of local lbftypes {
	  replace `lbf'_median=s`lbf'_median_`li' if _n==`li'
	  }
	local li=`li'+1
	}


	// The line for the mean must be divided by 1000
	foreach lbf of local lbftypes {
	replace `lbf'_median=`lbf'_median/1000 if var=="Mean"
	replace `lbf'_median=round(`lbf'_median,.01)
	}

	rename *_median *

	gen line=_n
	sort line
	
	// if you want to save as a dataset
	*save NT_bf_median.dta, replace
	list, table clean

	// export table to excel
	export excel "Tables_bf_median.xlsx", firstrow(variable) replace

	
	// remaining lines are part of check with report
	/*
	foreach lbf of local lbftypes {
	gen `lbf'_delta=`lbf'-`lbf'0
	}

	format *delta %8.2f
	list line var value *delta, table clean

	format *delta %8.1f
	list line var value *delta, table clean

	// For DHS phase 6 or earlier, the medians of the intervals are set at 0.5 months less than for DHS phase 7 or later.
	* It appears that this adjustment (subtracting 0.5) was also made for some DHS-7 surveys even though it should not 
	*  have been.  The Ethiopia 2016 survey (ET70) we can only match the report if we subtract 0.5.  
	*/
end

*********************************************************************
*********************************************************************
*********************************************************************
*********************************************************************
*********************************************************************
// Execution begins here


// Identify the survey
scalar survey= cc_fv	//"cc_fv" is country code and file version created in !NTmain.do

*quietly setup_and_recodes
setup_and_recodes
make_table_11pt3
make_table_11pt4

// optional statement
shell del *temp*.dta
shell del workfile.dta
shell del NT_bf_table_11pt3.dta

