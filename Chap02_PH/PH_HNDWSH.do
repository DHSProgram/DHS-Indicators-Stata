/*****************************************************************************************************
Program: 			PH_HNDWSH.do
Purpose: 			Code to compute handwashing indicators
Data inputs: 		HR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: April 22, 2020 by Shireen Assaf 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

ph_hndwsh_place_fxd			"Fixed place for handwashing"
ph_hndwsh_place_mob			"Mobile place for handwashing"
ph_hndwsh_plac_both			"Either fixed or mobile place for handwashing"
ph_hndwsh_soap_wtr			"Place observed for handwashing with soap and water"
ph_hndwsh_clnsagnt_wtr		"Place observed for handwashing with cleansing agent other than soap and water"
ph_hndwsh_wtronly			"Place observed for handwashing with water only"
ph_hndwsh_soap_nowtr		"Place observed for handwashing with soap and no water"
ph_hndwsh_clnsagnt_nowtr	"Place observed for handwashing with cleansing agent otherthan soap and no water"
ph_hndwsh_none				"Place observed for handwashing with no water, no soap, and no other cleansing agent"
----------------------------------------------------------------------------*/
cap label define yesno 0"No" 1"Yes"

//Fixed place for handwashing
gen ph_hndwsh_place_fxd= hv230a==1
label values ph_hndwsh_place_fxd yesno
label var ph_hndwsh_place_fxd "Fixed place for handwashing"

//Mobile place for handwashing
gen ph_hndwsh_place_mob= hv230a==2
label values ph_hndwsh_place_mob yesno
label var ph_hndwsh_place_mob "Mobile place for handwashing"

//Fixed or mobile place for handwashing
gen ph_hndwsh_plac_both= inlist(hv230a,1,2)
label values ph_hndwsh_plac_both yesno
label var ph_hndwsh_plac_both "Either fixed or mobile place for handwashing"

//Place observed for handwashing with soap and water
gen ph_hndwsh_soap_wtr= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_soap_wtr= 1 if hv230b==1 & hv232==1
label values ph_hndwsh_soap_wtr yesno
label var ph_hndwsh_soap_wtr "Place observed for handwashing with soap and water"

//Place observed for handwashing with cleansing agent other than soap and water
gen ph_hndwsh_clnsagnt_wtr= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_clnsagnt_wtr=1 if hv230b==1 & hv232!=1 & hv232b==1
label values ph_hndwsh_clnsagnt_wtr yesno
label var ph_hndwsh_clnsagnt_wtr "Place observed for handwashing with cleansing agent other than soap and water"

//Place observed for handwashing with water only
gen ph_hndwsh_wtronly= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_wtronly=1 if hv230b==1 & hv232!=1 & hv232b!=1 & hv232y==1
label values ph_hndwsh_wtronly yesno
label var ph_hndwsh_wtronly "Place observed for handwashing with water only"

//Place observed for handwashing with soap and no water
gen ph_hndwsh_soap_nowtr= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_soap_nowtr=1 if hv230b!=1 & hv232==1
label values ph_hndwsh_soap_nowtr yesno
label var ph_hndwsh_soap_nowtr "Place observed for handwashing with soap and no water"

//Place observed for handwashing with cleansing agent other than soap and no water
gen ph_hndwsh_clnsagnt_nowtr= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_clnsagnt_nowtr=1 if hv230b!=1 & hv232!=1 & hv232b==1
label values ph_hndwsh_clnsagnt_nowtr yesno
label var ph_hndwsh_clnsagnt_nowtr "Place observed for handwashing with cleansing agent otherthan soap and no water"

//Place observed for handwashing with no water, no soap, and no other cleansing agent
gen ph_hndwsh_none= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_none=1 if hv230b!=1 & hv232!=1 & hv232b!=1 & hv232y==1
label values ph_hndwsh_none yesno
label var ph_hndwsh_none "Place observed for handwashing with no water, no soap, and no other cleansing agent"
