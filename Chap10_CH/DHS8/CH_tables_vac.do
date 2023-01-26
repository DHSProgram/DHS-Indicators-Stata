/*****************************************************************************************************
Program: 			CH_tables_vac.do
Purpose: 			produce tables for vaccination indicators
Author:				Shireen Assaf
Date last modified: Jan 24, 2023 by Shireen Assaf 
	
This do file will produce the following tables in excel:
1. 	Tables_Vac_card:		Contains the tables for possession and observation of vaccination cards
2.	Tables_Vac_tot.xls:		Contains the tables vaccination by source of information
3.	Tables_Vac_vars.xls: 	Contains the tables for vaccination by background variables.  

Notes:	These tables will be produced for the age group selection in the CH_VAC.do file. 
		The default section is children 12-23 months. If estimates are requried for children 24-35 months, 
		the CH_VAC.do file needs to be run again with that age group selection and then this do file to produce the tables. 
		
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

cap gen wt=v005/1000000

* Non-standard background variable to add to tables
* birth order: 1, 2-3, 4-5, 6+
cap gen birth_order=1
replace birth_order=2 if bord>1 
replace birth_order=3 if bord>3
replace birth_order=4 if bord>5 
replace birth_order=. if bord==.
cap label define birth_order 1 "1" 2"2-3" 3 "4-5" 4 "6+"
label values birth_order birth_order

**************************************************************************************************
* Table for possession and observation of vaccination cards
**************************************************************************************************
//Ever had a vaccination card

*child's sex
tab b4 ch_card_ever_had [iw=wt], row nofreq 

*birth order
tab birth_order ch_card_ever_had [iw=wt], row nofreq 

*residence
tab v025 ch_card_ever_had [iw=wt], row nofreq 

*region
tab v024 ch_card_ever_had [iw=wt], row nofreq 

*education
tab v106 ch_card_ever_had [iw=wt], row nofreq 

*wealth
tab v190 ch_card_ever_had [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_card_ever_had using Tables_Vac_card.xls [iw=wt], c(row) f(1) replace 
*/
****************************************************
//Vaccination card seen

*child's sex
tab b4 ch_card_seen [iw=wt], row nofreq 

*birth order
tab birth_order ch_card_seen [iw=wt], row nofreq 

*residence
tab v025 ch_card_seen [iw=wt], row nofreq 

*region
tab v024 ch_card_seen [iw=wt], row nofreq 

*education
tab v106 ch_card_seen [iw=wt], row nofreq 

