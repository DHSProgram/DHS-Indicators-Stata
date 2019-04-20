/*****************************************************************************************************
Program: 			RH_ANC.do
Purpose: 			Code PNC indicators among women
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 21 2018 by Shireen Assaf 
*****************************************************************************************************/


*** PNC within 2 days of delivery for the most recent birth
	
** For surveys 2005 or after, postnatal care was asked for both institutional and non-institutional births. 
** surveys before 2005 only ask PNC for non-institutional births but assumed women received PNC if they delivered at health facilities	 
	* to check if survey has m51_1, which was in the surveys before 2005. 
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

	if m51_included==1 {
	* timing: 	* this code matches FR
	recode m51_1 (100/103= 1 "<4hr") (104/123 200= 2 "4-23hrs") (124/171 201/202=3 "1-2 days") (172/197 203/206=4 "3-6 days") (207/241 301/305=5 "7-41 days") (198/199 298/299 398/399 998/999=6 "dont know/missing") (242/297 306/397=7 "no pnc check") , g(rh_pnc_timing)
	replace rh_pnc_timing = 7 if m50_1==0 | m50_1==9
	replace rh_pnc_timing = 7 if (m52_1>29 & m52_1<97)  | m52_1==.
	replace rh_pnc_timing=. if age>=24 | bidx_01!=1  
	label var rh_pnc_timing "Timing after delivery for mother's PNC check"
	
	recode rh_pnc_timing (1/3= 1 "visit w/in 2 days") (4/7 = 0 "No Visit w/in 2 days"), g(rh_pnc_2days)
	label var rh_pnc_2days "PNC check within two days for mother"
	
	*provider type : not matching
	gen rh_pnc_pv = 0 if age<24 & bidx_01==1
	replace rh_pnc_pv=1 if m52_1 ==11 | m52_1==12
	replace rh_pnc_pv=2 if m52_1 ==13
	replace rh_pnc_pv=3 if m52_1 ==22
	replace rh_pnc_pv=4 if m52_1 >=14 & m52_1 <=19
	replace rh_pnc_pv=5 if m52_1 ==21
	replace rh_pnc_pv=. if age>=24 | bidx_01!=1  
	}
	
	
	****************************
	if m51_included==0{
	cap drop rh_pnc_timing
	
	* before discharge in a health facility
	recode m63_1 (100/103= 1 "<4hr") (104/123 200= 2 "4-23hrs") (124/171 201/202=3 "1-2 days") (172/197 203/206=4 "3-6 days") (207/241 300/305=5 "7-41 days") (198/199 298/299 398/399 998/999=6 "dont know/missing") (242/299 306/899=7 "no pnc check") , g(pnc1)
	replace pnc1 = 7 if m62_1==0 | m62_1==9
	replace pnc1 = 7 if (m64_1>29 & m64_1<97)  | m64_1==.
	replace pnc1=. if age>=24 | bidx_01!=1  
	
	* after discharge or at home
	recode m67_1 (100/103= 1 "<4hr") (104/123 200= 2 "4-23hrs") (124/171 201/202=3 "1-2 days") (172/197 203/206=4 "3-6 days") (207/241 301/305=5 "7-41 days") (198/199 298/299 398/399 998/999=6 "dont know/missing") (242/297 306/899=7 "no pnc check") , g(pnc2)
	replace pnc1 = 7 if m66_1==0 | m66_1==9
	replace pnc1 = 7 if (m68_1>29 & m68_1<97)  | m68_1==.
	replace pnc1=. if age>=24 | bidx_01!=1 

	gen rh_pnc_timing= 0 if v208>0
	replace rh_pnc_timing = pnc1
	replace rh_pnc_timing = pnc2 if (pnc1==. | pnc1==6 | pnc1==7) & (m62_1==1 | m66_1==1) & v208>0

	replace rh_pnc_timing=. if  age>=24 | bidx_01!=1
	label var rh_pnc_timing "Timing after delivery for mother's PNC check"
	
	recode rh_pnc_timing (1/3= 1 "visit w/in 2 days") (4/7 = 0 "No Visit w/in 2 days"), g(rh_pnc_2days)
	label var rh_pnc_2days "PNC check within two days for mother"
	
	* this is not matching (looked at Myanmar 2016 FR)
	* type of provider
	gen pncpv1=0 if age<24 & bidx_01==1
	replace pncpv1=1 if m64_1 ==11 | m64_1==12
	replace pncpv1=2 if m64_1 ==13
	replace pncpv1=3 if m64_1 ==22
	replace pncpv1=4 if m64_1 >=14 & m64_1 <=19
	replace pncpv1=5 if m64_1 ==21
	*replace pncpv1=0 if m62_1==0 | m62_1==9
	*replace pncpv1=. if age>=24 | bidx_01!=1  

	gen pncpv2=. if age<24 & bidx_01==1
	replace pncpv2=1 if m68_1 ==11 | m68_1==12
	replace pncpv2=2 if m68_1 ==13
	replace pncpv2=3 if m68_1 ==22
	replace pncpv2=4 if m68_1 >=14 & m64_1 <=19
	replace pncpv2=5 if m68_1 ==21
	*replace pncpv2=0 if m66_1==0 | m66_1==9
	*replace pncpv2=. if age>=24 | bidx_01!=1  
	
	*recode m64_1 (11/12=1 "doctor/nurse/midwife") (13=2 "aux. nurse/midwife") (22=3 "CHW") (14/19=4 "other HW") (21=5 "TBA"), gen(pncpv1)
	*replace pncpv1 = 0 if m62_1==0 | m62_1==9
	*replace pncpv1 = 0 if (m64_1>29 & m64_1<97)  | m64_1==.
	*replace pncpv1=. if age>=24 | bidx_01!=1  
	
	*recode m68_1 (11/12=1 "doctor/nurse/midwife") (13=2 "aux. nurse/midwife") (22=3 "CHW") (14/19=4 "other HW") (21=5 "TBA"), gen(pncpv2)
	*replace pncpv2 = 0 if m66_1==0 | m66_1==9
	*replace pncpv2 = 0 if (m68_1>29 & m68_1<97)  | m68_1==.
	*replace pncpv2=. if age>=24 | bidx_01!=1  
	
	gen rh_pnc_pv = 0 if age<24 & bidx_01==1
	replace rh_pnc_pv= pncpv1
	replace rh_pnc_pv = pncpv2 if (pncpv1==0) & v208>0	
	replace rh_pnc_pv=0 if m62_1==0 & m66_1==0
	*replace rh_pnc_pv=0 if rh_pnc_timing==7

	replace rh_pnc_pv=. if age>=24 | bidx_01!=1 

	
	}
	
	
	
	/*
		gen pnc1=0 if m62_1==1 
	replace pnc1=1 if (m63_1>=100 & m63_1 <=103) 
	replace pnc1=2 if (m63_1>=104 & m63_1<=123) |  m63_1==200
	replace pnc1=3 if (m63_1>=124 & m63_1<=171) |  m63_1==201 | m63_1==202
	replace pnc1=4 if (m63_1>=172 & m63_1<=197) | (m63_1>=203 & m63_1<=206)
	replace pnc1=5 if (m63_1>=207 & m63_1<=241) | (m63_1>=300 & m63_1<=305)
	replace pnc1=6 if  m63_1==198 | m63_1==199  |  m63_1==298 | m63_1==299 |  m63_1==398 | m63_1==399 |  m63_1==998 | m63_1==999 
	replace pnc1=. if m62_1!=1

	gen pnc2=0 if m66_1==1
	replace pnc2=1 if (m67_1>=100 & m67_1 <=103) 
	replace pnc2=2 if (m67_1>=104 & m67_1<=123) |  m67_1==200
	replace pnc2=3 if (m67_1>=124 & m67_1<=171) |  m67_1==201 | m67_1==202
	replace pnc2=4 if (m67_1>=172 & m67_1<=197) | (m67_1>=203 & m67_1<=206)
	replace pnc2=5 if (m67_1>=207 & m67_1<=241) | (m67_1>=300 & m67_1<=305)
	replace pnc2=6 if  m67_1==198 | m67_1==199  |  m67_1==298 | m67_1==299 |  m67_1==398 | m67_1==399 |  m67_1==998 | m67_1==999 
	replace pnc2=. if m66_1!=1

	gen pnc=0
	replace pnc=1 if pnc1==1 | pnc2==1
	replace pnc=2 if pnc1==2 | pnc2==2
	replace pnc=3 if pnc1==3 | pnc2==3
	replace pnc=4 if pnc1==4 | pnc2==4
	replace pnc=5 if pnc1==5 | pnc2==5
	replace pnc=6 if pnc1==6 | pnc2==6
	replace pnc=. if age>=24 | bidx_01!=1
	*/
