/*****************************************************************************************************
Program: 			NT_tables2.do
Purpose: 			produce tables for indicators with the denominator of the youngest child under age 2 years living with the mother
Author:				Shireen Assaf
Date last modified: January 8 2020 by Shireen Assaf 

*Note this do file will produce the following tables in excel:

*These tables will append to the same excel files produced in NT_tables.do

	1. 	Tables_brst_fed:	Contains the tables for breastfeeding indicators
	2.	Tables_IYCF:		Contains the tables for IYCF indicators in children
	3. 	Tables_micronut_ch:	Contains the tables for micronutrient intake in children

*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* Indicators from KR file restricted to youngest child under 2 years living with the mother

cap gen wt=v005/1000000

**************************************************************************************************
* background variables

//Age categories
cap recode age (0/1=1 " 0-1") (2/3=2 " 2-3") (4/5=3 " 4-5") (6/8=4 " 6-8") (9/11=5 " 9-11") (12/17=6 " 12-17") (18/23=7 " 18-23") , gen(agecats)

//Age category 6-23
recode age (6/23=1 " 6-23") (else=0) , gen(agecats623)

**************************************************************************************************
* Breastfeeding status 
**************************************************************************************************
//Breastfeeding status
*Age categories
tab agecats nt_bf_status [iw=wt], row nofreq 

*Age 0-3
tab nt_bf_ever if age<4 [iw=wt] 

*Age 0-5
tab nt_bf_status if age<6 [iw=wt]

*Age 6-9
tab nt_bf_status if age>5 & age<10 [iw=wt]

*Age 12-15
tab nt_bf_status if age>11 & age<16 [iw=wt] 

*Age 12-23
tab nt_bf_status if age>11 & age<24 [iw=wt]

*Age 20-23
tab nt_bf_status if age>19 & age<24  [iw=wt]

* output to excel
tabout agecats nt_bf_status using Tables_brst_fed.xls [iw=wt] , c(row) f(1) append 
tabout nt_bf_status if age<4 using Tables_brst_fed.xls [iw=wt] , clab("0-3months") c(cell) f(1) append 
tabout nt_bf_status if age<6 using Tables_brst_fed.xls [iw=wt] , clab("0-5months") c(cell) f(1) append 
tabout nt_bf_status if age>5 & age<10 using Tables_brst_fed.xls [iw=wt] , clab("6-9months") c(cell) f(1) append 
tabout nt_bf_status if age>11 & age<16 using Tables_brst_fed.xls [iw=wt] , clab("12-15months") c(cell) f(1) append 
tabout nt_bf_status if age>11 & age<24 using Tables_brst_fed.xls [iw=wt] , clab("12-23months") c(cell) f(1) append 
tabout nt_bf_status if age>19 & age<24 using Tables_brst_fed.xls [iw=wt] , clab("20-23months") c(cell) f(1) append 
*/
**************************************************************************************************
//Currently breastfeeding
*Age categories
tab agecats nt_bf_curr [iw=wt], row nofreq 

*Age 0-3
tab nt_bf_curr if age<4 [iw=wt] 

*Age 0-5
tab nt_bf_curr if age<6 [iw=wt]

*Age 6-9
tab nt_bf_curr if age>5 & age<10 [iw=wt]

*Age 12-15
tab nt_bf_curr if age>11 & age<16 [iw=wt] 

*Age 12-23
tab nt_bf_curr if age>11 & age<24 [iw=wt]

*Age 20-23
tab nt_bf_curr if age>19 & age<24  [iw=wt]

