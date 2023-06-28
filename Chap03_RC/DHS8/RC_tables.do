/*****************************************************************************************************
Program: 			RC_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: June 28, 2023 by Shireen Assaf 

*This do file will produce the following tables in excel:
1. 	Tables_background_wm:		Contains the tables for background variables for women
2. 	Tables_background_mn:		Contains the tables for background variables for men
3. 	Tables_educ_wm:				Contains the tables for education indicators for women
4. 	Tables_educ_mn:				Contains the tables for education indicators for women
5.	Tables_media_wm:			Contains the tables for media exposure and internet use for women
6.	Tables_media_mn:			Contains the tables for media exposure and internet use for men
7.	Tables_employ_wm:			Contains the tables for employment and occupation indicators for women
8.	Tables_employ_mn:			Contains the tables for employment and occupation indicators for men
9.  Tables_insurance_wm:		Contains the tables for health insurance indicators for women
10. Tables_insurance_mn:		Contains the tables for health insurance indicators for men
11. Tables_tobac_wm:			Contains the tables for tobacco use indicators for women
12. Tables_tobac_mn:			Contains the tables for tobacco use indicators for men
13. Tables_alco_wm:				Contains the tables for alcohol use indicators for women
14. Tables_alco_mn:				Contains the tables for alcohol use indicators for men
15. Tables_migrant_wm:			Contains the tables for migration indicators for women
16. Tables_migrant_mn:			Contains the tables for migration indicators for men


Notes: 	For women and men the indicators are outputed for age 15-49 in line 31 and 714. This can be commented out if the indicators are required for all women/men.				 						
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file
if file=="IR" {
* limiting to women age 15-49
drop if v012<15 | v012>49

gen wt=v005/1000000
**************************************************************************************************
* Background characteristics: excel file Tables_background_wm will be produced
**************************************************************************************************

*age
tab v013 [iw=wt] 

*marital status
tab v501 [iw=wt] 

*residence
tab v025 [iw=wt] 

*region
tab v024 [iw=wt] 

*education
tab v106 [iw=wt] 

*wealth
tab v190 [iw=wt] 

* output to excel
tabout v013 v501 v025 v106 v024 v190 using Tables_background_wm.xls [iw=wt] , oneway cells(cell freq) replace 
*/
**************************************************************************************************
* Indicators for education and literacy: excel file Tables_educ_wm will be produced
**************************************************************************************************
//Highest level of schooling

*age
tab v013 rc_edu [iw=wt], row nofreq 

*residence
tab v025 rc_edu [iw=wt], row nofreq 

*region
tab v024 rc_edu [iw=wt], row nofreq 

