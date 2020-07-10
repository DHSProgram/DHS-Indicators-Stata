/*****************************************************************************************************
Program: 			FE_TFR.do
Purpose: 			Code to compute fertility rates
Data inputs: 		IR survey list
Data outputs:		coded variables, .DTA file with rates and confidence intervals, 
Author:				Thomas Pullum and modified by Courtney Allen for the code share project
Date last modified: July 7, 2020 by Courtney Allen
Note:				
					This do file will produce a table of  TFRs by background variables as shown in final report (Table_TFR.xls). 
*****************************************************************************************************/

*GO TO THE MULTIPLE LINES OF ASTERISKS FOR THE BEGINNING OF THE EXECUTABLE STATEMENTS

/*______________________________NOTES___________________________________________

VARIABLES CREATED IN THIS PROGRAM:
	asfr_10_14	"age specific fertility rates for 10-14 yr olds"

	
OUTPUT FILES:
	FE_ASFR_10-14.dta:			asfrs for 10-14yr olds for 3yr and 5yr intervals
								plus estimated confidence interval

	Note: the main output files must be renamed or they will be over-written the
	next time the program is run


CRUCIAL VARIABLES USED (IN DHS NAMES)
	The input file has one record for each woman, including all women 15-49,
	regardless of whether they have had any children.

	caseid	"Case Identification"
	v001    "Cluster number"
	v005    "Sample weight"
	v008    "Date of interview (CMC)"
	v011    "Date of birth (CMC)"
	b3_*    "Date of birth (CMC)"
	v201    "Total children ever born"


ABOUT THIS PROGRAM
	This is a version of the 10-14 fertility rates program that runs on a single
	survey and only gives the Lexis method described in Methodological Report 23.

	This version will calculate rates for single years of age 10-14 and the pooled 
	rates for intervals of 10-14, 12-14.
	
	This version will produce rates, births, and exposure, for SINGLE YEARS years
	10 through 14 for the past five years.
	
	The full fertility rates program is reduced and ONLY produces asfrs, no TFR or GFR

	It can use alternative re-weighting approaches to the censoring effect
	
	This version can be used on ever-married surveys.

	It cannot easily be used with covariates--which are not advised for these rates.

	These rates can also be interpreted as the probability that a girl will have
	a birth at each single year of age.

	There are modifications to the general fertility rates program involving the 
	start age in months (120 instead of 180) and the age width in months (12 
	instead of 60).


COUNTRY SPECIFIC NOTES:
	- In PE6I (Peru) it is necessary to use a subhousehold code that is column 12
	of hhid	and column 9 of caseid. 
	
	- In IA (India) it is necessary to include region in the id codes.

	- In ML6H (Mali) it is necessary to remove two duplicate lines.

______________________________________________________________________________*/


program drop _all
program define make_ucmc_lcmc
	* convert lw and uw to cmc's

	if lw<=0 {
	* note that lw and uw will be <=0 for "years before survey"

	* coding that WILL NOT include the month of interview in the most recent interval;
	* this matches with DHS results

	gen lcmc=doi+12*lw-12
	gen ucmc=doi+12*uw-1

	}

	if lw>0 {
	* lw and uw will be >0 for "calendar years"
	gen lcmc=12*(lw-1900)+1
	gen ucmc=12*(uw-1900)+12
	}

	replace ucmc=min(ucmc,doi)

	* calculate the reference date

	summarize lcmc [iweight=v005/1000000]
	scalar mean_start_month=r(mean)

	summarize ucmc [iweight=v005/1000000]
	scalar mean_end_month=r(mean)

	* Convert back to continuous time, which requires an adjustment of half a month (i.e. -1/24).
	* This adjustment is not often made but should be.
	scalar refdate=1900-(1/24)+((mean_start_month+mean_end_month)/2)/12

	summarize doi [iweight=v005/1000000]
	scalar mean_doi=1900-(1/24)+(r(mean))/12

end

******************************************************************************

