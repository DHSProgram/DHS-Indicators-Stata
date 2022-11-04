/*****************************************************************************************************
Program: 			NT_CH_GWTH.do
Purpose: 			Code to compute child growth monitoring indicators - DHS8 update
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: November 2, 2022 by Shireen Assaf 	
Note: 				These four indicators are NEW Indicators in DHS8			
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_ch_wt_msrd	"Child under 5 with weight measured in the last 3 months" 
nt_ch_wtht_msrd	"Child under 5 with weight and height measured in the last 3 months"
nt_ch_muac_msrd	"Child under 5 with MUAC measured in the last 3 months"
nt_ch_all_msrd	"Child under 5 with weight, height, and MUAC measured in the last 3 months"
----------------------------------------------------------------------------*/

cap label define yesno 0"No" 1"Yes"
gen wt=v005/1000000

//weight measured
gen nt_ch_wt_msrd= h70a==1 
label values nt_ch_wt_msrd yesno 
label var nt_ch_wt_msrd "Child under 5 with weight measured in the last 3 months"

//weight and height measured
gen nt_ch_wtht_msrd= h70a==1 & h70b==1
label values nt_ch_wtht_msrd yesno 
label var nt_ch_wtht_msrd "Child under 5 with weight and height measured in the last 3 months"

//MUAC measured measured
gen nt_ch_muac_msrd= h70c==1 
label values nt_ch_muac_msrd yesno 
label var nt_ch_muac_msrd "Child under 5 with MUAC measured in the last 3 months"

//weight, height, and MUAC measured
gen nt_ch_all_msrd= h70a==1 & h70b==1 & h70c==1 
label values nt_ch_all_msrd yesno 
label var nt_ch_all_msrd "Child under 5 with weight, height, and MUAC measured in the last 3 months"