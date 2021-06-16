/*****************************************************************************************************
Program: 			CM_tables.do
Purpose: 			produce tables for high risk birth and high risk fertility behavior
Author:				Shireen Assaf
Date last modified: April 30, 2019 by Shireen Assaf 

*This do file will produce the following tables in excel:
1. 	Table_Risk_wm:		Contains the tables of high risk fertility behavior indicators among women
2. 	Table_Risk_birth:	Contains the tables of high risk births indicators
	
Notes: 	The indicators are outputed for women age 15-49 in line 27. This can be commented out if the indicators are required for all women.	
*****************************************************************************************************/

if file=="IR" {
* limiting to women age 15-49
drop if v012<15 | v012>49

gen wt=v005/1000000

**************************************************************************************************
* High risk fertility indicators amoung women 
**************************************************************************************************

tab1	cm_riskw_none cm_riskw_unavoid cm_riskw_any_avoid cm_riskw_u18 cm_riskw_o34 cm_riskw_interval cm_riskw_order ///
cm_riskw_any_single cm_riskw_mult1 cm_riskw_mult2 cm_riskw_mult3 cm_riskw_mult4 cm_riskw_mult5 cm_riskw_any_mult ///
cm_riskw_u18_avoid cm_riskw_o34_avoid cm_riskw_interval_avoid cm_riskw_order_avoid [iw=wt] 

tabout 	cm_riskw_none cm_riskw_unavoid cm_riskw_any_avoid cm_riskw_u18 cm_riskw_o34 cm_riskw_interval cm_riskw_order ///
cm_riskw_any_single cm_riskw_mult1 cm_riskw_mult2 cm_riskw_mult3 cm_riskw_mult4 cm_riskw_mult5 cm_riskw_any_mult ///
cm_riskw_u18_avoid cm_riskw_o34_avoid cm_riskw_interval_avoid cm_riskw_order_avoid using Tables_Risk_wm.xls [iw=wt] , oneway cells(cell) f(1) replace 
}

if file=="KR" {
**************************************************************************************************
* High risk births and risk ratios
**************************************************************************************************
gen wt=v005/1000000

* Percentage of births with risk - among births in the 5 years precedig the survey
tab1 cm_riskb_none cm_riskb_unavoid cm_riskb_any_avoid cm_riskb_u18 cm_riskb_o34 cm_riskb_interval cm_riskb_order ///
cm_riskb_any_single cm_riskb_mult1 cm_riskb_mult2 cm_riskb_mult3 cm_riskb_mult4 cm_riskb_mult5 cm_riskb_any_mult ///
cm_riskb_u18_avoid cm_riskb_o34_avoid cm_riskb_interval_avoid cm_riskb_order_avoid [iw=wt] 

tabout 	cm_riskb_none cm_riskb_unavoid cm_riskb_any_avoid cm_riskb_u18 cm_riskb_o34 cm_riskb_interval cm_riskb_order ///
cm_riskb_any_single cm_riskb_mult1 cm_riskb_mult2 cm_riskb_mult3 cm_riskb_mult4 cm_riskb_mult5 cm_riskb_any_mult ///
cm_riskb_u18_avoid cm_riskb_o34_avoid cm_riskb_interval_avoid cm_riskb_order_avoid using Tables_Risk_births.xls [iw=wt] , oneway cells(cell) f(1) replace 

* Risk ratios - among births in the 5 years precedig the survey
* these are scalars that can be listed using the command below

scalar list _all

/* code below not working because putexcel cannot open the Tables_Risk_births.xls file, i get an error
putexcel set Tables_Risk_births.xls, modify
putexcel	D2=("Risk ratio") D4=(cm_riskb_none_RR) D9=(cm_riskb_unavoid_RR) D14=(cm_riskb_any_avoid_RR) D19=(cm_riskb_u18_RR) ///
			D24=(cm_riskb_o34_RR) D29=(cm_riskb_interval_RR) D34=(cm_riskb_order_RR) D39=(cm_riskb_any_single_RR) ///
			D44=(cm_riskb_mult1_RR) D49=(cm_riskb_mult2_RR) D54=(cm_riskb_mult3_RR) D59=(cm_riskb_mult4_RR) D64=(cm_riskb_mult5_RR) ///
			D69=(cm_riskb_any_mult_RR) D74=(cm_riskb_u18_avoid_RR) D79=(cm_riskb_o34_avoid_RR) D84=(cm_riskb_interval_avoid_RR) D89=(cm_riskb_order_avoid_RR) 
*/
}
