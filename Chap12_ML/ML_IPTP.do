/*****************************************************************************************************
Program: 			ML_IPTP.do
Purpose: 			Malaria IPTP
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Cameron Taylor
Date last modified: March 14 2019 by Cameron Taylor
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
mal_agemnth			"Establishing birth in past 2 years"
mal_one_iptp	"One or more doses of SP/Fansidar"
mal_two_iptp	"Two or more doses of SP/Fansidar"
mal_three_iptp	"Three or more doses of SP/Fansidar"
----------------------------------------------------------------------------*/

*** Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received one or more doses of SP/Fansidar  ***
*** Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received two or more doses of SP/Fansidar  ***
*** Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received three or more doses of SP/Fansidar  ***


//Establishing birth in past 2 years
	gen mal_agemnth=.
	replace mal_agemnth=v008-b3_01
	lab var mal_agemnth "Establishing birth in past 2 years"

//1+ doses SP/Fansidar
	gen mal_one_iptp=0
	replace mal_one_iptp=1 if m49a_1==1 & ml1_1 >=1 & ml1_1<=97
	lab var mal_one_iptp "One or more doses of SP/Fansidar"
	
//2+ doses SP/Fansidar
	gen mal_two_iptp=0
	replace mal_two_iptp=1 if m49a_1==1 & ml1_1 >=2 & ml1_1<=97
	lab var mal_two_iptp "Two or more doses of SP/Fansidar"

//3+ doses SP/Fansidar
	gen mal_three_iptp=0
	replace mal_three_iptp=1 if m49a_1==1 & ml1_1 >=2 & ml1_1<=97
	lab var mal_three_iptp "Three or more doses of SP/Fansidar"
