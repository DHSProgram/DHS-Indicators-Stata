/*****************************************************************************************************
Program: 			RH_tables.do - DHS8 update
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: Dec 9, 2022 by Shireen Assaf 

*This do file will produce the following tables in excel:
1. 	Tables_ANCvisits:	Contains the tables for ANC provider, ANC skilled provider, ANC number of visits, and timing of ANC visit by background variables
2.	Tables_ANCcomps: 	Contains tables for all ANC components.
3.	Tables_PNC:			Contains the tables for the PNC indicators for women 
4.	Tables_PNCnb:		Contains the tables for the PNC indicators for newborns
5.	Tables_Deliv:		Contains the tables for the delivery indicators
6.	Tables_HLTHwm: 		Contains the tables for women's health indcators and problems seeking healthcare
8.	Tables_Men:			Contains the tables for men's involvement indicators

Notes: Please check the do file notes for description of the denominators and select the denominator of interest below using "select variable". 

	For ANC and PNC indicators, using file variable=NR, default is for recent livebirths. 
	For newborn PNC there is only one denominator for most recent birth which is included in calculation so no need to use select. 
	For delivery indicators, using file variable=NR2, default is all livebirths. 
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from NR file - ANC/PNC denominator
if file=="NR" {
	
cap gen wt=v005/1000000

* three denominators
* recent livebirth 
gen select = m80==1

*recent stillbirths
*gen select = m80==3

* recent livebirths + stillbirths
* keeps if birth is last live birth or last still birth (see notes in main file). 
*gen select = (_n == 1 | caseid != caseid[_n-1])  


* Indicators involving ANC visit: excel file Tables_ANCvisits will be produced
*********************************************************************************
//Person providing assistance during ANC

*residence
tab v025 rh_anc_pv if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_pv if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_pv if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_pv if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_pv using Tables_ANCvists.xls if select==1 [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Skilled assistance during ANC

*residence
tab v025 rh_anc_pvskill if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_pvskill if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_pvskill if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_pvskill if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_pvskill using Tables_ANCvists.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
// Number of ANC visits in categories

*residence
tab v025 rh_anc_numvs if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_numvs if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_numvs if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_numvs if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_numvs using Tables_ANCvists.xls if select==1 [iw=wt] , c(row) f(1) append 
*/

 ****************************************************
// 4+ ANC visits

*residence
tab v025 rh_anc_4vs if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_4vs if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_4vs if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_4vs if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_4vs using Tables_ANCvists.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
// Number of months pregnant before 1st ANC visit

*residence
tab v025 rh_anc_moprg if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_moprg if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_moprg if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_moprg if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_moprg using Tables_ANCvists.xls if select==1 [iw=wt] , c(row) f(1) append 
*/

****************************************************
* Output for rh_ancmedian, rh_ancmedian_urban rh_ancmedian_rural. These are scalars. 

tabout rh_anc_median rh_anc_median_liveb rh_anc_median_stillb using Tables_ANCvists.xls if select==1 [iw=wt] , oneway cells(cell) append 

****************************************************

* Indicators involving ANC components: excel file Tables_ANCcomps will be produced
* For these indicators, there is an additional condition to select for women who have had at least one ANC visit or all women using variable ancany. 
* default below if for all women
*************************************************************************************

****************************************************
//blood pressure was taken during ANC visit

*residence
tab v025 rh_anc_bldpres if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_bldpres if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_bldpres if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_bldpres if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_bldpres using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//urine sample taken during ANC visit

*residence
tab v025 rh_anc_urine if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_urine if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_urine if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_urine if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_urine using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//blood sample taken during ANC visit

*residence
tab v025 rh_anc_bldsamp if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_bldsamp if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_bldsamp if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_bldsamp if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_bldsamp using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Baby's heartbeat was listened for during ANC visit

*residence
tab v025 rh_anc_heartbt if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_heartbt if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_heartbt if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_heartbt if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_heartbt using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Counseled on maternal diet during ANC visit

*residence
tab v025 rh_anc_consldiet if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_consldiet if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_consldiet if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_consldiet if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_consldiet using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Counseled on breastfeeding during ANC visit

