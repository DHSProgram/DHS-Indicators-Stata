/*****************************************************************************************************
Program: 			PH_POP.do
Purpose: 			Code to compute population characteristics, birth registration, household composition, orphanhood, and living arrangments
Data inputs: 		PR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: April 23, 2020 by Shireen Assaf 
Note:				In line 244 the code will collapse the data and therefore some indicators produced will be lost. However, they are saved in the file PR_temp_children.dta and this data file will be used to produce the tables for these indicators in the PH_table code. This code will produce the Tables_hh_comps for household composition. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

ph_pop_age			"De facto population by five-year age groups"
ph_pop_depend		"De facto population by dependency age groups"
ph_pop_cld_adlt		"De facto population by child and adult populations"
ph_pop_adols		"De factor population that are adolesents"
	
ph_birthreg_cert	"Child under 5 with registered birth and birth certificate"
ph_birthreg_nocert	"Child under 5 with registered birth and no birth certificate"
ph_birthreg			"Child under 5 with registered birth"

ph_hhhead_sex		"Sex of household head"
ph_num_members		"Number of usual household members"
	
ph_orph_double		"Double orphans under age 18"
ph_orph_single		"Single orphans under age 18"
ph_foster			"Foster children under age 18"
ph_orph_foster		"Orphans and/or foster children under age 18"
	
ph_chld_liv_arrang	"Living arrangement and parents survival status for child under 18"
ph_chld_liv_noprnt	"Child under 18 not living with a biological parent"
ph_chld_orph		"Child under 18 with one or both parents dead"
----------------------------------------------------------------------------*/

*** Population characteristics ***

 gen ager=int(hv105/5) if hv103==1

//Five year age groups
recode ager	(0=0 " <5") (1=1 " 5-9") (2=2 " 10-14") (3=3  " 15-19") (4=4 " 20-24") (5=5 " 25-29") (6=6 "30-34") ///
			(7=7 " 35-39") (8=8 " 40-44") (9=9 " 45-49") (10=10 " 50-54") (11=11 " 55-59") (12=12 " 60-64") ///
			(13=13 " 65-69") (14=14 " 70-74") (15=15 " 75-79") (16/18=16 " 80+") (19/max=98 "Don't know/missing"), gen(ph_pop_age)
replace ph_pop_age=16 if hv105==95 & hv103==1
label var ph_pop_age "De facto population by five-year age groups"

//Dependency age groups
recode ager	(0/2=1 " 0-14") (3/12=2 " 15-64") (13/18=3 " 65+") (19/max=98 "Don't know/missing"), gen(ph_pop_depend)
replace ph_pop_age=3 if hv105==95 & hv103==1
label var ph_pop_depend "De facto population by dependency age groups"

//Child and adult populations
recode hv105 (0/17=1 " 0-17") (18/97=2 " 18+") (98/max=98 "Don't know/missing") if hv103==1, gen(ph_pop_cld_adlt)
label var ph_pop_cld_adlt "De facto population by child and adult populations"

//Adolescent population
recode hv105 (10/19=1 " Adolescents") (else=0 " not adolesents") if hv103==1, gen(ph_pop_adols)
label var ph_pop_adols "De factor population that are adolesents"

*** Birth registration ***
//Child registered and with birth certificate
gen ph_birthreg_cert= hv140==1 if hv102==1 & hv105<5
label values ph_birthreg_cert yesno	
label var ph_birthreg_cert "Child under 5 with registered birth and birth certificate"

//Child registered and with no birth certificate
gen ph_birthreg_nocert= hv140==2 if hv102==1 & hv105<5
label values ph_birthreg_nocert yesno
label var ph_birthreg_nocert "Child under 5 with registered birth and no birth certificate"

//Child is registered
gen ph_birthreg= inrange(hv140,1,2) if hv102==1 & hv105<5
label values ph_birthreg yesno
label var ph_birthreg "Child under 5 with registered birth"
 

*** Living arrangments ***

* IMPORTANT: Children must be de jure residents AND coresidence with parents requires that
* the parents are also de jure residents

* add a code 99 to hv112 if the mother is in the hh but is not de jure
* add a code 99 to hv114 if the mother is in the hh but is not de jure

* Preparing files to produce the indicators, this required several merges

keep hv001 hv002 hvidx hv005 hv009 hv024 hv025 hv101-hv105 hv111-hv114 hv270 ph_*
save PR_temp.dta, replace

