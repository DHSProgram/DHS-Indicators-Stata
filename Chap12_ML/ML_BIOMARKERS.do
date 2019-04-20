/*****************************************************************************************************
Program: 			ML_BIOMARKERS.do
Purpose: 			Anemia and malaria prevalence in children under 5
Data inputs: 		PR survey list
Data outputs:		coded variables
Author:				Cameron Taylor
Date last modified: March 14 2019 by Cameron Taylor
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
mal_anemia		Anemia in children 6-59 months
mal_micmalpos 	Parasitemia (via microscopy) in children 6-59 months
mal_rdtmalpos	Parasitemia (via RDT) in children 6-59 months
----------------------------------------------------------------------------*/

***  Percentage of children with hemoglobin lower than 8.0 g/dl ***
***  Percentage of children age 6-59 months classified as having malaria according to a rapid diagnostic test (RDT) ***
***  Percentage of children age 6-59 months classified as having malaria according to microscopy ***


//Anemia in children 6-59 months
	gen mal_anemia=(hc56<80)
	lab var mal_anemia "Anemia in children 6-59 months"

//Parasitemia (via microscopy) in children 6-59 months
	gen mal_micmalpos=0
	replace mal_micmalpos=(hml32==1) 
	lab var mal_micmalpos "Parasitemia (via microscopy) in children 6-59 months"
	
//Parasitemia (vis RDT) in children 6-59 months
	gen mal_rdtmalpos=0
	replace mal_rdtmalpos=(hml35==1) 
	lab var mal_rdtmalpos "Parasitemia (via RDT) in children 6-59 months"
