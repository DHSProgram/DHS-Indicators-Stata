/*****************************************************************************************************
Program: 			ML_tables.do
Purpose: 			produce tables for indicators
Author:				Cameron Taylor
Date last modified: Feb 19 2019 by Cameron Taylor

*Note this do file will produce the following tables in excel:
	1. 	Tables_HH_ITN:		Contains the tables for houeshold possession of ITNs 
	2.  Tables_HH_ITN_USE:	Contains the tables for ITN use among de facto population, children, and pregnant women
	3.  Tables_MAL_ANEMIA:	Contains the table for children 6–59 months old tested for anemia and tables for children with severe anemia (<8.0 g/dL)
	4. 	Tables_MALARIA:		Contains the table for children 6-59 months old tested for malaria and children with malaria infection via RDT and microscopy
	5. 	Tables_IPTP:		Contains tables on IPTp uptake
	6. 	Tables_FEVER:		Contains tables on fever careseeking for children under 5 (fever, treatment seeking)
	7. 	Tables_Antimal:		Contains tables for antimalarial drugs
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from HR file
if file=="HR" {
gen wt=hv005/1000000
**************************************************************************************************
* Indicators for household ownership of nets
**************************************************************************************************
//Household ownership of one mosquito net

*residence
tab hv025 ml_mosquitonet  [iw=wt], row nofreq 

*region
tab hv024 ml_mosquitonet [iw=wt], row nofreq 

*wealth
tab hv270 ml_mosquitonet [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_mosquitonet using Tables_HH_ITN.xls [iw=wt] , c(row) f(1) replace 
*/
****************************************************
//Household ownership of ITNs

*residence
tab hv025 ml_itnhh  [iw=wt], row nofreq 

*region
tab hv024 ml_itnhh [iw=wt], row nofreq 

*wealth
tab hv270 ml_itnhh [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_itnhh using Tables_HH_ITN.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Average number of mosquito nets per household

*residence
bysort hv025: sum ml_numnets [iw=wt]

*region
bysort hv024: sum ml_numnets [iw=wt]

*wealth
bysort hv270: sum ml_numnets [iw=wt]

* output to excel
tabout hv025 hv024 hv270 using Tables_HH_ITN.xls [fw=hv005], clab("avg_num_mosquito_net_in_HH") oneway sum cells(mean ml_numnets) f(1) append 
*/
****************************************************
//Average number of ITNs per household

*residence
bysort hv025: sum ml_numitnhh [iw=wt]

*region
bysort hv024: sum ml_numitnhh [iw=wt]

*wealth
bysort hv270: sum ml_numitnhh [iw=wt]

* output to excel
tabout hv025 hv024 hv270 using Tables_HH_ITN.xls [fw=hv005], clab("avg_num_ITN_in_HH") oneway sum cells(mean ml_numitnhh) f(1) append 
*/
****************************************************
//Households with at least one mosquito net for every 2 persons 

*residence
tab hv025 ml_mosnethhaccess if hv013>=1 [iw=wt], row nofreq 

*region
tab hv024 ml_mosnethhaccess if hv013>=1 [iw=wt], row nofreq 

*wealth
tab hv270 ml_mosnethhaccess if hv013>=1 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_mosnethhaccess using Tables_HH_ITN.xls [iw=wt] , c(row) f(1) append 
*/
****************************************************
//Households with at least one ITN for every 2 persons 

*residence
tab hv025 ml_hhaccess if hv013>=1 [iw=wt], row nofreq 

*region
tab hv024 ml_hhaccess if hv013>=1 [iw=wt], row nofreq 

*wealth
tab hv270 ml_hhaccess if hv013>=1 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_hhaccess if hv013>=1 using Tables_HH_ITN.xls [iw=wt] , c(row) f(1) append 
*/

}