* output to excel
tabout agecats nt_bf_curr using Tables_brst_fed.xls [iw=wt] , c(row) f(1) append 
tabout nt_bf_curr if age<4 using Tables_brst_fed.xls [iw=wt] , clab("0-3months") c(cell) f(1) append 
tabout nt_bf_curr if age<6 using Tables_brst_fed.xls [iw=wt] ,  clab("0-5months") c(cell) f(1) append 
tabout nt_bf_curr if age>5 & age<10 using Tables_brst_fed.xls [iw=wt] , clab("6-9months")  c(cell) f(1) append 
tabout nt_bf_curr if age>11 & age<16 using Tables_brst_fed.xls [iw=wt] , clab("12-15months")  c(cell) f(1) append 
tabout nt_bf_curr if age>11 & age<24 using Tables_brst_fed.xls [iw=wt] , clab("12-23months")  c(cell) f(1) append 
tabout nt_bf_curr if age>19 & age<24 using Tables_brst_fed.xls [iw=wt] , clab("20-23months") c(cell) f(1) append 
*/

**************************************************************************************************
* IYCF indicators
**************************************************************************************************
//Exclusive breastfeeding 

*Age under 6
tab nt_ebf if age<6 [iw=wt]

*Age 5-6
ta nt_ebf if age>=4 & age<6 [iw=wt]

* output to excel
tabout nt_ebf if age <6 using Tables_IYCF.xls [iw=wt] , c(cell freq) clab("age<6") f(1) append 
tabout nt_ebf if age>=4 & age<6 using Tables_IYCF.xls [iw=wt] , c(cell freq) clab("age5-6") f(1) append 

//Continued breastfeeding

* Continued breastfeeding at 1 year for children 12-15 months
tab nt_bf_cont_1yr [iw=wt]

* Continued breastfeeding at 2 years for children 20-23 months
tab nt_bf_cont_2yr [iw=wt]

//Introduction of solid, semi-solid, or soft foods 
tab nt_food_bf [iw=wt]

//Age appropriate breastfeeding
tab nt_ageapp_bf [iw=wt]

//Predominantly breastfeeding
tab nt_predo_bf [iw=wt]

* output to excel
tabout nt_bf_cont_1yr nt_food_bf nt_bf_cont_2yr nt_ageapp_bf nt_predo_bf using Tables_IYCF.xls [iw=wt] , oneway c(cell freq) f(1) append 
**************************************************************************************************
* Foods and liquids consumed
**************************************************************************************************

*** Among breastfeeding children ***

//Infant formula
tab agecats nt_formula if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_formula if nt_bf_curr==1 [iw=wt], row  

//Other milk
tab agecats nt_milk if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_milk if nt_bf_curr==1 [iw=wt], row  

//Other liquids
tab agecats nt_liquids if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_liquids if nt_bf_curr==1 [iw=wt], row  

//Fortified baby foods
tab agecats nt_bbyfood if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_bbyfood if nt_bf_curr==1 [iw=wt], row  

//Grains
tab agecats nt_grains if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_grains if nt_bf_curr==1 [iw=wt], row  

//Fruits and vegetables rich in Vit. A
tab agecats nt_vita if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_vita if nt_bf_curr==1 [iw=wt], row  

//Other fruits and vegetables
tab agecats nt_frtveg if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_frtveg if nt_bf_curr==1 [iw=wt], row  

//Roots and tubers
tab agecats nt_root if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_root if nt_bf_curr==1 [iw=wt], row  

//Nuts and legumes
tab agecats nt_nuts if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_nuts if nt_bf_curr==1 [iw=wt], row  

//Meat, fish, poultry
tab agecats nt_meatfish if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_meatfish if nt_bf_curr==1 [iw=wt], row  

//Eggs
tab agecats nt_eggs if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_eggs if nt_bf_curr==1 [iw=wt], row  

//Dairy
tab agecats nt_dairy if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_dairy if nt_bf_curr==1 [iw=wt], row  

//Any solid or semi-solid food
tab agecats nt_solids if nt_bf_curr==1 [iw=wt], row  
tab agecats623 nt_solids if nt_bf_curr==1 [iw=wt], row  

* output to excel
* for all age categories
tabout nt_formula nt_milk nt_liquids nt_bbyfood nt_grains nt_vita nt_frtveg nt_root nt_nuts nt_meatfish nt_eggs nt_dairy nt_solids agecats if nt_bf_curr==1 using Tables_IYCF.xls [iw=wt], h1("Breastfeeding children by age categories") c(col) f(1) append 

