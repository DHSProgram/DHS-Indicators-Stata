/*****************************************************************************************************
Program: 			CM_PMR.do
Purpose: 			Code to compute perinatal mortality 
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Trevor Croft
Date last modified: October 26 2020 by Trevor Croft
Notes:				Any background variable you would like to disaggregate the perinatal mortality by needs to be added to line 19.
					A file "CM_PMRdata.dta" will be produced that can be used to export the results. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
cm_peri		"Perinatal mortality rate"
----------------------------------------------------------------------------*/

* open IR dataset
* drop or add variables from this list as needed
use caseid v001 v002 v003 v005 v008 v011 v013 v017 v018 v021 v022 v023 v024 v025 v106 v190 v231 v242 b3* vcal_1 ///
  using "$datapath//$irdata.dta", clear

* drop any case without a birth or termination in the calendar, just to speed up the code
keep if strpos(vcal_1,"B") | strpos(vcal_1,"T")

rename b3_0* b3_*
* find the last pregnancy reported before the calendar - needed for calculation of pregnancy interval
gen befcal = 0
forvalues i = 1/20 {
  replace befcal = b3_`i' if befcal == 0 & b3_`i' < v017
}
replace befcal = v231 if v231 != . & v231 > befcal & v231 < v017
replace befcal = v242 if v242 != . & v242 > befcal & v242 < v017
* drop variables no longer needed before reshape
drop b3* v231 v242

* loop through all positions in the calendar and turn them into variables
forvalues i = 1/80 {
  gen cmc`i' = v017 + 80 - `i'
  gen type`i' = .
  replace type`i' = 1 if substr(vcal_1,`i',1) == "B"
  replace type`i' = 3 if substr(vcal_1,`i',1) == "T"
  replace type`i' = 2 if substr(vcal_1,`i',7) == "TPPPPPP" 
}

* The reshape is really really really slow if you don't select variables and cases first, and will most likely fail otherwise.
reshape long cmc type, i(caseid) j(i)

lab def type 1 "Birth" 2 "Stillbirth" 3 "Miscarriage/abortion"
lab val type type
lab var type "Type of pregnancy"
lab var cmc  "Century month code of event"

* Set length of calendar to use
gen callen = v018 + 59
* If calendar is aligned right (as in original dataset), use the following:
gen beg = v018
gen end = callen
* If calendar is aligned left (as it is in some datasets), use the following:
*gen beg = 1
*gen end = 60

* Include only the five year period, and keep only births and stillbirths
keep if i >= beg & i <= end & (type == 1 | type == 2)

* calculate the pregnancy interval
* find the first position before the pregnancy (when it is not a "P")
gen     j = 0
replace j = indexnot(substr(vcal_1,i+1,80-i),"P") if inlist(type,1,2,3)
replace j = i + j if j > 0

* find last pregnancy before the current one - births first, then terminated pregnancies
gen lb = strpos(substr(vcal_1,j,80-j+1),"B") if j > 0
gen lp = strpos(substr(vcal_1,j,80-j+1),"T") if j > 0
* if the last birth was after the last terminated pregnancy, then use the birth
replace lp = lb if j > 0 & (lp == 0 | (lb > 0 & lb < lp))
* correct the offset of lp 
replace lp = lp + j - 1 if j > 0 & lp > 0
  
* calculate the pregnancy interval if there was a birth or pregnancy in the calendar before the current one (only if type is 1,2,3)
gen pregint = lp - j if inlist(type,1,2,3) & lp != . & lp != 0
* calculate the pregnancy interval if there was a birth or pregnancy before the calendar (but not in the calendar) and before the current pregnancy (only if type is 1,2,3)
gen k = 0
* adjust to exclude the length of the pregnancy - not currently used in DHS
*replace k = j - i if j > 0 
replace pregint = cmc - k - befcal if inlist(type,1,2,3) & (lp == 0 | lp == .) & befcal != 0
lab var pregint "Pregnancy interval"
* end of calculation of the pregnancy interval

* sort by case identifiers and century month code of pregnancy end
sort v001 v002 v003 cmc
* save this file
save "CM_PMRdata.dta", replace

* merge in birth history variables

* Open birth history
use "$datapath//$brdata.dta", clear

keep v001 v002 v003 b*

* Sort according to ID and CMC of birth
clonevar cmc = b3
sort v001 v002 v003 cmc
save "births.dta", replace

* Reopen the pregnancies files and merge in the twins
use "CM_PMRdata.dta",clear
merge 1:m v001 v002 v003 cmc using "births.dta", keep(master match) keepusing(b*)
* drop a few mismatches between calendar and birth history to match table
drop if type==1 & bidx==.

gen stillbirths = type==2
gen earlyneonatal = (type==1 & b6>=100 & b6<= 106)

* Perinatal mortality
gen cm_peri = 1000*(type==2 | (type==1 & b6>=100 & b6<= 106))

* code background variables

* mother's age at birth (years): <20, 20-29, 30-39, 40-49 
gen months_age=cmc-v011
recode months_age (0/239 = 1 "< 20") (240/359 = 2 "20-29") (360/479 = 3 "30-39") (480/600 = 4 "40-49"), gen(mo_age_at_birth)
lab var mo_age_at_birth "Mother's age at birth"
drop months_age
*tab mo_age_at_birth [iw=v005/1000000]

* recode pregnancy interval into groups
recode pregint (. = 1 "First pregnancy") (0/14 = 2 "< 15") (15/26 = 3 "15-26") (27/38 = 4 "27-38") (39/9999 = 5 "39 or more"), gen(preg_interval)
lab var preg_interval "Previous pregnancy interval in months"
*tab preg_interval [iw=v005/1000000] 

* save data to use for tables
save "CM_PMRdata.dta", replace

erase births.dta

*Tabulate perinatal mortality
*tab type [iw=v005/1000000]
*tab stillbirths [iw=v005/1000000]
*tab earlyneonatal [iw=v005/1000000]
*tab cm_peri [iw=v005/1000000]

*summ cm_peri [iw=v005/1000000]
