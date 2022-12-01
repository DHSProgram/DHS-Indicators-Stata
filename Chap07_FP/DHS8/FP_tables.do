/*****************************************************************************************************
Program: 			FP_tables.do
Purpose: 			produce tables for indicators - DHS8 update
Author:				Shireen Assaf
Date last modified: November 8, 2022 by Shireen Assaf 

*This do file will produce the following tables in excel:
1. 	Tables_Know_wm:		Contains the tables for knowledge indicators for women
2. 	Tables_Know_mn:		Contains the tables for knowledge indicators for men
3. 	Tables_Use_ev:		Contains the tables for ever use of family planning for women
4. 	Tables_Use_cr:		Contains the tables for current use of family planning for women + timing of sterlization
5.	Tables_source_info:	Contains the tables for source of family planning method, brands used, and information given about the method for women
6.	Tables_Need:		Contains the tables for unmet need, met need, demand satisfied, and future intention to use for women
7.	Tables_Communicat:	Contains the tables for decision on use/nonuse and discussions for women
8. 	Tables_message_wn:  Contains the tables for exposure for FP messages for women
8.  Tables_message_mn:	Contains the tables for exposure for FP messages for men

Notes: 	For knowledge of contraceptive methods, ever use, current use, and unmet need variables, the population of
		interest can be selected (all women, currently married women, and sexually active women).
		The remaining indicators are reported for currently married women.
						
		For men, the population of interest can also be selected for the knowledge of methods variables. 
						
		Make the selection of the population of interest below for IR (line 40) and MR (line 1608) files. 
						
		For women and men the indicators are outputed for age 15-49 in line 36 and 1604. This can be commented out if the indicators are required for all women/men.
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file
if file=="IR" {
* limiting to women age 15-49
drop if v012<15 | v012>49

cap gen wt=v005/1000000

** Select population of interest

	/*all women
	cap drop select
	gen select=1
	*/

	*currently married women
	cap drop select
	gen select=v502==1
	*/

	/*sexually active unmarried women
	cap drop select
	gen select=0
	replace select=1 if v502!=1 & v528<=30
	*/

**************************************************************************************************
* Indicators for knowleldege of contraceptive methods: excel file Tables_Know_wm will be produced
**************************************************************************************************
//Knowledge of each method

tab1	fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp ///
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy ///
		fp_know_wthd fp_know_other if select==1 [iw=wt] 
		
tab1 fp_know_mean_all fp_know_mean_mar fp_know_mean_sexactv [iw=wt]

* output to excel
tabout 	fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp ///
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy ///
		fp_know_wthd fp_know_other if select==1 using Tables_Know_wm.xls [iw=wt] , oneway cells(cell) f(1) replace 
		
tabout fp_know_mean_all fp_know_mean_mar fp_know_mean_sexactv using Tables_Know_wm.xls [iw=wt] , oneway cells(cell) append 

*/
****************************************************
//Knowledge of any method by background variables

*age
tab v013 fp_know_any if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_know_any if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_know_any if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_know_any if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_know_any if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_know_any if select==1 using Tables_Know_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Knowledge of modern method by background variables

*age
tab v013 fp_know_mod if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_know_mod if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_know_mod if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_know_mod if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_know_mod if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_know_mod if select==1 using Tables_Know_wm.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Knowledge of fertile period
tab1	fp_know_fert_all fp_know_fert_rhy fp_know_fert_sdm [iw=wt] 

* output to excel
tabout	fp_know_fert_all fp_know_fert_rhy fp_know_fert_sdm using Tables_Know_wm.xls [iw=wt] , oneway cells(cell) f(1) append 

//Correct nowledge of fertile period
tab	v013 fp_know_fert_cor [iw=wt], row nofreq 	

* output to excel
tabout v013 fp_know_fert_cor using Tables_Know_wm.xls [iw=wt] , c(row) f(1) append 


**************************************************************************************************
* Indicators for current use of contraceptive methods: excel file Tables_Use_cr will be produced
**************************************************************************************************

//Currently using any by background variables

*age
tab v013 fp_cruse_any if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_any if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_any if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_any if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_any if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_any if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Currently using modern by background variables

