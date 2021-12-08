/*****************************************************************************************************
Program: 			HV_PREV.do
Purpose: 			Code for HIV prevalence
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Nov 5, 2019 by Shireen Assaf 
Note:				This is using the merged file IRMRARmerge.dta 	
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hv_hiv_pos				"HIV positive test result"
hv_hiv1_pos				"HIV-1 positive test result"
hv_hiv2_pos				"HIV-2 positive test result"
hv_hiv1or2_pos			"HIV-1 or HIV-2 positive test result"
	
hv_pos_ever_test		"Ever tested for HIV and received result of most recent test among HIV positive"
hv_pos_12m_test			"Tested in the past 12 months and received result among HIV positive"
hv_pos_more12m_test		"Tested 12 or more months ago and received result among HIV positive"
hv_pos_ever_noresult	"Ever tested for HIV and did not receive the result of most recent test among HIV positive"
hv_pos_nottested		"Not previously tested among HIV positive"
	
hv_neg_ever_test		"Ever tested for HIV and received result of most recent test among HIV negative"
hv_neg_12m_test			"Tested in the past 12 months and received result among HIV negative"
hv_neg_more12m_test		"Tested 12 or more months ago and received result among HIV negative"
hv_neg_ever_noresult	"Ever tested for HIV and did not receive the result of most recent test among HIV negative"
hv_neg_nottested		"Not previously tested among HIV negative"

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
	
//Ever tested among HIV positive
gen hv_pos_ever_test= v781==1 & v828==1 if inlist(hiv03,1,3)
label values hv_pos_ever_test yesno
label var hv_pos_ever_test "Ever tested for HIV and received result of most recent test among HIV positive"

//Tested in the last 12 months among HIV positive
gen hv_pos_12m_test= v781==1 & v826a<12 & v828==1 if inlist(hiv03,1,3)
label values hv_pos_12m_test yesno
label var hv_pos_12m_test "Tested in the past 12 months and received result among HIV positive"

//Tested 12 ore more months ago among HIV positive
gen hv_pos_more12m_test = v781==1 & v826a>=12 & v828==1 if inlist(hiv03,1,3)
label values hv_pos_more12m_test yesno
label var hv_pos_more12m_test "Tested 12 or more months ago and received result among HIV positive"

//Ever tested but did not receive most recent result among HIV positive
gen hv_pos_ever_noresult= v781==1 & v828!=1 if inlist(hiv03,1,3)
label values hv_pos_ever_noresult yesno
label var hv_pos_ever_noresult "Ever tested for HIV and did not receive the result of most recent test among HIV positive"

//Not previously tested among HIV positive
gen hv_pos_nottested= v781!=1 if inlist(hiv03,1,3)
label values hv_pos_nottested yesno
label var hv_pos_nottested "Not previously tested among HIV positive"

//Ever tested among HIV negative
gen hv_neg_ever_test= v781==1 & v828==1 if inlist(hiv03,0,2,7,9)
label values hv_neg_ever_test yesno
label var hv_neg_ever_test "Ever tested for HIV and received result of most recent test among HIV negative"

//Tested in the last 12 months among HIV negative
gen hv_neg_12m_test= v781==1 & v826a<12 & v828==1 if inlist(hiv03,0,2,7,9)
label values hv_neg_12m_test yesno
label var hv_neg_12m_test "Tested in the past 12 months and received result among HIV negative"

//Tested 12 ore more months ago among HIV negative
gen hv_neg_more12m_test = v781==1 & v826a>=12 & v828==1 if inlist(hiv03,0,2,7,9)
label values hv_neg_more12m_test yesno
label var hv_neg_more12m_test "Tested 12 or more months ago and received result among HIV negative"

//Ever tested but did not receive most recent result among HIV negative
gen hv_neg_ever_noresult= v781==1 & v828!=1 if inlist(hiv03,0,2,7,9)
label values hv_neg_ever_noresult yesno
label var hv_neg_ever_noresult "Ever tested for HIV and did not receive the result of most recent test among HIV negative"

//Not previously tested among HIV negative
gen hv_neg_nottested= v781!=1 if inlist(hiv03,0,2,7,9)
label values hv_neg_nottested yesno
label var hv_neg_nottested "Not previously tested among HIV negative"
	
}

* CR file
if file=="CR" {

gen hv_couple_hiv_status=.
replace hv_couple_hiv_status=1 if (w_hiv03!=1 & w_hiv03!=3) & (m_hiv03!=1 & m_hiv03!=3)
replace hv_couple_hiv_status=2 if (w_hiv03!=1 & w_hiv03!=3) & (m_hiv03==1 | m_hiv03==3)
replace hv_couple_hiv_status=3 if (w_hiv03==1 | w_hiv03==3) & (m_hiv03!=1 & m_hiv03!=3)
replace hv_couple_hiv_status=4 if (w_hiv03==1 | w_hiv03==3) & (m_hiv03==1 | m_hiv03==3)
replace hv_couple_hiv_status=. if !(inlist(w_hiv03,0,1,3) & inlist(m_hiv03,0,1,3))
label define status 1"Both HIV negative" 2"Man HIV positive, woman HIV negative" 3"Woman HIV positive, man HIV negative" 4"Both HIV positive"
label values hv_couple_hiv_status status
label var hv_couple_hiv_status "HIV status for couples living in the same household both of whom had HIV test in survey"

}