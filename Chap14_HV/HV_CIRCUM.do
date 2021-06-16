/*****************************************************************************************************
Program: 			HV_CIRCUM.do
Purpose: 			Code for Circumcision and HIV
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Nov 6, 2019 by Shireen Assaf 
Note:				This is using the merged file IRMRARmerge.dta 
			
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

hv_hiv_circum_skilled	"Circumcised by a health professional and HIV positive"
hv_hiv_circum_trad		"Circumcised by a traditional practitioner, family, or friend and HIV positive"
hv_hiv_circum_pos		"Circumcised and HIV positive"
hv_hiv_uncircum_pos		"Uncircumcised and HIV positive"
	
----------------------------------------------------------------------------*/
cap label define yesno 0"No" 1"Yes"

//Circumcised by health professional and HIV positive
gen hv_hiv_circum_skilled= 0 if v483==1 & v483b==2
replace hv_hiv_circum_skilled=1 if v483==1 & v483b==2 & inlist(hiv03,1,3) 
label values hv_hiv_circum_skilled yesno
label var hv_hiv_circum_skilled	"Circumcised by a health professional and HIV positive"

//Circumcised by traditional practitioner/family/friend and HIV positive
gen hv_hiv_circum_trad= 0 if v483==1 & v483b==1
replace hv_hiv_circum_trad=1 if v483==1 & v483b==1 & inlist(hiv03,1,3) 
label values hv_hiv_circum_trad yesno 
label var hv_hiv_circum_trad "Circumcised by a traditional practitioner, family, or friend and HIV positive"

//Circumcised and HIV positive
gen hv_hiv_circum_pos= 0 if v483==1 
replace hv_hiv_circum_pos=1 if v483==1 & inlist(hiv03,1,3) 
label values hv_hiv_circum_pos yesno
label var hv_hiv_circum_pos "Circumcised and HIV positive"

//Uncircumcised and HIV positive
gen hv_hiv_uncircum_pos= 0 if v483!=1 
replace hv_hiv_uncircum_pos=1 if v483!=1 & inlist(hiv03,1,3) 
replace hv_hiv_uncircum_pos=. if v483==.
label values hv_hiv_uncircum_pos yesno
label var hv_hiv_uncircum_pos "Uncircumcised and HIV positive"
