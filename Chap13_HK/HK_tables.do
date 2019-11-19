/*****************************************************************************************************
Program: 			HK_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: November 5 2019 by Shireen Assaf 

*Note this do file will produce the following tables in excel:
	1. 	Tables_know_wm:		Contains the tables for HIV/AIDS knowledge indicators for women
	2.	Tables_know_mn:		Contains the tables for HIV/AIDS knowledge indicators for men
	3. 	Tables_atd_wm:		Contains the tables for HIV/AIDS attitude indicators for women
	4.	Tables_atd_mn:		Contains the tables for HIV/AIDS attitude indicators for women
	5.	Tables_rsky_wm: 	Contains the tables for risky sexual behaviors for women
	6.	Tables_rsky_mn: 	Contains the tables for risky sexual behaviors for men
	7.	Tables_test_wm: 	Contains the tables for HIV prior testing and counseling for women
	8.	Tables_test_mn: 	Contains the tables for HIV prior testing and counseling for men
	9.	Tables_circum:		Contains the tables for circumcision indicators
	10.	Tables_sti_wm:		Contains the tables for STI indicators for women
	11. Tables_sti_mn:		Contains the tables for STI indicators for men
	12. Tables_bhv_yng_wm:	Contains the table for sexual behavior among young people for women
	13. Tables_bhv_yng_mn:	Contains the table for sexual behavior among young people for men

Notes:	Several tables in the final reports are reported about young people (15-24). 
To produce these tables you can rerun the code among young people age group using v013 by droping cases over 24 years (i.e drop if v013>2).

*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file
if file=="IR" {
gen wt=v005/1000000

**************************************************************************************************
* Knowledge of HIV/AIDS
**************************************************************************************************
//Ever heard of AIDS
*age
tab v013 hk_ever_heard [iw=wt], row nofreq 

*marital status
tab v501 hk_ever_heard [iw=wt], row nofreq 

*residence
tab v025 hk_ever_heard [iw=wt], row nofreq 

*region
tab v024 hk_ever_heard [iw=wt], row nofreq 

*education
tab v106 hk_ever_heard [iw=wt], row nofreq 

*wealth
tab v190 hk_ever_heard [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_ever_heard using Tables_know_wm.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Know reduce risk - use condoms
*age
tab v013 hk_knw_risk_cond [iw=wt], row nofreq 

*residence
tab v025 hk_knw_risk_cond [iw=wt], row nofreq 

*region
tab v024 hk_knw_risk_cond [iw=wt], row nofreq 

*education
tab v106 hk_knw_risk_cond [iw=wt], row nofreq 

*wealth
tab v190 hk_knw_risk_cond [iw=wt], row nofreq 

* output to excel
tabout v014 v025 v024 v106 v190 hk_knw_risk_cond using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know reduce risk - limit to one partner
*age
tab v013 hk_knw_risk_sex [iw=wt], row nofreq 

*residence
tab v025 hk_knw_risk_sex [iw=wt], row nofreq 

*region
tab v024 hk_knw_risk_sex [iw=wt], row nofreq 

*education
tab v106 hk_knw_risk_sex [iw=wt], row nofreq 

*wealth
tab v190 hk_knw_risk_sex [iw=wt], row nofreq 

* output to excel
tabout v014 v025 v024 v106 v190 hk_knw_risk_sex using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know reduce risk - use condoms and limit to one partner
*age
tab v013 hk_knw_risk_condsex [iw=wt], row nofreq 

*residence
tab v025 hk_knw_risk_condsex [iw=wt], row nofreq 

*region
tab v024 hk_knw_risk_condsex [iw=wt], row nofreq 

*education
tab v106 hk_knw_risk_condsex [iw=wt], row nofreq 

*wealth
tab v190 hk_knw_risk_condsex [iw=wt], row nofreq 

* output to excel
tabout v014 v025 v024 v106 v190 hk_knw_risk_condsex using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know healthy person can have HIV
*age
tab v013 hk_knw_hiv_hlth [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_hiv_hlth using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know HIV cannot be transmitted by mosquito bites
*age
tab v013 hk_knw_hiv_mosq [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_hiv_mosq using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know HIV cannot be transmitted by supernatural means
*age
tab v013 hk_knw_hiv_supernat [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_hiv_supernat using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know HIV cannot be transmitted by sharing food with HIV infected person
*age
tab v013 hk_knw_hiv_food [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_hiv_food using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know healthy person can have HIV and reject two common local misconceptions
*age
tab v013 hk_knw_hiv_hlth_2miscp [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_hiv_hlth_2miscp using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//HIV comprehensive knowledge
*age
tab v013 hk_knw_comphsv [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_comphsv using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know that HIV MTCT can occur during pregnancy
*age
tab v013 hk_knw_mtct_preg [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_mtct_preg using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know that HIV MTCT can occur during delivery
*age
tab v013 hk_knw_mtct_deliv [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_mtct_deliv using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know that HIV MTCT can occur during breastfeeding
*age
tab v013 hk_knw_mtct_brfeed [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_mtct_brfeed using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know all three HIV MTCT
*age
tab v013 hk_knw_mtct_all3 [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_mtct_all3 using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know risk of HIV MTCT can be reduced by meds
*age
tab v013 hk_knw_mtct_meds [iw=wt], row nofreq 

* output to excel
tabout v013 hk_knw_mtct_meds using Tables_know_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Attitudes on HIV/AIDS
**************************************************************************************************
//Think that children with HIV should not go to school with HIV negative children
*age
tab v013 hk_atd_child_nosch [iw=wt], row nofreq 

*marital status
tab v501 hk_atd_child_nosch [iw=wt], row nofreq 

*residence
tab v025 hk_atd_child_nosch [iw=wt], row nofreq 

*region
tab v024 hk_atd_child_nosch [iw=wt], row nofreq 

*education
tab v106 hk_atd_child_nosch [iw=wt], row nofreq 

*wealth
tab v190 hk_atd_child_nosch [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_atd_child_nosch using Tables_atd_wm.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Would not buy fresh vegetabels from a shopkeeper who has HIV
*age
tab v013 hk_atd_shop_notbuy [iw=wt], row nofreq 

*marital status
tab v501 hk_atd_shop_notbuy [iw=wt], row nofreq 

*residence
tab v025 hk_atd_shop_notbuy [iw=wt], row nofreq 

*region
tab v024 hk_atd_shop_notbuy [iw=wt], row nofreq 

*education
tab v106 hk_atd_shop_notbuy [iw=wt], row nofreq 

*wealth
tab v190 hk_atd_shop_notbuy [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_atd_shop_notbuy using Tables_atd_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Have discriminatory attitudes towards people living with HIV-AIDS
*age
tab v013 hk_atd_discriminat [iw=wt], row nofreq 

*marital status
tab v501 hk_atd_discriminat [iw=wt], row nofreq 

*residence
tab v025 hk_atd_discriminat [iw=wt], row nofreq 

*region
tab v024 hk_atd_discriminat [iw=wt], row nofreq 

*education
tab v106 hk_atd_discriminat [iw=wt], row nofreq 

*wealth
tab v190 hk_atd_discriminat [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_atd_discriminat using Tables_atd_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Risky sexual behavior
**************************************************************************************************
//Two or more sexual partners
*age
tab v013 hk_sex_2plus [iw=wt], row nofreq 

*marital status
tab v501 hk_sex_2plus [iw=wt], row nofreq 

*residence
tab v025 hk_sex_2plus [iw=wt], row nofreq 

*region
tab v024 hk_sex_2plus [iw=wt], row nofreq 

*education
tab v106 hk_sex_2plus [iw=wt], row nofreq 

*wealth
tab v190 hk_sex_2plus [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_sex_2plus using Tables_rsky_wm.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Had sex with a person that was not their partner
*age
tab v013 hk_sex_notprtnr [iw=wt], row nofreq 

*marital status
tab v501 hk_sex_notprtnr [iw=wt], row nofreq 

*residence
tab v025 hk_sex_notprtnr [iw=wt], row nofreq 

*region
tab v024 hk_sex_notprtnr [iw=wt], row nofreq 

*education
tab v106 hk_sex_notprtnr [iw=wt], row nofreq 

*wealth
tab v190 hk_sex_notprtnr [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_sex_notprtnr using Tables_rsky_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Have two or more sexual partners and used condom at last sex
*age
tab v013 hk_cond_2plus [iw=wt], row nofreq 

*marital status
tab v501 hk_cond_2plus [iw=wt], row nofreq 

*residence
tab v025 hk_cond_2plus [iw=wt], row nofreq 

*region
tab v024 hk_cond_2plus [iw=wt], row nofreq 

*education
tab v106 hk_cond_2plus [iw=wt], row nofreq 

*wealth
tab v190 hk_cond_2plus [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_cond_2plus using Tables_rsky_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Had sex with a person that was not their partner and used condom
*age
tab v013 hk_cond_notprtnr [iw=wt], row nofreq 

*marital status
tab v501 hk_cond_notprtnr [iw=wt], row nofreq 

*residence
tab v025 hk_cond_notprtnr [iw=wt], row nofreq 

*region
tab v024 hk_cond_notprtnr [iw=wt], row nofreq 

*education
tab v106 hk_cond_notprtnr [iw=wt], row nofreq 

*wealth
tab v190 hk_cond_notprtnr [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_cond_notprtnr using Tables_rsky_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Mean number of sexual partners
*total
ta hk_sexprtnr_mean

*age
bysort v013: sum v836 if inrange(v836,1,95) [iw=wt]

*marital status
bysort v501: sum v836 if inrange(v836,1,95) [iw=wt]

*residence
bysort v025: sum v836 if inrange(v836,1,95) [iw=wt]

*region
bysort v024: sum v836 if inrange(v836,1,95) [iw=wt]

*education
bysort v106: sum v836 if inrange(v836,1,95) [iw=wt]

*wealth
bysort v190: sum v836 if inrange(v836,1,95) [iw=wt]

tabout v013 v501 v025 v024 v106 v190 if inrange(v836,1,95) using Tables_rsky_wm.xls [fw=v005] , clab("mean_num_sexual_partners") oneway sum cells(mean v836) f(1) append 

**************************************************************************************************
* HIV prior testing and counseling 
**************************************************************************************************
//Know where to get HIV test
*age
tab v013 hk_test_where [iw=wt], row nofreq 

*marital status
tab v501 hk_test_where [iw=wt], row nofreq 

*residence
tab v025 hk_test_where [iw=wt], row nofreq 

*region
tab v024 hk_test_where [iw=wt], row nofreq 

*education
tab v106 hk_test_where [iw=wt], row nofreq 

*wealth
tab v190 hk_test_where [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_test_where using Tables_test_wm.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Had prior HIV test and whether they received results
*age
tab v013 hk_test_prior [iw=wt], row nofreq 

*marital status
tab v501 hk_test_prior [iw=wt], row nofreq 

*residence
tab v025 hk_test_prior [iw=wt], row nofreq 

*region
tab v024 hk_test_prior [iw=wt], row nofreq 

*education
tab v106 hk_test_prior [iw=wt], row nofreq 

*wealth
tab v190 hk_test_prior [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_test_prior using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
**************************************************************************************************
//Ever tested
*age
tab v013 hk_test_ever [iw=wt], row nofreq 

*marital status
tab v501 hk_test_ever [iw=wt], row nofreq 

*residence
tab v025 hk_test_ever [iw=wt], row nofreq 

*region
tab v024 hk_test_ever [iw=wt], row nofreq 

*education
tab v106 hk_test_ever [iw=wt], row nofreq 

*wealth
tab v190 hk_test_ever [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_test_ever using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
**************************************************************************************************
//Tested in last 12 months and received test results
*age
tab v013 hk_test_12m [iw=wt], row nofreq 

*marital status
tab v501 hk_test_12m [iw=wt], row nofreq 

*residence
tab v025 hk_test_12m [iw=wt], row nofreq 

*region
tab v024 hk_test_12m [iw=wt], row nofreq 

*education
tab v106 hk_test_12m [iw=wt], row nofreq 

*wealth
tab v190 hk_test_12m [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_test_12m using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Heard of self-test kits
*age
tab v013 hk_hiv_selftest_heard [iw=wt], row nofreq 

*residence
tab v025 hk_hiv_selftest_heard [iw=wt], row nofreq 

*region
tab v024 hk_hiv_selftest_heard [iw=wt], row nofreq 

*education
tab v106 hk_hiv_selftest_heard [iw=wt], row nofreq 

*wealth
tab v190 hk_hiv_selftest_heard [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 hk_hiv_selftest_heard using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Ever used a self-test kit
*age
tab v013 hk_hiv_selftest_use [iw=wt], row nofreq 

*residence
tab v025 hk_hiv_selftest_use [iw=wt], row nofreq 

*region
tab v024 hk_hiv_selftest_use [iw=wt], row nofreq 

*education
tab v106 hk_hiv_selftest_use [iw=wt], row nofreq 

*wealth
tab v190 hk_hiv_selftest_use [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 hk_hiv_selftest_use using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Received counseling on HIV during ANC visit
*age
tab v013 hk_hiv_consl_anc [iw=wt], row nofreq 

*marital status
tab v501 hk_hiv_consl_anc [iw=wt], row nofreq 

*residence
tab v025 hk_hiv_consl_anc [iw=wt], row nofreq 

*region
tab v024 hk_hiv_consl_anc [iw=wt], row nofreq 

*education
tab v106 hk_hiv_consl_anc [iw=wt], row nofreq 

*wealth
tab v190 hk_hiv_consl_anc [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_hiv_consl_anc using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Tested for HIV during ANC visit and received results and post-test counseling
*age
tab v013 hk_test_consl_anc [iw=wt], row nofreq 

*marital status
tab v501 hk_test_consl_anc [iw=wt], row nofreq 

*residence
tab v025 hk_test_consl_anc [iw=wt], row nofreq 

*region
tab v024 hk_test_consl_anc [iw=wt], row nofreq 

*education
tab v106 hk_test_consl_anc [iw=wt], row nofreq 

*wealth
tab v190 hk_test_consl_anc [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_test_consl_anc using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Tested for HIV during ANC visit and received results but no post-test counseling
*age
tab v013 hk_test_noconsl_anc [iw=wt], row nofreq 

*marital status
tab v501 hk_test_noconsl_anc [iw=wt], row nofreq 

*residence
tab v025 hk_test_noconsl_anc [iw=wt], row nofreq 

*region
tab v024 hk_test_noconsl_anc [iw=wt], row nofreq 

*education
tab v106 hk_test_noconsl_anc [iw=wt], row nofreq 

*wealth
tab v190 hk_test_noconsl_anc [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_test_consl_anc using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Tested for HIV during ANC visit and did not receive test results
*age
tab v013 hk_test_noresult_anc [iw=wt], row nofreq 

*marital status
tab v501 hk_test_noresult_anc [iw=wt], row nofreq 

*residence
tab v025 hk_test_noresult_anc [iw=wt], row nofreq 

*region
tab v024 hk_test_noresult_anc [iw=wt], row nofreq 

*education
tab v106 hk_test_noresult_anc [iw=wt], row nofreq 

*wealth
tab v190 hk_test_noresult_anc [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_test_noresult_anc using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Received HIV counseling, test, and results
*age
tab v013 hk_hiv_receivedall_anc [iw=wt], row nofreq 

*marital status
tab v501 hk_hiv_receivedall_anc [iw=wt], row nofreq 

*residence
tab v025 hk_hiv_receivedall_anc [iw=wt], row nofreq 

*region
tab v024 hk_hiv_receivedall_anc [iw=wt], row nofreq 

*education
tab v106 hk_hiv_receivedall_anc [iw=wt], row nofreq 

*wealth
tab v190 hk_hiv_receivedall_anc [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_hiv_receivedall_anc using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Received HIV test during ANC or labor and received results
*age
tab v013 hk_test_anclbr_result [iw=wt], row nofreq 

*marital status
tab v501 hk_test_anclbr_result [iw=wt], row nofreq 

*residence
tab v025 hk_test_anclbr_result [iw=wt], row nofreq 

*region
tab v024 hk_test_anclbr_result [iw=wt], row nofreq 

*education
tab v106 hk_test_anclbr_result [iw=wt], row nofreq 

*wealth
tab v190 hk_test_anclbr_result [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_test_anclbr_result using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Received HIV test during ANC or labor but did not receive results
*age
tab v013 hk_test_anclbr_noresult [iw=wt], row nofreq 

*marital status
tab v501 hk_test_anclbr_noresult [iw=wt], row nofreq 

*residence
tab v025 hk_test_anclbr_noresult [iw=wt], row nofreq 

*region
tab v024 hk_test_anclbr_noresult [iw=wt], row nofreq 

*education
tab v106 hk_test_anclbr_noresult [iw=wt], row nofreq 

*wealth
tab v190 hk_test_anclbr_noresult [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_test_anclbr_noresult using Tables_test_wm.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Self reported STIs
**************************************************************************************************
//STI in the past 12 months
*age
tab v013 hk_sti [iw=wt], row nofreq 

*marital status
tab v501 hk_sti [iw=wt], row nofreq 

*residence
tab v025 hk_sti [iw=wt], row nofreq 

*region
tab v024 hk_sti [iw=wt], row nofreq 

*education
tab v106 hk_sti [iw=wt], row nofreq 

*wealth
tab v190 hk_sti [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_sti using Tables_sti_wm.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Discharge in the past 12 months
*age
tab v013 hk_gent_disch [iw=wt], row nofreq 

*marital status
tab v501 hk_gent_disch [iw=wt], row nofreq 

*residence
tab v025 hk_gent_disch [iw=wt], row nofreq 

*region
tab v024 hk_gent_disch [iw=wt], row nofreq 

*education
tab v106 hk_gent_disch [iw=wt], row nofreq 

*wealth
tab v190 hk_gent_disch [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_gent_disch using Tables_sti_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Genital sore in past 12 months
*age
tab v013 hk_gent_sore [iw=wt], row nofreq 

*marital status
tab v501 hk_gent_sore [iw=wt], row nofreq 

*residence
tab v025 hk_gent_sore [iw=wt], row nofreq 

*region
tab v024 hk_gent_sore [iw=wt], row nofreq 

*education
tab v106 hk_gent_sore [iw=wt], row nofreq 

*wealth
tab v190 hk_gent_sore [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_gent_sore using Tables_sti_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//STI or STI symptoms in the past 12 months
*age
tab v013 hk_sti_symp [iw=wt], row nofreq 

*marital status
tab v501 hk_sti_symp [iw=wt], row nofreq 

*residence
tab v025 hk_sti_symp [iw=wt], row nofreq 

*region
tab v024 hk_sti_symp [iw=wt], row nofreq 

*education
tab v106 hk_sti_symp [iw=wt], row nofreq 

*wealth
tab v190 hk_sti_symp [iw=wt], row nofreq 

* output to excel
tabout v013 v501 v025 v024 v106 v190 hk_sti_symp using Tables_sti_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Care-seeking indicators for STIs
tab1 hk_sti_trt_doc hk_sti_trt_pharm hk_sti_trt_other hk_sti_notrt [iw=wt]

* output to excel
tabout hk_sti_trt_doc hk_sti_trt_pharm hk_sti_trt_other hk_sti_notrt using Tables_sti_wm.xls [iw=wt] , oneway cells(cell) f(1) append
*/

