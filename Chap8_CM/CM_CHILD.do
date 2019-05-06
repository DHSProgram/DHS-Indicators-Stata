/*****************************************************************************************************
Program: 			CM_CHILD.do
Purpose: 			Produce child mortality indicators 
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Tom Pullum, modified for the code share project by Shireen Assaf
Date last modified: April 1 2019 by Shireen Assaf 
Note:				The program will produce a file "`CNPH'_mortality_rates_with_ci.dta" which can be used to export the results, 
					where `CNPH' is the two letter country code followed by the 2 character survey phase, ex: UG7A . 
*****************************************************************************************************/

clear
program drop _all
set more off

/*
****************************************************************************************
PROGRAM TO PRODUCE UNDER 5 MORTALITY RATES FOR SPECIFIC WINDOWS OF TIME, WITH COVARIATES
****************************************************************************************

The 5 standard rates (also actually conditional probabilities) are as follows:

Neonatal mortality:     the probability of dying in the first month of life;
Postneonatal mortality: the difference between infant and neonatal mortality (similar to the
                            probability of dying during months 1 through 11, but different);
Infant mortality:       the probability of dying in the first year of life;
Child mortality:        probability of dying between the first and fifth birthday;
Under-five mortality:   the probability of dying before the fifth birthday.

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

******************************************************************************
* SUB-PROGRAMS OR ROUTINES BETWEEN HERE AND THE REPEATED LINES OF ASTERISKS
******************************************************************************

program define setup

*local lpath=spath
*local lfn=sfn

scalar stype=substr(sfn,3,2)

egen stratumid  =group(v024 v025)
gen clusterid=v021


* Must reshape if the input file is IR rather than BR:

if stype=="IR" {
drop bidx*
rename *_0* *_*
reshape long bord_ b3_ b4_ b7_ b11_ m18_, i(caseid) j(bidx)
drop if b3==.
rename *_ *
}


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
summarize doi [iweight=v005/1000000]
scalar doi_mean=r(mean)
gen wt=v005/1000000.
scalar v000_string=v000[1]
save temp2.dta, replace

end

******************************************************************************

program define start_month_end_month

* This routine calculates the end date and start date for the desired window of time

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

summarize start_month [iweight=v005/1000000]
scalar mean_start_month=r(mean)

summarize end_month [iweight=v005/1000000]
scalar mean_end_month=r(mean)

* Convert back to continuous time, which requires an adjustment of half a month (i.e. -1/24).
* This adjustment is not often made but should be.
scalar refdate=1900-(1/24)+((mean_start_month+mean_end_month)/2)/12

summarize doi [iweight=v005/1000000]
scalar mean_doi=1900-(1/24)+(r(mean))/12


end

******************************************************************************

program prepare_child_file

* This routine calculates dob, doi, dod_1, dod_2, and the start and end months
*  of each age interval for each child.

* This routine calls start_month_end_month

use temp2.dta, clear

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

save temp3.dta, replace

end

******************************************************************************
program define make_risk_and_deaths

prepare_child_file

use temp3.dta, replace

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

save risk_and_deaths.dta, replace

* This is a child-level file that includes a line for every child, with values of died and risk for each
*   of the eight basic age intervals.  

end


*********************************************

program define LUsteps

* This is a repeated part of the calculation of confidence intervals, called in calc_5_from_8_and_ci

matrix D=J(1,8,0)
scalar PI=1

* Fill D and calculate the compound rate Q
local li=si_start
while `li'<=si_end {
matrix D[1,`li']=q`li'
scalar PI=PI*(1+exp(b`li'))
local li=`li'+1
}

* calculate L and U 
scalar Q=1-1/PI
scalar F=log(Q/(1-Q))
scalar C=1/(Q*Q)
matrix M=C*D*V*D'
scalar sF=sqrt(M[1,1])
scalar LF=F-1.96*sF
scalar UF=F+1.96*sF
scalar L=exp(LF)/(1+exp(LF))
scalar U=exp(UF)/(1+exp(UF))

end

******************************************************************************

program define calc_5_from_8_and_ci

* Routine to calculate the 5 q's from the 8 q's and the standard errors of the 5 q's
*   using the standard errors (and covariances) of the 8 q's.
* This is done separately for each line of output rather than for all together.
* If done all together, the calculation of confidence intervals would be more efficient but 
*   harder to unravel.

local cat=code

matrix T=T_`cat'
matrix V=V_`cat'


local li=1
while `li'<=8 {

* Save the b's from the logit regression, from r(table)
scalar b`li'=T[1,`li']

* Construct the 8 q's and their confidence intervals from r(table)

scalar q`li'  =(exp(T[1,`li']))/(1+exp(T[1,`li']))
scalar q`li'_L=(exp(T[5,`li']))/(1+exp(T[5,`li']))
scalar q`li'_U=(exp(T[6,`li']))/(1+exp(T[6,`li']))
scalar list q`li' q`li'_L q`li'_U

local li=`li'+1
}

* First the neonatal rate, which is just q1

scalar q_nnmr=q1
scalar q_nnmr_L=q1_L
scalar q_nnmr_U=q1_U

* The following lines show how the compound q's are defined, although they are actually
*   calculated differently in LUsteps

*scalar q_imr=1-(1-q1)*(1-q2)*(1-q3)*(1-q4)
*scalar q_cmr=1-(1-q5)*(1-q6)*(1-q7)*(1-q8)
*scalar q_u5mr=1-(1-q_imr)*(1-q_cmr)
*scalar q_pnnmr=q_imr-q_nnmr
*scalar q_pseudo_pnnmr=1-(1-q2)*(1-q3)*(1-q4)

* PSEUDO POST NEONATAL
scalar si_start=2
scalar si_end=4
LUsteps
scalar q_pseudo_pnnmr=Q
scalar q_pseudo_pnnmr_L=L
scalar q_pseudo_pnnmr_U=U

* INFANT
scalar si_start=1
scalar si_end=4
LUsteps
scalar q_imr=Q
scalar q_imr_L=L
scalar q_imr_U=U

* CHILD
scalar si_start=5
scalar si_end=8
LUsteps
scalar q_cmr=Q
scalar q_cmr_L=L
scalar q_cmr_U=U

* UNDER FIVE
scalar si_start=1
scalar si_end=8
LUsteps
scalar q_u5mr=Q
scalar q_u5mr_L=L
scalar q_u5mr_U=U


* to get the confidence interval for the post neonatal rate, shift the interval for the pseudo post neoatal rate

scalar q_pnnmr=q_imr-q_nnmr

scalar q_pnnmr_L=q_pnnmr + (q_pseudo_pnnmr_L - q_pseudo_pnnmr)
scalar q_pnnmr_U=q_pnnmr + (q_pseudo_pnnmr_U - q_pseudo_pnnmr)

end

******************************************************************************

program define save_results

* This routine converts the scalars to variables and builds up the output file

scalar run_number=run_number+1

clear
set obs 1

local cat=code

gen v_run_number=run_number
gen str12 v_file=sfn
gen v_covariate=variable
gen v_label=label
gen v_value=code
gen v_lw=lw
gen v_uw=uw
gen v_refdate=refdate
gen v_mean_doi=mean_doi

local i=1 
while `i'<=8 {
gen v_q`i'  =q`i'
gen v_q`i'_L=q`i'_L
gen v_q`i'_U=q`i'_U
local i=`i'+1
}

gen v_q_nnmr=q_nnmr
gen v_q_pnnmr=q_pnnmr
gen v_q_imr=q_imr
gen v_q_cmr=q_cmr
gen v_q_u5mr=q_u5mr

gen v_q_nnmr_L=q_nnmr_L
gen v_q_pnnmr_L=q_pnnmr_L
gen v_q_imr_L=q_imr_L
gen v_q_cmr_L=q_cmr_L
gen v_q_u5mr_L=q_u5mr_L

gen v_q_nnmr_U=q_nnmr_U
gen v_q_pnnmr_U=q_pnnmr_U
gen v_q_imr_U=q_imr_U
gen v_q_cmr_U=q_cmr_U
gen v_q_u5mr_U=q_u5mr_U


if run_number>1 {
append using partial_results.dta
}

save partial_results.dta, replace

end

******************************************************************************

program define calc_q

/*

The 8 basic q's are produced in this routine. It loops through all the values of the 
  categorical variable called "covariate"; for "All", there is only one value, 1.

The UNWEIGHTED deaths and risk are used, with adjustments for weights, clusters, and strata within the model.

*/

