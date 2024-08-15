/*****************************************************************************************************
Program: 			RH_DEL.do - DHS8 update
Purpose: 			Code Delivery Care indicators
Data inputs: 		BR dataset
Data outputs:		coded variables
Author:				Courtney Allen, DHS8 updates by Shireen Assaf
Date last modified: Aug 15, 2024 by Ali Roghani	

In DHS8 we use the NR file for computing these indicators. Previously the BR file was used. 
					
In DHS8 the indicators are reported for the 24 of 2 years before the survey. In addition the variable p19 is used instead of b19.
Perviously delivery indicators were reported for the 5 years before the survey and used the varaible b19 for child's age. 
					
Also in DHS8, the DHS Final reports have three denominators for the indicators: 1. livebirths (recent and prior) (m80==1 | m80==2), 2. stillbirths (recent and prior) (m80==3 | m80==4)
3. and livebirths + stillbirths (m80 values from 1 to 4). To tabulate the indicators for denominator 1 and 2, run the code below and use m80 to select for the denominator of interest (m80<3 for livebirths or m80>2 for stillbirths). To compute the indicators for denominator 3, tabulate the indicators as is. Note that observations where m80==5 were dropped in the main file. 

The skin-to-skin indicator is reported among most recent births/stillbirths.
	
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:
rh_del_place		"Live births by place of delivery"
rh_del_pltype		"Live births by type of place"
rh_del_pv			"Person providing assistance during birth"
rh_del_pvskill		"Skilled provider providing assistance during birth"
rh_del_skin			"Births with skin-to-skin contact immediately after birth"
rh_del_ces			"Births delivered by cesarean"
rh_del_cestime		"Timing of decision to have Cesarean"
rh_del_stay			"Duration of stay following recent birth"
/----------------------------------------------------------------------------*/

//Place of delivery
	recode m15 (20/49 = 1 "Health facility") (10/19 9/99= 0 "Home/other"), gen(rh_del_place)
	label var rh_del_place "Live births by place of delivery"

//Place of delivery - by place type
	recode m15 (20/29 = 1 "Health facility - public") (30/39 = 2 "Health facility - private non-NGO") (41/46=3 "Health facility - private NGO") (10/19 = 4 "Home")(96/98 = 5 "Other") (99=9 "Missing"), gen(rh_del_pltype)
	label var rh_del_pltype "Live births by type of health facility"

//Assistance during delivery
**Note: Assistance during delivery and skilled provider indicators are both country specific indicators. 
**The table for these indicators in the final report would need to be checked to confirm the code below.
	gen rh_del_pv = 8
	replace rh_del_pv 	= 7 	if m3i == 1 | m3j == 1 | m3k == 1 | m3l == 1 | m3m == 1
	replace rh_del_pv 	= 6 	if m3g == 1
	replace rh_del_pv 	= 5 	if m3d == 1 | m3e == 1 | m3f == 1  
	replace rh_del_pv 	= 4 	if m3h == 1 
	replace rh_del_pv 	= 3 	if m3c == 1
	replace rh_del_pv 	= 2 	if m3b == 1
	replace rh_del_pv 	= 1 	if m3a == 1
	replace rh_del_pv 	= 9 	if m3a == 9
	label define pv 			///
	1 "Doctor" 		///
	2 "Nurse/midwife"	///
	3 "Auxiliary midwife" ///
	4 "Community health worker/fieldworker" ///
	5 "Other Health worker" ///
	6 "TBA"		///
	7 "Other, not health professional" ///
	8 "No one" ///
	9 "Missing"
	label val rh_del_pv pv
	label var rh_del_pv "Person providing assistance during delivery"
	
//Skilled provider during delivery
** Note: Please check the final report for this indicator to determine what provider is considered skilled.
	recode rh_del_pv (1/3 = 1 "Skilled provider") (4/9 = 0 "Unskilled provider/ No one") , gen(rh_del_pvskill)
	label var rh_del_pvskill "Skilled assistance during delivery"

//Births with skin-to-skin contact immediately after birth
	gen rh_del_skin = m77a==0
	label values rh_del_skin yesno
	label var rh_del_skin "Births with skin-to-skin contact immediately after birth"
	
//Caesarean delivery
	gen rh_del_ces = m17==1
	label values rh_del_ces yesno
	label var rh_del_ces "Births delivered by Caesarean"
	
//Timing of decision for caesarean
	gen rh_del_cestime = m17a if m17a!=.
	label define cestimelab 0 "Vaginal Birth" 1 "before labor started" 2 "after labor started"
	label val rh_del_cestime cestimelab
	label var rh_del_cestime "Timing of decision to have Caesarean"	
		
//Duration of stay following recent birth  (this is tabulated by m17, type of delivery)
	recode m61 (0/105 = 1 "<6 hours") (106/111 = 2 "6-11 hours") (112/123 200= 3 "12-23 hours") ///
	(124/171 201/202 = 4 "1-2 days") (172/197 203/297 301/397= 5 "3+ days") (198 199 298 299 398 399 998 999= 9 "Don't know/Missing") (else= 9), gen(rh_del_stay)
	replace rh_del_stay = . if rh_del_place!=1 | m61==.
	label var rh_del_stay "Duration of stay following recent birth"
	
	