program define setup

	* PREPARE THE MAIN FILE FOR REPEATED RUNS

	scalar run_number=0

	rename v008 doi
	rename v011 dob
	rename v201 ceb
	format ceb %5.3f

	rename b*_0* b*_*

	* curageint is important, in part because the calculation is different if this is the woman's
	*   age at interview.

	/**************************************************************
	Under 15: 5 single years of age, 10 through 14 (5 intervals) 
	      as part of this modification, agestart is changed from 180 months to 120
	      and the width of the interval is changed from 60 months to 12 
	      and the number of age intervals is changed from 7 to 5
	**************************************************************/
	scalar nageints=5

	* The starting age is 10 years (120 months) and the intervals are one year: 
	gen curageint=int((doi-dob)/12)-9

	save fertilitydata.dta, replace

end

******************************************************************************

program define make_exposure

	* CALCULATE EXPOSURE TO AGE INTERVALS WITHIN THE WINDOW, IN MONTHS

	* IMPORTANT: THIS VERSION WILL ASSUME INTERVALS OF WIDTH ONE YEAR.
	* THE THREE-YEAR AND FIVE-YEAR RATES ARE CONSTRUCTED SEPARATELY FROM THE ONE-YEAR RATES

	* THIS VERSION USES AWFACTT BY INFLATING THE EXPOSURE BY AWFACTT/100

	use fertilitydata.dta, clear

	make_ucmc_lcmc

	drop b*
	local i=1

	* specify starting age in months (12*S)
	*scalar agestart=180

	scalar agestart=120

	while `i'<=nageints {

	* NOTE THE ASSUMPTION OF ONE-YEAR AGE INTERVALS

	* if the width of the age interval is 5 years (60 months) 
	*gen mexp`i'=min(doi,ucmc,dob+agestart+59)-max(lcmc,dob+agestart)+1

	* if the width of the age interval is 1 year (12 months) 
	gen mexp`i'=min(doi,ucmc,dob+agestart+11)-max(lcmc,dob+agestart)+1


	replace mexp`i'=0 if mexp`i'<0 

	/**************************************************************
	must make an adjustment if doi is the last month in an interval
	in that case, half a month must be deducted, under the assumption 
	that the interview was in the middle of the month
	find the current age interval and subtract half a month of exposure
	*************************************************************/

	replace mexp`i'=mexp`i'-.5 if ucmc>=doi & curageint==`i'


	* if the width of the age interval is 5 years (60 months) 
	*scalar agestart=agestart+60

	* if the width of the age interval is 1 year (12 months) 
	scalar agestart=agestart+12

	* MULTIPY EXPOSURE BY AWFACTT/100

	if sEMW==1 {
	replace mexp`i'=mexp`i'*(awfactt/100)
	}

	local i=`i'+1
	}

	sort caseid
	save exposure.dta,replace
end

******************************************************************************

program define make_births

	* MAKE FILE OF ALL BIRTHS

	use fertilitydata.dta, clear
	keep caseid b3_* 

	quietly reshape long b3_ , i(caseid) j(order)

	drop if b3_==.
	rename b3_ cmcbirth
	sort caseid
	save births.dta,replace
	drop _all

	use fertilitydata.dta

	make_ucmc_lcmc

	keep caseid dob lcmc ucmc
	sort caseid
	merge caseid using births.dta
	* tab _merge
	drop _merge

	scalar list lw uw

	* drop births that lie outside the window
	drop if cmcbirth<lcmc | cmcbirth>ucmc

	*calculate births in age intervals within the window

	local i=1
	*scalar agestart=180
	scalar agestart=120
	while `i'<=nageints {

	gen births`i'=0

	* the following two lines are used if the age interval is 5 years
	*replace births`i'=births`i'+1 if cmcbirth<=dob+agestart+59 & cmcbirth>=dob+agestart
	*scalar agestart=agestart+60

	* the following two lines are used if the age interval is 1 year
	replace births`i'=births`i'+1 if cmcbirth<=dob+agestart+11 & cmcbirth>=dob+agestart
	scalar agestart=agestart+12

	local i=`i'+1
	}

	drop cmcbirth
	collapse (sum) births*, by(caseid)
	sort caseid
	save births.dta,replace
end

******************************************************************************

program define make_exposure_and_births

	* run_number is a counter for each run 

	quietly make_exposure
	quietly make_births
	use exposure.dta,replace
	merge caseid using births.dta
	tab _merge
	drop _merge

	/*
	optional section to calculate weighted numerators and denominators
	  to calculate rates in the conventional way
	*/

	gen weight=v005/1000000

	local i=1
	while `i'<=nageints {
	gen births_wtd`i'=births`i'*weight
	gen yexp_wtd`i'=mexp`i'*weight/12
	local i=`i'+1
	}

	local i=1
	while `i'<=nageints {
	gen lnexp`i'=ln(mexp`i'/12)
	replace births`i'=. if mexp`i'==0
	replace births`i'=0 if births`i'==. & mexp`i'>0

	* Calculate the number of births and years of exposure (weighted), save as scalars.
	* Do it within this loop

	summarize births_wtd`i'
	scalar sbirths`i'=r(sum)

	* Distinguish exposure according to source

	* Calculate exposure from the IR file; this will always be the 
	*   denominator for the single-year rates
	  summarize yexp_wtd`i'
	  scalar syrsexp`i'=r(sum)

	local i=`i'+1
	}

	scalar list syrsexp1 syrsexp2 syrsexp3 syrsexp4 syrsexp5

	scalar variable="All"
	scalar value="."

	* The following lines define variables that will be filled in.

	gen v_run_number=_n
	gen v_EMW_survey=.

	gen str10 variable="All"
	gen value=.
	label variable value "All"

	sort caseid

	save exposure_and_births.dta, replace

	if lw==-2 {
	scalar sint="3yrs"
	}

	if lw==-4 {
	scalar sint="5yrs"
	}

end

******************************************************************************

program define save_results

	* This routine save the scalars as variables and then appends to build up an output file

	* It is called in the routine calc_rates

	scalar run_number=run_number+1

	clear
	set obs 1

	local cat=code

	gen v_lw=lw
	gen v_uw=uw
	gen v_EMW_survey=sEMW
	gen v_refdate=refdate
	gen v_mean_doi=mean_doi

	* START AGE AT 0

	local li=1
	while `li'<=5 {
	local liplus9=`li'+9
	gen v_r`liplus9'  =1000*r`li'
	gen v_r`liplus9'_L=1000*r`li'_L
	gen v_r`liplus9'_U=1000*r`li'_U

	gen v_births_`liplus9'=sbirths`li'
	gen v_yrsexp_`liplus9'=syrsexp`li'
	*gen v_yrsexp_expanded`liplus9'=syrsexp_expanded`li'
	local li=`li'+1
	}

	gen v_R_Lexis=1000*R_Lexis
	gen v_L_Lexis=1000*L_Lexis
	gen v_U_Lexis=1000*U_Lexis

	if lw==-2 {
	scalar sint="3yrs"
	}

	if lw==-4 {
	scalar sint="5yrs"
	}

	gen interval=sint
	label variable interval "Width of window"

	if run_number>1 {
	append using partial_results.dta
	}

	save partial_results.dta, replace

end

******************************************************************************

program define RLU

	scalar F=log(R)
	scalar C=1/(R*R)

	matrix M=C*D*V*D'
	scalar sF=sqrt(M[1,1])
	scalar LF=F-1.96*sF
	scalar UF=F+1.96*sF
	scalar L=exp(LF)
	scalar U=exp(UF)

	scalar list R L U

	matrix list V
	matrix list D

	scalar list sbirths1 sbirths2 sbirths3 sbirths4 sbirths5
	scalar list syrsexp1 syrsexp2 syrsexp3 syrsexp4 syrsexp5
	scalar list r1 r2 r3 r4 r5

end

*********************************************

program define calc_ci

	/**************************************************************
	This routine is called within the calc_rates routine

	Routine to calculate the confidence interval for the pooled rates
	A document to describe the procedure is being prepared.

	The rates for single years 10 through 14 are numbered 1, 2, 3, 4, and 5.

	R1 is the rate for ages 12-14 in the three years before the survey (lw is -2)

	R2 is the rate for ages 10-14 in the five years before the survey (lw is -4)

	if lw==-2 {

	SEGMENT FOR RE-WEIGHTING FOR THE PAST THREE YEARS

	**************************************************************/

	* Use the Lexis Diagram
	scalar syrsexp345=(syrsexp3/1)+(syrsexp4/3)+(syrsexp5/5)
	scalar W12=(syrsexp3/1)/syrsexp345
	scalar W13=(syrsexp4/3)/syrsexp345
	scalar W14=(syrsexp5/5)/syrsexp345

	scalar R=W12*r3+W13*r4+W14*r5
	matrix D=(0,0,W12*r3,W13*r4,W14*r5)
	RLU
	scalar R_Lexis=R
	scalar L_Lexis=L
	scalar U_Lexis=U

	******************************************************

	

	if lw==-4 {

	* SEGMENT FOR RE-WEIGHTING FOR THE PAST FIVE YEARS

	******************************************************

	* Use Lexis Diagram weights
	scalar syrsexp12345=(syrsexp1/1)+(syrsexp2/3)+(syrsexp3/5)+(syrsexp4/7)+(syrsexp5/9)
	scalar W10=(syrsexp1/1)/syrsexp12345
	scalar W11=(syrsexp2/3)/syrsexp12345
	scalar W12=(syrsexp3/5)/syrsexp12345
	scalar W13=(syrsexp4/7)/syrsexp12345
	scalar W14=(syrsexp5/9)/syrsexp12345

	scalar R= W10*r1+W11*r2+W12*r3+W13*r4+W14*r5
	matrix D=(W10*r1,W11*r2,W12*r3,W13*r4,W14*r5)
	RLU
	scalar R_Lexis=R
	scalar L_Lexis=L
	scalar U_Lexis=U
	******************************************************

	}

end

******************************************************************************

program define calc_rates

	/**************************************************************
	This version calculates just the single-year rates for ages 10,
	11, 12, 13, 14.

	It loops through all the values of the 
	categorical variable called "covariate"; for "All", there is only
	one value, 1.

	The selection of categories is done with "subpop" within svy. 
	For calculating standard errors, this is preferable to the 
	alternatives, such as "if...." .

	The most crucial lines are enclosed in short lines of asterisks.
	***************************************************************/
	*/

	use exposure_and_births.dta, clear

	if variable=="All" {
	gen covariate=1
	}

	if variable~="All" {
	local lname=variable
	gen covariate=`lname'
	}

	/*
	* SPECIAL STATEMENT FOR ML6H!  THERE ARE TWO DUPLICATE VALUES OF CASEID.  JUST DROP THEM.
	if scid=="ML" & spv_IR=="6H" {
	egen test=seq(),by(caseid)
	drop if test>1
	drop test
	}
	*/

	egen womanid=group(caseid)

	levelsof covariate, local(levels)

	* Age-specific rates
	* Stack the births and exposure with reshape long; do a single poisson regression

	* The main reason for reshaping is to be able to get at the covariances among the births in
	*  different age intervals.  This helps in the calculation of the ci for the TFR.

	keep *id b* lnexp* v005 covariate
	drop births_wtd*

	***********************
	quietly reshape long births lnexp, i(womanid) j(age)
	***********************

	* This file has one record with births and exposure for each age interval for each woman 

	* Construct dummy variables for ALL age groups (noomit and nocons are crucial!).
	xi, noomit i.age
	rename _I* *

	* births is coded "." if there is no exposure to the age interval; drop such lines
	drop if births==.

	/**************************************************************
	You can choose whether to treat women or sample clusters as 
	level 2 units.  
	This will only affect the confidence intervals.  
	The intervals are slightly wider, and probably more accurate,
	with womanid than with clusterid. Ideally you would use a multi-level
	model, with age intervals nested in women nested in sample clusters.  
	**************************************************************/
	
	svyset clusterid [pweight=v005], strata(stratumid) singleunit(centered)
	***********************
	*svyset womanid [pweight=v005], strata(stratumid) singleunit(centered)
	***********************

	* Begin loop through each value of the categorical covariate for the asfrs

	foreach cat of local levels {

	scalar code=`cat'

	* The regression must be inside a look that checks for whether there are any births

	local li=1
	while `li'<=5 {

	scalar r`li'=.
	scalar r`li'_L=.
	scalar r`li'_U=.
	local li=`li'+1
	}

	scalar R_Lexis=.
	scalar L_Lexis=.
	scalar U_Lexis=.


	* Proceed with the poisson regression 

	********************************************************
	********************************************************

	* Always use only the IR data to calculate the rates themselves

	gen dummy=0
	*replace dummy=1 if covariate==code & source==1
	replace dummy=1 if covariate==code

	***********************
	svy, subpop(dummy): poisson births age_*, offset(lnexp) nocons
	***********************


	********************************************************
	********************************************************

	matrix T=r(table)
	matrix list T

	matrix V=e(V)
	matrix list V

	************************************
	local li=1
	while `li'<=5 {

	scalar r`li'=exp(T[1,`li'])
	scalar r`li'_L=exp(T[5,`li'])
	scalar r`li'_U=exp(T[6,`li'])

	* must make a correction for any earlier time intervals that have no births

	if T[1,`li']==0 {
	scalar r`li'=0
	scalar r`li'_L=0
	scalar r`li'_U=0
	}

	scalar list r`li' r`li'_L r`li'_U

	* save a set of rates without subscripts to simplify the TFR notation
	scalar r`li'=r`li'

	local li=`li'+1
	}
	*************************************


	* calculate a ci for the TFR by calculating a ci for ln[sum of exp(the coeffs)] 
	calc_ci
	drop dummy

	}

	* Loop again through categories, this time just to save the results.

	foreach cat of local levels {
	scalar code=`cat'
	save_results
	}

