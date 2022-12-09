/*****************************************************************************************************
Program: 			RH_ANC.do - DHS8 update
Purpose: 			Code ANC indicators
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 2, 2022 by Shireen Assaf 

Notes:	Nine new indicators for DH8, see below. 

In DHS8 we use the NR file for computing these indicators. Previously the IR file was used. 
					
In DHS8 the indicators are reported for the 24 of 2 years before the survey. In addition the variable p19 is used instead of b19.
Perviously ANC indicators were reported for the 5 years before the survey and used the varaible b19 for child's age. 
					
Also in DHS8, the DHS Final reports have three denominators for the indicators: 1. recent livebirths only (m80==1), 2. recent stillbirths only (m80==3)
3. and recent livebirths + stillbirths. To tabulate the indicators for denominator 1 and 2, run the code below and use m80 to select for the denominator of interest (m80==1 for livebirths or m80=3 for stillbirths). To compute the indicators for denominator 3, tabulate the indicators with the condition (_n == 1 | caseid != caseid[_n-1]) which keeps if birth is last live birth or last still birth (see notes in main file). 

In addition, for the ANC components, the tabulations can also be performed among all women with the above three denominators, or among women that have attended at least one ANC visit (ancany==1) with the above three denominators. Therefore, for the ANC components indicators there are six different denominators reported in the DHS Final report. 
										
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:
rh_anc_pv				"Person providing assistance during ANC"
rh_anc_pvskill			"Skilled assistance during ANC"
rh_anc_numvs			"Number of ANC visits"
rh_anc_4vs				"Attended 4+ ANC visits"
rh_anc_moprg			"Attended ANC <4 months of pregnancy"
rh_anc_median			"Median months pregnant at first visit - among live births + stillbirths" (scalar not a variable)
rh_anc_median_liveb		"Median months pregnant at first visit - among live births" (scalar not a variable) - NEW Indicator in DHS8
rh_anc_median_stillb	"Median months pregnant at first visit - among stillbirths" (scalar not a variable) - NEW Indicator in DHS8

rh_anc_bldpres			"Blood pressure was taken during ANC visit"
rh_anc_urine			"Urine sample was taken during ANC visit"
rh_anc_bldsamp			"Blood sample was taken during ANC visit"
rh_anc_heartbt			"Baby's heartbeat was listened for during ANC visit" - NEW Indicator in DHS8
rh_anc_consldiet		"Counseled about maternal diet during ANC visit" - NEW Indicator in DHS8
rh_anc_conslbf			"Counseled about breastfeeding during ANC visit" - NEW Indicator in DHS8
rh_anc_askvagbleed		"Asked about vaginal bleeding during ANC visit" - NEW Indicator in DHS8
rh_anc_iron				"Took iron tablet/syrup during most recent pregnancy"
rh_anc_parast			"Took intestinal parasite drugs most recent pregnancy"
rh_anc_foodcash			"Took food or cash assistance during most recent pregnancy" - NEW Indicator in DHS8
rh_anc_daysiron			"Number of days took iron-containing supplements during most recent pregnancy"  - NEW Indicator in DHS8
rh_anc_ironpl_(a-x)		"Place where iron-continaining supplements where obtained: xx" - "NEW Indicator in DHS8 
						* This is a country specific variable which depends on the number of sources available. 
						* The code will produce a vairable for each source in the survey from a to x"

rh_anc_toxinj			"Received 2+ tetanus injections during last pregnancy"
rh_anc_neotet			"Protected against neonatal tetanus"
/----------------------------------------------------------------------------*/

*** ANC visit indicators ***

//ANC by type of provider
** Note: Please check the final report for this indicator to determine the categories and adjust the code and labels accordingly. 
	gen rh_anc_pv = 8 if m2a! = . 
	replace rh_anc_pv 	= 8 	if m2n == 1 
	replace rh_anc_pv 	= 7 	if m2i == 1 | m2j == 1 | m2k == 1 | m2l == 1 | m2m == 1
	replace rh_anc_pv 	= 6 	if m2g == 1 
	replace rh_anc_pv 	= 5 	if m2d == 1 | m2e == 1 | m2f == 1 
	replace rh_anc_pv 	= 4 	if m2h == 1 
	replace rh_anc_pv 	= 3 	if m2c == 1 
	replace rh_anc_pv 	= 2 	if m2b == 1
	replace rh_anc_pv 	= 1 	if m2a == 1
	replace rh_anc_pv 	= 9 	if m2a == 9
	label define rh_anc_pv ///
	1 "Doctor" 		///
	2 "Nurse/midwife"	///
	3 "Auxiliary midwife" ///
	4 "Community health worker/fieldworker" ///
	5 "Other Health worker" ///
	6 "TBA"		///
	7 "Other, not health professional" ///
	8 "No ANC" ///
	9 "Missing"
	label val rh_anc_pv rh_anc_pv
	label var rh_anc_pv "Person providing assistance during ANC"
	