*wealth
tab v190 rc_edu [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v190 rc_edu using Tables_educ_wm.xls [iw=wt] , c(row) f(1) replace 

//Median years of schooling
tab rc_edu_median 

tabout rc_edu_median using Tables_educ_wm.xls [iw=wt] , oneway cells(cell) append 

****************************************************
//Literacy levels

*age
tab v013 rc_litr_cats [iw=wt], row nofreq 

*residence
tab v025 rc_litr_cats [iw=wt], row nofreq 

*region
tab v024 rc_litr_cats [iw=wt], row nofreq 

*wealth
tab v190 rc_litr_cats [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v190 rc_litr_cats using Tables_educ_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Literate 

*age
tab v013 rc_litr [iw=wt], row nofreq 

*residence
tab v025 rc_litr [iw=wt], row nofreq 

*region
tab v024 rc_litr [iw=wt], row nofreq 

*wealth
tab v190 rc_litr [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v190 rc_litr using Tables_educ_wm.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Indicators for media exposure and internet use: excel file Tables_media_wm will be produced
**************************************************************************************************
//Reads a newspaper

*age
tab v013 rc_media_newsp [iw=wt], row nofreq 

*residence
tab v025 rc_media_newsp [iw=wt], row nofreq 

*region
tab v024 rc_media_newsp [iw=wt], row nofreq 

*education
tab v106 rc_media_newsp [iw=wt], row nofreq 

*wealth
tab v190 rc_media_newsp [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_media_newsp using Tables_media_wm.xls [iw=wt] , c(row) f(1) replace 

****************************************************
//Watches TV

*age
tab v013 rc_media_tv [iw=wt], row nofreq 

*residence
tab v025 rc_media_tv [iw=wt], row nofreq 

*region
tab v024 rc_media_tv [iw=wt], row nofreq 

*education
tab v106 rc_media_tv [iw=wt], row nofreq 

*wealth
tab v190 rc_media_tv [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_media_tv using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Listens to radio

*age
tab v013 rc_media_radio [iw=wt], row nofreq 

*residence
tab v025 rc_media_radio [iw=wt], row nofreq 

*region
tab v024 rc_media_radio [iw=wt], row nofreq 

*education
tab v106 rc_media_radio [iw=wt], row nofreq 

*wealth
tab v190 rc_media_radio [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_media_radio using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//All three media

*age
tab v013 rc_media_allthree [iw=wt], row nofreq 

*residence
tab v025 rc_media_allthree [iw=wt], row nofreq 

*region
tab v024 rc_media_allthree [iw=wt], row nofreq 

*education
tab v106 rc_media_allthree [iw=wt], row nofreq 

*wealth
tab v190 rc_media_allthree [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_media_allthree using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//None of the media forms

*age
tab v013 rc_media_none [iw=wt], row nofreq 

*residence
tab v025 rc_media_none [iw=wt], row nofreq 

*region
tab v024 rc_media_none [iw=wt], row nofreq 

*education
tab v106 rc_media_none [iw=wt], row nofreq 

*wealth
tab v190 rc_media_none [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_media_none using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Ever used the internet
* Indicator not available in all surveys so will add cap
*age
cap tab v013 rc_intr_ever [iw=wt], row nofreq 

*residence
cap tab v025 rc_intr_ever [iw=wt], row nofreq 

*region
cap tab v024 rc_intr_ever [iw=wt], row nofreq 

*education
cap tab v106 rc_intr_ever [iw=wt], row nofreq 

*wealth
cap tab v190 rc_intr_ever [iw=wt], row nofreq 

* output to excel
cap tabout v013 v025 v024 v106 v190 rc_intr_ever using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Internet use in the last 12 months
* Indicator not available in all surveys so will add cap
*age
cap tab v013 rc_intr_use12mo [iw=wt], row nofreq 

*residence
cap tab v025 rc_intr_use12mo [iw=wt], row nofreq 

*region
cap tab v024 rc_intr_use12mo [iw=wt], row nofreq 

*education
cap tab v106 rc_intr_use12mo [iw=wt], row nofreq 

*wealth
cap tab v190 rc_intr_use12mo [iw=wt], row nofreq 

* output to excel
cap  tabout v013 v025 v024 v106 v190 rc_intr_use12mo using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Internet use frequency
* Indicator not available in all surveys so will add cap
*age
cap tab v013 rc_intr_usefreq [iw=wt], row nofreq 

*residence
cap tab v025 rc_intr_usefreq [iw=wt], row nofreq 

*region
cap tab v024 rc_intr_usefreq [iw=wt], row nofreq 

*education
cap tab v106 rc_intr_usefreq [iw=wt], row nofreq 

*wealth
cap tab v190 rc_intr_usefreq [iw=wt], row nofreq 

* output to excel
cap tabout v013 v025 v024 v106 v190 rc_intr_usefreq using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Indicators for employment and occupation: excel file Tables_employ_wm will be produced
**************************************************************************************************
//Employment status

*age
tab v013 rc_empl [iw=wt], row nofreq 

*marital status
tab v502 rc_empl [iw=wt], row nofreq 

*residence
tab v025 rc_empl [iw=wt], row nofreq 

*region
tab v024 rc_empl [iw=wt], row nofreq 

*education
tab v106 rc_empl [iw=wt], row nofreq 

*wealth
tab v190 rc_empl [iw=wt], row nofreq 

* output to excel
tabout v013 v502 v025 v024 v106 v190 rc_empl using Tables_employ_wm.xls [iw=wt] , c(row) f(1) replace 

****************************************************************************
//Occupation

*age
tab v013 rc_occup [iw=wt], row nofreq 

*marital status
tab v502 rc_occup [iw=wt], row nofreq 

*residence
tab v025 rc_occup [iw=wt], row nofreq 

*region
tab v024 rc_occup [iw=wt], row nofreq 

*education
tab v106 rc_occup [iw=wt], row nofreq 

*wealth
tab v190 rc_occup [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_occup using Tables_employ_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************************************

recode v717 (1/3 6/9 96/99 .=0 "Non-Agriculture") (4/5=1 "Agriculture") if inlist(v731,1,2,3), gen(agri)

//Type of employer
tab rc_empl_type agri [iw=wt], col nofreq 

//Type of earnings
tab rc_empl_earn agri [iw=wt], col nofreq 

*Continuity of employment
tab rc_empl_cont agri [iw=wt], col nofreq 

* output to excel
cap tabout rc_empl_type rc_empl_earn rc_empl_cont agri using Tables_employ_wm.xls [iw=wt], c(col) f(1) append 

**************************************************************************************************
* Indicators for health insurance: excel file Tables_insurance_wm will be produced
**************************************************************************************************
//Social security

*age
tab v013 rc_hins_ss [iw=wt], row nofreq 

*residence
tab v025 rc_hins_ss [iw=wt], row nofreq 

*region
tab v024 rc_hins_ss [iw=wt], row nofreq 

*education
tab v106 rc_hins_ss [iw=wt], row nofreq 

*wealth
tab v190 rc_hins_ss [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_hins_ss using Tables_insurance_wm.xls [iw=wt] , c(row) f(1) replace 

****************************************************
//Other employer based insurance

*age
tab v013 rc_hins_empl [iw=wt], row nofreq 

*residence
tab v025 rc_hins_empl [iw=wt], row nofreq 

*region
tab v024 rc_hins_empl [iw=wt], row nofreq 

*education
tab v106 rc_hins_empl [iw=wt], row nofreq 

*wealth
tab v190 rc_hins_empl [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_hins_empl using Tables_insurance_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Community-based insurance

*age
tab v013 rc_hins_comm [iw=wt], row nofreq 

*residence
tab v025 rc_hins_comm [iw=wt], row nofreq 

*region
tab v024 rc_hins_comm [iw=wt], row nofreq 

*education
tab v106 rc_hins_comm [iw=wt], row nofreq 

*wealth
tab v190 rc_hins_comm [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_hins_comm using Tables_insurance_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Private insurance

*age
tab v013 rc_hins_priv [iw=wt], row nofreq 

*residence
tab v025 rc_hins_priv [iw=wt], row nofreq 

*region
tab v024 rc_hins_priv [iw=wt], row nofreq 

*education
tab v106 rc_hins_priv [iw=wt], row nofreq 

*wealth
tab v190 rc_hins_priv [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_hins_priv using Tables_insurance_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Other type of insurance

*age
tab v013 rc_hins_other [iw=wt], row nofreq 

*residence
tab v025 rc_hins_other [iw=wt], row nofreq 

*region
tab v024 rc_hins_other [iw=wt], row nofreq 

*education
tab v106 rc_hins_other [iw=wt], row nofreq 

*wealth
tab v190 rc_hins_other [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_hins_other using Tables_insurance_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Have any insurance

*age
tab v013 rc_hins_any [iw=wt], row nofreq 

*residence
tab v025 rc_hins_any [iw=wt], row nofreq 

*region
tab v024 rc_hins_any [iw=wt], row nofreq 

*education
tab v106 rc_hins_any [iw=wt], row nofreq 

*wealth
tab v190 rc_hins_any [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_hins_any using Tables_insurance_wm.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Indicators for tobacco use: excel file Tables_tobac_wm will be produced
**************************************************************************************************
//Smokes cigarettes

*age
tab v013 rc_tobc_cig [iw=wt], row nofreq 

*residence
tab v025 rc_tobc_cig [iw=wt], row nofreq 

*region
tab v024 rc_tobc_cig [iw=wt], row nofreq 

*education
tab v106 rc_tobc_cig [iw=wt], row nofreq 

*wealth
tab v190 rc_tobc_cig [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_tobc_cig using Tables_tobac_wm.xls [iw=wt] , c(row) f(1) replace 

****************************************************
//Smokes other type of tobacco

*age
tab v013 rc_tobc_other [iw=wt], row nofreq 

*residence
tab v025 rc_tobc_other [iw=wt], row nofreq 

*region
tab v024 rc_tobc_other [iw=wt], row nofreq 

*education
tab v106 rc_tobc_other [iw=wt], row nofreq 

*wealth
tab v190 rc_tobc_other [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_tobc_other using Tables_tobac_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Smokes any tobacco

*age
tab v013 rc_tobc_smk_any [iw=wt], row nofreq 

*residence
tab v025 rc_tobc_smk_any [iw=wt], row nofreq 

*region
tab v024 rc_tobc_smk_any [iw=wt], row nofreq 

*education
tab v106 rc_tobc_smk_any [iw=wt], row nofreq 

*wealth
tab v190 rc_tobc_smk_any [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_tobc_smk_any using Tables_tobac_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
* Smokeless tobacco use
* These indicators are not available in all surveys so will add cap
//Snuff by mouth
cap tab rc_tobc_snuffm [iw=wt]

//Snuff by nose
cap tab rc_tobc_snuffn [iw=wt]

//Chews tobacco
cap tab rc_tobc_chew [iw=wt]

//Betel quid with tobacco
cap tab rc_tobv_betel [iw=wt]

//Other type of smokless tobacco
cap tab rc_tobc_osmkless [iw=wt]

//Any smokeless tobacco
cap tab rc_tobc_anysmkless [iw=wt]

//Uses any type of tobacco
cap tab rc_tobc_any [iw=wt]

* output to excel
cap tabout rc_tobc_snuffm rc_tobc_snuffn rc_tobc_chew rc_tobv_betel rc_tobc_osmkless rc_tobc_anysmkless rc_tobc_any using Tables_tobac_wm.xls [iw=wt] , oneway cells(cell freq) append 

**************************************************************************************************
* Indicators for alcohol use: excel file Tables_alco_wm will be produced
**************************************************************************************************
// Consumed any alcohol

*age
tab v013 rc_alc_any [iw=wt], row nofreq 

*residence
tab v025 rc_alc_any [iw=wt], row nofreq 

*region
tab v024 rc_alc_any [iw=wt], row nofreq 

*education
tab v106 rc_alc_any [iw=wt], row nofreq 

*wealth
tab v190 rc_alc_any [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_alc_any using Tables_alco_wm.xls [iw=wt] , c(row) f(1) replace 
****************************************************
//Frequency of drinking 
*age
tab v013 rc_alc_freq [iw=wt], row nofreq 

*residence
tab v025 rc_alc_freq [iw=wt], row nofreq 

*region
tab v024 rc_alc_freq [iw=wt], row nofreq 

*education
tab v106 rc_alc_freq [iw=wt], row nofreq 

*wealth
tab v190 rc_alc_freq [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_alc_freq using Tables_alco_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Average number of drinks
*age
tab v013 rc_alc_drinks [iw=wt], row nofreq 

*age
tab rc_alc_freq rc_alc_drinks [iw=wt], row nofreq 

*residence
tab v025 rc_alc_drinks [iw=wt], row nofreq 

*region
tab v024 rc_alc_drinks [iw=wt], row nofreq 

*education
tab v106 rc_alc_drinks [iw=wt], row nofreq 

*wealth
tab v190 rc_alc_drinks [iw=wt], row nofreq 

* output to excel
tabout v013 rc_alc_freq v025 v024 v106 v190 rc_alc_drinks using Tables_alco_wm.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Indicators for migration: excel file Tables_migrant_wm will be produced
**************************************************************************************************
//Place of birth
*age
tab v013 rc_place_birth [iw=wt], row nofreq 

*residence
tab v025 rc_place_birth [iw=wt], row nofreq 

*region
tab v024 rc_place_birth [iw=wt], row nofreq 

*wealth
tab v190 rc_place_birth [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v190 rc_place_birth using Tables_migrant_wm.xls [iw=wt] , c(row) f(1) replace 
****************************************************
//Migrated in the last 5 years
*age
tab v013 rc_migrant_5yrs [iw=wt], row nofreq 

*residence
tab v025 rc_migrant_5yrs [iw=wt], row nofreq 

*region
tab v024 rc_migrant_5yrs [iw=wt], row nofreq 

*wealth
tab v190 rc_migrant_5yrs [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v190 rc_migrant_5yrs using Tables_migrant_wm.xls [iw=wt] , c(row) f(1) append
****************************************************
//Type of migration by age

tab v013 rc_migrant_type [iw=wt], row nofreq 
tabout v013 rc_migrant_type using Tables_migrant_wm.xls [iw=wt] , c(row) f(1) append

****************************************************
//Reason for migration

*age
tab v013 rc_migrant_reason [iw=wt], row nofreq 

*residence
tab v025 rc_migrant_reason [iw=wt], row nofreq 

*type of migration
tab v025 rc_migrant_type [iw=wt], row nofreq 

*region
tab v024 rc_migrant_reason [iw=wt], row nofreq 

*wealth
tab v190 rc_migrant_reason [iw=wt], row nofreq 

* output to excel
tabout v013 rc_migrant_type v025 v024 v190 rc_migrant_reason using Tables_migrant_wm.xls [iw=wt] , c(row) f(1) append

}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {
* limiting to men age 15-49
drop if mv012<15 | mv012>49

gen wt=mv005/1000000
**************************************************************************************************
* Background characteristics: excel file Tables_background_mn will be produced
**************************************************************************************************

*age
tab mv013 [iw=wt] 

*marital status
tab mv501 [iw=wt] 

*residence
tab mv025 [iw=wt] 

*region
tab mv024 [iw=wt] 

*education
tab mv106 [iw=wt] 

*wealth
tab mv190 [iw=wt] 

* output to excel
tabout mv013 mv501 mv025 mv106 mv024 mv190 using Tables_background_mn.xls [iw=wt] , oneway cells(cell freq) replace 
*/
**************************************************************************************************
* Indicators for education and literacy: excel file Tables_educ_mn will be produced
**************************************************************************************************
//Highest level of schooling

*age
tab mv013 rc_edu [iw=wt], row nofreq 

*residence
tab mv025 rc_edu [iw=wt], row nofreq 

*region
tab mv024 rc_edu [iw=wt], row nofreq 

*wealth
tab mv190 rc_edu [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv190 rc_edu using Tables_educ_mn.xls [iw=wt] , c(row) f(1) replace 

//Median years of schooling
tab rc_edu_median 

tabout rc_edu_median using Tables_educ_mn.xls [iw=wt] , oneway cells(cell) append 

****************************************************
//Literacy levels

*age
tab mv013 rc_litr_cats [iw=wt], row nofreq 

*residence
tab mv025 rc_litr_cats [iw=wt], row nofreq 

*region
tab mv024 rc_litr_cats [iw=wt], row nofreq 

*wealth
tab mv190 rc_litr_cats [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv190 rc_litr_cats using Tables_educ_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Literate 

*age
tab mv013 rc_litr [iw=wt], row nofreq 

*residence
tab mv025 rc_litr [iw=wt], row nofreq 

*region
tab mv024 rc_litr [iw=wt], row nofreq 

*wealth
tab mv190 rc_litr [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv190 rc_litr using Tables_educ_mn.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Indicators for media exposure and internet use: excel file Tables_media_mn will be produced
**************************************************************************************************
//Reads a newspaper

*age
tab mv013 rc_media_newsp [iw=wt], row nofreq 

*residence
tab mv025 rc_media_newsp [iw=wt], row nofreq 

*region
tab mv024 rc_media_newsp [iw=wt], row nofreq 

*education
tab mv106 rc_media_newsp [iw=wt], row nofreq 

*wealth
tab mv190 rc_media_newsp [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_media_newsp using Tables_media_mn.xls [iw=wt] , c(row) f(1) replace 

****************************************************
//Watches TV

*age
tab mv013 rc_media_tv [iw=wt], row nofreq 

*residence
tab mv025 rc_media_tv [iw=wt], row nofreq 

*region
tab mv024 rc_media_tv [iw=wt], row nofreq 

*education
tab mv106 rc_media_tv [iw=wt], row nofreq 

*wealth
tab mv190 rc_media_tv [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_media_tv using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Listens to radio

*age
tab mv013 rc_media_radio [iw=wt], row nofreq 

*residence
tab mv025 rc_media_radio [iw=wt], row nofreq 

*region
tab mv024 rc_media_radio [iw=wt], row nofreq 

*education
tab mv106 rc_media_radio [iw=wt], row nofreq 

*wealth
tab mv190 rc_media_radio [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_media_radio using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//All three media

*age
tab mv013 rc_media_allthree [iw=wt], row nofreq 

*residence
tab mv025 rc_media_allthree [iw=wt], row nofreq 

*region
tab mv024 rc_media_allthree [iw=wt], row nofreq 

*education
tab mv106 rc_media_allthree [iw=wt], row nofreq 

*wealth
tab mv190 rc_media_allthree [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_media_allthree using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//None of the media forms

*age
tab mv013 rc_media_none [iw=wt], row nofreq 

*residence
tab mv025 rc_media_none [iw=wt], row nofreq 

*region
tab mv024 rc_media_none [iw=wt], row nofreq 

*education
tab mv106 rc_media_none [iw=wt], row nofreq 

*wealth
tab mv190 rc_media_none [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_media_none using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Ever used the internet
* Indicator not available in all surveys so will add cap
*age
cap tab mv013 rc_intr_ever [iw=wt], row nofreq 

*residence
cap tab mv025 rc_intr_ever [iw=wt], row nofreq 

*region
cap tab mv024 rc_intr_ever [iw=wt], row nofreq 

*education
cap tab mv106 rc_intr_ever [iw=wt], row nofreq 

*wealth
cap tab mv190 rc_intr_ever [iw=wt], row nofreq 

* output to excel
cap tabout mv013 mv025 mv024 mv106 mv190 rc_intr_ever using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Internet use in the last 12 months
* Indicator not available in all surveys so will add cap
*age
cap tab mv013 rc_intr_use12mo [iw=wt], row nofreq 

*residence
cap tab mv025 rc_intr_use12mo [iw=wt], row nofreq 

*region
cap tab mv024 rc_intr_use12mo [iw=wt], row nofreq 

*education
cap tab mv106 rc_intr_use12mo [iw=wt], row nofreq 

*wealth
cap tab mv190 rc_intr_use12mo [iw=wt], row nofreq 

* output to excel
cap tabout mv013 mv025 mv024 mv106 mv190 rc_intr_use12mo using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Internet use frequency
* Indicator not available in all surveys so will add cap
*age
cap tab mv013 rc_intr_usefreq [iw=wt], row nofreq 

*residence
cap tab mv025 rc_intr_usefreq [iw=wt], row nofreq 

*region
cap tab mv024 rc_intr_usefreq [iw=wt], row nofreq 

*education
cap tab mv106 rc_intr_usefreq [iw=wt], row nofreq 

*wealth
cap tab mv190 rc_intr_usefreq [iw=wt], row nofreq 

* output to excel
cap tabout mv013 mv025 mv024 mv106 mv190 rc_intr_usefreq using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Indicators for employment and occupation: excel file Tables_employ_mn will be produced
**************************************************************************************************
//Employment status

*age
tab mv013 rc_empl [iw=wt], row nofreq 

*marital status
tab mv502 rc_empl [iw=wt], row nofreq 

*residence
tab mv025 rc_empl [iw=wt], row nofreq 

*region
tab mv024 rc_empl [iw=wt], row nofreq 

*education
tab mv106 rc_empl [iw=wt], row nofreq 

*wealth
tab mv190 rc_empl [iw=wt], row nofreq 

* output to excel
tabout mv013 mv502 mv025 mv024 mv106 mv190 rc_empl using Tables_employ_mn.xls [iw=wt] , c(row) f(1) replace 

****************************************************************************
//Occupation

*age
tab mv013 rc_occup [iw=wt], row nofreq 

*marital status
tab mv502 rc_occup [iw=wt], row nofreq 

*residence
tab mv025 rc_occup [iw=wt], row nofreq 

*region
tab mv024 rc_occup [iw=wt], row nofreq 

*education
tab mv106 rc_occup [iw=wt], row nofreq 

*wealth
tab mv190 rc_occup [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_occup using Tables_employ_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************************************
*
recode mv717 (1/3 6/9 96/99 .=0 "Non-Agriculture") (4/5=1 "Agriculture") if inlist(mv731,1,2,3), gen(agri)

//Type of employer
tab rc_empl_type agri [iw=wt], col nofreq 

//Type of earnings
tab rc_empl_earn agri [iw=wt], col nofreq 

*Continuity of employment
tab rc_empl_cont agri [iw=wt], col nofreq 

* output to excel
cap tabout rc_empl_type rc_empl_earn rc_empl_cont agri using Tables_employ_mn.xls [iw=wt], c(col) f(1) append 
*/

**************************************************************************************************
* Indicators for health insurance: excel file Tables_insurance_wm will be produced
**************************************************************************************************
//Social security

*age
tab mv013 rc_hins_ss [iw=wt], row nofreq 

*residence
tab mv025 rc_hins_ss [iw=wt], row nofreq 

*region
tab mv024 rc_hins_ss [iw=wt], row nofreq 

*education
tab mv106 rc_hins_ss [iw=wt], row nofreq 

*wealth
tab mv190 rc_hins_ss [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_hins_ss using Tables_insurance_mn.xls [iw=wt] , c(row) f(1) replace 

****************************************************
//Other employer based insurance

*age
tab mv013 rc_hins_empl [iw=wt], row nofreq 

*residence
tab mv025 rc_hins_empl [iw=wt], row nofreq 

*region
tab mv024 rc_hins_empl [iw=wt], row nofreq 

*education
tab mv106 rc_hins_empl [iw=wt], row nofreq 

*wealth
tab mv190 rc_hins_empl [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_hins_empl using Tables_insurance_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Community-based insurance

*age
tab mv013 rc_hins_comm [iw=wt], row nofreq 

*residence
tab mv025 rc_hins_comm [iw=wt], row nofreq 

*region
tab mv024 rc_hins_comm [iw=wt], row nofreq 

*education
tab mv106 rc_hins_comm [iw=wt], row nofreq 

*wealth
tab mv190 rc_hins_comm [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_hins_comm using Tables_insurance_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Private insurance

*age
tab mv013 rc_hins_priv [iw=wt], row nofreq 

*residence
tab mv025 rc_hins_priv [iw=wt], row nofreq 

*region
tab mv024 rc_hins_priv [iw=wt], row nofreq 

*education
tab mv106 rc_hins_priv [iw=wt], row nofreq 

*wealth
tab mv190 rc_hins_priv [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_hins_priv using Tables_insurance_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Other type of insurance

*age
tab mv013 rc_hins_other [iw=wt], row nofreq 

*residence
tab mv025 rc_hins_other [iw=wt], row nofreq 

*region
tab mv024 rc_hins_other [iw=wt], row nofreq 

*education
tab mv106 rc_hins_other [iw=wt], row nofreq 

*wealth
tab mv190 rc_hins_other [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_hins_other using Tables_insurance_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Have any insurance

*age
tab mv013 rc_hins_any [iw=wt], row nofreq 

*residence
tab mv025 rc_hins_any [iw=wt], row nofreq 

*region
tab mv024 rc_hins_any [iw=wt], row nofreq 

*education
tab mv106 rc_hins_any [iw=wt], row nofreq 

*wealth
tab mv190 rc_hins_any [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_hins_any using Tables_insurance_mn.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Indicators for tobacco use: excel file Tables_tobac_mn will be produced
**************************************************************************************************
//Smokes cigarettes

*age
tab mv013 rc_tobc_cig [iw=wt], row nofreq 

*residence
tab mv025 rc_tobc_cig [iw=wt], row nofreq 

*region
tab mv024 rc_tobc_cig [iw=wt], row nofreq 

*education
tab mv106 rc_tobc_cig [iw=wt], row nofreq 

*wealth
tab mv190 rc_tobc_cig [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_tobc_cig using Tables_tobac_mn.xls [iw=wt] , c(row) f(1) replace 

****************************************************
//Smokes other type of tobacco

*age
tab mv013 rc_tobc_other [iw=wt], row nofreq 

*residence
tab mv025 rc_tobc_other [iw=wt], row nofreq 

*region
tab mv024 rc_tobc_other [iw=wt], row nofreq 

*education
tab mv106 rc_tobc_other [iw=wt], row nofreq 

*wealth
tab mv190 rc_tobc_other [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_tobc_other using Tables_tobac_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Smokes any tobacco

*age
tab mv013 rc_tobc_smk_any [iw=wt], row nofreq 

*residence
tab mv025 rc_tobc_smk_any [iw=wt], row nofreq 

*region
tab mv024 rc_tobc_smk_any [iw=wt], row nofreq 

*education
tab mv106 rc_tobc_smk_any [iw=wt], row nofreq 

*wealth
tab mv190 rc_tobc_smk_any [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_tobc_smk_any using Tables_tobac_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Smoking frequency

*age
cap tab mv013 rc_smk_freq [iw=wt], row nofreq 

*residence
cap tab mv025 rc_smk_freq [iw=wt], row nofreq 

*region
cap tab mv024 rc_smk_freq [iw=wt], row nofreq 

*education
cap tab mv106 rc_smk_freq [iw=wt], row nofreq 

*wealth
cap tab mv190 rc_smk_freq [iw=wt], row nofreq 

* output to excel
cap tabout mv013 mv025 mv024 mv106 mv190 rc_smk_freq using Tables_tobac_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Average number of cigarettes per day

*age
cap tab mv013 rc_cig_day [iw=wt], row nofreq 

*residence
cap tab mv025 rc_cig_day [iw=wt], row nofreq 

*region
cap tab mv024 rc_cig_day [iw=wt], row nofreq 

*education
cap tab mv106 rc_cig_day [iw=wt], row nofreq 

*wealth
cap tab mv190 rc_cig_day [iw=wt], row nofreq 

* output to excel
cap tabout mv013 mv025 mv024 mv106 mv190 rc_cig_day using Tables_tobac_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
* Smokeless tobacco use

//Snuff by mouth
cap tab rc_tobc_snuffm [iw=wt]

//Snuff by nose
cap tab rc_tobc_snuffn [iw=wt]

//Chews tobacco
cap tab rc_tobc_chew [iw=wt]

//Betel quid with tobacco
cap tab rc_tobv_betel [iw=wt]

//Other type of smokless tobacco
cap tab rc_tobc_osmkless [iw=wt]

//Any smokeless tobacco
cap tab rc_tobc_anysmkless [iw=wt]

//Uses any type of tobacco
cap tab rc_tobc_any [iw=wt]

* output to excel
cap tabout rc_tobc_snuffm rc_tobc_snuffn rc_tobc_chew rc_tobv_betel rc_tobc_osmkless rc_tobc_anysmkless rc_tobc_any using Tables_tobac_mn.xls [iw=wt] , oneway cells(cell freq) append 
**************************************************************************************************
* Indicators for alcohol use: excel file Tables_alco_mn will be produced
**************************************************************************************************
// Consumed any alcohol

*age
tab mv013 rc_alc_any [iw=wt], row nofreq 

*residence
tab mv025 rc_alc_any [iw=wt], row nofreq 

*region
tab mv024 rc_alc_any [iw=wt], row nofreq 

*education
tab mv106 rc_alc_any [iw=wt], row nofreq 

*wealth
tab mv190 rc_alc_any [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_alc_any using Tables_alco_mn.xls [iw=wt] , c(row) f(1) replace 
****************************************************
//Frequency of drinking 
*age
tab mv013 rc_alc_freq [iw=wt], row nofreq 

*residence
tab mv025 rc_alc_freq [iw=wt], row nofreq 

*region
tab mv024 rc_alc_freq [iw=wt], row nofreq 

*education
tab mv106 rc_alc_freq [iw=wt], row nofreq 

*wealth
tab mv190 rc_alc_freq [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_alc_freq using Tables_alco_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Average number of drinks
*age
tab mv013 rc_alc_drinks [iw=wt], row nofreq 

*age
tab rc_alc_freq rc_alc_drinks [iw=wt], row nofreq 

*residence
tab mv025 rc_alc_drinks [iw=wt], row nofreq 

*region
tab mv024 rc_alc_drinks [iw=wt], row nofreq 

*education
tab mv106 rc_alc_drinks [iw=wt], row nofreq 

*wealth
tab mv190 rc_alc_drinks [iw=wt], row nofreq 

* output to excel
tabout mv013 rc_alc_freq mv025 mv024 mv106 mv190 rc_alc_drinks using Tables_alco_mn.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Indicators for migration: excel file Tables_migrant_mn will be produced
**************************************************************************************************
//Place of birth
*age
tab mv013 rc_place_birth [iw=wt], row nofreq 

*residence
tab mv025 rc_place_birth [iw=wt], row nofreq 

*region
tab mv024 rc_place_birth [iw=wt], row nofreq 

*wealth
tab mv190 rc_place_birth [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv190 rc_place_birth using Tables_migrant_mn.xls [iw=wt] , c(row) f(1) replace 
****************************************************
//Migrated in the last 5 years
*age
tab mv013 rc_migrant_5yrs [iw=wt], row nofreq 

*residence
tab mv025 rc_migrant_5yrs [iw=wt], row nofreq 

*region
tab mv024 rc_migrant_5yrs [iw=wt], row nofreq 

*wealth
tab mv190 rc_migrant_5yrs [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv190 rc_migrant_5yrs using Tables_migrant_mn.xls [iw=wt] , c(row) f(1) append
****************************************************
//Type of migration by age

tab v013 rc_migrant_type [iw=wt], row nofreq 
tabout v013 rc_migrant_type using Tables_migrant_mn.xls [iw=wt] , c(row) f(1) append

****************************************************
//Reason for migration

*age
tab mv013 rc_migrant_reason [iw=wt], row nofreq 

*residence
tab mv025 rc_migrant_reason [iw=wt], row nofreq 

*type of migration
tab mv025 rc_migrant_type [iw=wt], row nofreq 

*region
tab mv024 rc_migrant_reason [iw=wt], row nofreq 

*wealth
tab mv190 rc_migrant_reason [iw=wt], row nofreq 

* output to excel
tabout mv013 rc_migrant_type mv025 mv024 mv190 rc_migrant_reason using Tables_migrant_mn.xls [iw=wt] , c(row) f(1) append
}

