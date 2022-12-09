/*****************************************************************************************************
Program: 			RH_PNC.do - DHS8 update
Purpose: 			Code PNC indicators for women and newborns
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Lindsay Mallick and Shireen Assaf, DHS8 updates by Shireen Assaf
Date last modified: Dec 8, 2022 by Shireen Assaf 	
Notes:				Fourteen new indicators for DH8, see below. 
		
In DHS8 we use the NR file for computing these indicators. Previously the IR file was used. In addition the variable p19 is used instead of b19.
					
Also in DHS8, the DHS Final reports have three denominators for the Mother's PNC indicators: 1. recent livebirths only (m80==1), 2. recent stillbirths only (m80==3)
3. and recent livebirths + stillbirths. To tabulate the indicators for denominator 1 and 2, run the code below and use m80 to select for the denominator of interest (m80==1 for livebirths or m80=3 for stillbirths). To compute the indicators for denominator 3, tabulate the indicators with the condition (_n == 1 | caseid != caseid[_n-1]) which keeps if birth is last live birth or last still birth (see notes in main file). 

The Newborn PNC indicator are reporting only among the recent livebirths (m80==1)
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:
rh_pnc_wm_timing		"Timing after delivery for mother's PNC check"
rh_pnc_wm_2days 		"PNC check within two days for mother"
rh_pnc_wm_pv 			"Provider for mother's PNC check"

rh_pnc_nb_timing		"Timing after delivery for newborn's PNC check"
rh_pnc_nb_2days 		"PNC check within two days for newborn"
rh_pnc_nb_pv 			"Provider for newborn's PNC check"	

rh_pnc_wm_bldpres		"Blood pressure was taken during PNC check" - NEW Indicator in DHS8
rh_pnc_wm_askvagbleed	"Discussed vaginal bleeding during PNC check" - NEW Indicator in DHS8
rh_pnc_wm_fp			"Discussed family planning during PNC check" - NEW Indicator in DHS8
rh_pnc_wm_allchecks		"All three checks were made duirng PNC check" - NEW Indicator in DHS8

rh_pnc_nb_cord			"Examined cord during newborn PNC check" - NEW Indicator in DHS8
rh_pnc_nb_temp			"Measured temperature during newborn PNC check" - NEW Indicator in DHS8
rh_pnc_nb_dngr			"Mother told how to recognize if baby needs immediate medical attention during newborn PNC check" - NEW Indicator in DHS8
rh_pnc_nb_conslbf		"Mother counseled on breastfeeding during newborn PNC check" - NEW Indicator in DHS8
rh_pnc_nb_obsbf			"Observed breastfeeding during newborn PNC check" - NEW Indicator in DHS8
rh_pnc_nb_conslobsbf 	"Counseled and observed breastfeeding during newborn PNC check" - NEW Indicator in DHS8
rh_pnc_nb_weighed		"Weighed during newborn PNC check" - NEW Indicator in DHS8
rh_pnc_nb_5sigfunc		"Performed five or more signal postnatal care fucntions during newborn PNC check" - NEW Indicator in DHS8

rh_pnc_bothchecked		"Both mother and newborn received a PNC check" - NEW Indicator in DHS8
rh_pnc_bothnotchecked	"Neither mother nor newborn received a PNC check" - NEW Indicator in DHS8

/----------------------------------------------------------------------------*/
		
*** Mother's PNC ***

//PNC timing for mother		
	*did the mother have any check
	gen momcheck = 0 if p19<24 
	replace momcheck = 1 if (m62==1 | m66==1) & p19<24
	
	*create combined timing variable
	gen pnc_wm_time = 999 if (p19<24 & momcheck==1) 
	*start with women who delivered in a health facility with a check
	replace pnc_wm_time = m63 if inrange(m64,11,29) & p19<24 
	*Account for provider of PNC- country specific- see table footnotes
	replace pnc_wm_time = 0 if (pnc_wm_time < 1000 & m64 >30 & m64 < 100 & p19<24) 
	*Add in women who delivered at home with a check
	replace pnc_wm_time = m67 if  (pnc_wm_time == 999 & inrange(m68, 11,29) & p19<24) 
	*Account for provider of PNC- country specific- see table footnotes
	replace pnc_wm_time = 0 if m67 < 1000 & m68 >30 & m68 < 100 & p19<24 
	*Add in women who had no check 
	replace pnc_wm_time = 0 if momcheck == 0 & p19<24 
	
	*Recode variable into categories as in FR
	recode pnc_wm_time (0 242/299 306/899 = 0 "No check or past 41 days") ( 100/103 = 1 "<4hrs") (104/123 200 = 2 "4-23hrs") (124/171 201/202 = 3 "1-2days") ///
	(172/197 203/206 = 4 "3-6days") (207/241 301/305 = 5 "7-41days")  (else = 9 "Don't know/missing") if p19<24, gen(rh_pnc_wm_timing) 
	label var rh_pnc_wm_timing "Timing after delivery for mother's PNC check"

