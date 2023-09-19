/*****************************************************************************************************
Program: 			RH_DEL.do
Purpose: 			Code Delivery Care indicators
Data inputs: 		BR dataset
Data outputs:		coded variables
Author:				Courtney Allen 
Date last modified: July 9 2018 by Shireen Assaf to adding missing categories and fix an error in the rh_del_cestime indicator 	
					September 19, 2023 by Shireen Assaf to add period and child age variables. 
Notes:				Choose reference period to select last 2 years or last 5 years.
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:
rh_del_place		"Live births by place of delivery"
rh_del_pltype		"Live births by type of place"
rh_del_pv			"Person providing assistance during birth"
rh_del_pvskill		"Skilled provider providing assistance during birth"
rh_del_ces			"Live births delivered by cesarean"
rh_del_cestime		"Timing of decision to have Cesarean"
rh_del_stay			"Duration of stay following recent birth"
/----------------------------------------------------------------------------*/

 * Choose reference period, last 2 years or last 5 years
	*gen period = 24
	gen period = 60

*	Child's age in months	
	gen age = v008 - b3
	
	* to check if survey has b19, which should be used instead to compute age. 
	scalar b19_included=1
		capture confirm numeric variable b19, exact 
		if _rc>0 {
		* b19 is not present
		scalar b19_included=0
		}
		if _rc==0 {
		* b19 is present; check for values
		summarize b19
		  if r(sd)==0 | r(sd)==. {
		  scalar b19_included=0
		  }
		}

	if b19_included==1 {
	drop age
	gen age=b19
	}
	
cap label define yesno 0"no" 1"yes"
	
*** Delivery indicators ***	
	
//Place of delivery
	recode m15 (20/39 = 1 "Health facility") (10/19 = 2 "Home") (40/98 = 3 "Other") (99=9 "Missing"), gen(rh_del_place)
	replace rh_del_place = . if age>=period
	label var rh_del_place "Live births by place of delivery"

//Place of delivery - by place type
	recode m15 (20/29 = 1 "Health facility - public") (30/39 = 2 "Health facility - private") (10/19 = 3 "Home")(40/98 = 4 "Other") (99=9 "Missing"), gen(rh_del_pltype)
	replace rh_del_pltype = . if age>=period
	label var rh_del_pltype "Live births by type of health facility"

//Assistance during delivery
**Note: Assistance during delivery and skilled provider indicators are both country specific indicators. 
**The table for these indicators in the final report would need to be checked to confirm the code below.
	gen rh_del_pv = 9 
	replace rh_del_pv 	= 6 	if m3n == 1
	replace rh_del_pv 	= 5 	if m3h == 1 | m3i == 1 | m3j == 1 | m3k == 1 | m3l == 1 | m3m == 1
	replace rh_del_pv 	= 4 	if m3g == 1 
	replace rh_del_pv 	= 3 	if m3c == 1 | m3d == 1 | m3e == 1 | m3f == 1 
	replace rh_del_pv 	= 2 	if m3b == 1
	replace rh_del_pv 	= 1 	if m3a == 1
	replace rh_del_pv 	= 9 	if m3a == 8 | m3a == 9
	replace rh_del_pv	= .		if age>=period
	
	label define pv 			///
	1 "Doctor" 					///
	2 "Nurse/midwife"			///
	3 "Country specific health professional" ///
	4 "Traditional birth attendant"	///
	5 "Relative/other"			///
	6 "No one"					///
	9 "Don't know/missing"
	label val rh_del_pv pv
	label var rh_del_pv "Person providing assistance during delivery"

//Skilled provider during delivery
** Note: Please check the final report for this indicator to determine what provider is considered skilled.
	recode rh_del_pv (1/2 = 1 "Skilled provider") (3/5 = 2 "Unskilled provider") (6 = 3 "No one") (9=4 "Don't know/missing"), gen(rh_del_pvskill)
	replace rh_del_pvskill = . if age>=period
	label var rh_del_pvskill "Skilled assistance during delivery"
	
//Caesarean delivery
	gen rh_del_ces = 0
	replace rh_del_ces = 1 if m17==1
	replace rh_del_ces = . if age>=period
	label define rh_del_ceslab 0 "No" 1 "Yes"
	label val rh_del_ces rh_del_ceslab
	label var rh_del_ces "Live births delivered by Caesarean"
	
//Timing of decision for caesarean
	gen rh_del_cestime = 0
	cap confirm numeric variable m17a, exact
	*some surveys did not ask this question, confirm m17a exists
	if _rc==0 {  
		replace rh_del_cestime = m17a if m17a!=.
		replace rh_del_cestime = . if age>=period 
		label define cestimelab 0 "Vaginal Birth" 1 "before labor started" 2 "after labor started"
		label val rh_del_cestime cestimelab
		label var rh_del_cestime "Timing of decision to have Caesarean"
		}
//Duration of stay following recent birth
	recode m61 (0/105 = 1 "<6 hours") (106/111 = 2 "6-11 hours") (112/123 200= 3 "12-23 hours") ///
	(124/171 201/202 = 4 "1-2 days") (172/197 203/297 301/397= 5 "3+ days") (198 199 298 299 398 399 998 999= 9 "Don't know/Missing") (else= 9), gen(rh_del_stay)
	replace rh_del_stay = . if rh_del_place!=1 | bidx!=1 | age>=period | m61==.
	label var rh_del_stay "Duration of stay following recent birth"
	
	
