/*****************************************************************************************************
Program: 			RH_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: Jan 9 2019 by Shireen Assaf 

*Note this do file will produce the following tables in excel:
	1. 	ch9tables_ANCvisits:Contains the tables for ANC provider, ANC skilled provider, 
		ANC number of visits, and timing of ANC visit by background variables
	2.	ch9tables_ANCcomps: Contains tables for all ANC components.
	3.	ch9tables_probs: 	Contains the tables for problems accessing health care
	4.	ch9tables_PNCwm:	Contains the tables for the PNC indicators for women
	5.	ch9tables_Deliv:	Contains the tables for the delivery indicators
	6.	ch9tables_PNCnb:	Contains the tables for PNC indicators for newborns
*****************************************************************************************************/


* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
**************************************************************

* create a log file for reference
	capture log close
	local currdate 	=	date(c(current_date),"DMY")
	local stryear 	= 	string(year(`currdate'))
	local strmonth 	= 	string(month(`currdate'))
	local strday	= 	string(day(`currdate'))
	global date 	= 	"`strmonth'_`strday'_`stryear'"
	di "$date"
	log using RH_tables$date, replace text
********************************************************

gen wt=v005/1000000

* indicators from IR file
if file=="IR" {

log off
* Indicators involving ANC visit: excel file ch9tables_ANCvisits will be produced
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
log off
tabout v025 v106 v024 v190 rh_anc_pv using ch9tables_ANCvists.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Skilled assistance during ANC
log on
*residence
tab v025 rh_anc_pvskill [iw=wt], row nofreq 

*region
tab v024 rh_anc_pvskill [iw=wt], row nofreq 

*education
tab v106 rh_anc_pvskill [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_pvskill [iw=wt], row nofreq 

* output to excel
log off
tabout v025 v106 v024 v190 rh_anc_pvskill using ch9tables_ANCvists.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
// Number of ANC visits in categories
log on
*residence
tab v025 rh_anc_numvs [iw=wt], row nofreq 

*region
tab v024 rh_anc_numvs [iw=wt], row nofreq 

*education
tab v106 rh_anc_numvs [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_numvs [iw=wt], row nofreq 
log off
* output to excel
tabout v025 v106 v024 v190 rh_anc_numvs using ch9tables_ANCvists.xls [iw=wt] , c(row) f(1) append 
*/

* no table for rh_anc4vs. 
****************************************************
// Number of months pregnant before 1st ANC visit
log on
*residence
tab v025 rh_anc_moprg [iw=wt], row nofreq 

*region
tab v024 rh_anc_moprg [iw=wt], row nofreq 

*education
tab v106 rh_anc_moprg [iw=wt], row nofreq 

*wealth
tab v190 rh_anc_moprg [iw=wt], row nofreq 

log off
* output to excel
tabout v025 v106 v024 v190 rh_anc_moprg using ch9tables_ANCvists.xls [iw=wt] , c(row) f(1) append 
*/

* no table for rh_anc4mo. 
****************************************************
* Output for rh_ancmedian, rh_ancmedian_urban rh_ancmedian_rural. These are scalars. 

tabout rh_ancmedian rh_ancmedian_urban rh_ancmedian_rural using ch9tables_ANCvists.xls [iw=wt] , oneway cells(cell) append 

****************************************************

* Indicators involving ANC components: excel file ch9tables_ANCcomps will be produced
*************************************************************************************
//took iron during pregnancy
log on
*residence
tab v025 rh_anciron [iw=wt], row nofreq 

*region
tab v024 rh_anciron [iw=wt], row nofreq 

*education
tab v106 rh_anciron [iw=wt], row nofreq 

*wealth
tab v190 rh_anciron [iw=wt], row nofreq 
log off
* output to excel
tabout v025 v106 v024 v190 rh_anciron using ch9tables_ANCcomps.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//took intestinal parasite drugs during pregnacy
log on
*residence
tab v025 rh_ancparast [iw=wt], row nofreq 

*region
tab v024 rh_ancparast [iw=wt], row nofreq 

*education
tab v106 rh_ancparast [iw=wt], row nofreq 

*wealth
tab v190 rh_ancparast [iw=wt], row nofreq 

log off
* output to excel
tabout v025 v106 v024 v190 rh_ancparast using ch9tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//told of pregnancy complications
log on
*residence
tab v025 rh_ancprgcomp [iw=wt], row nofreq 

*region
tab v024 rh_ancprgcomp [iw=wt], row nofreq 

*education
tab v106 rh_ancprgcomp [iw=wt], row nofreq 

*wealth
tab v190 rh_ancprgcomp [iw=wt], row nofreq 

log off
* output to excel
tabout v025 v106 v024 v190 rh_ancprgcomp using ch9tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//blood pressure was taken during ANC visit
log on
*residence
tab v025 rh_ancbldpres [iw=wt], row nofreq 

*region
tab v024 rh_ancbldpres [iw=wt], row nofreq 

*education
tab v106 rh_ancbldpres [iw=wt], row nofreq 

*wealth
tab v190 rh_ancbldpres [iw=wt], row nofreq 

log off
* output to excel
tabout v025 v106 v024 v190 rh_ancbldpres using ch9tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//urine sample taken during ANC visit
log on
*residence
tab v025 rh_ancurine [iw=wt], row nofreq 

*region
tab v024 rh_ancurine [iw=wt], row nofreq 

*education
tab v106 rh_ancurine [iw=wt], row nofreq 

*wealth
tab v190 rh_ancurine [iw=wt], row nofreq 

log off
* output to excel
tabout v025 v106 v024 v190 rh_ancurine using ch9tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//blood sample taken during ANC visit
log on
*residence
tab v025 rh_ancbldsamp [iw=wt], row nofreq 

*region
tab v024 rh_ancbldsamp [iw=wt], row nofreq 

*education
tab v106 rh_ancbldsamp [iw=wt], row nofreq 

*wealth
tab v190 rh_ancbldsamp [iw=wt], row nofreq 

log off
* output to excel
tabout v025 v106 v024 v190 rh_ancbldsamp using ch9tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//had 2+ tetanus injections
log on
*residence
tab v025 rh_anctoxinj [iw=wt], row nofreq 

*region
tab v024 rh_anctoxinj [iw=wt], row nofreq 

*education
tab v106 rh_anctoxinj [iw=wt], row nofreq 

*wealth
tab v190 rh_anctoxinj [iw=wt], row nofreq 

log off
* output to excel
tabout v025 v106 v024 v190 rh_anctoxinj using ch9tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//protected against neonatal tetanus

*residence
tab v025 rh_ancneotet [iw=wt], row nofreq 

*region
tab v024 rh_ancneotet [iw=wt], row nofreq 

*education
tab v106 rh_ancneotet [iw=wt], row nofreq 

*wealth
tab v190 rh_ancneotet [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_ancneotet using ch9tables_ANCcomps.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************


* Indicators for problems accessing health care: excel file ch9tables_probs will be produced
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
tabout v025 v106 v024 v190 rh_prob_permit using ch9tables_probs.xls [iw=wt] , c(row) f(1) replace 
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
tabout v025 v106 v024 v190 rh_prob_money using ch9tables_probs.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_prob_dist using ch9tables_probs.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_prob_alone using ch9tables_probs.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_prob_minone using ch9tables_probs.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_del_place using ch9tables_Deliv.xls [iw=wt] , c(row) f(1) replace 
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
tabout v025 v106 v024 v190 rh_del_pltype using ch9tables_Deliv.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_del_pv using ch9tables_Deliv.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_del_pv using ch9tables_Deliv.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_del_ces using ch9tables_Deliv.xls [iw=wt] , c(row) f(1) append 
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
tabout v025 v106 v024 v190 rh_del_cestime using ch9tables_Deliv.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//during of stay after delivery

*residence
tab v025 rh_del_stay [iw=wt], row nofreq 

*region
tab v024 rh_del_stay [iw=wt], row nofreq 

*education
tab v106 rh_del_stay [iw=wt], row nofreq 

*wealth
tab v190 rh_del_stay [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v024 v190 rh_del_stay using ch9tables_Deliv.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
}

