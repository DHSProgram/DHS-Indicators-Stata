/*****************************************************************************************************
Program: 			NT_tables.do
Purpose: 			produce tables for indicators - DHS8 update
Author:				Shireen Assaf
Date last modified: November 16, 2022 by Shireen Assaf 	

*This do file will produce the following tables in excel:
1. 	Tables_nut_ch:		Contains the tables for nutritional status indicators for children
2. 	Tables_gwth_monit:	Contains the tables for child growth monitoring 
3.	Tables_anemia_ch:	Contains the tables for anemia indicators for children
4. 	Tables_bf:			Contains the tables for breastfeeding indicators
5.	Tables_IYCF:		Contains the tables for IYCF indicators in children
6. 	Tables_micronut_ch:	Contains the tables for micronutrient intake in children
7. 	Tables_salt_hh:		Contains the tables for salt testing and iodized salt in households
8. 	Tables_nut_wm:		Contains the tables for nutritional status indicators for women (first for women age 20-49 then for women age 15-19)
9. 	Tables_foodliq_wm:	Contains tables for food and liquid consumption for women
10.	Tables_anemia_wm:	Contains the tables for anemia indicators for women
11. Tables_nut_mn:		Contains the tables for nutritional status indicators for men (first for men age 20-49 then for men age 15-19)
12.	Tables_anemia_mn:	Contains the tables for anemia indicators for men

Notes: 	For men indicators are anthropometric indicators are computed for men age 20-49 and 15-19. Anemia is computed for all men but men age 15-49 are selected in line 1292. To compute these indicators for all men, remove that line. 
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from PR file
if file=="PR" {
cap gen wt=hv005/1000000

**************************************************************************************************
* background variables

//Age in months
recode hc1 (0/5=1 " <6") (6/11=2 " 6-11") (12/23=3 " 12-23") (24/35=4 " 24-35") (36/47=5 " 36-47") (48/59=6 " 48-59"), gen(agemonths)

* Note: other variables such as size at birth (from KR file) and mother's BMI (from IR) are found in other files and need to be merged with PR file
* These tables are only for variables available in the PR file

**************************************************************************************************
* Anthropometric indicators for children under age 5
**************************************************************************************************
//Severely stunted
*age of child in months
tab agemonths nt_ch_sev_stunt [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_sev_stunt [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_sev_stunt [iw=wt], row nofreq 

*region
tab hv024 nt_ch_sev_stunt [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_sev_stunt [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_sev_stunt using Tables_nut_ch.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Stunted
*age of child in months
tab agemonths nt_ch_stunt [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_stunt [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_stunt [iw=wt], row nofreq 

*region
tab hv024 nt_ch_stunt [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_stunt [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_stunt using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Mean haz
tab nt_ch_mean_haz

* this is a scalar and only produced for the total. 

* output to excel
tabout nt_ch_mean_haz using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Severely wasted
*age of child in months
tab agemonths nt_ch_sev_wast [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_sev_wast [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_sev_wast [iw=wt], row nofreq 

*region
tab hv024 nt_ch_sev_wast [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_sev_wast [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_sev_wast using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Wasted
*age of child in months
tab agemonths nt_ch_wast [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_wast [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_wast [iw=wt], row nofreq 

*region
tab hv024 nt_ch_wast [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_wast [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_wast using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Overweight for height
*age of child in months
tab agemonths nt_ch_ovwt [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_ovwt [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_ovwt [iw=wt], row nofreq 

*region
tab hv024 nt_ch_ovwt [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_ovwt [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_ovwt using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Mean whz
tab nt_ch_mean_whz

* this is a scalar and only produced for the total. 

* output to excel
tabout nt_ch_mean_whz using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Severely underweight
*age of child in months
tab agemonths nt_ch_sev_underwt [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_sev_underwt [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_sev_underwt [iw=wt], row nofreq 

*region
tab hv024 nt_ch_sev_underwt [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_sev_wast [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_sev_underwt using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Underweight
*age of child in months
tab agemonths nt_ch_underwt [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_underwt [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_underwt [iw=wt], row nofreq 

*region
tab hv024 nt_ch_underwt [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_underwt [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_underwt using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Mean whz
tab nt_ch_mean_waz

* this is a scalar and only produced for the total. 

* output to excel
tabout nt_ch_mean_waz using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Anemia in children 6-59 months
**************************************************************************************************
//Any anemia
*age of child in months
tab agemonths nt_ch_any_anem [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_any_anem [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_any_anem [iw=wt], row nofreq 

*region
tab hv024 nt_ch_any_anem [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_any_anem [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_any_anem using Tables_anemia_ch.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Mild anemia
*age of child in months
tab agemonths nt_ch_mild_anem [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_mild_anem [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_mild_anem [iw=wt], row nofreq 

*region
tab hv024 nt_ch_mild_anem [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_mild_anem [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_mild_anem using Tables_anemia_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Moderate anemia
*age of child in months
tab agemonths nt_ch_mod_anem [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_mod_anem [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_mod_anem [iw=wt], row nofreq 

*region
tab hv024 nt_ch_mod_anem [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_mod_anem [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_mod_anem using Tables_anemia_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Severe anemia
*age of child in months
tab agemonths nt_ch_sev_anem [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_sev_anem [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_sev_anem [iw=wt], row nofreq 

*region
tab hv024 nt_ch_sev_anem [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_sev_anem [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_sev_anem using Tables_anemia_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
}

****************************************************************************
****************************************************************************

* indicators from KR file
if file=="KR" {
cap gen wt=v005/1000000

**************************************************************************************************
* background variables

//Age in months
recode age (0/5=1 " <6") (6/11=2 " 6-11") (12/23=3 " 12-23") (24/35=4 " 24-35") (36/47=5 " 36-47") (48/59=6 " 48-59"), gen(agemonths)

//Age categories for children 0-23
cap recode age (0/1=1 " 0-1") (2/3=2 " 2-3") (4/5=3 " 4-5") (6/11=4 " 6-11") (12/15=5 " 12-15") (16/19=6 " 16-19") (20/23=7 " 20-23") , gen(agecats)

//Place of delivery
recode m15 (20/39 = 1 "Health facility") (10/19 = 2 "Home") (40/99 = 3 "Other/Missing"), gen(del_place)
label var del_place "Place of delivery"

//Assistance during delivery
**Note: Assistance during delivery are country specific indicators. Check final report to know if these are coded correctly. 
gen del_pv = 0 if m3a != .
replace del_pv 	= 4 	if m3n == 1
replace del_pv 	= 3 	if m3d == 1 | m3e == 1 | m3f == 1 | m3h == 1 | m3i == 1 | m3j == 1 | m3k == 1 | m3l == 1 | m3m == 1 | m3a == 8
replace del_pv 	= 2 	if m3g == 1 
replace del_pv 	= 1 	if m3a == 1 | m3b == 1 | m3c == 1 
replace del_pv 	= . 	if m3a == 9
	
label define pv 1 "Health personnel" 2 "Traditional birth attendant" 3 "Other" 4 "No one"
label val del_pv pv
label var del_pv "Assistance during delivery"

//Mother's age 
recode v013 (1=1 "15-19") (2/3=2 "20-29") (4/5=3 "30-39") (6/7=4 "40-49"), gen(agem)
	
//Breastfeeding status	
gen brstfed = m4==95
replace brstfed = . if m4==.
*Assume that living twin of last birth who is living with mother is breastfeeding if the last birth is still breastfeeding
replace brstfed = 1 if caseid == caseid[_n-1] & b3 == b3[_n-1] & brstfed[_n-1] == 1 & b0 > 0 & b5==1 & b9[_n-1]==0 & b9==0
label values brstfed yesno
label var brstfed "Currently breastfeeding"
*recode m4 (95=1 "Breastfeeding ") (93 94=2 "Not breastfeeding"), gen(brstfed)


**************************************************************************************************
* Child grown monitoring indicators
**************************************************************************************************
//weight measured

*child's age
tab agemonths nt_ch_wt_msrd [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_wt_msrd [iw=wt], row nofreq 

*residence
tab v025 nt_ch_wt_msrd [iw=wt], row nofreq 

*region
tab v024 nt_ch_wt_msrd [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_wt_msrd [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_wt_msrd [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 v025 v024 v106 v190 nt_ch_wt_msrd using Tables_gwth_monit.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************

//weight and height measured

*child's age
tab agemonths nt_ch_wtht_msrd [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_wtht_msrd [iw=wt], row nofreq 

*residence
tab v025 nt_ch_wtht_msrd [iw=wt], row nofreq 

*region
tab v024 nt_ch_wtht_msrd [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_wtht_msrd [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_wtht_msrd [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 v025 v024 v106 v190 nt_ch_wtht_msrd using Tables_gwth_monit.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//MUAC measured

*child's age
tab agemonths nt_ch_muac_msrd [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_muac_msrd [iw=wt], row nofreq 

*residence
tab v025 nt_ch_muac_msrd [iw=wt], row nofreq 

*region
tab v024 nt_ch_muac_msrd [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_muac_msrd [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_muac_msrd [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 v025 v024 v106 v190 nt_ch_muac_msrd using Tables_gwth_monit.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//weight, height, and MUAC measured

*child's age
tab agemonths nt_ch_all_msrd [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_all_msrd [iw=wt], row nofreq 

*residence
tab v025 nt_ch_all_msrd [iw=wt], row nofreq 

*region
tab v024 nt_ch_all_msrd [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_all_msrd [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_all_msrd [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 v025 v024 v106 v190 nt_ch_all_msrd using Tables_gwth_monit.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Initial breastfeeding 
**************************************************************************************************
//Ever breastfed
*child's sex
tab b4 nt_bf_ever [iw=wt], row nofreq 

*Assistance during delivery
tab del_pv nt_bf_ever [iw=wt], row nofreq 

*Place of delivery
tab del_place nt_bf_ever [iw=wt], row nofreq 

*residence
tab v025 nt_bf_ever [iw=wt], row nofreq 

*region
tab v024 nt_bf_ever [iw=wt], row nofreq 

*mother's education
tab v106 nt_bf_ever [iw=wt], row nofreq 

*wealth
tab v190 nt_bf_ever [iw=wt], row nofreq 

* output to excel
tabout b4 del_pv del_place v025 v024 v106 v190 nt_bf_ever using Tables_bf.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Breastfed within 1hr
*child's sex
tab b4 nt_bf_start_1hr [iw=wt], row nofreq 

*residence
tab v025 nt_bf_start_1hr [iw=wt], row nofreq 

*region
tab v024 nt_bf_start_1hr [iw=wt], row nofreq 

*mother's education
tab v106 nt_bf_start_1hr [iw=wt], row nofreq 

*wealth
tab v190 nt_bf_start_1hr [iw=wt], row nofreq 

* output to excel
tabout b4 del_pv del_place v025 v024 v106 v190 nt_bf_start_1hr using Tables_bf.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Exclusively breastfed for the first 2 days after birth 
*child's sex
tab b4 nt_ebf_2days [iw=wt], row nofreq 

*Assistance during delivery
tab del_pv nt_ebf_2days [iw=wt], row nofreq 

*Place of delivery
tab del_place nt_ebf_2days [iw=wt], row nofreq 

*residence
tab v025 nt_ebf_2days [iw=wt], row nofreq 

*region
tab v024 nt_ebf_2days [iw=wt], row nofreq 

*mother's education
tab v106 nt_ebf_2days [iw=wt], row nofreq 

*wealth
tab v190 nt_ebf_2days [iw=wt], row nofreq 

* output to excel
tabout b4 del_pv del_place v025 v024 v106 v190 nt_ebf_2days using Tables_bf.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Currently breastfeeding : age 12-23

*child's age
tab agecats nt_bf_curr [iw=wt], row nofreq 

*child's sex
tab b4 nt_bf_curr [iw=wt], row nofreq 

*residence
tab v025 nt_bf_curr [iw=wt], row nofreq 

*region
tab v024 nt_bf_curr [iw=wt], row nofreq 

*mother's education
tab v106 nt_bf_curr [iw=wt], row nofreq 

*wealth
tab v190 nt_bf_curr [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_bf_curr using Tables_bf.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Bottle feeding
*child's age
tab agecats nt_bottle [iw=wt], row nofreq 

*child's sex
tab b4 nt_bottle [iw=wt], row nofreq 

*residence
tab v025 nt_bottle [iw=wt], row nofreq 

*region
tab v024 nt_bottle [iw=wt], row nofreq 

*mother's education
tab v106 nt_bottle [iw=wt], row nofreq 

*wealth
tab v190 nt_bottle [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_bottle using Tables_bf.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* IYCF table with several indicators: this also includes indicators tabulated in the NT_tables2.do file

tab1 nt_bf_ever nt_bf_start_1hr nt_ebf_2days nt_bf_curr nt_bottle [iw=wt]

tabout nt_bf_ever nt_bf_start_1hr nt_ebf_2days nt_bf_curr nt_bottle  using Tables_IYCF.xls [iw=wt] , oneway c(cell) f(1) append 

**************************************************************************************************
* Micronutrient intake
**************************************************************************************************
//Given Vitamin and Mineral Powder among children 6-59 months
*child's age in months
tab agemonths nt_ch_micro_mp [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_micro_mp [iw=wt], row nofreq 

*Breastfeeding status
tab brstfed nt_ch_micro_mp [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_micro_mp [iw=wt], row nofreq 

*residence
tab v025 nt_ch_micro_mp [iw=wt], row nofreq 

*region
tab v024 nt_ch_micro_mp [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_micro_mp [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_micro_mp [iw=wt], row nofreq 

* output to excel
cap tabout agemonths b4 brstfed agem v025 v024 v106 v190 nt_ch_micro_mp using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Given iron tablets or syrups among children 6-59 months
*child's age in months
tab agemonths nt_ch_micro_iron [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_micro_iron [iw=wt], row nofreq 

*Breastfeeding status
tab brstfed nt_ch_micro_iron [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_micro_iron [iw=wt], row nofreq 

*residence
tab v025 nt_ch_micro_iron [iw=wt], row nofreq 

*region
tab v024 nt_ch_micro_iron [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_micro_iron [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_micro_iron [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 brstfed agem v025 v024 v106 v190 nt_ch_micro_iron using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Given iron supplements children 6-59 months
*child's age in months
tab agemonths nt_ch_micro_ironsup [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_micro_ironsup [iw=wt], row nofreq 

*Breastfeeding status
tab brstfed nt_ch_micro_ironsup [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_micro_ironsup [iw=wt], row nofreq 

*residence
tab v025 nt_ch_micro_ironsup [iw=wt], row nofreq 

*region
tab v024 nt_ch_micro_ironsup [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_micro_ironsup [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_micro_ironsup [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 brstfed agem v025 v024 v106 v190 nt_ch_micro_iron using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Given Vit. A supplements among children 6-59 months
*child's age in months
tab agemonths nt_ch_micro_vas [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_micro_vas [iw=wt], row nofreq 

*Breastfeeding status
tab brstfed nt_ch_micro_vas [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_micro_vas [iw=wt], row nofreq 

*residence
tab v025 nt_ch_micro_vas [iw=wt], row nofreq 

*region
tab v024 nt_ch_micro_vas [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_micro_vas [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_micro_vas [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 brstfed agem v025 v024 v106 v190 nt_ch_micro_vas using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Given deworming medication among children 12-59 months
*child's age in months
tab agemonths nt_ch_micro_dwm [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_micro_dwm [iw=wt], row nofreq 

*Breastfeeding status
tab brstfed nt_ch_micro_dwm [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_micro_dwm [iw=wt], row nofreq 

*residence
tab v025 nt_ch_micro_dwm [iw=wt], row nofreq 

*region
tab v024 nt_ch_micro_dwm [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_micro_dwm [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_micro_dwm [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 brstfed agem v025 v024 v106 v190 nt_ch_micro_dwm using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) append 
*/
}