//PNC within 2days for mother	
	recode rh_pnc_wm_timing (1/3 = 1 "Within 2 days") (0 4 5 9 = 0 "Not in 2 days"), gen(rh_pnc_wm_2days) 
	label var rh_pnc_wm_2days "PNC check within two days for mother"
	
//PNC provider for mother	
** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
	*Providers of PNC for facility deliveries 
	recode m64 (0 = 0 "No check") (11/12 = 1 "Doctor/Nurse/Midwife") (13=2 "Auxiliary midwife") ( 22 = 3 "Other skilled provider") (21 = 4 "TBA") (23/99 = 9 "Other") , gen(pnc_wm_pv_hf)
	replace pnc_wm_pv_hf = 0 if rh_pnc_wm_2days==0 | m64==.
	
	*Providers of PNC for home deliveries or checks after discharge
	recode m68 (0 = 0 "No check") (11/12 = 1 "Doctor/Nurse/Midwife") (13=2 "Auxiliary midwife") ( 22 = 3 "Other skilled provider") (21 = 4 "TBA") (23/99 = 9 "Other") , gen(pnc_wm_pv_home)
	replace pnc_wm_pv_home = 0 if rh_pnc_wm_2days==0  | m68==.

	*Combine two PNC provider variables 	
	clonevar rh_pnc_wm_pv = pnc_wm_pv_hf 
	replace rh_pnc_wm_pv = pnc_wm_pv_home if (pnc_wm_pv_hf==0 & rh_pnc_wm_2days==1) 
	label var rh_pnc_wm_pv "Provider for mother's PNC check"
	
*** Components of PNC for mother ***

//Blood pressure taken - NEW Indicator in DHS8
gen rh_pnc_wm_bldpres = m78f ==1 
label values rh_pnc_wm_bldpres yesno
label var rh_pnc_wm_bldpres "Blood pressure was taken during PNC check"

//Discussed vaginal bleeding - NEW Indicator in DHS8 
gen rh_pnc_wm_askvagbleed= m78g ==1
label values rh_pnc_wm_askvagbleed yesno
label var rh_pnc_wm_askvagbleed "Discussed vaginal bleeding during PNC check"

//Discussed family planning - NEW Indicator in DHS8
gen rh_pnc_wm_fp= m78h ==1
label values rh_pnc_wm_fp yesno
label var rh_pnc_wm_fp "Discussed family planning during PNC check"

//All three checks - NEW Indicator in DHS8
gen rh_pnc_wm_allchecks = m78f==1 & m78g==1 & m78h==1
label values rh_pnc_wm_allchecks yesno
label var rh_pnc_wm_allchecks "All three checks were made duirng PNC check"

*** Newborn's PNC ***

	//PNC timing for newborn	
		
		*Newborn check
		gen nbcheck = 1 if (m70==1 | m74==1 )
		*create combined timing variable
		gen pnc_nb_timing_all = 999 if p19<24 & nbcheck==1 
		
		*start with women who delivered in a health facility with a check
		replace pnc_nb_timing_all = m75 if inrange(m76,11,29) & p19<24 
		*Account for provider of PNC- country specific- see table footnotes
		replace pnc_nb_timing_all = 0 if pnc_nb_timing_all < 1000 & m76 >30 & m76 < 100 & p19<24 
		
		*Add in women who delivered at home with a check
		replace pnc_nb_timing_all = m71 if (pnc_nb_timing_all==999 & inrange(m72,11,29) & p19<24)
		*Account for provider of PNC- country specific- see table footnotes
		replace pnc_nb_timing_all = 0 if (m71 < 1000 & m72 >30 & m72 < 100 & p19<24)
		*Add in women who had no check 
		replace pnc_nb_timing_all = 0 if (nbcheck!=1) & p19<24 
		
		*Recode variable into categories as in FR
		recode pnc_nb_timing_all (0 207/297 301/397 = 0 "No check or past 7 days") ( 100=1 "less than 1 hour") (101/103 =2 "1-3 hours") (104/123 200 = 3 "4 to 23 hours") (124/171 201/202 = 4 "1-2 days") ///
		 (172/197 203/206 = 5 "3-6 days new") (else = 9 "Don't know or missing") if m80==1 , gen (rh_pnc_nb_timing) 
		*label variable
		label var rh_pnc_nb_timing "Timing after delivery for mother's PNC check"

	//PNC within 2days for newborn	
		recode rh_pnc_nb_timing (1/4 = 1 "visit within 2 days") (0 5 9 = 0 "No Visit within 2 days"), g(rh_pnc_nb_2days)
		label var rh_pnc_nb_2days "PNC check within two days for newborn"

	//PNC provider for newborn
	** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
		
		*Providers of PNC for home deliveries or checks after discharge
		recode m72 (0 = 0 "No check") (11/12 = 1 "Doctor/Nurse/Midwife") (13=2 "Auxiliary midwife") ( 22 = 3 "Other skilled provider") (21 = 4 "TBA") (23/99 = 9 "Other"), gen(pnc_nb_pv_home)
		replace pnc_nb_pv_home = 0 if rh_pnc_nb_2days==0 | m72==.
		
		*Providers of PNC for facility deliveries 
		recode m76 (0 = 0 "No check") (11/12 = 1 "Doctor/Nurse/Midwife") (13=2 "Auxiliary midwife") ( 22 = 3 "Other skilled provider") (21 = 4 "TBA") (23/99 = 9 "Other"), gen(pnc_nb_pv_hf)
		replace pnc_nb_pv_hf = 0 if rh_pnc_nb_2days==0  | m76==.
		
		*Combine two PNC provider variables 	
		clonevar rh_pnc_nb_pv = pnc_nb_pv_hf 
		replace rh_pnc_nb_pv = pnc_nb_pv_home if (pnc_nb_pv_hf ==0 & rh_pnc_nb_2days ==1) 
		replace rh_pnc_nb_pv = . if m80!=1
		label var rh_pnc_nb_pv "Provider for newborns's PNC check"
			
