/*****************************************************************************************************
Program: 			RH_ANC.do
Purpose: 			Code ANC indicators
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Sept 19, 2023 by Shireen Assaf 
Notes: 				Choose reference period to select last 2 years or last 5 years.
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:
rh_anc_pv			"Person providing assistance during ANC"
rh_anc_pvskill		"Skilled assistance during ANC"
rh_anc_numvs		"Number of ANC visits"
rh_anc_4vs			"Attended 4+ ANC visits"
rh_anc_moprg		"Attended ANC <4 months of pregnancy"
rh_anc_median		"Median months pregnant at first visit" (scalar not a variable)
rh_anc_iron			"Took iron tablet/syrup during the pregnancy of last birth"
rh_anc_parast		"Took intestinal parasite drugs during pregnancy of last birth"
rh_anc_prgcomp		"Informed of pregnancy complications during ANC visit"
rh_anc_bldpres		"Blood pressure was taken during ANC visit"
rh_anc_urine		"Urine sample was taken during ANC visit"
rh_anc_bldsamp		"Blood sample was taken during ANC visit"
rh_anc_toxinj		"Received 2+ tetanus injections during last pregnancy"
rh_anc_neotet		"Protected against neonatal tetanus"
/----------------------------------------------------------------------------*/

 * Choose reference period, last 2 years or last 5 years
	*gen period = 24
	gen period = 60

*	Child's age in months	
	gen age = v008 - b3_01
	
	* to check if survey has b19, which should be used instead to compute age. 
	scalar b19_included=1
		capture confirm numeric variable b19_01, exact 
		if _rc>0 {
		* b19 is not present
		scalar b19_included=0
		}
		if _rc==0 {
		* b19 is present; check for values
		summarize b19_01
		  if r(sd)==0 | r(sd)==. {
		  scalar b19_included=0
		  }
		}

	if b19_included==1 {
	drop age
	gen age=b19_01
	}
	
cap label define yesno 0"no" 1"yes"
	
*** ANC visit indicators ***

//ANC by type of provider
** Note: Please check the final report for this indicator to determine the categories and adjust the code and label accordingly. 
	gen rh_anc_pv = 6 if m2a_1! = .
	replace rh_anc_pv 	= 4 	if m2f_1 == 1 | m2g_1 == 1 | m2h_1 == 1 | m2i_1 == 1 | m2j_1 == 1 | m2k_1 == 1 | m2l_1 == 1 | m2m_1 == 1
	replace rh_anc_pv 	= 3 	if m2c_1 == 1 | m2d_1 == 1 | m2e_1 == 1
	replace rh_anc_pv 	= 2 	if m2b_1 == 1
	replace rh_anc_pv 	= 1 	if m2a_1 == 1
	replace rh_anc_pv 	= 9 	if m2a_1 == 9
	replace rh_anc_pv	= .		if age>=period
	
	label define rh_anc_pv ///
	1 "Doctor" 		///
	2 "Nurse/midwife"	///
	3 "Other health worker" ///
	4 "TBA/other/relative"		///
	9 "Missing" ///
	6 "No ANC" 
	label val rh_anc_pv rh_anc_pv
	label var rh_anc_pv "Person providing assistance during ANC"
	
//ANC by skilled provider
** Note: Please check the final report for this indicator to determine what provider is considered skilled.
	recode rh_anc_pv (1/2 = 1 "Skilled provider") (3/9 = 0 "Unskilled/no one") , gen(rh_anc_pvskill)
	replace rh_anc_pvskill = . if age>=period
	label var rh_anc_pvskill "Skilled assistance during ANC"	
	
//Number of ANC visits in 4 categories that match the table in the final report
	recode m14_1 (0=0 "none") (1=1) (2 3=2 "2-3") (4/90=3 "4+") (else=9 "don't know/missing"), gen(rh_anc_numvs)
	replace rh_anc_numvs=. if age>=period  
	label var rh_anc_numvs "Number of ANC visits"
		
