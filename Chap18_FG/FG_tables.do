/*****************************************************************************************************
Program: 			FG_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: October 23, 2020 by Shireen Assaf 

*Note this do file will produce the following tables in excel:
	1. 	Tables_Know:		Contains the tables for heard of female circumcision among women and men 
	2. 	Tables_Circum_wm:	Contains the tables for female circumcision prevalence, type, age of circumcision, and who performed the circumcision
	3.	Tables_Opinion:		Contains the tables for opinions related to female circumcision among women and men 


Notes: 	Tables_Circum_gl that show the indicators of female circumcision among girls 0-14 is produced in the FG_GIRLS.do file

		We select for the age groups 15-49 for both men and women. If you want older ages in men please change this selection in the code below (line 191). Most surveys for women are only for 15-49, but a few surveys have older surveys so this selection can be necessary (line 27). 
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file
if file=="IR" {

gen wt=v005/1000000

*select age group
drop if v012<15 | v012>49

**************************************************************************************************
//Heard of female circumcision

*age
tab v013 fg_heard [iw=wt], row nofreq 

*residence
tab v025 fg_heard [iw=wt], row nofreq 

*region
tab v024 fg_heard [iw=wt], row nofreq 

*education
tab v106 fg_heard [iw=wt], row nofreq 

*wealth
tab v190 fg_heard [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fg_heard using Tables_Know.xls [iw=wt] , clab(Among_women) c(row) f(1) replace 
*/

**************************************************************************************************
* Indicators for prevalence of female circumcision
**************************************************************************************************

//Circumcised women

*age
tab v013 fg_fcircum_wm [iw=wt], row nofreq 

*residence
tab v025 fg_fcircum_wm [iw=wt], row nofreq 

*region
tab v024 fg_fcircum_wm [iw=wt], row nofreq 

*education
tab v106 fg_fcircum_wm [iw=wt], row nofreq 

*wealth
tab v190 fg_fcircum_wm [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fg_fcircum_wm using Tables_Circum_wm.xls [iw=wt] , c(row) f(1) replace 

*/
****************************************************
//Type of circumcision

*age
tab v013 fg_type_wm [iw=wt], row nofreq 

*residence
tab v025 fg_type_wm [iw=wt], row nofreq 

*region
tab v024 fg_type_wm [iw=wt], row nofreq 

*education
tab v106 fg_type_wm [iw=wt], row nofreq 

*wealth
tab v190 fg_type_wm [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fg_type_wm using Tables_Circum_wm.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Age at circumcision

*age
tab v013 fg_age_wm [iw=wt], row nofreq 

*residence
tab v025 fg_age_wm [iw=wt], row nofreq 

*region
tab v024 fg_age_wm [iw=wt], row nofreq 

*education
tab v106 fg_age_wm [iw=wt], row nofreq 

*wealth
tab v190 fg_age_wm [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fg_age_wm using Tables_Circum_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Person performing the circumcision among women age 15-49

* output to excel
tabout  fg_who_wm using Tables_Circum_wm.xls [iw=wt], oneway c(cell) f(1) append 
*/
****************************************************
//Sewn close

* output to excel
tabout fg_sewn_wm using Tables_Circum_wm.xls [iw=wt], oneway c(cell) f(1) append 
*/

**************************************************************************************************
* Indicators for opinions related to female circumcision
**************************************************************************************************
//Opinion on whether female circumcision is required by their religion

* female circumcision status
tab fg_fcircum_wm fg_relig [iw=wt], row nofreq 

*age
tab v013 fg_relig [iw=wt], row nofreq 

*residence
tab v025 fg_relig [iw=wt], row nofreq 

*region
tab v024 fg_relig [iw=wt], row nofreq 

*education
tab v106 fg_relig [iw=wt], row nofreq 

*wealth
tab v190 fg_relig [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fg_relig using Tables_Opinion.xls [iw=wt] , clab(Among_women) c(row) f(1) replace 
****************************************************
//Opinion on whether female circumcision should continue

* female circumcision status
tab fg_fcircum_wm fg_cont [iw=wt], row nofreq 

*age
tab v013 fg_cont [iw=wt], row nofreq 

*residence
tab v025 fg_cont [iw=wt], row nofreq 

*region
tab v024 fg_cont [iw=wt], row nofreq 

*education
tab v106 fg_cont [iw=wt], row nofreq 

*wealth
tab v190 fg_cont [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 fg_cont using Tables_Opinion.xls [iw=wt] , clab(Among_women) c(row) f(1) append 
*/
}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {

gen wt=mv005/1000000

*select age group
drop if mv012<15 | mv012>49

****************************************************************************
//Heard of female circumcision

*age
tab mv013 fg_heard [iw=wt], row nofreq 

*residence
tab mv025 fg_heard [iw=wt], row nofreq 

*region
tab mv024 fg_heard [iw=wt], row nofreq 

*education
tab mv106 fg_heard [iw=wt], row nofreq 

*wealth
tab mv190 fg_heard [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fg_heard using Tables_Know.xls [iw=wt] , clab(Among_men) c(row) f(1) append 
**************************************************************************************************
* Indicators for opinions related to female circumcision
**************************************************************************************************
//Opinion on whether female circumcision is required by their religion

*age
tab mv013 fg_relig [iw=wt], row nofreq 

*residence
tab mv025 fg_relig [iw=wt], row nofreq 

*region
tab mv024 fg_relig [iw=wt], row nofreq 

*education
tab mv106 fg_relig [iw=wt], row nofreq 

*wealth
tab mv190 fg_relig [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fg_relig using Tables_Opinion.xls [iw=wt] , clab(Among_men) c(row) f(1) append 
****************************************************
//Opinion on whether female circumcision should continue

*age
tab mv013 fg_cont [iw=wt], row nofreq 

*residence
tab mv025 fg_cont [iw=wt], row nofreq 

*region
tab mv024 fg_cont [iw=wt], row nofreq 

*education
tab mv106 fg_cont [iw=wt], row nofreq 

*wealth
tab mv190 fg_cont [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 fg_cont using Tables_Opinion.xls [iw=wt] , clab(Among_men) c(row) f(1) append 
*/

}

