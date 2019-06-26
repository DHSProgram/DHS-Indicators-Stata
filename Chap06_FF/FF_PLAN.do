/*****************************************************************************************************
Program: 			FF_Want.do
Purpose: 			Code to compute fertility planning status in women
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Thomas Pullum and modified by Shireen Assaf for the code share project
Date last modified: May 13, 2019 by Shireen Assaf 
Note:				To construct the fertility planning status indicator, we need to include births in the
					five years before the survey as well as current pregnancy. This requires appending the
					data of births and pregnancies. 
					After appending these data, the indicator is generated in line 130	
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

* check whether b19 is in the file 
scalar suseb19=0
capture confirm numeric variable b19_01, exact 
if _rc>0 {
gen b19_01=.
}

quietly summarize b19_01
if r(mean)>0 & r(mean)<. {
scalar suseb19=1
}

if suseb19==0 {
  local li=2
  while `li'<=6 {
  gen b19_0`li'=.
  local li=`li'+1
  }
}

keep caseid v005 v008 v011 v012 bord_01-bord_06 b0_01-b0_06 b3_01-b3_06 b19_01-b19_06 m10_1-m10_6 v201 v213 v214 v225

* v213      V213       currently pregnant
* v225      V225       current pregnancy wanted

gen womanid=_n
rename *_0* *_*

save `srvy'temp.dta, replace

end

************************************************************

program define reshape_births
local srvy=substr("$irdata", 1, 4)

use `srvy'temp.dta, clear

* construct a file of births in the past five years
reshape long bord_ b0_ b3_ b19_ m10_, i(womanid) j(bidx)

drop if bord==.
rename *_ *

* adjustment to birth order for multiple births; see Guide to DHS Statistics
replace bord=bord-b0+1 if b0>1

gen interval=v008-b3

if suseb19==1 {
replace interval=b19
}

keep if interval<60
drop interval

gen age_at_birth=-2 + int((b3-v011)/60)
replace age_at_birth=1 if age_at_birth<1
label define age_at_birth 1 "<20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49"
label values age_at_birth age_at_birth
tab age_at_birth,m

save `srvy'temp_births.dta, replace

end

************************************************************

program define append_current_preg

local srvy=substr("$irdata", 1, 4)

* construct a file of pregnancies
use `srvy'temp.dta, clear
keep caseid v005 v008 v011 v012 v201 v213 v214 v225
keep if v213==1
rename v225 m10
gen bidx=0

* if the woman is currently pregnant, set the birth order of the pregnancy
gen bord=v201+1

gen preg_duration=v214
replace preg_duration=9 if v214>9 

gen cmc_preg_delivery=v008+(9-preg_duration)
gen age_at_birth=-2 + int((cmc_preg_delivery-v011)/60)
label define age_at_birth 1 "<20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49"
label values age_at_birth age_at_birth

* It can happen that a woman age 49 is pregnant and will give birth at age 50. Push any such cases into 45-49
replace age_at_birth=7 if age_at_birth>7

save `srvy'temp_pregs.dta, replace
append using `srvy'temp_births.dta

gen birth_order=bord
replace birth_order=4 if bord>4

//Define our variable of interest after appending the births and pregnancies
clonevar ff_plan_status=m10
label var ff_plan_status "Fertility planning status at birth of child"

save `srvy'temp_births_plus_pregs.dta, replace

end

************************************************************

program define calculate_table
local srvy=substr("$irdata", 1, 4)

use `srvy'temp_births_plus_pregs.dta, clear

gen wt=v005/1000000

tab birth_order ff_plan_status [iweight=wt], row
tab age_at_birth ff_plan_status [iweight=wt], row

*output to excel
tabout birth_order age_at_birth ff_plan_status using Tables_FFplan.xls [iw=wt] , c(row) f(1) replace 


end

************************************************************
************************************************************
************************************************************
************************************************************
* EXECUTION BEGINS HERE

reduce_IR_file
reshape_births
append_current_preg
calculate_table

local srvy=substr("$irdata", 1, 4)

erase `srvy'temp.dta
erase `srvy'temp_births.dta
erase `srvy'temp_pregs.dta
