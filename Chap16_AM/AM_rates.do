/*****************************************************************************************************
Program: 			AM_RATES.do
Purpose: 			Code to produce adult and maternal mortality rates for specific windows of time
Data inputs: 		IR dataset
Data outputs:		AM_Tables.xls and AM_completeness
Author:				Thomas Pullum and modified by Courtney Allen for the code share project
Date last modified: November 6, 2020 by Trevor Croft
					March 22, 2021 by Shireen Assaf to add more desciptive labels in the exported excel file using putexcel. This code was added to the "merge_files" program.   
Note:				See below 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
mx			"mortality rate"
q_15_to_50	(aka 15q35)	"probability of dying between ages 15 and 50"
mmx         "maternal mortality rate"
PMDF		"proportions maternal among deaths of females of reproductive age"
MMRatio 	"maternal mortality ratio
PRMRatio 	"pregnancy related mortality ratio"
mLTR		"lifetime risk of maternal death"
prLTR   	"lifetime risk of pregnancy-related death"
----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------

MATERNAL MORTALITY RATIO
	The MMRatio is the MMRate divided by the GFR, where the GFR is from the same time period as the 
	MMRate but is age-standardized according to the age distribution of the women in the IR file.  
	Note that this GFR is defined as the number of births to women 15-49, divided by the number of 
	(or exposure by) women age 15-49; it is not the DHS GFR.

OUTPUTS
	After this program has been run and the files have been saved you will find
	two excel workbooks. One labeled AM_tables.xlsx will have all mortality rates.
	The other is labeled AM_completeness and will have all completeness of sibling
	information.

NOTES
	Executable statements and more comments begin after the multiple rows of 
	asterisks around line 1250.
	
	The program agrees exactly with DHS procedures, except for confidence intervals. 

	It is a complete re-write, not a translation, of the CSPro program. It includes 
	many comments and explanations and is intended for users who are already familiar
	with demographic rates and with Stata. It is expected that users will make modifications.

	The program does not include an option for covariates. DHS does not recommend 
	the calculation of maternal mortality rates or ratios within subpopulations and 
	will not facilitate this, but of course users can modify the program if they wish. 
	The only covariates in the data files are characteristics of the respondent, not
	of her siblings.

	There is no difference between never-married and ever-married surveys in the calculation
	of the asdrs. It only uses the sibling data in the IR file, from the survey of women.  

	The program does four poisson regressions with the age groups stacked.  One 
	is for the age-specific fertility rates for the respondents, to get the re-weighted
	GFR. The other three are for the age-specific death rates for men, age-specific 
	death rates for women, and age-specific pregnancy-related death rates, all based
	on the sisters.  

	The rates are given to many decimal places and do not include factors of 1000
	or 100,000. YOU MUST APPLY THOSE FACTORS YOURSELF.
	
	As is standard DHS practice, exposure or events in the month of interview are ignored.

	Calculate exposure to successive age intervals within the interval of observation.
	The age intervals are numbered 1 for 15-19 through 7 for 45-49.

	The first cmc when the sibling is in age interval i is mm4+(i+2)*60 and the last cmc when the sibling is in age interval i
	  is the first cmc plus 59. The months of exposure to age interval i within the window is mexp_i.

	first_1 is the cmc when the sibling reached age interval 1 (age 15-19), and last_1 is the last cmc when the sibling was in age
	  interval 1 (age 15-19), etc., up to interval 7 (age 45-49)

	The filenames include the two-character country code, characters 5 and 6 from the 
	IR filename, and the starting and ending dates of the window of time. The log 
	file includes most of the same numbers and also includes the tables on completeness
	and timing of a maternal death (during pregnancy, at delivery, or afterwards) 
	and sibship size. Those numbers are not included in the output files.  


MEN'S DATA
	Users can modify if the men's survey included sibling histories.

	The procedure uses the MR file, but only for the proportion in each five-year 
	age group at the time of the survey, needed for re-weighting the asdrs to get 35m15.

	If there was no survey of men, the current age distribution can be obtained from 
	the PR file, with modifications to the routine "get_age_distributions". If you 
	are only interested in the women's 35m15 and/or the MMratio, you can use any MR 
	file and ignore the results for men.

	This version does not include the data on the men's siblings, if any. 
	Modification to do that is not difficult. Here the men's file is used only 
	as part of the calculation of adult male mortality, not for maternal mortality.
	If you are not interested in adult male mortality, you can use any MR file 
	at all, with no effect on the estimates of adult female or maternal mortality.


VARIABLES
	mm1  "Sex"
	mm2  "Survival status"
	mm3  "Current age"
	mm4  "Date of birth (cmc)"
	mm6  "Years since death"
	mm7  "Age at death"
	mm8  "Date of death (cmc)"
	mm9  "Death and pregnancy"
	mm12 "Length of time between sibling's delivery and death"
	mm14 "Number of sibling's children"
	mm16 "Sibling's death due to violence or accident" (In surveys from 2016 onwards)

	pregnancy-related death: mm9 is 2, 3, 5, or 6, and mm16 is not used
	maternal death:          mm9 is 2, 3, or 5,    and mm16=0 

	mm2 codes:
			   0 dead
			   1 alive
			   8 don't know
	mm9 codes:
			   0 never pregnant
			   1 death not related
			   2 died while pregnant
			   3 died during delivery
			   4 since delivery         NOT USED
			   5 6 weeks after delivery
			   6 2 months after delivery ADDITIONAL BETWEEN 6 WEEKS AND 2 MONTHS
			  98 don't know

	mm12 codes:
			 100 same day
			 101 days: 1
			 199 days: number missing
			 201 months: 1
			 299 months: number missing
			 301 years: 1
			 399 years: number missing
			 997 inconsistent
			 998 don't know

	mm16 codes
			   0 no
			   1 violence
			   2 accident

	mm12 is not needed

	mm4 and mm8 are always coded but may include some impossible values; apparently not always edited

	mm3 is equivalent to int((v008-mm4)/12)  age in years if alive
	mm6 is equivalent to int((v008-mm8)/12)  age in years at death if dead
	mm7 is equivalent to int((mm8-mm4)/12)   years since death if dead

	Only keep the variables that are needed: mm 1, 2, 4, 8, 9, 16

	If mm16 is present and if it equals 1 or 2, then change mm9 from 2 to 1

	The program produces several tables that appear in the log file.  You can insert lines for tabout, 
	  or export excel, or can copy from the log file, whatevere is most convenient for you.  All the the main rates,
	  age-specific and overall, age-adjusted, are exported as Stata .dta file and as Excel files, for you to manipulate.

CONFIDENCE INTERVALS
	 
	95% confidence intervals are provided for all of the main overall rates. These
	confidence intervals are calculated on the scale of the log of the rate and 
	then the ends are exponentiated. The intervals are not centered on the point estimate.
	The point estimate is the geometric mean of L and U, not the arithmetic mean.  
	The intervals are always shorter on the downward side than on the upward side. 
	A standard error for the rate itself is not produced. If you want an estimate
	of the standard error of the rate itself, use (U-L)/(2*1.96).  If you want the 
	standard error of the log rate, it is se=(logU-logL)/(2*1.96).  If you want to
	test the significance of the difference between two rates from two surveys, say
	R1 and R2, do it on the log scale.  
	The test statistic will be (logR1-logR2)/sqrt(se1^2+se2^2).
	This will have a z distribution, with .05 two tailed critical values at +/-1.96, etc.

	The confidence intervals are calculated within a statistical framework. They
	will not match the DHS jackknife procedure.	In general the width of the confidence 
	intervals produced here will be very close to the width of the DHS intervals, but
	will be displaced slightly upwards because of the asymmetry described in the 
	previous paragraph.  
----------------------------------------------------------------------------*/


