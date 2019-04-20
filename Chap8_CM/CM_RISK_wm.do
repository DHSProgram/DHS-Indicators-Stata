/*****************************************************************************************************
Program: 			CM_RISK_wm.do
Purpose: 			Code to compute high risk birth in women
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and Thomas Pullum
Date last modified: April 19 2019 by Shireen Assaf 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
cm_riskw_none		"Women not in any high-risk category"
cm_riskw_u18		"Women under age 18 (17yrs and 3 mos)"
cm_riskw_o34		"Women over age 34 (34yrs and 2mos)"
cm_riskw_interval	"Women with birth <15mos ago"
cm_riskw_order		"Women with latest birth being 3rd order or higher"
cm_riskw_unavoid	"Women with unavoidable risk - never given birth and age 17yrs 3mos to 34yrs 2mos"
	
cm_riskw_mult1		"Women with mult. risks - under age 18, and high order"
cm_riskw_mult2		"Women with mult. risks - under age 18, and short interval"
cm_riskw_mult3		"Women with mult. risks - over age 34, and short interval"
cm_riskw_mult4		"Women with mult. risks - over age 34, and high order"
cm_riskw_mult5		"Women with mult. risks - over age 34, and short interval and high order"
cm_riskw_mult6		"Women with mult. risks - short interval and high order"
----------------------------------------------------------------------------*/
