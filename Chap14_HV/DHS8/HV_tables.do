/*****************************************************************************************************
Program: 			HV_tables.do  - DHS8 update
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: July 10, 2023 by Shireen Assaf 

*This do file will produce the following tables in excel:
1. 	Tables_coverage:	Contains the tables for HIV testing coverage for women, men, and total. THESE TABLES ARE UNWEIGHTED
2.	Tables_prev_wm:		Contains the tables for HIV prevalence for women
3.	Tables_prev_mn:		Contains the tables for HIV prevalence for men
4.	Tables_prev_tot:	Contains the tables for HIV prevalence for total
5.	Tables_circum:		Contains the tables for HIV prevalence by male circumcision
6.	Tables_prev_cpl:	Contains the tables for HIV prevalence for couples

Notes: 	Line 32 selects for the age group of interest for the coverage indicators. 
		The default is age 15-49. For all other tables (except couples) the default was set as 15-49 in line 116. 
		
		Not all surveys have testing that distinguish between HIV-1 and HIV-2. These tables are commented out in line 141. Uncomment if you need them. 
		
		HIV positive is represented by either hv_hiv_pos hv_hiv1or2_pos depending on whether the survey has testing to distinguish between HIV-1 and HIV-2
		For the tabulations of HIV status by background variables, hv_hiv1_pos was used but this can be replaced by hv_hiv1or2_pos. 
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from PR file
if file=="PR" {

* THE TABLES PRODUCED HERE ARE UNWEIGHTED

* select age group
drop if hv105<15 | hv105>49
 
* compute age groups for women
 recode ha1 (15/19=1 " 15-19") ( 20/24=2 " 20-24") (25/29=3 " 25-29") (30/34=4 " 30-34") (35/39=5 " 35-39") (40/44=6 " 40-44") (45/49=7 "45-49"), gen(age_wm)
 
 * compute age groups for men
 recode hb1 (15/19=1 " 15-19") ( 20/24=2 " 20-24") (25/29=3 " 25-29") (30/34=4 " 30-34") (35/39=5 " 35-39") (40/44=6 " 40-44") (45/49=7 "45-49") (else=.), gen(age_mn)
 
 *education for women
 recode ha66 (8/9=9), gen(edu_wm)
 label values edu_wm HA66
 
  *education for men
 recode hb66 (8/9=9), gen(edu_mn)
 label values edu_mn HB66
 
**************************************************************************************************
* Coverage of HIV testing 
**************************************************************************************************
//Testing status among women

*residence
tab hv025 hv_hiv_test_wm , row nofreq 

*region
tab hv024 hv_hiv_test_wm , row nofreq 

*age
tab age_wm hv_hiv_test_wm , row nofreq 

*education
tab edu_wm hv_hiv_test_wm , row nofreq 

*wealth
tab hv270 hv_hiv_test_wm , row nofreq 

* output to excel
tabout hv025 hv024 age_wm edu_wm hv270 hv_hiv_test_wm using Tables_coverage.xls , c(row) f(1) replace 
*/
**************************************************************************************************
//Testing status among men

*residence
tab hv025 hv_hiv_test_mn , row nofreq 

*region
tab hv024 hv_hiv_test_mn , row nofreq 

*age
tab age_mn hv_hiv_test_mn , row nofreq 

*education
tab edu_mn hv_hiv_test_mn , row nofreq 

*wealth
tab hv270 hv_hiv_test_mn , row nofreq 

* output to excel
tabout hv025 hv024 age_mn edu_mn hv270 hv_hiv_test_mn using Tables_coverage.xls , c(row) f(1) append 
*/
**************************************************************************************************
//Testing status total 

*residence
tab hv025 hv_hiv_test_tot , row nofreq 

*region
tab hv024 hv_hiv_test_tot , row nofreq 