******************************************************************************
//SUB PROGRAMS BEGIN HERE
******************************************************************************

//Calculate the end date and start date for the desired window of time
program define start_month_end_month

	/*--------------------------------------------------------------------------
	NOTE:
	There are two ways to specify the window of time using lw (lower end of window)
	and uw (upper end of window).

		Method 1: as calendar year intervals, e.g. with
			- scalar lw=1992
			- scalar uw=1996
			for a window from January 1992 through December 1996, inclusive.

		Method 2: as an interval before the date of interview, e.g. with
			- scalar lw=-2
			- scalar uw=0  
			for a window from 0 to 2 years before the interview, inclusive
			(that is, three years)

	The program knows you are using method 2 if the two numbers
	you enter are negative or zero.

	start_month is the cmc for the earliest month in the window and
	end_month is the cmc for the latest month in the window
	
	coding that WILL NOT include the month of interview in the most recent interval 
	in order to match with DHS results

	--------------------------------------------------------------------------*/

	//Date of interview
	gen doi=v008

	//Section for "years before survey". lw and uw will be <=0 (see Method 2 above)
	if lw<=0 {

	gen start_month=doi+12*lw-12
	gen end_month=doi+12*uw-1
	}

	//Section for calendar years. lw and uw will be >0 (see Method 1 above)
	if lw>0 {
	gen start_month=12*(lw-1900)+1
	gen end_month=12*(uw-1900)+12
	}

	replace end_month=min(end_month,doi)

	//calculate the reference date
	summarize start_month [iweight=v005/1000000]
	scalar mean_start_month=r(mean)

	summarize end_month [iweight=v005/1000000]
	scalar mean_end_month=r(mean)

	//Convert back to continuous time, which requires an adjustment of half a month (i.e. -1/24).
	//(This adjustment is not often made but should be.)
	scalar refdate=1900-(1/24)+((mean_start_month+mean_end_month)/2)/12

	summarize doi [iweight=v005/1000000]
	scalar mean_doi=1900-(1/24)+(r(mean))/12

end
***************************************************************************

