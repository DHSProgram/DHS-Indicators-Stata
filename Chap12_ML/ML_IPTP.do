/*****************************************************************************************************
Program: 			ML_IPTP.do
Purpose: 			Code malaria IPTP indicators
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Cameron Taylor and Shireen Assaf
Date last modified: May 20 2019 by Shireen Assaf
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_one_iptp		"One or more doses of SP/Fansidar"
ml_two_iptp		"Two or more doses of SP/Fansidar"
ml_three_iptp	"Three or more doses of SP/Fansidar"
----------------------------------------------------------------------------*/

//Age of most recent birth
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
	

//1+ doses SP/Fansidar
gen ml_one_iptp=0
replace ml_one_iptp=1 if m49a_1==1 
replace ml_one_iptp=. if age>=24
lab var ml_one_iptp "One or more doses of SP/Fansidar"
	
//2+ doses SP/Fansidar
gen ml_two_iptp=0
replace ml_two_iptp=1 if m49a_1==1 & ml1_1 >=2 & ml1_1<=97
replace ml_two_iptp=. if age>=24
lab var ml_two_iptp "Two or more doses of SP/Fansidar"

//3+ doses SP/Fansidar
gen ml_three_iptp=0
replace ml_three_iptp=1 if m49a_1==1 & ml1_1 >=3 & ml1_1<=97
replace ml_three_iptp=. if age>=24
lab var ml_three_iptp "Three or more doses of SP/Fansidar"
