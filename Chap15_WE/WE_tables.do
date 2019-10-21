/*****************************************************************************************************
Program: 			WE_tables.do
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: October 17 2019 by Shireen Assaf 

*Note this do file will produce the following tables in excel:
	1. 	Tables_emply_wm:	Contains the tables for employment and earning indicators for women
	2.	Tables_emply_mn:	Contains the tables for employment and earning indicators for men
	3. 	Tables_assets_wm:	Contains the tables for asset ownwership indicators for women
	4.	Tables_assets_mn:	Contains the tables for asset ownwership indicators for men
	5. 	Tables_empw_wm:		Contains the tables for empowerment indicators, justification of wife beating, and decision making for women
	6.	Tables_empw_mn:		Contains the tables for empowerment indicators, justification of wife beating, and decision making for men

Notes:	Please see note on line 730 for constructing addition tables for the empowerment indicators
		For men, the tables are produced according to the age group identified in the WE_ASSETS and the WE_EMPW do files. Currently it is for men 15-49 by default. 
		This can be changed in the do files that constuct the indicators. 
		
		Please check note on line 720 and 723. Only the first column for the first crosstabulation and the last column for the second crosstabulation are reported in the final report. 
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file
if file=="IR" {
gen wt=v005/1000000

* Number of living children
recode v218 (0=0 " 0") (1/2=1 " 1-2") (3/4=2 " 3-4") (5/max=3 "5+") (99 . =.), gen(numch)
replace numch=. if v218==.
label var numch "number of living children"
**************************************************************************************************
* Employment and earnings
**************************************************************************************************
//Employment in the last 12 months
*age
tab v013 we_empl [iw=wt], row

* output to excel
tabout v013 we_empl using Tables_emply_wm.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Employment by type of earnings
*age
tab v013 we_empl_earn [iw=wt], row

* output to excel
tabout v013 we_empl_earn using Tables_emply_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decision on wife's cash earnings
*age
tab v013 we_earn_wm_decide [iw=wt], row nofreq 

*number of living children
tab numch we_earn_wm_decide [iw=wt], row nofreq 

*residence
tab v025 we_earn_wm_decide [iw=wt], row nofreq 

*region
tab v024 we_earn_wm_decide [iw=wt], row nofreq 

*education
tab v106 we_earn_wm_decide [iw=wt], row nofreq 

*wealth
tab v190 we_earn_wm_decide [iw=wt], row nofreq 

* output to excel
tabout v013 numch v025 v106 v024 v190 we_earn_wm_decide using Tables_emply_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Comparison of wife's cash earnings with husband
*age
tab v013 we_earn_wm_compare [iw=wt], row nofreq 

*number of living children
tab numch we_earn_wm_compare [iw=wt], row nofreq 

*residence
tab v025 we_earn_wm_compare [iw=wt], row nofreq 

*region
tab v024 we_earn_wm_compare [iw=wt], row nofreq 

*education
tab v106 we_earn_wm_compare [iw=wt], row nofreq 

*wealth
tab v190 we_earn_wm_compare [iw=wt], row nofreq 

* output to excel
tabout v013 numch v025 v106 v024 v190 we_earn_wm_compare using Tables_emply_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decision on husbands's cash earnings
*age
tab v013 we_earn_hs_decide [iw=wt], row nofreq 

*number of living children
tab numch we_earn_hs_decide [iw=wt], row nofreq 

*residence
tab v025 we_earn_hs_decide [iw=wt], row nofreq 

*region
tab v024 we_earn_hs_decide [iw=wt], row nofreq 

*education
tab v106 we_earn_hs_decide [iw=wt], row nofreq 

*wealth
tab v190 we_earn_hs_decide [iw=wt], row nofreq 

* output to excel
tabout v013 numch v025 v106 v024 v190 we_earn_hs_decide using Tables_emply_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decision on wife's cash earnings by comparison of wife to husband's earnings
tab we_earn_wm_compare we_earn_wm_decide [iw=wt], row

* output to excel
tabout we_earn_wm_compare we_earn_wm_decide using Tables_emply_wm.xls [iw=wt] , c(row) f(1) append 

//Decision on husband's cash earnings by comparison of wife to husband's earnings
gen we_earn_wm_compare2=we_earn_wm_compare
replace we_earn_wm_compare2=5 if (we_empl_earn==0 | we_empl_earn==3) 
replace we_earn_wm_compare2=6 if we_empl==0 
label define we_earn_wm_compare2 1"More than husband" 2"Less than husband" 3"Same as husband" 4"Husband has no cash earnings or not working" ///
5"Woman worked but has no cash earnings" 6"Woman did not work" 8"Don't know/missing"

label values we_earn_wm_compare2 we_earn_wm_compare2

tab we_earn_wm_compare2 we_earn_hs_decide [iw=wt], row

* output to excel
tabout we_earn_wm_compare2 we_earn_hs_decide using Tables_emply_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Ownership of assets
**************************************************************************************************
//Own a house
*age
tab v013 we_own_house [iw=wt], row nofreq 

*residence
tab v025 we_own_house [iw=wt], row nofreq 

*region
tab v024 we_own_house [iw=wt], row nofreq 

*education
tab v106 we_own_house [iw=wt], row nofreq 

*wealth
tab v190 we_own_house [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 we_own_house using Tables_assets_wm.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Own land
*age
tab v013 we_own_land [iw=wt], row nofreq 

*residence
tab v025 we_own_land [iw=wt], row nofreq 

*region
tab v024 we_own_land [iw=wt], row nofreq 

*education
tab v106 we_own_land [iw=wt], row nofreq 

*wealth
tab v190 we_own_land [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 we_own_land using Tables_assets_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Title or deed ownwership for house
*age
tab v013 we_house_deed [iw=wt], row nofreq 

*residence
tab v025 we_house_deed [iw=wt], row nofreq 

*region
tab v024 we_house_deed [iw=wt], row nofreq 

*education
tab v106 we_house_deed [iw=wt], row nofreq 

*wealth
tab v190 we_house_deed [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 we_house_deed using Tables_assets_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Title or deed ownwership for land
*age
tab v013 we_land_deed [iw=wt], row nofreq 

*residence
tab v025 we_land_deed [iw=wt], row nofreq 

*region
tab v024 we_land_deed [iw=wt], row nofreq 

*education
tab v106 we_land_deed [iw=wt], row nofreq 

*wealth
tab v190 we_land_deed [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 we_land_deed using Tables_assets_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Have a bank account
*age
tab v013 we_bank [iw=wt], row nofreq 

*residence
tab v025 we_bank [iw=wt], row nofreq 

*region
tab v024 we_bank [iw=wt], row nofreq 

*education
tab v106 we_bank [iw=wt], row nofreq 

*wealth
tab v190 we_bank [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 we_bank using Tables_assets_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Have a mobile phone
*age
tab v013 we_mobile [iw=wt], row nofreq 

*residence
tab v025 we_mobile [iw=wt], row nofreq 

*region
tab v024 we_mobile [iw=wt], row nofreq 

*education
tab v106 we_mobile [iw=wt], row nofreq 

*wealth
tab v190 we_mobile [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 we_mobile using Tables_assets_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Use mobile phone for financial transactions
*age
tab v013 we_mobile_finance [iw=wt], row nofreq 

*residence
tab v025 we_mobile_finance [iw=wt], row nofreq 

*region
tab v024 we_mobile_finance [iw=wt], row nofreq 

*education
tab v106 we_mobile_finance [iw=wt], row nofreq 

*wealth
tab v190 we_mobile_finance [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 we_mobile_finance using Tables_assets_wm.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Decision making indicators
**************************************************************************************************
//Decision making indicators

*on health, household purchases, and visits
tab1 we_decide_health we_decide_hhpurch we_decide_visits [iw=wt]

* output to excel
tabout we_decide_health we_decide_hhpurch we_decide_visits using Tables_empw_wm.xls [iw=wt] , oneway cells(cell) replace 

****************************************************
*Employment by earning 
gen emply=.
replace emply=0 if v731==0
replace emply=1 if v731>0 & v731<8 & (v741==1 | v741==2)
replace emply=2 if v731>0 & v731<8 & (v741==0 | v741==3)
label define emply 0"Not employed" 1"Employed for cash" 2"Employed not for cash"
label values emply emply
label var emply "Employment in the last 12 months"

//Decide on own health care either alone or jointly with partner
*age
tab v013 we_decide_health_self [iw=wt], row nofreq 

*employment by earning
tab emply we_decide_health_self [iw=wt], row nofreq 

*number of children
tab numch we_decide_health_self [iw=wt], row nofreq 

*residence
tab v025 we_decide_health_self [iw=wt], row nofreq 

*region
tab v024 we_decide_health_self [iw=wt], row nofreq 

*education
tab v106 we_decide_health_self [iw=wt], row nofreq 

*wealth
tab v190 we_decide_health_self [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v025 v106 v024 v190 we_decide_health_self using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decide on household purchases either alone or jointly with partner
*age
tab v013 we_decide_hhpurch_self [iw=wt], row nofreq 

*employment by earning
tab emply we_decide_hhpurch_self [iw=wt], row nofreq 

*number of children
tab numch we_decide_hhpurch_self [iw=wt], row nofreq 

*residence
tab v025 we_decide_hhpurch_self [iw=wt], row nofreq 

*region
tab v024 we_decide_hhpurch_self [iw=wt], row nofreq 

*education
tab v106 we_decide_hhpurch_self [iw=wt], row nofreq 

*wealth
tab v190 we_decide_hhpurch_self [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v025 v106 v024 v190 we_decide_hhpurch_self using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decide on visits either alone or jointly with partner
*age
tab v013 we_decide_visits_self [iw=wt], row nofreq 

*employment by earning
tab emply we_decide_visits_self [iw=wt], row nofreq 

*number of children
tab numch we_decide_visits_self [iw=wt], row nofreq 

*residence
tab v025 we_decide_visits_self [iw=wt], row nofreq 

*region
tab v024 we_decide_visits_self [iw=wt], row nofreq 

*education
tab v106 we_decide_visits_self [iw=wt], row nofreq 

*wealth
tab v190 we_decide_visits_self [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v025 v106 v024 v190 we_decide_visits_self using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decide on all three: health, purchases, and visits
*age
tab v013 we_decide_all [iw=wt], row nofreq 

*employment by earning
tab emply we_decide_all [iw=wt], row nofreq 

*number of children
tab numch we_decide_all [iw=wt], row nofreq 

*residence
tab v025 we_decide_all [iw=wt], row nofreq 

*region
tab v024 we_decide_all [iw=wt], row nofreq 

*education
tab v106 we_decide_all [iw=wt], row nofreq 

*wealth
tab v190 we_decide_all [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v025 v106 v024 v190 we_decide_all using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decide on none of three
*age
tab v013 we_decide_none [iw=wt], row nofreq 

*employment by earning
tab emply we_decide_none [iw=wt], row nofreq 

*number of children
tab numch we_decide_none [iw=wt], row nofreq 

*residence
tab v025 we_decide_none [iw=wt], row nofreq 

*region
tab v024 we_decide_none [iw=wt], row nofreq 

*education
tab v106 we_decide_none [iw=wt], row nofreq 

*wealth
tab v190 we_decide_none [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v025 v106 v024 v190 we_decide_none using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Justification of violence
**************************************************************************************************
//Justify wife beating if burns food
*age
tab v013 we_dvjustify_burn [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_burn [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_burn [iw=wt], row nofreq 

*marital status
tab v502 we_dvjustify_burn [iw=wt], row nofreq 

*residence
tab v025 we_dvjustify_burn [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_burn [iw=wt], row nofreq 

*education
tab v106 we_dvjustify_burn [iw=wt], row nofreq 

*wealth
tab v190 we_dvjustify_burn [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v502 v025 v106 v024 v190 we_dvjustify_burn using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if argues with him
*age
tab v013 we_dvjustify_argue [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_argue [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_argue [iw=wt], row nofreq 

*marital status
tab v502 we_dvjustify_argue [iw=wt], row nofreq 

*residence
tab v025 we_dvjustify_argue [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_argue [iw=wt], row nofreq 

*education
tab v106 we_dvjustify_argue [iw=wt], row nofreq 

*wealth
tab v190 we_dvjustify_argue [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v502 v025 v106 v024 v190 we_dvjustify_argue using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if goes out with telling him
*age
tab v013 we_dvjustify_goout [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_goout [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_goout [iw=wt], row nofreq 

*marital status
tab v502 we_dvjustify_goout [iw=wt], row nofreq 

*residence
tab v025 we_dvjustify_goout [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_goout [iw=wt], row nofreq 

*education
tab v106 we_dvjustify_goout [iw=wt], row nofreq 

*wealth
tab v190 we_dvjustify_goout [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v502 v025 v106 v024 v190 we_dvjustify_goout using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if neglects children
*age
tab v013 we_dvjustify_neglect [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_neglect [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_neglect [iw=wt], row nofreq 

*marital status
tab v502 we_dvjustify_neglect [iw=wt], row nofreq 

*residence
tab v025 we_dvjustify_neglect [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_neglect [iw=wt], row nofreq 

*education
tab v106 we_dvjustify_neglect [iw=wt], row nofreq 

*wealth
tab v190 we_dvjustify_neglect [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v502 v025 v106 v024 v190 we_dvjustify_neglect using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if refuses sex
*age
tab v013 we_dvjustify_refusesex [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_refusesex [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_refusesex [iw=wt], row nofreq 

*marital status
tab v502 we_dvjustify_refusesex [iw=wt], row nofreq 

*residence
tab v025 we_dvjustify_refusesex [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_refusesex [iw=wt], row nofreq 

*education
tab v106 we_dvjustify_refusesex [iw=wt], row nofreq 

*wealth
tab v190 we_dvjustify_refusesex [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v502 v025 v106 v024 v190 we_dvjustify_refusesex using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating - at least one reason
*age
tab v013 we_dvjustify_onereas [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_onereas [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_onereas [iw=wt], row nofreq 

*marital status
tab v502 we_dvjustify_onereas [iw=wt], row nofreq 

*residence
tab v025 we_dvjustify_onereas [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_onereas [iw=wt], row nofreq 

*education
tab v106 we_dvjustify_onereas [iw=wt], row nofreq 

*wealth
tab v190 we_dvjustify_onereas [iw=wt], row nofreq 

* output to excel
tabout v013 emply numch v502 v025 v106 v024 v190 we_dvjustify_onereas using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify having no sex if husband is having sex with another woman
*age
tab v013 we_justify_refusesex [iw=wt], row nofreq 

*marital status
tab v502 we_justify_refusesex [iw=wt], row nofreq 

*residence
tab v025 we_justify_refusesex [iw=wt], row nofreq 

*region
tab v024 we_justify_refusesex [iw=wt], row nofreq 

*education
tab v106 we_justify_refusesex [iw=wt], row nofreq 

*wealth
tab v190 we_justify_refusesex [iw=wt], row nofreq 

* output to excel
tabout v013 v502 v025 v106 v024 v190 we_justify_refusesex using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify asking husband to use condom if he has STI
*age
tab v013 we_justify_cond [iw=wt], row nofreq 

*marital status
tab v502 we_justify_cond [iw=wt], row nofreq 

*residence
tab v025 we_justify_cond [iw=wt], row nofreq 

*region
tab v024 we_justify_cond [iw=wt], row nofreq 

*education
tab v106 we_justify_cond [iw=wt], row nofreq 

*wealth
tab v190 we_justify_cond [iw=wt], row nofreq 

* output to excel
tabout v013 v502 v025 v106 v024 v190 we_justify_cond using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify asking husband to use condom if he has STI
*age
tab v013 we_justify_cond [iw=wt], row nofreq 

*marital status
tab v502 we_justify_cond [iw=wt], row nofreq 

*residence
tab v025 we_justify_cond [iw=wt], row nofreq 

*region
tab v024 we_justify_cond [iw=wt], row nofreq 

*education
tab v106 we_justify_cond [iw=wt], row nofreq 

*wealth
tab v190 we_justify_cond [iw=wt], row nofreq 

* output to excel
tabout v013 v502 v025 v106 v024 v190 we_justify_cond using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Can say no to husband if they dont want to have sex
*age
tab v013 we_havesay_refusesex [iw=wt], row nofreq 

*residence
tab v025 we_havesay_refusesex [iw=wt], row nofreq 

*region
tab v024 we_havesay_refusesex [iw=wt], row nofreq 

*education
tab v106 we_havesay_refusesex [iw=wt], row nofreq 

*wealth
tab v190 we_havesay_refusesex [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 we_havesay_refusesex using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Can ask husband to use a condom
*age
tab v013 we_havesay_condom [iw=wt], row nofreq 

*residence
tab v025 we_havesay_condom [iw=wt], row nofreq 

*region
tab v024 we_havesay_condom [iw=wt], row nofreq 

*education
tab v106 we_havesay_condom [iw=wt], row nofreq 

*wealth
tab v190 we_havesay_condom [iw=wt], row nofreq 

* output to excel
tabout v013 v025 v106 v024 v190 we_havesay_condom using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Number of decisions by those who disagree with all reasons that justify wife beating (only first column)
ta we_num_decide we_num_justifydv [iw=wt], row

//Number of reasons that justify wife beating by those who participate in all decision making (only last column)
ta we_num_justifydv we_num_decide [iw=wt], row

* output to excel
tabout we_num_decide we_num_justifydv using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append
tabout we_num_justifydv we_num_decide using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 

/* ****************************************************
Note:
The women empowerment indicators we_num_decide and we_num_justifydv may also be tabulated by current contraceptive use and unment need (chapter 7), ideal number of children (chapter 6),
and reproductive health indicators (chapter 9). Please check these chapters to create the indicators of interest that you would like to include in the tabulations. 
For instance the code below would give the contraceptive use for those that participate in all three decision making items. 
ta v313 if we_num_decide==2 [iw=wt]
*****************************************************/

}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {
gen wt=mv005/1000000

* Number of living children
recode mv218 (0=0 " 0") (1/2=1 " 1-2") (3/4=2 " 3-4") (5/max=3 "5+") (99 . =.), gen(numch)
label var numch "number of living children"

**************************************************************************************************
* Employment and earnings
**************************************************************************************************
//Employment in the last 12 months
*age
tab mv013 we_empl [iw=wt], row

* output to excel
tabout mv013 we_empl using Tables_emply_mn.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Employment by type of earnings
*age
tab mv013 we_empl_earn [iw=wt], row

* output to excel
tabout mv013 we_empl_earn using Tables_emply_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decision on husband's cash earnings
*age
tab mv013 we_earn_mn_decide [iw=wt], row nofreq 

*number of living children
tab numch we_earn_mn_decide [iw=wt], row nofreq 

*residence
tab mv025 we_earn_mn_decide [iw=wt], row nofreq 

*region
tab mv024 we_earn_mn_decide [iw=wt], row nofreq 

*education
tab mv106 we_earn_mn_decide [iw=wt], row nofreq 

*wealth
tab mv190 we_earn_mn_decide [iw=wt], row nofreq 

* output to excel
tabout mv013 numch mv025 mv106 mv024 mv190 we_earn_mn_decide using Tables_emply_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Ownership of assets
**************************************************************************************************
//Own a house
*age
tab mv013 we_own_house [iw=wt], row nofreq 

*residence
tab mv025 we_own_house [iw=wt], row nofreq 

*region
tab mv024 we_own_house [iw=wt], row nofreq 

*education
tab mv106 we_own_house [iw=wt], row nofreq 

*wealth
tab mv190 we_own_house [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 we_own_house using Tables_assets_mn.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Own land
*age
tab mv013 we_own_land [iw=wt], row nofreq 

*residence
tab mv025 we_own_land [iw=wt], row nofreq 

*region
tab mv024 we_own_land [iw=wt], row nofreq 

*education
tab mv106 we_own_land [iw=wt], row nofreq 

*wealth
tab mv190 we_own_land [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 we_own_land using Tables_assets_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Title or deed ownwership for house
*age
tab mv013 we_house_deed [iw=wt], row nofreq 

*residence
tab mv025 we_house_deed [iw=wt], row nofreq 

*region
tab mv024 we_house_deed [iw=wt], row nofreq 

*education
tab mv106 we_house_deed [iw=wt], row nofreq 

*wealth
tab mv190 we_house_deed [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 we_house_deed using Tables_assets_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Title or deed ownwership for land
*age
tab mv013 we_land_deed [iw=wt], row nofreq 

*residence
tab mv025 we_land_deed [iw=wt], row nofreq 

*region
tab mv024 we_land_deed [iw=wt], row nofreq 

*education
tab mv106 we_land_deed [iw=wt], row nofreq 

*wealth
tab mv190 we_land_deed [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 we_land_deed using Tables_assets_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Have a bank account
*age
tab mv013 we_bank [iw=wt], row nofreq 

*residence
tab mv025 we_bank [iw=wt], row nofreq 

*region
tab mv024 we_bank [iw=wt], row nofreq 

*education
tab mv106 we_bank [iw=wt], row nofreq 

*wealth
tab mv190 we_bank [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 we_bank using Tables_assets_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Have a mobile phone
*age
tab mv013 we_mobile [iw=wt], row nofreq 

*residence
tab mv025 we_mobile [iw=wt], row nofreq 

*region
tab mv024 we_mobile [iw=wt], row nofreq 

*education
tab mv106 we_mobile [iw=wt], row nofreq 

*wealth
tab mv190 we_mobile [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 we_mobile using Tables_assets_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Use mobile phone for financial transactions
*age
tab mv013 we_mobile_finance [iw=wt], row nofreq 

*residence
tab mv025 we_mobile_finance [iw=wt], row nofreq 

*region
tab mv024 we_mobile_finance [iw=wt], row nofreq 

*education
tab mv106 we_mobile_finance [iw=wt], row nofreq 

*wealth
tab mv190 we_mobile_finance [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv106 mv024 mv190 we_mobile_finance using Tables_assets_mn.xls [iw=wt] , c(row) f(1) append 
*/
**************************************************************************************************
* Decision making indicators
**************************************************************************************************
//Decision making indicators

*on health and household purchases
tab1 we_decide_health we_decide_hhpurch [iw=wt]

* output to excel
tabout we_decide_health we_decide_hhpurch using Tables_empw_mn.xls [iw=wt] , oneway cells(cell) replace 

****************************************************
*Employment by earning either alone or jointly with partner
gen emply=.
replace emply=0 if mv731==0
replace emply=1 if mv731>0 & mv731<8 & (mv741==1 | mv741==2)
replace emply=2 if mv731>0 & mv731<8 & (mv741==0 | mv741==3)
label define emply 0"Not employed" 1"Employed for cash" 2"Employed not for cash"
label values emply emply
label var emply "Employment in the last 12 months"

//Decide on own health care
*age
tab mv013 we_decide_health_self [iw=wt], row nofreq 

*employment by earning
tab emply we_decide_health_self [iw=wt], row nofreq 

*number of children
tab numch we_decide_health_self [iw=wt], row nofreq 

*residence
tab mv025 we_decide_health_self [iw=wt], row nofreq 

*region
tab mv024 we_decide_health_self [iw=wt], row nofreq 

*education
tab mv106 we_decide_health_self [iw=wt], row nofreq 

*wealth
tab mv190 we_decide_health_self [iw=wt], row nofreq 

* output to excel
tabout mv013 numch emply mv025 mv106 mv024 mv190 we_decide_health_self using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append
*/
****************************************************
//Decide on household purchases either alone or jointly with partner
*age
tab mv013 we_decide_hhpurch_self [iw=wt], row nofreq 

*employment by earning
tab emply we_decide_hhpurch_self [iw=wt], row nofreq 

*number of children
tab numch we_decide_hhpurch_self [iw=wt], row nofreq 

*residence
tab mv025 we_decide_hhpurch_self [iw=wt], row nofreq 

*region
tab mv024 we_decide_hhpurch_self [iw=wt], row nofreq 

*education
tab mv106 we_decide_hhpurch_self [iw=wt], row nofreq 

*wealth
tab mv190 we_decide_hhpurch_self [iw=wt], row nofreq 

* output to excel
tabout mv013 numch emply mv025 mv106 mv024 mv190 we_decide_hhpurch_self using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decide on both health and purchases
*age
tab mv013 we_decide_all [iw=wt], row nofreq 

*employment by earning
tab emply we_decide_all [iw=wt], row nofreq 

*number of children
tab numch we_decide_all [iw=wt], row nofreq 

*residence
tab mv025 we_decide_all [iw=wt], row nofreq 

*region
tab mv024 we_decide_all [iw=wt], row nofreq 

*education
tab mv106 we_decide_all [iw=wt], row nofreq 

*wealth
tab mv190 we_decide_all [iw=wt], row nofreq 

* output to excel
tabout mv013 numch emply mv025 mv106 mv024 mv190 we_decide_all using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Decide on neither of two decisions (health and purchases)
*age
tab mv013 we_decide_none [iw=wt], row nofreq 

*employment by earning
tab emply we_decide_none [iw=wt], row nofreq 

*number of children
tab numch we_decide_none [iw=wt], row nofreq 

*residence
tab mv025 we_decide_none [iw=wt], row nofreq 

*region
tab mv024 we_decide_none [iw=wt], row nofreq 

*education
tab mv106 we_decide_none [iw=wt], row nofreq 

*wealth
tab mv190 we_decide_none [iw=wt], row nofreq 

* output to excel
tabout mv013 numch emply mv025 mv106 mv024 mv190 we_decide_none using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/

**************************************************************************************************
* Justification of violence
**************************************************************************************************
//Justify wife beating if burns food
*age
tab mv013 we_dvjustify_burn [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_burn [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_burn [iw=wt], row nofreq 

*marital status
tab mv502 we_dvjustify_burn [iw=wt], row nofreq 

*residence
tab mv025 we_dvjustify_burn [iw=wt], row nofreq 

*region
tab mv024 we_dvjustify_burn [iw=wt], row nofreq 

*education
tab mv106 we_dvjustify_burn [iw=wt], row nofreq 

*wealth
tab mv190 we_dvjustify_burn [iw=wt], row nofreq 

* output to excel
tabout mv013 emply numch mv502 mv025 mv106 mv024 mv190 we_dvjustify_burn using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if argues with him
*age
tab mv013 we_dvjustify_argue [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_argue [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_argue [iw=wt], row nofreq 

*marital status
tab mv502 we_dvjustify_argue [iw=wt], row nofreq 

*residence
tab mv025 we_dvjustify_argue [iw=wt], row nofreq 

*region
tab mv024 we_dvjustify_argue [iw=wt], row nofreq 

*education
tab mv106 we_dvjustify_argue [iw=wt], row nofreq 

*wealth
tab mv190 we_dvjustify_argue [iw=wt], row nofreq 

* output to excel
tabout mv013 emply numch mv502 mv025 mv106 mv024 mv190 we_dvjustify_argue using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if goes out with telling him
*age
tab mv013 we_dvjustify_goout [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_goout [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_goout [iw=wt], row nofreq 

*marital status
tab mv502 we_dvjustify_goout [iw=wt], row nofreq 

*residence
tab mv025 we_dvjustify_goout [iw=wt], row nofreq 

*region
tab mv024 we_dvjustify_goout [iw=wt], row nofreq 

*education
tab mv106 we_dvjustify_goout [iw=wt], row nofreq 

*wealth
tab mv190 we_dvjustify_goout [iw=wt], row nofreq 

* output to excel
tabout mv013 emply numch mv502 mv025 mv106 mv024 mv190 we_dvjustify_goout using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if neglects children
*age
tab mv013 we_dvjustify_neglect [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_neglect [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_neglect [iw=wt], row nofreq 

*marital status
tab mv502 we_dvjustify_neglect [iw=wt], row nofreq 

*residence
tab mv025 we_dvjustify_neglect [iw=wt], row nofreq 

*region
tab mv024 we_dvjustify_neglect [iw=wt], row nofreq 

*education
tab mv106 we_dvjustify_neglect [iw=wt], row nofreq 

*wealth
tab mv190 we_dvjustify_neglect [iw=wt], row nofreq 

* output to excel
tabout mv013 emply numch mv502 mv025 mv106 mv024 mv190 we_dvjustify_neglect using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if refuses sex
*age
tab mv013 we_dvjustify_refusesex [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_refusesex [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_refusesex [iw=wt], row nofreq 

*marital status
tab mv502 we_dvjustify_refusesex [iw=wt], row nofreq 

*residence
tab mv025 we_dvjustify_refusesex [iw=wt], row nofreq 

*region
tab mv024 we_dvjustify_refusesex [iw=wt], row nofreq 

*education
tab mv106 we_dvjustify_refusesex [iw=wt], row nofreq 

*wealth
tab mv190 we_dvjustify_refusesex [iw=wt], row nofreq 

* output to excel
tabout mv013 emply numch mv502 mv025 mv106 mv024 mv190 we_dvjustify_refusesex using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating - at least one reason
*age
tab mv013 we_dvjustify_onereas [iw=wt], row nofreq 

*employment by earning
tab emply we_dvjustify_onereas [iw=wt], row nofreq 

*number of children
tab numch we_dvjustify_onereas [iw=wt], row nofreq 

*marital status
tab mv502 we_dvjustify_onereas [iw=wt], row nofreq 

*residence
tab mv025 we_dvjustify_onereas [iw=wt], row nofreq 

*region
tab mv024 we_dvjustify_onereas [iw=wt], row nofreq 

*education
tab mv106 we_dvjustify_onereas [iw=wt], row nofreq 

*wealth
tab mv190 we_dvjustify_onereas [iw=wt], row nofreq 

* output to excel
tabout mv013 emply numch mv502 mv025 mv106 mv024 mv190 we_dvjustify_onereas using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify having no sex if husband is having sex with another woman
*age
tab mv013 we_justify_refusesex [iw=wt], row nofreq 

*marital status
tab mv502 we_justify_refusesex [iw=wt], row nofreq 

*residence
tab mv025 we_justify_refusesex [iw=wt], row nofreq 

*region
tab mv024 we_justify_refusesex [iw=wt], row nofreq 

*education
tab mv106 we_justify_refusesex [iw=wt], row nofreq 

*wealth
tab mv190 we_justify_refusesex [iw=wt], row nofreq 

* output to excel
tabout mv013 mv502 mv025 mv106 mv024 mv190 we_justify_refusesex using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Justify asking husband to use condom if he has STI
*age
tab mv013 we_justify_cond [iw=wt], row nofreq 

*marital status
tab mv502 we_justify_cond [iw=wt], row nofreq 

*residence
tab mv025 we_justify_cond [iw=wt], row nofreq 

*region
tab mv024 we_justify_cond [iw=wt], row nofreq 

*education
tab mv106 we_justify_cond [iw=wt], row nofreq 

*wealth
tab mv190 we_justify_cond [iw=wt], row nofreq 

* output to excel
tabout mv013 mv502 mv025 mv106 mv024 mv190 we_justify_cond using Tables_empw_mn.xls [iw=wt] , c(row) f(1) append 
*/

}

