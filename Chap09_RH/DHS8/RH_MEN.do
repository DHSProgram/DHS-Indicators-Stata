/*****************************************************************************************************
Program: 			RH_MEN.do - new do file in DHS8 update
Purpose: 			Code indicators on men's involvement in maternal health care
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 9, 2022 by Shireen Assaf 
Notes:				Four new indicators in DHS8, see below. 
					Note indicators below are computed for all men in the survey. Must select for men age 15-49 if needed using mv012.
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:

rh_mn_report_anc		"Report that their child's mother had any ANC" - NEW Indicator in DHS8
rh_mn_present_anc		"Present during any ANC visit" - NEW Indicator in DHS8
rh_mn_report_delfacil	"Report that their child was born in health facility" - NEW Indicator in DHS8
rh_mn_present_delfacil	"Went with child's mother to health facility for delivery" - NEW Indicator in DHS8

/----------------------------------------------------------------------------*/

//Report that their child's mother had any ANC
gen rh_mn_report_anc = mv247<=2 & mv248==1
replace rh_mn_report_anc=. if mv247>2
label var rh_mn_report_anc	"Report that their child's mother had any ANC"

//Present during any ANC visit
gen rh_mn_present_anc = mv247<=2 & mv248==1 & mv249==1
replace rh_mn_present_anc=. if mv247>2 | mv248!=1
label var rh_mn_present_anc	"Present during any ANC visit"

//Report that their child was born in health facility
gen rh_mn_report_delfacil = mv247<=2 & mv250==1
replace rh_mn_report_delfacil=. if mv247>2 
label var rh_mn_report_delfacil	"Report that their child was born in health facility"

//Went with child's mother to health facility for delivery
gen rh_mn_present_delfacil = mv247<=2 & mv250==1 & mv253==1
replace rh_mn_present_delfacil=. if mv247>2  | mv250!=1
label var rh_mn_present_delfacil	"Went with child's mother to health facility for delivery"


