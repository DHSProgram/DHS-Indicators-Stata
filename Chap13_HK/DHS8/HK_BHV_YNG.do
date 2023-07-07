/*****************************************************************************************************
Program: 			HK_BHV_YNG.do - No changes in DHS8
Purpose: 			Code for sexual behaviors among young people
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Nov 4, 2019 by Shireen Assaf 
Note:				The indicators below can be computed for men and women. No age selection is made here. 
			
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_sex_15			"Had sexual intercourse before age 15 among those age 15-24"
hk_sex_18			"Had sexual intercourse before age 18 among those age 18-24"
hk_nosex_youth		"Never had sexual intercourse among never-married age 15-24"
hk_sex_youth_test	"Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24"
	
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {

cap label define yesno 0"No" 1"Yes"

**************************
//Sex before 15
gen hk_sex_15 = inrange(v531,1,14)
replace hk_sex_15 = . if v012>24
label values hk_sex_15 yesno
label var hk_sex_15 "Had sexual intercourse before age 15 among those age 15-24"

//Sex before 18
gen hk_sex_18 = inrange(v531,1,17)
replace hk_sex_18 = . if v012<18 | v012>24
label values hk_sex_18 yesno
label var hk_sex_18 "Had sexual intercourse before age 18 among those age 18-24"

//Never had sexual
gen hk_nosex_youth = (v525==0 | v525==99)
replace hk_nosex_youth = . if v012>24 | v501!=0
label values hk_nosex_youth yesno
label var hk_nosex_youth "Never had sexual intercourse among never-married age 15-24"

//Tested and received HIV test results
gen hk_sex_youth_test = (inrange(v527,100,251) | inrange(v527,300,311)) & v828==1 & inrange(v826a,0,11)
replace hk_sex_youth_test=. if v012>24
replace hk_sex_youth_test=. if inrange(v527,252,299) | v527>311 | v527<100
label values hk_sex_youth_test yesno
label var hk_sex_youth_test "Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24"

}


* indicators from MR file
if file=="MR" {

cap label define yesno 0"No" 1"Yes"

**************************
//Sex before 15
gen hk_sex_15 = inrange(mv531,1,14)
replace hk_sex_15 = . if mv012>24
label values hk_sex_15 yesno
label var hk_sex_15 "Had sexual intercourse before age 15 among those age 15-24"

//Sex before 18
gen hk_sex_18 = inrange(mv531,1,17)
replace hk_sex_18 = . if mv012<18 | mv012>24
label values hk_sex_18 yesno
label var hk_sex_18 "Had sexual intercourse before age 18 among those age 18-24"

//Never had sexual
gen hk_nosex_youth = (mv525==0 | mv525==99)
replace hk_nosex_youth = . if mv012>24 | mv501!=0
label values hk_nosex_youth yesno
label var hk_nosex_youth "Never had sexual intercourse among never-married age 15-24"

//Tested and received HIV test results
gen hk_sex_youth_test = (inrange(mv527,100,251) | inrange(mv527,300,311)) & mv828==1 & inrange(mv826a,0,11)
replace hk_sex_youth_test=. if mv012>24
replace hk_sex_youth_test=. if inrange(mv527,252,299) | mv527>311 | mv527<100
label values hk_sex_youth_test yesno
label var hk_sex_youth_test "Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24"

}




