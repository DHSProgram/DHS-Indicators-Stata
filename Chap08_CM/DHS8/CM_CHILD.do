/*******************************************************************************
Program:		CM_CHILD.do - DHS8 update
Purpose:		Produce child mortality rates 
Data inputs:	BR dataset
Data outputs:	Screen, Stata .dta file with rates, and Excel file with tables 
Author:			Tom Pullum and modified by Shireen Assaf for the code share project
Date last modified:	January 31, 2024, by Tom Pullum for DHS8 
*******************************************************************************/

clear
program drop _all
set more off

/*
****************************************************************************************
PROGRAM TO PRODUCE UNDER 5 MORTALITY RATES FOR SPECIFIC WINDOWS OF TIME, WITH COVARIATES
****************************************************************************************

The 5 standard rates (also actually conditional probabilities) are as follows:

Neonatal mortality (NNMR):     the probability of dying in the first month of life;
Postneonatal mortality (PNMR): the difference between infant and neonatal mortality (similar to the
                            probability of dying during months 1 through 11, but different);
Infant mortality (IMR):	the probability of dying in the first year of life;
Child mortality (CMR):	the probability of dying between the first and fifth birthday;
Under-five mortality (U5MR):	the probability of dying before the fifth birthday.

Refer to these as q_nnmr, q_pnnmr, q_imr, q_cmr, and q_u5mr, respectively.  

When these are multiplied by 1000, they are referred to as NNMR, PNNMR, IMR, CMR, and U5MR, respectively

The set of 5 is obtained from the set of 8 as follows:

q_nnmr=q1
q_pnnmr=q_imr-qnnmr
q_imr=1-(1-q1)*(1-q2)*(1-q3)*(1-q4)
q_cmr=1-(1-q5)*(1-q6)*(1-q7)*(1-q8)
q_u5mr=1-(1-q1)*(1-q2)*(1-q3)*(1-q4)*(1-q5)*(1-q6)*(1-q7)*(1-q8)=1-(1-q_imr)*(1-q_cmr)

GO TO THE REPEATED LINES OF ASTERISKS FOR THE BEGINNING OF THE EXECUTABLE STATEMENTS

*/

********************************************************************************
* SUB-PROGRAMS OR ROUTINES BETWEEN HERE AND THE REPEATED LINES OF ASTERISKS
********************************************************************************

program define setup

scalar stype=substr(sfn,3,2)

gen stratumid=v023
gen clusterid=v021


* Specification of nageints, lengths of age intervals

/*
Standard specification but it can be changed:

i start_i  end_i  length_i
1    0        1      1  
2    1        3      2
3    3        6      3
4    6       12      6
5   12       24     12
6   24       36     12
7   36       48     12
8   48       60     12

*/

scalar nageints=8

scalar length_1=1
scalar length_2=2
scalar length_3=3
scalar length_4=6
scalar length_5=12
scalar length_6=12
scalar length_7=12
scalar length_8=12