* for age 6-23
tabout nt_formula nt_milk nt_liquids nt_bbyfood nt_grains nt_vita nt_frtveg nt_root nt_nuts nt_meatfish nt_eggs nt_dairy nt_solids agecats623 if nt_bf_curr==1 using Tables_IYCF.xls [iw=wt], h1("Breastfeeding children for children 6-23 months") c(col) f(1) append 

*** Among non-breastfeeding children ***

//Infant formula
tab agecats nt_formula if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_formula if nt_bf_curr==0 [iw=wt], row  

//Other milk
tab agecats nt_milk if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_milk if nt_bf_curr==0 [iw=wt], row  

//Other liquids
tab agecats nt_liquids if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_liquids if nt_bf_curr==0 [iw=wt], row  

//Fortified baby foods
tab agecats nt_bbyfood if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_bbyfood if nt_bf_curr==0 [iw=wt], row  

//Grains
tab agecats nt_grains if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_grains if nt_bf_curr==0 [iw=wt], row  

//Fruits and vegetables rich in Vit. A
tab agecats nt_vita if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_vita if nt_bf_curr==0 [iw=wt], row  

//Other fruits and vegetables
tab agecats nt_frtveg if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_frtveg if nt_bf_curr==0 [iw=wt], row  

//Roots and tubers
tab agecats nt_root if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_root if nt_bf_curr==0 [iw=wt], row  

//Nuts and legumes
tab agecats nt_nuts if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_nuts if nt_bf_curr==0 [iw=wt], row  

//Meat, fish, poultry
tab agecats nt_meatfish if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_meatfish if nt_bf_curr==0 [iw=wt], row  

//Eggs
tab agecats nt_eggs if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_eggs if nt_bf_curr==0 [iw=wt], row  

//Dairy
tab agecats nt_dairy if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_dairy if nt_bf_curr==0 [iw=wt], row  

//Any solid or semi-solid food
tab agecats nt_solids if nt_bf_curr==0 [iw=wt], row  
tab agecats623 nt_solids if nt_bf_curr==0 [iw=wt], row  

* output to excel
* for all age categories
tabout nt_formula nt_milk nt_liquids nt_bbyfood nt_grains nt_vita nt_frtveg nt_root nt_nuts nt_meatfish nt_eggs nt_dairy nt_solids agecats if nt_bf_curr==0 using Tables_IYCF.xls [iw=wt],  h1("Non-breastfeeding children by age categories") c(col) f(1) append 

* for age 6-23
tabout nt_formula nt_milk nt_liquids nt_bbyfood nt_grains nt_vita nt_frtveg nt_root nt_nuts nt_meatfish nt_eggs nt_dairy nt_solids agecats623 if nt_bf_curr==0 using Tables_IYCF.xls [iw=wt], h1("Non-breastfeeding children for children 6-23 months") c(col) f(1) append 

**************************************************************************************************
* Minimum acceptable diet
**************************************************************************************************

*** Among breastfeeding children ***

//Minimum dietary diversity
*age categories
tab agecats nt_mdd if nt_bf_curr==1 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mdd if nt_bf_curr==1  [iw=wt], row nofreq 

*residence
tab v025 nt_mdd if nt_bf_curr==1 [iw=wt], row nofreq 

*region
tab v024 nt_mdd if nt_bf_curr==1 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mdd if nt_bf_curr==1  [iw=wt], row nofreq 

*wealth
tab v190 nt_mdd if nt_bf_curr==1 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mdd if nt_bf_curr==1 using Tables_IYCF.xls [iw=wt] , h1("Minimum dietary diversity among breastfeeding children") c(row) f(1) append 

****
//Minimum meal frequency
*age categories
tab agecats nt_mmf if nt_bf_curr==1 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mmf if nt_bf_curr==1  [iw=wt], row nofreq 

*residence
tab v025 nt_mmf if nt_bf_curr==1 [iw=wt], row nofreq 