****************************************************************************
****************************************************************************

* indicators from HR file
if file=="HR" {
gen wt=hv005/1000000

//Salt and salt testing status in housholds
*residence
tab hv025 nt_salt_any [iw=wt], row nofreq 

*region
tab hv024 nt_salt_any [iw=wt], row nofreq 

*wealth
tab hv270 nt_salt_any [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 nt_salt_any using Tables_salt_hh.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Iodized salt in the household
*residence
tab hv025 nt_salt_iod [iw=wt], row nofreq 

*region
tab hv024 nt_salt_iod [iw=wt], row nofreq 

*wealth
tab hv270 nt_salt_iod [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 nt_salt_iod using Tables_salt_hh.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
}

****************************************************************************
****************************************************************************

* indicators from IR file
if file=="IR" {
* limiting to women age 15-49
drop if v012<15 | v012>49

cap gen wt=v005/1000000

**************************************************************************************************
* background variables

//Age 
recode v013 (1=1 "15-19") (2/3=2 "20-29") (4/5=3 "30-39") (6/7=4 "40-49"), gen(agecat)

//Number of children ever born
recode v201 (0=0 " 0 ") (1=1 " 1 ") (2/3=2 " 2-3") (4/5=3 " 4-5") (6/max=4 " 6+"), gen(ceb)

//IUD use
recode v312 (2=1 "Yes") (else=0 "No"), gen(iud)
label var iud "Using IUD"

//Maternity status
gen mstat=3
replace mstat=1 if v213==1
replace mstat=2 if v404==1 & v213!=1
label define mstat 1"Pregnant" 2"Breastfeeding" 3"Neither"
label values mstat mstat
label var mstat "Maternity status"

**************************************************************************************************
* Nutritional status of women age 20-49
**************************************************************************************************
//Height below 145cm
*age
tab agecat nt_wm_ht [iw=wt], row nofreq 

*residence
tab v025 nt_wm_ht [iw=wt], row nofreq 

*region
tab v024 nt_wm_ht [iw=wt], row nofreq 

*education
tab v106 nt_wm_ht [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_ht [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_ht using Tables_nut_wm.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Mean bmi
tab nt_wm_bmi_mean

* this is a scalar and only produced for the total. 

* output to excel
tabout nt_wm_bmi_mean using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Normal BMI
*age
tab agecat nt_wm_norm [iw=wt], row nofreq 

*residence
tab v025 nt_wm_norm [iw=wt], row nofreq 

*region
tab v024 nt_wm_norm [iw=wt], row nofreq 

*education
tab v106 nt_wm_norm [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_norm [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_norm using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Thin BMI
*age
tab agecat nt_wm_thin [iw=wt], row nofreq 

*residence
tab v025 nt_wm_thin [iw=wt], row nofreq 

*region
tab v024 nt_wm_thin [iw=wt], row nofreq 

*education
tab v106 nt_wm_thin [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_thin [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_thin using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Mildly thin BMI
*age
tab agecat nt_wm_mthin [iw=wt], row nofreq 

*residence
tab v025 nt_wm_mthin [iw=wt], row nofreq 

*region
tab v024 nt_wm_mthin [iw=wt], row nofreq 

*education
tab v106 nt_wm_mthin [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_mthin [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_mthin using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Moderately and severely thin BMI
*age
tab agecat nt_wm_modsevthin [iw=wt], row nofreq 

*residence
tab v025 nt_wm_modsevthin [iw=wt], row nofreq 

*region
tab v024 nt_wm_modsevthin [iw=wt], row nofreq 

*education
tab v106 nt_wm_modsevthin [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_modsevthin [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_modsevthin using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Overweight or obese BMI
*age
tab agecat nt_wm_ovobese [iw=wt], row nofreq 

*residence
tab v025 nt_wm_ovobese [iw=wt], row nofreq 

*region
tab v024 nt_wm_ovobese [iw=wt], row nofreq 

*education
tab v106 nt_wm_ovobese [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_ovobese [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_ovobese using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Overweight BMI
*age
tab agecat nt_wm_ovwt [iw=wt], row nofreq 

*residence
tab v025 nt_wm_ovwt [iw=wt], row nofreq 

*region
tab v024 nt_wm_ovwt [iw=wt], row nofreq 

*education
tab v106 nt_wm_ovwt [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_ovwt [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_ovwt using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Obese BMI
*age
tab agecat nt_wm_obese [iw=wt], row nofreq 

*residence
tab v025 nt_wm_obese [iw=wt], row nofreq 

*region
tab v024 nt_wm_obese [iw=wt], row nofreq 

*education
tab v106 nt_wm_obese [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_obese [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_obese using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Nutritional status of women age 15-19
**************************************************************************************************
//Height below 145cm
*age
tab agecat nt_wm2_ht [iw=wt], row nofreq 

*residence
tab v025 nt_wm2_ht [iw=wt], row nofreq 

*region
tab v024 nt_wm2_ht [iw=wt], row nofreq 

*education
tab v106 nt_wm2_ht [iw=wt], row nofreq 

*wealth
tab v190 nt_wm2_ht [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm2_ht using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Mean bmi
tab nt_wm2_bmi_mean

* this is a scalar and only produced for the total. 

* output to excel
tabout nt_wm2_bmi_mean using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Normal BMI
*age
tab agecat nt_wm2_norm [iw=wt], row nofreq 

*residence
tab v025 nt_wm2_norm [iw=wt], row nofreq 

*region
tab v024 nt_wm2_norm [iw=wt], row nofreq 

*education
tab v106 nt_wm2_norm [iw=wt], row nofreq 

*wealth
tab v190 nt_wm2_norm [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm2_norm using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Thin BMI
*age
tab agecat nt_wm2_thin [iw=wt], row nofreq 

*residence
tab v025 nt_wm2_thin [iw=wt], row nofreq 

*region
tab v024 nt_wm2_thin [iw=wt], row nofreq 

*education
tab v106 nt_wm2_thin [iw=wt], row nofreq 

*wealth
tab v190 nt_wm2_thin [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm2_thin using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Mildly thin BMI
*age
tab agecat nt_wm2_mthin [iw=wt], row nofreq 

*residence
tab v025 nt_wm2_mthin [iw=wt], row nofreq 

*region
tab v024 nt_wm2_mthin [iw=wt], row nofreq 

*education
tab v106 nt_wm2_mthin [iw=wt], row nofreq 

*wealth
tab v190 nt_wm2_mthin [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm2_mthin using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Moderately and severely thin BMI
*age
tab agecat nt_wm2_modsevthin [iw=wt], row nofreq 

*residence
tab v025 nt_wm2_modsevthin [iw=wt], row nofreq 

*region
tab v024 nt_wm2_modsevthin [iw=wt], row nofreq 

*education
tab v106 nt_wm2_modsevthin [iw=wt], row nofreq 

*wealth
tab v190 nt_wm2_modsevthin [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm2_modsevthin using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Overweight or obese BMI
*age
tab agecat nt_wm2_ovobese [iw=wt], row nofreq 

*residence
tab v025 nt_wm2_ovobese [iw=wt], row nofreq 

*region
tab v024 nt_wm2_ovobese [iw=wt], row nofreq 

*education
tab v106 nt_wm2_ovobese [iw=wt], row nofreq 

*wealth
tab v190 nt_wm2_ovobese [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm2_ovobese using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Overweight BMI
*age
tab agecat nt_wm2_ovwt [iw=wt], row nofreq 

*residence
tab v025 nt_wm2_ovwt [iw=wt], row nofreq 

*region
tab v024 nt_wm2_ovwt [iw=wt], row nofreq 

*education
tab v106 nt_wm2_ovwt [iw=wt], row nofreq 

*wealth
tab v190 nt_wm2_ovwt [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm2_ovwt using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Obese BMI
*age
tab agecat nt_wm2_obese [iw=wt], row nofreq 

*residence
tab v025 nt_wm2_obese [iw=wt], row nofreq 

*region
tab v024 nt_wm2_obese [iw=wt], row nofreq 

*education
tab v106 nt_wm2_obese [iw=wt], row nofreq 

*wealth
tab v190 nt_wm2_obese [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm2_obese using Tables_nut_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Foods and liquids consumed among women age 15-49
**************************************************************************************************
* These tables include foods and liquids consumption as well as minimum dietary diversity and consumption of sweet drinks and unhealthy foods.

tab1 nt_wm_grains nt_wm_root nt_wm_beans nt_wm_nuts nt_wm_dairy nt_meatfish nt_wm_eggs nt_wm_dkgreens nt_wm_vita nt_wm_veg nt_wm_fruit nt_wm_insect nt_wm_palm nt_wm_sweets nt_wm_salty nt_wm_juice nt_wm_soda nt_wm_teacoff nt_wm_mdd nt_wm_swt_drink nt_wm_unhlth_food [iw=wt]

*age
tabout  nt_wm_grains nt_wm_root nt_wm_beans nt_wm_nuts nt_wm_dairy nt_meatfish nt_wm_eggs nt_wm_dkgreens nt_wm_vita nt_wm_veg nt_wm_fruit nt_wm_insect nt_wm_palm nt_wm_sweets nt_wm_salty nt_wm_juice nt_wm_soda nt_wm_teacoff nt_wm_mdd nt_wm_swt_drink nt_wm_unhlth_food agecat using Tables_foodliq_wm.xls [iw=wt] , c(col) f(1) replace 

*pregancy status
tabout  nt_wm_grains nt_wm_root nt_wm_beans nt_wm_nuts nt_wm_dairy nt_meatfish nt_wm_eggs nt_wm_dkgreens nt_wm_vita nt_wm_veg nt_wm_fruit nt_wm_insect nt_wm_palm nt_wm_sweets nt_wm_salty nt_wm_juice nt_wm_soda nt_wm_teacoff nt_wm_mdd nt_wm_swt_drink nt_wm_unhlth_food v213 using Tables_foodliq_wm.xls [iw=wt] , c(col) f(1) append 

* residence
tabout  nt_wm_grains nt_wm_root nt_wm_beans nt_wm_nuts nt_wm_dairy nt_meatfish nt_wm_eggs nt_wm_dkgreens nt_wm_vita nt_wm_veg nt_wm_fruit nt_wm_insect nt_wm_palm nt_wm_sweets nt_wm_salty nt_wm_juice nt_wm_soda nt_wm_teacoff nt_wm_mdd nt_wm_swt_drink nt_wm_unhlth_food v025 using Tables_foodliq_wm.xls [iw=wt] , c(col) f(1) append 

*region
tabout  nt_wm_grains nt_wm_root nt_wm_beans nt_wm_nuts nt_wm_dairy nt_meatfish nt_wm_eggs nt_wm_dkgreens nt_wm_vita nt_wm_veg nt_wm_fruit nt_wm_insect nt_wm_palm nt_wm_sweets nt_wm_salty nt_wm_juice nt_wm_soda nt_wm_teacoff nt_wm_mdd nt_wm_swt_drink nt_wm_unhlth_food v024 using Tables_foodliq_wm.xls [iw=wt] , c(col) f(1) append 

*education
tabout  nt_wm_grains nt_wm_root nt_wm_beans nt_wm_nuts nt_wm_dairy nt_meatfish nt_wm_eggs nt_wm_dkgreens nt_wm_vita nt_wm_veg nt_wm_fruit nt_wm_insect nt_wm_palm nt_wm_sweets nt_wm_salty nt_wm_juice nt_wm_soda nt_wm_teacoff nt_wm_mdd nt_wm_swt_drink nt_wm_unhlth_food v106 using Tables_foodliq_wm.xls [iw=wt] , c(col) f(1) append 

*wealth
tabout  nt_wm_grains nt_wm_root nt_wm_beans nt_wm_nuts nt_wm_dairy nt_meatfish nt_wm_eggs nt_wm_dkgreens nt_wm_vita nt_wm_veg nt_wm_fruit nt_wm_insect nt_wm_palm nt_wm_sweets nt_wm_salty nt_wm_juice nt_wm_soda nt_wm_teacoff nt_wm_mdd nt_wm_swt_drink nt_wm_unhlth_food v190 using Tables_foodliq_wm.xls [iw=wt] , c(col) f(1) append 
*/
**************************************************************************************************
* Anemia in women
**************************************************************************************************
//Any anemia
*age
tab agecat nt_wm_any_anem [iw=wt], row nofreq 

*number of children ever born
tab ceb nt_wm_any_anem [iw=wt], row nofreq 

*maternity status
tab mstat nt_wm_any_anem [iw=wt], row nofreq 

*using iud
tab iud nt_wm_any_anem [iw=wt], row nofreq 

*smokes cigarettes
tab v463a nt_wm_any_anem [iw=wt], row nofreq 

*residence
tab v025 nt_wm_any_anem [iw=wt], row nofreq 

*region
tab v024 nt_wm_any_anem [iw=wt], row nofreq 

*education
tab v106 nt_wm_any_anem [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_any_anem [iw=wt], row nofreq 

* output to excel
tabout agecat ceb mstat iud v463a v025 v024 v106 v190 nt_wm_any_anem using Tables_anemia_wm.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Mild anemia
*age
tab agecat nt_wm_mild_anem [iw=wt], row nofreq 

*number of children ever born
tab ceb nt_wm_mild_anem [iw=wt], row nofreq 

*maternity status
tab mstat nt_wm_mild_anem [iw=wt], row nofreq 

*using iud
tab iud nt_wm_mild_anem [iw=wt], row nofreq 

*smokes cigarettes
tab v463a nt_wm_mild_anem [iw=wt], row nofreq 

*residence
tab v025 nt_wm_mild_anem [iw=wt], row nofreq 

*region
tab v024 nt_wm_mild_anem [iw=wt], row nofreq 

*education
tab v106 nt_wm_mild_anem [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_mild_anem [iw=wt], row nofreq 

* output to excel
tabout agecat ceb mstat iud v463a v025 v024 v106 v190 nt_wm_mild_anem using Tables_anemia_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Moderate anemia
*age
tab agecat nt_wm_mod_anem [iw=wt], row nofreq 

*number of children ever born
tab ceb nt_wm_mod_anem [iw=wt], row nofreq 

*maternity status
tab mstat nt_wm_mod_anem [iw=wt], row nofreq 

*using iud
tab iud nt_wm_mod_anem [iw=wt], row nofreq 

*smokes cigarettes
tab v463a nt_wm_mod_anem [iw=wt], row nofreq 

*residence
tab v025 nt_wm_mod_anem [iw=wt], row nofreq 

*region
tab v024 nt_wm_mod_anem [iw=wt], row nofreq 

*education
tab v106 nt_wm_mod_anem [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_mod_anem [iw=wt], row nofreq 

* output to excel
tabout agecat ceb mstat iud v463a v025 v024 v106 v190 nt_wm_mod_anem using Tables_anemia_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Severe anemia
*age
tab agecat nt_wm_sev_anem [iw=wt], row nofreq 

*number of children ever born
tab ceb nt_wm_sev_anem [iw=wt], row nofreq 

*maternity status
tab mstat nt_wm_sev_anem [iw=wt], row nofreq 

*using iud
tab iud nt_wm_sev_anem [iw=wt], row nofreq 

*smokes cigarettes
tab v463a nt_wm_sev_anem [iw=wt], row nofreq 

*residence
tab v025 nt_wm_sev_anem [iw=wt], row nofreq 

*region
tab v024 nt_wm_sev_anem [iw=wt], row nofreq 

*education
tab v106 nt_wm_sev_anem [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_sev_anem [iw=wt], row nofreq 

* output to excel
tabout agecat ceb mstat iud v463a v025 v024 v106 v190 nt_wm_sev_anem using Tables_anemia_wm.xls [iw=wt] , c(row) f(1) append 
*/

}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {
* limiting to men age 15-49
drop if mv012<15 | mv012>49

cap gen wt=mv005/1000000

**************************************************************************************************
* background variables

//Age 
recode mv013 (1=1 "15-19") (2/3=2 "20-29") (4/5=3 "30-39") (6/7=4 "40-49"), gen(agecat)
**************************************************************************************************
* Anemia in men
**************************************************************************************************
//Any anemia
*age
tab agecat nt_mn_any_anem [iw=wt], row nofreq 

*smokes
tab smoke nt_mn_any_anem [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_any_anem [iw=wt], row nofreq 

*region
tab mv024 nt_mn_any_anem [iw=wt], row nofreq 

*education
tab mv106 nt_mn_any_anem [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_any_anem [iw=wt], row nofreq 

* output to excel
tabout agecat smoke mv025 mv024 mv106 mv190 nt_mn_any_anem using Tables_anemia_mn.xls [iw=wt] , c(row) f(1) replace 
*/

//Mild anemia
*age
tab agecat nt_mn_mild_anem [iw=wt], row nofreq 

*smokes
tab smoke nt_mn_mild_anem [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_mild_anem [iw=wt], row nofreq 

*region
tab mv024 nt_mn_mild_anem [iw=wt], row nofreq 

*education
tab mv106 nt_mn_mild_anem [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_mild_anem [iw=wt], row nofreq 

* output to excel
tabout agecat smoke mv025 mv024 mv106 mv190 nt_mn_mild_anem using Tables_anemia_mn.xls [iw=wt] , c(row) f(1) replace 
*/
//Moderate anemia
*age
tab agecat nt_mn_mod_anem [iw=wt], row nofreq 

*smokes
tab smoke nt_mn_mod_anem [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_mod_anem [iw=wt], row nofreq 

*region
tab mv024 nt_mn_mod_anem [iw=wt], row nofreq 

*education
tab mv106 nt_mn_mod_anem [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_mod_anem [iw=wt], row nofreq 

* output to excel
tabout agecat smoke mv025 mv024 mv106 mv190 nt_mn_mod_anem using Tables_anemia_mn.xls [iw=wt] , c(row) f(1) replace 
*/
//Severe anemia
*age
tab agecat nt_mn_sev_anem [iw=wt], row nofreq 

*smokes
tab smoke nt_mn_sev_anem [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_sev_anem [iw=wt], row nofreq 

*region
tab mv024 nt_mn_sev_anem [iw=wt], row nofreq 

*education
tab mv106 nt_mn_sev_anem [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_sev_anem [iw=wt], row nofreq 

* output to excel
tabout agecat smoke mv025 mv024 mv106 mv190 nt_mn_sev_anem using Tables_anemia_mn.xls [iw=wt] , c(row) f(1) replace 
*/
**************************************************************************************************
* Nutritional status of men - among men age 20-49
**************************************************************************************************
//Mean bmi - men 20-49
tab nt_mn_bmi_mean

//Mean bmi - men 20+
tab nt_mn_bmi_mean_all

* this is a scalar and only produced for the total. 

* output to excel
tabout nt_mn_bmi_mean nt_mn_bmi_mean_all using Tables_nut_mn.xls [iw=wt] , oneway c(cell) f(1) append 
*/
****************************************************
//Normal BMI
*age
tab agecat nt_mn_norm [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_norm [iw=wt], row nofreq 

*region
tab mv024 nt_mn_norm [iw=wt], row nofreq 

*education
tab mv106 nt_mn_norm [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_norm [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn_norm using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Thin BMI
*age
tab agecat nt_mn_thin [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_thin [iw=wt], row nofreq 

*region
tab mv024 nt_mn_thin [iw=wt], row nofreq 

*education
tab mv106 nt_mn_thin [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_thin [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn_thin using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Mildly thin BMI
*age
tab agecat nt_mn_mthin [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_mthin [iw=wt], row nofreq 

*region
tab mv024 nt_mn_mthin [iw=wt], row nofreq 

*education
tab mv106 nt_mn_mthin [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_mthin [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn_mthin using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Moderately and severely thin BMI
*age
tab agecat nt_mn_modsevthin [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_modsevthin [iw=wt], row nofreq 

*region
tab mv024 nt_mn_modsevthin [iw=wt], row nofreq 

*education
tab mv106 nt_mn_modsevthin [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_modsevthin [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn_modsevthin using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Overweight or obese BMI
*age
tab agecat nt_mn_ovobese [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_ovobese [iw=wt], row nofreq 

*region
tab mv024 nt_mn_ovobese [iw=wt], row nofreq 

*education
tab mv106 nt_mn_ovobese [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_ovobese [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn_ovobese using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Overweight BMI
*age
tab agecat nt_mn_ovwt [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_ovwt [iw=wt], row nofreq 

*region
tab mv024 nt_mn_ovwt [iw=wt], row nofreq 

*education
tab mv106 nt_mn_ovwt [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_ovwt [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn_ovwt using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Obese BMI
*age
tab agecat nt_mn_obese [iw=wt], row nofreq 

*residence
tab mv025 nt_mn_obese [iw=wt], row nofreq 

*region
tab mv024 nt_mn_obese [iw=wt], row nofreq 

*education
tab mv106 nt_mn_obese [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn_obese [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn_obese using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Nutritional status of men - among men age 15-19
**************************************************************************************************
//Mean bmi - men 15-19
tab nt_mn2_bmi_mean

* this is a scalar and only produced for the total. 

* output to excel
tabout nt_mn2_bmi_mean using Tables_nut_mn.xls [iw=wt] , oneway c(cell) f(1) append 
*/
****************************************************
//Normal BMI

*residence
tab mv025 nt_mn2_norm [iw=wt], row nofreq 

*region
tab mv024 nt_mn2_norm [iw=wt], row nofreq 

*education
tab mv106 nt_mn2_norm [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn2_norm [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn2_norm using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Thin BMI
*residence
tab mv025 nt_mn2_thin [iw=wt], row nofreq 

*region
tab mv024 nt_mn2_thin [iw=wt], row nofreq 

*education
tab mv106 nt_mn2_thin [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn2_thin [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn2_thin using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Mildly thin BMI

*residence
tab mv025 nt_mn2_mthin [iw=wt], row nofreq 

*region
tab mv024 nt_mn2_mthin [iw=wt], row nofreq 

*education
tab mv106 nt_mn2_mthin [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn2_mthin [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn2_mthin using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Moderately and severely thin BMI

*residence
tab mv025 nt_mn2_modsevthin [iw=wt], row nofreq 

*region
tab mv024 nt_mn2_modsevthin [iw=wt], row nofreq 

*education
tab mv106 nt_mn2_modsevthin [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn2_modsevthin [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn2_modsevthin using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Overweight or obese BMI

*residence
tab mv025 nt_mn2_ovobese [iw=wt], row nofreq 

*region
tab mv024 nt_mn2_ovobese [iw=wt], row nofreq 

*education
tab mv106 nt_mn2_ovobese [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn2_ovobese [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn2_ovobese using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Overweight BMI

*residence
tab mv025 nt_mn2_ovwt [iw=wt], row nofreq 

*region
tab mv024 nt_mn2_ovwt [iw=wt], row nofreq 

*education
tab mv106 nt_mn2_ovwt [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn2_ovwt [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn2_ovwt using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Obese BMI

*residence
tab mv025 nt_mn2_obese [iw=wt], row nofreq 

*region
tab mv024 nt_mn2_obese [iw=wt], row nofreq 

*education
tab mv106 nt_mn2_obese [iw=wt], row nofreq 

*wealth
tab mv190 nt_mn2_obese [iw=wt], row nofreq 

* output to excel
tabout agecat mv025 mv024 mv106 mv190 nt_mn2_obese using Tables_nut_mn.xls [iw=wt] , c(row) f(1) append 
*/
}