//Go to the IR file and reshape the mm variables.
program define setup_adult_mm_vars

	//Setup local path and data file name
	local lpath=spath
	local lfn_IR=sfn_IR
	use "`lpath'\\`lfn_IR'", clear

	//Make a file of sisters
	keep v000 v001 v002 v003 v005 v008 v010 v013 v021-v025 mm* awfact*

	//This file includes all women, including women with no siblings, and is needed later
	sort v001 v002 v003
	save IR_all_women.dta, replace

	gen clusterid=v021

	//check for v023 for stratum id
	if sv023_NA==0 {
	rename v023 stratumid
	}

	if sv023_NA==1 {
	egen stratumid=group(v024 v025)
	}

	//Need to check for mm16; if an older survey, must give it a value
	scalar smissing_mm16=0
	capture confirm numeric variable mm16_01, exact 
	if _rc>0 {
	  scalar smissing_mm16=1
	  local li=1
	  while `li'<=20 {
	  gen mm16_`li'=.
	  local li=`li'+1
	  }
	}

	ren *_0* *_*
	drop mmc* mmidx* mm5* mm10* mm11* mm12* mm13* mm14* mm15* 


	//reshape data file 
	quietly reshape long mm1_ mm2_ mm3_ mm4_ mm6_ mm7_ mm8_ mm9_ mm16_, i(v001 v002 v003) j(mmidx)
	rename mm*_ mm*

	//Drop any cases with sex missing, i.e. mm1>2
	drop if mm1>2

	/*--------------------------------------------------------------------------
	NOTE: 
	Important for redefinition of Pregnancy Related Mortality Ratio (PRMR)
	in surveys from 2016 onwards
	
	If mm9=2, and mm16=1 or 2, recode mm9 to 1
	replace mm9=1 if mm9==2 & (mm16==1 | mm16==2)

	For earlier surveys that do not include mm16, it is only possible to 
	calculate PRMR; what was previously called maternal mortality (MM) is now called 
	pregancy related mortality (PRM)
	
	See https://blog.dhsprogram.com/mmr-prmr/ for more information on these indicators.
	--------------------------------------------------------------------------*/

	//This file has one record for each sibling. It is needed for the tables on completeness of information. 
	save workfile.dta, replace


	//Crucial: drop cases in which survival status is don't know (dk) AFTER saving workfile
	drop if mm2>1

	//specify the lower and upper cmcs of the interval of observation, start_month and end_month,
	
	/*--------------------------------------------------------------------------
	NOTE:
	This uses scalars lw and uw that were set earlier; usually lw=-6 and uw=0, 
	but not always!
	--------------------------------------------------------------------------*/

	//execute program to create start and end month for window of time
	start_month_end_month

	rename mm1 sex

	//Tabulate the timing--during pregnancy, at childbirth, afterwards

		//tabulate mm9 for all maternal deaths, unweighted
		tab mm9

		//tabulate mm9 for all maternal deaths, weighted
		tab mm9 [iweight=v005/1000000]

		//tabulate mm9 for all maternal deaths in the window, unweighted
		tab mm9 if mm8>=start_month & mm8<=end_month

		//tabulate mm9 for all maternal deaths in the window, weighted
		tab mm9 if mm8>=start_month & mm8<=end_month [iweight=v005/1000000]

	save adult_mm_vars.dta, replace
	
	/*--------------------------------------------------------------------------
	NOTE:
	
	adult_mm_vars.dta is an individual-level file for with one record for each 
	sibling in the IR file. If there was also a sibling module in the men's survey,
	a parallel routine must be added.
	--------------------------------------------------------------------------*/

end
***************************************************************************

//Calculate the table on completeness of information. 
program define completeness_of_information

	/*--------------------------------------------------------------------------
	NOTE: 
	This routine calculates the table on completeness of information. 
	It does not depend on the window of time that is used for the rates.

	The data quality tables may be UNWEIGHTED, as in Cambodia 2014, or WEIGHTED, 
	as in Tanzania 2010; here they will be produced both unweighted and weighted
	--------------------------------------------------------------------------*/
	
	//open file 
	use workfile.dta, clear

	//Tabulate survival status by sex for all deaths, weighted
	tab mm2 mm1,m

	//Tabulate survival status by sex for all deaths, unweighted
	tab mm2 mm1 [iweight=v005/1000000],m

	//There should not be any cases with survival status=9 or NA, but if there are, 
	//change to dk
	replace mm2=8 if mm2>8


	/*--------------------------------------------------------------------------
	NOTE: 
	If the sibling is alive: label for mm3 indicates that age is missing if mm3 is 98.
	However, it appears that "." is used.  Allow for 99 too.
	--------------------------------------------------------------------------*/

	//Similarly for mm6 and mm7

	gen age_AD_YSD_missing=.
	replace age_AD_YSD_missing=0 if mm2==1
	replace age_AD_YSD_missing=1 if mm2==1 & (mm3==98 | mm3==99 | mm3==.)
	tab age_AD_YSD_missing mm1,col

	//If the sibling has died, YSD is years since death (mm6) and AD is age at death (mm7).
	gen     YSD_missing=0
	gen      AD_missing=0
	replace YSD_missing=1 if mm2==0 & (mm6==98 | mm6==99 | mm6==.)
	replace  AD_missing=1 if mm2==0 & (mm7==98 | mm7==99 | mm7==.)

	replace age_AD_YSD_missing=2 if mm2==0
	replace age_AD_YSD_missing=3 if mm2==0 & AD_missing==1 & YSD_missing==0  
	replace age_AD_YSD_missing=4 if mm2==0 & AD_missing==0 & YSD_missing==1  
	replace age_AD_YSD_missing=5 if mm2==0 & AD_missing==1 & YSD_missing==1  

	#delimit ;
	label define age_AD_YSD_missing  0 "Living, age reported"  1 "Living, age missing" 
	2 "Dead, AD and YSD reported" 3 "Dead, missing only AD" 4 "Dead, missing only YSD" 5 "Dead, missing AD and YSD";
	#delimit cr
	label values age_AD_YSD_missing age_AD_YSD_missing

	//save
	save completeness.dta, replace

	//Create tabulations for completeness 

		//survival status by sex for all deaths, unweighted and weighted, percentaged
		tab mm2 mm1, col
		tab mm2 mm1 [iweight=v005/1000000], col
		tabout mm2 mm1 using AM_completeness.xls, cells(freq col) clab(No. Col_%) replace
		
		//incompleteness of date by sex for surviving siblings
		tab age_AD_YSD_missing mm1 if mm2==1, col
		tab age_AD_YSD_missing mm1 if mm2==1 [iweight=v005/1000000], col
		tabout age_AD_YSD_missing mm1 if mm2==1 using AM_completeness.xls, cells(freq col) clab(No. Col_%) append

		//incompleteness of date by sex for dead siblings
		tab age_AD_YSD_missing mm1 if mm2==0, col
		tab age_AD_YSD_missing mm1 if mm2==0 [iweight=v005/1000000], col
		tabout age_AD_YSD_missing mm1 if mm2==0 using AM_completeness.xls, cells(freq col) clab(No. Col_%) appen
	
end
***************************************************************************

//For standardization of 35m15 and the GFR we need the current distribution across five-year age intervals.  
program define get_age_distributions


	/*--------------------------------------------------------------------------
	NOTE: 
	For women, use the IR file; for men (15-49 only) use the MR file.

	The age distribution for men is needed ONLY for calculating the age-standardized
	death rate for ages 15-49, i.e. 35m15.

	Age is considered to be more accurate in the IR and MR files than in the PR file;
	otherwise we could use age in the PR file. If there is no MR file, use the PR file.
	We also need to do age-sex standardization of the total, and for that we need
	the PR file
	--------------------------------------------------------------------------*/

	//Begin PR segment for the joint age-sex distribution
	
	*Segment to get the age distribution of men from the PR file, for standardization
	*of the brothers' age distribution.

	//scalar data path and filename 
	local lpath=spath
	local lfn_PR=sfn_PR
	use hv005 hv103-hv105 using "`lpath'\\`lfn_PR'", clear

	//restrict to de facto men and women in age range
	keep if hv103==1 & hv105>=15 & hv105<=49
	keep hv005 hv104
	gen sex=hv104

	//may need to remove hh cases with hv104 missing
	keep if sex<=2
	gen sex_wt=hv005/1000000
	collapse (sum) sex_wt,by(sex)
	total sex_wt
	matrix T=e(b)
	scalar stotal=T[1,1]

	scalar   sprop_male=sex_wt[1]/stotal
	scalar sprop_female=sex_wt[2]/stotal
	scalar list sprop_male sprop_female

	/*--------------------------------------------------------------------------
	ATTENTION: One or the other of the next two segments must be used for the 
	age standardization of 35m15 for men.
	
	Choose the PR segment or the MR segment, the default is the MR segment.
		--------------------------------------------------------------------------*/

	/*
	**********************begin PR segment
	//Segment for age distribution of men from the PR file, for standardization of the brothers' age distribution.
	local lpath=spath
	local lfn_PR=sfn_PR
	use hv005 hv103-hv105 using "`lpath'\\`lfn_PR'", clear

	//restrict to de facto males in age range
	keep if hv103==1 & hv104==1 & hv105>=15 & hv105<=49

	keep hv005 hv105
	gen age_grp=-2+int(hv105/5)
	gen age_prop=hv005/1000000
	**********************end PR segment
	*/

	**********************begin MR segment
	//Segment for age distribution of men from the MR file, for standardization of the brothers' age distribution.
	local lpath=spath
	local lfn_MR=sfn_MR
	use mv005 mv012 mv013 using "`lpath'\\`lfn_MR'", clear

	//restrict age range if necessary
	keep if mv012>=15 & mv012<=49

	keep mv005 mv013
	rename mv013 age_grp
	gen age_prop=mv005/1000000
	**********************end MR segment


	collapse (sum) age_prop,by(age_grp)
	quietly summarize age_prop
	replace age_prop=age_prop/r(sum)
	gen sex=1
	sort age_grp

	//save these weights as scalars for easier use in calc_ci
	local li=1
	while `li'<=7 {
	scalar age_prop_men`li'=age_prop[`li']
	local li=`li'+1
	}
	save age_dist_m.dta, replace


	//Segment for age distribution of women in the IR file, for standardization of the sisters' age distribution.
	//NOTE: The age distribution must use awfactt for women

	local lpath=spath
	local lfn_IR=sfn_IR
	use "`lpath'\\`lfn_IR'", clear

	keep v005 v013 awfact*
	rename v013 age_grp
	gen age_prop=(v005/1000000)*(awfactt/100)
	collapse (sum) age_prop,by(age_grp)
	quietly summarize age_prop
	replace age_prop=age_prop/r(sum)
	gen sex=2
	sort age_grp

	//save these weights as scalars for easier use in calc_ci
	local li=1
	while `li'<=7 {
		scalar age_prop_women`li'=age_prop[`li']
		local li=`li'+1
		}

	save age_dist_f.dta, replace

	append using age_dist_m.dta
	gen sex_prop=.
	replace sex_prop=sprop_male   if sex==1
	replace sex_prop=sprop_female if sex==2
	sort sex age_grp

	/*
	//save these weights as scalars for easier use in calc_ci
	local li=1
	while `li'<=7 {
	scalar age_prop_men`li'=age_prop[`li']
	local liplus7=`li'+7
	scalar age_prop_women`li'=age_prop[`liplus7']
	local li=`li'+1
	}
	*/

	save sex_age_dist.dta, replace

	/*--------------------------------------------------------------------------
	--------------------------------------------------------------------------*/
	//sex_age_dist.dta has 2 x 7 = 14 lines. It gives the "best" age distribution of men and women
	//at the time of the survey, as the proportions of each sex who are in each of the 7 age groups.
	//sex_prop is the proportion male in the PR files (same for all age groups) and the proportion
	//female (same for all age groups)

end
***************************************************************************

//This routine calculates the table on sibship size and the sex ratio, which is always WEIGHTED.
program define sibship_size_and_sex_ratio


	//It will be easiest to save a temporary file and then return to that file at the end
	use workfile.dta, clear

	//The current file has siblings as cases.
	//For sibship size, we keep the siblings with sex missing, but exclude them from the sex ratio.
	gen unwtd_brothers=.
	replace unwtd_brothers=0 if mm1==2
	replace unwtd_brothers=1 if mm1==1
	gen wtd_brothers=unwtd_brothers*v005/1000000

	gen unwtd_sisters=.
	replace unwtd_sisters=0 if mm1==1
	replace unwtd_sisters=1 if mm1==2
	gen wtd_sisters=unwtd_sisters*v005/1000000

	gen unwtd_nosex=.
	replace unwtd_nosex=1 if mm1==8
	gen wtd_nosex=unwtd_nosex*v005/1000000

	//Collapse so respondents are cases; sum the siblings for each respondent, by age group of the respondent.
	collapse (mean) v005 v010 v013 awfact* (sum) *wtd* , by(v001 v002 v003)

	/*--------------------------------------------------------------------------
	NOTE: 
	Now have one record per respondent, but this file, which is constructed from 
	a file of siblings,  does not include women who had no siblings.  To get the
	distribution of number of siblings, including women with no	siblings at all,
	it is necessary to merge with the IR file. 
	--------------------------------------------------------------------------*/

	//merge with IR file to get women with no siblings
	sort v001 v002 v003
	merge v001 v002 v003 using IR_all_women.dta

	tab _merge

	drop _merge
	replace unwtd_brothers=0 if unwtd_brothers==.
	replace   wtd_brothers=0 if wtd_brothers==.
	replace  unwtd_sisters=0 if unwtd_sisters==.
	replace    wtd_sisters=0 if wtd_sisters==.

	//Now must add the respondent back into the subship.
	gen unwtd_resp=1
	gen wtd_resp=v005/1000000

	//yob refers to the respondent's year of birth
	gen minyob=v010
	gen maxyob=v010

	//Next collapse by age groups of respondent, averaging the numbers of siblings
	collapse (sum) *wtd* (min) minyob (max) maxyob, by(v013)

	gen wtd_mean_sibship=(wtd_brothers+wtd_sisters+wtd_resp)/wtd_resp
	gen wtd_sex_ratio=100*wtd_brothers/wtd_sisters

	//Table x. Note that age groups are listed in reverse order
	gen v013r=-v013
	sort v013r
	drop v013r
	list v013 minyob maxyob wtd_mean_sibship wtd_sex_ratio, table clean abbreviate(20)

	collapse (sum) *wtd* (min) minyob (max) maxyob
	replace wtd_mean_sibship=(wtd_brothers+wtd_sisters+wtd_resp)/wtd_resp
	replace wtd_sex_ratio=100*wtd_brothers/wtd_sisters

	//Totals row of table x.
	list wtd_mean_sibship wtd_sex_ratio, table clean abbreviate(20)

end
***************************************************************************

//Calculate exposure, deaths, pregnancy-related deatls, and maternal deaths for each sibling
program define get_exposure_and_deaths

	/*--------------------------------------------------------------------------
	Now construct the adult and maternal mortality rates. Calculate exposure, 
	deaths, preganancy-related deaths, and maternal deaths for each sibling by 
	looping through the seven age intervals
	--------------------------------------------------------------------------*/

	//open file
	use adult_mm_vars.dta, clear

	local li=1 
	quietly while `li'<=7 {

	scalar si=`li'

	//For each sibling, calculate the first cmc and last cmc when he/she was in each age interval.
	gen first_`li'=mm4+(`li'+2)*60
	gen  last_`li'=first_`li'+59

	//These boundaries will typically extend into the future. 
	/*--------------------------------------------------------------------------
	NOTE: This should not be a problem because the specified time intervals are 
	always prior to the survey,	but make an adjustment to truncate.
	--------------------------------------------------------------------------*/
	replace  last_`li'=end_month if first_`li'<=end_month & last_`li'>=end_month
	replace first_`li'=. if first_`li'>end_month
	replace  last_`li'=. if first_`li'>end_month

	/*--------------------------------------------------------------------------
	NOTE: If there is a death in age interval i, replace last_i with 
	mm8	(the month of death) and then replace all subsequent values of first and
	last with . (not applicable). Crucial for correct calculation of exposure.
	--------------------------------------------------------------------------*/
	replace  last_`li'=mm8 if first_`li'<=mm8 & last_`li'>=mm8 & mm8<.
	replace first_`li'=. if first_`li'>mm8
	replace  last_`li'=. if first_`li'>mm8


	/*--------------------------------------------------------------------------
	NOTE: Identify deaths in the interval of age and time. Very important for all 
	the rates and ratios. Note that PR includes mm9=6. Not good but gives a match 
	with MM estimates before the question on violence and accidents was added  
	--------------------------------------------------------------------------*/
	gen deaths_in_`li'=0
	replace   deaths_in_`li'=1 if (first_`li'<=mm8 & last_`li'>=mm8) & (start_month<=mm8 & end_month>=mm8)

	gen prdeaths_in_`li'=0
	replace prdeaths_in_`li'=1 if deaths_in_`li'==1 & mm9>=2 & mm9<=6

	gen mdeaths_in_`li'=0
	replace  mdeaths_in_`li'=1 if deaths_in_`li'==1 & mm9>=2 & mm9<=5 & mm16!=1 & mm16!=2


	//Calculate exposure by subtraction
	gen mexp_`li'=0
	replace mexp_`li'=last_`li' -start_month+1 if first_`li'  <start_month & last_`li'>=start_month
	replace mexp_`li'=last_`li' -first_`li'+1  if first_`li' >=start_month & last_`li'<=end_month
	replace mexp_`li'=end_month -first_`li'+1  if first_`li'   <=end_month & last_`li'> end_month
	replace mexp_`li'=0 if mexp_`li'<0

	local li=`li'+1
	}

	drop first* last* start end

	//Reshape into a long file
	reshape long deaths_in_ prdeaths_in_ mdeaths_in_ mexp_, i(v001 v002 v003 mmidx) j(age_grp)
	rename *_ *
	drop if mexp==. | mexp==0

	//Convert months of exposure to years of exposure at this point.
	gen yexp=mexp/12

	rename   deaths_in died
	rename prdeaths_in prdied
	rename  mdeaths_in mdied

	//This is a file with one record for each sibling's exposure to each age group in the window.
	//It can be used for very detailed modeling. 
	gen lw=lw
	gen uw=uw
	local lfn=sfn_IR
	gen str12 file="`lfn'"


	label variable mm2  "Survival status"
	label variable mm3  "Current age"
	label variable mm4  "Date of birth (cmc)"
	label variable mm6  "Years since death"
	label variable mm7  "Age at death"
	label variable mm8  "Date of death (cmc)"
	label variable mm9  "Death and pregnancy"
	label variable mm16 "Sibling's death due to violence or accident" 
	save micro.dta, replace

	drop lw uw file

