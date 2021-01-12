/*****************************************************************************************************
Program: 			NT_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: December 10, 2020 by Courtney Allen  

*Note this do file will produce the following tables in excel:
	1. 	Tables_nut_ch:		Contains the tables for nutritional status indicators for children
	2.	Tables_anemia_ch:	Contains the tables for anemia indicators for children
	3. 	Tables_brst_fed:	Contains the tables for breastfeeding indicators
	4.	Tables_IYCF:		Contains the tables for IYCF indicators in children
	5. 	Tables_micronut_ch:	Contains the tables for micronutrient intake in children
	6. 	Tables_salt_hh:		Contains the tables for salt testing and iodized salt in households
	7.	Tables_micronut_wm	Contains the tables for micronutrient intake in women
	8. 	Tables_nut_wm:		Contains the tables for nutritional status indicators for women
	9.	Tables_anemia_wm:	Contains the tables for anemia indicators for women
	10. Tables_nut_mn:		Contains the tables for nutritional status indicators for men
	11.	Tables_anemia_mn:	Contains the tables for anemia indicators for men
Note: The tables produced for men (MR file) select for men 15-49. If all men are needed please comment out line 1148
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
recode hc1 (0/5=1 " <6") (6/8=2 " 6-8") (9/11=3 " 9-11") (12/17=4 " 12-17") (18/23=5 " 18-23") (24/35=6 " 24-35") (36/47=7 " 36-47") (48/59=8 " 48-59"), gen(agemonths)

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
tab agemonths nt_ch_ovwt_ht [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_ovwt_ht [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_ovwt_ht [iw=wt], row nofreq 

*region
tab hv024 nt_ch_ovwt_ht [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_ovwt_ht [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_ovwt_ht using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
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
//Wasted
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
//Overweight for height
*age of child in months
tab agemonths nt_ch_ovwt_age [iw=wt], row nofreq 

*child's sex
tab hc27 nt_ch_ovwt_age [iw=wt], row nofreq 

*residence
tab hv025 nt_ch_ovwt_age [iw=wt], row nofreq 

*region
tab hv024 nt_ch_ovwt_age [iw=wt], row nofreq 

*wealth
tab hv270 nt_ch_ovwt_age [iw=wt], row nofreq 

* output to excel
tabout agemonths hc27 hv025 hv024 hv270 nt_ch_ovwt_age using Tables_nut_ch.xls [iw=wt] , c(row) f(1) append 
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
gen wt=v005/1000000

**************************************************************************************************
* background variables

//Age in months
recode age (0/5=1 " <6") (6/8=2 " 6-8") (9/11=3 " 9-11") (12/17=4 " 12-17") (18/23=5 " 18-23") (24/35=6 " 24-35") (36/47=7 " 36-47") (48/59=8 " 48-59"), gen(agemonths)

//Age categories for children 0-23
cap recode age (0/1=1 " 0-1") (2/3=2 " 2-3") (4/5=3 " 4-5") (6/8=4 " 6-8") (9/11=5 " 9-11") (12/17=6 " 12-17") (18/23=7 " 18-23") , gen(agecats)

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

//Wasting status
gen waste=. if hw72<9996
replace waste=1 if hw72<-300
replace waste=2 if hw72>=-300 & hw72<-200
replace waste=3 if hw72>=-200 & hw72<9996
label define waste 1 "Severe acute malnutrition" 2 "Moderate acute malnutrition" 3 "Not wasted"
label values waste waste

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

*Assistance during delivery
tab del_pv nt_bf_start_1hr [iw=wt], row nofreq 

*Place of delivery
tab del_place nt_bf_start_1hr [iw=wt], row nofreq 

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
//Breastfed within 1 day
*child's sex
tab b4 nt_bf_start_1day [iw=wt], row nofreq 

*Assistance during delivery
tab del_pv nt_bf_start_1day [iw=wt], row nofreq 

*Place of delivery
tab del_place nt_bf_start_1day [iw=wt], row nofreq 

*residence
tab v025 nt_bf_start_1day [iw=wt], row nofreq 

*region
tab v024 nt_bf_start_1day [iw=wt], row nofreq 

*mother's education
tab v106 nt_bf_start_1day [iw=wt], row nofreq 

*wealth
tab v190 nt_bf_start_1day [iw=wt], row nofreq 

* output to excel
tabout b4 del_pv del_place v025 v024 v106 v190 nt_bf_start_1day using Tables_bf.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Received a prelacteal feed among breastfed children
*child's sex
tab b4 nt_bf_prelac [iw=wt], row nofreq 

*Assistance during delivery
tab del_pv nt_bf_prelac [iw=wt], row nofreq 

*Place of delivery
tab del_place nt_bf_prelac [iw=wt], row nofreq 

*residence
tab v025 nt_bf_prelac [iw=wt], row nofreq 

*region
tab v024 nt_bf_prelac [iw=wt], row nofreq 

*mother's education
tab v106 nt_bf_prelac [iw=wt], row nofreq 

*wealth
tab v190 nt_bf_prelac [iw=wt], row nofreq 

* output to excel
tabout b4 del_pv del_place v025 v024 v106 v190 nt_bf_prelac using Tables_bf.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Bottle feeding
* For breastfeeding status table 
*Age categories
tab agecats nt_bottle if age<24 [iw=wt], row nofreq 

*Age 0-3
tab nt_bottle if age<4 [iw=wt] 

*Age 0-5
tab nt_bottle if age<6 [iw=wt]

*Age 6-9
tab nt_bottle if age>5 & age<10 [iw=wt]

*Age 12-15
tab nt_bottle if age>11 & age<16 [iw=wt] 

*Age 12-23
tab nt_bottle if age>11 & age<24 [iw=wt]

*Age 20-23
tab nt_bottle if age>19 & age<24  [iw=wt]

* output to excel
tabout agecats nt_bottle using Tables_bf.xls [iw=wt] , c(row) f(1) append 
tabout nt_bottle if age<4 using Tables_bf.xls [iw=wt] , clab("0-3months") c(cell) f(1) append 
tabout nt_bottle if age<6 using Tables_bf.xls [iw=wt] , clab("0-5months") c(cell) f(1) append 
tabout nt_bottle if age>5 & age<10 using Tables_bf.xls [iw=wt] , clab("6-9months") c(cell) f(1) append 
tabout nt_bottle if age>11 & age<16 using Tables_bf.xls [iw=wt] , clab("12-15months") c(cell) f(1) append 
tabout nt_bottle if age>11 & age<24 using Tables_bf.xls [iw=wt] , clab("12-23months") c(cell) f(1) append 
tabout nt_bottle if age>19 & age<24 using Tables_bf.xls [iw=wt] , clab("20-23months") c(cell) f(1) append 

* Total for IYCF tables
tabout nt_bottle using Tables_IYCF.xls [iw=wt] , oneway c(cell freq) f(1) replace 

*/
**************************************************************************************************
* Micronutrient intake
**************************************************************************************************
//Given Vitamin and Mineral Powder among children 6-23 months
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
tabout agemonths b4 brstfed agem v025 v024 v106 v190 nt_ch_micro_mp using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Given iron supplements among children 6-59 months
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
//Given deworming medication among children 6-59 months
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
****************************************************
//Children age 6-59 living in household with iodized salt 
*child's age in months
tab agemonths nt_ch_micro_iod [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_micro_iod [iw=wt], row nofreq 

*Breastfeeding status
tab brstfed nt_ch_micro_iod [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_micro_iod [iw=wt], row nofreq 

*residence
tab v025 nt_ch_micro_iod [iw=wt], row nofreq 

*region
tab v024 nt_ch_micro_iod [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_micro_iod [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_micro_iod [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 brstfed agem v025 v024 v106 v190 nt_ch_micro_iod using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Given therapeutic food among children 6-35 months
*child's age in months
tab agemonths nt_ch_food_ther [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_food_ther [iw=wt], row nofreq 

*Breastfeeding status
tab brstfed nt_ch_food_ther [iw=wt], row nofreq 

*Wasting status
tab waste nt_ch_food_ther [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_food_ther [iw=wt], row nofreq 

*residence
tab v025 nt_ch_food_ther [iw=wt], row nofreq 

*region
tab v024 nt_ch_food_ther [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_food_ther [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_food_ther [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 brstfed waste agem v025 v024 v106 v190 nt_ch_food_ther using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Given supplemental food among children 6-35 months
*child's age in months
tab agemonths nt_ch_food_supp [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_food_supp [iw=wt], row nofreq 

*Breastfeeding status
tab brstfed nt_ch_food_supp [iw=wt], row nofreq 

*Wasting status
tab waste nt_ch_food_supp [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_food_supp [iw=wt], row nofreq 

*residence
tab v025 nt_ch_food_supp [iw=wt], row nofreq 

*region
tab v024 nt_ch_food_supp [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_food_supp [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_food_supp [iw=wt], row nofreq 

* output to excel
tabout agemonths b4 brstfed waste agem v025 v024 v106 v190 nt_ch_food_supp using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
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
* Nutritional status of women
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

**************************************************************************************************
* Micronutrient intake among women
**************************************************************************************************
//Number of days women took iron tablets or syrup during pregnancy 
*age
tab agecat nt_wm_micro_iron [iw=wt], row nofreq 

*residence
tab v025 nt_wm_micro_iron [iw=wt], row nofreq 

*region
tab v024 nt_wm_micro_iron [iw=wt], row nofreq 

*education
tab v106 nt_wm_micro_iron [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_micro_iron [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_micro_iron using Tables_micronut_wm.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Took deworming medication during pregnancy
*age
tab agecat nt_wm_micro_dwm [iw=wt], row nofreq 

*residence
tab v025 nt_wm_micro_dwm [iw=wt], row nofreq 

*region
tab v024 nt_wm_micro_dwm [iw=wt], row nofreq 

*education
tab v106 nt_wm_micro_dwm [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_micro_dwm [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_micro_dwm using Tables_micronut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Live in a household with iodized salt
*age
tab agecat nt_wm_micro_iod [iw=wt], row nofreq 

*residence
tab v025 nt_wm_micro_iod [iw=wt], row nofreq 

*region
tab v024 nt_wm_micro_iod [iw=wt], row nofreq 

*education
tab v106 nt_wm_micro_iod [iw=wt], row nofreq 

*wealth
tab v190 nt_wm_micro_iod [iw=wt], row nofreq 

* output to excel
tabout agecat v025 v024 v106 v190 nt_wm_micro_iod using Tables_micronut_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {
cap gen wt=mv005/1000000

**************************************************************************************************
* background variables

* Note: droping men over age 49. If you want to produce tables for all men then comment out this line. 
drop if mv013>7

//Age 
recode mv013 (1=1 "15-19") (2/3=2 "20-29") (4/5=3 "30-39") (6/7=4 "40-49"), gen(agecat)

//Smokes cigarettes
gen smoke=0
replace smoke=1 if inrange(mv464a,1,888) | inrange(mv464b,1,888) | inrange(mv464c,1,888) | inrange(mv484a,1,888) | inrange(mv484b,1,888) | inrange(mv484c,1,888) 
label values smoke yesno

**************************************************************************************************
* Nutritional status of men
**************************************************************************************************
//Mean bmi - men 15-49
tab nt_mn_bmi_mean

//Mean bmi - men 15-54
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

}
