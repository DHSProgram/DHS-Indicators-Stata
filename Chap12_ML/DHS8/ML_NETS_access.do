/*****************************************************************************************************
Program: 			ML_NETS_access.do - DHS8 update
Purpose: 			POPULATION ACCESS TO ITNS and POPULATION/CHILD/PREGNANT WOMEN USE OF ITNS AMONG HH WITH ITNs
Data inputs: 		HR and PR dataset
Data outputs:		coded variables and the tables Tables_ITN_access.xls and Tables_HH_ITN_USE.xls for the tabulations for the indicators
Author:				Cameron Taylor and modified by Shireen Assaf for the code share project
Date last modified: July 11, 2023 by Shireen Assaf
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_pop_access		"Population with access to an ITN"
ml_slept_itn_hhitn	"Slept under an ITN last night amound household population with at least 1 ITN"
----------------------------------------------------------------------------*/
*** Percentage of the population with access to an ITN ***

*open HR file
use "$datapath//$hrdata.dta", clear

sort hv001 hv002
*
//Number of ITNs per household
	gen ml_numitnhh=0 
		forvalues x=1/7 {
			gen itnhh_0`x'=(hml10_`x'==1)
		}
	replace ml_numitnhh=itnhh_01 + itnhh_02 + itnhh_03 + itnhh_04 + itnhh_05 + itnhh_06 + itnhh_07
	lab var ml_numitnhh "Number of ITNs per household"
*/
save "HRmerge.dta", replace

*Merge pr file hr file
use "$datapath//$prdata.dta", clear
sort hv001 hv002

	merge hv001 hv002 using "HRmerge.dta"
	tab _merge
	
//Households with > 1 ITN per 2 members
*Potential users divided by defacto household members is greater or equal to one
cap drop ml_potuse
gen ml_potuse = ml_numitnhh*2 // Potential ITN users in Household
lab var ml_potuse "Potential ITN users in household"

//Population with access to an ITN
	bysort hhid: gen ml_pop_access = ml_potuse /hv013
	replace ml_pop_access=1 if ml_potuse /hv013 >1
	lab var ml_pop_access "Population with access to an ITN"

*******************************************************************************
*Table for access
********************************************************************************
gen wt=hv005/1000000

*Percent of population with access to an ITN by background variables
*The percentage would be the mean shown in output times 100
*residence
bysort hv025: sum ml_pop_access if hv103==1 [iw=wt]

*region
bysort hv024: sum ml_pop_access if hv103==1 [iw=wt]

*wealth
bysort hv270: sum ml_pop_access if hv103==1 [iw=wt]

*output to excel
*The percentage would be the mean shown in output times 100
tabout hv025 hv024 hv270 if hv103==1 using Tables_ITN_access.xls [fw=hv005], oneway sum cells(mean ml_pop_access) f(3) append 

**********************************************************************************************
**********************************************************************************************

do ML_NETS_use.do

//Slept under an ITN last night among households with at least 1 ITN
gen ml_slept_itn_hhitn=0 if (hml10_1==1|hml10_2==1|hml10_3==1|hml10_4==1|hml10_5==1|hml10_6==1|hml10_7==1)
replace ml_slept_itn_hhitn=1 if (ml_netcat==1)
label var ml_slept_itn_hhitn "Slept under an ITN last night amound household population with at least 1 ITN"

*Tables by background variables

*** Overall Population ***
*age of household memeber
recode hv105 (0/4=1 "<5") (5/14=2 "5-14") (15/34=3 "15-34") (35/49=4 "35-49") (50/95=5 "50+") (96/99=.), gen(age)
tab age ml_slept_itn_hhitn if hv103==1 [iw=wt], row nofreq

*sex of household member
tab hv104 ml_slept_itn_hhitn if hv103==1 [iw=wt], row nofreq

*residence
tab hv025 ml_slept_itn_hhitn if hv103==1 [iw=wt], row nofreq 

*region
tab hv024 ml_slept_itn_hhitn if hv103==1 [iw=wt], row nofreq 

*wealth
tab hv270 ml_slept_itn_hhitn if hv103==1 [iw=wt], row nofreq 

* output to excel
tabout age hv104 hv025 hv024 hv270 ml_slept_itn_hhitn if hv103==1 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 

*** Children under 5 ***
*sex of child
tab hv104 ml_slept_itn_hhitn if hv103==1 & hml16<5 [iw=wt], row nofreq

*residence
tab hv025 ml_slept_itn_hhitn if hv103==1 & hml16<5 [iw=wt], row nofreq 

*region
tab hv024 ml_slept_itn_hhitn if hv103==1 & hml16<5 [iw=wt], row nofreq 

*wealth
tab hv270 ml_slept_itn_hhitn if hv103==1 & hml16<5 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_slept_itn_hhitn if hv103==1 & hml16<5 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 

*** Pregnant women age 15-49 ***

*residence
tab hv025 ml_slept_itn_hhitn if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

*region
tab hv024 ml_slept_itn_hhitn if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

*wealth
tab hv270 ml_slept_itn_hhitn if hv103==1 & hv104==2 & hml18==1 & hml16 >=15 & hml16<=49 [iw=wt], row nofreq 

* output to excel
tabout hv025 hv024 hv270 ml_slept_itn_hhitn if hv103==1 & hv104==2 & hml18==1 & hml16>=15 & hml16<=49 using Tables_HH_ITN_USE.xls [iw=wt] , c(row) f(1) append 


