cd "C:\Users\LMallick\ICF\Analysis - Shared Resources\Data\DHSdata"

*foreach x in UGIR7AFL     
use ETIR70FL.dta, clear
use UGIR7AFL.dta, clear
use UGIR60FL.dta, clear

gen wt = v005/1000000

*create age in months for surveys that did not collect age in month data
capture confirm variable b19_01
	if _rc { // b19 does not exist, so create equivalent for old calculation method
		gen b19_01 = v008 - b3_01
		label variable b19_01 "Age of child in months or months since birth"
	}

*generate variable for birth in the last two years	
gen birth2 =0
replace birth2=1 if b19_01<24

********************************************************
**Mother's PNC
********************************************************
************************************
*for DHS7 surveys (and later?)
************************************
**If m51_1 exists in newer surveys, this next line of code won't work. 
capture confirm variable m51_1 // this may be m51a_1 in some countries; also m51_1 may have some observations in newer surveys
	if _rc  { // m64_1 does not exist, create a variable that you can use for both old and new surveys

*generate general variable for if they had a check at all or not
gen momcheck=0 if birth2 ==1 
replace momcheck =1 if (m62_1 ==1 |m66_1==1)  & birth2==1

***************************
*Women delivering in a health facility

*code timing of check if health facility delivery
recode m63_1 (242/299 306/899 = 0 "No check or past 41 days") ( 100/103 =1 "less than 4 hours") (104/123 200 = 2 "4 to 23 hours") (124/171 201/202 = 3 "1-2 days") ///
 (172/197 203/206 =4 "3-6 days new") (207/241 300/305 = 5 "7-41 days new")  (else  =9 "Don't know or missing") if birth2==1  , gen(mompnctimehf) 

*generate country specific variable for provider of PNC for facility deliveries
recode m64_1  (11/29 = 1 "Provider") (30/96 =0 "Non-skilled or other provider") (else = .)  if birth2==1, gen(mompncprovhf)

*If mother received PNC from a non-skilled provider, it is not considered PNC
	*This may be country specific
replace mompnctimehf = 0 if (mompncprovhf ==0 | momcheck==0 ) & birth2==1 

***************************
*Women delivering at home or if they had a check after discharge

*code timing of pnc if woman delivered at home or had a check after discharge 
recode m67_1 (242/299 306/899 = 0 "No check or past 41 days") ( 100/103 =1 "less than 4 hours") (104/123 200 = 2 "4 to 23 hours") (124/171 201/202 = 3 "1-2 days") ///
 (172/197 203/206 =4 "3-6 days new") (207/241 300/305 = 5 "7-41 days new")  (else  =9 "Don't know or missing")  if birth2==1  , gen (mompnctimehome) 

*generate country specific variable for provider of pnc
recode m68_1  (11/29 = 1 "Provider") (30/96 =0 "Non-skilled or other provider") (else = .)  if birth2==1, gen(mompncprovhome)

*If mother received PNC from a non-skilled provider, it is not considered PNC
	*This may be country specific
replace mompnctimehome = 0 if (mompncprovhome ==0  | momcheck==0 ) & birth2==1 

*combine two timing variables, starting with mothers who delivered in a health facility
gen mompnctime = 0 if birth2==1
replace mompnctime = mompnctimehf

*if they delivered at home or only got checked after discharge, add in those responses
replace mompnctime  = mompnctimehome if (mompnctimehf==. | mompnctimehf==9) & birth2==1 & momcheck ==1

*label values combined variable
label values mompnctime mompnctimehome 

*pnc by provider in 2 days
recode mompnctime (1/3 =1 "Within 2 days") (0 4 5 9 = 0 "Not in 2 days"), gen(mompnc2d) 

***************************
*For table on skilled provider for PNC for the mom
*Please refer to the table for country specific variations for providers of PNC for facility deliveries

recode m64_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
		( else = 9 "Don't know or missing") if birth2==1 & mompnc2d==1, gen(momskillpncprovhf)
	replace momskillpncprovhf = 0 if mompnc2d==0 & birth2==1

		
recode m68_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
		( else = 9 "Don't know or missing") if birth2==1 & mompnc2d==1 , gen(momskillpncprovhome)
	replace momskillpncprovhome = 0 if mompnc2d==0  & birth2==1

gen momskillpncprov = 0 if birth2==1 
replace momskillpncprov = momskillpncprovhf 
replace momskillpncprov = momskillpncprovhome if (momskillpncprovhf ==9) & (m62_1 ==0 | m62_1==. ) & mompnc2d ==1 & birth2 ==1 
label values momskillpncprov momskillpncprovhf
ta momskillpncprov [iw=wt]

}