*residence
tab v025 rh_anc_conslbf if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_conslbf if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_conslbf if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_conslbf if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_conslbf using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Asked about vaginal bleeding during ANC visit

*residence
tab v025 rh_anc_askvagbleed if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_askvagbleed if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_askvagbleed if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_askvagbleed if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_askvagbleed using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//took iron during pregnancy

*residence
tab v025 rh_anc_iron if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_iron if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_iron if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_iron if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_iron using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//took intestinal parasite drugs during pregnacy

*residence
tab v025 rh_anc_parast if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_parast if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_parast if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_parast if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_parast using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Food/cash assistance

*residence
tab v025 rh_anc_foodcash if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_foodcash if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_foodcash if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_foodcash if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_foodcash using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Number of days took iron

*residence
tab v025 rh_anc_daysiron if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_daysiron if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_daysiron if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_daysiron if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_daysiron using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Source of iron supplements

tab1 rh_anc_ironpl* if select==1 [iw=wt]
tabout  rh_anc_ironpl* using Tables_ANCcomps.xls if select==1 [iw=wt] , c(cell) f(1) append 
****************************************************

//had 2+ tetanus injections

*residence
tab v025 rh_anc_toxinj if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_toxinj if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_toxinj if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_toxinj if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_toxinj using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//protected against neonatal tetanus

*residence
tab v025 rh_anc_neotet if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_anc_neotet if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_anc_neotet if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_neotet if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_neotet using Tables_ANCcomps.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************

* Indicators for PNC indicators
*************************************************************************************
//PNC timing for mother	