*wealth
tab v190 ch_card_seen [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_card_seen using Tables_Vac_card.xls [iw=wt], c(row) f(1) append 
*/

**************************************************************************************************
* Tables for vaccines by source
**************************************************************************************************
//BCG
tab1 ch_bcg_card ch_bcg_moth ch_bcg_either [iw=wt]

//DPT
tab1	ch_pent1_card ch_pent1_moth ch_pent1_either ///
		ch_pent2_card ch_pent2_moth	ch_pent2_either	///
		ch_pent3_card ch_pent3_moth ch_pent3_either	[iw=wt]	

//Polio
tab1	ch_polio0_card ch_polio0_moth ch_polio0_either ///	
		ch_polio1_card ch_polio1_moth ch_polio1_either ///
		ch_polio2_card ch_polio2_moth ch_polio2_either ///
		ch_polio3_card ch_polio3_moth ch_polio3_either [iw=wt]
		
//IPV
tab1 ch_ipv_card ch_ipv_moth ch_ipv_either [iw=wt]

//Pneumococcal
tab1	ch_pneumo1_card ch_pneumo1_moth ch_pneumo1_either ///	
		ch_pneumo2_card ch_pneumo2_moth ch_pneumo2_either ///
		ch_pneumo3_card ch_pneumo3_moth ch_pneumo3_either [iw=wt]

//Rotavirus
tab1	ch_rotav1_card ch_rotav1_moth ch_rotav1_either ///	
		ch_rotav2_card ch_rotav2_moth ch_rotav2_either ///	
		ch_rotav3_card ch_rotav3_moth ch_rotav3_either [iw=wt]

//Measles
tab1 ch_meas_card ch_meas_moth ch_meas_either [iw=wt]

//All basic vaccinations
tab1 ch_allvac_card ch_allvac_moth ch_allvac_either	[iw=wt]

//All vaccinations according to national schedule 
tab1 ch_allvac_schd_card ch_allvac_schd_moth ch_allvac_schd_either	[iw=wt]

//No vaccinations
tab1 ch_novac_card ch_novac_moth ch_novac_either [iw=wt]	

* output to excel
tabout	ch_bcg_card ch_bcg_moth ch_bcg_either ch_pent1_card ch_pent1_moth ch_pent1_either ///
		ch_pent2_card ch_pent2_moth	ch_pent2_either	ch_pent3_card ch_pent3_moth ch_pent3_either	 ///
		ch_polio0_card ch_polio0_moth ch_polio0_either ch_polio1_card ch_polio1_moth ch_polio1_either ///
		ch_polio2_card ch_polio2_moth ch_polio2_either ch_polio3_card ch_polio3_moth ch_polio3_either ///
		ch_ipv_card ch_ipv_moth ch_ipv_either ///
		ch_pneumo1_card ch_pneumo1_moth ch_pneumo1_either ch_pneumo2_card ch_pneumo2_moth ch_pneumo2_either ///
		ch_pneumo3_card ch_pneumo3_moth ch_pneumo3_either ch_rotav1_card ch_rotav1_moth ch_rotav1_either ///	
		ch_rotav2_card ch_rotav2_moth ch_rotav2_either ch_rotav3_card ch_rotav3_moth ch_rotav3_either ///
		ch_meas_card ch_meas_moth ch_meas_either ch_allvac_card ch_allvac_moth ch_allvac_either ///
		ch_allvac_schd_card ch_allvac_schd_moth ch_allvac_schd_either ///
		ch_novac_card ch_novac_moth ch_novac_either using Tables_Vac_tot.xls [iw=wt] , oneway cells(cell) f(1) replace 
		
		
**************************************************************************************************
* Table for vaccinations by background variables: 
* Note: this table is for children age 12-23. If you have 
* selected the 24-35 age group in the CH_VAC.do file, then you must rerun the do file with selecting the 12-23
* age group in order to match the table.
**************************************************************************************************
//BCG

*child's sex
tab b4 ch_bcg_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_bcg_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_bcg_either [iw=wt], row nofreq 

*residence
tab v025 ch_bcg_either [iw=wt], row nofreq 

*region
tab v024 ch_bcg_either [iw=wt], row nofreq 

*education
tab v106 ch_bcg_either [iw=wt], row nofreq 

*wealth
tab v190 ch_bcg_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_bcg_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) replace 
*/
****************************************************
//DPT1

*child's sex
tab b4 ch_pent1_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_pent1_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_pent1_either [iw=wt], row nofreq 

*residence
tab v025 ch_pent1_either [iw=wt], row nofreq 

*region
tab v024 ch_pent1_either [iw=wt], row nofreq 

*education
tab v106 ch_pent1_either [iw=wt], row nofreq 

*wealth
tab v190 ch_pent1_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_pent1_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//DPT2

*child's sex
tab b4 ch_pent2_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_pent2_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_pent2_either [iw=wt], row nofreq 

*residence
tab v025 ch_pent2_either [iw=wt], row nofreq 

*region
tab v024 ch_pent2_either [iw=wt], row nofreq 

*education
tab v106 ch_pent2_either [iw=wt], row nofreq 

*wealth
tab v190 ch_pent2_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_pent2_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//DPT3

*child's sex
tab b4 ch_pent3_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_pent3_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_pent3_either [iw=wt], row nofreq 

