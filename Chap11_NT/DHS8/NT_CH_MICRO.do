/*****************************************************************************************************
Program: 			NT_CH_MICRO.do
Purpose: 			Code to compute micronutrient indicators in children - DHS8 update
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: November 4, 2022 by Shireen Assaf 
Note:				One new DHS8 indicator. Age ranges were also updated. 		
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_ch_micro_mp		"Children age 6-59 mos given multiple micronutrient powder"
nt_ch_micro_iron	"Children age 6-59 mos given iron tablets or syrups"
nt_ch_micro_ironsup	"Children age 6-59 mos given iron containing supplements" - NEW Indicator in DHS8
nt_ch_micro_vas		"Children age 6-59 mos given Vit. A supplements"
nt_ch_micro_dwm		"Children age 12-59 mos given deworming medication"
----------------------------------------------------------------------------*/

cap label define yesno 0"No" 1"Yes"

//Received multiple micronutrient powder
gen nt_ch_micro_mp= h80a==1 
replace nt_ch_micro_mp=. if !inrange(age,6,59) | b5==0 | h80a==.
label values nt_ch_micro_mp yesno 
label var nt_ch_micro_mp "Children age 6-59 mos given multiple micronutrient powder"

//Received iron tablets or syrups
gen nt_ch_micro_iron= h42==1 
replace nt_ch_micro_iron=. if !inrange(age,6,59) | b5==0
label values nt_ch_micro_iron yesno 
label var nt_ch_micro_iron "Children age 6-59 mos given iron tablets or syrups"

//Received iron containing supplements - NEW Indicator in DHS8
gen nt_ch_micro_ironsup= h42==1 | h80a==1
replace nt_ch_micro_ironsup=. if !inrange(age,6,59) | b5==0
label values nt_ch_micro_ironsup yesno 
label var nt_ch_micro_ironsup "Children age 6-59 mos given iron containing supplements"

//Received Vit. A supplements
recode h33m (98=.), gen(h33m2)
recode h33d (98=15), gen(h33d2)
recode h33y (9998=.), gen(h33y2)
gen nt_ch_micro_vas= h34==1 | (int((mdy(v006,v016,v007) - mdy(h33m2,h33d2,h33y2) )/30.4375) < 7)
replace nt_ch_micro_vas=. if !inrange(age,6,59) | b5==0
label values nt_ch_micro_vas yesno 
label var nt_ch_micro_vas "Children age 6-59 mos given Vit. A supplements"

//Received deworming medication
gen nt_ch_micro_dwm= h43==1
replace nt_ch_micro_dwm=. if !inrange(age,12,59) | b5==0
label values nt_ch_micro_dwm yesno 
label var nt_ch_micro_dwm "Children age 6-59 mos given deworming medication"