scalar start_1=0
local i=2
while `i'<=nageints+1 {
local iminus1=`i'-1
scalar start_`i'=start_`iminus1'+length_`iminus1'
local i=`i'+1
}

local i=1
while `i'<=nageints {
local iplus1=`i'+1
scalar end_`i'=start_`iplus1'
local i=`i'+1
}

rename v008 doi
quietly summarize doi [iweight=v005/1000000]
scalar doi_mean=r(mean)
gen wt=v005/1000000.
scalar v000_string=v000[1]
save "$resultspath/temp1.dta", replace

end

********************************************************************************

program define start_month_end_month

* This routine calculates the end date and start date for the desired window of time
* It is called by prepare_child_file, which is called by make_risk_and_deaths
/*

For example, 

scalar lw=-2
scalar uw=0  

for a window from 0 to 2 years before the interview, inclusive
  (that is, three years)

lw is the lower end of the window and uw is the upper end.
(Remember that both are negative or 0.)

start_month is the cmc for the earliest month in the window and
end_month is the cmc for the latest month in the window

*/

* Section for "years before survey". lw and uw will be <=0

if lw<=0 {

* coding that WILL NOT include the month of interview in the most recent interval; matches with DHS results

gen start_month=doi+12*lw-12
gen end_month=doi+12*uw-1

}

replace end_month=min(end_month,doi)

* calculate the reference date

quietly summarize start_month [iweight=v005/1000000]
scalar mean_start_month=r(mean)

summarize end_month [iweight=v005/1000000]
scalar mean_end_month=r(mean)

* Convert back to continuous time, which requires an adjustment of half a month (i.e. -1/24).
* This adjustment is not often made but should be.
scalar srefdate=1900-(1/24)+((mean_start_month+mean_end_month)/2)/12

end

********************************************************************************

program prepare_child_file

* This routine calculates dob, doi, dod_1, dod_2, and the start and end months
*  of each age interval for each child.

* This routine calls start_month_end_month and is called by make_risk_and_deaths

use "$resultspath/temp1.dta", clear

start_month_end_month

rename b3 dob

*drop if missing on birthdate
drop if dob==.  

*drop if dob is later than the end of this time interval
drop if dob>end_month

* b7 is given in single months up to 23 and then given as 24, 36, 48, 60, ...
*  but for the Uganda 2006 survey there are 2 births at 25, 1 at 26, 1 at 35

rename b7 age_at_death
replace age_at_death=. if age_at_death>end_month
replace age_at_death=. if age_at_death>59

drop if dob+end_8<start_month-1

gen age_int_at_death=.
gen dod_1=.
gen dod_2=.

local i=1
while `i'<=nageints {
replace age_int_at_death=`i' if age_at_death>=start_`i' & age_at_death<=end_`i'-1
replace dod_1=dob+start_`i'  if age_int_at_death==`i'
replace dod_2=dob+end_`i'    if age_int_at_death==`i'
local i=`i'+1
}

drop if dod_2<start_month
replace dod_2=end_month if dod_1<= end_month & dod_2>end_month & end_month==doi-1

save "$resultspath/temp2.dta", replace

end

********************************************************************************

program define make_risk_and_deaths

prepare_child_file

use "$resultspath/temp2.dta", replace

* Values of risk and died are calculated in the following loop.  It could be streamlined
*  somewhat but you must be careful or you will lose the match with DHS.

local i=1
while `i'<=nageints {
gen died`i'=.

* age interval is entirely in the time window
replace died`i'=1  if age_int_at_death==`i' &  dod_2<=end_month   & dod_1>=start_month

* age interval is partly in the time window and partly in the previous time window
replace died`i'=.5 if age_int_at_death==`i' &  dod_2>=start_month & dod_1< start_month 

* age interval is partly in the time window and partly in the next time window
replace died`i'=.5 if age_int_at_death==`i' &  dod_2> end_month   & dod_1<=end_month

gen risk`i'=.

* age interval is entirely in the time window
replace risk`i'=1  if (age_int_at_death>=`i' | age_at_death==.) & dob+end_`i'<=end_month   & dob+start_`i'>=start_month

* age interval is partly in the time window and partly in the previous time window
replace risk`i'=.5 if (age_int_at_death>`i'  | age_at_death==.) & dob+end_`i'>=start_month & dob+start_`i'< start_month 

* age interval is partly in the time window and partly in the next time window
replace risk`i'=.5 if (age_int_at_death>`i'  | age_at_death==.) & dob+end_`i'> end_month   & dob+start_`i'<=end_month

* child dies in this interval
* age interval is partly in the time window and partly in the previous time window
replace risk`i'=.5 if age_int_at_death==`i' & end_`i'>=start_month & dob+start_`i'< start_month 

* age interval is partly in the time window and partly in the next time window
replace risk`i'=.5 if age_int_at_death==`i' & end_`i'> end_month   & dob+start_`i'<=end_month

* Next line will change risk from 0 to .5 for a potential handful of cases in which died=.5 and risk=0;
*   it ensures a perfect match with the DHS programs.
replace risk`i'=.5 if died`i'==.5 

* the preceding lines produce some values of died and risk that should be changed from missing to 0
replace died`i'=0 if died`i'==. & risk`i'>0 & risk`i'<=1
replace risk`i'=0 if risk`i'==. & died`i'>0 & died`i'<=1

replace risk`i'=1 if died`i'==1

* Everything is unweighted. Unweighted values are used in the logit model.
* The model includes weights in the specification.

