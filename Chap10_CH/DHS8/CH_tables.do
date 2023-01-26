/*****************************************************************************************************
Program: 			CH_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: Jan 25, 2023 by Shireen Assaf 

*This do file will produce the following tables in excel:
1. 	Tables_Size:		Contains the tables for child's size indicators
2.	Tables_ARI_FV.xls:	Contains the tables for ARI and fever indicators
3.	Tables_DIAR.xls: 	Contains the tables for diarrhea indicators. 
	Note: these tabouts do not include the watsan indicators (source of drinking water and type of 
	toilet facility). For these indicators please check chapter 16 for WASH indicators which uses the PR file. 
	The PR file then needs to be merged with the coded KR file with the diarrhea indicators to include them in the tabulations. 

Notes: 	The indicators are outputed for women age 15-49 in line 785. This can be commented out if the indicators are required for all women/men.	
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************


* indicators from NR file
if file=="NR" {
gen wt=v005/1000000

* Non-standard background variable to add to tables
*Age in months
recode p19 (0/5=1 "<6") (6/11=2 "6-11") (12/23=3 "12-23") (24/35=4 "24-35") (36/47=5 "36-47") (48/59=6 "48-59"), gen(agecats)

* mother's age at birth (years): <20, 20-34, 35-49 
gen months_age=p3-v011
gen mo_age_at_birth=1 if months_age<20*12
replace mo_age_at_birth=2 if months_age>=20*12 & months_age<35*12
replace mo_age_at_birth=3 if months_age>=35*12 & months_age<50*12
label define mo_age_at_birth 1 "<20" 2 "20-34" 3 "35-49"
label values mo_age_at_birth mo_age_at_birth
drop months_age

* birth order: 1, 2-3, 4-5, 6+
gen birth_order=1
replace birth_order=2 if pord>1 
replace birth_order=3 if pord>3
replace birth_order=4 if pord>5 
replace birth_order=. if pord==.
label define birth_order 1 "1" 2"2-3" 3 "4-5" 4 "6+"
label values birth_order birth_order

**************************************************************************************************
* Indicators for child's size variables
**************************************************************************************************
//Child's size at birth

*mother age at birth
tab mo_age_at_birth ch_size_birth [iw=wt], row nofreq 

*birth order
tab birth_order ch_size_birth [iw=wt], row nofreq 

*residence
tab v025 ch_size_birth [iw=wt], row nofreq 

*region
tab v024 ch_size_birth [iw=wt], row nofreq 

*education
tab v106 ch_size_birth [iw=wt], row nofreq 

*wealth
tab v190 ch_size_birth [iw=wt], row nofreq 

* output to excel
tabout mo_age_at_birth birth_order v025 v106 v024 v190 ch_size_birth using Tables_Size.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Child has a reported birth weight

*mother age at birth
tab mo_age_at_birth ch_report_bw [iw=wt], row nofreq 

*birth order
tab birth_order ch_report_bw [iw=wt], row nofreq 

*residence
tab v025 ch_report_bw [iw=wt], row nofreq 

*region
tab v024 ch_report_bw [iw=wt], row nofreq 

*education
tab v106 ch_report_bw [iw=wt], row nofreq 

*wealth
tab v190 ch_report_bw [iw=wt], row nofreq 

* output to excel
tabout mo_age_at_birth birth_order v025 v106 v024 v190 ch_report_bw using Tables_Size.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Child reported birthweight by source

*mother age at birth
tab mo_age_at_birth ch_report_bw_source [iw=wt], row nofreq 

*birth order
tab birth_order ch_report_bw_source [iw=wt], row nofreq 

*residence
tab v025 ch_report_bw_source [iw=wt], row nofreq 

*region
tab v024 ch_report_bw_source [iw=wt], row nofreq 

*education
tab v106 ch_report_bw_source [iw=wt], row nofreq 

*wealth
tab v190 ch_report_bw_source [iw=wt], row nofreq 

* output to excel
tabout mo_age_at_birth birth_order v025 v106 v024 v190 ch_report_bw_source using Tables_Size.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Child weight is less than 2.5kg

*mother age at birth
tab mo_age_at_birth ch_below_2p5 [iw=wt], row nofreq 

*birth order
tab birth_order ch_below_2p5 [iw=wt], row nofreq 

*residence
tab v025 ch_below_2p5 [iw=wt], row nofreq 

*region
tab v024 ch_below_2p5 [iw=wt], row nofreq 

*education
tab v106 ch_below_2p5 [iw=wt], row nofreq 

*wealth
tab v190 ch_below_2p5 [iw=wt], row nofreq 

* output to excel
tabout mo_age_at_birth birth_order v025 v106 v024 v190 ch_below_2p5 using Tables_Size.xls [iw=wt] , c(row) f(1) append 

}



* indicators from KR file
if file=="KR" {
gen wt=v005/1000000

* Non-standard background variable to add to tables
*Age in months
recode b19 (0/5=1 "<6") (6/11=2 "6-11") (12/23=3 "12-23") (24/35=4 "24-35") (36/47=5 "36-47") (48/59=6 "48-59"), gen(agecats)

* mother's age at birth (years): <20, 20-34, 35-49 
gen months_age=b3-v011
gen mo_age_at_birth=1 if months_age<20*12
replace mo_age_at_birth=2 if months_age>=20*12 & months_age<35*12
replace mo_age_at_birth=3 if months_age>=35*12 & months_age<50*12
label define mo_age_at_birth 1 "<20" 2 "20-34" 3 "35-49"
label values mo_age_at_birth mo_age_at_birth
drop months_age

* birth order: 1, 2-3, 4-5, 6+
gen birth_order=1
replace birth_order=2 if bord>1 
replace birth_order=3 if bord>3
replace birth_order=4 if bord>5 
replace birth_order=. if bord==.
label define birth_order 1 "1" 2"2-3" 3 "4-5" 4 "6+"
label values birth_order birth_order
* tab bord birth_order

*cooking fuel
recode v161 (1/5=1 "electricity/gas") (9/13=2 "Solid waste") (7=3 "Gasoline/diesel") (8=4 "Kerosene/paraffin") (95=6 "No food cooked in house") (else=5 "Other fuel"), gen(fuel)
replace fuel =. if v161>=97


**************************************************************************************************
* Tables for ARI and fever indicators
**************************************************************************************************
//ARI symptoms

*Age in months
tab agecats ch_ari [iw=wt], row nofreq 

*Child's sex
tab b4 ch_ari [iw=wt], row nofreq 

*type of cooking fuel
tab fuel ch_ari [iw=wt], row nofreq 

*residence
tab v025 ch_ari [iw=wt], row nofreq 

*region
tab v024 ch_ari [iw=wt], row nofreq 

*education
tab v106 ch_ari [iw=wt], row nofreq 

*wealth
tab v190 ch_ari [iw=wt], row nofreq 

* output to excel
tabout agecats b4 fuel v025 v106 v024 v190 ch_ari using Tables_ARI_FV.xls [iw=wt] , c(row) f(1) replace 

**************************************************************************************************
//ARI treatment. 
* Note: This indicator and the remaining ARI indicators depend on the country specific definition of treatment. Check the 
* footnote in the final report for this table and exclude the necessary source in the CH_AR_FV file. 

*Age in months
tab agecats ch_ari_care [iw=wt], row nofreq 

*Child's sex
tab b4 ch_ari_care [iw=wt], row nofreq 

*type of cooking fuel
tab fuel ch_ari_care [iw=wt], row nofreq 

*residence
tab v025 ch_ari_care [iw=wt], row nofreq 

*region
tab v024 ch_ari_care [iw=wt], row nofreq 

*education
tab v106 ch_ari_care [iw=wt], row nofreq 

*wealth
tab v190 ch_ari_care [iw=wt], row nofreq 

* output to excel
tabout agecats b4 fuel v025 v106 v024 v190 ch_ari_care using Tables_ARI_FV.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
//ARI treatment same or next day

*Age in months
tab agecats ch_ari_care_day [iw=wt], row nofreq 

*Child's sex
tab b4 ch_ari_care_day [iw=wt], row nofreq 

*type of cooking fuel
tab fuel ch_ari_care_day [iw=wt], row nofreq 

*residence
tab v025 ch_ari_care_day [iw=wt], row nofreq 

*region
tab v024 ch_ari_care_day [iw=wt], row nofreq 

*education
tab v106 ch_ari_care_day [iw=wt], row nofreq 

*wealth
tab v190 ch_ari_care_day [iw=wt], row nofreq 

* output to excel
tabout agecats b4 fuel v025 v106 v024 v190 ch_ari_care_day using Tables_ARI_FV.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
*** Source of advice or treatment for ARI symptoms ***
* only the following sources are computed, to get other sources that are country specific, please see the note on these indicators in the CH_ARI_FV.do file

* among children with ARI symtoms
tab1 ch_ari_public ch_ari_govh ch_ari_govcent ch_ari_private ch_ari_pclinc ch_ari_pdoc ch_ari_pharm ch_ari_ngo [iw=wt]

* output to excel
tabout ch_ari_public ch_ari_govh ch_ari_govcent ch_ari_private ch_ari_pclinc ch_ari_pdoc ch_ari_pharm ch_ari_ngo using Tables_ARI_FV.xls [iw=wt], oneway cells(cell) f(1) append 

* among children with ARI symtoms whom advice or treatment was sought
tab1 ch_ari_public_trt ch_ari_govh_trt ch_ari_govcent_trt ch_ari_private_trt ch_ari_pclinc_trt ch_ari_pdoc_trt ch_ari_pharm_trt ch_ari_ngo_trt [iw=wt]	

* output to excel
tabout ch_ari_public_trt ch_ari_govh_trt ch_ari_govcent_trt ch_ari_private_trt ch_ari_pclinc_trt ch_ari_pdoc_trt ch_ari_pharm_trt ch_ari_ngo_trt using Tables_ARI_FV.xls [iw=wt] , oneway cells(cell) f(1) append 
**************************************************************************************************
//Fever symptoms

*Age in months
tab agecats ch_fever [iw=wt], row nofreq 

*Child's sex
tab b4 ch_fever [iw=wt], row nofreq 

*residence
tab v025 ch_fever [iw=wt], row nofreq 

*region
tab v024 ch_fever [iw=wt], row nofreq 

*education
tab v106 ch_fever [iw=wt], row nofreq 

*wealth
tab v190 ch_fever [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_fever using Tables_ARI_FV.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
//Fever treatment. 
* Note: This indicator and the remaining fever indicators depend on the country specific definition of treatment. Check the 
* footnote in the final report for this table and exclude the necessary source in the CH_AR_FV file. 

*Age in months
tab agecats ch_fev_care [iw=wt], row nofreq 

*Child's sex
tab b4 ch_fev_care [iw=wt], row nofreq 

*residence
tab v025 ch_fev_care [iw=wt], row nofreq 

*region
tab v024 ch_fev_care [iw=wt], row nofreq 

*education
tab v106 ch_fev_care [iw=wt], row nofreq 

*wealth
tab v190 ch_fev_care [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_fev_care using Tables_ARI_FV.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
//Fever treatment same or next day

*Age in months
tab agecats ch_fev_care_day [iw=wt], row nofreq 

*Child's sex
tab b4 ch_fev_care_day [iw=wt], row nofreq 

*residence
tab v025 ch_fev_care_day [iw=wt], row nofreq 

*region
tab v024 ch_fev_care_day [iw=wt], row nofreq 

*education
tab v106 ch_fev_care_day [iw=wt], row nofreq 

*wealth
tab v190 ch_fev_care_day [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_fev_care_day using Tables_ARI_FV.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
//Fever treatment with antibiotics

*Age in months
tab agecats ch_fev_antib [iw=wt], row nofreq 

*Child's sex
tab b4 ch_fev_antib [iw=wt], row nofreq 

*residence
tab v025 ch_fev_antib [iw=wt], row nofreq 

*region
tab v024 ch_fev_antib [iw=wt], row nofreq 

*education
tab v106 ch_fev_antib [iw=wt], row nofreq 

*wealth
tab v190 ch_fev_antib [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_fev_antib using Tables_ARI_FV.xls [iw=wt] , c(row) f(1) append 
**************************************************************************************************
**************************************************************************************************
* Tables for diarrhea indicators
**************************************************************************************************
//Diarrhea symptoms

*Age in months
tab agecats ch_diar [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar [iw=wt], row nofreq 

*residence
tab v025 ch_diar [iw=wt], row nofreq 

*region
tab v024 ch_diar [iw=wt], row nofreq 

*education
tab v106 ch_diar [iw=wt], row nofreq 

*wealth
tab v190 ch_diar [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar using Tables_DIAR.xls [iw=wt], c(row) f(1) replace 

**************************************************************************************************
//Diarrhea treatment. 
* Note: This indicator and some remaining diarrhea indicators depend on the country specific definition of treatment. Check the 
* footnote in the final report for this table and exclude the necessary source in the CH_DIAR file. 

*Age in months
tab agecats ch_diar_care [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_care [iw=wt], row nofreq 

*residence
tab v025 ch_diar_care [iw=wt], row nofreq 

*region
tab v024 ch_diar_care [iw=wt], row nofreq 

*education
tab v106 ch_diar_care [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_care [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_care using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
**************************************************************************************************
//Amount of liquids given during diarrhea

*Age in months
tab agecats ch_diar_liq [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_liq [iw=wt], row nofreq 

*residence
tab v025 ch_diar_liq [iw=wt], row nofreq 

*region
tab v024 ch_diar_liq [iw=wt], row nofreq 

*education
tab v106 ch_diar_liq [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_liq [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_liq using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
**************************************************************************************************
//Amount of food given during diarrhea

*Age in months
tab agecats ch_diar_food [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_food [iw=wt], row nofreq 

*residence
tab v025 ch_diar_food [iw=wt], row nofreq 

*region
tab v024 ch_diar_food [iw=wt], row nofreq 

*education
tab v106 ch_diar_food [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_food [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_food using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
*** Table for Oral rehydration theapy and other treatments for diarrhea
//ORS

*Age in months
tab agecats ch_diar_ors [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_ors [iw=wt], row nofreq 

*residence
tab v025 ch_diar_ors [iw=wt], row nofreq 

*region
tab v024 ch_diar_ors [iw=wt], row nofreq 

*education
tab v106 ch_diar_ors [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_ors [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_ors using Tables_DIAR.xls [iw=wt], c(row) f(1) append 

****************************************************************************
//Zinc

*Age in months
tab agecats ch_diar_zinc [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_zinc [iw=wt], row nofreq 

*residence
tab v025 ch_diar_zinc [iw=wt], row nofreq 

*region
tab v024 ch_diar_zinc [iw=wt], row nofreq 

*education
tab v106 ch_diar_zinc [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_zinc [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_zinc using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//Zinc and ORS

*Age in months
tab agecats ch_diar_zinc_ors [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_zinc_ors [iw=wt], row nofreq 

*residence
tab v025 ch_diar_zinc_ors [iw=wt], row nofreq 

*region
tab v024 ch_diar_zinc_ors [iw=wt], row nofreq 

*education
tab v106 ch_diar_zinc_ors [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_zinc_ors [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_zinc_ors using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//ORS and continued feeding

*Age in months
tab agecats ch_diar_ors_feed [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_ors_feed [iw=wt], row nofreq 

*residence
tab v025 ch_diar_ors_feed [iw=wt], row nofreq 

*region
tab v024 ch_diar_ors_feed [iw=wt], row nofreq 

*education
tab v106 ch_diar_ors_feed [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_ors_feed [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_ors_feed using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//Zinc, ORS, and continued feeding

*Age in months
tab agecats ch_diar_zinc_ors_feed [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_zinc_ors_feed [iw=wt], row nofreq 

*residence
tab v025 ch_diar_zinc_ors_feed [iw=wt], row nofreq 

*region
tab v024 ch_diar_zinc_ors_feed [iw=wt], row nofreq 

*education
tab v106 ch_diar_zinc_ors_feed [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_zinc_ors_feed [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_zinc_ors_feed using Tables_DIAR.xls [iw=wt], c(row) f(1) append 

****************************************************************************
//ORS or increased fluids

*Age in months
tab agecats ch_diar_ors_fluid [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_ors_fluid [iw=wt], row nofreq 

*residence
tab v025 ch_diar_ors_fluid [iw=wt], row nofreq 

*region
tab v024 ch_diar_ors_fluid [iw=wt], row nofreq 

*education
tab v106 ch_diar_ors_fluid [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_ors_fluid [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_ors_fluid using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//RHF

*Age in months
tab agecats ch_diar_rhf [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_rhf [iw=wt], row nofreq 

*residence
tab v025 ch_diar_rhf [iw=wt], row nofreq 

*region
tab v024 ch_diar_rhf [iw=wt], row nofreq 

*education
tab v106 ch_diar_rhf [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_rhf [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_rhf using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//ORT
*Age in months
tab agecats ch_diar_ort [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_ort [iw=wt], row nofreq 

*residence
tab v025 ch_diar_ort [iw=wt], row nofreq 

*region
tab v024 ch_diar_ort [iw=wt], row nofreq 

*education
tab v106 ch_diar_ort [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_ort [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_ort using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//ORT and continued feeding

*Age in months
tab agecats ch_diar_ort_feed [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_ort_feed [iw=wt], row nofreq 

*residence
tab v025 ch_diar_ort_feed [iw=wt], row nofreq 

*region
tab v024 ch_diar_ort_feed [iw=wt], row nofreq 

*education
tab v106 ch_diar_ort_feed [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_ort_feed [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_ort_feed using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//Antiobitiocs

*Age in months
tab agecats ch_diar_antib [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_antib [iw=wt], row nofreq 

*residence
tab v025 ch_diar_antib [iw=wt], row nofreq 

*region
tab v024 ch_diar_antib [iw=wt], row nofreq 

*education
tab v106 ch_diar_antib [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_antib [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_antib using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//Antimotility drugs

*Age in months
tab agecats ch_diar_antim [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_antim [iw=wt], row nofreq 

*residence
tab v025 ch_diar_antim [iw=wt], row nofreq 

*region
tab v024 ch_diar_antim [iw=wt], row nofreq 

*education
tab v106 ch_diar_antim [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_antim [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_antim using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//Intravenous solution 

*Age in months
tab agecats ch_diar_intra [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_intra [iw=wt], row nofreq 

*residence
tab v025 ch_diar_intra [iw=wt], row nofreq 

*region
tab v024 ch_diar_intra [iw=wt], row nofreq 

*education
tab v106 ch_diar_intra [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_intra [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_intra using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//Home remedy or other treatment

*Age in months
tab agecats ch_diar_other [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_other [iw=wt], row nofreq 

*residence
tab v025 ch_diar_other [iw=wt], row nofreq 

*region
tab v024 ch_diar_other [iw=wt], row nofreq 

*education
tab v106 ch_diar_other [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_other [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_other using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
****************************************************************************
//No treatment

*Age in months
tab agecats ch_diar_notrt [iw=wt], row nofreq 

*Child's sex
tab b4 ch_diar_notrt [iw=wt], row nofreq 

*residence
tab v025 ch_diar_notrt [iw=wt], row nofreq 

*region
tab v024 ch_diar_notrt [iw=wt], row nofreq 

*education
tab v106 ch_diar_notrt [iw=wt], row nofreq 

*wealth
tab v190 ch_diar_notrt [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v106 v024 v190 ch_diar_notrt using Tables_DIAR.xls [iw=wt], c(row) f(1) append 
**************************************************************************************************
*** Source of advice or treatment of Diarrhea ***
* only the following sources are computed, to get other sources that are country specific, please see the note on these indicators in the CH_DIAR.do file

* among children with diarrhea
tab1 ch_diar_public ch_diar_govh ch_diar_govcent ch_diar_pclinc ch_diar_pdoc ch_diar_pharm ch_diar_ngo [iw=wt]

* output to excel
tabout ch_diar_public ch_diar_govh ch_diar_govcent ch_diar_pclinc ch_diar_pdoc ch_diar_pharm ch_diar_ngo  using Tables_DIAR.xls [iw=wt], oneway cells(cell) f(1) append 

* among children with diarrhea whom advice or treatment was sought
tab1 ch_diar_public_trt ch_diar_govh_trt ch_diar_govcent_trt ch_diar_private_trt ch_diar_pclinc_trt ch_diar_pdoc_trt ch_diar_pharm_trt ch_diar_ngo_trt [iw=wt]	

* output to excel
tabout ch_diar_public_trt ch_diar_govh_trt ch_diar_govcent_trt ch_diar_private_trt ch_diar_pclinc_trt ch_diar_pdoc_trt ch_diar_pharm_trt ch_diar_ngo_trt  using Tables_DIAR.xls [iw=wt] , oneway cells(cell) f(1) append 

* among those that received ORS		
tab1 ch_diar_public_ors ch_diar_govh_ors ch_diar_govcent_ors ch_diar_private_ors ch_diar_pclinc_ors ch_diar_pdoc_ors ch_diar_pharm_ors ch_diar_ngo_ors [iw=wt]

* output to excel
tabout ch_diar_public_ors ch_diar_govh_ors ch_diar_govcent_ors ch_diar_private_ors ch_diar_pclinc_ors ch_diar_pdoc_ors ch_diar_pharm_ors ch_diar_ngo_ors using Tables_DIAR.xls [iw=wt] , oneway cells(cell) f(1) append

* among those given zinc
tab1 ch_diar_public_zinc ch_diar_govh_zinc ch_diar_govcent_zinc ch_diar_private_zinc ch_diar_pclinc_zinc ch_diar_pdoc_zinc ch_diar_pharm_zinc ch_diar_ngo_zinc [iw=wt]

* output to excel
tabout ch_diar_public_zinc ch_diar_govh_zinc ch_diar_govcent_zinc ch_diar_private_zinc ch_diar_pclinc_zinc ch_diar_pdoc_zinc ch_diar_pharm_zinc ch_diar_ngo_zinc using Tables_DIAR.xls [iw=wt] , oneway cells(cell) f(1) append
 
**************************************************************************************************
}