*residence
tab v025 rh_pnc_wm_timing if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_timing if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_timing if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_timing if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_timing using Tables_PNC.xls if select==1 [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//PNC within 2days for mother

*residence
tab v025 rh_pnc_wm_2days if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_2days if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_2days if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_2days if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_2days using Tables_PNC.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//PNC provider for mother

*residence
tab v025 rh_pnc_wm_pv if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_pv if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_pv if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_pv if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_pv using Tables_PNC.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
***PNC components for mother ****

//Blood pressure

*residence
tab v025 rh_pnc_wm_bldpres if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_bldpres if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_bldpres if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_bldpres if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_bldpres using Tables_PNC.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Discussed vaginal bleeding

*residence
tab v025 rh_pnc_wm_askvagbleed if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_askvagbleed if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_askvagbleed if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_askvagbleed if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_askvagbleed using Tables_PNC.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Discussed FP

*residence
tab v025 rh_pnc_wm_fp if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_fp if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_fp if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_fp if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_fp using Tables_PNC.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//All three checks

*residence
tab v025 rh_pnc_wm_allchecks if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_allchecks if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_allchecks if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_allchecks if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_allchecks using Tables_PNC.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************

//PNC timing for newborn

*residence
tab v025 rh_pnc_nb_timing [iw=wt], row nofreq 

*region
tab v024 rh_pnc_nb_timing [iw=wt], row nofreq 

*education
tab v106 rh_pnc_nb_timing [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_nb_timing [i w=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_nb_timing using Tables_PNCnb.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//PNC within 2days for newborn

*residence
tab v025 rh_pnc_nb_2days [iw=wt], row nofreq 

*region
tab v024 rh_pnc_nb_2days [iw=wt], row nofreq 

*education
tab v106 rh_pnc_nb_2days [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_nb_2days [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_nb_2days using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//PNC provider for newborn

*residence
tab v025 rh_pnc_nb_pv [iw=wt], row nofreq 

*region
tab v024 rh_pnc_nb_pv [iw=wt], row nofreq 

*education
tab v106 rh_pnc_nb_pv [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_nb_pv [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_nb_pv using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 
*/

****************************************************
//PNC components for newborn

* Examined cord
tabout v025 v106 v024 v190 rh_pnc_nb_cord using Tables_PNCnb.xls [iw=wt] , c(row) f(1) append 

* Measured temp
tabout v025 v106 v024 v190 rh_pnc_nb_temp using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

*Mother told how to recognize danger signs
tabout v025 v106 v024 v190 rh_pnc_nb_dngr using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

*Mother counseled on breastfeeding
tabout v025 v106 v024 v190 rh_pnc_nb_conslbf using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

*Mother observed breastfeeding
tabout v025 v106 v024 v190 rh_pnc_nb_obsbf using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

*Mother counseled and observed breastfeeding
tabout v025 v106 v024 v190 rh_pnc_nb_conslobsbf using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

*Newborn weighed
tabout v025 v106 v024 v190 rh_pnc_nb_weighed using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

*At least 5 signal functions performed
tabout  v025 v106 v024 v190  rh_pnc_nb_5sigfunc using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

****************************************************
*Mother /Newborn PNC combined indicators

//PNC check mother
tabout  v025 v106 v024 v190  rh_pnc_wm_2days using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

//PNC check newborn
tabout  v025 v106 v024 v190  rh_pnc_nb_2days using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

//PNC check mother and newborn
tabout  v025 v106 v024 v190  rh_pnc_bothchecked using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

//Neither mother nor newborn had PNC check
tabout  v025 v106 v024 v190  rh_pnc_bothnotchecked using Tables_PNCnb.xls [iw=wt], c(row) f(1) append 

}


* indicators from NR file - Delivery denominator
if file=="NR2" {
	
cap gen wt=v005/1000000

* three denominators
* livebirth 
gen select = (m80==1 | m80==2)

*recent stillbirths
*gen select = (m80==3 | m80==4)

* livebirths + stillbirths
*gen select = 1 

****************************************************
//place of delivery

*residence
tab v025 rh_del_facil [iw=wt], row nofreq 

*region
tab v024 rh_del_facil if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_del_facil if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_del_facil if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_facil using Tables_Deliv.xls if select==1 [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//type of health facilty

*residence
tab v025 rh_del_pltype if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_del_pltype if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_del_pltype if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_del_pltype if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_pltype using Tables_Deliv.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//type of provider

*residence
tab v025 rh_del_pv if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_del_pv if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_del_pv if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_del_pv if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_pv using Tables_Deliv.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//skilled provider

*residence
tab v025 rh_del_pvskill if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_del_pvskill if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_del_pvskill if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_del_pvskill if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_pvskill using Tables_Deliv.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//skin-to-skin

*residence
tab v025 rh_del_skin if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_del_skin if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_del_skin if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_del_skin if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_skin using Tables_Deliv.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//C-section delivery

*residence
tab v025 rh_del_ces if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_del_ces if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_del_ces if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_del_ces if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_ces using Tables_Deliv.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//C-section delivery timing

*residence
tab v025 rh_del_cestime if select==1 [iw=wt], row nofreq 

*region
tab v024 rh_del_cestime if select==1 [iw=wt], row nofreq 

*education
tab v106 rh_del_cestime if select==1 [iw=wt], row nofreq 

*wealth
tab v190 rh_del_cestime if select==1 [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_cestime using Tables_Deliv.xls if select==1 [iw=wt] , c(row) f(1) append 
*/
****************************************************
//duration of stay after delivery

*Vaginal births
tab rh_del_stay if m17 ==0 & select==1 [iw=wt]

*C-section births
tab rh_del_stay if m17==1 & select==1 [iw=wt]

*Missing
tab rh_del_stay if m17>1 & select==1 [iw=wt]


* output to excel
* Vaginal births
tabout rh_del_stay if  m17 ==0 & select==1 using Tables_Deliv.xls  [iw=wt] , c(cell) f(1) append 

* C-section births
cap tabout rh_del_stay if m17 ==1 & select==1 using Tables_Deliv.xls [iw=wt] , c(cell) f(1) append 

* Missing
cap tabout rh_del_stay if m17 >1 & select==1 using Tables_Deliv.xls [iw=wt] , c(cell) f(1) append 
*/
****************************************************
}



* indicators from IR file
if file=="IR" {
	
cap gen wt=v005/1000000

//Had breast cancer exam
*residence
tab v025 rh_brst_cncr_exam [iw=wt], row nofreq 

*region
tab v024 rh_brst_cncr_exam [iw=wt], row nofreq 

*education
tab v106 rh_brst_cncr_exam [iw=wt], row nofreq 

*wealth
tab v190 rh_brst_cncr_exam [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_brst_cncr_exam using Tables_HLTHwm.xls [iw=wt] , c(row) f(1) replace 


//Had cervical cancer test
*residence
tab v025 rh_cervc_cancr_test [iw=wt], row nofreq 

*region
tab v024 rh_cervc_cancr_test [iw=wt], row nofreq 

*education
tab v106 rh_cervc_cancr_test [iw=wt], row nofreq 

*wealth
tab v190 rh_cervc_cancr_test [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_cervc_cancr_test using Tables_HLTHwm.xls [iw=wt] , c(row) f(1) replace 

********************************************************************************************

//Travel time to health facility
*residence
tab v025 rh_traveltime_hlthfacil [iw=wt], row nofreq 

*region
tab v024 rh_traveltime_hlthfacil [iw=wt], row nofreq 

*education
tab v106 rh_traveltime_hlthfacil [iw=wt], row nofreq 

*wealth
tab v190 rh_traveltime_hlthfacil [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_traveltime_hlthfacil using Tables_HLTHwm.xls [iw=wt] , c(row) f(1) replace 


//Means of transport to health facility
*residence
tab v025 rh_transport_hlthfacil [iw=wt], row nofreq 

*region
tab v024 rh_transport_hlthfacil [iw=wt], row nofreq 

*education
tab v106 rh_transport_hlthfacil [iw=wt], row nofreq 

*wealth
tab v190 rh_transport_hlthfacil [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_transport_hlthfacil using Tables_HLTHwm.xls [iw=wt] , c(row) f(1) replace 

********************************************************************************************
* Indicators for problems accessing health care
********************************************************************************************
//problem permission to go

*residence
tab v025 rh_prob_permit [iw=wt], row nofreq 

*region
tab v024 rh_prob_permit [iw=wt], row nofreq 

*education
tab v106 rh_prob_permit [iw=wt], row nofreq 

*wealth
tab v190 rh_prob_permit [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_prob_permit using Tables_HLTHwm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//problem getting money

*residence
tab v025 rh_prob_money [iw=wt], row nofreq 

*region
tab v024 rh_prob_money [iw=wt], row nofreq 

*education
tab v106 rh_prob_money [iw=wt], row nofreq 

*wealth
tab v190 rh_prob_money [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_prob_money using Tables_HLTHwm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//problem distance

*residence
tab v025 rh_prob_dist [iw=wt], row nofreq 

*region
tab v024 rh_prob_dist [iw=wt], row nofreq 

*education
tab v106 rh_prob_dist [iw=wt], row nofreq 

*wealth
tab v190 rh_prob_dist [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_prob_dist using Tables_HLTHwm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//problem don't want to go alone

*residence
tab v025 rh_prob_alone [iw=wt], row nofreq 

*region
tab v024 rh_prob_alone [iw=wt], row nofreq 

*education
tab v106 rh_prob_alone [iw=wt], row nofreq 

*wealth
tab v190 rh_prob_alone [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_prob_alone using Tables_HLTHwm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//at least one problem

*residence
tab v025 rh_prob_minone [iw=wt], row nofreq 

*region
tab v024 rh_prob_minone [iw=wt], row nofreq 

*education
tab v106 rh_prob_minone [iw=wt], row nofreq 

*wealth
tab v190 rh_prob_minone [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_prob_minone using Tables_HLTHwm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
}


* indicators from MR file
if file=="MR" {
	
cap gen wt=mv005/1000000

* will select for men age 15-49 in tabout

*Men report ANC
tabout mv025 mv106 mv024 mv190 rh_mn_report_anc using Tables_Men.xls [iw=wt] if mv012<50 , c(row) f(1) replace 

*Men presend during ANC
tabout mv025 mv106 mv024 mv190 rh_mn_present_anc using Tables_Men.xls [iw=wt] if mv012<50 , c(row) f(1) replace 

*Men report health facility delivery
tabout mv025 mv106 mv024 mv190 rh_mn_report_delfacil using Tables_Men.xls [iw=wt] if mv012<50 , c(row) f(1) replace 

*Men present in health facility delivery
tabout mv025 mv106 mv024 mv190 rh_mn_present_delfacil using Tables_Men.xls [iw=wt] if mv012<50 , c(row) f(1) replace 
  
}