//ANC by skilled provider
** Note: Please check the final report for this indicator to determine what provider is considered skilled.
	recode rh_anc_pv (1/3 = 1 "Skilled provider") (4/9 = 0 "Unskilled/no one") , gen(rh_anc_pvskill)
	label var rh_anc_pvskill "Skilled assistance during ANC"	
	
//Number of ANC visits in the categories that match the table in the final report
	recode m14 (0=0 "None") (1=1) (2=2 "2") (3=3 "3") (4/7=4 " 4-7") (8/90=5 "8+") (else=9 "don't know/missing"), gen(rh_anc_numvs)
	label var rh_anc_numvs "Number of ANC visits"
		
//4+ ANC visits  
	recode m14 (1/3 98/99=0 "No") (4/90=1 "Yes"), gen(rh_anc_4vs)
	lab var rh_anc_4vs "Attended 4+ ANC visits"
	
//Number of months pregnant at time of first ANC visit 
	recode m13 (.=0 "No ANC") (0/3=1 " <4") (4/6=2 " 4-6") (7/90=4 "7+") (else=9 "don't know/missing"), gen(rh_anc_moprg)
	label var rh_anc_moprg "Number of months pregnant at time of first ANC visit"

//Median number of months pregnant at time of 1st ANC
	
	* Any ANC visits (for denominator used in below indicators) 
	recode m14 (0 99 = 0 "None") (1/60 98 = 1 "1+ ANC visit"), g(ancany)
	
	recode m13 (98 99=.), gen(anctiming)
		
	* Total
	summarize anctiming if _n == 1 | caseid != caseid[_n-1] [fweight=v005], detail
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
	label var rh_anc_median "Median months pregnant at first visit - among live births + stillbirths"
	
	* Live births
	summarize anctiming if m80==1 [fweight=v005], detail
	* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 if ancany==1 & m80==1 
	replace dummy=1 if anctiming<sp50 & ancany==1 & m80==1 
	summarize dummy [fweight=v005]
	scalar sL=r(mean)

	replace dummy=. 
	replace dummy=0 if ancany==1 & m80==1 
	replace dummy=1 if anctiming <=sp50 & ancany==1 & m80==1 
	summarize dummy [fweight=v005]
	scalar sU=r(mean)
	drop dummy

	gen rh_anc_median_liveb=round(sp50+(.5-sL)/(sU-sL),.01)
	label var rh_anc_median_liveb "Median months pregnant at first visit - among live births"
	
	* Stillbirths
	summarize anctiming if m80==3 [fweight=v005], detail
	* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 if ancany==1  & m80==3 
	replace dummy=1 if anctiming<sp50 & ancany==1  & m80==3 
	summarize dummy [fweight=v005]
	scalar sL=r(mean)

	replace dummy=. 
	replace dummy=0 if ancany==1  & m80==3  
	replace dummy=1 if anctiming <=sp50 & ancany==1  & m80==3 
	summarize dummy [fweight=v005]
	scalar sU=r(mean)
	drop dummy

	gen rh_anc_median_stillb=round(sp50+(.5-sL)/(sU-sL),.01)
	label var rh_anc_median_stillb "Median months pregnant at first visit - among stillbirths"
	
	
*** ANC components ***	
* The indicators below can be tabulated among women who had at least one ANC visit (if ancany==1) or among all women. 
* This is in addition to the three denominators discussed in the notes at the top of this do file: 1. livebirths, 2. stillbirths, 3. livebirths + stillbirths
* For example, if you want to tabulate the blood pressure measure indicator among women who attended at least one ANC visit and among women with a livebirth, you run the following: tab rh_anc_bldpres if m80==1 & ancany==1 [iw=wt]	

* Among women who had ANC for their most recent birth	

//Blood pressure measured
	gen rh_anc_bldpres = m42c==1
	label values rh_anc_bldpres yesno
	label var rh_anc_bldpres "Blood pressure was taken during ANC visit"
	
//Urine sample taken
	gen rh_anc_urine = m42d==1
	label values rh_anc_urine yesno
	label var rh_anc_urine "Urine sample was taken during ANC visit"
	
//Blood sample taken
	gen rh_anc_bldsamp = m42e==1 
	label values rh_anc_bldsamp yesno
	label var rh_anc_bldsamp "Blood sample was taken during ANC visit"

