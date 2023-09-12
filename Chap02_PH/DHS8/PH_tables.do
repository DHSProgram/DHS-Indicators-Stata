/*****************************************************************************************************
Program: 			PH_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: September 4, 2020 by Courtney Allen 

*This do file will produce the following tables in excel:
1. 	Tables_hh_wash:			Contains the table for WASH (water and santitation) indicators
2.  Tables_hh_charac:		Contains the table for household characteristics
3. 	Tables_hh_poss:			Contains the table for household possessions
4.	Tables_handwsh:			Contains the table for handwashing indicators

Notes: 					 						
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from HR file
if file=="HR" {

gen wt=hv005/1000000

**************************************************************************************************
* Indicators for WASH indicators: excel file Tables_hh_WASH will be produced
**************************************************************************************************
* all WASH characteristics are crosstabulated by place of residence

*type of water source
	tab ph_wtr_source hv025 [iw=wt] , col

*improved drinking water source
	tab ph_wtr_improve hv025 [iw=wt] , col

*round trip time to obtaining water
	tab ph_wtr_time hv025 [iw=wt] , col

*basic or limited water service
	tab ph_wtr_basic hv025 [iw=wt] , col

*availability of water among those using piped water 
	tab ph_wtr_avail hv025 [iw=wt] , col

*treatment of water: boil
	tab ph_wtr_trt_boil hv025 [iw=wt] , col
	
*treatment of water: bleach or chlorine
	tab ph_wtr_trt_chlor hv025 [iw=wt] , col
	
*treatment of water: straining through cloth
	tab ph_wtr_trt_cloth	hv025 [iw=wt] , col
	
*treatment of water: ceramic, sand or other filter
	tab ph_wtr_trt_filt hv025 [iw=wt] , col
	
*treatment of water: solar disinfection
	tab ph_wtr_trt_solar hv025 [iw=wt] , col
	
*treatment of water: letting stand and settle	
	tab ph_wtr_trt_stand hv025 [iw=wt] , col	

*treatment of water: other
	tab ph_wtr_trt_other hv025 [iw=wt] , col
	
*treatment of water: no treatment	
	tab ph_wtr_trt_none hv025 [iw=wt] , col	
	
*treatment of water: appropriate treatment	
	tab ph_wtr_trt_appr hv025 [iw=wt] , col	
	
*type of sanitation 
	tab ph_sani_type hv025 [iw=wt] , col

*improved sanitation
	tab ph_sani_improve hv025 [iw=wt] , col

*basic or limited sanitation
	tab ph_sani_basic hv025 [iw=wt] , col

*location of sanitation facility
	tab ph_sani_location hv025 [iw=wt] , col


* output to excel
tabout 	ph_wtr_source ph_wtr_improve ph_wtr_time ph_wtr_basic ph_wtr_avail ///
		ph_wtr_trt_boil ph_wtr_trt_chlor ph_wtr_trt_cloth ph_wtr_trt_filt   ///
		ph_wtr_trt_solar ph_wtr_trt_stand ph_wtr_trt_other ph_wtr_trt_none ///
		ph_wtr_trt_appr ph_sani_type ph_sani_improve ph_sani_location ph_sani_basic ///
		hv025 using Tables_hh_wash.xls [iw=wt] , c(col) f(1) replace 
*/


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

*cooking tech
tab ph_cook_tech hv025 [iw=wt] , col

*cooking fuel
tab ph_cook_fuel hv025 [iw=wt] , col

*clean or solid fuel for cooking
tab ph_cook_clean hv025 [iw=wt] , col

*heating tech
tab ph_heat_tech hv025 [iw=wt] , col

*heating fuel
tab ph_heat_fuel hv025 [iw=wt] , col

*frequency of smoking in the home
tab ph_smoke hv025 [iw=wt] , col

* output to excel
tabout 	ph_electric ph_floor ph_rooms_sleep ph_cook_place ph_cook_fuel 	///
		ph_cook_solid ph_cook_clean ph_smoke hv025 using Tables_hh_charac.xls [iw=wt] , c(col) f(1) replace 
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
tabout 	ph_radio ph_tv ph_mobile ph_tel ph_comp ph_frig ph_bike ph_cart	///
		ph_moto ph_car ph_boat ph_agriland ph_animals hv025 using Tables_hh_poss.xls [iw=wt] , c(col) f(1) replace 
*/



}

**************************************************************************************************
**************************************************************************************************


* indicators from PR file
if file=="PR" {

cap gen wt=hv005/1000000

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
tab hv025 ph_hndwsh_place_any [iw=wt] , row

*region
tab hv024 ph_hndwsh_place_any [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_place_any [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_place_any using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//water for handwashing
*residence
tab hv025 ph_hndwsh_water [iw=wt] , row

*region
tab hv024 ph_hndwsh_water [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_water [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_water using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//soap for handwashing
*residence
tab hv025 ph_hndwsh_soap [iw=wt] , row

*region
tab hv024 ph_hndwsh_soap [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_soap [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_soap using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//cleansing agent for handwashing
*residence
tab hv025 ph_hndwsh_clnsagnt [iw=wt] , row

*region
tab hv024 ph_hndwsh_clnsagnt [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_clnsagnt [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_clnsagnt using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//basic handwashing facility
*residence
tab hv025 ph_hndwsh_basic [iw=wt] , row

*region
tab hv024 ph_hndwsh_basic [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_basic [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_basic using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 
********************

//limited handwashing facility
*residence
tab hv025 ph_hndwsh_limited [iw=wt] , row

*region
tab hv024 ph_hndwsh_limited [iw=wt] , row

*wealth quintiles
tab hv270 ph_hndwsh_limited [iw=wt] , row

* output to excel
tabout hv025 hv024 hv270 ph_hndwsh_limited using Tables_handwsh.xls [iw=wt] , c(row) f(1) append 

*/
**************************************************************************************************
}

