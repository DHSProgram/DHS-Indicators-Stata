/*****************************************************************************************************
Program: 			FS_FIST.do
Purpose: 			Code to compute fistula indicators among women
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: November 4, 2020 by Shireen Assaf 

Note:				
There are no standard variables names for these variables. These variables will likely be included in the data file as country-specific variables. Country-specific variables begin with an “s”, though in this chapter we use “fistula_v*” to denote variables as they are not standard. Country-specific variables should be checked. These tables are not standard across all surveys over time. There is some variation in the presentation of these results among final reports.

This do file provides a guide to how the fistula indicators can be computed but it is necessary to check the country-specific variables for each survey and adjust the code accordingly. 
					
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

fs_heard		"Ever heard of fistula"
fs_ever_exp		"Ever experienced fistula"
fs_current		"Currently have fistula"
	
fs_cause		"Reported cause of fistula"
fs_days_symp	"Reported number of days since symptoms began"
	
fs_trt_provid	"Provider type for fistula treatment"
fs_trt_outcome	"Outcome of treatment sought for fistula"
fs_trt_operat	"Had operation for fistula"
fs_notrt_reason	"Reason for not seeking treatment"

----------------------------------------------------------------------------*/

*Change variables below according to the survey: the variables below are for Afghanistan 2015 survey. 
*Use lookfor command in Stata or the variable manager to find fistula related varaibles. 

cap label define yesno 0"No" 1"Yes"

//Heard of fistula
*use varaible labeled as "ever heard of fistula"
gen fs_heard = 0
replace fs_heard=1 if s1102==1  
label values fs_heard yesno 
label var fs_heard "Ever heard of fistula"

//Ever experienced fistula
*use variable labeled as "involuntary loss of urine and/or feces through the vagina"
gen fs_ever_exp = 0
replace fs_ever_exp=1 if s1101==1 
label values fs_ever_exp yesno 
label var fs_ever_exp "Ever experienced fistula"

//Reported cause of fistula
* use two variables one labeled as "problem start after normal or difficult labor and delivery" here this is s1104 and "problem start after delivered a baby or had a stillbirth" here this is s1103
* you may need to add more country-specific categories here. To do this find a variable with the label "Reported cause of fistula"
gen fs_cause=9 if s1103<3
replace fs_cause=1 if s1104==1 & s1103==1
replace fs_cause=2 if s1104==1 & s1103==2
replace fs_cause=3 if s1104==2 & s1103==1
replace fs_cause=4 if s1104==2 & s1103==2
label define cause 1"Normal labor and delivery, baby born alive" 2"Normal labor and delivery, baby stillborn" 3"Very difficult labor and delivery, baby born alive" 4"Very difficult labor and delivery, baby stillborn" 9"Missing"
label values fs_cause cause
label var fs_cause "Reported cause of fistula"

//Reported number of days since symptoms began
*find variable with label "days after problem leakage started" here this is s1106
gen fs_days_symp=9 if s1103<3
replace fs_days_symp=1 if s1106<2
replace fs_days_symp=2 if inrange(s1106,2,4)
replace fs_days_symp=3 if inrange(s1106,5,7)
replace fs_days_symp=4 if inrange(s1106,8,90)
replace fs_days_symp=. if fs_cause==.
label define days 1"0-1 day" 2"2-4 days" 3"5-7 days" 4"8+ days" 9"Missing"
label values fs_days_symp days
label var fs_days_symp "Reported number of days since symptoms began"

//Provider type for fistula treatment
* use two variables one labeled as "sought treatment for fistula" here this is s1107 and "from whom have you sought a treatment" here this is s1109
gen fs_trt_provid = s1109 if s1101==1 & s1107==1
replace fs_trt_provid=9 if s1101==1 & s1109>6
replace fs_trt_provid=0 if s1101==1 & s1107!=1
label define provid 0"No treatment" 1"Doctor" 2"Nurse/Midwife" 3"Community/village health worker" 6"Other" 9"Missing"
label values fs_trt_provid provid
label var fs_trt_provid	"Provider type for fistula treatment"

//Outcome of treatment sought for fistula
* find a variable with "treatment" or "leakage" in the label 
gen fs_trt_outcome = s1111 if s1101==1 & s1107==1
replace fs_trt_outcome=9 if s1101==1 & s1107==1 & s1111>6
label define outcome 1"Leakage stopped completely" 2"Not stopped but reduced" 3"Not stopped at all" 4"Did not receive any treatment" 9"Missing"
label values fs_trt_outcome outcome
label var fs_trt_outcome "Outcome of treatment sought for fistula"

//Had operation for fistula
gen fs_trt_operat = 0 if s1101==1 & s1107==1
replace fs_trt_operat=1 if s1110==1
label var fs_trt_operat "Had operation for fistula"

//Reason for not seeking treatment
gen fs_notrt_reason = . if fs_ever_exp==1 & fs_trt_outcome==4
replace fs_notrt_reason = 8 if s1108x==1 | s1108e==1
replace fs_notrt_reason = 7 if s1108f==1
replace fs_notrt_reason = 6 if s1108h==1
replace fs_notrt_reason = 5 if s1108d==1
replace fs_notrt_reason = 4 if s1108g==1
replace fs_notrt_reason = 3 if s1108c==1
replace fs_notrt_reason = 2 if s1108b==1
replace fs_notrt_reason = 1 if s1108a==1
replace fs_notrt_reason = 9 if s1108a==. & fs_ever_exp==1 & fs_trt_outcome==4
label define reason 1"Did not know the problem can be fixed" 2"Did not know where to go" 3"Too expensive" 4"Embarrassment" 5"Too far" 6"Problem disappeard" 7"Could not get permission" 8"Other" 9"Missing"
label values fs_notrt_reason reason
label var fs_notrt_reason "Reason for not seeking treatment"