*** Components of PNC for newborn ***
//Examined cord - NEW Indicator in DHS8
gen rh_pnc_nb_cord = m78a ==1
replace rh_pnc_nb_cord = . if m80!=1
label values rh_pnc_nb_cord yesno	
label var rh_pnc_nb_cord "Examined cord during newborn PNC check"

//Measured temperature - NEW Indicator in DHS8
gen rh_pnc_nb_temp = m78b ==1	
replace rh_pnc_nb_temp = . if m80!=1
label values rh_pnc_nb_temp yesno
label var rh_pnc_nb_temp "Measured temperature during newborn PNC check"

//Mother told how to recognize danger signs - NEW Indicator in DHS8
gen rh_pnc_nb_dngr = m78c ==1
replace rh_pnc_nb_dngr = . if m80!=1
label values rh_pnc_nb_dngr yesno
label var rh_pnc_nb_dngr "Mother told how to recognize if baby needs immediate medical attention during newborn PNC check"

//Mother counseled on breastfeeding - NEW Indicator in DHS8
gen rh_pnc_nb_conslbf = m78d ==1
replace rh_pnc_nb_conslbf = . if m80!=1
label values rh_pnc_nb_conslbf yesno
label var rh_pnc_nb_conslbf	"Mother counseled on breastfeeding during newborn PNC check"

//Mother observed breastfeeding - NEW Indicator in DHS8
gen rh_pnc_nb_obsbf = m78e ==1
replace rh_pnc_nb_obsbf = . if m80!=1
label values rh_pnc_nb_obsbf yesno
label var rh_pnc_nb_obsbf "Observed breastfeeding during newborn PNC check"

//Mother counseled and observed breastfeeding - NEW Indicator in DHS8
gen rh_pnc_nb_conslobsbf = m78d==1 & m78e==1 
replace rh_pnc_nb_conslobsbf = . if m80!=1
label value rh_pnc_nb_conslobsbf yesno
label var rh_pnc_nb_conslobsbf	"Counseled and observed breastfeeding during newborn PNC check"

//Newborn weighed - NEW Indicator in DHS8
gen rh_pnc_nb_weighed = m19a ==1 | m19a==2
replace rh_pnc_nb_weighed = . if m80!=1
label values rh_pnc_nb_weighed yesno
label var rh_pnc_nb_weighed	"Weighed during newborn PNC check"

//Received five or more signal postnatal care functions - NEW Indicator in DHS8
gen rh_pnc_nb_5sigfunc = rh_pnc_nb_cord==1 & rh_pnc_nb_temp==1 & rh_pnc_nb_dngr==1 & (rh_pnc_nb_conslbf==1 | rh_pnc_nb_obsbf==1) & rh_pnc_nb_weighed==1
replace rh_pnc_nb_5sigfunc = . if m80!=1
label values rh_pnc_nb_5sigfunc yesno
label var rh_pnc_nb_5sigfunc "Performed five or more signal postnatal care fucntions during newborn PNC check"

*** PNC of mother and newborn ***
//Both checked  - NEW Indicator in DHS8
gen rh_pnc_bothchecked = rh_pnc_wm_2days==1 & rh_pnc_nb_2days==1
replace rh_pnc_bothchecked=. if m80!=1
label values rh_pnc_bothchecked yesno
label var rh_pnc_bothchecked "Both mother and newborn received a PNC check"

//Neither checked  - NEW Indicator in DHS8
gen rh_pnc_bothnotchecked = rh_pnc_wm_2days==0 & rh_pnc_nb_2days==0
replace rh_pnc_bothnotchecked=. if m80!=1
label values rh_pnc_bothnotchecked yesno
label var rh_pnc_bothnotchecked	"Neither mother nor newborn received a PNC check"
