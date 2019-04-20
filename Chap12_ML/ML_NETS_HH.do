/*****************************************************************************************************
Program: 			ML_NETS_HH.do
Purpose: 			HOUSEHOLD POSSESSION OF ITNS
Data inputs: 		HR survey list
Data outputs:		coded variables
Author:				Cameron Taylor
Date last modified: February 19 2019 by Cameron Taylor
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
mal_ITNinHH		"Households with at least one ITN"
mal_numitnhh	"Number of ITNs per household"
mal_potuse		"Potential ITN users in household"
mal_hhaccess	"Households with >1 ITN per 2 household members"
----------------------------------------------------------------------------*/

*** Household ITN Ownership ***

//Household ITN ownership
	gen mal_ITNinHH=0
		forvalues x=1/7 {
			replace mal_ITNinHH=1 if hml10_`x'==1
		}
	lab var mal_ITNinHH "Household owns at least one ITN"

//Number of ITNs per household
	gen mal_numitnhh=0 
		forvalues x=1/7 {
			gen itnhh_0`x'=(hml10_`x'==1)
		}
	replace mal_numitnhh=itnhh_01 + itnhh_02 + itnhh_03 + itnhh_04 + itnhh_05 + itnhh_06 + itnhh_07
	lab var mal_numitnhh "Number of ITNs per household"

//Potential ITN users in Household
	gen mal_potuse = numitnhh*2
	lab var mal_potuse "Potential ITN users in household"

	
//Households with > 1 ITN per 2 members
//Potential users divided by defacto household members is greater or equal to one
	gen mal_hhaccess = ((mal_potuse/hv013)>=1)
	lab var mal_hhaccess "Households with >1 ITN per 2 household members"

