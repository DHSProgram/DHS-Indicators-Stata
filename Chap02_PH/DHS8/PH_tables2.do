/*****************************************************************************************************
Program: 			PH_tables2.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: May 1 2020 by Shireen Assaf 

*This do file will produce the following tables in excel:
1. 	Tables_pop:				Contains the tables for the household population by age, sex, and residence and birth registration
2.	Tables_livarg_orph:		Contains the table for children's living arrangements and orphanhood

Notes: 					 						
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************


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
* Indicators for wealth quintile and education: excel file Tables_pop will be produced
**************************************************************************************************

//Wealth quintile
* residence
ta hv025 ph_wealth_quint [iw=wt], row

* region
ta hv024 ph_wealth_quint [iw=wt], row

*output to excel 
tabout hv025 hv024 ph_wealth_quint using Tables_pop.xls [iw=wt] , c(row) f(1) append 

//Education - Females
* age
ta ph_pop_age ph_highest_edu if hv104==2 [iw=wt], row

* residence
ta hv025 ph_highest_edu if hv104==2 [iw=wt], row

* region
ta hv024 ph_highest_edu if hv104==2 [iw=wt], row

*output to excel 
tabout ph_pop_age hv025 hv024 ph_highest_edu  if hv104==2 using Tables_pop.xls [iw=wt] , c(row) clab(Females) f(1) append 

//Median years of education - Females
tab ph_median_eduyrs_wm

*output to excel 
tabout ph_median_eduyrs_wm using Tables_pop.xls [iw=wt] , oneway cells(cell) append 

//Education - Males
* age
ta ph_pop_age ph_highest_edu if hv104==1 [iw=wt], row

* residence
ta hv025 ph_highest_edu if hv104==1 [iw=wt], row

* region
ta hv024 ph_highest_edu if hv104==1 [iw=wt], row

*output to excel 
tabout ph_pop_age hv025 hv024 ph_highest_edu if hv104==1 using Tables_pop.xls [iw=wt] , c(row) clab(Males) f(1) append 

//Median years of education - Females
tab ph_median_eduyrs_mn

*output to excel 
tabout ph_median_eduyrs_mn using Tables_pop.xls [iw=wt] , oneway cells(cell) append 

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