**************************************************************************************************
* Sexual behavior among young people
**************************************************************************************************
* new age variable among young. 
recode v012 (15/17=1 " 15-17") (18/19=2 " 18-19") (20/22=3 " 20-22") (23/24=4 " 23-24") (else=.), gen(age_yng)

//Sex before 15

* new age variable
tab age_yng hk_sex_15 [iw=wt], row nofreq 

*residence
tab v025 hk_sex_15 [iw=wt], row nofreq 

*education
tab v106 hk_sex_15 [iw=wt], row nofreq 

* output to excel
tabout age_yng v025 v106 hk_sex_15 using Tables_bhv_yng_wm.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Sex before 18

* new age variable
tab age_yng hk_sex_18 [iw=wt], row nofreq 

*residence
tab v025 hk_sex_18 [iw=wt], row nofreq 

*education
tab v106 hk_sex_18 [iw=wt], row nofreq 

* output to excel
tabout age_yng v025 v106 hk_sex_18 using Tables_bhv_yng_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Never had sexual

* new age variable
tab age_yng hk_nosex_youth [iw=wt], row nofreq 

*residence
tab v025 hk_nosex_youth [iw=wt], row nofreq 

*education
tab v106 hk_nosex_youth [iw=wt], row nofreq 

* output to excel
tabout age_yng v025 v106 hk_nosex_youth using Tables_bhv_yng_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************

