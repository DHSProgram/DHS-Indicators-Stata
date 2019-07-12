/*****************************************************************************************************
Program: 			RH_ANC.do
Purpose: 			Code PNC indicators for women and newborns
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Lindsay Mallick and Shireen Assaf
Date last modified: March 12 2019 by Shireen Assaf 
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:
rh_pnc_wm_timing	"Timing after delivery for mother's PNC check"
rh_pnc_wm_2days 	"PNC check within two days for mother"
rh_pnc_wm_pv 		"Provider for mother's PNC check"

rh_pnc_nb_timing	"Timing after delivery for newborn's PNC check"
rh_pnc_nb_2days 	"PNC check within two days for newborn"
rh_pnc_nb_pv 		"Provider for newborn's PNC check"	
/----------------------------------------------------------------------------*/
		
** For surveys 2005 or after, postnatal care was asked for both institutional and non-institutional births. 
** surveys before 2005 only ask PNC for non-institutional births but assumed women received PNC if they delivered at health facilities	 
** This is checked using variable m51_1 which was used in older surveys
** For some surveys it was m51a_1 not m51_1
	scalar drop _all
	*cap gen m51_1=m51a_1

** To check if survey has m51_1, which was in the surveys before 2005. 

	scalar m51_included=1
		capture confirm numeric variable m51_1, exact 
		if _rc>0 {
		* m51_1 is not present
		scalar m51_included=0
		}
		if _rc==0 {
		* m51_1 is present; check for values
		summarize m51_1
		  if r(sd)==0 | r(sd)==. {
		  scalar m51_included=0
		  }
		}
		
*** Mother's PNC ***		
		
if m51_included==1 {
cap drop ta

//PNC timing for mother	
	recode m51_1 (100/103 = 1 "<4hr") (104/123 200 = 2 "4-23hrs") (124/171 201/202 = 3 "1-2 days") ///
	(172/197 203/206 = 4 "3-6 days") (207/241 301/305=5 "7-41 days") ///
	(198/199 298/299 398/399 998/999 = 9 "dont know/missing") (242/297 306/397 = 0 "no pnc check") , g(rh_pnc_wm_timing)
	replace rh_pnc_wm_timing = 0 if m50_1==0 | m50_1==9
	replace rh_pnc_wm_timing = 0 if (m52_1>29 & m52_1<97) | m52_1==.
	replace rh_pnc_wm_timing=. if age>=24 | bidx_01!=1  
	label var rh_pnc_wm_timing "Timing after delivery for mother's PNC check"

//PNC within 2days for mother	
	recode rh_pnc_wm_timing (1/3= 1 "visit w/in 2 days") (0 4 5 9  = 0 "No Visit w/in 2 days"), g(rh_pnc_wm_2days)
	label var rh_pnc_wm_2days "PNC check within two days for mother"
	
//PNC provider for mother	
** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
	recode m52_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
		( else = 9 "Don't know or missing") if age<24 & rh_pnc_wm_2days==1, gen(rh_pnc_wm_pv)
	replace rh_pnc_wm_pv = 0 if rh_pnc_wm_2days==0 & age<24
	label var rh_pnc_wm_pv "Provider for mother's PNC check"
}
	