*residence
tab v025 ch_pent3_either [iw=wt], row nofreq 

*region
tab v024 ch_pent3_either [iw=wt], row nofreq 

*education
tab v106 ch_pent3_either [iw=wt], row nofreq 

*wealth
tab v190 ch_pent3_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_pent3_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Polio0

*child's sex
tab b4 ch_polio0_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_polio0_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_polio0_either [iw=wt], row nofreq 

*residence
tab v025 ch_polio0_either [iw=wt], row nofreq 

*region
tab v024 ch_polio0_either [iw=wt], row nofreq 

*education
tab v106 ch_polio0_either [iw=wt], row nofreq 

*wealth
tab v190 ch_polio0_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_polio0_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Polio1

*child's sex
tab b4 ch_polio1_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_polio1_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_polio1_either [iw=wt], row nofreq 

*residence
tab v025 ch_polio1_either [iw=wt], row nofreq 

*region
tab v024 ch_polio1_either [iw=wt], row nofreq 

*education
tab v106 ch_polio1_either [iw=wt], row nofreq 

*wealth
tab v190 ch_polio1_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_polio1_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Polio2

*child's sex
tab b4 ch_polio2_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_polio2_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_polio2_either [iw=wt], row nofreq 

*residence
tab v025 ch_polio2_either [iw=wt], row nofreq 

*region
tab v024 ch_polio2_either [iw=wt], row nofreq 

*education
tab v106 ch_polio2_either [iw=wt], row nofreq 

*wealth
tab v190 ch_polio2_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_polio2_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Polio3

*child's sex
tab b4 ch_polio3_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_polio3_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_polio3_either [iw=wt], row nofreq 

*residence
tab v025 ch_polio3_either [iw=wt], row nofreq 

*region
tab v024 ch_polio3_either [iw=wt], row nofreq 

*education
tab v106 ch_polio3_either [iw=wt], row nofreq 

*wealth
tab v190 ch_polio3_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_polio3_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//IPV

*child's sex
tab b4 ch_ipv_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_ipv_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_ipv_either [iw=wt], row nofreq 

*residence
tab v025 ch_ipv_either [iw=wt], row nofreq 

*region
tab v024 ch_ipv_either [iw=wt], row nofreq 

*education
tab v106 ch_ipv_either [iw=wt], row nofreq 

*wealth
tab v190 ch_ipv_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_ipv_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Pneumococcal1

*child's sex
tab b4 ch_pneumo1_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_pneumo1_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_pneumo1_either [iw=wt], row nofreq 

*residence
tab v025 ch_pneumo1_either [iw=wt], row nofreq 

*region
tab v024 ch_pneumo1_either [iw=wt], row nofreq 

*education
tab v106 ch_pneumo1_either [iw=wt], row nofreq 

*wealth
tab v190 ch_pneumo1_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_pneumo1_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Pneumococcal2

*child's sex
tab b4 ch_pneumo2_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_pneumo2_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_pneumo2_either [iw=wt], row nofreq 

*residence
tab v025 ch_pneumo2_either [iw=wt], row nofreq 

*region
tab v024 ch_pneumo2_either [iw=wt], row nofreq 

*education
tab v106 ch_pneumo2_either [iw=wt], row nofreq 

*wealth
tab v190 ch_pneumo2_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_pneumo2_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Pneumococcal3

*child's sex
tab b4 ch_pneumo3_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_pneumo3_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_pneumo3_either [iw=wt], row nofreq 

*residence
tab v025 ch_pneumo3_either [iw=wt], row nofreq 

*region
tab v024 ch_pneumo3_either [iw=wt], row nofreq 

*education
tab v106 ch_pneumo3_either [iw=wt], row nofreq 

*wealth
tab v190 ch_pneumo3_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_pneumo3_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Rotavirus1