*age
tab v013 fp_cruse_mod if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_mod if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_mod if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_mod if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_mod if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_mod if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Currently using female sterlization by background variables

*age
tab v013 fp_cruse_fster if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_fster if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_fster if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_fster if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_fster if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_fster if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using male sterlization by background variables

*age
tab v013 fp_cruse_mster if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_mster if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_mster if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_mster if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_mster if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_mster if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using pill by background variables

*age
tab v013 fp_cruse_pill if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_pill if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_pill if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_pill if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_pill if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_pill if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using IUD by background variables

*age
tab v013 fp_cruse_iud if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_iud if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_iud if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_iud if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_iud if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_iud if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using injectables by background variables

*age
tab v013 fp_cruse_inj if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_inj if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_inj if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_inj if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_inj if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_inj if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using implants by background variables

*age
tab v013 fp_cruse_imp if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_imp if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_imp if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_imp if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_imp if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_imp if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using male condoms by background variables

*age
tab v013 fp_cruse_mcond if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_mcond if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_mcond if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_mcond if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_mcond if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_mcond if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using female condoms by background variables

*age
tab v013 fp_cruse_fcond if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_fcond if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_fcond if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_fcond if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_fcond if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_fcond if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using diaphragm by background variables

*age
tab v013 fp_cruse_diaph if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_diaph if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_diaph if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_diaph if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_diaph if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_diaph if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using LAM by background variables

*age
tab v013 fp_cruse_lam if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_lam if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_lam if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_lam if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_lam if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_lam if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using emergency contraceptive by background variables

*age
tab v013 fp_cruse_ec if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_ec if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_ec if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_ec if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_ec if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_ec if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using other moden method by background variables

*age
tab v013 fp_cruse_omod if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_omod if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_omod if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_omod if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_omod if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_omod if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using traditional method by background variables

*age
tab v013 fp_cruse_trad if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_trad if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_trad if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_trad if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_trad if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_trad if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using rhythm by background variables

*age
tab v013 fp_cruse_rhy if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_rhy if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_rhy if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_rhy if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_rhy if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_rhy if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using withdrawal by background variables

*age
tab v013 fp_cruse_wthd if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_wthd if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_wthd if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_wthd if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_wthd if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_wthd if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently using other method by background variables

*age
tab v013 fp_cruse_other if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_other if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_cruse_other if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_cruse_other if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_other if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_other if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Not currently using

*age
tab v013 fp_not_cruse if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_not_cruse if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_not_cruse if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_not_cruse if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_not_cruse if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_not_cruse if select==1 using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Currently using DMPA-SC/Sayana Press among injectable users
*Tabulated for all women

*age
tab v013 fp_inj_dmpa [iw=wt], row nofreq 

*residence
tab v025 fp_inj_dmpa [iw=wt], row nofreq 

*region
tab v024 fp_inj_dmpa [iw=wt], row nofreq 

*education
tab v106 fp_inj_dmpa [iw=wt], row nofreq 

