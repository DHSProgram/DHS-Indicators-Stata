/*****************************************************************************************************
Program: 			ML_NETS_HH.do - No changes in DHS8
Purpose: 			Code indicators for household ITN ownership
Data inputs: 		HR dataset
Data outputs:		coded variables
Author:				Cameron Taylor 
Date last modified: February 19 2019 by Cameron Taylor
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_mosquitonet			"Households with at least one mosquito net"
ml_itnhh				"Households with at least one ITN"
ml_avgmosnethh			"Average number of mosquito nets per household"
ml_avgitnhh				"Average number of ITNs per household"
ml_mosnethhaccess		"Households with >1 mosquito net per 2 household members"
ml_hhaccess				"Households with >1 ITN per 2 household members"
----------------------------------------------------------------------------*/

//Household mosquito net ownership
gen ml_mosquitonet=0
replace ml_mosquitonet=1 if hv227==1
lab var ml_mosquitonet "Household owns at least one mosquito net"

//Household ITN ownership
gen ml_itnhh=0
forvalues x=1/7 {
replace ml_itnhh=1 if hml10_`x'==1
	}
lab var ml_itnhh "Household owns at least one ITN"

*Number of mosquito nets per household
gen ml_numnets=0 
replace ml_numnets=hml1
lab var ml_numnets "Number of mosquito nets per household"

*Number of ITNs per household
gen ml_numitnhh=0 
forvalues x=1/7 {
gen itnhh_0`x'=(hml10_`x'==1)
	}
replace ml_numitnhh=itnhh_01 + itnhh_02 + itnhh_03 + itnhh_04 + itnhh_05 + itnhh_06 + itnhh_07
lab var ml_numitnhh "Number of ITNs per household"

//Average number of mosquito nets per household
sum ml_numnets [iw=hv005/1000000]
gen ml_avgmosnethh=round(r(mean),0.1)
label var ml_avgmosnethh "Average number of mosquito nets per household"

//Average number of ITNs per household
sum ml_numitnhh [iw=hv005/1000000]
gen ml_avgitnhh=round(r(mean),0.1)
label var ml_avgitnhh "Average number of ITNs per household"

//Households with > 1 mosquito net per 2 members
*Potential users divided by defacto household members is greater or equal to one
gen ml_mosnetpotuse = ml_numnets*2 // Potential ITN users in Household
lab var ml_mosnetpotuse "Potential mosquito net users in household"
gen ml_mosnethhaccess = ((ml_mosnetpotuse/hv013)>=1)
*this indicator is based on households with at least one person who stayed in the house last night
*hv013 is the number of persons who stayed in the household last night. 
replace ml_mosnethhaccess=. if hv013==0
lab var ml_mosnethhaccess "Households with >1 mosquito net per 2 household members"

//Households with > 1 ITN per 2 members
*Potential users divided by defacto household members is greater or equal to one
gen ml_potuse = ml_numitnhh*2 // Potential ITN users in Household
lab var ml_potuse "Potential ITN users in household"
gen ml_hhaccess = ((ml_potuse/hv013)>=1)
replace ml_hhaccess=. if hv013==0
lab var ml_hhaccess "Households with >1 ITN per 2 household members"

drop itnhh_01- itnhh_07