*region
tab v024 nt_mmf if nt_bf_curr==1 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mmf if nt_bf_curr==1  [iw=wt], row nofreq 

*wealth
tab v190 nt_mmf if nt_bf_curr==1 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mmf if nt_bf_curr==1 using Tables_IYCF.xls [iw=wt] , h1("Minimum meal frequency among breastfeeding children") c(row) f(1) append 

****
//Minimum acceptable diet
*age categories
tab agecats nt_mad if nt_bf_curr==1 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mad if nt_bf_curr==1  [iw=wt], row nofreq 

*residence
tab v025 nt_mad if nt_bf_curr==1 [iw=wt], row nofreq 

*region
tab v024 nt_mad if nt_bf_curr==1 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mad if nt_bf_curr==1  [iw=wt], row nofreq 

*wealth
tab v190 nt_mad if nt_bf_curr==1 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mad if nt_bf_curr==1 using Tables_IYCF.xls [iw=wt] , h1("Minimum acceptable diet among breastfeeding children") c(row) f(1) append 

********************
*** Among non-breastfeeding children ***

//Given milk or milk products
*age categories
tab agecats nt_fed_milk if nt_bf_curr==0 [iw=wt], row nofreq 

*child's sex
tab b4 nt_fed_milk if nt_bf_curr==0  [iw=wt], row nofreq 

*residence
tab v025 nt_fed_milk if nt_bf_curr==0 [iw=wt], row nofreq 

*region
tab v024 nt_fed_milk if nt_bf_curr==0 [iw=wt], row nofreq 

*mother's education
tab v106 nt_fed_milk if nt_bf_curr==0  [iw=wt], row nofreq 

*wealth
tab v190 nt_fed_milk if nt_bf_curr==0 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_fed_milk if nt_bf_curr==0 using Tables_IYCF.xls [iw=wt] , h1("Milk or milk products among non-breastfeeding children") c(row) f(1) append 

****

//Minimum dietary diversity
*age categories
tab agecats nt_mdd if nt_bf_curr==0 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mdd if nt_bf_curr==0  [iw=wt], row nofreq 

*residence
tab v025 nt_mdd if nt_bf_curr==0 [iw=wt], row nofreq 

*region
tab v024 nt_mdd if nt_bf_curr==0 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mdd if nt_bf_curr==0  [iw=wt], row nofreq 

*wealth
tab v190 nt_mdd if nt_bf_curr==0 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mdd if nt_bf_curr==0 using Tables_IYCF.xls [iw=wt] , h1("Minimum dietary diversity among non-breastfeeding children") c(row) f(1) append 

****
//Minimum meal frequency
*age categories
tab agecats nt_mmf if nt_bf_curr==0 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mmf if nt_bf_curr==0  [iw=wt], row nofreq 

*residence
tab v025 nt_mmf if nt_bf_curr==0 [iw=wt], row nofreq 

*region
tab v024 nt_mmf if nt_bf_curr==0 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mmf if nt_bf_curr==0  [iw=wt], row nofreq 

*wealth
tab v190 nt_mmf if nt_bf_curr==0 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mmf if nt_bf_curr==0 using Tables_IYCF.xls [iw=wt] , h1("Minimum meal frequency among non-breastfeeding children") c(row) f(1) append 

****
//Minimum acceptable diet
*age categories
tab agecats nt_mad if nt_bf_curr==0 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mad if nt_bf_curr==0  [iw=wt], row nofreq 

*residence
tab v025 nt_mad if nt_bf_curr==0 [iw=wt], row nofreq 

*region
tab v024 nt_mad if nt_bf_curr==0 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mad if nt_bf_curr==0  [iw=wt], row nofreq 

*wealth
tab v190 nt_mad if nt_bf_curr==0 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mad if nt_bf_curr==0 using Tables_IYCF.xls [iw=wt] , h1("Minimum acceptable diet among non-breastfeeding children") c(row) f(1) append 

********************

*** Among all children ***

//Given milk or milk products
*age categories
tab agecats nt_fed_milk [iw=wt], row nofreq 