end
***************************************************************************

//Reduced micro analysis to get the age-specific mmrates and variance-covariance matrix
program define calc_mortality_rates


	//This is a binary outcome but we want a rate, not a probability, so use poisson, not logit. 
	*use micro.dta, clear

	gen brother=0
	replace brother=1 if sex==1

	gen lnyexp=log(yexp)
	gen sister=0
	replace sister=1 if sex==2

	***********************
	svyset clusterid [pweight=v005], strata(stratum) singleunit(centered)
	***********************

	//The following stacked poisson models produce the age-specific death rates.
	//The iterations limit should only kick in if the number of deaths is close to 0.

	//Construct dummy variables for ALL age groups ("noomit" is crucial!).
	xi, noomit i.age_grp
	rename _I* *

	* To get the logs of the age-specific death rates for men
	***********************
	svy, subpop(brother): poisson died age_grp_*, offset(lnyexp) nocons iter(50)
	***********************
	matrix T_men_asdr=r(table)
	matrix V_men_asdr=e(V)


	//To get the logs of the age-specific death rates for women
	***********************
	svy, subpop(sister): poisson died age_grp_*, offset(lnyexp) nocons iter(50)
	***********************
	matrix T_women_asdr=r(table)
	matrix V_women_asdr=e(V)


	//To get the logs of the age-specific pregnancy-related death rates for women
	***********************
	svy, subpop(sister): poisson prdied age_grp_*, offset(lnyexp) nocons iter(50)
	***********************
	matrix T_pr_asdr=r(table)
	matrix V_pr_asdr=e(V)


	//To get the logs of the age-specific maternal death rates for women
	/*--------------------------------------------------------------------------	
	NOTE: Maternal mortality rates can ONLY be done for surveys with var mm16 
	--------------------------------------------------------------------------*/
	//check for mm16, otherwise fill matrices with zeroes
	matrix T_maternal_asdr=0
	matrix V_maternal_asdr=0
	if smissing_mm16==0 {
		***********************
		svy, subpop(sister): poisson mdied age_grp_*, offset(lnyexp) nocons iter(50)
		***********************
		matrix T_maternal_asdr=r(table)
		matrix V_maternal_asdr=e(V)
		}

	/*--------------------------------------------------------------------------	
	NOTE: To match with the reports, we also produce the numerators and denominators
	of these rates, which can also be used to calculate the rates. The model-based
	calculation is included largely for constructing confidence intervals. 
	--------------------------------------------------------------------------*/
	local li=1
	while `li'<=7 {
	scalar      men_asdr`li'=exp(     T_men_asdr[1,`li'])
	scalar    women_asdr`li'=exp(   T_women_asdr[1,`li'])
	scalar       pr_asdr`li'=exp(T_pr_asdr[1,`li'])
	scalar maternal_asdr`li'=exp(T_maternal_asdr[1,`li'])
	local li=`li'+1
	}

	//Collapse the micro file to what is needed for the numerators and denominators of the rates. 
	drop mm2-mm16 mexp*

	gen unwtd_n=1
	gen   wtd_n=v005/1000000

	gen unwtd_deaths=died*unwtd_n
	gen   wtd_deaths=died*wtd_n

	gen unwtd_prdeaths=prdied*unwtd_n
	gen   wtd_prdeaths=prdied*wtd_n

	gen unwtd_mdeaths=mdied*unwtd_n
	gen   wtd_mdeaths=mdied*wtd_n

	gen unwtd_yexp=yexp*unwtd_n
	gen   wtd_yexp=yexp*wtd_n

	drop *wtd_n

	collapse (sum) *wtd*, by(age_grp sex)
	sort sex age_grp

	gen   wtd_drate=wtd_deaths/wtd_yexp
	gen wtd_prdrate=wtd_prdeaths/wtd_yexp
	gen  wtd_mdrate=wtd_mdeaths/wtd_yexp
	gen    wtd_prpmdf=wtd_prdeaths/wtd_deaths
	gen    wtd_mpmdf=wtd_mdeaths/wtd_deaths

	save exposure_and_deaths.dta, replace
	//exposure_and_deaths.dta is a collapsed file with all deaths, pr deaths, m deaths, and exposure

end
***************************************************************************

//This routine calculates confidence intervals for the reweighted or standardized rates
program define calc_ci

	/*--------------------------------------------------------------------------
	NOTE: 
	The reweighted or standardized rates resulting from this program are:
		1) Drate_men, which is 35m15, the death rate for men;
		2) Drate_women, which is 35m15, the death rate for women;
		3) MMRate, the maternal mortality rate;
		4) GFR, the General Fertility Rate; and
		5) MMRatio, the maternal mortality ratio.

	The first four are simply the sum of the age-specific rates, weighted by the
	age distributions of men or women at the time of the survey; MMRatio is MMRate/GFR.

	The calculations are done with scalars and matrices using the delta method. 
	The results are then added to the file as variables.
	 R is the adjusted overall rate
	 F is a function of the compound rate, in all these cases F=log(R)
	 V is the relevant variance-covariance matrix of the underlying b's (poisson regression coefficients).
	 D is the vector of derivatives of F with respect to the b's.
	 C is a constant that has been factored out of D; it must be squared
	 se2 is the standard error of F

	The following procedure could be made more efficient but with little real gain.
	--------------------------------------------------------------------------*/

	//se and ci for the reweighted Drate_men

	scalar R=sDrate_men_rewtd
	scalar F=log(R)
	scalar C=(1/R)

	local li=1
	while `li'<=7 {
	scalar d`li'=age_prop_men`li'*exp(T_men_asdr[1,`li'])
	local li=`li'+1
	}

	matrix D=(d1,d2,d3,d4,d5,d6,d7)
	matrix M=(C*C)*D*V_men_asdr*D'
	scalar se2_men=M[1,1]
	scalar LF=F-1.96*sqrt(se2_men)
	scalar UF=F+1.96*sqrt(se2_men)
	scalar sDrate_men_rewtd_L=exp(LF)
	scalar sDrate_men_rewtd_U=exp(UF)


	//se and ci for the reweighted Drate_women
	scalar R=sDrate_women_rewtd
	scalar F=log(R)
	scalar C=(1/R)

	local li=1
	while `li'<=7 {
	scalar d`li'=age_prop_women`li'*exp(T_women_asdr[1,`li'])
	local li=`li'+1
	}

	matrix D=(d1,d2,d3,d4,d5,d6,d7)
	matrix M=(C*C)*D*V_women_asdr*D'
	scalar se2_women=M[1,1]
	scalar LF=F-1.96*sqrt(se2_women)
	scalar UF=F+1.96*sqrt(se2_women)
	scalar sDrate_women_rewtd_L=exp(LF)
	scalar sDrate_women_rewtd_U=exp(UF)

	//se and ci for the reweighted PRMRate
	scalar R=sPRMRate_rewtd
	scalar F=log(R)
	scalar C=(1/R)

	local li=1
	while `li'<=7 {
	scalar d`li'=age_prop_women`li'*exp(T_pr_asdr[1,`li'])
	local li=`li'+1
	}

	matrix D=(d1,d2,d3,d4,d5,d6,d7)
	matrix M=(C*C)*D*V_maternal_asdr*D'
	scalar se2_PRMRate=M[1,1]
	scalar LF=F-1.96*sqrt(se2_PRMRate)
	scalar UF=F+1.96*sqrt(se2_PRMRate)
	scalar sPRMRate_rewtd_L=exp(LF)
	scalar sPRMRate_rewtd_U=exp(UF)


	//se and ci for the reweighted MMRate
	scalar R=sMMRate_rewtd
	scalar F=log(R)
	scalar C=(1/R)

	local li=1
	while `li'<=7 {
	scalar d`li'=age_prop_women`li'*exp(T_maternal_asdr[1,`li'])
	local li=`li'+1
	}

	matrix D=(d1,d2,d3,d4,d5,d6,d7)
	matrix M=(C*C)*D*V_maternal_asdr*D'
	scalar se2_MMRate=M[1,1]
	scalar LF=F-1.96*sqrt(se2_MMRate)
	scalar UF=F+1.96*sqrt(se2_MMRate)
	scalar sMMRate_rewtd_L=exp(LF)
	scalar sMMRate_rewtd_U=exp(UF)


	//se and ci for the reweighted GFR
	scalar R=sGFR_rewtd
	scalar F=log(R)
	scalar C=(1/R)

	local li=1
	while `li'<=7 {
	scalar d`li'=age_prop_women`li'*exp(T_asfr[1,`li'])
	local li=`li'+1
	}

	matrix D=(d1,d2,d3,d4,d5,d6,d7)
	matrix M=(C*C)*D*V_asfr*D'
	scalar se2_GFR=M[1,1]
	scalar LF=F-1.96*sqrt(se2_GFR)
	scalar UF=F+1.96*sqrt(se2_GFR)
	scalar sGFR_rewtd_L=exp(LF)
	scalar sGFR_rewtd_U=exp(UF)


	//se and ci for the reweighted PRMRatio
	*[log(PRMRatio)]=[log(PRMRate)]-[log(GFR)]
	*var[log(PRMRatio)]=var[log(PRMRate)]+var[log(GFR)]=se2_PRMRate+se2_GFR=se2

	scalar F=log(sPRMRate_rewtd)-log(sGFR_rewtd)
	scalar se2=se2_PRMRate+se2_GFR
	scalar LF=F-1.96*sqrt(se2)
	scalar UF=F+1.96*sqrt(se2)
	scalar sPRMRatio_L=exp(LF)
	scalar sPRMRatio_U=exp(UF)

	//se and ci for the reweighted MMRatio
	*[log(MMRatio)]=[log(MMRate)]-[log(GFR)]
	*var[log(MMRatio)]=var[log(MMRate)]+var[log(GFR)]=se2_MMRate+se2_GFR=se2

	scalar F=log(sMMRate_rewtd)-log(sGFR_rewtd)
	scalar se2=se2_MMRate+se2_GFR
	scalar LF=F-1.96*sqrt(se2)
	scalar UF=F+1.96*sqrt(se2)
	scalar sMMRatio_L=exp(LF)
	scalar sMMRatio_U=exp(UF)


end
***************************************************************************

//Combine all components into a single file (age distribution, exposure, deaths, and ASFRs)
program define merge_files


	//Combine all components into a single file with 2 x 7 = 14 columns:
	* sex_age_dist.dta
	* exposure_and_deaths.dta
	* fertility_rates.dta

	use sex_age_dist.dta, clear

	merge sex age_grp using exposure_and_deaths.dta

	drop _merge
	sort sex age_grp
	gen fx=.

	local li=1
	while `li'<=7 {
	replace fx=fx`li' if age_grp==`li' & sex==2
	local li=`li'+1
	}

	list, table clean

	//Calculate rates and standardize on the current age distribution
	gen fx_rewtd=fx*age_prop

	gen mx=wtd_deaths/wtd_yexp
	gen mx_rewtd=mx*age_prop

	gen prpmdf=wtd_prdeaths/wtd_deaths
	gen  mpmdf=wtd_mdeaths/wtd_deaths

	gen prmx=wtd_prdeaths/wtd_yexp
	gen prmx_rewtd=prmx*age_prop

	gen mmx=wtd_mdeaths/wtd_yexp
	gen mmx_rewtd=mmx*age_prop

	//See DHS Guide to Statistics for use of 2.4 rather than 2.5 in the following formula
	gen q5=5*mx/(1+2.4*mx)
	gen qterm=log(1-q5)

	save age_specific_results.dta, replace

	//save some numbers for the calculation of the standard errors
	//must add 7 to the index because the first 7 elements are for men (and are NA)
	local li=1
	while `li'<=7 {
	local liplus7=`li'+7
	scalar dprmx`li'=prmx_rewtd[`liplus7']
	scalar dmmx`li'=mmx_rewtd[`liplus7']
	scalar dfx`li' =fx_rewtd[`liplus7']
	local li=`li'+1
	}

	local lcid=scid
	local lpv=spv
	local llw=lw
	local luw=uw

	gen str2 country=scid
	gen str2 phase_version=spv
	gen lw=lw
	gen uw=uw
	gen refdate=refdate
	gen mean_doi=mean_doi

	//save
	save "Adult_Mortality_by_age.dta", replace

	//adult mortality 
	list sex age_grp unwtd_deaths unwtd_yexp wtd_deaths wtd_yexp mx q5, table clean
	
	label define sex 1 "Men" 2 "Women"
	label val sex sex

	export excel refdate mean_doi sex age_grp mx wtd_deaths wtd_yexp unwtd_deaths unwtd_yexp age_prop lw uw   using ///
	 "AM_tables.xlsx", firstrow(variable) sheet("Adult mortality by age") sheetreplace 
	putexcel set "AM_tables.xlsx", modify sheet("Adult mortality by age") 
	putexcel D1=("Age in 5-year groups") E1=("mx: Adult mortality rate for 15-49. Multiply by 1000 to present per 1000 persons")
	
	export excel refdate mean_doi sex age_grp  prmx fx prpmdf wtd_prdeaths wtd_yexp unwtd_prdeaths age_prop lw uw if sex==2  using /// 
	 "AM_tables.xlsx", firstrow(variable) sheet("PR mortality by age") sheetreplace
	putexcel set "AM_tables.xlsx", modify sheet("PR mortality by age") 
	putexcel D1=("Age in 5-year groups") E1=("mpx: Pregnancy-related mortality rate for women 15-49. Multiply by 1000 to present per 1000 women")
	
	export excel refdate mean_doi sex age_grp  mmx fx mpmdf wtd_mdeaths wtd_yexp unwtd_mdeaths age_prop lw uw if sex==2 using  ///
	 "AM_tables.xlsx", firstrow(variable) sheet("Maternal mortality by age") sheetreplace
	putexcel set "AM_tables.xlsx", modify sheet("Maternal mortality by age") 
	putexcel D1=("Age in 5-year groups") E1=("mmx: Maternal mortality rate for women 15-49. Multiply by 1000 to present per 1000 women")

	//pregnancy related mortality;
	list sex age_grp prpmdf unwtd_prdeaths wtd_prdeaths wtd_yexp prmx fx q5 if sex==2, table clean abbreviate(20)

	//maternal mortality;
	list sex age_grp mpmdf unwtd_mdeaths wtd_mdeaths wtd_yexp mmx fx q5 if sex==2, table clean abbreviate(20)


	//Calculate the summary rates as the totals of the columns in work.dta; rename the sums
	collapse (first) country phase_version lw uw refdate mean_doi (sum) *wtd_*deaths *wtd_yexp *mx_rewtd fx* qterm (mean) sex_prop, by(sex)

	rename fx_rewtd GFR_rewtd
	rename mx_rewtd Drate_rewtd
	rename prmx_rewtd PRMRate_rewtd
	rename mmx_rewtd MMRate_rewtd
	gen PRMRatio=PRMRate_rewtd/GFR_rewtd
	gen MMRatio=MMRate_rewtd/GFR_rewtd
	gen TFR=5*fx
	drop fx

	//Calculate the PMDF, all-cause death rates for men and women (35m15), and the probabilities (35q15)
	gen prPMDF=wtd_prdeaths/wtd_deaths
	gen mPMDF=wtd_mdeaths/wtd_deaths
	gen q_15_to_50=1-exp(qterm)
	drop qterm

	//two versions of the LTR (Lifetime Risk); In LTR2 the factor 16.7 is an approximation from another source
	gen prLTR1=1-(1-PRMRatio)^TFR
	*gen prLTR2=(35-16.7*q_15_to_50)*PRMRate_rewtd
	gen mLTR1=1-(1-MMRatio)^TFR
	*gen mLTR2=(35-16.7*q_15_to_50)*MMRate_rewtd


	//Calculate confidence intervals for the age-adjusted death rates
	/*--------------------------------------------------------------------------
	NOTE: Extract scalars for ci calculation
	To avoid / reduce ambiguity between variables and scalars, use s for first
	letter of a scalar
	--------------------------------------------------------------------------*/
	scalar sDrate_men_rewtd=Drate_rewtd[1]
	scalar sDrate_women_rewtd=Drate_rewtd[2]
	scalar sPRMRate_rewtd=PRMRate_rewtd[2]
	scalar sMMRate_rewtd=MMRate_rewtd[2]
	scalar sGFR_rewtd=GFR_rewtd[2]
	scalar sPRMRatio=PRMRatio[2]
	scalar sMMRatio=MMRatio[2]

	calc_ci

	gen Drate_rewtd_L  =.
	gen Drate_rewtd_U  =.
	gen PRMRate_rewtd_L=.
	gen PRMRate_rewtd_U=.
	gen MMRate_rewtd_L =.
	gen MMRate_rewtd_U =.
	gen GFR_rewtd_L    =.
	gen GFR_rewtd_U    =.
	gen PRMRatio_L     =.
	gen PRMRatio_U     =.
	gen MMRatio_L      =.
	gen MMRatio_U      =.


	replace Drate_rewtd_L=sDrate_men_rewtd_L   if sex==1
	replace Drate_rewtd_U=sDrate_men_rewtd_U   if sex==1

	replace Drate_rewtd_L=sDrate_women_rewtd_L if sex==2
	replace Drate_rewtd_U=sDrate_women_rewtd_U if sex==2
	replace PRMRate_rewtd_L=sPRMRate_rewtd_L   if sex==2
	replace PRMRate_rewtd_U=sPRMRate_rewtd_U   if sex==2
	replace MMRate_rewtd_L=sMMRate_rewtd_L     if sex==2
	replace MMRate_rewtd_U=sMMRate_rewtd_U     if sex==2
	replace GFR_rewtd_L   =sGFR_rewtd_L        if sex==2
	replace GFR_rewtd_U   =sGFR_rewtd_U        if sex==2
	replace PRMRatio_L     =sPRMRatio_L        if sex==2
	replace PRMRatio_U     =sPRMRatio_U        if sex==2
	replace MMRatio_L     =sMMRatio_L          if sex==2
	replace MMRatio_U     =sMMRatio_U          if sex==2

	list sex lw uw unwtd_deaths unwtd_yexp wtd_deaths wtd_yexp Drate_rewtd* q_15_to_50, table clean
	list sex lw uw unwtd_prdeaths wtd_prdeaths prPMDF PRMRate_rewtd* GFR_rewtd* PRMRatio* prLTR* if sex==2, table clean
	list sex lw uw unwtd_mdeaths wtd_mdeaths mPMDF MMRate_rewtd* GFR_rewtd* MMRatio* mLTR* if sex==2, table clean

	*label define sex 1 "Men" 2 "Women"
	*label val sex sex
	
	export excel sex TFR MMRatio MMRatio_L MMRatio_U mLTR1 PRMRatio PRMRatio_L PRMRatio_U prLTR1 if sex==2 using  ///
	"AM_tables.xlsx", firstrow(variable) sheet("Maternal Mortality Ratio") sheetreplace
	putexcel set "AM_tables.xlsx", modify sheet("Maternal Mortality Ratio") 
	putexcel C1=("mmratio: Maternal mortality ratio. Multiply by 100000 to present per 100,000 live births") ///
	F1=("mLTR1: Lifetime risk of maternal mortality") ///
	G1=("prmratio: Pregnancy-related mortality ratio. Multiply by 100000 to present per 100,000 live births") ///
	J1=("prLTR1: Lifetime risk of pregnancy-related mortality")
	
	export excel refdate mean_doi sex q_15_to_50 lw uw using  ///
	"AM_tables.xlsx", firstrow(variable) sheet("Adult mortality probabilities") sheetreplace
	
	export excel using "AM_tables.xlsx", firstrow(variable) sheet("Mortality summary") sheetreplace
	putexcel set "AM_tables.xlsx", modify sheet("Mortality summary") 
	putexcel P1=("mx_adj: Age-adjusted adult mortality rate for 15-49. Multiply by 1000 to present per 1000 persons") ///
	Q1=("mpx_adj: Age-adjusted pregnancy-related mortality rate for women 15-49. Multiply by 1000 to present per 1000 women") ///
	R1=("mmx_adj: Age-adjusted maternal mortality rate for women 15-49. Multiply by 1000 to present per 1000 women") ///
	U1=("prmratio: Pregnancy-related mortality ratio. Multiply by 100000 to present per 100,000 live births") ///
	V1=("mmratio: Maternal mortality ratio. Multiply by 100000 to present per 100,000 live births") ///
	AA1=("prLTR1: Lifetime risk of pregnancy-related mortality") ///
	AB1=("mLTR1: Lifetime risk of maternal mortality")
		
save "Adult_Mortality.dta", replace

end
***************************************************************************

//create adult mortality rates
program define main_adult_mm_mortality

	//create local for country ID and version 
	scalar scid=substr(sfn_IR,1,2)
	scalar spv =substr(sfn_IR,5,2)

	local lpath_results=spath_results
	cd "`lpath_results'"

	//You can put "quietly" in front of any of these subroutine calls
	setup_adult_mm_vars
	sibship_size_and_sex_ratio
	completeness_of_information
	get_age_distributions
	*quietly get_exposure_and_deaths
	get_exposure_and_deaths
	calc_mortality_rates
	main_GFR_for_mm

	merge_files

	//optional--erase the working files

	erase completeness.dta
	erase births.dta
	erase exposure_and_deaths.dta
	erase exposure.dta
	erase exposure_and_births.dta
	erase adult_mm_vars.dta
	erase age_dist_f.dta
	erase age_dist_m.dta
	erase sex_age_dist.dta
	erase workfile.dta
	*erase micro.dta
	erase IR_all_women.dta