use risk_and_deaths.dta, clear

if variable=="All" {
gen covariate=1

}

if variable~="All" {
local lname=variable
gen covariate=`lname'

}

egen stratum=group(v024 v025)
egen motherid=group(v001 v002 v003)
egen childid=group(motherid bidx)

keep *id doi died* risk* stratum v005 covariate

***********************
reshape long died risk, i(childid) j(age)
***********************

* Construct dummy variables for ALL age groups ("noomit" is crucial!).
xi, noomit i.age
rename _I* *

* died is coded "." if there is no risk in the age/time interval; drop such lines
drop if died==.

***********************
svyset clusterid [pweight=v005], strata(stratum) singleunit(centered)
***********************

levelsof covariate, local(levels)

* Begin loop through each value of the categorical covariate

foreach cat of local levels {

scalar code=`cat'

scalar list variable code

* Construct a dummy variable to identify the subpopulation 

gen dummy=0
replace dummy=1 if covariate==code

summarize doi if covariate==code

***********************
svy, subpop(dummy): glm died age_*, nocons family(binomial risk) link(logit) iter(10)
***********************
matrix T_`cat'=r(table)
matrix list T_`cat'

matrix V_`cat'=e(V)
matrix list V_`cat'

* Extract the total risk as a denominator for the specified age interval

local li=1
while `li'<=8 {
quietly summarize risk if age==`li'
scalar stotal_risk_`li'=r(sum)
quietly summarize died if age==`li'
scalar stotal_died_`li'=r(sum)
local li=`li'+1
}