end

**********************************************************

program define final_file_save

	use partial_results.dta, clear

	scalar scid=substr(sfn,1,2)
	scalar spv =substr(sfn,5,2)
	local lcid=scid
	local lpv=spv

	rename v_* *
	drop if lw==.

	list EMW_survey lw uw r10 r11 r12 r13 r14 R_Lexis, table clean 

	label define lw -4 "5 years" -2 "3 years"
	label values lw lw

	format R* L* U* %8.4f

	list lw *Lexis if lw==-2, table clean noobs
	list lw *Lexis if lw==-4, table clean  noobs

	********* Export results to Excel *****************************
	rename (r10 r10_L r10_U) (fe_ASFR_10 fe_ASFR_10_L fe_ASFR_10_U)
	rename (r11 r11_L r11_U) (fe_ASFR_11 fe_ASFR_11_L fe_ASFR_11_U)
	rename (r12 r12_L r12_U) (fe_ASFR_12 fe_ASFR_12_L fe_ASFR_12_U)
	rename (r13 r13_L r13_U) (fe_ASFR_13 fe_ASFR_13_L fe_ASFR_13_U)
	rename (r14 r14_L r14_U) (fe_ASFR_14 fe_ASFR_14_L fe_ASFR_14_U)
	rename (R_Lexis L_Lexis U_Lexis) (fe_ASFR_10to14 fe_ASFR_10to14_L fe_ASFR_10to14_U)

	keep  interval fe_ASFR_10to14 fe_ASFR_10to14_L fe_ASFR_10to14_U		   ///
		  fe_ASFR_10 fe_ASFR_10_U fe_ASFR_10_L	///
		  fe_ASFR_11 fe_ASFR_11_U fe_ASFR_11_L  ///
		  fe_ASFR_12 fe_ASFR_12_U fe_ASFR_12_L  ///
		  fe_ASFR_13 fe_ASFR_13_U fe_ASFR_13_L  ///
		  fe_ASFR_14 fe_ASFR_14_U fe_ASFR_14_L     
	
	order interval fe_ASFR_10to14 fe_ASFR_10to14_L fe_ASFR_10to14_U		   ///
		  fe_ASFR_10 fe_ASFR_10_U fe_ASFR_10_L ///
		  fe_ASFR_11 fe_ASFR_11_U fe_ASFR_11_L /// 
		  fe_ASFR_12 fe_ASFR_12_U fe_ASFR_12_L ///
		  fe_ASFR_13 fe_ASFR_13_U fe_ASFR_13_L ///
		  fe_ASFR_14 fe_ASFR_14_U fe_ASFR_14_L  	   

	save               "FE_ASFR_10-14.dta", replace
	export excel using "Tables_FE_ASFR_10-14.xlsx", firstrow(variables) replace

	* clean up the folder
	shell del *FL.DTA
	shell del *temp*.* fertilitydata.dta births.dta exposure*.dta partial_results.dta