* indicators from PR file
if file=="PR" {
gen wt=hv005/1000000
**************************************************************************************************
* Indicators for population who slept under a net or ITN the night before the survey
**************************************************************************************************
//De facto household population who slept the night before the survey under a mosquito net (treated or untreated)

recode hv105 (0/4=1 "<5") (5/14=2 "5-14") (15/34=3 "15-34") (35/49=4 "35-49") (else=5 "50+"), gen(age)

*age of household memeber
tab age ml_slept_net if hv103==1 [iw=wt], row nofreq

*sex of household member
tab hv104 ml_slept_net if hv103==1 [iw=wt], row nofreq

*residence
tab hv025 ml_slept_net if hv103==1 [iw=wt], row nofreq 

*region
tab hv024 ml_slept_net if hv103==1 [iw=wt], row nofreq 

*wealth
tab hv270 ml_slept_net if hv103==1 [iw=wt], row nofreq 

* output to excel
tabout age hv104 hv025 hv024 hv270 ml_slept_net if hv103==1 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) replace 
****************************************************
//De facto household population who slept the night before the survey under an ITN

*age of household memeber
tab age ml_slept_itn if hv103==1 [iw=wt], row nofreq

*sex of household member
tab hv104 ml_slept_itn if hv103==1 [iw=wt], row nofreq

*residence
tab hv025 ml_slept_itn if hv103==1 [iw=wt], row nofreq 

*region
tab hv024 ml_slept_itn if hv103==1 [iw=wt], row nofreq 

*wealth
tab hv270 ml_slept_itn if hv103==1 [iw=wt], row nofreq 

* output to excel
tabout age hv104 hv025 hv024 hv270 ml_slept_itn if hv103==1 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Children under age 5 who slept the night before the survey under a mosquito net (treated or untreated)
*sex of child
tab hv104 ml_slept_itn if hv103==1 & hml16<5 [iw=wt], row nofreq

*residence
tab hv025 ml_slept_net if hv103==1 & hml16<5 [iw=wt], row nofreq 

*region
tab hv024 ml_slept_net if hv103==1 & hml16<5 [iw=wt], row nofreq 

*wealth
tab hv270 ml_slept_net if hv103==1 & hml16<5 [iw=wt], row nofreq 

* output to excel
tabout hv104 hv025 hv024 hv270 ml_slept_net if hv103==1 & hml16<5 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 


****************************************************
//Children under age 5 who slept the night before the survey under an ITN
*sex of child
tab hv104 ml_slept_itn if hv103==1 & hml16<5 [iw=wt], row nofreq 

*residence
tab hv025 ml_slept_itn if hv103==1 & hml16<5 [iw=wt], row nofreq 

*region
tab hv024 ml_slept_itn if hv103==1 & hml16<5 [iw=wt], row nofreq 

*wealth
tab hv270 ml_slept_itn if hv103==1 & hml16<5 [iw=wt], row nofreq 

* output to excel
tabout hv104 hv025 hv024 hv270 ml_slept_itn if hv103==1 & hml16<5 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Pregnant women age 15-49 who slept the night before the survey under a mosquito net (treated or untreated)

*residence
tab hv025 ml_slept_net if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

*region
tab hv024 ml_slept_net if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

*wealth
tab hv270 ml_slept_net if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_slept_net if hv103==1 & hv104==2 & hml18==1 & hml16>=15 & hml16<=49 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 


****************************************************
//Pregnant women age 15-49 who slept the night before the survey under an ITN

*residence
tab hv025 ml_slept_itn if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

*region
tab hv024 ml_slept_itn if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

*wealth
tab hv270 ml_slept_itn if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_slept_itn if hv103==1 & hv104==2 & hml18==1 & hml16>=15 & hml16<=49 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 

**************************************************************************************************
* Indicators for anemia and malaria testing and prevalence: 
* Note: Testing indicators are not weighted
**************************************************************************************************
//Tested for Anemia

* sex of child
tab hc27 ml_test_anemia, row nofreq 

*residence
tab hv025 ml_test_anemia, row nofreq 

*region
tab hv024 ml_test_anemia, row nofreq 

*wealth
tab hv270 ml_test_anemia, row nofreq 

* output to excel
tabout hc27 hv025 hv024 hv270 ml_test_anemia using Tables_MAL_ANEMIA.xls , c(row) f(1) replace 

****************************************************
//Children with hemoglobin lower than 8.0 g/dl
*sex of child
tab hc27 ml_anemia [iw=wt], row nofreq 

*residence
tab hv025 ml_anemia [iw=wt], row nofreq 