if m51_included==0 {
cap drop rh_pnc_wm_timing

//PNC timing for mother		
	*did the mother have any check
	gen momcheck = 0 if age<24 
	replace momcheck = 1 if (m62_1==1 | m66_1==1) & age<24
	
	*create combined timing variable
	gen pnc_wm_time = 999 if (age<24 & momcheck==1) 
	*start with women who delivered in a health facility with a check
	replace pnc_wm_time = m63_1 if inrange(m64_1,11,29) & age<24 
	*Account for provider of PNC- country specific- see table footnotes
	replace pnc_wm_time = 0 if (pnc_wm_time < 1000 & m64_1 >30 & m64_1 < 100 & age<24) 
	*Add in women who delivered at home with a check
	replace pnc_wm_time = m67_1 if  (pnc_wm_time == 999 & inrange(m68_1, 11,29) & age<24) 
	*Account for provider of PNC- country specific- see table footnotes
	replace pnc_wm_time = 0 if m67_1 < 1000 & m68_1 >30 & m68_1 < 100 & age<24 
	*Add in women who had no check 
	replace pnc_wm_time = 0 if momcheck == 0 & age<24 
	
	*Recode variable into categories as in FR
	recode pnc_wm_time (0 242/299 306/899 = 0 "No check or past 41 days") ( 100/103 = 1 "less than 4 hours") (104/123 200 = 2 "4 to 23 hours") (124/171 201/202 = 3 "1-2 days") ///
	(172/197 203/206 = 4 "3-6 days") (207/241 300/305 = 5 "7-41 days")  (else = 9 "Don't know or missing") if age<24, gen(rh_pnc_wm_timing) 
	*label variable
	label var rh_pnc_wm_timing "Timing after delivery for mother's PNC check"

//PNC within 2days for mother	
	recode rh_pnc_wm_timing (1/3 = 1 "Within 2 days") (0 4 5 9 = 0 "Not in 2 days"), gen(rh_pnc_wm_2days) 
	label var rh_pnc_wm_2days "PNC check within two days for mother"
	
//PNC provider for mother	
** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
	
	*Providers of PNC for facility deliveries 
	recode m64_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
	( else = 9 "Don't know or missing") if age<24 & rh_pnc_wm_2days==1, gen(pnc_wm_pv_hf)
	replace pnc_wm_pv_hf = 0 if rh_pnc_wm_2days==0 & age<24
	
	*Providers of PNC for home deliveries or checks after discharge
	recode m68_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
	( else = 9 "Don't know or missing") if age<24 & rh_pnc_wm_2days==1 , gen(pnc_wm_pv_home)
	replace pnc_wm_pv_home = 0 if rh_pnc_wm_2days==0  & age<24

	*Combine two PNC provider variables 	
	clonevar rh_pnc_wm_pv = pnc_wm_pv_hf 
	replace rh_pnc_wm_pv = pnc_wm_pv_home if (pnc_wm_pv_hf==9 & rh_pnc_wm_2days==1 & age<24) 
	*label variable
	label var rh_pnc_wm_pv "Provider for mother's PNC check"
}



*** Newborn's PNC ***

* some surveys (usally older surveys) do not have PNC indicators for newborns. For this you would need variables m70_1, m71_1, ..., m76_1
scalar m70s_included=1
forvalues i=1/6 {
		capture confirm numeric variable m7`i'_1, exact 
		if _rc>0 {
		scalar m70s_included=0
		}
		if _rc==0 {
		summarize m7`i'_1
		  if r(sd)==0 | r(sd)==. {
		  scalar m70s_included=0
		  }
		}
}

