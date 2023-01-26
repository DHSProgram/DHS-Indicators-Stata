/*****************************************************************************************************
Program: 			ML_BIOMARKERS.do
Purpose: 			Code anemia and malaria testing prevalence in children under 5
Data inputs: 		PR dataset
Data outputs:		coded variables
Author:				Cameron Taylor and Shireen Assaf
Date last modified: May 20 2019 by Shiren Assaf
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_test_anemia	Tested for anemia in children 6-59 months
ml_test_micmal 	Tested for Parasitemia (via microscopy) in children 6-59 months
ml_test_rdtmal	Tested for Parasitemia (via RDT) in children 6-59 months

ml_anemia		Anemia in children 6-59 months
ml_micmalpos 	Parasitemia (via microscopy) in children 6-59 months
ml_rdtmalpos	Parasitemia (via RDT) in children 6-59 months
----------------------------------------------------------------------------*/

*** Testing ***

//Tested for Anemia
gen ml_test_anemia=0 if hv103==1 & hc1>=6 & hc1<=59 & hv042==1
replace ml_test_anemia=1 if hc55==0
label var ml_test_anemia "Tested for anemia in children 6-59 months"

//Tested for Parasitemia via microscopy
gen ml_test_micmal=0 if hv103==1 & hc1>=6 & hc1<=59 & hv042==1
replace ml_test_micmal=1 if hml32==0 | hml32==1 | hml32==6
label var ml_test_micmal "Tested for Parasitemia (via microscopy) in children 6-59 months"

//Tested for Parasitemia via RDT
gen ml_test_rdtmal=0 if hv103==1 & hc1>=6 & hc1<=59 & hv042==1
replace ml_test_rdtmal=1 if hml35==0 | hml35==1 
label var ml_test_rdtmal "Tested for Parasitemia (via RDT) in children 6-59 months"

*** Prevalence ***

//Anemia in children 6-59 months
gen ml_anemia=0 if hv103==1 & hc1>=6 & hc1<=59 & hc55==0 & hv042==1
replace ml_anemia=1 if hc56<80
lab var ml_anemia "Anemia in children 6-59 months"

//Parasitemia (via microscopy) in children 6-59 months
gen ml_micmalpos=0 if hv103==1 & hc1>=6 & hc1<=59 & hv042==1 & (hml32==0 | hml32==1 | hml32==6)
replace ml_micmalpos=1 if hml32==1 & hv103==1 & hc1>=6 & hc1<=59 & hv042==1
lab var ml_micmalpos "Parasitemia (via microscopy) in children 6-59 months"
	
//Parasitemia (vis RDT) in children 6-59 months
gen ml_rdtmalpos=0 if hv103==1 & hc1>=6 & hc1<=59 & hv042==1 & (hml35==0 | hml35==1)
replace ml_rdtmalpos=1 if hml35==1 & hv103==1 & hc1>=6 & hc1<=59 & hv042==1 
lab var ml_rdtmalpos "Parasitemia (via RDT) in children 6-59 months"
