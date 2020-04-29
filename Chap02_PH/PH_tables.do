/*****************************************************************************************************
Program: 			PH_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: April 28 2020 by Shireen Assaf 

*Note this do file will produce the following tables in excel:
	1. 	Tables_hh_charac:		Contains the table for household characteristics
	2. 	Tables_hh_poss:			Contains the table for household possessions
	3.	Tables_handwsh:			Contains the table for handwashing indicators
	4.	Tables_pop:				Contains the tables for the household population by age, sex, and residence and birth registration
	5.	Tables_livarg_orph:		Contains the table for children's living arrangements and orphanhood

Notes: 					 						
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from HR file
if file=="HR" {

gen wt=hv005/1000000

**************************************************************************************************
* Indicators for household characteristics: excel file Tables_hh_charac will be produced
**************************************************************************************************
* all household characteristics are crosstabulated by place of residence

*electricity
tab ph_electric hv025 [iw=wt] , col

*floor marital
tab ph_floor hv025 [iw=wt] , col

*rooms for sleeping
tab ph_rooms_sleep hv025 [iw=wt] , col

*place for cooking
tab ph_cook_place hv025 [iw=wt] , col

*cooking fuel
tab ph_cook_fuel hv025 [iw=wt] , col

*solid fuel for cooking
tab ph_cook_solid hv025 [iw=wt] , col

*clean fuel for cooking
tab ph_cook_clean hv025 [iw=wt] , col

*frequency of smoking in the home
tab ph_smoke hv025 [iw=wt] , col

* output to excel
tabout ph_electric ph_floor ph_rooms_sleep ph_cook_place ph_cook_fuel ph_cook_solid ph_cook_clean ph_smoke hv025 using Tables_hh_charac.xls [iw=wt] , c(col) f(1) replace 
*/
**************************************************************************************************
* Indicators for household possessions: excel file Tables_hh_poss will be produced
**************************************************************************************************
* all household possessions are crosstabulated by place of residence

*radio
tab ph_radio hv025 [iw=wt] , col

*TV
tab ph_tv hv025 [iw=wt] , col

*mobile
tab ph_mobile hv025 [iw=wt] , col

*telephone
tab ph_tel hv025 [iw=wt] , col

*computer
tab ph_comp hv025 [iw=wt] , col

*refrigerator
tab ph_frig hv025 [iw=wt] , col

*bicycle
tab ph_bike hv025 [iw=wt] , col

*animal drawn cart
tab ph_cart hv025 [iw=wt] , col

*motorcycle/scooter
tab ph_moto hv025 [iw=wt] , col

*car or truck
tab ph_car hv025 [iw=wt] , col

*boat with a motor
tab ph_boat hv025 [iw=wt] , col

*agricultural land
tab ph_agriland hv025 [iw=wt] , col

*livestock or farm animals
tab ph_animals hv025 [iw=wt] , col


* output to excel
tabout ph_radio ph_tv ph_mobile ph_tel ph_comp ph_frig ph_bike ph_cart ph_moto ph_car ph_boat ph_agriland ph_animals hv025 using Tables_hh_poss.xls [iw=wt] , c(col) f(1) replace 
*/

**************************************************************************************************
* Indicators for handwashing: excel file Tables_handwsh will be produced
**************************************************************************************************

//fixed place for handwashing
*residence
tab hv025 ph_hndwsh_place_fxd [iw=wt] , row