* Prepare a file of potential mothers
use PR_temp.dta, clear
drop if hv104==1
drop if hv105<15
keep hv001 hv002 hvidx hv102
gen in_mothers=1
rename hv102 hv102_mo
rename hvidx hv112
sort hv001 hv002 hv112
save PR_temp_mothers.dta, replace

* Prepare a file of potential fathers
use PR_temp.dta, clear
drop if hv104==2
drop if hv105<15
keep hv001 hv002 hvidx hv102
gen in_fathers=1
rename hv102 hv102_fa
rename hvidx hv114
sort hv001 hv002 hv114
save PR_temp_fathers.dta, replace

* Prepare file of children for merges
use PR_temp.dta, clear
drop if hv102==0
drop if hv105>17
gen in_children=1

* Merge children with potential mothers
sort hv001 hv002 hv112
merge hv001 hv002 hv112 using PR_temp_mothers.dta
rename _merge _merge_child_mother

* Merge children with potential fathers
sort hv001 hv002 hv114
merge hv001 hv002 hv114 using PR_temp_fathers.dta
rename _merge _merge_child_father

gen hv112r=hv112
gen hv114r=hv114

* Code 99 of the mother or father is not de jure
replace hv112r=99 if hv112>0 & hv102_mo==0
replace hv114r=99 if hv114>0 & hv102_fa==0

keep if in_children==1
drop in_* _merge*

label define HV112R 0 "Mother not in household" 99 "In hh but not de jure"
label define HV114R 0 "Father not in household" 99 "In hh but not de jure"

label values hv112r HV112R
label values hv114r HV114R

tab1 hv112r hv114r

//Living arrangement for children under 18
gen orphan_type=.
replace orphan_type=1 if hv111==1 & hv113==1
replace orphan_type=2 if hv111==1 & hv113==0
replace orphan_type=3 if hv111==0 & hv113==1
replace orphan_type=4 if hv111==0 & hv113==0
replace orphan_type=5 if hv111>1  | hv113>1

gen cores_type=.
replace cores_type=1 if (hv112r>0  & hv112r<99)  & (hv114r>0  & hv114r<99)
replace cores_type=2 if (hv112r>0  & hv112r<99)  & (hv114r==0 | hv114r==99)
replace cores_type=3 if (hv112r==0 | hv112r==99) & (hv114r>0  & hv114r<99)
replace cores_type=4 if (hv112r==0 | hv112r==99) & (hv114r==0 | hv114r==99)

gen ph_chld_liv_arrang=.
replace ph_chld_liv_arrang=1  if cores_type==1
replace ph_chld_liv_arrang=2  if cores_type==2 & (orphan_type==1 | orphan_type==3)  
replace ph_chld_liv_arrang=3  if cores_type==2 & (orphan_type==2 | orphan_type==4)
replace ph_chld_liv_arrang=4  if cores_type==3 & (orphan_type==1 | orphan_type==2)
replace ph_chld_liv_arrang=5  if cores_type==3 & (orphan_type==3 | orphan_type==4)
replace ph_chld_liv_arrang=6  if cores_type==4 & orphan_type==1
replace ph_chld_liv_arrang=7  if cores_type==4 & orphan_type==3
replace ph_chld_liv_arrang=8  if cores_type==4 & orphan_type==2
replace ph_chld_liv_arrang=9  if cores_type==4 & orphan_type==4
replace ph_chld_liv_arrang=10 if orphan_type==5

#delimit ;
label define orphan_type 1 "Both parents alive" 2 "Mother alive, father dead" 
3 "Father alive, mother dead" 4 "Both parents dead" 5 "Info missing";

label define cores_type 1 "Living with both parents" 2 "With mother, not father" 
3 "With father, not mother" 4 "Living with neither parent";

label define ph_chld_liv_arrang 1 "With both parents" 2 "With mother only, father alive" 
3 "With mother only, father dead" 4 "With father only, mother alive" 
5 "With father only, mother dead" 6 "With neither, both alive" 
7 "With neither, only father alive" 8 "With neither, only mother alive" 
9 "With neither, both dead" 10 "Survival info missing"; 
#delimit cr

label values orphan_type orphan_type
label values cores_type cores_type
label values ph_chld_liv_arrang ph_chld_liv_arrang
label var ph_chld_liv_arrang	"Living arrangment and parents survival status for child under 18"

