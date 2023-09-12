/*****************************************************************************************************
Program: 			PH_HNDWSH.do - No changes in DHS8
Purpose: 			Code to compute handwashing indicators
Data inputs: 		PR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: May 1, 2020 by Shireen Assaf 
Note:				The HR file can also be used to code these indicators among households. The condition hv102 would need to be removed. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

ph_hndwsh_place_fxd			"Fixed place for handwashing"
ph_hndwsh_place_mob			"Mobile place for handwashing"
ph_hndwsh_place_any			"Either fixed or mobile place for handwashing"
ph_hndwsh_water				"Place observed for handwashing with water"
ph_hndwsh_soap				"Place observed for handwashing with soap"
ph_hndwsh_clnsagnt			"Place observed for handwashing with cleansing agent other than soap"
ph_hndwsh_basic				"Basic handwashing facility"
ph_hndwsh_limited			"Limited handwashing facility"

----------------------------------------------------------------------------*/
cap label define yesno 0"No" 1"Yes"

//Fixed place for handwashing
gen ph_hndwsh_place_fxd= hv230a==1 
replace ph_hndwsh_place_fxd=. if hv102!=1
label values ph_hndwsh_place_fxd yesno
label var ph_hndwsh_place_fxd "Fixed place for handwashing"

//Mobile place for handwashing
gen ph_hndwsh_place_mob= hv230a==2 
replace ph_hndwsh_place_mob=. if hv102!=1
label values ph_hndwsh_place_mob yesno
label var ph_hndwsh_place_mob "Mobile place for handwashing"

//Fixed or mobile place for handwashing
gen ph_hndwsh_place_any= inlist(hv230a,1,2)
replace ph_hndwsh_place_any=. if hv102!=1
label values ph_hndwsh_place_any yesno
label var ph_hndwsh_place_any "Either fixed or mobile place for handwashing"

//Place observed for handwashing with water
gen ph_hndwsh_water= 0 if inlist(hv230a,1,2) 
replace ph_hndwsh_water= 1 if hv230b==1 
replace ph_hndwsh_water=. if hv102!=1
label values ph_hndwsh_water yesno
label var ph_hndwsh_water "Place observed for handwashing with water"

//Place observed for handwashing with soap
gen ph_hndwsh_soap= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_soap=1 if hv232==1
replace ph_hndwsh_soap=. if hv102!=1
label values ph_hndwsh_soap yesno
label var ph_hndwsh_soap "Place observed for handwashing with soap"

//Place observed for handwashing with cleansing agent other than soap
gen ph_hndwsh_clnsagnt= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_clnsagnt=1 if hv232b==1
replace ph_hndwsh_clnsagnt=. if hv102!=1
label values ph_hndwsh_clnsagnt yesno
label var ph_hndwsh_clnsagnt "Place observed for handwashing with cleansing agent other than soap"

//Basic handwashing facility
gen ph_hndwsh_basic= 0 if inlist(hv230a,1,2,3)
replace ph_hndwsh_basic = 1 if hv230b==1 & hv232==1
replace ph_hndwsh_basic=. if hv102!=1 
label values ph_hndwsh_basic yesno
label var ph_hndwsh_basic	"Basic handwashing facility"

//Limited handwashing facility
gen ph_hndwsh_limited= 0 if inlist(hv230a,1,2,3)
replace ph_hndwsh_limited = 1 if hv230b==0 | hv232==0
replace ph_hndwsh_limited=. if hv102!=1 
label values ph_hndwsh_limited yesno
label var ph_hndwsh_limited	"Limited handwashing facility"