drop dummy

}

* Loop again through categories, this time just to save the results.

foreach cat of local levels {
scalar code=`cat'

calc_5_from_8_and_ci
save_results

}

end

**********************************************************

program define final_file_save

use partial_results.dta, clear

* construct two Stata data files that save the results.
* The first includes confidence intervals, the second does not

rename v_* *

scalar scid=substr(sfn,1,2)
scalar spv =substr(sfn,5,2)
local lcid=scid
local lpv=spv

gen NNMR=1000*q_nnmr
gen PNNMR=1000*q_pnnmr
gen IMR=1000*q_imr
gen CMR=1000*q_cmr
gen U5MR=1000*q_u5mr

gen NNMR_L=1000*q_nnmr_L
gen PNNMR_L=1000*q_pnnmr_L
gen IMR_L=1000*q_imr_L
gen CMR_L=1000*q_cmr_L
gen U5MR_L=1000*q_u5mr_L

gen NNMR_U=1000*q_nnmr_U
gen PNNMR_U=1000*q_pnnmr_U
gen IMR_U=1000*q_imr_U
gen CMR_U=1000*q_cmr_U
gen U5MR_U=1000*q_u5mr_U

format *MR* %6.2f
format refdate mean_doi %7.2f


sort lw uw covariate value
list lw uw refdate mean_doi covariate value NNMR PNNMR IMR CMR U5MR, table clean
list lw uw refdate mean_doi covariate value NNMR_L PNNMR_L IMR_L CMR_L U5MR_L, table clean
list lw uw refdate mean_doi covariate value NNMR_U PNNMR_U IMR_U CMR_U U5MR_U, table clean

save "`lcid'`lpv'_mortality_rates_with_ci.dta", replace
*export excel "`lcid'`lpv'_mortality_rates_with_ci.xlsx", firstrow(var) replace

* optional--erase the working files
erase partial_results.dta
erase risk_and_deaths.dta
erase temp2.dta
erase temp3.dta

end

******************************************************************************

program define recodes

* Routine to recode or construct covariates

* Be sure that the components are included in the the original save and reshape commands

* Example: combine codes 2 and 3 of v106, Education

*gen v106r=v106
*replace v106r=2 if v106==3
*save, replace

*/

gen child_sex=b4

* mother's age at birth (years): <20, 20-29, 30-39, 40-49 
gen months_age=b3-v011
gen mo_age_at_birth=1 if months_age<20*12
replace mo_age_at_birth=2 if months_age>=20*12 & months_age<30*12
replace mo_age_at_birth=3 if months_age>=30*12 & months_age<40*12
replace mo_age_at_birth=4 if months_age>=40*12 & months_age<50*12
drop months_age

* birth order: 1, 2-3, 4-6, 7+
gen birth_order=1
replace birth_order=2 if bord>1 
replace birth_order=3 if bord>3
replace birth_order=4 if bord>6 
replace birth_order=. if bord==.
* tab bord birth_order

* preceding birth interval (years): <2, 2, 3, 4+
gen prev_bint=1
replace prev_bint=2 if b11>23
replace prev_bint=3 if b11>35
replace prev_bint=4 if b11>47
replace prev_bint=. if b11==.
* tab b11 prev_bint

* birth size: small/very small, average or larger 
gen birth_size=1
replace birth_size=2 if m18<=3
replace birth_size=. if m18>5
* tab m18 birth_size

* If there are any recodes, you must include "save, replace"
save, replace

end

******************************************************************************

program define covariate_segment

* This routine checks whether an "include" scalar is specified, is coded 1, and 
*   calculates the rates for each category

* FOR EACH COVARIATE, USE A GROUP OF LINES LIKE THE FOLLOWING
/*
scalar variable="v025"
scalar label="Type of Place"
scalar list variable label
quietly calc_q
*/

local lvarname=svarname
local lvarlabel=svarlabel

capture confirm scalar include_`lvarname'
if _rc==0 {
  if include_`lvarname'==1 {
    scalar variable="`lvarname'"
    scalar label="`lvarlabel'"
    scalar list variable label
    quietly calc_q
  }
