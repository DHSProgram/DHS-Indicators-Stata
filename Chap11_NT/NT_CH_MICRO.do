/*****************************************************************************************************
Program: 			NT_CH_MICRO.do
Purpose: 			Code to compute micronutrient indicators in children
Data inputs: 		KR file
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 26, 2019 by Shireen Assaf 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

nt_ch_micro_mp		"Children age 6-23 mos given multiple micronutrient powder"
nt_ch_micro_iron	"Children age 6-59 mos given iron supplements"
nt_ch_micro_vas		"Children age 6-59 mos given Vit. A supplements"
nt_ch_micro_dwm		"Children age 6-59 mos given deworming medication"
nt_ch_micro_iod		"Children age 6-59 mos live in hh with iodized salt"
nt_ch_food_ther		"Children age 6-35 mos given therapeutic food"
nt_ch_food_supp		"Children age 6-35 mos given supplemental food"

----------------------------------------------------------------------------*/

//Received multiple micronutrient powder
gen nt_ch_micro_mp= h80a==1 
replace nt_ch_micro_mp=. if !inrange(age,6,23) | b5==0
label values nt_ch_micro_mp yesno 
label var nt_ch_micro_mp "Children age 6-23 mos given multiple micronutrient powder"

//Received iron supplements
gen nt_ch_micro_iron= h42==1 
replace nt_ch_micro_iron=. if !inrange(age,6,59) | b5==0
label values nt_ch_micro_iron yesno 
label var nt_ch_micro_iron "Children age 6-59 mos given iron supplements"

//Received Vit. A supplements
recode h33m (98=.), gen(h33m2)
recode h33d (98=15), gen(h33d2)
recode h33y (9998=.), gen(h33y2)

gen nt_ch_micro_vas= h34==1 | (int((v008a - (mdy(h33m2,h33d2,h33y2) + 21916) )/30.4375) <= 6) 
replace nt_ch_micro_vas=. if !inrange(age,6,59) | b5==0
label values nt_ch_micro_vas yesno 
label var nt_ch_micro_vas "Children age 6-59 mos given Vit. A supplements"

//Received deworming medication
gen nt_ch_micro_dwm= h43==1
replace nt_ch_micro_dwm=. if !inrange(age,6,59) | b5==0
label values nt_ch_micro_dwm yesno 
label var nt_ch_micro_dwm "Children age 6-59 mos given deworming medication"

//Child living in household with idodized salt 
gen nt_ch_micro_iod= hv234a==1
replace nt_ch_micro_iod=. if !inrange(age,6,59) | b5==0 | hv234a>1
label values nt_ch_micro_iod yesno 
label var nt_ch_micro_iod "Children age 6-59 mos live in hh with iodized salt"

//Received therapeutic food
gen nt_ch_food_ther= h80b==1
replace nt_ch_food_ther=. if !inrange(age,6,35) | b5==0
label values nt_ch_food_ther yesno 
label var nt_ch_food_ther "Children age 6-35 mos given therapeutic food"

//Received supplemental food
gen nt_ch_food_supp= h80c==1
replace nt_ch_food_supp=. if !inrange(age,6,35) | b5==0
label values nt_ch_food_supp yesno 
label var nt_ch_food_supp "Children age 6-35 mos given supplemental food"