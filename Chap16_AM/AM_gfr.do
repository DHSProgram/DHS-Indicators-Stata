/*****************************************************************************************************
Program: 			AM_gfr.do
Purpose: 			Code to produce ASFRs and GFR for use in estimating maternal mortality
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Thomas Pullum and modified by Courtney Allen for the code share project
Date last modified: September 29, 2020 by Courtney Allen
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
fx			"age-specific fertility rate"
TFR			"total fertility rate"
GFR 		"general fertility rate"
----------------------------------------------------------------------------*/



/*----------------------------------------------------------------------------
NOTES
	This program should be run before AM_rates because ASFRs are needed to calculate 
	a re-weighted GFR. Also the variance-covariance matrix of the ASFRs, which is 
	needed for the CI of the re-weighted GFR.

	This version uses awfactt for the calculation of the ASFRs and for the age-adjustment
	of the GFR and Maternal Mortality Rate.
------------------------------------------------------------------------------*/


	 
//convert lw and uw to cmc's
program define make_start_month_end_month_GFR

	if lw<=0 {
	/*--------------------------------------------------------------------------
	NOTE:
	that lw and uw will be <=0 for "years before survey"

	coding that WILL NOT include the month of interview in the most recent interval;
	this matches up with DHS results
	--------------------------------------------------------------------------*/

	gen start_month=doi+12*lw-12
	gen end_month=doi+12*uw-1

	//alternative coding that WILL include the month of interview in the most recent interval
	*gen start_month=doi+12*lw-11
	*gen end_month=doi+12*uw

	}

	if lw>0 {
	//lw and uw will be >0 for "calendar years"
	gen start_month=12*(lw-1900)+1
	gen end_month=12*(uw-1900)+12
	}

	replace end_month=min(end_month,doi)

end
******************************************************************************

