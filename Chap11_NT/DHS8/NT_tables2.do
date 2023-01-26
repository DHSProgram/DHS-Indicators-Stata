/*****************************************************************************************************
Program: 			NT_tables2.do
Purpose: 			produce tables for indicators with the denominator of the youngest child under age 2 years living with the mother
Author:				Shireen Assaf
Date last modified: November 15 2022 by Shireen Assaf 

*This do file will produce the following tables in excel:
*These tables will append to the same excel files produced in NT_tables.do
1. 	Tables_bf:			Contains the tables for breastfeeding indicators
2.	Tables_liquids:		Contains the liquid consumed indicators
3. 	Tables_foods:		Contains foods conusmed indicators
4.	Tables_IYCF:		Contains the tables for IYCF indicators in children

*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* Indicators from KR file restricted to youngest child under 2 years living with the mother

cap gen wt=v005/1000000

**************************************************************************************************
* background variables

//Age categories
cap recode age (0/1=1 " 0-1") (2/3=2 " 2-3") (4/5=3 " 4-5") (6/11=4 " 6-11") (12/15=5 " 12-15") (16/19=6 " 16-19") (20/23=7 " 20-23") , gen(agecats)

//Age category 6-23
recode age (6/23=1 " 6-23") (else=0) , gen(agecats623)

//Mother's age 
cap recode v013 (1=1 "15-19") (2/3=2 "20-29") (4/5=3 "30-39") (6/7=4 "40-49"), gen(agem)

**************************************************************************************************
* Breastfeeding status - appended to Tables_bf tables. 
**************************************************************************************************
* among children 0-5 months
//Exclusively breastfeeding

*child's age
tab agecats nt_ebf [iw=wt], row nofreq 

*child's sex
tab b4 nt_ebf [iw=wt], row nofreq 

*residence
tab v025 nt_ebf [iw=wt], row nofreq 

*region
tab v024 nt_ebf [iw=wt], row nofreq 

*mother's education
tab v106 nt_ebf [iw=wt], row nofreq 

*wealth
tab v190 nt_ebf [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_ebf using Tables_bf.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Mixed milk feeding
*child's age
tab agecats nt_milkmix [iw=wt], row nofreq 

*child's sex
tab b4 nt_milkmix [iw=wt], row nofreq 

*residence
tab v025 nt_milkmix [iw=wt], row nofreq 

*region
tab v024 nt_milkmix [iw=wt], row nofreq 

*mother's education
tab v106 nt_milkmix [iw=wt], row nofreq 

*wealth
tab v190 nt_milkmix [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_milkmix using Tables_bf.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Breastfeeding status
*Age categories
tab agecats nt_bf_status [iw=wt], row nofreq 

* output to excel
tabout agecats nt_bf_status using Tables_bf.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Liquids consumed by children - Table_liquids excel file produced
**************************************************************************************************

*** Among breastfeeding children ***

tab1 nt_water nt_formula nt_milk nt_smilk nt_yogurt nt_syogdrink nt_nutmilk nt_snutmilk nt_juice nt_soda nt_teacoff nt_steacoff nt_soup nt_oliquids nt_sliquids if m4==95 [iw=wt]

* output to excel
* for all age categories
tabout nt_water nt_formula nt_milk nt_smilk nt_yogurt nt_syogdrink nt_nutmilk nt_snutmilk nt_juice nt_soda nt_teacoff nt_steacoff nt_soup nt_oliquids nt_sliquids  agecats if m4==95 using Table_liquids.xls [iw=wt], h1("Breastfeeding children by age categories") c(col) f(1) replace 

* for age 6-23
tabout nt_water nt_formula nt_milk nt_smilk nt_yogurt nt_syogdrink nt_nutmilk nt_snutmilk nt_juice nt_soda nt_teacoff nt_steacoff nt_soup nt_oliquids nt_sliquids agecats623 if m4==95 using Table_liquids.xls [iw=wt], h1("Breastfeeding children for children 6-23 months") c(col) f(1) append 

* Total
tabout nt_water nt_formula nt_milk nt_smilk nt_yogurt nt_syogdrink nt_nutmilk nt_snutmilk nt_juice nt_soda nt_teacoff nt_steacoff nt_soup nt_oliquids nt_sliquids  if m4==95 using Table_liquids.xls [iw=wt], h1("Breastfeeding children - Total") oneway c(cell) f(1) append 

*** Among non-breastfeeding children ***

tab1 nt_water nt_formula nt_milk nt_smilk nt_yogurt nt_syogdrink nt_nutmilk nt_snutmilk nt_juice nt_soda nt_teacoff nt_steacoff nt_soup nt_oliquids nt_sliquids if m4!=95 [iw=wt]

* output to excel
* for all age categories
tabout nt_water nt_formula nt_milk nt_smilk nt_yogurt nt_syogdrink nt_nutmilk nt_snutmilk nt_juice nt_soda nt_teacoff nt_steacoff nt_soup nt_oliquids nt_sliquids  agecats if m4!=95 using Table_liquids.xls [iw=wt], h1("Non-breastfeeding children by age categories") c(col) f(1) append 

* for age 6-23
tabout nt_water nt_formula nt_milk nt_smilk nt_yogurt nt_syogdrink nt_nutmilk nt_snutmilk nt_juice nt_soda nt_teacoff nt_steacoff nt_soup nt_oliquids nt_sliquids agecats623 if m4!=95 using Table_liquids.xls [iw=wt], h1("Non-breastfeeding children for children 6-23 months") c(col) f(1) append 

* Total
tabout nt_water nt_formula nt_milk nt_smilk nt_yogurt nt_syogdrink nt_nutmilk nt_snutmilk nt_juice nt_soda nt_teacoff nt_steacoff nt_soup nt_oliquids nt_sliquids  if m4!=95 using Table_liquids.xls [iw=wt], h1("Non-breastfeeding children - Total") oneway c(cell) f(1) append 



**************************************************************************************************
* Foods consumed by children - Table_foods excel file produced
**************************************************************************************************

*** Among breastfeeding children ***

tab1 nt_grains nt_root nt_nuts nt_dairy nt_meatfish nt_eggs nt_vita nt_frtveg nt_insect nt_palm nt_sweets nt_salty nt_osolids if m4==95 [iw=wt]

* output to excel
* for all age categories
tabout nt_grains nt_root nt_nuts nt_dairy nt_meatfish nt_eggs nt_vita nt_frtveg nt_insect nt_palm nt_sweets nt_salty nt_osolids agecats if m4==95 using Table_foods.xls [iw=wt], h1("Breastfeeding children by age categories") c(col) f(1) replace 

* for age 6-23
tabout nt_grains nt_root nt_nuts nt_dairy nt_meatfish nt_eggs nt_vita nt_frtveg nt_insect nt_palm nt_sweets nt_salty nt_osolids agecats623 if m4==95 using Table_foods.xls [iw=wt], h1("Breastfeeding children for children 6-23 months") c(col) f(1) append 

* Total
tabout nt_grains nt_root nt_nuts nt_dairy nt_meatfish nt_eggs nt_vita nt_frtveg nt_insect nt_palm nt_sweets nt_salty nt_osolids if m4==95 using Table_foods.xls [iw=wt], h1("Breastfeeding children - Total") oneway c(cell) f(1) append 

*** Among non-breastfeeding children ***

tab1 nt_grains nt_root nt_nuts nt_dairy nt_meatfish nt_eggs nt_vita nt_frtveg nt_insect nt_palm nt_sweets nt_salty nt_osolids if m4!=95 [iw=wt]

* output to excel
* for all age categories
tabout nt_grains nt_root nt_nuts nt_dairy nt_meatfish nt_eggs nt_vita nt_frtveg nt_insect nt_palm nt_sweets nt_salty nt_osolids agecats if m4!=95 using Table_foods.xls [iw=wt], h1("Non-breastfeeding children by age categories") c(col) f(1) append 

* for age 6-23
tabout nt_grains nt_root nt_nuts nt_dairy nt_meatfish nt_eggs nt_vita nt_frtveg nt_insect nt_palm nt_sweets nt_salty nt_osolids agecats623 if m4!=95 using Table_foods.xls [iw=wt], h1("Non-breastfeeding children for children 6-23 months") c(col) f(1) append 

* Total
tabout nt_grains nt_root nt_nuts nt_dairy nt_meatfish nt_eggs nt_vita nt_frtveg nt_insect nt_palm nt_sweets nt_salty nt_osolids if m4!=95 using Table_foods.xls [iw=wt], h1("Non-breastfeeding children - Total") oneway c(cell) f(1) append 

**************************************************************************************************
**  Egg and/or flesh food consumption and unhealthy feeding practices among children age 6-23 months
*nt_egg_flesh nt_swt_drink nt_unhlth_food nt_zvf

//Egg and flesh foods
*child's age
tab agecats nt_egg_flesh [iw=wt], row nofreq 

*child's sex
tab b4 nt_egg_flesh [iw=wt], row nofreq 

*residence
tab v025 nt_egg_flesh [iw=wt], row nofreq 

*region
tab v024 nt_egg_flesh [iw=wt], row nofreq 

*mother's education
tab v106 nt_egg_flesh [iw=wt], row nofreq 

*wealth
tab v190 nt_egg_flesh [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_egg_flesh using Tables_foods.xls [iw=wt] , c(row) f(1) append 

*************
//Sweetened drinks
*child's age
tab agecats nt_swt_drink [iw=wt], row nofreq 

*child's sex
tab b4 nt_swt_drink [iw=wt], row nofreq 

*residence
tab v025 nt_swt_drink [iw=wt], row nofreq 

*region
tab v024 nt_swt_drink [iw=wt], row nofreq 

*mother's education
tab v106 nt_swt_drink [iw=wt], row nofreq 

*wealth
tab v190 nt_swt_drink [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_swt_drink using Tables_foods.xls [iw=wt] , c(row) f(1) append 

*************
//unhealthy foods
*child's age
tab agecats nt_unhlth_food [iw=wt], row nofreq 

*child's sex
tab b4 nt_unhlth_food [iw=wt], row nofreq 

*residence
tab v025 nt_unhlth_food [iw=wt], row nofreq 

*region
tab v024 nt_unhlth_food [iw=wt], row nofreq 

*mother's education
tab v106 nt_unhlth_food [iw=wt], row nofreq 

*wealth
tab v190 nt_unhlth_food [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_unhlth_food using Tables_foods.xls [iw=wt] , c(row) f(1) append 

*************
//zero vegetables or fruits given
*child's age
tab agecats nt_zvf [iw=wt], row nofreq 

*child's sex
tab b4 nt_zvf [iw=wt], row nofreq 

*residence
tab v025 nt_zvf [iw=wt], row nofreq 

*region
tab v024 nt_zvf [iw=wt], row nofreq 

*mother's education
tab v106 nt_zvf [iw=wt], row nofreq 

*wealth
tab v190 nt_zvf [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_zvf using Tables_foods.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Minimum acceptable diet
**************************************************************************************************

*** Among breastfeeding children ***

//Minimum dietary diversity
*age categories
tab agecats nt_mdd if m4==95 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mdd if m4==95  [iw=wt], row nofreq 

*residence
tab v025 nt_mdd if m4==95 [iw=wt], row nofreq 

*region
tab v024 nt_mdd if m4==95 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mdd if m4==95  [iw=wt], row nofreq 

*wealth
tab v190 nt_mdd if m4==95 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mdd if m4==95 using Tables_IYCF.xls [iw=wt] , h1("Minimum dietary diversity among breastfeeding children") c(row) f(1) append 

****
//Minimum meal frequency
*age categories
tab agecats nt_mmf if m4==95 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mmf if m4==95  [iw=wt], row nofreq 

*residence
tab v025 nt_mmf if m4==95 [iw=wt], row nofreq 

*region
tab v024 nt_mmf if m4==95 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mmf if m4==95  [iw=wt], row nofreq 

*wealth
tab v190 nt_mmf if m4==95 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mmf if m4==95 using Tables_IYCF.xls [iw=wt] , h1("Minimum meal frequency among breastfeeding children") c(row) f(1) append 

****
//Minimum acceptable diet
*age categories
tab agecats nt_mad if m4==95 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mad if m4==95  [iw=wt], row nofreq 

*residence
tab v025 nt_mad if m4==95 [iw=wt], row nofreq 

*region
tab v024 nt_mad if m4==95 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mad if m4==95  [iw=wt], row nofreq 

*wealth
tab v190 nt_mad if m4==95 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mad if m4==95 using Tables_IYCF.xls [iw=wt] , h1("Minimum acceptable diet among breastfeeding children") c(row) f(1) append 

********************
*** Among non-breastfeeding children ***

//Given milk or milk products
*age categories
tab agecats nt_milkfeeds if m4!=95 [iw=wt], row nofreq 

*child's sex
tab b4 nt_milkfeeds if m4!=95  [iw=wt], row nofreq 

*residence
tab v025 nt_milkfeeds if m4!=95 [iw=wt], row nofreq 

*region
tab v024 nt_milkfeeds if m4!=95 [iw=wt], row nofreq 

*mother's education
tab v106 nt_milkfeeds if m4!=95  [iw=wt], row nofreq 

*wealth
tab v190 nt_milkfeeds if m4!=95 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_milkfeeds if m4!=95 using Tables_IYCF.xls [iw=wt] , h1("Milk or milk products among non-breastfeeding children") c(row) f(1) append 

****

//Minimum dietary diversity
*age categories
tab agecats nt_mdd if m4!=95 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mdd if m4!=95  [iw=wt], row nofreq 

*residence
tab v025 nt_mdd if m4!=95 [iw=wt], row nofreq 

*region
tab v024 nt_mdd if m4!=95 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mdd if m4!=95  [iw=wt], row nofreq 

*wealth
tab v190 nt_mdd if m4!=95 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mdd if m4!=95 using Tables_IYCF.xls [iw=wt] , h1("Minimum dietary diversity among non-breastfeeding children") c(row) f(1) append 

****
//Minimum meal frequency
*age categories
tab agecats nt_mmf if m4!=95 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mmf if m4!=95  [iw=wt], row nofreq 

*residence
tab v025 nt_mmf if m4!=95 [iw=wt], row nofreq 

*region
tab v024 nt_mmf if m4!=95 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mmf if m4!=95  [iw=wt], row nofreq 

*wealth
tab v190 nt_mmf if m4!=95 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mmf if m4!=95 using Tables_IYCF.xls [iw=wt] , h1("Minimum meal frequency among non-breastfeeding children") c(row) f(1) append 

****
//Minimum acceptable diet
*age categories
tab agecats nt_mad if m4!=95 [iw=wt], row nofreq 

*child's sex
tab b4 nt_mad if m4!=95  [iw=wt], row nofreq 

*residence
tab v025 nt_mad if m4!=95 [iw=wt], row nofreq 

*region
tab v024 nt_mad if m4!=95 [iw=wt], row nofreq 

*mother's education
tab v106 nt_mad if m4!=95  [iw=wt], row nofreq 

*wealth
tab v190 nt_mad if m4!=95 [iw=wt], row nofreq 

* output to excel
tabout agecats b4 v025 v024 v106 v190 nt_mad if m4!=95 using Tables_IYCF.xls [iw=wt] , h1("Minimum acceptable diet among non-breastfeeding children") c(row) f(1) append 

********************

*** Among all children ***

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
* IYCF table with several indicators: this also includes indicators tabulated in the NT_tables.do file

tab1 nt_ebf nt_milkmix nt_food_bf nt_mdd nt_mmf nt_mad nt_milkfeeds nt_egg_flesh nt_swt_drink nt_unhlth_food nt_zvf [iw=wt]

* output to excel
tabout nt_ebf nt_milkmix nt_food_bf nt_mdd nt_mmf nt_mad nt_milkfeeds nt_egg_flesh nt_swt_drink nt_unhlth_food nt_zvf using Tables_IYCF.xls [iw=wt] , oneway c(cell freq) f(1) append 
**************************************************************************************************

* Mothers who received counseling on IYCF in the last 6 months

*age categories
tab agecats nt_counsel_iycf [iw=wt], row nofreq 

*child's sex
tab b4 nt_counsel_iycf [iw=wt], row nofreq 

*mother's age
tab agem nt_counsel_iycf [iw=wt], row nofreq 

*residence
tab v025 nt_counsel_iycf [iw=wt], row nofreq 

*region
tab v024 nt_counsel_iycf [iw=wt], row nofreq 

*mother's education
tab v106 nt_counsel_iycf [iw=wt], row nofreq 

*wealth
tab v190 nt_counsel_iycf [iw=wt], row nofreq 

* output to excel
tabout agecats b4 agem v025 v024 v106 v190 nt_counsel_iycf using Tables_IYCF.xls [iw=wt] , h1("Minimum acceptable diet among all children") c(row) f(1) append 

