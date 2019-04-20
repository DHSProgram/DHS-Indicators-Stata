/*****************************************************************************************************
Program: 			FP_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: Feb 5 2019 by Shireen Assaf 

*Note this do file will produce the following tables in excel:
	1. 	Tables_Know_wm:		Contains the tables for knowledge indicators for women
	2. 	Tables_Know_mn:		Contains the tables for knowledge indicators for men
	3. 	Tables_Use_ev:		Contains the tables for ever use of family planning for women
	4. 	Tables_Use_cr:		Contains the tables for current use of family planning for women + timing of sterlization
	5.	Tables_source_info:	Contains the tables for source of family planning method, brands used, and information given about the method for women
	not done 6.	Tables_Discont:		Contains the tables for discontinuation rates and reason for discontinuation for women
	7.	Tables_Need:		Contains the tables for unmet need, met need, demand satisfied, and future intention to use for women
	8.	Tables_Communicat:	Contains the tables for exposure to FP messages, decision on use/nonuse, discussions for women
	9.  Tables_message_mn:	Contains the tables for exposure for FP messages for men


Notes: 					For knowledge of contraceptive methods, ever use, current use, and unmet need variables, the population of
						interest can be selected (all women, currently married women, and sexually active women).
						The reminaing indicators are reported for currently married women.
						
						For men, the population of interest can also be selected for the knowledge of methods variables. 
						
						Make the secltion of the population of interest below for IR and MR files. 
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file
if file=="KR" {
gen wt=v005/1000000

**************************************************************************************************
* Indicators for knowleldege of contraceptive methods: excel file Tables_Know_wm will be produced
**************************************************************************************************
//Knowledge of each method

tab1	fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp ///
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy ///
		fp_know_wthd fp_know_other fp_know_mean if select==1 [iw=wt] 

* output to excel
tabout 	fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp ///
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy ///
		fp_know_wthd fp_know_other fp_know_mean if select==1 using Tables_Know_wm.xls [iw=wt] , oneway cells(cell) f(1) replace 
*/
****************************************************
//Knowledge of any method by background variables

*age
tab v013 fp_know_any if select==1 [iw=wt], row nofreq 

*residence
tab v025 fp_know_any if select==1 [iw=wt], row nofreq 

*region
tab v024 fp_know_any if select==1 [iw=wt], row nofreq 

*education
tab v106 fp_know_any if select==1 [iw=wt], row nofreq 

*wealth
tab v190 fp_know_any if select==1 [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fp_know_any if select==1 using Tables_Know_wm.xls [iw=wt] , c(row) f(1) append 
*/


}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="IR" {

gen wt=v005/1000000

	
**************************************************************************************************
* Indicators for knowleldege of contraceptive methods: excel file Tables_Know_mn will be produced
**************************************************************************************************
//Knowledge of each method

* selected men 15-49

tab1	fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp ///
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy ///
		fp_know_wthd fp_know_other fp_know_mean if select==1 & mv013<8 [iw=wt] 

* output to excel
tabout 	fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp ///
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy ///
		fp_know_wthd fp_know_other fp_know_mean if select==1 & mv013<8 using Tables_Know_mn.xls [iw=wt] , oneway cells(cell) f(1) replace 
*/
****************************************************
//Knowledge of any method by background variables

*age
tab mv013 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

*residence
tab mv025 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

*region
tab mv024 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

*education
tab mv106 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

*wealth
tab mv190 fp_know_any if select==1 & mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fp_know_any if select==1 & mv013<8 using Tables_Know_mn.xls [iw=wt] , c(row) f(1) append 
*/
}

