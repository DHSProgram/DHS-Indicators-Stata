/*****************************************************************************************************
Program: 			FF_Want.do - DHS8 update
Purpose: 			Code to compute fertility planning status in women
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Thomas Pullum and modified by Shireen Assaf for the code share project
Date last modified: Aug 28, 2023 by Thomas Pullum 
Note:				The indicator is generated in line 129 and tabulated to match the table in the final report in line 140	using the calculate_table program and will produce the Tables_Fert_plan.xls file. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ff_plan_status		"Fertility planning status at birth of child"
----------------------------------------------------------------------------*/

clear
program drop _all

************************************************************
program define reduce_IR_file

* open dataset
use "$datapath//$irdata.dta", clear

local srvy=substr("$irdata", 1, 4)

rename *_0* *_*

* Construct a new variable for each pregnancy, called pbord
* pidxb is the index to the b variables. Use it to find bord for pregnancies 1 to 6
* Say that the most recent pregnancy, pregnancy #1, was not a live birth, and the previous pregnancy
*   was the most recent live birth. Then pidxb_1=. and pidxb_2=1. 
* We want to construct variables pbord_1=. and pbord_2=bord_1
* Thus pbord_p for pregnancy p will be bord for pregnancy p if the pregnancy outcome is a live
*   birth or this is a current pregnancy. Otherwise, pbord_p is . (NA)

summarize pord_1
local lmax=r(max)

quietly forvalues lo=1/6 {
gen pbord_`lo'=.
  forvalues lp=1/`lmax' {
  replace pbord_`lo'=bord_`lp' if pidxb_`lo'==`lp'  
  }
}

keep caseid v005 v008 v011 v012 pbord_1-pbord_6 pord_1-pord_6 p0_1-p0_6 p3_1-p3_6 p19_1-p19_6 p32_1-p32_6 m10_* v201 v213 v214 v225

save `srvy'temp.dta, replace

end

************************************************************

program define reshape_births
local srvy=substr("$irdata", 1, 4)

use `srvy'temp.dta, clear

* construct a file of births in the past five years
reshape long pbord_ pord_ p0_ p3_ p19_ p32_ m10_, i(caseid) j(bidx)

drop if pord==.

rename *_ *

* Restrict to the past 3 years
keep if p19<36

* adjustment to birth order for multiple births; see Guide to DHS Statistics
replace pbord=pbord-p0+1 if p0>1

* Construct intervals for the woman's age at birth (or other outcome)
gen age_at_birth=-2 + int((p3-v011)/60)

save `srvy'temp_births.dta, replace

end

************************************************************

program define append_current_preg

local srvy=substr("$irdata", 1, 4)

* construct a file of pregnancies
use `srvy'temp.dta, clear
keep caseid v005 v008 v011 v012 v201 v213 v214 v225
keep if v213==1

* Construct m10, bidx, birth order, and set p32 to 0
gen m10=v225
gen bidx=0
gen pbord=v201+1
gen p32=0

* tab v214,m

gen preg_duration=v214
replace preg_duration=9 if v214>9 

gen cmc_preg_delivery=v008+(9-preg_duration)
gen age_at_birth=-2 + int((cmc_preg_delivery-v011)/60)

* It can happen that a woman age 49 is pregnant and will give birth at age 50. Push any such cases into 45-49
replace age_at_birth=7 if age_at_birth>7

save         `srvy'temp_pregs.dta, replace
append using `srvy'temp_births.dta

* The youngest age interval should include births before 15
replace age_at_birth=1 if age_at_birth<1

label define ab 1 "<20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49"
label values age_at_birth ab
label variable age_at_birth "Mother's age at birth"

* Define a new label for p32 that includes a possible current pregnancy
label define p32r 0 "Current pregnancy" 1 "Live birth" 2 "Stillbirth" 3 "Miscarriage" 4 "Abortion"
label values p32 p32r
label variable p32 "Pregnancy outcome type"

gen birth_order=pbord
replace birth_order=4 if pbord>4
label define bo 4 "4+"
label values birth_order bo
label variable birth_order "Birth order"

clonevar ff_plan_status=m10
label define ff_plan_status 1 "Wanted then" 2 "Wanted later" 3 "Wanted no more"
label values ff_plan_status ff_plan_status
label variable ff_plan_status "Fertility planning status at birth of child"

save `srvy'temp_births_plus_pregs.dta, replace

end

************************************************************

program define calculate_table
local srvy=substr("$irdata", 1, 4)

use `srvy'temp_births_plus_pregs.dta, clear

gen wt= v005/1000000

* Top panel, limited to live births and current pregnancies
tab birth_order  ff_plan_status if p32<=1 [iw=wt], row
tab age_at_birth ff_plan_status if p32<=1 [iw=wt], row

* Panel for "ALL PREGNANCY OUTCOMES"
tab p32 ff_plan_status [iw=wt], row

* Export to excel
tabout birth_order age_at_birth ff_plan_status if p32<=1 using Table_FFplan.xls [iw=wt], c(row) f(1) replace 

tabout p32 ff_plan_status using Table_FFplan.xls [iw=wt] , c(row) f(1) append 

end

************************************************************
************************************************************
************************************************************
************************************************************
* EXECUTION BEGINS HERE

* open dataset

reduce_IR_file
reshape_births
append_current_preg
calculate_table

local srvy=substr("$irdata", 1, 4)

erase `srvy'temp.dta
erase `srvy'temp_births.dta
erase `srvy'temp_pregs.dta
erase `srvy'temp_births_plus_pregs.dta