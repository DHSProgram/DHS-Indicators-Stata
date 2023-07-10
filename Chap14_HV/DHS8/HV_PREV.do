/*****************************************************************************************************
Program: 			HV_PREV.do - DHS8 update
Purpose: 			Code for HIV prevalence
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: July 10, 2023 by Shireen Assaf
Note:				This is using the merged file IRMRARmerge.dta . For this file men's variables (mv###) were renamed to (v###) and a sex variable was created to identify men/women	

Several indicators have also been discontiued in DHS8. Please check the excel indicator list for these indicators. 
					
8 new indicators in DHS8, see below. These indicators can be tabulated among HIV positive respondents inrange(hiv03,1,3) or HIV negative respondents inlist(hiv03,0,7,9). See the updated tables code for how to tabulate these indicators using the DHS8 taplan.

Notes from the Guide to DHS States:
In DHS-7 and DHS-8, for surveys with testing to distinguish between HIV-1 and HIV-2, those found positive for either HIV-1 or HIV-2 (hiv03 in 1,2,3) are considered as HIV positive in these indicators.

Prior to DHS-7, for surveys with testing to distinguish between HIV-1 and HIV-2, only those tested and found positive for HIV-1 (including those found positive for HIV-1 only, as well as those found positive for both HIV-1 and HIV-2) (hiv03 in 1,3) are considered as HIV positive in these indicators.

*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hv_hiv_pos				"HIV positive test result"
	
hv_rcnt_test_pos		"Tested HIV positive during the most recent test prior to survey" - NEW Indicator in DHS8
hv_rcnt_test_pos_art	"Tested HIV positive during the most recent test prior to survey and currently taking ART" - NEW Indicator in DHS8
hv_rcnt_test_pos_noart	"Tested HIV positive during the most recent test prior to survey and not currently taking ART" - NEW Indicator in DHS8
hv_rcnt_test_neg		"Tested HIV negative during the most recent test prior to survey" - NEW Indicator in DHS8
hv_test_indeter			"HIV test prior to survey was indeterminate" - NEW Indicator in DHS8
hv_test_decline			"Decline to report HIV test result done prior to survey" - NEW Indicator in DHS8
hv_ever_test_noresult	"Ever tested for HIV and did not receive result of the most recent test" - NEW Indicator in DHS8
hv_no_prev_test			"Not previously tested" - NEW Indicator in DHS8


hv_couple_hiv_status	"HIV status for couples living in the same household both of whom had HIV test in survey"
----------------------------------------------------------------------------*/

if file=="MR" {

* Although the file MR is indicated in line 33, this is using the merged file IRMRARmerge.dta

cap label define yesno 0"No" 1"Yes"
***************************************

//HIV positive result
gen hv_hiv_pos= hiv03==1
label values hv_hiv_pos yesno
label var hv_hiv_pos "HIV positive test result"

//HIV-1 postive result
gen hv_hiv1_pos= inlist(hiv03,1,3)
label values hv_hiv1_pos yesno
label var hv_hiv1_pos "HIV-1 positive test result"

//HIV-2 positive result
gen hv_hiv2_pos= hiv03==2
label values hv_hiv2_pos yesno
label var hv_hiv2_pos "HIV-2 positive test result"

//HIV-1 or HIV-2 positive result
gen hv_hiv1or2_pos= inlist(hiv03,1,2,3)
label values hv_hiv1or2_pos yesno
label var hv_hiv1or2_pos "HIV-1 or HIV-2 positive test result"

//Tested HIV positive during the most recent test - NEW Indicator in DHS8
gen hv_rcnt_test_pos = v781==1 & v828==1 & v861==1
label values hv_rcnt_test_pos yesno
label var hv_rcnt_test_pos "Tested HIV positive during the most recent test prior to survey"

//Tested HIV positive during the most recent test and currently taking ART - NEW Indicator in DHS8
gen hv_rcnt_test_pos_art = v781==1 & v828==1 & v861==1 & v863==1
label values hv_rcnt_test_pos_art yesno
label var hv_rcnt_test_pos_art "Tested HIV positive during the most recent test prior to survey and currently taking ART"

//Tested HIV positive during the most recent test and not currently taking ART - NEW Indicator in DHS8
gen hv_rcnt_test_pos_noart = v781==1 & v828==1 & v861==1 & inlist(v863,0,8,9)
label values hv_rcnt_test_pos_noart yesno
label var hv_rcnt_test_pos_noart "Tested HIV positive during the most recent test prior to survey and not currently taking ART"

//Tested HIV negative during the most recent test - NEW Indicator in DHS8
gen hv_rcnt_test_neg = v781==1 & v828==1 & inlist(v861,2,5,9)
label values hv_rcnt_test_neg yesno
label var hv_rcnt_test_neg "Tested HIV negative during the most recent test prior to survey"

//HIV test prior to survey was indeterminate - NEW Indicator in DHS8
gen hv_test_indeter = v781==1 & v828==1 & v861==3
label values hv_test_indeter yesno
label var hv_test_indeter "HIV test prior to survey was indeterminate"

//Decline to report HIV test result - NEW Indicator in DHS8
gen hv_test_decline = v781==1 & v828==1 & v861==4
label values hv_test_decline yesno
label var hv_test_decline "Decline to report HIV test result done prior to survey"

//Ever tested for HIV and did not receive result - NEW Indicator in DHS8
gen hv_ever_test_noresult = v781==1 & v828!=1 
label values hv_ever_test_noresult yesno
label var hv_ever_test_noresult "Ever tested for HIV and did not receive result of the most recent test"

//Not previously tested - NEW Indicator in DHS8
gen hv_no_prev_test= v781!=1 
label values hv_no_prev_test yesno
label var hv_no_prev_test "Not previously tested"
	
}

* CR file
if file=="CR" {

gen hv_couple_hiv_status=.
replace hv_couple_hiv_status=1 if !inrange(w_hiv03,1,3) & !inrange(m_hiv03,1,3)
replace hv_couple_hiv_status=2 if !inrange(w_hiv03,1,3) & inrange(m_hiv03,1,3)
replace hv_couple_hiv_status=3 if inrange(w_hiv03,1,3)  & !inrange(m_hiv03,1,3)
replace hv_couple_hiv_status=4 if inrange(w_hiv03,1,3)  & inrange(m_hiv03,1,3)
replace hv_couple_hiv_status=. if !(inrange(w_hiv03,0,3) & inrange(m_hiv03,0,3))
label define status 1"Both HIV negative" 2"Man HIV positive, woman HIV negative" 3"Woman HIV positive, man HIV negative" 4"Both HIV positive"
label values hv_couple_hiv_status status
label var hv_couple_hiv_status "HIV status for couples living in the same household both of whom had HIV test in survey"

}