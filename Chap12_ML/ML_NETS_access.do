/*****************************************************************************************************
Program: 			ML_NETS_access.do
Purpose: 			POPULATION ACCESS TO ITNS
Data inputs: 		HR and PR survey list
Data outputs:		coded variables
Author:				Cameron Taylor
Date last modified: February 19 2019 by Cameron Taylor
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
mal_numitnhh	"Number of ITNs per household"
mal_access		"Population with access to an ITN"
----------------------------------------------------------------------------*/

*Open HR dataset

if file=="HR" 
	sort hv001 hv002

//Number of ITNs per household
	gen mal_numitnhh=0 
		forvalues x=1/7 {
			gen itnhh_0`x'=(hml10_`x'==1)
		}
	replace mal_numitnhh=itnhh_01 + itnhh_02 + itnhh_03 + itnhh_04 + itnhh_05 + itnhh_06 + itnhh_07
	lab var mal_numitnhh "Number of ITNs per household"

save "HRmerge", replace

*Merge pr file hr file

if file=="PR" 

	merge hv001 hv002 using "HRmerge.dta"
	tab _merge

//Population with access to an ITN

	bysort hhid: g mal_access = potuse/hv013
	replace mal_access=1 if potuse/hv013 >1
	lab var mal_access "Population with access to an ITN"


save "HRPR", replace


