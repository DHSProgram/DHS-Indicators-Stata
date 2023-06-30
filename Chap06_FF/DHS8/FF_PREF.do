d/*****************************************************************************************************
Program: 			FF_PREF.do
Purpose: 			Code to compute fertility preferences in men and women
Data inputs: 		IR or MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: May 13, 2019 by Shireen Assaf 
Note:				The five indicators below can be computed for men and women. 
					For men the indicator is computed for age 15-49 in line 56. This can be commented out if the indicators are required for all men.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ff_want_type		"Type of desire for children"
ff_want_nomore		"Want no more children"
ff_ideal_num		"Ideal number of children"
ff_ideal_mean_all	"Mean ideal number of children for all"
ff_ideal_mean_mar	"Mean ideal number of children for married"
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {
//Desire for children
gen ff_want_type= v605
* indicator is computed for women in a union
replace ff_want_type=. if v502!=1
label values ff_want_type V605
label var ff_want_type "Type of desire for children"

//Want no more
* this includes women who are sterilzed or their partner is sterilzed
recode v605 (5/6=1) (else=0), gen(ff_want_nomore)
* indicator is computed for women in a union
replace ff_want_nomore=. if v502!=1
label var ff_want_nomore "Want no more children"

//Ideal number of children
recode v613 (0=0 "0") (1=1 "1") (2=2 "2") (3=3 "3") (4=4 "4") (5=5 "5") (6/94=6 "6+") (95/99=9 "non-numeric response"), gen(ff_ideal_num) 
label var ff_ideal_num "Ideal number of children"

//Mean ideal number of children - all women
sum v613 if v613<95 [iw=v005/1000000]
gen ff_ideal_mean_all=round(r(mean),0.1)
label var ff_ideal_mean_all	"Mean ideal number of children for all"

//Mean ideal number of children - married women
sum v613 if v613<95 & v502==1 [iw=v005/1000000]
gen ff_ideal_mean_mar=round(r(mean),0.1)
label var ff_ideal_mean_mar	"Mean ideal number of children for married"
}


* indicators from MR file
if file=="MR" {
* limiting to men age 15-49
drop if mv012>49

//Desire for children
gen ff_want_type= mv605
* indicator is computed for men in a union
replace ff_want_type=. if mv502!=1
label values ff_want_type MV605
label var ff_want_type "Type of desire for children"

//Want no more
* this includes men who are sterilzed or their partner is sterilzed
recode mv605 (5/6=1) (else=0), gen(ff_want_nomore)
* indicator is computed for men in a union
replace ff_want_nomore=. if mv502!=1
label var ff_want_nomore "Want no more children"

//Ideal number of children
recode mv613 (0=0 "0") (1=1 "1") (2=2 "2") (3=3 "3") (4=4 "4") (5=5 "5") (6/94=6 "6+") (95/99=9 "non-numeric response"), gen(ff_ideal_num) 
label var ff_ideal_num "Ideal number of children"

//Mean ideal number of children - all men
sum mv613 if mv613<95 [iw=mv005/1000000]
gen ff_ideal_mean_all=round(r(mean),0.1)
label var ff_ideal_mean_all	"Mean ideal number of children for all"

//Mean ideal number of children - married men
sum mv613 if mv613<95 & mv502==1 [iw=mv005/1000000]
gen ff_ideal_mean_mar=round(r(mean),0.1)
label var ff_ideal_mean_mar	"Mean ideal number of children for married"
}