*region
tab hv024 ml_anemia [iw=wt], row nofreq 

*wealth
tab hv270 ml_anemia  [iw=wt], row nofreq 

* output to excel
tabout hc27 hv025 hv024 hv270 ml_anemia  using Tables_MAL_ANEMIA.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Testing of Parasitemia (via microscopy) in children 6-59 months

*sex of child 
tab hc27 ml_test_micmal, row nofreq 

*residence
tab hv025 ml_test_micmal, row nofreq 

*region
tab hv024 ml_test_micmal, row nofreq 

*wealth
tab hv270 ml_test_micmal, row nofreq 

* output to excel
tabout hc27 hv025 hv024 hv270 ml_test_micmal using Tables_MALARIA.xls, c(row) f(1) replace 

****************************************************
//Parasitemia (via microscopy) in children 6-59 months

*sex of child
tab hc27 ml_micmalpos [iw=wt], row nofreq 

*residence
tab hv025 ml_micmalpos [iw=wt], row nofreq 

*region
tab hv024 ml_micmalpos [iw=wt], row nofreq 

*wealth
tab hv270 ml_micmalpos [iw=wt], row nofreq 

* output to excel
tabout hc27 hv025 hv024 hv270 ml_micmalpos using Tables_MALARIA.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Testing of Parasitemia (vis RDT) in children 6-59 months

* sex of child
tab hc27 ml_test_rdtmal , row nofreq 

*residence
tab hv025 ml_test_rdtmal, row nofreq 

*region
tab hv024 ml_test_rdtmal, row nofreq 

*wealth
tab hv270 ml_test_rdtmal, row nofreq 

* output to excel
tabout hc27 hv025 hv024 hv270 ml_test_rdtmal using Tables_MALARIA.xls, c(row) f(1) append 
****************************************************
//Parasitemia (vis RDT) in children 6-59 months

* sex of child
tab hc27 ml_rdtmalpos [iw=wt], row nofreq 

*residence
tab hv025 ml_rdtmalpos [iw=wt], row nofreq 

*region
tab hv024 ml_rdtmalpos [iw=wt], row nofreq 

*wealth
tab hv270 ml_rdtmalpos [iw=wt], row nofreq 

* output to excel
tabout hc27 hv025 hv024 hv270 ml_rdtmalpos  using Tables_MALARIA.xls [iw=wt] , c(row) f(1) append 
****************************************************
}