program define setup_GFR

	rename v008 doi
	rename v011 dob
	rename v201 ceb
	format ceb %5.3f
	*tab v013, summarize(ceb) means freq

	//rename prefixes
	renpfix b3_0 b3_
	
	//create age intervals
	gen curageint=int((doi-dob)/60)-2

	//use children ever born (ceb) to create local k 
	summarize ceb
	scalar maxceb=r(max) 
	local k=maxceb+1 
	while `k'<=20 {
	drop b3_`k'
	local k=`k'+1
	}

	scalar nageints=7

	save temp2.dta, replace
end
******************************************************************************

//Calculate exposure to age intervals within the window, in months
program define make_exposure
	
	use temp2.dta, clear

	//run GFR start/end month program
	make_start_month_end_month_GFR

	//mexp - months of exposure; yexp - years of exposure
	drop b*
	local i=1
	scalar agestart=180
	while `i'<=nageints {
		gen mexp`i'=min(doi,end_month,dob+agestart+59)-max(start_month,dob+agestart)+1
		replace mexp`i'=0 if mexp`i'<0 

		/*----------------------------------------------------------------------
		NOTE:
		must make an adjustment if DOI is the last month in an interval
		in that case, half a month must be deducted, under the assumption that the
		interview was in the middle of the month find the current age interval and 
		subtract half a month of exposure
		----------------------------------------------------------------------*/

		//deduct half month if DOI is last month in interval (see note above)
		replace mexp`i'=mexp`i'-.5 if end_month>=doi & curageint==`i'
		scalar agestart=agestart+60
		local i=`i'+1
		}

	/*----------------------------------------------------------------------
	NOTE:
	At this point inflate the exposure by awfactt/100 if this is an ever-married
	sample. Do not need any other versions of awfactt, such as awfactu, because 
	these rates should only be calculated for the total, not for subpopulations.
	
	Note that this correction will be off if there have been changes in the age 
	distribution of marriage between the date of the estimate and the date of the
	survey!!
	----------------------------------------------------------------------*/

	//Must first check whether awfactt is in the data. If not, construct it.
	local i=1
	while `i'<=nageints {
		replace mexp`i'=(awfactt/100)*mexp`i' 
		local i=`i'+1
		}
	 
	sort caseid
	save exposure.dta, replace
end
******************************************************************************

//Make file of all births
program define make_births

	use temp2.dta, clear
	keep caseid b3_* clusterid stratumid

	reshape long b3_, i(caseid) j(order)

	drop if b3_==.
	rename b3_ cmcbirth
	sort caseid
	save births.dta,replace
	drop _all

	use temp2.dta
	
	//run GFR start/end month program
	make_start_month_end_month_GFR
	keep caseid dob start_month end_month clusterid stratumid
	sort caseid
	merge caseid using births.dta
	* tab _merge
	drop _merge

	scalar list lw uw

	//drop births that lie outside the window
	drop if cmcbirth<start_month | cmcbirth>end_month

	//calculate births in age intervals within the window
	local i=1
	scalar agestart=180
	while `i'<=nageints {
		gen births`i'=0
		replace births`i'=births`i'+1 if cmcbirth<=dob+agestart+59 & cmcbirth>=dob+agestart
		scalar agestart=agestart+60
		local i=`i'+1
		}

	drop cmcbirth
	collapse (sum) births*, by(caseid)
	sort caseid
	save births.dta,replace
end
******************************************************************************

//Create a file with exposure and births for GFR  
program define make_exposure_and_births

	quietly make_exposure
	quietly make_births
	use exposure.dta,replace
	merge caseid using births.dta
	tab _merge
	drop _merge

	//The following line may or may not make any difference for the accuracy of the calculations
	recast double mexp* v005


	/*--------------------------------------------------------------------------
	We now have a woman-level file that includes each woman's exposure and births 
	in each of the age intervals and in the specified time interval.
	
	It will help to know the woman-years of exposure used for the GFR; call it 
	yexp_GFR to distinguish from the person-years of exposure for the mortality rates
	--------------------------------------------------------------------------*/

	local i=1
	while `i'<=nageints {
		gen yexp_GFR`i'=mexp`i'/12
		gen lnyexp_GFR`i'=ln(yexp_GFR`i')
		replace births`i'=. if mexp`i'==0
		replace births`i'=0 if births`i'==. & mexp`i'>0
		local i=`i'+1
		}

	sort caseid
	save exposure_and_births, replace

end
******************************************************************************


//Calculate the asfrs; no need for GFR or for covariates and categories
program define calc_rates

	use exposure_and_births.dta, clear

	*egen stratumid=group(v024 v025)
	*gen clusterid=v021
	egen womanid=group(caseid)

	//Reduced section for micro bodel; just save the ASFRs and variance-covariance matrix
	//To get asfrs: stack the births and exposure with reshape long; do a single poisson regression

	keep *id births* lnyexp_GFR* v005 awfact*

	//After reshape, this file has one record with births and exposure for each age interval for each woman 
	reshape long births lnyexp_GFR, i(womanid) j(age_grp)

	//Construct dummy variables for ALL age groups (noomit and nocons are crucial!).
	xi, noomit i.age_grp
	rename _I* *

	//births will have code "." if there is no exposure to the age interval; drop such lines
	drop if births==.

	/*--------------------------------------------------------------------------
	NOTE:
	You can choose whether to treat women or sample clusters as level 2 units.  
	This will only affect the confidence intervals.  
	The intervals are slightly wider, and probably more accurate, with womanid 
	than with clusterid. Ideally you would use a multi-level model, with age 
	intervals nested in women nested in sample clusters.  
	--------------------------------------------------------------------------*/

	//choose clusterid as level 2 unit 
	svyset clusterid [pweight=v005], strata(stratumid) singleunit(centered)
	
	//or choose womanid as level 2 unit
	*svyset womanid [pweight=v005], strata(stratumid) singleunit(centered)

	//poisson regression
	svy: poisson births age_grp_*, offset(lnyexp_GFR) nocons

	//save results in matrices 
	matrix T_asfr=r(table)
	matrix list T_asfr

	matrix V_asfr=e(V)
	matrix list V_asfr


	local li=1
	while `li'<=7 {
		scalar fx`li'=exp(T_asfr[1,`li'])

		//must make a correction for any earlier time intervals that have no births
		if T_asfr[1,`li']==0 {
			scalar fx`li'=0
			}

		//for checking, you can save the numerators and denominators of these rates
		*quietly summarize births [iweight=v005/1000000] if age_grp==`li'
		*scalar births`li'=r(sum)

		*quietly summarize yexp_GFR [iweight=v005/1000000] if age_grp==`li'
		*scalar yexp_GFR`li'=r(sum)

		local li=`li'+1
		}

end
******************************************************************************

//Calculate GFR used for mortality rates
program define main_GFR_for_mm

	//create local for file path and file name 
	local lpath=spath
	local lfn_IR=sfn_IR

	//open datafile 
	use "`lpath'\\`lfn_IR'", clear

	//check for existence of all women factor 
	capture confirm numeric variable awfactt, exact 
	if _rc>0 {
		gen awfactt=100
		}

	//keep important variables
	keep caseid v001 v005 v008 v011 v021 v023-v025 v201 b3_* awfactt 
	rename v021 clusterid

	//check for presence of v023 for clusterid 
	if sv023_NA==0 {
		rename v023 stratumid
		}

	if sv023_NA==1 {
		egen stratumid=group(v024 v025)
		}

	save temp1.dta, replace

	//execute program to setup GFR 
	quietly setup_GFR
									 
	/*--------------------------------------------------------------------------
	NOTE: 
	lw and uw enter this version of the program from the mm program
	The usual values are lw=-6 and uw=0
	--------------------------------------------------------------------------*/
						  
	//execute program to create a file with exposure and births
	make_exposure_and_births 
	
	//execute program to calculate ASFR 
	calc_rates  

	erase temp1.dta
	erase temp2.dta

end

