/*****************************************************************************************************
Program: 			RH_DEL.do
Purpose: 			Code Delivery Care indicators
Data inputs: 		BR data files
Data outputs:		coded variables
Author:				Courtney Allen 
Date last modified: Jan 10 2018 by Courtney Allen 				
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

//Place of delivery
	recode m15 (20/39 = 1 "Health facility") (10/19 = 2 "Home") (40/98 = 3 "Other"), gen(rh_del_place)
	replace rh_del_place = . if age>=period
	label var rh_del_place "Live births by place of delivery"

//Place of delivery - by place type
	recode m15 (20/29 = 1 "Health facility - public") (30/39 = 2 "Health facility - private") (10/19 = 3 "Home")(40/98 = 4 "Other"), gen(rh_del_pltype)
	replace rh_del_pltype = . if age>=period
	label var rh_del_pltype "Live births by type of health facility"

//Assistance during delivery
	gen rh_del_pv = 0 if m3a != .
	replace rh_del_pv 	= 7 	if m3n == 1
	replace rh_del_pv 	= 6 	if m3i == 1 | m3j == 1 | m3k == 1 | m3l == 1 | m3m == 1
	replace rh_del_pv 	= 5 	if m3h == 1
	replace rh_del_pv 	= 4 	if m3g == 1 
	replace rh_del_pv 	= 3 	if m3c == 1 | m3d == 1 | m3e == 1 | m3f == 1 
	replace rh_del_pv 	= 2 	if m3b == 1
	replace rh_del_pv 	= 1 	if m3a == 1
	replace rh_del_pv	= .		if age>=period
	
	label define pv 			///
	1 "Doctor" 					///
	2 "Nurse/midwife"			///
	3 "Country specific health professional" ///
	4 "Traditional birth attendant"	///
	5 "Other health worker"		///
	6 "Relative/other"			///
	7 "No one"
	label val rh_del_pv pv
	label var rh_del_pv "Person providing assistance during delivery"

//Skilled provider during delivery
	recode rh_del_pv (1/2 = 1 "Skilled provider") (3/6 = 2 "Unskilled provider") (7 = 3 "No one"), gen(rh_del_pvskill)
	replace rh_del_pvskill = . if age>=period
	label var rh_del_pvskill "Skilled assistance during delivery"
	
//Caesarean delivery
	gen rh_del_ces = 0
	replace rh_del_ces = 1 if m17==1
	replace rh_del_ces = . if age>=period
	label define rh_del_ceslab 0 "Vaginal birth" 1 "Caesarean section"
	label val rh_del_ces rh_del_ceslab
	label var rh_del_ces "Live births delivered by Caesarean"
	
//Timing of decision for caesarean
	gen rh_del_cestime = 0
	cap confirm m17a
	if _rc==0 {  //some surveys did not ask this question, confirm m17a exists
		replace rh_del_cestime = m17a if m17a!=.
		replace rh_del_cestime = . if age>=period 
		label define cestimelab 0 "Vaginal Birth" 1 "before labor started" 2 "after labor started"
		label val rh_del_cestime cestimelab
		label var rh_del_cestime "Timing of decision to have Caesarean"*/
		}
//Timing of decision for caesarean
	recode m61 (0/105 = 1 "<6 hours") (106/111 = 2 "6-11 hours") (112/123 = 3 "12-23 hours") ///
	(124/171 201/202 = 4 "1-2 days") (172/199 203/399= 5 "3+ days") (998 = 6 "don't know"), gen(rh_del_stay)
	replace rh_del_stay = . if rh_del_place!=1 | bidx!=1 | age>=period
	label var rh_del_stay "Duration of stay following recent birth"
	
	
