/*****************************************************************************************************
Program: 			ML_tables.do
Purpose: 			produce tables for indicators
Author:				Cameron Taylor
Date last modified: Feb 19 2019 by Cameron Taylor

*Note this do file will produce the following tables in excel:
	1. 	Tables_HH_ITN:		Contains the tables for houeshold possession of ITNs
	2.  Tables_HH_ITN_USE:	Contains the tables for ITN use among de facto population, children, and pregnant women
	3.  Tables_MAL_ANEMIA:	Contains the table for children 6–59 months old with severe anemia (<8.0 g/dL)
	4. 	Tables_MALARIA:		Contains the table for children 6-59 months old with malaria infection via RDT and microscopy
	5. 	Tables_IPTP:		Contains tables on IPTp uptake
	6. 	Tables_FEVER:		Contains tables on fever careseeking for children under 5 (fever, treatment seeking, ACT)


*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from HR file
if file=="HR" 
gen wt=hv005/1000000


****************************************************
//Household ownership of ITNs

*residence
tab hv025 mal_ITNinHH  [iw=wt], row nofreq 

*region
tab hv024 mal_ITNinHH [iw=wt], row nofreq 

*wealth
tab hv270 mal_ITNinHH [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 mal_ITNinHH using Tables_HH_ITN.xls [iw=wt] , c(row) f(1) append 


****************************************************
//Average number of ITNs per household
/*
*residence
mean mal_numitnhh

*region


*wealth


* output to excel

*/

****************************************************
//Households with at least one ITN for every 2 persons 

*residence
tab hv025 mal_hhaccess if hv013>=1 [iw=wt], row nofreq 

*region
tab hv024 mal_hhaccess if hv013>=1 [iw=wt], row nofreq 

*wealth
tab hv270 mal_hhaccess if hv013>=1 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 mal_ITNinHH using Tables_HH_ITN.xls [iw=wt] , c(row) f(1) append 


* indicators from HRPR file
if file=="HRPR" 
gen wt=hv005/1000000

****************************************************
//Proportion of the population with access to an ITN

svy: mean access2 if hv103==1





* indicators from PR file
if file=="PR" 
gen wt=hv005/1000000


****************************************************
//De facto household population who slept the night before the survey under an ITN

*residence
tab hv025 mal_itn if hv103==1 [iw=wt], row nofreq 

*region
tab hv024 mal_itn if hv103==1 [iw=wt], row nofreq 

*wealth
tab hv270 mal_itn if hv103==1 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 mal_itn if hv103==1 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Children under age 5 who slept the night before the survey under an ITN

*residence
tab hv025 mal_itn if hv103==1 & hml16<5 [iw=wt], row nofreq 

*region
tab hv024 mal_itn if hv103==1 & hml16<5 [iw=wt], row nofreq 

*wealth
tab hv270 mal_itn if hv103==1 & hml16<5 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 mal_itn if hv103==1 & hml16<5 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Pregnant women age 15-49 who slept the night before the survey under an ITN

*residence
tab hv025 mal_itn if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

*region
tab hv024 mal_itn if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

*wealth
tab hv270 mal_itn if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 mal_itn if hv103==1 & hv104==2 & hml18==1 & hml16>=15 & hml16<=49 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 


****************************************************
//Children with hemoglobin lower than 8.0 g/dl

*residence
tab hv025 mal_anemia if hv103==1 & hc1>=6 & hc1<=59 & hc55==0 & hc53~=999 [iw=wt], row nofreq 

*region
tab hv024 mal_anemia if hv103==1 & hc1>=6 & hc1<=59 & hc55==0 & hc53~=999 [iw=wt], row nofreq 

*wealth
tab hv270 mal_anemia if hv103==1 & hc1>=6 & hc1<=59 & hc55==0 & hc53~=999 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 mal_anemia if hv103==1 & hc1>=6 & hc1<=59 & hc55==0 & hc53~=999 using Tables_MAL_ANEMIA.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Parasitemia (via microscopy) in children 6-59 months

*residence
tab hv025 mal_micmalpos if hc1>=6 & hc1<=59 & hv103==1 & hml33==0 [iw=wt], row nofreq 

*region
tab hv024 mal_micmalpos if hc1>=6 & hc1<=59 & hv103==1 & hml33==0 [iw=wt], row nofreq 

*wealth
tab hv270 mal_micmalpos if hc1>=6 & hc1<=59 & hv103==1 & hml33==0 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 mal_micmalpos if hc1>=6 & hc1<=59 & hv103==1 & hml33==0 using Tables_MALARIA.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Parasitemia (vis RDT) in children 6-59 months

