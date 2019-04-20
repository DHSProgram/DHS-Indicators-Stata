/*****************************************************************************************************
Program: 			CH_SIZE.do
Purpose: 			Code vaccination variables.
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: March 12 2019 by Shireen Assaf 
Notes:				Estimates can be created for two age groups (12-23) and (24-35). Please choose the age group of interest in line 78
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_bcg_card			"BCG vaccination according to card"
ch_bcg_moth			"BCG vaccination according to mother"
ch_bcg_either		"BCG vaccination according to either source"
ch_bcg_by12			"BCG vaccination by age 12 months"
ch_pent1_card		"Pentavalent 1st dose vaccination according to card"
ch_pent1_moth		"Pentavalent 1st dose vaccination according to mother"
ch_pent1_either		"Pentavalent 1st dose vaccination according to either source"
ch_pent1_by12		"Pentavalent 1st dose vaccination by age 12 months"
ch_pent2_card		"Pentavalent 2nd dose vaccination according to card"
ch_pent2_moth		"Pentavalent 2nd dose vaccination according to mother"
ch_pent2_either		"Pentavalent 2nd dose vaccination according to either source"
ch_pent2_by12		"Pentavalent 2nd dose vaccination by age 12 months"
ch_pent3_card		"Pentavalent 3rd dose vaccination according to card"
ch_pent3_moth		"Pentavalent 3rd dose vaccination according to mother"
ch_pent3_either		"Pentavalent 3rd dose vaccination according to either source"
ch_pent3_by12		"Pentavalent 3rd dose vaccination by age 12 months"
ch_polio1_card		"Polio 1st dose vaccination according to card"
ch_polio1_moth		"Polio 1st dose vaccination according to mother"
ch_polio1_either	"Polio 1st dose vaccination according to either source"
ch_polio1_by12		"Polio 1st dose vaccination by age 12 months"
ch_polio2_card		"Polio 2nd dose vaccination according to card"
ch_polio2_moth		"Polio 2nd dose vaccination according to mother"
ch_polio2_either	"Polio 2nd dose vaccination according to either source"
ch_polio2_by12		"Polio 2nd dose vaccination by age 12 months"
ch_polio3_card		"Polio 3rd dose vaccination according to card"
ch_polio3_moth		"Polio 3rd dose vaccination according to mother"
ch_polio3_either	"Polio 3rd dose vaccination according to either source"
ch_polio3_by12		"Polio 3rd dose vaccination by age 12 months"
ch_meas_card		"Measles vaccination according to card"
ch_meas_moth		"Measles vaccination according to mother"
ch_meas_either		"Measles vaccination according to either source"
ch_meas_by12		"Measles vaccination by age 12 months"
ch_allvac_card		"All basic vaccinations according to card"
ch_allvac_moth		"All basic vaccinations according to mother"
ch_allvac_either	"All basic vaccinations according to either source"
ch_allvac_by12		"All basic vaccinations by age 12 months"
ch_novac_card		"No vaccinations according to card"
ch_novac_moth		"No vaccinations according to mother"
ch_novac_either		"No vaccinations according to either source"
ch_novac_by12		"No vaccinations by age 12 months"
----------------------------------------------------------------------------*/

*** Child's age
gen age = v008 - b3
	
	* to check if survey has b19, which should be used instead to compute age. 
	scalar b19_included=1
		capture confirm numeric variable b19, exact 
		if _rc>0 {
		* b19 is not present
		scalar b19_included=0
		}
		if _rc==0 {
		* b19 is present; check for values
		summarize b19
		  if r(sd)==0 | r(sd)==. {
		  scalar b19_included=0
		  }
		}

	if b19_included==1 {
	drop age
	gen age=b19
	}
	
*** Two age groups used for reporting. 
	* choose age group of interest	
	*
	gen agegroup=0
	replace agegroup=1 if age>=12 & age<=23
	*/

	/*
	gen agegroup=0
	replace agegroup=1 if age>=24 & age<=35
	*/

*******************************************************************************

//BCG either source
gen ch_bcg_either=0
replace ch_bcg_either=1 if h2>0 & h2<8
replace ch_bcg_either = . if agegroup==0 | b5==0

//BCG by card
gen ch_bcg_card=0
replace ch_bcg_card=1 if (h2==1|h2==3) & h1==1
replace ch_bcg_card = . if agegroup==0 | b5==0

//BCG mother's report
gen ch_bcg_moth=0
replace ch_bcg_moth=1 if h2==2 & h1!=1
replace ch_bcg_moth = . if agegroup==0 | b5==0