end







***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************

//EXECUTION BEGINS HERE

	/*--------------------------------------------------------------------------
	NOTE: 

	THIS IS WHERE YOU IDENTIFY THE PATHS, INPUT FILES, AND TIME INTERVAL FOR THE RATES.
	All paths and files are identified in the AMmain.do file for Chapter 16 on GitHub.

	Specify the interval or window for the rates with two scalars.
	When counting backwards, the month of interview is month 0 and is never included.
	The normal specification is for years 0-6 before the survey, i.e. 7 years.
	For this, set scalar lw=-6 and uw=0. "l" for lower, "u" for upper, "w" for window.
	The conversion to sibling-specific start_month and end_month is done in start_month_end_month.

	Include lines to give the paths to the IR and MR files for the surveys you want to use, as scalars.

	Keep these lines for examples....

	scalar lw=-6
	scalar uw=-0


	Factors of 1000 or 100,000 are not included in the output and numbers are not
	rounded.

	You can repeat any of the following specifications of the time interval, paths,
	and data files, followed by "main_adult_mm_mortality", for multiple runs on 
	the same file or different files. You do not need to re-specify a path, data
	file, or time interval if they would not change. Each set of specifications 
	will produce a different set of output files.

	--------------------------------------------------------------------------*/

//Specify the path to the log file and the output files and give a name to the log file.
scalar spath_results="$workingpath" 	//(this is set in the !AMmain.do)
local lpath_results=spath_results