************************************
*for surveys conducted prior to DHS7
************************************
*If m64_1 (new PNC for the mom variable) does not exist, create a variable that you can use for both old surveys 
capture confirm variable m64_1 
	if _rc  { 

*generate variable to create categories of timing of PNC for the mother
	*may be m51a_1
recode m51_1 (242/299 306/899 = 0 "No check or past 41 days") ( 100/103 =1 "less than 4 hours") (104/123 200= 2 "4 to 23 hours")  (124/171 201/202 = 3 "1-2 days") ///
 (172/197 203/206 =4 "3-6 days new") (207/241 300/305 = 5 "7-41 days new")  (else  =9 "Don't know or missing")  if birth2==1, gen(mompnctimeold)

*generate country specific variable for provider of PNC
recode m52_1 (11/29 = 1 "Provider") (else =0 "Non-skilled or other provider") if birth2==1 & m50_1 ==1, gen (mompncprovold)

*If mother received PNC from a non-skilled provider, it is not considered PNC
	*This may be country specific
replace mompnctimeold = 0 if (mompncprovold ==0 | m50_1==0 ) & birth2==1

*PNC by provider in 2 days
recode mompnctime (1/3 =1 "Within 2 days") (0 4 5 9 = 0 "Not in 2 days") if birth2==1, gen(mompnc2dold) 

*Rename old DHS variable to match new survey variables 
clonevar mompnctime = mompnctimeold
clonevar mompnc2d = mompnc2dold


*For table on provider of PNC
recode m52_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
		( else = 9 "Don't know or missing") if birth2==1 & mompnc2d==1, gen(momskillpncprov)
	replace momskillpncprov = 0 if mompnc2d==0 & birth2==1

}

label variable momskillpncprov "Provider of PNC in the first 2 days"
label variable mompnctime  "Timing of PNC for the mom"
label variable mompnc2d "PNC for the mom in 2 days"

tab mompnctime [iw=wt]
tab mompnc2d [iw=wt] 
ta momskillpncprov [iw=wt]

********************************************************
**Baby's PNC
********************************************************
*********************
*Old and new surveys use var m71, so PNC for baby calculation is different
************************
*Code timing of PNC either for all babies in older surveys or 
	*If woman delivered at home or had a check after discharge either regardless of health check before discharge
recode m71_1 (207/899 = 0 "No check or past 7 days") ( 100/103 =1 "less than 4 hours") (104/123 200 = 2 "4 to 23 hours") (124/171 201/202 = 3 "1-2 days") ///
 (172/197 203/206 = 4 "3-6 days new") (else = 9 "Don't know or missing") if birth2==1 , gen (babypnctimeall) 

*Provider of PNC- country specific
*May not match between rounds of surveys
recode m72_1 (11/29 = 1 "Skilled provider") (30/96 =0 "Non-skilled or other provider") (else = .)  if  birth2==1, gen (babypncprovall) 

*Recode babies with no check and babies with check by unskilled prov back to 0 
replace babypnctimeall = 0 if (babypncprovall ==0 | m70_1==0 ) & birth2==1 

*For table on provider of PNC -- this is country specific, please check table in final report
recode m72_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
		( else = 9 "Don't know or missing") if birth2==1 &babypnctimeall<4 & babypnctimeall>0, gen(babyskillpncprovall)
	replace babyskillpncprovall = 0 if babypnctimeall ==0 |  babypnctimeall == 4 | babypnctimeall == 9 & birth2==1