* indicators from IR file
if file=="IR" {
gen wt=v005/1000000

****************************************************
//Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received one or more doses of SP/Fansidar

*residence
tab v025 ml_one_iptp [iw=wt], row nofreq 

*region
tab v024 ml_one_iptp [iw=wt], row nofreq 

*education
tab v106 ml_one_iptp [iw=wt], row nofreq 

*wealth
tab v190 ml_one_iptp [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v106 v190 ml_one_iptp using Tables_IPTP.xls [iw=wt] , c(row) f(1) replace 

****************************************************
//Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received two or more doses of SP/Fansidar

*residence
tab v025 ml_two_iptp [iw=wt], row nofreq 

*region
tab v024 ml_two_iptp [iw=wt], row nofreq 

*education
tab v106 ml_two_iptp [iw=wt], row nofreq 

*wealth
tab v190 ml_two_iptp [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v106 v190 ml_two_iptp using Tables_IPTP.xls [iw=wt] , c(row) f(1) append 

****************************************************
//Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received three or more doses of SP/Fansidar

*residence
tab v025 ml_three_iptp [iw=wt], row nofreq 

*region
tab v024 ml_three_iptp [iw=wt], row nofreq 

*education
tab v106 ml_three_iptp [iw=wt], row nofreq 

*wealth
tab v190 ml_three_iptp [iw=wt], row nofreq 

* output to excel
tabout v025 v024 v106 v190 ml_three_iptp using Tables_IPTP.xls [iw=wt] , c(row) f(1) append 

}


* indicators from KR file
if file=="KR" {
gen wt=v005/1000000

* Child's age as background variable for tables
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

recode age (0/11=1 "<12") (12/23=2 "12-23") (24/35=3 "24-35") (36/47=4 "36-47") (48/60=5 "48-59"), gen(agecat)
****************************************************
*** Fever and care seeking for fever ***
****************************************************
//Children under age 5 years with fever in the 2 weeks preceding the survey

*child's age
tab agecat ml_fever [iw=wt], row nofreq 

*child's sex
tab b4 ml_fever [iw=wt], row nofreq 

*residence
tab v025 ml_fever [iw=wt], row nofreq 

*region
tab v024 ml_fever [iw=wt], row nofreq 

*mother's education
tab v106 ml_fever [iw=wt], row nofreq 

*wealth
tab v190 ml_fever [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_fever using Tables_FEVER.xls [iw=wt] , c(row) f(1) replace 

****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey, percentage for whom advice or treatment was sought

*child's age
tab agecat ml_fev_care [iw=wt], row nofreq 

*child's sex
tab b4 ml_fev_care [iw=wt], row nofreq 

*residence
tab v025 ml_fev_care [iw=wt], row nofreq 

*region
tab v024 ml_fev_care [iw=wt], row nofreq 

*mother's education
tab v106 ml_fev_care [iw=wt], row nofreq 

*wealth
tab v190 ml_fev_care [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_fev_care using Tables_FEVER.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey, percentage for whom advice or treatment was sought the same or next day

*child's age
tab agecat ml_fev_care_day [iw=wt], row nofreq 

*child's sex
tab b4 ml_fev_care_day [iw=wt], row nofreq 

*residence
tab v025 ml_fev_care_day [iw=wt], row nofreq 

*region
tab v024 ml_fev_care_day [iw=wt], row nofreq 

*mother's education
tab v106 ml_fev_care_day [iw=wt], row nofreq 

*wealth
tab v190 ml_fev_care_day [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_fev_care_day using Tables_FEVER.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Children under age 5 years with fever in the 2 weeks preceding the survey who had blood taken from a finger or heel for testing

*child's age
tab agecat ml_stick [iw=wt], row nofreq 

*child's sex
tab b4 ml_stick [iw=wt], row nofreq 

*residence
tab v025 ml_stick [iw=wt], row nofreq 

*region
tab v024 ml_stick [iw=wt], row nofreq 

*mother's education
tab v106 ml_stick [iw=wt], row nofreq 

*wealth
tab v190 ml_stick [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_stick using Tables_FEVER.xls [iw=wt] , c(row) f(1) append 
****************************************************
*** Source of advice or treatment for fever symptoms ***
* only the following sources are computed, to get other sources that are country specific, please see the note on these indicators in the ML_FEVER.do file

* among children with fever symtoms
tab1 ml_fev_govh ml_fev_govcent ml_fev_pclinc ml_fev_pdoc ml_fev_pharm [iw=wt]

* output to excel
tabout ml_fev_govh ml_fev_govcent ml_fev_pclinc ml_fev_pdoc ml_fev_pharm using Tables_FEVER.xls [iw=wt], oneway cells(cell) f(1) append 

* among children with fever symtoms whom advice or treatment was sought
tab1 ml_fev_govh_trt ml_fev_govcent_trt ml_fev_pclinc_trt ml_fev_pdoc_trt ml_fev_pharm_trt [iw=wt]	

* output to excel
tabout ml_fev_govh_trt ml_fev_govcent_trt ml_fev_pclinc_trt ml_fev_pdoc_trt ml_fev_pharm_trt using Tables_FEVER.xls [iw=wt] , oneway cells(cell) f(1) append 
**************************************************************************************************
****************************************************
*** Antimalarial drugs***
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took an ACT

*child's age
tab agecat ml_act [iw=wt], row nofreq 

*child's sex
tab b4 ml_act [iw=wt], row nofreq 

*residence
tab v025 ml_act [iw=wt], row nofreq 

*region
tab v024 ml_act [iw=wt], row nofreq 

*mother's education
tab v106 ml_act [iw=wt], row nofreq 

*wealth
tab v190 ml_act [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_act using Tables_Antimal.xls [iw=wt] , c(row) f(1) replace 
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took SP/Fansider

*child's age
tab agecat ml_sp_fan [iw=wt], row nofreq 

*child's sex
tab b4 ml_sp_fan [iw=wt], row nofreq 

*residence
tab v025 ml_sp_fan [iw=wt], row nofreq 

*region
tab v024 ml_sp_fan [iw=wt], row nofreq 

*mother's education
tab v106 ml_sp_fan [iw=wt], row nofreq 

*wealth
tab v190 ml_sp_fan [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_sp_fan using Tables_Antimal.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Chloroquine

*child's age
tab agecat ml_chloro [iw=wt], row nofreq 

*child's sex
tab b4 ml_chloro [iw=wt], row nofreq 

*residence
tab v025 ml_chloro [iw=wt], row nofreq 

*region
tab v024 ml_chloro [iw=wt], row nofreq 

*mother's education
tab v106 ml_chloro [iw=wt], row nofreq 

*wealth
tab v190 ml_chloro [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_chloro using Tables_Antimal.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Amodiaquine

*child's age
tab agecat ml_amodia [iw=wt], row nofreq 

*child's sex
tab b4 ml_amodia [iw=wt], row nofreq 

*residence
tab v025 ml_amodia [iw=wt], row nofreq 

*region
tab v024 ml_amodia [iw=wt], row nofreq 

*mother's education
tab v106 ml_amodia [iw=wt], row nofreq 

*wealth
tab v190 ml_amodia [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_amodia using Tables_Antimal.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Quinine pills

*child's age
tab agecat ml_quin_pill [iw=wt], row nofreq 

*child's sex
tab b4 ml_quin_pill [iw=wt], row nofreq 

*residence
tab v025 ml_quin_pill [iw=wt], row nofreq 

*region
tab v024 ml_quin_pill [iw=wt], row nofreq 

*mother's education
tab v106 ml_quin_pill [iw=wt], row nofreq 

*wealth
tab v190 ml_quin_pill [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_quin_pill using Tables_Antimal.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Quinine injection or IV

*child's age
tab agecat ml_quin_inj [iw=wt], row nofreq 

*child's sex
tab b4 ml_quin_inj [iw=wt], row nofreq 

*residence
tab v025 ml_quin_inj [iw=wt], row nofreq 

*region
tab v024 ml_quin_inj [iw=wt], row nofreq 

*mother's education
tab v106 ml_quin_inj [iw=wt], row nofreq 

*wealth
tab v190 ml_quin_inj [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_quin_inj using Tables_Antimal.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Artesunate rectal

*child's age
tab agecat ml_artes_rec [iw=wt], row nofreq 

*child's sex
tab b4 ml_artes_rec [iw=wt], row nofreq 

*residence
tab v025 ml_artes_rec [iw=wt], row nofreq 

*region
tab v024 ml_artes_rec [iw=wt], row nofreq 

*mother's education
tab v106 ml_artes_rec [iw=wt], row nofreq 

*wealth
tab v190 ml_artes_rec [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_artes_rec using Tables_Antimal.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Artesunate injection or intravenous

*child's age
tab agecat ml_artes_inj  [iw=wt], row nofreq 

*child's sex
tab b4 ml_artes_inj [iw=wt], row nofreq 

*residence
tab v025 ml_artes_inj [iw=wt], row nofreq 

*region
tab v024 ml_artes_inj [iw=wt], row nofreq 

*mother's education
tab v106 ml_artes_inj [iw=wt], row nofreq 

*wealth
tab v190 ml_artes_inj [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_artes_inj using Tables_Antimal.xls [iw=wt] , c(row) f(1) append 
****************************************************
//Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took other antimalarial

*child's age
tab agecat ml_antimal_other  [iw=wt], row nofreq 

*child's sex
tab b4 ml_antimal_other [iw=wt], row nofreq 

*residence
tab v025 ml_antimal_other [iw=wt], row nofreq 

*region
tab v024 ml_antimal_other [iw=wt], row nofreq 

*mother's education
tab v106 ml_antimal_other [iw=wt], row nofreq 

*wealth
tab v190 ml_antimal_other [iw=wt], row nofreq 

* output to excel
tabout agecat b4 v025 v024 v106 v190 ml_antimal_other using Tables_Antimal.xls [iw=wt] , c(row) f(1) append 
****************************************************
}