* output to excel
tabout hv025 hv024 hv_hiv_test_tot using Tables_coverage.xls , c(row) f(1) append 
*/

}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {

* These tables actually use the IRMRARmerge.dta file and not the MR file. For this file men's variables (mv###) were renamed to (v###) and a sex variable was created to identify men/women	

* limiting to women and men age 15-49
drop if v012<15 | v012>49

* use HIV weight
gen wt=hiv05/1000000

**************************************************************************************************
* HIV prevalence
**************************************************************************************************
//HIV positive
*by age for women
tab v013 hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*by age for men
tab v013 hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*by age - Total
tab v013 hv_hiv_pos [iw=wt], row nofreq 

* output to excel
tabout v013 hv_hiv_pos if sex==2 using Tables_prev_wm.xls [iw=wt] , c(row) clab("Women") f(1) replace 
tabout v013 hv_hiv_pos if sex==1 using Tables_prev_mn.xls [iw=wt] , c(row) clab("Men") f(1) replace 
tabout v013 hv_hiv_pos using Tables_prev_tot.xls [iw=wt] , c(row) clab("Total") f(1) replace 
*/
*/
**************************************************************************************************
/* For surveys with testing to distinguish between HIV-1 and HIV-2
* Tabulation is for HIV-1, HIV-2, and HIV-1 or HIV-2 indicators

*age for women
tab v013 hv_hiv1_pos if sex==2 [iw=wt], row nofreq 
tab v013 hv_hiv2_pos if sex==2 [iw=wt], row nofreq 
tab v013 hv_hiv1or2_pos if sex==2 [iw=wt], row nofreq 

* output to excel
tabout v013 hv_hiv1_pos if sex==2 using Tables_prev_wm.xls [iw=wt] , c(row) clab("Women_HIV1") f(1) append 
tabout v013 hv_hiv2_pos if sex==2 using Tables_prev_wm.xls [iw=wt] , c(row) clab("Women_HIV2") f(1) append 
tabout v013 hv_hiv1or2_pos if sex==2 using Tables_prev_wm.xls [iw=wt] , c(row) clab("Women_HIV1_or_2") f(1) append 
****

*age for men
tab v013 hv_hiv1_pos if sex==1 [iw=wt], row nofreq 
tab v013 hv_hiv2_pos if sex==1 [iw=wt], row nofreq 
tab v013 hv_hiv1or2_pos if sex==1 [iw=wt], row nofreq 

* output to excel
tabout v013 hv_hiv1_pos if sex==1 using Tables_prev_mn.xls [iw=wt] , c(row) clab("Men_HIV1") f(1) append 
tabout v013 hv_hiv2_pos if sex==1 using Tables_prev_mn.xls [iw=wt] , c(row) clab("Men_HIV2") f(1) append 
tabout v013 hv_hiv1or2_pos if sex==1 using Tables_prev_mn.xls [iw=wt] , c(row) clab("Men_HIV1_or_2") f(1) append 
****

*age - Total
tab v013 hv_hiv1_pos [iw=wt], row nofreq 
tab v013 hv_hiv2_pos [iw=wt], row nofreq 
tab v013 hv_hiv1or2_pos [iw=wt], row nofreq 

* output to excel
tabout v013 hv_hiv1_pos using Tables_prev_tot.xls [iw=wt] , c(row) clab("Total_HIV1") f(1) append 
tabout v013 hv_hiv2_pos using Tables_prev_tot.xls [iw=wt] , c(row) clab("Total_HIV2") f(1) append 
tabout v013 hv_hiv1or2_pos using Tables_prev_tot.xls [iw=wt] , c(row) clab("Total_HIV1_or_2") f(1) append 
*/
**************************************************************************************************
* HIV prevalence - by background variables
**************************************************************************************************
*** Tables for HIV positive among women 15-49 by background variables

* ethnicity
tab v131 hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*religion
tab v130 hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*employment
tab empl hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*residence
tab v025 hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*region
tab v024 hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*education
tab v106 hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*wealth 
tab v190 hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*marital status
tab v501 hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*type of union - polygamy
tab poly_w hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*currently pregnant
tab preg hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*ANC place for last birth in the past 3 years
tab ancplace hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*Age at first sexual intercourse
tab agesex hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*number of lifetime partners
tab numprtnr hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*multiple sexual partners in the past 12 months
tab multisex hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*Non-marital, non-cohabiting partner in the past 12 months
tab prtnrcohab hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*Condom use at last sexual intercourse in past 12 months
tab condomuse hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*STI in the past 12 months
tab sti12m hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*Had prior HIV test and whether they received results
tab test_prior hv_hiv_pos if sex==2 [iw=wt], row nofreq 

*output to excel
tabout v131 v130 empl v025 v024 v106 v190 v501 poly_w preg ancplace agesex numprtnr multisex prtnrcohab condomuse sti12m test_prior hv_hiv_pos if sex==2 using Tables_prev_wm.xls [iw=wt] , c(row) clab("Women_15_49") f(1) append 

**************************************************************************************************
*** Tables for HIV positive among men 15-49 by background variables

* ethnicity
tab v131 hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*religion
tab v130 hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*employment
tab empl hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*residence
tab v025 hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*region
tab v024 hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*education
tab v106 hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*wealth 
tab v190 hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*marital status
tab v501 hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*type of union - polygamy
tab poly_m hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*Age at first sexual intercourse
tab agesex hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*number of lifetime partners
tab numprtnr hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*multiple sexual partners in the past 12 months
tab multisex hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*Non-marital, non-cohabiting partner in the past 12 months
tab prtnrcohab hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*Condom use at last sexual intercourse in past 12 months
tab condomuse hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*STI in the past 12 months
tab sti12m hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*Had prior HIV test and whether they received results
tab test_prior hv_hiv_pos if sex==1 [iw=wt], row nofreq 

*output to excel
tabout v131 v130 empl v025 v024 v106 v190 v501 poly_m agesex numprtnr multisex prtnrcohab condomuse sti12m test_prior hv_hiv_pos if sex==1 using Tables_prev_mn.xls [iw=wt] , c(row) clab("Men_15_49") f(1) append 

**************************************************************************************************
*** Tables for HIV positive among men and women (15-49) for Total by background variables

* ethnicity
tab v131 hv_hiv_pos  [iw=wt], row nofreq 

*religion
tab v130 hv_hiv_pos [iw=wt], row nofreq 

*employment
tab empl hv_hiv_pos  [iw=wt], row nofreq 

*residence
tab v025 hv_hiv_pos [iw=wt], row nofreq 

*region
tab v024 hv_hiv_pos [iw=wt], row nofreq 

*education
tab v106 hv_hiv_pos [iw=wt], row nofreq 

*wealth 
tab v190 hv_hiv_pos  [iw=wt], row nofreq 

*marital status
tab v501 hv_hiv_pos [iw=wt], row nofreq 

*type of union - polygamy
tab poly_t hv_hiv_pos [iw=wt], row nofreq 

*Age at first sexual intercourse
tab agesex hv_hiv_pos  [iw=wt], row nofreq 

*number of lifetime partners
tab numprtnr hv_hiv_pos [iw=wt], row nofreq 

*multiple sexual partners in the past 12 months
tab multisex hv_hiv_pos  [iw=wt], row nofreq 

*Non-marital, non-cohabiting partner in the past 12 months
tab prtnrcohab hv_hiv_pos [iw=wt], row nofreq 

*Condom use at last sexual intercourse in past 12 months
tab condomuse hv_hiv_pos [iw=wt], row nofreq 

*STI in the past 12 months
tab sti12m hv_hiv_pos [iw=wt], row nofreq 

*Had prior HIV test and whether they received results
tab test_prior hv_hiv_pos [iw=wt], row nofreq 

*output to excel
tabout v131 v130 empl v025 v024 v106 v190 v501 poly_t agesex numprtnr multisex prtnrcohab condomuse sti12m test_prior hv_hiv_pos using Tables_prev_tot.xls [iw=wt] , c(row) clab("Total_15_49") f(1) append 

**************************************************************************************************

*** Tables for HIV positive among young women (15-24) by background variables

* new age variable for youth 
tab age_yng hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*marital status
tab v501 hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*currently pregnant
tab preg hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*residence
tab v025 hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*region
tab v024 hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*education
tab v106 hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*wealth 
tab v190 hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*multiple sexual partners in the past 12 months
tab multisex hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*Non-marital, non-cohabiting partner in the past 12 months
tab prtnrcohab hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*Condom use at last sexual intercourse in past 12 months
tab condomuse hv_hiv_pos if sex==2 & v013<3 [iw=wt], row nofreq 

*output to excel
tabout age_yng v501 preg v025 v024 v106 v190 multisex prtnrcohab condomuse hv_hiv_pos if sex==2 & v013<3 using Tables_prev_wm.xls [iw=wt] , c(row) clab("Women_15_24") f(1) append 
**************************************************************************************************

*** Tables for HIV positive among young men (15-24) by background variables

* new age variable for youth 
tab age_yng hv_hiv_pos if sex==1 & v013<3 [iw=wt], row nofreq 

*marital status
tab v501 hv_hiv_pos if sex==1 & v013<3 [iw=wt], row nofreq 

*residence
tab v025 hv_hiv_pos if sex==1 & v013<3 [iw=wt], row nofreq 

*region
tab v024 hv_hiv_pos if sex==1 & v013<3 [iw=wt], row nofreq 

*education
tab v106 hv_hiv_pos if sex==1 & v013<3 [iw=wt], row nofreq 

*wealth 
tab v190 hv_hiv_pos if sex==1 & v013<3 [iw=wt], row nofreq 

*multiple sexual partners in the past 12 months
tab multisex hv_hiv_pos if sex==1 & v013<3 [iw=wt], row nofreq 

*Non-marital, non-cohabiting partner in the past 12 months
tab prtnrcohab hv_hiv_pos if sex==1 & v013<3 [iw=wt], row nofreq 

*Condom use at last sexual intercourse in past 12 months
tab condomuse hv_hiv_pos if sex==1 & v013<3 [iw=wt], row nofreq 

*output to excel
tabout age_yng v501 v025 v024 v106 v190 multisex prtnrcohab condomuse hv_hiv_pos if sex==1 & v013<3 using Tables_prev_mn.xls [iw=wt] , c(row) clab("Men_15_24") f(1) append 
**************************************************************************************************

*** Tables for HIV positive among young men and women (15-24) for Total by background variables

* new age variable for youth 
tab age_yng hv_hiv_pos if v013<3 [iw=wt], row nofreq 

*marital status
tab v501 hv_hiv_pos if v013<3 [iw=wt], row nofreq 

*residence
tab v025 hv_hiv_pos if v013<3 [iw=wt], row nofreq 

*region
tab v024 hv_hiv_pos if v013<3 [iw=wt], row nofreq 

*education
tab v106 hv_hiv_pos if v013<3 [iw=wt], row nofreq 

*wealth 
tab v190 hv_hiv_pos if v013<3 [iw=wt], row nofreq 

*multiple sexual partners in the past 12 months
tab multisex hv_hiv_pos if v013<3 [iw=wt], row nofreq 

*Non-marital, non-cohabiting partner in the past 12 months
tab prtnrcohab hv_hiv_pos if v013<3 [iw=wt], row nofreq 

*Condom use at last sexual intercourse in past 12 months
tab condomuse hv_hiv_pos if v013<3 [iw=wt], row nofreq 

*output to excel
tabout age_yng v501 v025 v024 v106 v190 multisex prtnrcohab condomuse hv_hiv_pos if v013<3 using Tables_prev_tot.xls [iw=wt] , c(row) clab("Total_15_24") f(1) append 

**************************************************************************************************
* Prior HIV testing by current HIV status
**************************************************************************************************

* among HIV positive women
tab1 hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if sex==2 & inrange(hiv03,1,3) [iw=wt]

*output to excel - women
tabout hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if sex==2 & inrange(hiv03,1,3) ///
using Tables_prior_tests.xls [iw=wt], oneway clab("Women_15_49_hivpos") cells(cell) f(1) replace

* among HIV negative women
tab1 hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if sex==2 & inlist(hiv03,0,7,9) [iw=wt]

*output to excel - women
tabout hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if sex==2 & inlist(hiv03,0,7,9)  ///
using Tables_prior_tests.xls [iw=wt], oneway clab("Women_15_49_hivneg") cells(cell) f(1) append

**********************
* among HIV positive men
tab1 hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if sex==1 & inrange(hiv03,1,3) [iw=wt]

*output to excel - men
tabout hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if sex==1 & inrange(hiv03,1,3) ///
using Tables_prior_tests.xls [iw=wt], oneway clab("Men_15_49_hivpos") cells(cell) f(1) append

* among HIV negative men
tab1 hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if sex==1 & inlist(hiv03,0,7,9) [iw=wt]

*output to excel - men
tabout hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if sex==1 & inlist(hiv03,0,7,9)  ///
using Tables_prior_tests.xls [iw=wt], oneway clab("Men_15_49_hivneg") cells(cell) f(1) append

**********************
* among HIV positive - total
tab1 hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if inrange(hiv03,1,3) [iw=wt]

*output to excel - total
tabout hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if inrange(hiv03,1,3) ///
using Tables_prior_tests.xls [iw=wt], oneway clab("Tot_15_49_hivpos") cells(cell) f(1) append

* among HIV negative - total
tab1 hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if inlist(hiv03,0,7,9) [iw=wt]

*output to excel - total
tabout hv_rcnt_test_pos hv_rcnt_test_pos_art hv_rcnt_test_pos_noart hv_rcnt_test_neg hv_test_indeter hv_test_decline hv_ever_test_noresult hv_no_prev_test if inlist(hiv03,0,7,9)  ///
using Tables_prior_tests.xls [iw=wt], oneway clab("Tot_15_49_hivneg") cells(cell) f(1) append

**************************************************************************************************
* HIV prevalence by male circumcision
**************************************************************************************************
* Men traditionally or medically circumcised who were HIV positive

* age
tab v013 hv_tradormed_circum if sex==1 [iw=wt], row nofreq 

* ethnicity
tab v131 hv_tradormed_circum if sex==1  [iw=wt], row nofreq 

*religion
tab v130 hv_tradormed_circum if sex==1 [iw=wt], row nofreq 

*residence
tab v025 hv_tradormed_circum if sex==1 [iw=wt], row nofreq 

*region
tab v024 hv_tradormed_circum if sex==1 [iw=wt], row nofreq 

*education
tab v106 hv_tradormed_circum if sex==1 [iw=wt], row nofreq 

*wealth 
tab v190 hv_tradormed_circum if sex==1  [iw=wt], row nofreq 

*output to excel
tabout v013 v131 v130 v025 v024 v106 v190 hv_tradormed_circum if sex==1 using Tables_circum.xls [iw=wt] , c(row) clab("trad_or_med_circum") f(1) replace 


***********
* Men traditionally circumcised who were HIV positive

* age
tab v013 hv_trad_circum if sex==1 [iw=wt], row nofreq 

* ethnicity
tab v131 hv_trad_circum if sex==1  [iw=wt], row nofreq 

*religion
tab v130 hv_trad_circum if sex==1 [iw=wt], row nofreq 

*residence
tab v025 hv_trad_circum if sex==1 [iw=wt], row nofreq 

*region
tab v024 hv_trad_circum if sex==1 [iw=wt], row nofreq 

*education
tab v106 hv_trad_circum if sex==1 [iw=wt], row nofreq 

*wealth 
tab v190 hv_trad_circum if sex==1  [iw=wt], row nofreq 

*output to excel
tabout v013 v131 v130 v025 v024 v106 v190 hv_hiv_circum_trad if sex==1 using Tables_circum.xls [iw=wt] , c(row) clab("trad_circum") f(1) append 


***********
* Men medically circumcised who were HIV positive

* age
tab v013 hv_med_circum if sex==1 [iw=wt], row nofreq 

* ethnicity
tab v131 hv_med_circum if sex==1  [iw=wt], row nofreq 

*religion
tab v130 hv_med_circum if sex==1 [iw=wt], row nofreq 

*residence
tab v025 hv_med_circum if sex==1 [iw=wt], row nofreq 

*region
tab v024 hv_med_circum if sex==1 [iw=wt], row nofreq 

*education
tab v106 hv_med_circum if sex==1 [iw=wt], row nofreq 

*wealth 
tab v190 hv_med_circum if sex==1  [iw=wt], row nofreq 

*output to excel
tabout v013 v131 v130 v025 v024 v106 v190 hv_hiv_circum_pos if sex==1 using Tables_circum.xls [iw=wt] , c(row) clab("med_circum") f(1) append 


***********		
* Men traditionally and medically circumcised who were HIV positive

* age
tab v013 hv_tradandmed_circum if sex==1 [iw=wt], row nofreq 

* ethnicity
tab v131 hv_tradandmed_circum if sex==1  [iw=wt], row nofreq 

*religion
tab v130 hv_tradandmed_circum if sex==1 [iw=wt], row nofreq 

*residence
tab v025 hv_tradandmed_circum if sex==1 [iw=wt], row nofreq 

*region
tab v024 hv_tradandmed_circum if sex==1 [iw=wt], row nofreq 

*education
tab v106 hv_tradandmed_circum if sex==1 [iw=wt], row nofreq 

*wealth 
tab v190 hv_tradandmed_circum if sex==1  [iw=wt], row nofreq 

*output to excel
tabout v013 v131 v130 v025 v024 v106 v190 hv_tradandmed_circum if sex==1 using Tables_circum.xls [iw=wt] , c(row) clab("trad_and_med_circum") f(1) append 

***********		
		
* All uncircumcised or don't know circumcision status men who were HIV positive

* age
tab v013 hv_uncircum if sex==1 [iw=wt], row nofreq 

* ethnicity
tab v131 hv_uncircum if sex==1  [iw=wt], row nofreq 

*religion
tab v130 hv_uncircum if sex==1 [iw=wt], row nofreq 

*residence
tab v025 hv_uncircum if sex==1 [iw=wt], row nofreq 

*region
tab v024 hv_uncircum if sex==1 [iw=wt], row nofreq 

*education
tab v106 hv_uncircum if sex==1 [iw=wt], row nofreq 

*wealth 
tab v190 hv_uncircum if sex==1  [iw=wt], row nofreq 

*output to excel
tabout v013 v131 v130 v025 v024 v106 v190 hv_uncircum if sex==1 using Tables_circum.xls [iw=wt] , c(row) clab("uncircum") f(1) append 

***********	

}


* indicators from the CR file
if file=="CR" {

* use HIV weight
gen wt=hiv05/1000000

**************************************************************************************************
* HIV prevalence among couples
**************************************************************************************************

* women's age
tab v013 hv_couple_hiv_status [iw=wt], row nofreq 

* men's age
tab mv013 hv_couple_hiv_status [iw=wt], row nofreq 

*residence
tab v025 hv_couple_hiv_status [iw=wt], row nofreq 

*region
tab v024 hv_couple_hiv_status [iw=wt], row nofreq 

*women's education
tab v106 hv_couple_hiv_status [iw=wt], row nofreq 

*men's education
tab v106 hv_couple_hiv_status [iw=wt], row nofreq 

*wealth 
tab v190 hv_couple_hiv_status [iw=wt], row nofreq 


*output to excel
tabout v013 mv013 v025 v024 v106 mv106 v190 hv_couple_hiv_status using Tables_prev_cpl.xls [iw=wt] , c(row)  f(1) replace 
***********	
 
}