recode v502 (0=0 "Never married") (1/2=1 "Ever married"), gen(marstat)

//Tested and received HIV test results

* new age variable
tab age_yng hk_sex_youth_test [iw=wt], row nofreq 

*new marital status variable
tab marstat hk_sex_youth_test [iw=wt], row nofreq 

* output to excel
tabout age_yng marstat hk_sex_youth_test using Tables_bhv_yng_wm.xls [iw=wt] , c(row) f(1) append 
*/
}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {
gen wt=mv005/1000000


**************************************************************************************************
* Knowledge and Attitudes towards HIV/AIDS
**************************************************************************************************
//Ever heard of AIDS
*age
tab mv013 hk_ever_heard [iw=wt], row nofreq 

*marital status
tab mv501 hk_ever_heard [iw=wt], row nofreq 

*residence
tab mv025 hk_ever_heard [iw=wt], row nofreq 

*region
tab mv024 hk_ever_heard [iw=wt], row nofreq 

*education
tab mv106 hk_ever_heard [iw=wt], row nofreq 

*wealth
tab mv190 hk_ever_heard [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_ever_heard using Tables_know_mn.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Know reduce risk - use condoms
*age
tab mv013 hk_knw_risk_cond [iw=wt], row nofreq 

*residence
tab mv025 hk_knw_risk_cond [iw=wt], row nofreq 

*region
tab mv024 hk_knw_risk_cond [iw=wt], row nofreq 

*education
tab mv106 hk_knw_risk_cond [iw=wt], row nofreq 

*wealth
tab mv190 hk_knw_risk_cond [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 hk_knw_risk_cond using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know reduce risk - limit to one partner
*age
tab mv013 hk_knw_risk_sex [iw=wt], row nofreq 

*residence
tab mv025 hk_knw_risk_sex [iw=wt], row nofreq 

*region
tab mv024 hk_knw_risk_sex [iw=wt], row nofreq 

*education
tab mv106 hk_knw_risk_sex [iw=wt], row nofreq 

*wealth
tab mv190 hk_knw_risk_sex [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 hk_knw_risk_sex using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know reduce risk - use condoms and limit to one partner
*age
tab mv013 hk_knw_risk_condsex [iw=wt], row nofreq 

*residence
tab mv025 hk_knw_risk_condsex [iw=wt], row nofreq 

*region
tab mv024 hk_knw_risk_condsex [iw=wt], row nofreq 

*education
tab mv106 hk_knw_risk_condsex [iw=wt], row nofreq 

*wealth
tab mv190 hk_knw_risk_condsex [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 hk_knw_risk_condsex using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know healthy person can have HIV
*age
tab mv013 hk_knw_hiv_hlth [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_hiv_hlth using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know HIV cannot be transmitted by mosquito bites
*age
tab mv013 hk_knw_hiv_mosq [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_hiv_mosq using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know HIV cannot be transmitted by supernatural means
*age
tab mv013 hk_knw_hiv_supernat [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_hiv_supernat using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know HIV cannot be transmitted by sharing food with HIV infected person
*age
tab mv013 hk_knw_hiv_food [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_hiv_food using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know healthy person can have HIV and reject two common local misconceptions
*age
tab mv013 hk_knw_hiv_hlth_2miscp [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_hiv_hlth_2miscp using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//HIV comprehensive knowledge
*age
tab mv013 hk_knw_comphsv [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_comphsv using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know that HIV MTCT can occur during pregnancy
*age
tab mv013 hk_knw_mtct_preg [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_mtct_preg using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know that HIV MTCT can occur during delivery
*age
tab mv013 hk_knw_mtct_deliv [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_mtct_deliv using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know that HIV MTCT can occur during breastfeeding
*age
tab mv013 hk_knw_mtct_brfeed [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_mtct_brfeed using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know all three HIV MTCT
*age
tab mv013 hk_knw_mtct_all3 [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_mtct_all3 using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Know risk of HIV MTCT can be reduced by meds
*age
tab mv013 hk_knw_mtct_meds [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_knw_mtct_meds using Tables_know_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Attitudes on HIV/AIDS
**************************************************************************************************
//Think that children with HIV should not go to school with HIV negative children
*age
tab mv013 hk_atd_child_nosch [iw=wt], row nofreq 

*marital status
tab mv501 hk_atd_child_nosch [iw=wt], row nofreq 

*residence
tab mv025 hk_atd_child_nosch [iw=wt], row nofreq 

*region
tab mv024 hk_atd_child_nosch [iw=wt], row nofreq 

*education
tab mv106 hk_atd_child_nosch [iw=wt], row nofreq 

*wealth
tab mv190 hk_atd_child_nosch [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_atd_child_nosch using Tables_atd_mn.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Would not buy fresh vegetabels from a shopkeeper who has HIV
*age
tab mv013 hk_atd_shop_notbuy [iw=wt], row nofreq 

*marital status
tab mv501 hk_atd_shop_notbuy [iw=wt], row nofreq 

*residence
tab mv025 hk_atd_shop_notbuy [iw=wt], row nofreq 

*region
tab mv024 hk_atd_shop_notbuy [iw=wt], row nofreq 

*education
tab mv106 hk_atd_shop_notbuy [iw=wt], row nofreq 

*wealth
tab mv190 hk_atd_shop_notbuy [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_atd_shop_notbuy using Tables_atd_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Have discriminatory attitudes towards people living with HIV-AIDS
*age
tab mv013 hk_atd_discriminat [iw=wt], row nofreq 

*marital status
tab mv501 hk_atd_discriminat [iw=wt], row nofreq 

*residence
tab mv025 hk_atd_discriminat [iw=wt], row nofreq 

*region
tab mv024 hk_atd_discriminat [iw=wt], row nofreq 

*education
tab mv106 hk_atd_discriminat [iw=wt], row nofreq 

*wealth
tab mv190 hk_atd_discriminat [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_atd_discriminat using Tables_atd_mn.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Risky sexual behavior
**************************************************************************************************
//Two or more sexual partners
*age
tab mv013 hk_sex_2plus [iw=wt], row nofreq 

*marital status
tab mv501 hk_sex_2plus [iw=wt], row nofreq 

*residence
tab mv025 hk_sex_2plus [iw=wt], row nofreq 

*region
tab mv024 hk_sex_2plus [iw=wt], row nofreq 

*education
tab mv106 hk_sex_2plus [iw=wt], row nofreq 

*wealth
tab mv190 hk_sex_2plus [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_sex_2plus using Tables_rsky_mn.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Had sex with a person that was not their partner
*age
tab mv013 hk_sex_notprtnr [iw=wt], row nofreq 

*marital status
tab mv501 hk_sex_notprtnr [iw=wt], row nofreq 

*residence
tab mv025 hk_sex_notprtnr [iw=wt], row nofreq 

*region
tab mv024 hk_sex_notprtnr [iw=wt], row nofreq 

*education
tab mv106 hk_sex_notprtnr [iw=wt], row nofreq 

*wealth
tab mv190 hk_sex_notprtnr [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_sex_notprtnr using Tables_rsky_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Have two or more sexual partners and used condom at last sex
*age
tab mv013 hk_cond_2plus [iw=wt], row nofreq 

*marital status
tab mv501 hk_cond_2plus [iw=wt], row nofreq 

*residence
tab mv025 hk_cond_2plus [iw=wt], row nofreq 

*region
tab mv024 hk_cond_2plus [iw=wt], row nofreq 

*education
tab mv106 hk_cond_2plus [iw=wt], row nofreq 

*wealth
tab mv190 hk_cond_2plus [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_cond_2plus using Tables_rsky_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Had sex with a person that was not their partner and used condom
*age
tab mv013 hk_cond_notprtnr [iw=wt], row nofreq 

*marital status
tab mv501 hk_cond_notprtnr [iw=wt], row nofreq 

*residence
tab mv025 hk_cond_notprtnr [iw=wt], row nofreq 

*region
tab mv024 hk_cond_notprtnr [iw=wt], row nofreq 

*education
tab mv106 hk_cond_notprtnr [iw=wt], row nofreq 

*wealth
tab mv190 hk_cond_notprtnr [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_cond_notprtnr using Tables_rsky_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Mean number of sexual partners
*total
ta hk_sexprtnr_mean

*age
bysort mv013: sum mv836 if inrange(mv836,1,95) [iw=wt]

*marital status
bysort mv501: sum mv836 if inrange(mv836,1,95) [iw=wt]

*residence
bysort mv025: sum mv836 if inrange(mv836,1,95) [iw=wt]

*region
bysort mv024: sum mv836 if inrange(mv836,1,95) [iw=wt]

*education
bysort mv106: sum mv836 if inrange(mv836,1,95) [iw=wt]

*wealth
bysort mv190: sum mv836 if inrange(mv836,1,95) [iw=wt]

tabout mv013 mv501 mv025 mv024 mv106 mv190 if inrange(mv836,1,95) using Tables_rsky_mn.xls [fw=mv005] , clab("mean_num_sexual_partners") oneway sum cells(mean v836) f(1) append 
**************************************************************************************************
//Ever paid for sex
*age
tab mv013 hk_paid_sex_ever [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_paid_sex_ever using Tables_rsky_mn.xls [iw=wt] , c(row) f(1) append 
**************************************************************************************************
//Paid for sex in the last 12 months
*age
tab mv013 hk_paid_sex_12mo [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_paid_sex_12mo using Tables_rsky_mn.xls [iw=wt] , c(row) f(1) append 
**************************************************************************************************
//Used a condom at last paid sex in the last 12 months
*age
tab mv013 hk_paid_sex_cond [iw=wt], row nofreq 

* output to excel
tabout mv013 hk_paid_sex_cond using Tables_rsky_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* HIV prior testing and counseling 
**************************************************************************************************
//Know where to get HIV test
*age
tab mv013 hk_test_where [iw=wt], row nofreq 

*marital status
tab mv501 hk_test_where [iw=wt], row nofreq 

*residence
tab mv025 hk_test_where [iw=wt], row nofreq 

*region
tab mv024 hk_test_where [iw=wt], row nofreq 

*education
tab mv106 hk_test_where [iw=wt], row nofreq 

*wealth
tab mv190 hk_test_where [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_test_where using Tables_test_mn.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Had prior HIV test and whether they received results
*age
tab mv013 hk_test_prior [iw=wt], row nofreq 

*marital status
tab mv501 hk_test_prior [iw=wt], row nofreq 

*residence
tab mv025 hk_test_prior [iw=wt], row nofreq 

*region
tab mv024 hk_test_prior [iw=wt], row nofreq 

*education
tab mv106 hk_test_prior [iw=wt], row nofreq 

*wealth
tab mv190 hk_test_prior [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_test_prior using Tables_test_mn.xls [iw=wt] , c(row) f(1) append 
**************************************************************************************************
//Ever tested
*age
tab mv013 hk_test_ever [iw=wt], row nofreq 

*marital status
tab mv501 hk_test_ever [iw=wt], row nofreq 

*residence
tab mv025 hk_test_ever [iw=wt], row nofreq 

*region
tab mv024 hk_test_ever [iw=wt], row nofreq 

*education
tab mv106 hk_test_ever [iw=wt], row nofreq 

*wealth
tab mv190 hk_test_ever [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_test_ever using Tables_test_mn.xls [iw=wt] , c(row) f(1) append 
**************************************************************************************************
//Tested in last 12 months and received test results
*age
tab mv013 hk_test_12m [iw=wt], row nofreq 

*marital status
tab mv501 hk_test_12m [iw=wt], row nofreq 

*residence
tab mv025 hk_test_12m [iw=wt], row nofreq 

*region
tab mv024 hk_test_12m [iw=wt], row nofreq 

*education
tab mv106 hk_test_12m [iw=wt], row nofreq 

*wealth
tab mv190 hk_test_12m [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 mv025 mv024 mv106 mv190 hk_test_12m using Tables_test_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Heard of self-test kits
*age
tab mv013 hk_hiv_selftest_heard [iw=wt], row nofreq 

*residence
tab mv025 hk_hiv_selftest_heard [iw=wt], row nofreq 

*region
tab mv024 hk_hiv_selftest_heard [iw=wt], row nofreq 

*education
tab mv106 hk_hiv_selftest_heard [iw=wt], row nofreq 

*wealth
tab mv190 hk_hiv_selftest_heard [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 hk_hiv_selftest_heard using Tables_test_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Ever used a self-test kit
*age
tab mv013 hk_hiv_selftest_use [iw=wt], row nofreq 

*residence
tab mv025 hk_hiv_selftest_use [iw=wt], row nofreq 

*region
tab mv024 hk_hiv_selftest_use [iw=wt], row nofreq 

*education
tab mv106 hk_hiv_selftest_use [iw=wt], row nofreq 

*wealth
tab mv190 hk_hiv_selftest_use [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 hk_hiv_selftest_use using Tables_test_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Circumcision
**************************************************************************************************
//Circumcised 
*age
tab mv013 hk_circum [iw=wt], row nofreq 

*residence
tab mv025 hk_circum [iw=wt], row nofreq 

*region
tab mv024 hk_circum [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 hk_circum using Tables_circum.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Circumcision status and provider
*age
tab mv013 hk_circum_status_prov [iw=wt], row nofreq 

*residence
tab mv025 hk_circum_status_prov [iw=wt], row nofreq 

*region
tab mv024 hk_circum_status_prov [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 hk_circum_status_prov using Tables_circum.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Self reported STIs
**************************************************************************************************
//STI in the past 12 months
*age
tab mv013 hk_sti [iw=wt], row nofreq 

*marital status
tab mv501 hk_sti [iw=wt], row nofreq 

*circumcised
tab hk_circum hk_sti [iw=wt], row nofreq 

*residence
tab mv025 hk_sti [iw=wt], row nofreq 

*region
tab mv024 hk_sti [iw=wt], row nofreq 

*education
tab mv106 hk_sti [iw=wt], row nofreq 

*wealth
tab mv190 hk_sti [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 hk_circum mv025 mv024 mv106 mv190 hk_sti using Tables_sti_mn.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Discharge in the past 12 months
*age
tab mv013 hk_gent_disch [iw=wt], row nofreq 

*marital status
tab mv501 hk_gent_disch [iw=wt], row nofreq 

*circumcised
tab hk_circum hk_sti [iw=wt], row nofreq 

*residence
tab mv025 hk_gent_disch [iw=wt], row nofreq 

*region
tab mv024 hk_gent_disch [iw=wt], row nofreq 

*education
tab mv106 hk_gent_disch [iw=wt], row nofreq 

*wealth
tab mv190 hk_gent_disch [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 hk_circum mv025 mv024 mv106 mv190 hk_gent_disch using Tables_sti_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Genital sore in past 12 months
*age
tab mv013 hk_gent_sore [iw=wt], row nofreq 

*marital status
tab mv501 hk_gent_sore [iw=wt], row nofreq 

*circumcised
tab hk_circum hk_sti [iw=wt], row nofreq 

*residence
tab mv025 hk_gent_sore [iw=wt], row nofreq 

*region
tab mv024 hk_gent_sore [iw=wt], row nofreq 

*education
tab mv106 hk_gent_sore [iw=wt], row nofreq 

*wealth
tab mv190 hk_gent_sore [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 hk_circum mv025 mv024 mv106 mv190 hk_gent_sore using Tables_sti_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//STI or STI symptoms in the past 12 months
*age
tab mv013 hk_sti_symp [iw=wt], row nofreq 

*marital status
tab mv501 hk_sti_symp [iw=wt], row nofreq 

*circumcised
tab hk_circum hk_sti [iw=wt], row nofreq 

*residence
tab mv025 hk_sti_symp [iw=wt], row nofreq 

*region
tab mv024 hk_sti_symp [iw=wt], row nofreq 

*education
tab mv106 hk_sti_symp [iw=wt], row nofreq 

*wealth
tab mv190 hk_sti_symp [iw=wt], row nofreq 

* output to excel
tabout mv013 mv501 hk_circum mv025 mv024 mv106 mv190 hk_sti_symp using Tables_sti_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Care-seeking indicators for STIs
tab1 hk_sti_trt_doc hk_sti_trt_pharm hk_sti_trt_other hk_sti_notrt [iw=wt]

* output to excel
tabout hk_sti_trt_doc hk_sti_trt_pharm hk_sti_trt_other hk_sti_notrt using Tables_sti_mn.xls [iw=wt] , oneway cells(cell) f(1) append
*/

**************************************************************************************************
* Sexual behavior among young people
**************************************************************************************************
* new age variable among young. 
recode mv012 (15/17=1 " 15-17") (18/19=2 " 18-19") (20/22=3 " 20-22") (23/24=4 " 23-24") (else=.), gen(age_yng)

//Sex before 15

* new age variable
tab age_yng hk_sex_15 [iw=wt], row nofreq 

*residence
tab mv025 hk_sex_15 [iw=wt], row nofreq 

*education
tab mv106 hk_sex_15 [iw=wt], row nofreq 

* output to excel
tabout age_yng mv025 mv106 hk_sex_15 using Tables_bhv_yng_mn.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
//Sex before 18

* new age variable
tab age_yng hk_sex_18 [iw=wt], row nofreq 

*residence
tab mv025 hk_sex_18 [iw=wt], row nofreq 

*education
tab mv106 hk_sex_18 [iw=wt], row nofreq 

* output to excel
tabout age_yng mv025 mv106 hk_sex_18 using Tables_bhv_yng_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
//Never had sexual

* new age variable
tab age_yng hk_nosex_youth [iw=wt], row nofreq 

*residence
tab mv025 hk_nosex_youth [iw=wt], row nofreq 

*education
tab mv106 hk_nosex_youth [iw=wt], row nofreq 

* output to excel
tabout age_yng mv025 mv106 hk_nosex_youth using Tables_bhv_yng_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************

recode mv502 (0=0 "Never married") (1/2=1 "Ever married"), gen(marstat)

//Tested and received HIV test results

* new age variable
tab age_yng hk_sex_youth_test [iw=wt], row nofreq 

*new marital status variable
tab marstat hk_sex_youth_test [iw=wt], row nofreq 

* output to excel
tabout age_yng marstat hk_sex_youth_test using Tables_bhv_yng_mn.xls [iw=wt] , c(row) f(1) append 
*/

}