*survey has newborn PNC indicators
if m70s_included==1 {
	
	if m51_included==1 {
			
	//PNC timing for newborn
		recode m71_1 (207/297 301/397 = 0 "No check or past 7 days") ( 100 = 1 "less than 1 hour") (101/103 = 2 "1-3 hours") (104/123 200 = 3 "4 to 23 hours") (124/171 201/202 = 4 "1-2 days") ///
		 (172/197 203/206 = 5 "3-6 days new") (198/199 298/299 398/399 998/999 = 9 "dont know/missing") if age<24 , gen(rh_pnc_nb_timing) 
		 
		*Recode babies with no check and babies with check by unskilled prov back to 0 
		 replace rh_pnc_nb_timing = 0 if (m70_1==0 | m70_1==9)
		*Account for provider of PNC- country specific- see table footnotes
		replace rh_pnc_nb_timing = 0 if (m72_1>29 & m72_1<97) | m72_1==.
		replace rh_pnc_nb_timing = . if age>=24 | bidx_01!=1  
		 
		*label variable
		label var rh_pnc_nb_timing "Timing after delivery for newborn's PNC check"

	//PNC within 2days for newborn	
		recode rh_pnc_nb_timing (1/4 = 1 "Visit within 2 days") (0 5 9 = 0 "No Visit within 2 days"), g(rh_pnc_nb_2days)
		*label variable	
		label var rh_pnc_nb_2days "PNC check within two days for newborn"

	//PNC provider for newborn
	** this is country specific, please check table in final report
		recode m72_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
				( 98/99 = 9 "Don't know or missing") if age<24 & rh_pnc_nb_timing<9 & rh_pnc_nb_timing>0, gen(rh_pnc_nb_pv)
		replace rh_pnc_nb_pv = 0 if rh_pnc_nb_2days ==0 & age<24
		label var rh_pnc_nb_pv "Provider for newborn's PNC check"
		
	}

	if m51_included==0 {

	//PNC timing for newborn	
		
		*Newborn check
		gen nbcheck = 1 if (m70_1==1 | m74_1==1 )
		*create combined timing variable
		gen pnc_nb_timing_all = 999 if age<24 & nbcheck==1 
		
		*start with women who delivered in a health facility with a check
		replace pnc_nb_timing_all = m75_1 if inrange(m76_1,11,29) & age<24 
		*Account for provider of PNC- country specific- see table footnotes
		replace pnc_nb_timing_all = 0 if pnc_nb_timing_all < 1000 & m76_1 >30 & m76_1 < 100 & age<24 
		
		*Add in women who delivered at home with a check
		replace pnc_nb_timing_all = m71_1 if (pnc_nb_timing_all==999 & inrange(m72_1,11,29) & age<24)
		*Account for provider of PNC- country specific- see table footnotes
		replace pnc_nb_timing_all = 0 if (m71_1 < 1000 & m72_1 >30 & m72_1 < 100 & age<24)
		*Add in women who had no check 
		replace pnc_nb_timing_all = 0 if (nbcheck!=1) & age<24 
		
		*Recode variable into categories as in FR
		recode pnc_nb_timing_all (0 207/297 301/397 = 0 "No check or past 7 days") ( 100=1 "less than 1 hour") (101/103 =2 "1-3 hours") (104/123 200 = 3 "4 to 23 hours") (124/171 201/202 = 4 "1-2 days") ///
		 (172/197 203/206 = 5 "3-6 days new") (else = 9 "Don't know or missing") if age<24 , gen (rh_pnc_nb_timing) 
		*label variable
		label var rh_pnc_nb_timing "Timing after delivery for mother's PNC check"

	//PNC within 2days for newborn	
		recode rh_pnc_nb_timing (1/4 = 1 "visit within 2 days") (0 5 9 = 0 "No Visit within 2 days"), g(rh_pnc_nb_2days)
		label var rh_pnc_nb_2days "PNC check within two days for newborn"

	//PNC provider for newborn
	** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
		
		*Providers of PNC for home deliveries or checks after discharge
		recode m72_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
		( else = 9 "Don't know or missing") if age<24 & rh_pnc_nb_2days==1, gen(pnc_nb_pv_home)
		replace pnc_nb_pv_home = 0 if rh_pnc_nb_2days==0 & age<24
		
		*Providers of PNC for facility deliveries 
		recode m76_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
		( else = 9 "Don't know or missing") if age<24 & rh_pnc_nb_2days==1 , gen(pnc_nb_pv_hf)
		replace pnc_nb_pv_hf = 0 if rh_pnc_nb_2days==0  & age<24
		
		*Combine two PNC provider variables 	
		clonevar rh_pnc_nb_pv = pnc_nb_pv_hf 
		replace rh_pnc_nb_pv = pnc_nb_pv_home if (pnc_nb_pv_hf ==9) &  rh_pnc_nb_2days ==1 & age<24 
		*label variable
		label var rh_pnc_nb_pv "Provider for newborns's PNC check"
		
	}
}

*survey does not have newborn PNC indicators
if m70s_included==0 {
* replace indicators as missing
gen rh_pnc_nb_timing = .
gen rh_pnc_nb_2days = . 	
gen rh_pnc_nb_pv = . 
}

	
	
