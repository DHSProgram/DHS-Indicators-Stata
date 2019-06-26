/*****************************************************************************************************
Program: 			RH_age_period.do
Purpose: 			compute the age variable and set the period for the analysis
Author:				Shireen Assaf
Date last modified: Jan 9 2019 by Shireen Assaf 

Notes: 				Choose reference period to select last 2 years or last 5 years.
 					Using the a period of the last 2 years will not match final report but would provide more recent information.
					The PNC indicator is always reported for the last 2 years before the survey. Therefore, 
					the period for this indicator was set as 24 in the PNC do files.
*****************************************************************************************************/

 * choose reference period, last 2 years or last 5 years
	*gen period = 24
	gen period = 60

if file=="IR" {
	gen age = v008 - b3_01
	
	* to check if survey has b19, which should be used instead to compute age. 
	scalar b19_included=1
		capture confirm numeric variable b19_01, exact 
		if _rc>0 {
		* b19 is not present
		scalar b19_included=0
		}
		if _rc==0 {
		* b19 is present; check for values
		summarize b19_01
		  if r(sd)==0 | r(sd)==. {
		  scalar b19_included=0
		  }
		}

	if b19_included==1 {
	drop age
	gen age=b19_01
	}
	
}
**********************************************************

if file=="BR" {
	
	label define yesno 0"no" 1"yes"
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

}

	cap label define yesno 0"no" 1"yes"
