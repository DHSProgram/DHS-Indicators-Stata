/*****************************************************************************************************
Program: 			ML_FEVER.do
Purpose: 			Malaria Care Seeking
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Cameron Taylor
Date last modified: March 14 2019 by Cameron Taylor
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
mal_agemnth			"Establishing birth in past 2 years"
mal_fever			"Mother reported fever in child during 2 weeks preceding interview"
mal_soughtcare		"Sought treatment for fever from the formal health sector"
mal_stick			"Child received heel or finger stick"
mal_antimal			"Child took any antimalarial"
mal_act				"Child took an ACT"
----------------------------------------------------------------------------*/

*** Children under age 5 years with fever in the 2 weeks preceding the survey ***
*** Among children under age 5 years with fever in the 2 weeks preceding the survey, percentage for whom advice or treatment was sought ***
*** Children under age 5 years with fever in the 2 weeks preceding the survey who had blood taken from a finger or heel for testing ***
*** Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took an ACT ***

//Establishing birth in past 2 years
	gen mal_agemnth=.
	replace mal_agemnth=v008-b3
	lab var mal_agemnth "Establishing birth in past 2 years"

//Mother reported fever in child during 2 weeks preceeding interview
	gen mal_fever=(h22==1)
	lab var mal_fever "Mother reported fever in child during 2 weeks preceding interview"


//Sought treatment for fever from the formal health sector (needs to be updated according to country specifications)
	g mal_soughtcare=0
		foreach x in a b c d e f g h i j k l m n o p q r {
			replace mal_soughtcare=1 if h32`x'==1
		}
	replace mal_soughtcare=0 if h22==1 & trtfevform !=1
	lab var mal_soughtcare "Sought treatment for fever from the formal health sector"

//Child with fever received heel or finger stick 
	gen mal_stick=(h47==1)
	lab var mal_stick "Child received heel or finger stick"

//Child with fever received heel or finger stick 
	gen mal_stick=(h47==1)
	lab var mal_stick "Child received heel or finger stick"

//Child with fever in past 2 weeks took any antimalarial (needs to be updated according to country specifications)
	gen mal_antimal=0
	foreach x in a b c d e f g h {
		replace mal_antimal=1 if ml13`x'==1
	}
	lab var mal_antimal "Child took any antimalarial"
	
//Child with fever in past 2 weeks took an ACT
	gen mal_act=(ml13e==1)
	lab var mal_act "Child took an ACT"
