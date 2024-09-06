/*****************************************************************************************************
Program: 			ML_IPTP.do - DHS8 update
Purpose: 			Code malaria IPTP indicators
Data inputs: 		NR dataset
Data outputs:		coded variables
Author:				Cameron Taylor and Shireen Assaf
Date last modified: August 07, 2023 by Courtney Allen
					In DHS8 these indicators are computed using the NR file instead of the IR file. 
					Also the indicators are tabulated for three subpopulations using m80. See the tables code for the NR section
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_one_iptp		"One or more doses of SP/Fansidar"
ml_two_iptp		"Two or more doses of SP/Fansidar"
ml_three_iptp	"Three or more doses of SP/Fansidar"
----------------------------------------------------------------------------*/


//1+ doses SP/Fansidar
gen ml_one_iptp= m49a==1 
replace ml_one_iptp=. if m49a==.
lab var ml_one_iptp "One or more doses of SP/Fansidar"
	
//2+ doses SP/Fansidar
gen ml_two_iptp= m49a==1 & ml1 >=2 & ml1<=97
replace ml_two_iptp=. if m49a==.
lab var ml_two_iptp "Two or more doses of SP/Fansidar"

//3+ doses SP/Fansidar
gen ml_three_iptp= m49a==1 & ml1 >=3 & ml1<=97
replace ml_three_iptp=. if m49a==.
lab var ml_three_iptp "Three or more doses of SP/Fansidar"

