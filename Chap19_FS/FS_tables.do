/*****************************************************************************************************
Program: 			FS_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: November 5, 2020 by Shireen Assaf 

*This do file will produce the following table in excel:
Tables_FIST: Contains the tables for fistula indicators

Notes: 	The indicators are outputed for women age 15-49 in line 17. This can be commented out if the indicators are required for all women.	
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************
*select age group
drop if v012<15 | v012>49

gen wt=v005/1000000

**************************************************************************************************
//Heard of fistula

*age
tab v013 fs_heard [iw=wt], row nofreq 

*residence
tab v025 fs_heard [iw=wt], row nofreq 

*region
tab v024 fs_heard [iw=wt], row nofreq 

*education
tab v106 fs_heard [iw=wt], row nofreq 

*wealth
tab v190 fs_heard [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fs_heard using Tables_FIST.xls [iw=wt] ,  c(row) f(1) replace 
*/

*************************************************************************************************
//Ever experienced fistula

*age
tab v013 fs_ever_exp [iw=wt], row nofreq 

*residence
tab v025 fs_ever_exp [iw=wt], row nofreq 

*region
tab v024 fs_ever_exp [iw=wt], row nofreq 

*education
tab v106 fs_ever_exp [iw=wt], row nofreq 

*wealth
tab v190 fs_ever_exp [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fs_ever_exp using Tables_FIST.xls [iw=wt] ,  c(row) f(1) append 
*/
*************************************************************************************************
//Reported cause of fistula

tab fs_cause [iw=wt], nofreq 

* output to excel
tabout fs_cause using Tables_FIST.xls [iw=wt] , oneway c(cell) f(1) append 


//Reported number of days since symptoms began
tab fs_days_symp [iw=wt], nofreq 

* output to excel
tabout fs_days_symp using Tables_FIST.xls [iw=wt] , oneway c(cell) f(1) append 
*/
*************************************************************************************************

//Provider type for fistula treatment

*residence
tab v025 fs_trt_provid [iw=wt], row nofreq 

*education
tab v106 fs_trt_provid [iw=wt], row nofreq 

*wealth
tab v190 fs_trt_provid [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v190 fs_trt_provid using Tables_FIST.xls [iw=wt] ,  c(row) f(1) append 
*/
*************************************************************************************************

//Outcome of treatment sought for fistula

*residence
tab v025 fs_trt_outcome [iw=wt], row nofreq 

*education
tab v106 fs_trt_outcome [iw=wt], row nofreq 

*wealth
tab v190 fs_trt_outcome [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v190 fs_trt_outcome using Tables_FIST.xls [iw=wt] ,  c(row) f(1) append 

//Had operation for fistula

*residence
tab v025 fs_trt_operat [iw=wt], row nofreq 

*education
tab v106 fs_trt_operat [iw=wt], row nofreq 

*wealth
tab v190 fs_trt_operat [iw=wt], row nofreq 

* output to excel
tabout v025 v106 v190 fs_trt_operat using Tables_FIST.xls [iw=wt] ,  c(row) f(1) append 
*/
*************************************************************************************************
//Reason for not seeking treatment

tab fs_notrt_reason [iw=wt], nofreq 

* output to excel
tabout fs_notrt_reason using Tables_FIST.xls [iw=wt] , oneway c(cell) f(1) append 
*/
*************************************************************************************************