scalar include_`lvarname'=0
}

end

******************************************************************************

program define main

quietly setup

* YOU CAN RECODE OR CONSTRUCT COVARIATES 
* See the sub program "recodes"

quietly recodes

quietly make_risk_and_deaths

scalar variable="All"
scalar label="All"
quietly calc_q

* NOTE: All-women factors are not required for the calculation of under-five mortality rates

* The following segments for covariates will be activated if a scalar such as "include_v025" has been included in the
*  executable section

scalar svarname="v025"
scalar svarlabel="Type of Place"
covariate_segment

scalar svarname="v024"
scalar svarlabel="Region"
covariate_segment

scalar svarname="v106"
scalar svarlabel="Education"
covariate_segment

scalar svarname="v190"
scalar svarlabel="Wealth quintile"
covariate_segment

scalar svarname="child_sex"
scalar svarlabel="Sex of child"
covariate_segment

scalar svarname="mo_age_at_birth"
scalar svarlabel="Mother's age at birth"
covariate_segment

scalar svarname="birth_order"
scalar svarlabel="Birth order"
covariate_segment

scalar svarname="prev_bint"
scalar svarlabel="Preceding birth interval"
covariate_segment

scalar svarname="birth_size"
scalar svarlabel="Birth size"
covariate_segment


end

******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
* EXECUTION BEGINS HERE


* Input file should be either IR; check the setup routine for a group of  
*  lines including reshape, that must be included if the input file is IR.

* run_number is a counter used for the construction of the output file
scalar run_number=0

* The covariates you want to use must be specified in "main"

* IDENTIFY WHERE YOU WANT THE LOG AND OUTPUT FILES TO GO AND THE NAME OF THE LOG FILE

***********************
* Specify the path to the log file and the output files as a scalar
scalar soutpath="C:/Users//$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap8_CM"
local loutpath=soutpath
cd "`loutpath'"
***********************

/***********************
* Specify the name of the log file as a scalar
scalar slogfile="DHS_U5_rates_log.txt"
local llogfile=slogfile
***********************/

*log using "`llogfile'",replace

* A WORKING NAME OF THE OUTPUT FILE IS ASSIGNED IN "final_file_save"; you can change it

* IDENTIFY THE PATH AND NAME OF THE INPUT FILE 

***********************
* Specify the path to the input data as a scalar
scalar spath="C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata"
local lpath=spath
***********************

***********************
* Specify the file name as a scalar. This must be an IR or BR standard recode file in Stata format.
scalar sfn="$irdata"
***********************

local lfn=sfn
use "`lpath'//`lfn'", clear

* IMPORTANT: Reduce to the variables that are needed
keep caseid v000 v001 v002 v003 v005 v008 v011 v201 bidx_* bord_* b3_* b4_* b7_* b11_* m18_* v021 v024 v025 v106 v190 

rename caseid original_caseid
gen caseid=_n
save IRtemp.dta, replace 

use IRtemp.dta, clear
scalar lw=-4
scalar uw=0

* The following covariates are only used for 0-4 years ago

scalar include_v025=1
scalar include_child_sex=1

main

use IRtemp.dta, clear
scalar lw=-9
scalar uw=-5
main

use IRtemp.dta, clear
scalar lw=-14
scalar uw=-10
main

use IRtemp.dta, clear
scalar lw=-9
scalar uw=0

* The scalars "include_xxxx", when set to 1, will lead to estimates for categories of covariates.
* For them to work correctly you must also include the components in the save and reshape commands,
*   include them in the recode routine (if recoding is required) AND include the relevant three lines
*   in the last part of the "main" routine.
* The program is set up for the covariates usually used in the main reports, but recodes will be needed for
*   country-specific versions of region, etc.

* The results for covariates do not include labels

* The following covariates are only used for 0-9 years ago

scalar include_v024=1
scalar include_v106=1
scalar include_v190=1

scalar include_mo_age_at_birth=1
scalar include_birth_order=1
scalar include_prev_bint=1
scalar include_birth_size=1

main

* THE NEXT LINE IS ESSENTIAL AT THE END OF THE RUN

final_file_save

erase IRtemp.dta
******************************************************************************
* END OF PROGRAM