end

******************************************************************************

program define calc_fert_rates_10to14

	/**************************************************************
	SPECIFY THE WINDOW(S) OF TIME AND COVARIATE(S), IF ANY. TYPICALLY
	THIS ROUTINE WILL CHANGE FOR EACH RUN BUT ALL OTHER ROUTINES WILL
	STAY THE SAME.

	There are two ways to specify the window of time.
		Method 1: as calendar year intervals, e.g. with
			scalar lw=1992
			scalar uw=1996
			for a window from January 1992 through December 1996, inclusive.

		Method 2: as an interval before the date of interview, e.g. with
			scalar lw=-4
			scalar uw=0  

	IMPORTANT!!! The only women who will contribute to these rates 
	are women age 15-19 at the time of the survey
	**************************************************************/

	*use IRtemp.dta, clear

	capture confirm numeric variable awfactt, exact 
	if _rc>0 {
	  gen awfactt=100
	}

	replace awfactt=100 if awfactt==.

	quietly summarize awfactt
	scalar sawfactt_sd=r(sd)
	scalar sEMW=0
	if sawfactt_sd>0 {
	scalar sEMW=1
	}

	keep caseid v001 v005 v008 v011 v201 b3_* awfact* v021 v024 v025

	egen stratumid=group(v024 v025)

	* in IA52, v021 is empty and v001 must be used as clusterid.  Otherwise use v021.

	gen clusterid=v021

	quietly summarize clusterid
	scalar scheck=r(mean)

	if scheck==. {
	replace clusterid=v001
	}

	keep *id v001 v005 v008 v011 v201 b3_* awfactt

	quietly summarize v008
	scalar sv008_mean=r(mean)

	save temp.dta, replace
	quietly setup
									 
	scalar lw=-2                    
	scalar uw=0                      
	quietly make_exposure_and_births 
	quietly calc_rates 

	scalar lw=-4                    
	scalar uw=0                      
	quietly make_exposure_and_births 
	quietly calc_rates               

end

******************************************************************************

program define save_IRtemp

	capture confirm numeric variable awfactt, exact 
	if _rc>0 {
	  gen awfactt=100
	}

	replace awfactt=100 if awfactt==.

	quietly summarize awfactt
	scalar sawfactt_sd=r(sd)
	scalar sEMW=0
	if sawfactt_sd>0 {
	scalar sEMW=1
	}

	keep caseid v001 v002 v003 v005 v008 v011 v012 v021-v025 v201 b3_* awfact* v021
	keep if v012>=10 & v012<=19
	save IRtemp.dta, replace

end



************************************************************
************************************************************
************************************************************
************************************************************
* EXECUTION BEGINS HERE
 
* NOTE: scalars first and last can be adjusted within "copy_files" and
*   "reshape_wide_and_merge"

* Specify the file name as a scalar. This must be an IR standard recode file in Stata format.
scalar sfn="$irdata"

scalar run_number=0

save_IRtemp
calc_fert_rates_10to14
final_file_save