*region
tab hv024 ph_hndwsh_place_fxd [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_place_fxd [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_place_fxd using Tables_handwsh.xls [iw=wt] , c(row) f(1) replace 
********************

//mobile place for handwashing
*residence
tab hv025 ph_hndwsh_place_mob [iw=wt] , row

*region
tab hv024 ph_hndwsh_place_mob [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_place_mob [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_place_mob using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//fixed and mobile place for handwashing
*residence
tab hv025 ph_hndwsh_plac_both [iw=wt] , row

*region
tab hv024 ph_hndwsh_plac_both [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_plac_both [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_plac_both using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//water only for handwashing
*residence
tab hv025 ph_hndwsh_wtronly [iw=wt] , row

*region
tab hv024 ph_hndwsh_wtronly [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_wtronly [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_wtronly using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//soap and water for handwashing
*residence
tab hv025 ph_hndwsh_soap_wtr [iw=wt] , row

*region
tab hv024 ph_hndwsh_soap_wtr [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_soap_wtr [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_soap_wtr using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//cleansing agent and water for handwashing
*residence
tab hv025 ph_hndwsh_clnsagnt_wtr [iw=wt] , row

*region
tab hv024 ph_hndwsh_clnsagnt_wtr [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_clnsagnt_wtr [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_clnsagnt_wtr using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//soap and no water for handwashing
*residence
tab hv025 ph_hndwsh_soap_nowtr [iw=wt] , row

*region
tab hv024 ph_hndwsh_soap_nowtr [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_soap_nowtr [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_soap_nowtr using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//cleansing agent and no water for handwashing
*residence
tab hv025 ph_hndwsh_clnsagnt_nowtr [iw=wt] , row

*region
tab hv024 ph_hndwsh_clnsagnt_nowtr [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_clnsagnt_nowtr [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_clnsagnt_nowtr using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//no water, no soap, and no other cleansing agent observed for handwashing
*residence
tab hv025 ph_hndwsh_none [iw=wt] , row

*region
tab hv024 ph_hndwsh_none [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_none [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_none using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
*/

}

**************************************************************************************************
**************************************************************************************************


* indicators from PR file
if file=="PR" {

*open temp file produced by PH_POP.do for population
use PR_temp.dta, clear 

gen wt=hv005/1000000

**************************************************************************************************
* Indicators for household population: excel file Tables_pop will be produced
**************************************************************************************************

* Among urban
//population age distribution 
tab ph_pop_age hv104 if hv025==1 [iw=wt] , col

//Dependency age groups
tab ph_pop_depend hv104 if hv025==1 [iw=wt] , col

//Child and adult population
tab ph_pop_cld_adlt hv104 if hv025==1 [iw=wt] , col

//Adolescent population
tab ph_pop_adols hv104 if hv025==1 [iw=wt] , col

*Among rural
//population age distribution 
tab ph_pop_age hv104 if hv025==2 [iw=wt] , col

//Dependency age groups
tab ph_pop_depend hv104 if hv025==2 [iw=wt] , col

//Child and adult population
tab ph_pop_cld_adlt hv104 if hv025==2 [iw=wt] , col

//Adolescent population
tab ph_pop_adols hv104 if hv025==2 [iw=wt] , col

*Total: urban and rural
//population age distribution 
tab ph_pop_age hv104 [iw=wt] , col

//Dependency age groups
tab ph_pop_depend hv104 [iw=wt] , col

//Child and adult population
tab ph_pop_cld_adlt hv104 [iw=wt] , col

//Adolescent population
tab ph_pop_adols hv104 [iw=wt] , col


*output to excel
*urban
tabout ph_pop_age ph_pop_depend ph_pop_cld_adlt ph_pop_adols hv104 if hv025==1 using Tables_pop.xls [iw=wt] , c(col) f(1) clab(Among_urban) replace 

*rural 
tabout ph_pop_age ph_pop_depend ph_pop_cld_adlt ph_pop_adols hv104 if hv025==2 using Tables_pop.xls [iw=wt] , c(col) f(1) clab(Among_rural) append 

*total
tabout ph_pop_age ph_pop_depend ph_pop_cld_adlt ph_pop_adols hv104 using Tables_pop.xls [iw=wt] , c(col) f(1) clab(Among_total) append
 
**************************************************************************************************
* Indicators for birth registration: excel file Tables_pop will be produced
**************************************************************************************************

*create age variable for children under 5
recode hv105 (0/1=1 " <2") (2/4=2 " 2-4") (else=.) , gen(agec)

//Birth certificate
*Age
tab agec ph_birthreg_cert  [iw=wt] , row
 
*Sex
tab hv104 ph_birthreg_cert  [iw=wt] , row

*Residence
tab hv025 ph_birthreg_cert  [iw=wt] , row

*Region
tab hv024 ph_birthreg_cert  [iw=wt] , row

*Wealth quintiles
tab hv270 ph_birthreg_cert  [iw=wt] , row

*output to excel 
tabout agec hv104 hv025 hv024 hv270 ph_birthreg_cert using Tables_pop.xls [iw=wt] , c(row) f(1) append 
******************************

//Registered birth but no certificate
*Age
tab agec ph_birthreg_nocert  [iw=wt] , row
 
*Sex
tab hv104 ph_birthreg_nocert  [iw=wt] , row

*Residence
tab hv025 ph_birthreg_nocert  [iw=wt] , row

*Region
tab hv024 ph_birthreg_nocert  [iw=wt] , row

*Wealth quintiles
tab hv270 ph_birthreg_nocert  [iw=wt] , row

*output to excel 
tabout agec hv104 hv025 hv024 hv270 ph_birthreg_nocert using Tables_pop.xls [iw=wt] , c(row) f(1) append 
******************************

//Registered birth
*Age
tab agec ph_birthreg  [iw=wt] , row
 
*Sex
tab hv104 ph_birthreg  [iw=wt] , row

*Residence
tab hv025 ph_birthreg  [iw=wt] , row

*Region
tab hv024 ph_birthreg  [iw=wt] , row

*Wealth quintiles
tab hv270 ph_birthreg  [iw=wt] , row

*output to excel 
tabout agec hv104 hv025 hv024 hv270 ph_birthreg using Tables_pop.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
**************************************************************************************************

*open temp file produced by PH_POP.do for children
use PR_temp_children.dta, clear 

gen wt=hv005/1000000

**************************************************************************************************
* Indicators for children living arrangements and orphanhood: excel file Tables_livarg_orph will be produced
**************************************************************************************************

*create age variable for children under 18
recode hv105 (0/1=1 " <2") (2/4=2 " 2-4") (5/9=3 " 5-9") (10/14=4 " 10-14") (15/17=5 " 15-17") , gen(agec)

*Note: if you would like to output these indicators for children under 15, then use the condition if agec<5

//Child living arrangements
*Age
tab agec ph_chld_liv_arrang  [iw=wt] , row
 
*Sex
tab hv104 ph_chld_liv_arrang  [iw=wt] , row

*Residence
tab hv025 ph_chld_liv_arrang  [iw=wt] , row

*Region
tab hv024 ph_chld_liv_arrang  [iw=wt] , row

*Wealth quintiles
tab hv270 ph_chld_liv_arrang  [iw=wt] , row

*output to excel 
tabout agec hv104 hv025 hv024 hv270 ph_chld_liv_arrang using Tables_livarg_orph.xls [iw=wt] , c(row) f(1) replace 
******************************

//Child not living with a biological parent
*Age
tab agec ph_chld_liv_noprnt  [iw=wt] , row
 
*Sex
tab hv104 ph_chld_liv_noprnt  [iw=wt] , row

*Residence
tab hv025 ph_chld_liv_noprnt  [iw=wt] , row

*Region
tab hv024 ph_chld_liv_noprnt  [iw=wt] , row

*Wealth quintiles
tab hv270 ph_chld_liv_noprnt  [iw=wt] , row

*output to excel 
tabout agec hv104 hv025 hv024 hv270 ph_chld_liv_noprnt using Tables_livarg_orph.xls [iw=wt] , c(row) f(1) append 
******************************

//Child with one or both parents dead
*Age
tab agec ph_chld_orph  [iw=wt] , row
 
*Sex
tab hv104 ph_chld_orph  [iw=wt] , row

*Residence
tab hv025 ph_chld_orph  [iw=wt] , row

*Region
tab hv024 ph_chld_orph  [iw=wt] , row

*Wealth quintiles
tab hv270 ph_chld_orph  [iw=wt] , row

*output to excel 
tabout agec hv104 hv025 hv024 hv270 ph_chld_orph using Tables_livarg_orph.xls [iw=wt] , c(row) f(1) append 
******************************

}