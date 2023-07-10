/*****************************************************************************************************
Program: 			HV_CIRCUM.do - DHS8 update
Purpose: 			Code for Circumcision and HIV
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: July 10, 2023 by Shireen Assaf 
Note:				This is using the merged file IRMRARmerge.dta . For this file men's variables (mv###) were renamed to (v###) and a sex variable was created to identify men/women	

Several indicators have also been discontiued in DHS8. Please check the excel indicator list for these indicators. 
					
5 new indicators in DHS8, see below				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

hv_tradormed_circum		"Men traditionally or medically circumcised who were HIV positive"  - NEW Indicator in DHS8
hv_trad_circum			"Men traditionally circumcised who were HIV positive"  - NEW Indicator in DHS8
hv_med_circum			"Men medically circumcised who were HIV positive"  - NEW Indicator in DHS8
hv_tradandmed_circum	"Men traditionally and medically circumcised who were HIV positive"  - NEW Indicator in DHS8
hv_uncircum				"All uncircumcised or don't know circumcision status men who were HIV positive"  - NEW Indicator in DHS8
	
----------------------------------------------------------------------------*/
cap label define yesno 0"No" 1"Yes"

//Men traditionally or medically circumcised who were HIV positive  - NEW Indicator in DHS8
gen hv_tradormed_circum = v483==1 & inrange(hiv03,1,3) if (v483==1 & (inrange(hiv03,1,7) | hiv03==9)) 
label values hv_tradormed_circum yesno
label var hv_tradormed_circum "Men traditionally or medically circumcised who were HIV positive"  

//Men traditionally circumcised who were HIV positive  - NEW Indicator in DHS8
gen hv_trad_circum = (v483d==1 & v483e==0) & inrange(hiv03,1,3) if ((v483d==1 & v483e==0) & (inrange(hiv03,1,7) | hiv03==9)) 
label values hv_trad_circum yesno
label var hv_trad_circum "Men traditionally circumcised who were HIV positive"  

//Men medically circumcised who were HIV positive  - NEW Indicator in DHS8
gen hv_med_circum = (v483d==0 & v483e==1) & inrange(hiv03,1,3) if ((v483d==0 & v483e==1) & (inrange(hiv03,1,7) | hiv03==9)) 
label values hv_med_circum yesno
label var hv_med_circum "Men medically circumcised who were HIV positive"  

//Men traditionally and medically circumcised who were HIV positive  - NEW Indicator in DHS8
gen hv_tradandmed_circum = (v483d==1 & v483e==1) & inrange(hiv03,1,3) if ((v483d==1 & v483e==1) & (inrange(hiv03,1,7) | hiv03==9)) 
label values hv_tradandmed_circum yesno
label var hv_tradandmed_circum "Men traditionally and medically circumcised who were HIV positive"  

//Uncircumcised and or dont know circumcision status who were HIV positive
gen hv_uncircum= inlist(v483,0,8) & inrange(hiv03,1,3) if (inlist(v483,0,8) & (inrange(hiv03,1,7) | hiv03==9)) 
label values hv_uncircum yesno
label var hv_uncircum "All uncircumcised or don't know circumcision status men who were HIV positive"