************************************
*for DHS7 surveys (and later?)
************************************
**If m51_1 exists in newer surveys, this next line of code won't work. 
capture confirm variable m51_1 // this may be m51a_1 in some countries; also m51_1 may have some observations in newer surveys
	if _rc  { // m64_1 does not exist, create a variable that you can use for both old and new surveys

*Generate general variable for if they had a check at all or not
gen babycheck=0 if birth2 ==1 
replace babycheck =1 if (m74_1 ==1 |m70_1==1)  & birth2==1

*Code timing of check if health facility delivery
recode m75_1 (207/899 = 0 "No check or past 7 days") ( 100/103 =1 "less than 4 hours") (104/123 200= 2 "4 to 23 hours") (124/171 201/202 = 3 "1-2 days") ///
 (172/197 203/206 = 4 "3-6 days new") (else = 9 "Don't know or missing") if birth2==1 , gen(babypnctimehf) 

*Provider of PNC- country specific
recode m76_1 (11/29 = 1 "Skilled provider") (30/96 =0 "Non-skilled or other provider") (else = .) if birth2==1,  gen (babypncprovhf) 

*Recode babies with no check and babies with check by unskilled prov back to 0 
replace babypnctimehf = 0 if (babypncprovhf ==0 | babycheck==0 ) & birth2==1 

/****IF PROVIDER CATEGORY IS DIFFERENT BETWEEN SURVEYS:
	*Create new provider variable 
	recode m72_1 (11/29 = 1 "Skilled provider") (30/96 =0 "Non-skilled or other provider") (else = .)  if  birth2==1, gen (babyskillprovhome) 

	*Recode babies with no check and babies with check by unskilled prov back to 0 
	replace babypnctimeall = 0 if (babyskillprovhome ==0 | m70_1==0 ) & birth2==1 
*/

*Combine two timing variables, starting with mothers who delivered in a health facility
gen babypnctime = 0 if birth2==1
replace babypnctime = babypnctimehf

*If they delivered at home or only got checked after discharge, add in those responses
replace babypnctime =  babypnctimeall if (babypnctimehf==0| babypnctimehf ==9) & birth2==1 & babycheck==1

*Label values combined variable
label values babypnctime babypnctimehf

*For table on provider of PNC -- this is country specific, please check table in final report
recode m76_1 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ///
		( else = 9 "Don't know or missing") if birth2==1 & (babypnctime == 1 | babypnctime == 2 | babypnctime == 3), gen(babyskillpncprovhf)
	replace babyskillpncprovhf = 0 if (babypnctime ==0 |  babypnctime == 4 | babypnctime == 9) & birth2==1

*Combine two PNC provider variables 	
gen babyskillpncprov = 0 if birth2==1 
replace babyskillpncprov = babyskillpncprovhf 
replace babyskillpncprov = babyskillpncprovall if (babyskillpncprovhf ==9) & (m62_1 ==0 | m62_1==. ) & (babypnctime == 1 | babypnctime == 2 | babypnctime == 3) & birth2 ==1 
label values babyskillpncprov babyskillpncprovhf
ta babyskillpncprov [iw=wt]
	
}

*Rename old DHS variable to match new survey variables 
cap clonevar babypnctime = babypnctimeall
cap clonevar babyskillpncprov = babyskillpncprovall

*pnc by provider in 2 days
recode babypnctime (1/3 =1 "Within 2 days") (0 4 5 9 = 0 "Not in 2 days"), gen(babypnc2d) 

label variable babyskillpncprov "Provider of PNC for the baby in the first 2 days"
label variable babypnctime  "Timing of PNC for the baby"
label variable babypnc2d "PNC for the baby in 2 days"

tab babyskillpncprov [iw=wt]
tab babypnctime [iw=wt]
tab babypnc2d [iw=wt] 