*child's sex
tab b4 ch_rotav1_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_rotav1_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_rotav1_either [iw=wt], row nofreq 

*residence
tab v025 ch_rotav1_either [iw=wt], row nofreq 

*region
tab v024 ch_rotav1_either [iw=wt], row nofreq 

*education
tab v106 ch_rotav1_either [iw=wt], row nofreq 

*wealth
tab v190 ch_rotav1_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_rotav1_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Rotavirus2

*child's sex
tab b4 ch_rotav2_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_rotav2_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_rotav2_either [iw=wt], row nofreq 

*residence
tab v025 ch_rotav2_either [iw=wt], row nofreq 

*region
tab v024 ch_rotav2_either [iw=wt], row nofreq 

*education
tab v106 ch_rotav2_either [iw=wt], row nofreq 

*wealth
tab v190 ch_rotav2_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_rotav2_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Rotavirus3

*child's sex
tab b4 ch_rotav3_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_rotav3_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_rotav3_either [iw=wt], row nofreq 

*residence
tab v025 ch_rotav3_either [iw=wt], row nofreq 

*region
tab v024 ch_rotav3_either [iw=wt], row nofreq 

*education
tab v106 ch_rotav3_either [iw=wt], row nofreq 

*wealth
tab v190 ch_rotav3_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_rotav3_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Measles

*child's sex
tab b4 ch_meas_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_meas_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_meas_either [iw=wt], row nofreq 

*residence
tab v025 ch_meas_either [iw=wt], row nofreq 

*region
tab v024 ch_meas_either [iw=wt], row nofreq 

*education
tab v106 ch_meas_either [iw=wt], row nofreq 

*wealth
tab v190 ch_meas_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_meas_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//All basic vaccinations

*child's sex
tab b4 ch_allvac_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_allvac_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_allvac_either [iw=wt], row nofreq 

*residence
tab v025 ch_allvac_either [iw=wt], row nofreq 

*region
tab v024 ch_allvac_either [iw=wt], row nofreq 

*education
tab v106 ch_allvac_either [iw=wt], row nofreq 

*wealth
tab v190 ch_allvac_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_allvac_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//All basic vaccinations according to national schedule

*child's sex
tab b4 ch_allvac_schd_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_allvac_schd_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_allvac_schd_either [iw=wt], row nofreq 

*residence
tab v025 ch_allvac_schd_either [iw=wt], row nofreq 

*region
tab v024 ch_allvac_schd_either [iw=wt], row nofreq 

*education
tab v106 ch_allvac_schd_either [iw=wt], row nofreq 

*wealth
tab v190 ch_allvac_schd_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_allvac_schd_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//No vaccinations

*child's sex
tab b4 ch_novac_either [iw=wt], row nofreq 

*birth order
tab birth_order ch_novac_either [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_novac_either [iw=wt], row nofreq 

*residence
tab v025 ch_novac_either [iw=wt], row nofreq 

*region
tab v024 ch_novac_either [iw=wt], row nofreq 

*education
tab v106 ch_novac_either [iw=wt], row nofreq 

*wealth
tab v190 ch_novac_either [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_novac_either using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/
****************************************************
//Source of vaccinations

*child's sex
tab b4 ch_vac_source [iw=wt], row nofreq 

*birth order
tab birth_order ch_vac_source [iw=wt], row nofreq 

*vaccination card seen
tab ch_card_seen ch_vac_source [iw=wt], row nofreq 

*residence
tab v025 ch_vac_source [iw=wt], row nofreq 

*region
tab v024 ch_vac_source [iw=wt], row nofreq 

*education
tab v106 ch_vac_source [iw=wt], row nofreq 

*wealth
tab v190 ch_vac_source [iw=wt], row nofreq 

* output to excel
tabout b4 birth_order ch_card_seen v025 v106 v024 v190 ch_vac_source using Tables_Vac_vars.xls [iw=wt], c(row) f(1) append 
*/