local i=`i'+1
}

sort caseid bidx

save "$resultspath/risk_and_deaths.dta", replace

* This is a child-level file that includes a line for every child, with values of died and risk for each
*   of the eight basic age intervals.  

end

******************************************************************************

program define calculate_q

* simple calculation of rates with division: q=died/risk

foreach lc of global gcovars_temp {

use "$resultspath/risk_and_deaths.dta", clear
keep died* risk* v005 `lc'
collapse (sum) died* risk* [iweight=v005/1000000], by(`lc')
  forvalues lr=1/8 {
  gen q`lr'=died`lr'/risk`lr'
  }
drop died* risk*

* Construct output variables
gen v_run=srun
gen str10 v_variable="`lc'"
local llabel : variable label `lc'
gen str40 v_variable_label="`llabel'"
gen v_category=`lc'
gen str40 v_category_label="."
levelsof `lc', local(levels)
  foreach li of local levels {
  local lname : label (`lc') `li'
  replace v_category_label="`lname'" if `lc'==`li'
  }
gen v_lw=lw
gen v_uw=uw
gen v_mean_doi=smean_doi
gen v_refdate=srefdate
gen NNMR =q1
gen IMR  =1-(1-q1)*(1-q2)*(1-q3)*(1-q4)
gen PNNMR=IMR-NNMR
gen CMR  =1-(1-q5)*(1-q6)*(1-q7)*(1-q8)
gen U5MR =1-(1-IMR)*(1-CMR)
  foreach lt in NN PNN I C U5 {
  replace `lt'MR=1000*`lt'MR
  }

  if srun>1 {
  append using "$resultspath/results_temp.dta"
  }

save "$resultspath/results_temp.dta", replace
scalar srun=srun+1
}

end

**********************************************************

program define make_tables_8pt1_8pt2_8pt3

* The variables in the results will be equenced as in each version of gcovars_temp

* Cleanup
use "$resultspath/results_temp.dta", clear
keep v_* *MR
order v_* NNMR PNNMR IMR CMR U5MR
rename v_* *
format *MR* refdate mean_doi %7.2f
gen neglw=-lw
sort neglw run category
drop neglw
replace variable_label=strproper(variable_label)
replace category_label=strproper(category_label)
*list, table clean
save "$resultspath/CM_rates.dta", replace

* Table 8.1 and the totals rows in tables 8.2 and 8.3
keep lw uw refdate mean_doi variable* category* NNMR PNNMR IMR CMR U5MR
keep if variable=="total"
list, table clean
save "$resultspath/table_8pt1.dta", replace
export excel "$resultspath/CM_tables.xlsx", sheet("Table 8.1") sheetreplace firstrow(var)

* Table 8.2
use "$resultspath/CM_rates.dta", clear
keep if (variable=="child_sex" | variable=="v025" | variable=="total") & lw==-4 & uw==0
list, table clean
save "$resultspath/table_8pt2.dta", replace
export excel "$resultspath/CM_tables.xlsx", sheet("Table 8.2") sheetreplace firstrow(var)


* Table 8.3
* Any survey-specific panels in table 8.3 would require adjustments to this program
* In the reports Table 8.3 does not include a totals row but one is given here
use "$resultspath/CM_rates.dta", clear
keep if lw==-9 & uw==0
list, table clean
save "$resultspath/table_8pt3.dta", replace
export excel "$resultspath/CM_tables.xlsx", sheet("Table 8.3") sheetreplace firstrow(var)


* optional--erase the working files; you may want to keep results.dta
*erase "$resultspath/results.dta
erase "$resultspath/results_temp.dta"
erase "$resultspath/risk_and_deaths.dta"
erase "$resultspath/temp1.dta"
erase "$resultspath/temp2.dta"
erase "$resultspath/BRtemp.dta"
end

********************************************************************************

program define recodes

* Routine to recode or construct covariates

* Be sure that the covariates are included in the the original save and reshape commands

* Example: combine codes 2 and 3 of v106, Education

*gen v106r=v106
*replace v106r=2 if v106==3

gen child_sex=b4
label variable child_sex "Sex of child"
label define child_sex 1 "Male" 2 "Female"
label values child_sex child_sex

* mother's age at birth (years): <20, 20-29, 30-39, 40-49 
gen months_age=b3-v011
gen mo_age_at_birth=1 if months_age<20*12
replace mo_age_at_birth=2 if months_age>=20*12 & months_age<30*12
replace mo_age_at_birth=3 if months_age>=30*12 & months_age<40*12
replace mo_age_at_birth=4 if months_age>=40*12 & months_age<50*12
drop months_age
label variable mo_age_at_birth "Mother's age at birth"
label define mo_age 1 "<20" 2 "20-29" 3 "30-39" 4 "40-49"
label values mo_age_at_birth mo_age

* birth order: 1, 2-3, 4-6, 7+
* To match birth order in the tables, bord must be modified to sssign multiple
*    births to the same birth order. There are different ways to do this. 
gen bordr=bord
replace bordr=bord-1 if b0==2
replace bordr=bord-2 if b0==3

gen     birth_order=1 if bordr==1
replace birth_order=2 if bordr>1 
replace birth_order=3 if bordr>3
replace birth_order=4 if bordr>6 
replace birth_order=. if bord==.
label variable birth_order "Birth order" 
label define birth_order 1 "1" 2 "2-3" 3 "4-6" 4 "7+"
label values birth_order birth_order
drop bordr

* preceding birth interval (years): <2, 2, 3, 4+
gen prev_bint=1
replace prev_bint=2 if b11>23
replace prev_bint=3 if b11>35
replace prev_bint=4 if b11>47
replace prev_bint=. if b11==.
label variable prev_bint "Preceding birth interval (years)"
label define prev_bint 1 "<2 years" 2 "2 years" 3 "3 years" 4 "4+ years"
label values prev_bint prev_bint

* birth size: small or very small, average or larger 
gen birth_size=1
replace birth_size=2 if m18<=3
replace birth_size=. if m18>5
label variable birth_size "Birth size"
label define birth_size 1 "Small or very small" 2 "Average or larger"
label values birth_size birth_size

save, replace

end

********************************************************************************

program define main

use "$resultspath/BRtemp.dta", clear
quietly summarize v008 [iweight=v005/1000000]
scalar smean_doi=1900-(1/24)+(r(mean))/12

quietly setup
quietly recodes
quietly make_risk_and_deaths
calculate_q

end

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
* EXECUTION BEGINS HERE


* Input file should be BR

* srun is a counter used for the construction of the output file
scalar srun=1

* IDENTIFY WHERE YOU WANT THE LOG AND OUTPUT FILES TO GO AND THE NAME OF THE LOG FILE

* Specify the path to the log file and the output files as a scalar
* This path was defined in the main file. If you do not use the main file you need to provide it here.

* scalar soutpath="C:/Users//$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap08_CM"
* local loutpath=soutpath
* cd "`loutpath'"

* Specify the name of the log file as a scalar
* set logtype text
* scalar slogfile="DHS_U5_rates_log.txt"
* local llogfile=slogfile
* log using "`llogfile'",replace

***********************
* Specify the path to the input data as a scalar
* datapath is defined in the main file. If you do not use the main file you need to provide it here.
scalar spath="$datapath"
local lpath=spath
***********************

***********************
* Specify the file name as a scalar.
* The survey is defined in the main file. If you do not use the main file you need to provide it here.
scalar sfn="$brdata"
***********************

local lfn=sfn
use "`lpath'//`lfn'", clear

* IMPORTANT: Reduce to the variables that are needed
gen total=1
label variable total "Total"
label define total 1 "Total" 
label values total total

keep caseid v000 v001 v002 v003 v005 v008 v011 v021 v023 v201 bidx* bord* b0* b3* b4* b7* b11* m18* $gcovars 
rename caseid original_caseid
gen caseid=_n
save "$resultspath/BRtemp.dta", replace 


* The following setup is for the standard tables but can be altered
* lw and uw describe the window of time as the lower and upper ends of "years ago"

use "$resultspath/BRtemp.dta", clear
scalar lw=-4
scalar uw=0
global gcovars_temp "child_sex v025 total"
main

use "$resultspath/BRtemp.dta", clear
scalar lw=-9
scalar uw=-5
global gcovars_temp "total"
main

use "$resultspath/BRtemp.dta", clear
scalar lw=-14
scalar uw=-10
global gcovars_temp "total"
main

use "$resultspath/BRtemp.dta", clear
scalar lw=-9
scalar uw=0
global gcovars_temp "mo_age_at_birth birth_order prev_bint birth_size $gcovars"
main

make_tables_8pt1_8pt2_8pt3