//if you want to log results 
*log using "`lpath_results'\\DHS_AM_rates",replace

//Specify the time interval; modify lw and uw as needed							!!!CHANGE TIME INTERVAL HERE!!!
scalar lw=-6
scalar uw=-0

//Specify path(s) to the data files (these are set in the !AMmain.do)
scalar spath="$datapath"

//Specify the names of the data files (these are set in the !AMmain.do)
scalar sfn_IR="$irdata"
scalar sfn_MR="$mrdata"
scalar sfn_PR="$prdata"

//include a special scalar to identify surveys for which v023 is not the stratum variable
	scalar sv023_NA=1
	capture confirm numeric variable v023
	if _rc>0 {
	scalar sv023_NA=0
	  }

	/*--------------------------------------------------------------------------
	NOTE:
	The path and name of the PR file are only needed if the standard age distribution
	of men will come from the PR file rather than the MR file
	--------------------------------------------------------------------------*/


//Execute the program
main_adult_mm_mortality

	/*--------------------------------------------------------------------------
	NOTE:
	After this program has been run and the files have been saved you will find
	two excel workbooks. One labeled AM_tables.xlsx will have all mortality rates.
	The other is labeled AM_completeness and will have all completeness of sibling
	information.
	--------------------------------------------------------------------------*/
*log close

