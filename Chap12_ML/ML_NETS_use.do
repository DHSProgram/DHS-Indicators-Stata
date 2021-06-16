/*****************************************************************************************************
Program: 			ML_NETS_use.do
Purpose: 			POPULATION/CHILD/PREGNANT WOMEN USE OF NETS
Data inputs: 		PR dataset
Data outputs:		coded variables
Author:				Cameron Taylor
Date last modified: March 14 2019 by Cameron Taylor
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_slept_net	"Slept under any mosquito net last night"
ml_slept_itn	"Slept under an ITN last night"
----------------------------------------------------------------------------*/

*Categorizing nets
gen ml_netcat=0 if hml12==0
replace ml_netcat=1 if hml12==1|hml12==2
replace ml_netcat=2 if hml12==3
lab var ml_netcat "Mosquito net categorization"

//Slept under any mosquito net last night
gen ml_slept_net=(ml_netcat==1|ml_netcat==2)
lab var ml_slept_net "Slept under any mosquito net last night"
	
//Slept under an ITN last night
gen ml_slept_itn=(ml_netcat==1)
lab var ml_slept_itn  "Slept under an ITN last night"


