/*****************************************************************************************************
Program: 			HK_TEST_CONSL.do
Purpose: 			Code for indicators on HIV prior testing and counseling 
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Oct 29, 2019 by Shireen Assaf 
Note:				The indicators below can be computed for men and women. No age selection is made here. 
			
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_test_where			"Know where to get an HIV test"
hk_test_prior			"Prior HIV testing status and whether received test result"
hk_test_ever			"Ever been tested for HIV"
hk_test_12m				"Tested for HIV in the past 12 months and received results of the last test"

hk_hiv_selftest_heard	"Ever heard of HIV self-test kits"
hk_hiv_selftest_use		"Ever used a HIV self-test kit"

* for women only	
hk_hiv_consl_anc		"Received counseling on HIV during ANC visit among women with a birth 2 years before the survey"
hk_test_consl_anc		"Received HIV test during ANC visit and received results and post-test counseling among women with a birth 2 years before the survey"
hk_test_noconsl_anc		"Received HIV test during ANC visit and received results but no post-test counseling among women with a birth 2 years before the survey"
hk_test_noresult_anc	"Received HIV test during ANC visit and did not receive test results among women with a birth 2 years before the survey"
hk_hiv_receivedall_anc	"Received HIV counseling, HIV test, and test results during ANC visit among women with a birth 2 years before the survey"
hk_test_anclbr_result	"Received HIV test during ANC visit or labor and received results among women with a birth 2 years before the survey"
hk_test_anclbr_result	"Received HIV test during ANC visit or labor but did not receive results among women with a birth 2 years before the survey"
	
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

cap label define yesno 0"No" 1"Yes"

*** Coverage of Prior HIV Testing ***

//Know where to get HIV test
gen hk_test_where= v781==1 | v783==1
label values hk_test_where yesno
label var hk_test_where "Know where to get an HIV test"

//Had prior HIV test and whether they received results
gen hk_test_prior = .
replace hk_test_prior = 1 if v781==1 & v828==1
replace hk_test_prior = 2 if v781==1 & v828!=1
replace hk_test_prior = 3 if v781!=1 & v828!=1
label define hk_test_prior 1"Tested and received results" 2"Tested and did not receive results" 3"Never tested"
label values hk_test_prior hk_test_prior
label var hk_test_prior "Prior HIV testing status and whether received test result"

//Ever tested
gen hk_test_ever= v781==1
label values hk_test_ever yesno
label var hk_test_ever "Ever been tested for HIV"

//Tested in last 12 months and received test results
gen hk_test_12m= v828==1 & inrange(v826a,0,11)
label values hk_test_12m yesno
label var hk_test_12m "Tested for HIV in the past 12 months and received results of the last test"

//Heard of self-test kits
gen hk_hiv_selftest_heard= inrange(v856,1,3)
label values hk_hiv_selftest_heard yesno
label var hk_hiv_selftest_heard "Ever heard of HIV self-test kits"

//Ever used a self-test kit
gen hk_hiv_selftest_use= v856==1
label values hk_hiv_selftest_use yesno
label var hk_hiv_selftest_use "Ever used a HIV self-test kit"

*** Pregnant Women Counseled and Tested for HIV ***

* Indicators are among women with a live birth in the two years preceiding the survey. 
* To make this restriction we need to compute the age of most recent child (agec).
gen agec = v008 - b3_01
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
	drop agec
	gen agec=b19_01
	}
***	

//Received counseling on HIV during ANC visit
gen hk_hiv_consl_anc= v838a==1 & v838b==1 & v838c==1
replace hk_hiv_consl_anc=. if agec>=24	
label values hk_hiv_consl_anc yesno
label var hk_hiv_consl_anc "Received counseling on HIV during ANC visit among women with a birth 2 years before the survey"

//Tested for HIV during ANC visit and received results and post-test counseling
gen hk_test_consl_anc= v841==1 & v855==1
replace hk_test_consl_anc= . if agec>=24	
label values hk_test_consl_anc yesno
label var hk_test_consl_anc "Received HIV test during ANC visit and received results and post-test counseling among women with a birth 2 years before the survey"

//Tested for HIV during ANC visit and received results but no post-test counseling
gen hk_test_noconsl_anc= v841==1 & v855!=1
replace hk_test_noconsl_anc= . if agec>=24	
label values hk_test_noconsl_anc yesno
label var hk_test_noconsl_anc "Received HIV test during ANC visit and received results but no post-test counseling among women with a birth 2 years before the survey"

//Tested for HIV during ANC visit and did not receive test results
gen hk_test_noresult_anc= v841==0 
replace hk_test_noresult_anc= . if agec>=24	
label values hk_test_noresult_anc yesno
label var hk_test_noresult_anc "Received HIV test during ANC visit and did not receive test results among women with a birth 2 years before the survey"

//Received HIV counseling, test, and results
gen hk_hiv_receivedall_anc= v838a ==1 & v838b ==1 & v838c ==1 & v840 ==1 & v841 ==1
replace hk_hiv_receivedall_anc= . if agec>=24	
label values hk_hiv_receivedall_anc yesno
label var hk_hiv_receivedall_anc "Received HIV counseling, HIV test, and test results during ANC visit among women with a birth 2 years before the survey"

//Received HIV test during ANC or labor and received results
gen hk_test_anclbr_result= (v840==1 | v840a==1) & (v841==1 | v841a==1) 
replace hk_test_anclbr_result= . if agec>=24	
label values hk_test_anclbr_result yesno
label var hk_test_anclbr_result	"Received HIV test during ANC visit or labor and received results among women with a birth 2 years before the survey"

//Received HIV test during ANC or labor but did not receive results
gen hk_test_anclbr_noresult= (v840==1 | v840a==1) & (v841!=1 & v841a!=1) 
replace hk_test_anclbr_noresult= . if agec>=24
label values hk_test_anclbr_noresult yesno
label var hk_test_anclbr_result "Received HIV test during ANC visit or labor but did not receive results among women with a birth 2 years before the survey"

}


* indicators from MR file
if file=="MR" {

cap label define yesno 0"No" 1"Yes"

*** Coverage of Prior HIV Testing ***

//Know where to get HIV test
gen hk_test_where= mv781==1 | mv783==1
label values hk_test_where yesno
label var hk_test_where "Know where to get an HIV test"

//Had prior HIV test and whether they received results
gen hk_test_prior = .
replace hk_test_prior = 1 if mv781==1 & mv828==1
replace hk_test_prior = 2 if mv781==1 & mv828!=1
replace hk_test_prior = 3 if mv781!=1 & mv828!=1
label define hk_test_prior 1"Tested and received results" 2"Tested and did not receive results" 3"Never tested"
label values hk_test_prior hk_test_prior
label var hk_test_prior "Prior HIV testing status and whether received test result"

//Ever tested
gen hk_test_ever= mv781==1
label values hk_test_ever yesno
label var hk_test_ever "Ever been tested for HIV"

//Tested in last 12 months and received test results
gen hk_test_12m= mv828==1 & inrange(mv826a,0,11)
label values hk_test_12m yesno
label var hk_test_12m "Tested for HIV in the past 12 months and received results of the last test"

//Heard of self-test kits
gen hk_hiv_selftest_heard= inrange(mv856,1,3)
label values hk_hiv_selftest_heard yesno
label var hk_hiv_selftest_heard "Ever heard of HIV self-test kits"

//Ever used a self-test kit
gen hk_hiv_selftest_use= mv856==1
label values hk_hiv_selftest_use yesno
label var hk_hiv_selftest_use "Ever used a HIV self-test kit"

}
