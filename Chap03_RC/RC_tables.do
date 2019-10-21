/*****************************************************************************************************
Program: 			RC_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: October 3 2019 by Shireen Assaf 

*Note this do file will produce the following tables in excel:
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

Notes: 					 						
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file
if file=="IR" {
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

*age
tab v013 rc_intr_ever [iw=wt], row nofreq 

*residence
tab v025 rc_intr_ever [iw=wt], row nofreq 

*region
tab v024 rc_intr_ever [iw=wt], row nofreq 

*education
tab v106 rc_intr_ever [iw=wt], row nofreq 

*wealth
tab v190 rc_intr_ever [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_intr_ever using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Internet use in the last 12 months

*age
tab v013 rc_intr_use12mo [iw=wt], row nofreq 

*residence
tab v025 rc_intr_use12mo [iw=wt], row nofreq 

*region
tab v024 rc_intr_use12mo [iw=wt], row nofreq 

*education
tab v106 rc_intr_use12mo [iw=wt], row nofreq 

*wealth
tab v190 rc_intr_use12mo [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_intr_use12mo using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Internet use frequency

*age
tab v013 rc_intr_usefreq [iw=wt], row nofreq 

*residence
tab v025 rc_intr_usefreq [iw=wt], row nofreq 

*region
tab v024 rc_intr_usefreq [iw=wt], row nofreq 

*education
tab v106 rc_intr_usefreq [iw=wt], row nofreq 

*wealth
tab v190 rc_intr_usefreq [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v024 v106 v190 rc_intr_usefreq using Tables_media_wm.xls [iw=wt] , c(row) f(1) append 

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

//Snuff by mouth
tab rc_tobc_snuffm [iw=wt]

//Snuff by nose
tab rc_tobc_snuffn [iw=wt]

//Chews tobacco
tab rc_tobc_chew [iw=wt]

//Betel quid with tobacco
tab rc_tobv_betel [iw=wt]

//Other type of smokless tobacco
tab rc_tobc_osmkless [iw=wt]

//Any smokeless tobacco
tab rc_tobc_anysmkless [iw=wt]

//Uses any type of tobacco
tab rc_tobc_any [iw=wt]

* output to excel
tabout rc_tobc_snuffm rc_tobc_snuffn rc_tobc_chew rc_tobv_betel rc_tobc_osmkless rc_tobc_anysmkless rc_tobc_any using Tables_tobac_wm.xls [iw=wt] , oneway cells(cell freq) append 

}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {
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

*age
tab mv013 rc_intr_ever [iw=wt], row nofreq 

*residence
tab mv025 rc_intr_ever [iw=wt], row nofreq 

*region
tab mv024 rc_intr_ever [iw=wt], row nofreq 

*education
tab mv106 rc_intr_ever [iw=wt], row nofreq 

*wealth
tab mv190 rc_intr_ever [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_intr_ever using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Internet use in the last 12 months

*age
tab mv013 rc_intr_use12mo [iw=wt], row nofreq 

*residence
tab mv025 rc_intr_use12mo [iw=wt], row nofreq 

*region
tab mv024 rc_intr_use12mo [iw=wt], row nofreq 

*education
tab mv106 rc_intr_use12mo [iw=wt], row nofreq 

*wealth
tab mv190 rc_intr_use12mo [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_intr_use12mo using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Internet use frequency

*age
tab mv013 rc_intr_usefreq [iw=wt], row nofreq 

*residence
tab mv025 rc_intr_usefreq [iw=wt], row nofreq 

*region
tab mv024 rc_intr_usefreq [iw=wt], row nofreq 

*education
tab mv106 rc_intr_usefreq [iw=wt], row nofreq 

*wealth
tab mv190 rc_intr_usefreq [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_intr_usefreq using Tables_media_mn.xls [iw=wt] , c(row) f(1) append 

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
tab mv013 rc_smk_freq [iw=wt], row nofreq 

*residence
tab mv025 rc_smk_freq [iw=wt], row nofreq 

*region
tab mv024 rc_smk_freq [iw=wt], row nofreq 

*education
tab mv106 rc_smk_freq [iw=wt], row nofreq 

*wealth
tab mv190 rc_smk_freq [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_smk_freq using Tables_tobac_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Average number of cigarettes per day

*age
tab mv013 rc_cig_day [iw=wt], row nofreq 

*residence
tab mv025 rc_cig_day [iw=wt], row nofreq 

*region
tab mv024 rc_cig_day [iw=wt], row nofreq 

*education
tab mv106 rc_cig_day [iw=wt], row nofreq 

*wealth
tab mv190 rc_cig_day [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 rc_cig_day using Tables_tobac_mn.xls [iw=wt] , c(row) f(1) append 

****************************************************
* Smokeless tobacco use

//Snuff by mouth
tab rc_tobc_snuffm [iw=wt]

//Snuff by nose
tab rc_tobc_snuffn [iw=wt]

//Chews tobacco
tab rc_tobc_chew [iw=wt]

//Betel quid with tobacco
tab rc_tobv_betel [iw=wt]

//Other type of smokless tobacco
tab rc_tobc_osmkless [iw=wt]

//Any smokeless tobacco
tab rc_tobc_anysmkless [iw=wt]

//Uses any type of tobacco
tab rc_tobc_any [iw=wt]

* output to excel
tabout rc_tobc_snuffm rc_tobc_snuffn rc_tobc_chew rc_tobv_betel rc_tobc_osmkless rc_tobc_anysmkless rc_tobc_any using Tables_tobac_mn.xls [iw=wt] , oneway cells(cell freq) append 

}

