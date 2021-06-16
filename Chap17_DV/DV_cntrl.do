/*****************************************************************************************************
Program: 			DV_cntrl.do
Purpose: 			Code marital control  indicators from the IR file
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Courtney Allen 
Date last modified: September 09 2020
*****************************************************************************************************/

/*______________________________________________________________________________
Variables created in this file:

//MARITAL CONTROL
	dv_prtnr_jeals		"Current or most recent partner ever was jealous if spoke to other men"
	dv_prtnr_accus		"Current or most recent partner ever accused her of being unfaithful"
	dv_prtnr_friends	"Current or most recent partner ever prevented her from meeting female friends"
	dv_prtnr_fam		"Current or most recent partner ever tried to limit her contact with her family"
	dv_prtnr_where		"Current or most recent partner ever insisted on knowing where she is at all times"
	dv_prtnr_money		"Current or most recent partner ever did not trust her with money"
	dv_prtnr_cntrl_3 	"Current or most recent partner displays 3 or more control behaviors"
	dv_prtnr_cntrl_0 	"Current or most recent partner displays no control behaviors"
	
_____________________________________________________________________________*/


********************************************************************************	
**Marital control by current or most recent partner
********************************************************************************	

	//partner jealous if spoke to other men
	gen dv_prtnr_jeals = 0 if v044==1 & v502>0
	replace dv_prtnr_jeals = 1 if d101a==1
	label val dv_prtnr_jeals yesno
	label var dv_prtnr_jeals "Current or most recent partner ever was jealous if spoke to other men"
	
	//accused her of being unfaithful
	gen dv_prtnr_accus = 0 if v044==1 & v502>0
	replace dv_prtnr_accus = 1 if d101b==1
	label val dv_prtnr_accus yesno
	label var dv_prtnr_accus "Current or most recent partner ever accused her of being unfaithful"

	//prevented her from meeting female friends
	gen dv_prtnr_friends = 0 if v044==1 & v502>0
	replace dv_prtnr_friends = 1 if d101c==1
	label val dv_prtnr_friends yesno
	label var dv_prtnr_friends	"Current or most recent partner ever prevented her from meeting female friends"

	//tried to limit her contact with her family
	gen dv_prtnr_fam = 0 if v044==1 & v502>0
	replace dv_prtnr_fam = 1 if d101d==1
	label val dv_prtnr_fam yesno
	label var dv_prtnr_fam "Current or most recent partner ever tried to limit her contact with her family"

	//insisted on knowing where she is at all times
	gen dv_prtnr_where = 0 if v044==1 & v502>0
	replace dv_prtnr_where = 1 if d101e==1
	label val dv_prtnr_where yesno
	label var dv_prtnr_where "Current or most recent partner ever insisted on knowing where she is at all times"

	//did not trust her with money
	gen dv_prtnr_money = 0 if v044==1 & v502>0
	replace dv_prtnr_money = 1 if d101f==1
	label val dv_prtnr_money yesno
	label var dv_prtnr_money "Current or most recent partner ever did not trust her with money"

	//partner displays marital control behaviors
	egen dv_prtnr_cntrl_temp = rowtotal(dv_prtnr_jeals dv_prtnr_accus dv_prtnr_friends dv_prtnr_fam dv_prtnr_where dv_prtnr_money) if v044==1 & v502>0
	recode dv_prtnr_cntrl_temp (1/2=1 "1-2") (3/4=2 "3-4") (5/6=3 "5-6"), gen(dv_prtnr_cntrl_cat)
	label var dv_prtnr_cntrl_cat "Current or most recent partner displays control behaviors"

	//partner displays 3 or more of marital control behaviors
	egen dv_prtnr_cntrl_3 = rowtotal(dv_prtnr_jeals dv_prtnr_accus dv_prtnr_friends dv_prtnr_fam dv_prtnr_where dv_prtnr_money) if v044==1 & v502>0
	recode dv_prtnr_cntrl_3 (3/6=1) (0/2=0)
	label val dv_prtnr_cntrl_3 yesno
	label var dv_prtnr_cntrl_3 "Current or most recent partner displays 3 or more control behaviors"
	
	//partner displays none of these marital control behaviors
	egen dv_prtnr_cntrl_0 = rowtotal(dv_prtnr_jeals dv_prtnr_accus dv_prtnr_friends dv_prtnr_fam dv_prtnr_where dv_prtnr_money) if v044==1 & v502>0
	recode dv_prtnr_cntrl_0  (1/6=1)
	label define dv_prtnr_cntrl_0_lab 0 "no behaviors" 1 "1 or more behaviors"
	label val dv_prtnr_cntrl_0 dv_prtnr_cntrl_0_lab 
	label var dv_prtnr_cntrl_0 "Current or most recent partner displays no control behaviors"