*wealth
tab v190 fp_inj_dmpa [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_inj_dmpa using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Person administering the DMPA-SC/Sayana Press injection
*Tabulated for all women

*age
tab v013 fp_inj_dmpa_pr [iw=wt], row nofreq 

*residence
tab v025 fp_inj_dmpa_pr [iw=wt], row nofreq 

*region
tab v024 fp_inj_dmpa_pr [iw=wt], row nofreq 

*education
tab v106 fp_inj_dmpa_pr [iw=wt], row nofreq 

*wealth
tab v190 fp_inj_dmpa_pr [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_inj_dmpa_pr using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Used emergency contraception in the last 12 months
*Tabulated for all women

*age
tab v013 fp_cruse_ec_12mo [iw=wt], row nofreq 

*residence
tab v025 fp_cruse_ec_12mo [iw=wt], row nofreq 

*region
tab v024 fp_cruse_ec_12mo [iw=wt], row nofreq 

*education
tab v106 fp_cruse_ec_12mo [iw=wt], row nofreq 

*wealth
tab v190 fp_cruse_ec_12mo [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_cruse_ec_12mo using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Timing of sterlization

tab v319 fp_ster_age [iw=wt], row nofreq

* output to excel
cap tabout v319 fp_ster_age using Tables_Use_cr.xls [iw=wt] , c(row) f(1) append 

//Median age at sterlization
cap tabout fp_ster_median using Tables_Use_cr.xls [iw=wt] , oneway cells(cell) append 

**************************************************************************************************
* Indicators for source and info. contraceptive methods: excel file Tables_source_info will be produced
**************************************************************************************************
//Source of contraception for main modern methods and total

tab1 fp_source_fster fp_source_iud fp_source_inj fp_source_imp fp_source_pill fp_source_mcond fp_source_tot [iw=wt] 

* output to excel
cap tabout	fp_source_fster using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) replace 
tabout  fp_source_iud fp_source_inj fp_source_imp fp_source_pill fp_source_mcond fp_source_tot ///
		using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) append 

****************************************************
//Pill users using a brand
* country-specific variable. Recode to a binary variable to match the final report.

*age
tab v013 fp_brand_pill [iw=wt], row nofreq 

*residence
tab v025 fp_brand_pill [iw=wt], row nofreq 

*region
tab v024 fp_brand_pill [iw=wt], row nofreq 

*education
tab v106 fp_brand_pill [iw=wt], row nofreq 

*wealth
tab v190 fp_brand_pill [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_brand_pill using Tables_source_info.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Condom users using a brand
* country-specific variable. Recode to a binary variable to match the final report.

*age
tab v013 fp_brand_cond [iw=wt], row nofreq 

*residence
tab v025 fp_brand_cond [iw=wt], row nofreq 

*region
tab v024 fp_brand_cond [iw=wt], row nofreq 

*education
tab v106 fp_brand_cond [iw=wt], row nofreq 

*wealth
tab v190 fp_brand_cond [iw=wt], row nofreq 

* output to excel
cap tabout v013 v025 v106 v024 v190 fp_brand_cond using Tables_source_info.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Informed of side effects

*female sterlization users
tab fp_info_sideff if v312==6 [iw=wt]

*pill users
tab fp_info_sideff if v312==1 [iw=wt]

*IUD users
tab fp_info_sideff if v312==2 [iw=wt]

*Injectables users
tab fp_info_sideff if v312==3 [iw=wt]

*Implant users
tab fp_info_sideff if v312==11 [iw=wt]

*by source of method (may need to recode, country specific)
tab fp_source_tot fp_info_sideff [iw=wt], row nofreq 

* output to excel 
tabout	fp_info_sideff if v312==6  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(female_ster_users) append 
tabout	fp_info_sideff if v312==2  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(IUD_users) append 
tabout	fp_info_sideff if v312==3  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(inject_users) append 
tabout	fp_info_sideff if v312==11 using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(implant_users) append 
tabout	fp_info_sideff if v312==1  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(pill_users) append 
tabout  fp_source_tot fp_info_sideff using Tables_source_info.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Informed of what to do if experienced side effects

*female sterlization users
tab fp_info_what_to_do if v312==6 [iw=wt]

*pill users
tab fp_info_what_to_do if v312==1 [iw=wt]

*IUD users
tab fp_info_what_to_do if v312==2 [iw=wt]

*Injectables users
tab fp_info_what_to_do if v312==3 [iw=wt]

*Implant users
tab fp_info_what_to_do if v312==11 [iw=wt]

*by source of method (may need to recode, country specific)
tab fp_source_tot fp_info_what_to_do [iw=wt], row nofreq 

* output to excel 
tabout	fp_info_what_to_do if v312==6  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(female_ster_users) append 
tabout	fp_info_what_to_do if v312==2  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(IUD_users) append 
tabout	fp_info_what_to_do if v312==3  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(inject_users) append 
tabout	fp_info_what_to_do if v312==11 using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(implant_users) append 
tabout	fp_info_what_to_do if v312==1  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(pill_users) append 
tabout  fp_source_tot fp_info_what_to_do using Tables_source_info.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Informed of other methods

*female sterlization users
tab fp_info_other_meth if v312==6 [iw=wt]

*pill users
tab fp_info_other_meth if v312==1 [iw=wt]

*IUD users
tab fp_info_other_meth if v312==2 [iw=wt]

*Injectables users
tab fp_info_other_meth if v312==3 [iw=wt]

*Implant users
tab fp_info_other_meth if v312==11 [iw=wt]

*by source of method (may need to recode, country specific)
tab fp_source_tot fp_info_other_meth [iw=wt], row nofreq 

* output to excel 
tabout	fp_info_other_meth if v312==6  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(female_ster_users) append 
tabout	fp_info_other_meth if v312==2  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(IUD_users) append 
tabout	fp_info_other_meth if v312==3  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(inject_users) append 
tabout	fp_info_other_meth if v312==11 using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(implant_users) append 
tabout	fp_info_other_meth if v312==1  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(pill_users) append 
tabout  fp_source_tot fp_info_other_meth using Tables_source_info.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Informed of all three (Method Information Mix)

*female sterlization users
tab fp_info_all if v312==6 [iw=wt]

*pill users
tab fp_info_all if v312==1 [iw=wt]

*IUD users
tab fp_info_all if v312==2 [iw=wt]

*Injectables users
tab fp_info_all if v312==3 [iw=wt]

*Implant users
tab fp_info_all if v312==11 [iw=wt]

*by source of method (may need to recode, country specific)
tab fp_source_tot fp_info_all [iw=wt], row nofreq 

* output to excel 
tabout	fp_info_all if v312==6  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(female_ster_users) append 
tabout	fp_info_all if v312==2  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(IUD_users) append 
tabout	fp_info_all if v312==3  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(inject_users) append 
tabout	fp_info_all if v312==11 using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(implant_users) append 
tabout	fp_info_all if v312==1  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(pill_users) append 
tabout  fp_source_tot fp_info_all using Tables_source_info.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Informed that they could switch if needed 

*female sterlization users
tab fp_info_switch if v312==6 [iw=wt]

*pill users
tab fp_info_switch if v312==1 [iw=wt]

*IUD users
tab fp_info_switch if v312==2 [iw=wt]

*Injectables users
tab fp_info_switch if v312==3 [iw=wt]

*Implant users
tab fp_info_switch if v312==11 [iw=wt]

*by source of method (may need to recode, country specific)
tab fp_source_tot fp_info_switch [iw=wt], row nofreq 

* output to excel 
tabout	fp_info_switch if v312==6  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(female_ster_users) append 
tabout	fp_info_switch if v312==2  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(IUD_users) append 
tabout	fp_info_switch if v312==3  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(inject_users) append 
tabout	fp_info_switch if v312==11 using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(implant_users) append 
tabout	fp_info_switch if v312==1  using Tables_source_info.xls [iw=wt] , oneway cells(cell) f(1) clab(pill_users) append 
tabout  fp_source_tot fp_info_switch using Tables_source_info.xls [iw=wt] , c(row) f(1) append 


**************************************************************************************************
* Indicators for unmet, met, demand satisfied and intention to use: excel file Tables_Need will be produced
* Note: you can produce the same tables for all women and sexually active women not currently in a union. The default selection is women in a union. 
**************************************************************************************************
****************************************************
//Unmet for spacing

*age
tab v013 fp_unmet_space if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_unmet_space if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_unmet_space if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_unmet_space if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_unmet_space if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_unmet_space if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) replace 
*/

****************************************************
//Unmet for limiting

*age
tab v013 fp_unmet_limit if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_unmet_limit if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_unmet_limit if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_unmet_limit if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_unmet_limit if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_unmet_limit if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Unmet for total

*age
tab v013 fp_unmet_tot if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_unmet_tot if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_unmet_tot if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_unmet_tot if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_unmet_tot if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_unmet_tot if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Met for spacing

*age
tab v013 fp_met_space if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_met_space if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_met_space if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_met_space if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_met_space if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_met_space if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Met for limiting

*age
tab v013 fp_met_limit if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_met_limit if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_met_limit if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_met_limit if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_met_limit if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_met_limit if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Met total

*age
tab v013 fp_met_tot if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_met_tot if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_met_tot if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_met_tot if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_met_tot if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_met_tot if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Demand for spacing

*age
tab v013 fp_demand_space if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_demand_space if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_demand_space if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_demand_space if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_demand_space if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_demand_space if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Demand for limiting

*age
tab v013 fp_demand_limit if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_demand_limit if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_demand_limit if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_demand_limit if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_demand_limit if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_demand_limit if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Demand total

*age
tab v013 fp_demand_tot if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_demand_tot if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_demand_tot if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_demand_tot if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_demand_tot if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_demand_tot if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Demand satisfied by modern methods

*age
tab v013 fp_demsat_mod if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_demsat_mod if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_demsat_mod if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_demsat_mod if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_demsat_mod if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_demsat_mod if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Demand satisfied by any method

*age
tab v013 fp_demsat_any if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_demsat_any if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_demsat_any if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_demsat_any if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_demsat_any if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_demsat_any if select==1 using Tables_Need.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Future intention to use

*recode number of living children
recode v219 (0=0 "0") (1=1 "1") (2=2 "2") (3=3 "3") (4/50=4 "4+"), gen(numchild)

tab fp_future_use numchild if v502==1 [iw=wt], col nofreq

* output to excel
tabout fp_future_use  numchild if v502==1 using Tables_Need.xls [iw=wt] , c(col) f(1) append 
*/

**************************************************************************************************
* Indicators for family planning messages: excel file Tables_message_wn will be produced
**************************************************************************************************
****************************************************
//FP messages by radio

*age
tab v013 fp_message_radio [iw=wt], row nofreq 

*residence
tab v025 fp_message_radio [iw=wt], row nofreq 

*region
tab v024 fp_message_radio [iw=wt], row nofreq 

*education
tab v106 fp_message_radio [iw=wt], row nofreq 

*wealth
tab v190 fp_message_radio [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_message_radio using Tables_message_wn.xls [iw=wt] , c(row) f(1) replace 
*/

****************************************************
//FP messages by TV

*age
tab v013 fp_message_tv [iw=wt], row nofreq 

*residence
tab v025 fp_message_tv [iw=wt], row nofreq 

*region
tab v024 fp_message_tv [iw=wt], row nofreq 

*education
tab v106 fp_message_tv [iw=wt], row nofreq 

*wealth
tab v190 fp_message_tv [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_message_tv using Tables_message_wn.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//FP messages by paper

*age
tab v013 fp_message_paper [iw=wt], row nofreq 

*residence
tab v025 fp_message_paper [iw=wt], row nofreq 

*region
tab v024 fp_message_paper [iw=wt], row nofreq 

*education
tab v106 fp_message_paper [iw=wt], row nofreq 

*wealth
tab v190 fp_message_paper [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_message_paper using Tables_message_wn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by mobile

*age
tab v013 fp_message_mobile [iw=wt], row nofreq 

*residence
tab v025 fp_message_mobile [iw=wt], row nofreq 

*region
tab v024 fp_message_mobile [iw=wt], row nofreq 

*education
tab v106 fp_message_mobile [iw=wt], row nofreq 

*wealth
tab v190 fp_message_mobile [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_message_mobile using Tables_message_wn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by social media

*age
tab v013 fp_message_socialm [iw=wt], row nofreq 

*residence
tab v025 fp_message_socialm [iw=wt], row nofreq 

*region
tab v024 fp_message_socialm [iw=wt], row nofreq 

*education
tab v106 fp_message_socialm [iw=wt], row nofreq 

*wealth
tab v190 fp_message_socialm [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_message_socialm using Tables_message_wn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by poster/leaflet/brochure

*age
tab v013 fp_message_poster [iw=wt], row nofreq 

*residence
tab v025 fp_message_poster [iw=wt], row nofreq 

*region
tab v024 fp_message_poster [iw=wt], row nofreq 

*education
tab v106 fp_message_poster [iw=wt], row nofreq 

*wealth
tab v190 fp_message_poster [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_message_poster using Tables_message_wn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by outdoor sign/billboard

*age
tab v013 fp_message_signs [iw=wt], row nofreq 

*residence
tab v025 fp_message_signs [iw=wt], row nofreq 

*region
tab v024 fp_message_signs [iw=wt], row nofreq 

*education
tab v106 fp_message_signs [iw=wt], row nofreq 

*wealth
tab v190 fp_message_signs [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_message_signs using Tables_message_wn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by community meetings/events

*age
tab v013 fp_message_comnty [iw=wt], row nofreq 

*residence
tab v025 fp_message_comnty [iw=wt], row nofreq 

*region
tab v024 fp_message_comnty [iw=wt], row nofreq 

*education
tab v106 fp_message_comnty [iw=wt], row nofreq 

*wealth
tab v190 fp_message_comnty [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_message_comnty using Tables_message_wn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages none of eight

*age
tab v013 fp_message_noneof8 [iw=wt], row nofreq 

*residence
tab v025 fp_message_noneof8 [iw=wt], row nofreq 

*region
tab v024 fp_message_noneof8 [iw=wt], row nofreq 

*education
tab v106 fp_message_noneof8 [iw=wt], row nofreq 

*wealth
tab v190 fp_message_noneof8 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_message_noneof8 using Tables_message_wn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
**************************************************************************************************
* Indicators for FP decisions, and discussion: excel file Tables_Communicat will be produced
**************************************************************************************************

*recode number of living children
recode v219 (0=0 "0") (1/2=1 " 1-2") (3/4=2 " 3-4") (4/max=3 "5+"), gen(numchild2)

*FP use
recode v313 (0=0 "Not currently using") (1/3=1 "Currently using"), gen(fpuse)

//Decide to use FP among users

*age
tab v013 fp_dec_who [iw=wt], row nofreq 

*FP use
tab fpuse fp_dec_who [iw=wt], row nofreq 

*Number of living children
tab numchild2 fp_dec_who [iw=wt], row nofreq 

*residence
tab v025 fp_dec_who [iw=wt], row nofreq 

*region
tab v024 fp_dec_who [iw=wt], row nofreq 

*education
tab v106 fp_dec_who [iw=wt], row nofreq 

*wealth
tab v190 fp_dec_who [iw=wt], row nofreq 

* output to excel
tabout v013 fpuse numchild2 v025 v106 v024 v190 fp_dec_who using Tables_Communicat.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Woman participated in decisionmaking about family planning

*age
tab v013 fp_dec_wm [iw=wt], row nofreq 

*FP use
tab fpuse fp_dec_wm [iw=wt], row nofreq 

*Number of living children
tab numchild2 fp_dec_wm [iw=wt], row nofreq 

*residence
tab v025 fp_dec_wm [iw=wt], row nofreq 

*region
tab v024 fp_dec_wm [iw=wt], row nofreq 

*education
tab v106 fp_dec_wm [iw=wt], row nofreq 

*wealth
tab v190 fp_dec_wm [iw=wt], row nofreq 

* output to excel
tabout v013 fpuse numchild2 v025 v106 v024 v190 fp_dec_wm using Tables_Communicat.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Woman pressured to become pregnant

*age
tab v013 fp_preg_pressure [iw=wt], row nofreq 

*FP use
tab fpuse fp_preg_pressure [iw=wt], row nofreq 

*Number of living children
tab numchild2 fp_preg_pressure [iw=wt], row nofreq 

*residence
tab v025 fp_preg_pressure [iw=wt], row nofreq 

*region
tab v024 fp_preg_pressure [iw=wt], row nofreq 

*education
tab v106 fp_preg_pressure [iw=wt], row nofreq 

*wealth
tab v190 fp_preg_pressure [iw=wt], row nofreq 

* output to excel
tabout v013 fpuse numchild2 v025 v106 v024 v190 fp_preg_pressure using Tables_Communicat.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Discussing FP during visit from FP worker

*age
tab v013 fp_fpvisit_discuss [iw=wt], row nofreq 

*residence
tab v025 fp_fpvisit_discuss [iw=wt], row nofreq 

*region
tab v024 fp_fpvisit_discuss [iw=wt], row nofreq 

*education
tab v106 fp_fpvisit_discuss [iw=wt], row nofreq 

*wealth
tab v190 fp_fpvisit_discuss [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_fpvisit_discuss using Tables_Communicat.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Discussing FP during visit to health facility

*age
tab v013 fp_hf_discuss [iw=wt], row nofreq 

*residence
tab v025 fp_hf_discuss [iw=wt], row nofreq 

*region
tab v024 fp_hf_discuss [iw=wt], row nofreq 

*education
tab v106 fp_hf_discuss [iw=wt], row nofreq 

*wealth
tab v190 fp_hf_discuss [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_hf_discuss using Tables_Communicat.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Did not discuss FP during visit to health facility

*age
tab v013 fp_hf_notdiscuss [iw=wt], row nofreq 

*residence
tab v025 fp_hf_notdiscuss [iw=wt], row nofreq 

*region
tab v024 fp_hf_notdiscuss [iw=wt], row nofreq 

*education
tab v106 fp_hf_notdiscuss [iw=wt], row nofreq 

*wealth
tab v190 fp_hf_notdiscuss [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_hf_notdiscuss using Tables_Communicat.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Did not discuss FP during visit to health facility or with FP worker

*age
tab v013 fp_any_notdiscuss [iw=wt], row nofreq 

*residence
tab v025 fp_any_notdiscuss [iw=wt], row nofreq 

*region
tab v024 fp_any_notdiscuss [iw=wt], row nofreq 

*education
tab v106 fp_any_notdiscuss [iw=wt], row nofreq 

*wealth
tab v190 fp_any_notdiscuss [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_any_notdiscuss using Tables_Communicat.xls [iw=wt] , c(row) f(1) append 
*/

}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {
* limiting to men age 15-49
drop if mv012<15 | mv012>49

gen wt=mv005/1000000

** Select population of interest

	/*all men
	cap drop select
	gen select=1
	*/

	*currently married men
	cap drop select
	gen select=mv502==1
	*/

	/*sexually active unmarried men
	cap drop select
	gen select=0
	replace select=1 if mv502!=1 & mv528<=30
	*/
	
**************************************************************************************************
* Indicators for knowleldege of contraceptive methods: excel file Tables_Know_mn will be produced
**************************************************************************************************
//Knowledge of each method

* selected men 15-49

tab1	fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp ///
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy ///
		fp_know_wthd fp_know_other if select==1 & mv013<8 [iw=wt] 

tab1 fp_know_mean_all fp_know_mean_mar fp_know_mean_sexactv [iw=wt]		

* output to excel
tabout 	fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp ///
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy ///
		fp_know_wthd fp_know_other if select==1 & mv013<8 using Tables_Know_mn.xls [iw=wt] , oneway cells(cell) f(1) replace 
		
tabout fp_know_mean_all fp_know_mean_mar fp_know_mean_sexactv using Tables_Know_mn.xls [iw=wt] , oneway cells(cell) append 

*/
****************************************************
//Knowledge of any method by background variables

*age
tab mv013 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

*residence
tab mv025 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

*region
tab mv024 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

*education
tab mv106 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

*wealth
tab mv190 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fp_know_any if select==1 & mv013<8 using Tables_Know_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Knowledge of modern method by background variables

*age
tab mv013 fp_know_mod if select==1 & mv013<8 [iw=wt], row nofreq 

*residence
tab mv025 fp_know_mod if select==1 & mv013<8 [iw=wt], row nofreq 

*region
tab mv024 fp_know_mod if select==1 & mv013<8 [iw=wt], row nofreq 

*education
tab mv106 fp_know_mod if select==1 & mv013<8 [iw=wt], row nofreq 

*wealth
tab mv190 fp_know_mod if select==1 & mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fp_know_mod if select==1 & mv013<8 using Tables_Know_mn.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Indicators for messages: excel file Tables_message_mn will be produced
**************************************************************************************************

** selected men 15-49

****************************************************
//FP messages by radio

*age
tab mv013 fp_message_radio if mv013<8 [iw=wt], row nofreq 

*residence
tab mv025 fp_message_radio if mv013<8 [iw=wt], row nofreq 

*region
tab mv024 fp_message_radio if mv013<8 [iw=wt], row nofreq 

*education
tab mv106 fp_message_radio if mv013<8 [iw=wt], row nofreq 

*wealth
tab mv190 fp_message_radio if mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fp_message_radio if mv013<8 using Tables_message_mn.xls [iw=wt] , c(row) f(1) replace 
*/

****************************************************
//FP messages by TV

*age
tab mv013 fp_message_tv if mv013<8 [iw=wt], row nofreq 

*residence
tab mv025 fp_message_tv if mv013<8 [iw=wt], row nofreq 

*region
tab mv024 fp_message_tv if mv013<8 [iw=wt], row nofreq 

*education
tab mv106 fp_message_tv if mv013<8 [iw=wt], row nofreq 

*wealth
tab mv190 fp_message_tv if mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fp_message_tv if mv013<8 using Tables_message_mn.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//FP messages by paper

*age
tab mv013 fp_message_paper if mv013<8 [iw=wt], row nofreq 

*residence
tab mv025 fp_message_paper if mv013<8 [iw=wt], row nofreq 

*region
tab mv024 fp_message_paper if mv013<8 [iw=wt], row nofreq 

*education
tab mv106 fp_message_paper if mv013<8 [iw=wt], row nofreq 

*wealth
tab mv190 fp_message_paper if mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fp_message_paper if mv013<8 using Tables_message_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by mobile

*age
tab mv013 fp_message_mobile if mv013<8 [iw=wt], row nofreq 

*residence
tab mv025 fp_message_mobile if mv013<8 [iw=wt], row nofreq 

*region
tab mv024 fp_message_mobile if mv013<8 [iw=wt], row nofreq 

*education
tab mv106 fp_message_mobile if mv013<8 [iw=wt], row nofreq 

*wealth
tab mv190 fp_message_mobile if mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fp_message_mobile if mv013<8 using Tables_message_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by social media

*age
tab mv013 fp_message_socialm [iw=wt], row nofreq 

*residence
tab mv025 fp_message_socialm [iw=wt], row nofreq 

*region
tab mv024 fp_message_socialm [iw=wt], row nofreq 

*education
tab mv106 fp_message_socialm [iw=wt], row nofreq 

*wealth
tab mv190 fp_message_socialm [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fp_message_socialm using Tables_message_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by poster/leaflet/brochure

*age
tab mv013 fp_message_poster [iw=wt], row nofreq 

*residence
tab mv025 fp_message_poster [iw=wt], row nofreq 

*region
tab mv024 fp_message_poster [iw=wt], row nofreq 

*education
tab mv106 fp_message_poster [iw=wt], row nofreq 

*wealth
tab mv190 fp_message_poster [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fp_message_poster using Tables_message_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by outdoor sign/billboard

*age
tab mv013 fp_message_signs [iw=wt], row nofreq 

*residence
tab mv025 fp_message_signs [iw=wt], row nofreq 

*region
tab mv024 fp_message_signs [iw=wt], row nofreq 

*education
tab mv106 fp_message_signs [iw=wt], row nofreq 

*wealth
tab mv190 fp_message_signs [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190  fp_message_signs using Tables_message_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages by community meetings/events

*age
tab mv013 fp_message_comnty [iw=wt], row nofreq 

*residence
tab mv025 fp_message_comnty [iw=wt], row nofreq 

*region
tab mv024 fp_message_comnty [iw=wt], row nofreq 

*education
tab mv106 fp_message_comnty [iw=wt], row nofreq 

*wealth
tab mv190 fp_message_comnty [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190  fp_message_comnty using Tables_message_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//FP messages none of eight

*age
tab mv013 fp_message_noneof8 [iw=wt], row nofreq 

*residence
tab mv025 fp_message_noneof8 [iw=wt], row nofreq 

*region
tab mv024 fp_message_noneof8 [iw=wt], row nofreq 

*education
tab mv106 fp_message_noneof8 [iw=wt], row nofreq 

*wealth
tab mv190 fp_message_noneof8 [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190  fp_message_noneof8 using Tables_message_mn.xls [iw=wt] , c(row) f(1) append 
*/
}