//Baby's heartbeat was listened for - NEW Indicator in DHS8
	gen rh_anc_heartbt = m42f==1
	label values rh_anc_heartbt yesno
	label var rh_anc_heartbt "Baby's heartbeat was listened for during ANC visit" 
	
//Counseled about maternal diet - NEW Indicator in DHS8
	gen rh_anc_consldiet = m42g==1
	label values rh_anc_consldiet yesno
	label var rh_anc_consldiet "Counseled about maternal diet during ANC visit" 
	
//Counseled about breastfeeding - NEW Indicator in DHS8
	gen rh_anc_conslbf = m42h==1
	label values rh_anc_conslbf yesno
	label var rh_anc_conslbf "Counseled about breastfeeding during ANC visit" 

// Asked about vaginal bleeding - NEW Indicator in DHS8
	gen rh_anc_askvagbleed = m42i==1
	label values rh_anc_askvagbleed yesno
	label var rh_anc_askvagbleed "Asked about vaginal bleeding during ANC visit" 
		
//Took iron tablets or syrup
	gen rh_anc_iron= m45==1
	label values rh_anc_iron yesno
	label var rh_anc_iron "Took iron tablet/syrup during most recent pregnancy"
	
//Took intestinal parasite drugs 
	cap gen rh_anc_parast= m60==1 
	label values rh_anc_parast yesno
	cap label var rh_anc_parast "Took intestinal parasite drugs during most recent pregnancy"
	* for surveys that do not have this variable
	cap gen rh_anc_parast=.

//Took food or cash assistance - NEW Indicator in DHS8
	gen rh_anc_foodcash= m82==1
	label values rh_anc_foodcash yesno
	label var rh_anc_foodcash "Took food or cash assistance during most recent pregnancy" 

//Number of days took iron-containing supplements - NEW Indicator in DHS8
	recode m46 (. 0=0 "None") (1/59=1 " <60") (60/89=2 " 60-89") (90/179=3 " 90-179") (180/990=4 "180+") (998/999=5 "Don't know"), gen(rh_anc_daysiron)
	label var rh_anc_daysiron "Number of days took iron-containing supplements during most recent pregnancy"  

//Place obtained iron pills
* these are country specific and some of the variables below may have missing values if the source is not reported for the survey. 
	foreach z in a b c d e f g h i j k l m n o p q r na nb nc nd ne s t u v w x {
		gen rh_anc_ironpl_`z' = m81`z'==1 if m45==1
		local labz: variable label m81`z'
		label var rh_anc_ironpl_`z' "`labz'"
	}
	
//tetnaus toxoid injections
	recode m1 (0 1 8 9 . = 0 "No") (2/7 = 1 "Yes"), gen(rh_anc_toxinj)
	replace rh_anc_toxinj = . if !(p19<24 & m80==1)
	label var rh_anc_toxinj "Received 2+ tetanus injections during last pregnancy"
	
//neonatal tetanus	
	gen tet2lastp = 0 
    replace tet2lastp = 1 if m1 >1 & m1<8
	
	* temporary vars needed to compute the indicator
	gen totet = 0 
	gen rh_anc_neotet = 0 				   
	replace totet = m1 if (m1>0 & m1<8)
	replace totet = m1a + totet if (m1a > 0 & m1a < 8)
				   
	*now generating variable for date of last injection - will be 0 for women with at least 1 injection at last pregnancy
	g lastinj = 9999
	replace lastinj = 0 if (m1>0 & m1 <8)
	gen int p19yr = (p19)/12 
	replace lastinj = (m1d - p19yr) if m1d <20 & (m1==0 | (m1>7 & m1<9996)) // years ago of last shot - (p19 at of child), yields some negatives

	*now generate summary variable for protection against neonatal tetanus 
	replace rh_anc_neotet = 1 if tet2lastp ==1 
	replace rh_anc_neotet = 1 if totet>=2 &  lastinj<=2 //at least 2 shots in last 3 years
	replace rh_anc_neotet = 1 if totet>=3 &  lastinj<=4 //at least 3 shots in last 5 years
	replace rh_anc_neotet = 1 if totet>=4 &  lastinj<=9 //at least 4 shots in last 10 years
	replace rh_anc_neotet = 1 if totet>=5  //at least 2 shots in lifetime
	lab var rh_anc_neotet "Full neonatal tetanus Protection"
	replace rh_anc_neotet = . if  !(p19<24 & m80==1)
	label var rh_anc_neotet "Protected against neonatal tetanus"
	