//4+ ANC visits  
	recode rh_anc_numvs (1 2 9=0 "no") (3=1 "yes"), gen(rh_anc_4vs)
	lab var rh_anc_4vs "Attended 4+ ANC visits"
	
//Number of months pregnant at time of first ANC visit 
	recode m13_1 (.=0 "no anc") (0/3=1 "<4") (4 5=2 "4-5") (6 7=3 "6-7") (8/90=4 "8+") (else=9 "don't know/missing"), gen(rh_anc_moprg)
	replace rh_anc_moprg=. if age>=period  
	label var rh_anc_moprg "Number of months pregnant at time of first ANC visit"

//ANC before 4 months
	recode rh_anc_moprg (0 2/5 9=0 "no") (1=1 "yes"), gen(rh_anc_4mo)
	lab var rh_anc_4mo "Attended ANC <4 months of pregnancy"

//Median number of months pregnant at time of 1st ANC
	
	* Any ANC visits (for denominator)
	recode m14_1 (0 99 = 0 "None") (1/60 98 = 1 "1+ ANC visit"), g(ancany)
	
	recode m13_1 (98 99=.), gen(anctiming)
		
	* Total
	summarize anctiming [fweight=v005], detail
	* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 if ancany==1
	replace dummy=1 if anctiming<sp50 & ancany==1
	summarize dummy [fweight=v005]
	scalar sL=r(mean)
	drop dummy
	
	gen dummy=. 
	replace dummy=0 if ancany==1
	replace dummy=1 if anctiming <=sp50 & ancany==1
	summarize dummy [fweight=v005]
	scalar sU=r(mean)
	drop dummy

	gen rh_anc_median=round(sp50+(.5-sL)/(sU-sL),.01)
	label var rh_anc_median "Total- Median months pregnant at first visit"
	
	* Urban
	summarize anctiming if v025==1 [fweight=v005], detail
	* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 if ancany==1 & v025==1 
	replace dummy=1 if anctiming<sp50 & ancany==1 & v025==1 
	summarize dummy [fweight=v005]
	scalar sL=r(mean)

	replace dummy=. 
	replace dummy=0 if ancany==1 & v025==1 
	replace dummy=1 if anctiming <=sp50 & ancany==1 & v025==1 
	summarize dummy [fweight=v005]
	scalar sU=r(mean)
	drop dummy

	gen rh_anc_median_urban=round(sp50+(.5-sL)/(sU-sL),.01)
	label var rh_anc_median_urban "Urban- Median months pregnant at first visit"
	
	* Rural
	summarize anctiming if v025==2 [fweight=v005], detail
	* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 if ancany==1  & v025==2 
	replace dummy=1 if anctiming<sp50 & ancany==1  & v025==2 
	summarize dummy [fweight=v005]
	scalar sL=r(mean)

	replace dummy=. 
	replace dummy=0 if ancany==1  & v025==2 
	replace dummy=1 if anctiming <=sp50 & ancany==1  & v025==2 
	summarize dummy [fweight=v005]
	scalar sU=r(mean)
	drop dummy

	gen rh_anc_median_rural=round(sp50+(.5-sL)/(sU-sL),.01)
	label var rh_anc_median_rural "Rural- Median months pregnant at first visit"
	
	
*** ANC components ***	
//Took iron tablets or syrup
	recode m45_1 (1=1 "yes") (else=0 "No") if v208>0, gen(rh_anc_iron)
	replace rh_anc_iron=. if age>=period  
	label var rh_anc_iron "Took iron tablet/syrup during pregnancy of last birth"
	
//Took intestinal parasite drugs 
	cap recode m60_1 (1=1 "yes") (else=0 "No") if v208>0, gen(rh_anc_parast)
	cap replace rh_anc_parast=. if age>=period  
	cap label var rh_anc_parast "Took intestinal parasite drugs during pregnancy of last birth"
	* for surveys that do not have this variable
	cap gen rh_anc_parast=.
	
* Among women who had ANC for their most recent birth	

