/*****************************************************************************************************
Program: 			RH_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: Jan 9 2019 by Shireen Assaf 

*This do file will produce the following tables in excel:
1. 	Tables_ANCvisits:	Contains the tables for ANC provider, ANC skilled provider, ANC number of visits, and timing of ANC visit by background variables
2.	Tables_ANCcomps: 	Contains tables for all ANC components.
3.	Tables_Probs: 		Contains the tables for problems accessing health care
4.	Tables_PNC:			Contains the tables for the PNC indicators for women and newborns
5.	Tables_Deliv:		Contains the tables for the delivery indicators
	
Notes: 	The indicators are outputed for women age 15-49 in line 27. This can be commented out if the indicators are required for all women.	
*****************************************************************************************************/

gen wt=v005/1000000

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file
if file=="IR" {
* limiting to women age 15-49
drop if v012<15 | v012>49

* Indicators involving ANC visit: excel file Tables_ANCvisits will be produced
*********************************************************************************
//Person providing assistance during ANC

*residence
tab v025 rh_anc_pv [iw=wt], row nofreq 

*region
tab v024 rh_anc_pv [iw=wt], row nofreq 

*education
tab v106 rh_anc_pv [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_pv [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_pv using Tables_ANCvists.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Skilled assistance during ANC

*residence
tab v025 rh_anc_pvskill [iw=wt], row nofreq 

*region
tab v024 rh_anc_pvskill [iw=wt], row nofreq 

*education
tab v106 rh_anc_pvskill [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_pvskill [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_pvskill using Tables_ANCvists.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
// Number of ANC visits in categories

*residence
tab v025 rh_anc_numvs [iw=wt], row nofreq 

*region
tab v024 rh_anc_numvs [iw=wt], row nofreq 

*education
tab v106 rh_anc_numvs [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_numvs [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_numvs using Tables_ANCvists.xls [iw=wt] , c(row) f(1) append 
*/

* no table for rh_anc_4vs. 
****************************************************
// Number of months pregnant before 1st ANC visit

*residence
tab v025 rh_anc_moprg [iw=wt], row nofreq 

*region
tab v024 rh_anc_moprg [iw=wt], row nofreq 

*education
tab v106 rh_anc_moprg [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_moprg [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_moprg using Tables_ANCvists.xls [iw=wt] , c(row) f(1) append 
*/

* no table for rh_anc_4mo. 
****************************************************
* Output for rh_ancmedian, rh_ancmedian_urban rh_ancmedian_rural. These are scalars. 

tabout rh_anc_median rh_anc_median_urban rh_anc_median_rural using Tables_ANCvists.xls [iw=wt] , oneway cells(cell) append 

****************************************************

* Indicators involving ANC components: excel file Tables_ANCcomps will be produced
*************************************************************************************
//took iron during pregnancy

*residence
tab v025 rh_anc_iron [iw=wt], row nofreq 

*region
tab v024 rh_anc_iron [iw=wt], row nofreq 

*education
tab v106 rh_anc_iron [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_iron [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_iron using Tables_ANCcomps.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//took intestinal parasite drugs during pregnacy

*residence
tab v025 rh_anc_parast [iw=wt], row nofreq 

*region
tab v024 rh_anc_parast [iw=wt], row nofreq 

*education
tab v106 rh_anc_parast [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_parast [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_parast using Tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//told of pregnancy complications

*residence
tab v025 rh_anc_prgcomp [iw=wt], row nofreq 

*region
tab v024 rh_anc_prgcomp [iw=wt], row nofreq 

*education
tab v106 rh_anc_prgcomp [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_prgcomp [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_prgcomp using Tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//blood pressure was taken during ANC visit

*residence
tab v025 rh_anc_bldpres [iw=wt], row nofreq 

*region
tab v024 rh_anc_bldpres [iw=wt], row nofreq 

*education
tab v106 rh_anc_bldpres [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_bldpres [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_bldpres using Tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//urine sample taken during ANC visit

*residence
tab v025 rh_anc_urine [iw=wt], row nofreq 

*region
tab v024 rh_anc_urine [iw=wt], row nofreq 

*education
tab v106 rh_anc_urine [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_urine [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_urine using Tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//blood sample taken during ANC visit

*residence
tab v025 rh_anc_bldsamp [iw=wt], row nofreq 

*region
tab v024 rh_anc_bldsamp [iw=wt], row nofreq 

*education
tab v106 rh_anc_bldsamp [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_bldsamp [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_bldsamp using Tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//had 2+ tetanus injections

*residence
tab v025 rh_anc_toxinj [iw=wt], row nofreq 

*region
tab v024 rh_anc_toxinj [iw=wt], row nofreq 

*education
tab v106 rh_anc_toxinj [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_toxinj [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_toxinj using Tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//protected against neonatal tetanus

*residence
tab v025 rh_anc_neotet [iw=wt], row nofreq 

*region
tab v024 rh_anc_neotet [iw=wt], row nofreq 

*education
tab v106 rh_anc_neotet [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_neotet [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_anc_neotet using Tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************

* Indicators for PNC indicators
*************************************************************************************
//PNC timing for mother	

*residence
tab v025 rh_pnc_wm_timing [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_timing [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_timing [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_timing [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_timing using Tables_PNC.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//PNC within 2days for mother

*residence
tab v025 rh_pnc_wm_2days [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_2days [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_2days [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_2days [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_2days using Tables_PNC.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//PNC provider for mother

*residence
tab v025 rh_pnc_wm_pv [iw=wt], row nofreq 

*region
tab v024 rh_pnc_wm_pv [iw=wt], row nofreq 

*education
tab v106 rh_pnc_wm_pv [iw=wt], row nofreq 

*wealth
tab v190 rh_pnc_wm_pv [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_wm_pv using Tables_PNC.xls [iw=wt] , c(row) f(1) append 
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
tab v190 rh_pnc_nb_timing [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_pnc_nb_timing using Tables_PNC.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_pnc_nb_2days using Tables_PNC.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_pnc_nb_pv using Tables_PNC.xls [iw=wt] , c(row) f(1) append 
*/


* Indicators for problems accessing health care: excel file Tables_Probs will be produced
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
tabout v025 v106 v024 v190 rh_prob_permit using Tables_Probs.xls [iw=wt] , c(row) f(1) replace 
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
tabout v025 v106 v024 v190 rh_prob_money using Tables_Probs.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_prob_dist using Tables_Probs.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_prob_alone using Tables_Probs.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_prob_minone using Tables_Probs.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************

}

****************************************************************************
****************************************************************************

* indicators from BR file
if file=="BR" {
****************************************************
//place of delivery

*residence
tab v025 rh_del_place [iw=wt], row nofreq 

*region
tab v024 rh_del_place [iw=wt], row nofreq 

*education
tab v106 rh_del_place [iw=wt], row nofreq 

*wealth
tab v190 rh_del_place [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_place using Tables_Deliv.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//type of health facilty

*residence
tab v025 rh_del_pltype [iw=wt], row nofreq 

*region
tab v024 rh_del_pltype [iw=wt], row nofreq 

*education
tab v106 rh_del_pltype [iw=wt], row nofreq 

*wealth
tab v190 rh_del_pltype [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_pltype using Tables_Deliv.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//type of provider

*residence
tab v025 rh_del_pv [iw=wt], row nofreq 

*region
tab v024 rh_del_pv [iw=wt], row nofreq 

*education
tab v106 rh_del_pv [iw=wt], row nofreq 

*wealth
tab v190 rh_del_pv [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_pv using Tables_Deliv.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//skilled provider

*residence
tab v025 rh_del_pv [iw=wt], row nofreq 

*region
tab v024 rh_del_pv [iw=wt], row nofreq 

*education
tab v106 rh_del_pv [iw=wt], row nofreq 

*wealth
tab v190 rh_del_pv [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_pv using Tables_Deliv.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//C-section delivery

*residence
tab v025 rh_del_ces [iw=wt], row nofreq 

*region
tab v024 rh_del_ces [iw=wt], row nofreq 

*education
tab v106 rh_del_ces [iw=wt], row nofreq 

*wealth
tab v190 rh_del_ces [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_ces using Tables_Deliv.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//C-section delivery timing

*residence
tab v025 rh_del_cestime [iw=wt], row nofreq 

*region
tab v024 rh_del_cestime [iw=wt], row nofreq 

*education
tab v106 rh_del_cestime [iw=wt], row nofreq 

*wealth
tab v190 rh_del_cestime [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_cestime using Tables_Deliv.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//during of stay after delivery

*Vaginal births
tab rh_del_stay if rh_del_cestime ==0 [iw=wt]

*C-section births
tab rh_del_stay if rh_del_cestime !=0 [iw=wt]


* output to excel
* Vaginal births
tabout rh_del_stay if rh_del_cestime ==0 using Tables_Deliv.xls [iw=wt] , c(cell) f(1) append 

* C-section births
* For older surveys the indicator rh_del_cestime is not available so this tabout would not produce results.
cap tabout rh_del_stay if rh_del_cestime !=0 using Tables_Deliv.xls [iw=wt] , c(cell) f(1) append 
*/
****************************************************
}

