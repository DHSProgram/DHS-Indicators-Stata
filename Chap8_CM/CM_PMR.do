/*****************************************************************************************************
Program: 			CM_PMR.do
Purpose: 			Code to compute perinatal mortality 
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Trevor Croft
Date last modified: April 19 2019 by Shireen Assaf 
Note:				Any background variable you would like to disaggregate the perinatal mortality by needs to be added to line 19.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
cm_peri		"Perinatal mortality rate"
----------------------------------------------------------------------------*/

gen pregs = 0

forvalues i = 1/80 {
  gen cmc`i' = v017 + 80 - `i'
  gen event`i' = substr(vcal_1, `i', 1)
  gen type`i' = .
  replace type`i' = 1 if substr(vcal_1,`i',1) == "B"
  replace type`i' = 3 if substr(vcal_1,`i',1) == "T"
  replace type`i' = 2 if substr(vcal_1,`i',7) == "TPPPPPP" 
  replace pregs = pregs+1 if (substr(vcal_1,`i',1) == "B" | substr(vcal_1,`i',1) == "T")
}
* Drop cases with no pregnancies
drop if pregs == 0

* Decide what variables you want to keep first before the reshape, modify this list as you need to add extra variables.
keep caseid v001 v002 v003 v005 v008 v011 v013 v017 v018 v019 v021 v022 v023 v024 v025 v106 v190 cmc* event* type* 

* The reshape is really really really slow if you don't select variables and cases first, and will most likely fail otherwise.
reshape long cmc event type, i(caseid) j(ix)

lab def type 1 "Birth" 2 "Stillbirth" 3 "Miscarriage/abortion"
lab val type type
lab var type "Type of pregnancy"
lab var cmc "Century month code of event"
lab var event "Calendar event code"

* Set length of calendar to use
gen callen = v018 + 59
* If calendar is aligned right (as in original dataset), use the following:
gen beg = v018
gen end = callen
* If calendar is aligned left (as it is in some datasets), use the following:
*gen beg = 1
*gen end = 60

* Include only the five year period
keep if ix >= beg & ix <= end

* check the pregnancy types 
tab type [iw=v005/1000000]

* Note that this will not match the 5086 pregnancies of 7+ months as that includes twins.
* This file excludes twins, but i believe that is what you really need.

* keep only births and stillbirths
keep if type == 1 | type == 2

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

tab type [iw=v005/1000000]

gen stillbirths = type==2
gen earlyneonatal = (type==1 & b6>=100 & b6<= 106)

* Perinatal mortality
gen cm_peri = 1000*(type==2 | (type==1 & b6>=100 & b6<= 106))

save "CM_PMRdata.dta", replace
erase births.dta

*tab stillbirths [iw=v005/1000000]
*tab earlyneonatal [iw=v005/1000000]
*tab cm_peri [iw=v005/1000000]

*summ cm_peri [iw=v005/1000000]