//Informed of pregnancy complications
	gen rh_anc_prgcomp = 0 if ancany==1
	replace rh_anc_prgcomp = 1 if m43_1==1 & ancany==1
	label values rh_anc_prgcomp yesno
	label var rh_anc_prgcomp "Informed of pregnancy complications during ANC visit"
	
//Blood pressure measured
	gen rh_anc_bldpres = 0 if ancany==1
	replace rh_anc_bldpres=1 if m42c_1==1 & ancany==1
	label values rh_anc_bldpres yesno
	label var rh_anc_bldpres "Blood pressure was taken during ANC visit"
	
//Urine sample taken
	gen rh_anc_urine = 0 if ancany==1
	replace rh_anc_urine=1 if m42d_1==1 & ancany==1
	label values rh_anc_urine yesno
	label var rh_anc_urine "Urine sample was taken during ANC visit"
	
//Blood sample taken
	gen rh_anc_bldsamp = 0 if ancany==1
	replace rh_anc_bldsamp = 1 if m42e_1==1 & ancany==1
	label values rh_anc_bldsamp yesno
	label var rh_anc_bldsamp "Blood sample was taken during ANC visit"
	
//tetnaus toxoid injections
	recode m1_1 (0 1 8 9 . = 0 "No") (2/7 = 1 "Yes"), gen(rh_anc_toxinj)
	replace rh_anc_toxinj = . if age>=period
	label var rh_anc_toxinj "Received 2+ tetanus injections during last pregnancy"
	
//neonatal tetanus
	* this was copied from the DHS user forum. Code was prepared by Lindsay Mallick.
	
	*older surverys do not have this indicator. m1a_1 (number of tetanus injections before pregnancy) is needed to compute this indicator
	scalar m1a_1_included=1
		capture confirm numeric variable m1a_1, exact 
		if _rc>0 {
		* b19 is not present
		scalar m1a_1_included=0
		}
		if _rc==0 {
		* b19 is present; check for values
		summarize m1a_1
		  if r(sd)==0 | r(sd)==. {
		  scalar m1a_1_included=0
		  }
		}
		
* for surveys that have this indicator
if m1a_1_included==1 {	
	gen tet2lastp = 0 
    replace tet2lastp = 1 if m1_1 >1 & m1_1<8
	
	* temporary vars needed to compute the indicator
	gen totet = 0 
	gen ttprotect = 0 				   
	replace totet = m1_1 if (m1_1>0 & m1_1<8)
	replace totet = m1a_1 + totet if (m1a_1 > 0 & m1a_1 < 8)
				   
	*now generating variable for date of last injection - will be 0 for women with at least 1 injection at last pregnancy
	g lastinj = 9999
	replace lastinj = 0 if (m1_1>0 & m1_1 <8)
	gen int ageyr = (age)/12 
	replace lastinj = (m1d_1 - ageyr) if m1d_1 <20 & (m1_1==0 | (m1_1>7 & m1_1<9996)) // years ago of last shot - (age at of child), yields some negatives

	*now generate summary variable for protection against neonatal tetanus 
	replace ttprotect = 1 if tet2lastp ==1 
	replace ttprotect = 1 if totet>=2 &  lastinj<=2 //at least 2 shots in last 3 years
	replace ttprotect = 1 if totet>=3 &  lastinj<=4 //at least 3 shots in last 5 years
	replace ttprotect = 1 if totet>=4 &  lastinj<=9 //at least 4 shots in last 10 years
	replace ttprotect = 1 if totet>=5  //at least 2 shots in lifetime
	lab var ttprotect "Full neonatal tetanus Protection"
				   
	gen rh_anc_neotet = ttprotect
	replace rh_anc_neotet = . if  bidx_01!=1 | age>=period 
	label var rh_anc_neotet "Protected against neonatal tetanus"
	
	}

*for surveys that do not have this indicator, generate indicator as missing value. 
if m1a_1_included==0 {	
gen rh_anc_neotet=.
}

************************************************************************
	