//Child under 18 not living with either parent
gen     ph_chld_liv_noprnt=0
replace ph_chld_liv_noprnt=1 if ph_chld_liv_arrang>=6 & ph_chld_liv_arrang<=9 
label values ph_chld_liv_noprnt yesno
label var ph_chld_liv_noprnt	"Child under 18 not living with a biological parent"

//Child under 18 with one or both parents dead
gen     ph_chld_orph=0
replace ph_chld_orph=1 if hv111==0 | hv113==0
label values ph_chld_orph yesno
label var ph_chld_orph "Child under 18 with one or both parents dead"


*** Orphanhood ***

//Double orphan: both parents dead
gen     ph_orph_double=0
replace ph_orph_double=1 if hv111==0 & hv113==0

//Single orphan: one parent dead 
gen     ph_orph_single=0
replace ph_orph_single=1 if ph_chld_orph==1 & ph_orph_double==0

//Foster child: not living with a parent but one or more parents alive
gen     ph_foster=0
replace ph_foster=1 if cores_type==4 

//Foster child and/or orphan
gen     ph_orph_foster=0
replace ph_orph_foster=1 if ph_foster==1 | ph_orph_single==1 | ph_orph_double==1

sort hv001 hv002 hvidx
save PR_temp_children.dta, replace

*** Household characteristics *** 
*  Warning, this code will collapse the data and therefore the indicators produced will be lost. However, they are saved in the file PR_temp2_children.dta 

use PR_temp.dta, clear
keep if hv102==1
sort hv001 hv002 hvidx
merge hv001 hv002 hvidx using PR_temp_children.dta
drop _merge

//Household size
gen n=1
egen hhsize=count(n), by(hv001 hv002)
gen     ph_num_members=hhsize
replace ph_num_members=9 if hhsize>9 

* Sort to be sure that the head of the household (with hv101=1) is the first person listed in the household
sort hv001 hv002 hv101

* Reduce to one record per household, that of the hh head
collapse (first) hv005 hhsize ph_num_members hv104 hv025 hv024 (sum) ph_orph_double ph_orph_single ph_foster ph_orph_foster, by(hv001 hv002)

* re-attach labels after collapse
label values hv024 HV024
label values hv025 HV025
label values hv104 HV104

label define ph_num_members 1"1" 2"2" 3"3" 4"4" 5"5" 6"6" 7"7" 8"8" 9"9+"
label values ph_num_members ph_num_members

replace ph_foster=1 if ph_foster>1 
replace ph_orph_foster=1 if ph_orph_foster>1 
replace ph_orph_single=1 if ph_orph_single>1 
replace ph_orph_double=1 if ph_orph_double>1 

cap label define yesno 0"No" 1"Yes"

label values ph_foster yesno
label values ph_orph_foster yesno
label values ph_orph_single yesno
label values ph_orph_double yesno

label var ph_orph_foster "Orphans and/or foster children under age 18"
label var ph_foster "Foster children under age 18"
label var ph_orph_single "Single orphans under age 18"
label var ph_orph_double "Double orphans under age 18"

label var hv025 "type of place of residence"

//Sex of household head
rename hv104 ph_hhhead_sex
label var ph_hhhead_sex "Sex of household head"

****************************************************

*** Table for household composition ***

gen wt = hv005/1000000

//Household headship and and 
tab ph_hhhead_sex hv025 [iweight=wt], col
* export to excel
tabout ph_hhhead_sex hv025 using Tables_hh_comps.xls [iw=wt] , c(col) f(1) replace 

// Number of usual members
tab ph_num_members hv025 [iweight=wt], col
* export to excel
tabout  ph_num_members hv025 using Tables_hh_comps.xls [iw=wt] , c(col) f(1) append 

//Mean household size; use fweight
tab hv025 [fweight=hv005], summarize(hhsize) means
* export to excel
tabout hv025 using Tables_hh_comps.xls [fweight=hv005], oneway cells(mean hhsize) sum append

//Percentage of households with orphans and foster children under 18
local lvars ph_orph_double ph_orph_single ph_foster ph_orph_foster
foreach lv of local lvars {
tab `lv' hv025 [iweight=hv005/1000000], col
tabout `lv' hv025 using Tables_hh_comps.xls [iw=wt] , c(col) f(1) append 
}

****************************************************

*erase unnessary temp files
erase PR_temp_fathers.dta
erase PR_temp_mothers.dta
 