*child's sex
tab b4 nt_fed_milk [iw=wt], row nofreq 

*residence
tab v025 nt_fed_milk [iw=wt], row nofreq 

*region
tab v024 nt_fed_milk [iw=wt], row nofreq 

*mother's education
tab v106 nt_fed_milk [iw=wt], row nofreq 

*wealth
tab v190 nt_fed_milk [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_fed_milk using Tables_IYCF.xls [iw=wt] , h1("Milk or milk products among all children") c(row) f(1) append 

****

//Minimum dietary diversity
*age categories
tab agecats nt_mdd [iw=wt], row nofreq 

*child's sex
tab b4 nt_mdd [iw=wt], row nofreq 

*residence
tab v025 nt_mdd [iw=wt], row nofreq 

*region
tab v024 nt_mdd [iw=wt], row nofreq 

*mother's education
tab v106 nt_mdd [iw=wt], row nofreq 

*wealth
tab v190 nt_mdd [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mdd using Tables_IYCF.xls [iw=wt] , h1("Minimum dietary diversity among all children") c(row) f(1) append 

****
//Minimum meal frequency
*age categories
tab agecats nt_mmf [iw=wt], row nofreq 

*child's sex
tab b4 nt_mmf [iw=wt], row nofreq 

*residence
tab v025 nt_mmf [iw=wt], row nofreq 

*region
tab v024 nt_mmf [iw=wt], row nofreq 

*mother's education
tab v106 nt_mmf  [iw=wt], row nofreq 

*wealth
tab v190 nt_mmf [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mmf using Tables_IYCF.xls [iw=wt] , h1("Minimum meal frequency among all children") c(row) f(1) append 

****
//Minimum acceptable diet
*age categories
tab agecats nt_mad [iw=wt], row nofreq 

*child's sex
tab b4 nt_mad [iw=wt], row nofreq 

*residence
tab v025 nt_mad [iw=wt], row nofreq 

*region
tab v024 nt_mad [iw=wt], row nofreq 

*mother's education
tab v106 nt_mad [iw=wt], row nofreq 

*wealth
tab v190 nt_mad [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mad using Tables_IYCF.xls [iw=wt] , h1("Minimum acceptable diet among all children") c(row) f(1) append 
**************************************************************************************************
* Micronutrient intake
**************************************************************************************************
//Given foods rich in Vit A. among youngest children 6-23 months living with the mother
*child's age in months
tab agecats nt_ch_micro_vaf [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_micro_vaf [iw=wt], row nofreq 

*Breastfeeding status
tab nt_bf_curr nt_ch_micro_vaf [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_micro_vaf [iw=wt], row nofreq 

*residence
tab v025 nt_ch_micro_vaf [iw=wt], row nofreq 

*region
tab v024 nt_ch_micro_vaf [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_micro_vaf [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_micro_vaf [iw=wt], row nofreq 

* output to excel
tabout agecats b4 nt_bf_curr agem v025 v024 v106 v190 nt_ch_micro_vaf using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Given foods rich in iron among youngest children 6-23 months living with the mother
*child's age in months
tab agecats nt_ch_micro_irf [iw=wt], row nofreq 

*child's sex
tab b4 nt_ch_micro_irf [iw=wt], row nofreq 

*Breastfeeding status
tab nt_bf_curr nt_ch_micro_irf [iw=wt], row nofreq 

*Mother's age
tab agem nt_ch_micro_irf [iw=wt], row nofreq 

*residence
tab v025 nt_ch_micro_irf [iw=wt], row nofreq 

*region
tab v024 nt_ch_micro_irf [iw=wt], row nofreq 

*mother's education
tab v106 nt_ch_micro_irf [iw=wt], row nofreq 

*wealth
tab v190 nt_ch_micro_irf [iw=wt], row nofreq 

* output to excel
tabout agecats b4 nt_bf_curr agem v025 v024 v106 v190 nt_ch_micro_irf using Tables_micronut_ch.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************