*residence
tab hv025 mal_rdtmalpos if hc1>=6 & hc1<=59 & hv103==1 & hml33==0 [iw=wt], row nofreq 

*region
tab hv024 mal_rdtmalpos if hc1>=6 & hc1<=59 & hv103==1 & hml33==0 [iw=wt], row nofreq 

*wealth
tab hv270 mal_rdtmalpos if hc1>=6 & hc1<=59 & hv103==1 & hml33==0 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 mal_rdtmalpos if hc1>=6 & hc1<=59 & hv103==1 & hml33==0 using Tables_MALARIA.xls [iw=wt] , c(row) f(1) append 



* indicators from IR file
if file=="IR" 
gen wt=v005/1000000


****************************************************
//Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received one or more doses of SP/Fansidar

*residence
tab v025 mal_one_iptp if mal_agemnth < 24 [iw=wt], row nofreq 

*region
tab v024 mal_one_iptp if mal_agemnth < 24 [iw=wt], row nofreq 

*wealth
tab v190 mal_one_iptp if mal_agemnth < 24 [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v190 mal_one_iptp if mal_agemnth < 24 using Tables_IPTP.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received two or more doses of SP/Fansidar

*residence
tab v025 mal_two_iptp if mal_agemnth < 24 [iw=wt], row nofreq 

*region
tab v024 mal_two_iptp if mal_agemnth < 24 [iw=wt], row nofreq 

*wealth
tab v190 mal_two_iptp if mal_agemnth < 24 [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v190 mal_two_iptp if mal_agemnth < 24 using Tables_IPTP.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received three or more doses of SP/Fansidar

*residence
tab v025 mal_three_iptp if mal_agemnth < 24 [iw=wt], row nofreq 

*region
tab v024 mal_three_iptp if mal_agemnth < 24 [iw=wt], row nofreq 

*wealth
tab v190 mal_three_iptp if mal_agemnth < 24 [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v190 mal_three_iptp if mal_agemnth < 24 using Tables_IPTP.xls [iw=wt] , c(row) f(1) append 




* indicators from KR file
if file=="KR" 
gen wt=v005/1000000


****************************************************
//Children under age 5 years with fever in the 2 weeks preceding the survey

*residence
tab v025 mal_fever if b5==1 & mal_agemnth<60 [iw=wt], row nofreq 

*region
tab v024 mal_fever if b5==1 & mal_agemnth<60 [iw=wt], row nofreq 

*wealth
tab v190 mal_fever if b5==1 & mal_agemnth<60 [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v190 mal_fever if b5==1 & mal_agemnth<60 using Tables_FEVER.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey, percentage for whom advice or treatment was sought

*residence
tab v025 mal_soughtcare if mal_fever==1 & b5==1 & mal_agemnth < 60 [iw=wt], row nofreq 

*region
tab v024 mal_soughtcare if mal_fever==1 & b5==1 & mal_agemnth < 60 [iw=wt], row nofreq 

*wealth
tab v190 mal_soughtcare if mal_fever==1 & b5==1 & mal_agemnth < 60 [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v190 mal_soughtcare if mal_fever==1 & b5==1 & mal_agemnth < 60 using Tables_FEVER.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Children under age 5 years with fever in the 2 weeks preceding the survey who had blood taken from a finger or heel for testing

*residence
tab v025 mal_stick if mal_fever==1 & b5==1 & mal_agemnth < 60 [iw=wt], row nofreq 

*region
tab v024 mal_stick if mal_fever==1 & b5==1 & mal_agemnth < 60 [iw=wt], row nofreq 

*wealth
tab v190 mal_stick if mal_fever==1 & b5==1 & mal_agemnth < 60 [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v190 mal_stick if mal_fever==1 & b5==1 & mal_agemnth < 60 using Tables_FEVER.xls [iw=wt] , c(row) f(1) append 


****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took an ACT

*residence
tab v025 mal_act if mal_fever==1 & mal_antimal==1 & b5==1 & mal_agemnth < 60 [iw=wt], row nofreq 

*region
tab v024 mal_act if mal_fever==1 & mal_antimal==1 & b5==1 & mal_agemnth < 60[iw=wt], row nofreq 

*wealth
tab v190 mal_act if mal_fever==1 & mal_antimal==1 & b5==1 & mal_agemnth < 60 [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v190 mal_act if mal_fever==1 & mal_antimal==1 & b5==1 & mal_agemnth < 60 using Tables_FEVER.xls [iw=wt] , c(row) f(1) append 
