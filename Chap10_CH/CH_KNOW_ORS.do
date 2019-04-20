/*****************************************************************************************************
Program: 			CH_KNOW_ORS.do
Purpose: 			Code knowledge of ORS variable.
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: March 15 2019 by Shireen Assaf 
Notes:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_know_ors		"Know about ORS as treatment for diarrhea among women with birth in the last 5 years"
----------------------------------------------------------------------------*/

//Know ORS
gen ch_know_ors=0
replace ch_know_ors=1 if v416>0 & v416<3
replace ch_know_ors=. if v208==0
label var ch_know_ors "Know about ORS as treatment for diarrhea among women with birth in the last 5 years"
