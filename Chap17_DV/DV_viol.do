/*****************************************************************************************************
Program: 			DV_viol.do
Purpose: 			Code domestic violence indicators from the IR file
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Courtney Allen 
Date last modified: September 24, 2020
*****************************************************************************************************/

/*______________________________________________________________________________
Variables created in this file:

//EXPERIENCE OF PHYSICAL and SEXUAL VIOLENCE
	dv_phy				"Experienced physical violence since age 15"
	dv_phy_12m			"Experienced physical violence in the past 12 months"
	dv_phy_preg			"Experienced physical violence during pregnancy"
	dv_sex				"Ever experienced sexual violence"
	dv_sex_12m			"Experienced sexual violence in the past 12 months"
	dv_sex_age			"Specific age experienced sexual violence"
	dv_phy_only			"Experienced physical violence only"
	dv_sex_only			"Experienced sexual violence only"
	dv_phy_sex_all		"Experienced physical and sexual violence"
	dv_phy_sex_any		"Experienced physical or sexual violence"
	dv_viol_type		"Experienced physical only, sexual only, or both"

//PERSONS COMMITTING PHYSICAL OR SEXUAL VIOLENCE
	dv_phy_hus_curr		"Person committing physical violence: current husband/partner"
	dv_phy_hus_form		"Person committing physical violence: former husband/partner"
	dv_phy_bf_curr		"Person committing physical violence: current boyfriend"
	dv_phy_bf_form		"Person committing physical violence: former boyfriend"
	dv_phy_father		"Person committing physical violence: father/step-father"
	dv_phy_mother		"Person committing physical violence: mother/step-mother"
	dv_phy_sibling		"Person committing physical violence: sister or bother"
	dv_phy_bychild		"Person committing physical violence: daughter/son"
	dv_phy_other_rel	"Person committing physical violence: other relative"
	dv_phy_mother_inlaw	"Person committing physical violence: mother-in-law"
	dv_phy_father_inlaw	"Person committing physical violence: father-in-law"
	dv_phy_other_inlaw	"Person committing physical violence: other-in-law"
	dv_phy_teacher		"Person committing physical violence: teacher"
	dv_phy_atwork		"Person committing physical violence: employer/someone at work"
	dv_phy_police		"Person committing physical violence: police/soldier"
	dv_phy_other		"Person committing physical violence: other"
	
	dv_sex_hus_curr		"Person committing sexual violence: current husband/partner"
	dv_sex_hus_form		"Person committing sexual violence: former husband/partner"
	dv_sex_bf			"Person committing sexual violence: current/former boyfriend"
	dv_sex_father		"Person committing sexual violence: father/step-father"
	dv_sex_brother		"Person committing sexual violence: brother/step-brother"
	dv_sex_other_rel	"Person committing sexual violence: other relative"
	dv_sex_inlaw		"Person committing sexual violence: in-law"
	dv_sex_friend		"Person committing sexual violence: friend/acquaintance"
	dv_sex_friend_fam	"Person committing sexual violence: family friend"
	dv_sex_teacher		"Person committing sexual violence: teacher"
	dv_sex_atwork		"Person committing sexual violence: employer/someone at work"
	dv_sex_relig		"Person committing sexual violence: priest or religious leader"
	dv_sex_police		"Person committing sexual violence: police/soldier"
	dv_sex_stranger		"Person committing sexual violence: stranger"
	dv_sex_other		"Person committing sexual violence: other"
	dv_sex_missing		"Person committing sexual violence: missing"			
	
_//SEEKING HELP AFTER VIOLENCE	
	dv_help_seek		"Help-seeking behavior of women who ever experienced physical or sexual violence"
	dv_help_phy			"Sources of help sought for physical violence among women who sought help"
	dv_help_sex			"Sources of help sought for sexual violence among women who sought help"
	dv_help_phy_sex_all	"Sources of help sought for physical and sexual violence among women who sought help"
	dv_help_phy_sex_any	"Sources of help sought for physical or sexual violence among women who sought help"
	
	
	dv_help_fam 		"Source of help: own family"
	dv_help_hfam 		"Source of help: husband's family"
	dv_help_husb        "Source of help: husband"
	dv_help_bf 			"Source of help: boyfriend"
	dv_help_friend 		"Source of help: friend"
	dv_help_neighbor 	"Source of help: neighbor"
	dv_help_relig 		"Source of help: religious"
	dv_help_doc         "Source of help: doctor"
	dv_help_police      "Source of help: police"
	dv_help_lawyer      "Source of help: lawyer"
	dv_help_sw          "Source of help: social worker"
	dv_help_other       "Source of help: other"


______________________________________________________________________________*/

cap label define yesno 0 "no" 1 "yes" //for all yes/no binary variables

**EXPERIENCED PHYSICAL VIOLENCE
		//ever
		gen dv_phy = 0 if v044==1
		foreach z in a b c d e f g j {
		replace dv_phy = 1 if d105`z'>=1 & d105`z'<=4 //violence by current partner
		}
		replace dv_phy = 1 if d130a>=1 & d130a<=4	  //violence by former partner
		replace dv_phy = 1 if d115y==0				  //violence by anyone other than partner
		replace dv_phy = 1 if d118y==0				  //violence during pregnancy
		label var dv_phy	"Experienced physical violence since age 15"
		label val dv_phy yesno
		
		//in the last 12 months
		gen dv_phy_12m = 0 if v044==1 
		foreach z in a b c d e f g j {
		replace dv_phy_12m = 1 if d105`z'==1 | d105`z'==2 
		}
		replace dv_phy_12m = 1 if d117a==1 | d117a==2 | d130a==1
		label val dv_phy_12m yesno
		label var dv_phy_12m	"Experienced physical violence in past 12 mos"
	
		//in the last 12 months by frequency (often or sometimes)
		gen dv_phy_12m_f = 0 if v044==1
		foreach z in a b c d e f g j {
		replace dv_phy_12m_f = 2 if d105`z'==2 | d117a==2  //sometimes
		}
		foreach z in a b c d e f g j {
		replace dv_phy_12m_f = 1 if d105`z'==1 | d117a==1  //often
		}
		label define lab_12m_f 0 "no" 1 "often" 2 "sometimes"
		label val dv_phy_12m_f lab_12m_f
		label var dv_phy_12m_f	"Experienced physical violence in the past 12 mos, frequency"

	//physical violence during pregnancy
	gen dv_phy_preg = 0 if v044==1 & (v201>0 | v213==1 | v228==1) //Ever had a pregnancy
	replace dv_phy_preg = 1 if d118y==0		
	label val dv_phy_preg yesno
	label var dv_phy_preg	"Experienced physical violence during pregnancy"


**PERSONS COMMITTING PHYSICAL VIOLENCE
	//current partner
	gen dv_phy_hus_curr = 0 if dv_phy==1
	foreach z in a b c d e f g j {
		replace dv_phy_hus_curr = 1 if v502==1 & ((d105`z'>0 & d105`z'<=4) | d118a==1)
		}
	lab var dv_phy_hus_curr		"Person committing physical violence: current husband/partner"
	label val dv_phy_hus_curr yesno

	//former partner
	gen dv_phy_hus_form = 0 if dv_phy==1
	replace dv_phy_hus_form = 1 if (v502==1 | v502==2) & (d115j==1 | d118j==1 | (d130a>0 & d130a!=.))
	foreach z in a b c d e f g j {
	replace dv_phy_hus_form = 1 if v502==2 & (d105`z'>0 & d105`z'<=4)
	}
	lab var dv_phy_hus_form		"Person committing physical violence: former husband/partner"
	label val dv_phy_hus_form yesno

	//current boyfriend
	gen dv_phy_bf_curr = 0 if dv_phy==1
	replace dv_phy_bf_curr = 1 if d115k==1 | d118k==1
	lab var dv_phy_bf_curr		"Person committing physical violence: current boyfriend"
	label val dv_phy_bf_curr yesno

	//former boyfriend
	gen dv_phy_bf_form = 0 if dv_phy==1
	replace dv_phy_bf_form = 1 if d115l==1 | d118l==1
	lab var dv_phy_bf_form		"Person committing physical violence: former boyfriend"
	label val dv_phy_bf_form yesno

	//father step-father
	gen dv_phy_father = 0 if dv_phy==1
	replace dv_phy_father = 1 if d115c==1 | d118c==1
	lab var dv_phy_father		"Person committing physical violence: father/step-father"
	label val dv_phy_father yesno

	//mother or step-mother
	gen dv_phy_mother = 0 if dv_phy==1
	replace dv_phy_mother = 1 if d115b==1 | d118b==1
	lab var dv_phy_mother		"Person committing physical violence: mother/step-mother"
	label val dv_phy_mother yesno

	//sister or brother
	gen dv_phy_sibling = 0 if dv_phy==1
	replace dv_phy_sibling = 1 if d115f==1 | d118f==1
	lab var dv_phy_sibling		"Person committing physical violence: sister or bother"
	label val dv_phy_sibling yesno

	//daughter/son
	gen dv_phy_bychild = 0 if dv_phy==1
	replace dv_phy_bychild = 1 if d115d==1 | d118d==1
	lab var dv_phy_bychild		"Person committing physical violence: daughter/son"
	label val dv_phy_bychild yesno

	//other relative
	gen dv_phy_other_rel = 0 if dv_phy==1
	replace dv_phy_other_rel = 1 if d115g==1 | d118g==1
	lab var dv_phy_other_rel	"Person committing physical violence: other relative"
	label val dv_phy_other_rel yesno

	//mother-in-law
	gen dv_phy_mother_inlaw = 0 if dv_phy==1
	replace dv_phy_mother_inlaw = 1 if d115o==1 | d118o==1
	lab var dv_phy_mother_inlaw	"Person committing physical violence: mother-in-law"
	label val dv_phy_mother_inlaw yesno

	//father-in-law
	gen dv_phy_father_inlaw = 0 if dv_phy==1
	replace dv_phy_father_inlaw = 1 if d115p==1 | d118p==1
	lab var dv_phy_father_inlaw	"Person committing physical violence: father-in-law"
	label val dv_phy_father_inlaw yesno

	//other-in-law
	gen dv_phy_other_inlaw = 0 if dv_phy==1
	replace dv_phy_other_inlaw = 1 if d115q==1 | d118q==1
	lab var dv_phy_other_inlaw	"Person committing physical violence: other-in-law"
	label val dv_phy_other_inlaw yesno

	//teacher
	gen dv_phy_teacher = 0 if dv_phy==1
	replace dv_phy_teacher = 1 if d115v==1 | d118v==1
	lab var dv_phy_teacher		"Person committing physical violence: teacher"
	label val dv_phy_teacher yesno

	//employer/someone at work
	gen dv_phy_atwork = 0 if dv_phy==1
	replace dv_phy_atwork = 1 if d115w==1 | d118w==1
	lab var dv_phy_atwork		"Person committing physical violence: employer/someone at work"
	label val dv_phy_atwork yesno

	//police/soldier
	gen dv_phy_police = 0 if dv_phy==1
	replace dv_phy_police = 1 if d115xe==1 | d118xe==1
	lab var dv_phy_police		"Person committing physical violence: police/soldier"
	label val dv_phy_police yesno

	//other
	gen dv_phy_other = 0 if dv_phy==1
	replace dv_phy_other = 1 if d115x==1 | d118x==1
	lab var dv_phy_other		"Person committing physical violence: other"
	label val dv_phy_other yesno


**EXPERIENCED SEXUAL VIOLENCE
		//ever 
		gen dv_sex = 0 if v044==1
		foreach z in h i k  {
		replace dv_sex = 1 if d105`z'>=1 & d105`z'<=4 //violence by current partner
		}
		replace dv_sex = 1 if d130b>=1 & d130b<=4	  //violence by former partner
		replace dv_sex = 1 if d124==1				  //violence by anyone other than partner
		replace dv_sex = 1 if d125==1				  //forced to perform unwanted acts
		label var dv_sex	"Ever experienced sexual violence"
		label val dv_sex yesno
		
		//in the last 12 months
		gen dv_sex_12m = 0 if v044==1
		foreach z in h i k {
		replace dv_sex_12m = 1 if d105`z'==1 | d105`z'==2 
		}
		replace dv_sex_12m = 1 if d130b==1 | d124==1
		label val dv_sex_12m yesno
		label var dv_sex_12m	"Experienced sexual violence in past 12 mos"
	
		//in the last 12 months by frequency (often or sometimes)
		gen dv_sex_12m_f = 0 if v044==1
		foreach z in h i k {
		replace dv_sex_12m_f = 2 if d105`z'==2 | d117a==2  //sometimes
		}
		foreach z in h i k {
		replace dv_sex_12m_f = 1 if d105`z'==1 | d117a==1  //often
		}
		label define lab_12m_sex_f 0 "no" 1 "yes, often" 2 "yes, sometimes"
		label val dv_sex_12m_f lab_12m_sex_f
		label var dv_sex_12m_f	"Experienced sexual violence in the past 12 mos, frequency"

**EXPERIENCED PHYSICAL AND SEXUAL VIOLENCE
		//ever
		gen dv_phy_sex = 0 if v044==1
		replace dv_phy_sex = 1 if (dv_phy==1 & dv_sex==1)
		label val dv_phy_sex yesno
		label var dv_phy_sex	"Ever experienced physical AND sexual violence"

		//in the last 12 months
		gen dv_phy_sex_12m = 0 if v044==1 
		replace dv_phy_sex_12m = 1 if (dv_phy_12m==1 & dv_sex_12m==1)
		label val dv_phy_sex_12m yesno
		label var dv_phy_sex_12m	"Experienced physical AND sexual violence in the last 12 months"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_phy_sex_12m_f = 0 if v044==1
		replace dv_phy_sex_12m_f = 1 if (dv_phy_12m==1 & dv_sex_12m==1)
		replace dv_phy_sex_12m_f = 2 if (dv_phy_12m==2 & dv_sex_12m==2)
		label val dv_phy_sex_12m_f frequency
		label var dv_phy_sex_12m_f	"Experienced physical AND sexual violence in the last 12 months, frequency"

**EXPERIENCED PHYSICAL OR SEXUAL VIOLENCE
		//ever
		gen dv_phy_sex_any = 0 if v044==1
		replace dv_phy_sex_any = 1 if (dv_phy==1 | dv_sex==1)
		label val dv_phy_sex_any yesno
		label var dv_phy_sex_any	"Ever experienced physical OR sexual violence"

		//in the last 12 months
		gen dv_phy_sex_any_12m = 0 if v044==1
		replace dv_phy_sex_any_12m = 1 if (dv_phy_12m==1 | dv_sex_12m==1)
		label val dv_phy_sex_any_12m yesno
		label var dv_phy_sex_any_12m	"Experienced physical OR sexual violence in the last 12 months"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_phy_sex_any_12m_f = 0 if v044==1 
		replace dv_phy_sex_any_12m_f = 1 if (dv_phy_12m==1 | dv_sex_12m==1)
		replace dv_phy_sex_any_12m_f = 2 if (dv_phy_12m==2 | dv_sex_12m==2)
		label val dv_phy_sex_any_12m_f frequency
		label var dv_phy_sex_any_12m_f	"Experienced physical OR sexual violence in the last 12 months, frequency"

		//which type
		gen dv_viol_type = 0 if dv_phy_sex_any==1
		replace dv_viol_type = 1 if (dv_phy==1 & dv_sex==0)
		replace dv_viol_type = 2 if (dv_phy==0 & dv_sex==1)
		replace dv_viol_type = 3 if (dv_phy==1 & dv_sex==1)
		label define dv_viol_type 1 "physical only" 2 "sexual only" 3 "both"
		label val dv_viol_type dv_viol_type
		label var dv_viol_type	"Ever experienced physical only, sexual only, or both"
	
		//physical only
		gen dv_phy_only = 0 if v044==1
		replace dv_phy_only = 1 if (dv_phy==1 & dv_sex==0)
		label val dv_phy_only yesno
		label var dv_phy_only	"Ever experienced only physical violence"

		//sexual only
		gen dv_sex_only = 0 if v044==1
		replace dv_sex_only = 1 if (dv_phy==0 & dv_sex==1)
		label val dv_sex_only yesno
		label var dv_sex_only	"Ever experienced only sexual violence"
		
**AGE EXPERIENCED SEXUAL VIOLENCE 
	//by age 10
	gen dv_sex_age_10 = 0 if v044==1
	replace dv_sex_age_10 = 1 if d126<10
	label var dv_sex_age_10 "First experienced sexual violence by age 10"
	label val dv_sex_age_10 yesno
	
	//by age 12
	gen dv_sex_age_12 = 0 if v044==1
	replace dv_sex_age_12 = 1 if d126<12
	label var dv_sex_age_12 "First experienced sexual violence by age 12"
	label val dv_sex_age_12 yesno

	//by age 15
	gen dv_sex_age_15 = 0 if v044==1
	replace dv_sex_age_15 = 1 if d126<15
	label var dv_sex_age_15 "First experienced sexual violence by age 15"
	label val dv_sex_age_15 yesno

	//by age 18
	gen dv_sex_age_18 = 0 if v044==1
	replace dv_sex_age_18 = 1 if d126<18
	label var dv_sex_age_18 "First experienced sexual violence by age 18"
	label val dv_sex_age_18 yesno

	//by age 22
	gen dv_sex_age_22 = 0 if v044==1
	replace dv_sex_age_22 = 1 if d126<22
	label var dv_sex_age_22 "First experienced sexual violence by age 22"
	label val dv_sex_age_22 yesno

**PERSONS COMMITTING SEXUAL VIOLENCE 
	//current partner
	gen dv_sex_hus_curr = 0 if dv_sex==1
	foreach z in h i k {
		replace dv_sex_hus_curr = 1 if v502==1 & ((d105`z'>0 & d105`z'<=4) | d127==1)
		}
	lab var dv_sex_hus_curr		"Person committing sexual violence: current husband/partner"
	label val dv_sex_hus_curr yesno

	//former partner
	gen dv_sex_hus_form = 0 if dv_sex==1
	replace dv_sex_hus_form = 1 if v502==1 & (d127==2 & v503!=1)
	replace dv_sex_hus_form = 1 if (v502==1 |v502==2) & (d130b>0 & d130b!=.)
	foreach z in h i k {
	replace dv_sex_hus_form = 1 if v502==2 & (d127==2 | (d105`z'>0 & d105`z'<=4))
	}
	lab var dv_sex_hus_form		"Person committing sexual violence: former husband/partner"
	label val dv_sex_hus_form yesno

	//current or former boyfriend
	gen dv_sex_bf = 0 if dv_sex==1
	replace dv_sex_bf = 1 if (v502==1 & d127==2 & v503==1) | (v502==0 & (d127==1 | d127==2))
	replace dv_sex_bf = 1 if d127==3
	lab var dv_sex_bf		"Person committing sexual violence: current/former boyfriend"
	label val dv_sex_bf yesno

	//father step-father
	gen dv_sex_father = 0 if dv_sex==1
	replace dv_sex_father = 1 if d127==4
	lab var dv_sex_father		"Person committing sexual violence: father/step-father"
	label val dv_sex_father yesno

	//brother
	gen dv_sex_brother = 0 if dv_sex==1
	replace dv_sex_brother = 1 if d127==5
	lab var dv_sex_brother		"Person committing sexual violence: bother"
	label val dv_sex_brother yesno

	//other relative
	gen dv_sex_other_rel = 0 if dv_sex==1
	replace dv_sex_other_rel = 1 if d127==6
	lab var dv_sex_other_rel	"Person committing sexual violence: other relative"
	label val dv_sex_other_rel yesno

	//in-law
	gen dv_sex_inlaw = 0 if dv_sex==1
	replace dv_sex_inlaw = 1 if d127==7
	lab var 	dv_sex_inlaw		"Person committing sexual violence: an in-law"
	label val dv_sex_inlaw yesno

	//friend or acquaintance
	gen dv_sex_friend = 0 if dv_sex==1
	replace dv_sex_friend = 1 if d127==8
	lab var dv_sex_friend		"Person committing sexual violence: own friend/acquaintance"
	label val dv_sex_friend yesno

	//friend of the family
	gen dv_sex_friend_fam = 0 if dv_sex==1
	replace dv_sex_friend_fam = 1 if d127==9
	lab var dv_sex_friend_fam	"Person committing sexual violence: a family friend"
	label val dv_sex_friend_fam yesno

	//teacher
	gen dv_sex_teacher = 0 if dv_sex==1
	replace dv_sex_teacher = 1 if d127==10
	lab var dv_sex_teacher		"Person committing sexual violence: teacher"
	label val dv_sex_teacher yesno

	//employer/someone at work
	gen dv_sex_atwork = 0 if dv_sex==1
	replace dv_sex_atwork = 1 if d127==11
	lab var dv_sex_atwork		"Person committing sexual violence: employer/someone at work"
	label val dv_sex_atwork yesno

	//police/soldier
	gen dv_sex_police = 0 if dv_sex==1
	replace dv_sex_police = 1 if d127==12
	lab var dv_sex_police		"Person committing sexual violence: police/soldier"
	label val dv_sex_police yesno

	//priest/religious leader
	gen dv_sex_relig = 0 if dv_sex==1
	replace dv_sex_relig = 1 if d127==13
	lab var dv_sex_relig		"Person committing sexual violence: a priest or religious leader"
	label val dv_sex_relig yesno

	//stranger
	gen dv_sex_stranger = 0 if dv_sex==1
	replace dv_sex_stranger = 1 if d127==14
	lab var dv_sex_stranger		"Person committing sexual violence: stranger"
	label val dv_sex_stranger yesno

	//other
	gen dv_sex_other = 0 if dv_sex==1
	replace dv_sex_other = 1 if d127==96
	lab var dv_sex_other		"Person committing sexual violence: other"
	label val dv_sex_other yesno
	
	//missing
	gen dv_sex_missing = 0 if dv_sex==1
	replace dv_sex_missing = 1 if d127==99
	lab var dv_sex_missing		"Person committing sexual violence: missing"
	lab val dv_sex_missing yesno

********************************************************************************
**Seeking help after violence
********************************************************************************
	
	//sought help
	gen dv_help_seek = 0 if dv_phy_sex_any==1
	replace dv_help_seek = 1 if d119y==0
	replace dv_help_seek = 2 if (d119y==1 & d128==1)
	replace dv_help_seek = 3 if (d119y==1 & d128==0)
	label define dv_help_seek 1 "Sought help" 2 "Didn't seek help, told someone" 3 "Didn't seek help, didn't tell someone"
	label val dv_help_seek dv_help_seek
	lab var dv_help_seek		"Sought help to stop violence"
	
	//sources of help: own family
	gen dv_help_fam = 0 if dv_help_seek==1
	foreach x in b c d e f g h m n {
	replace dv_help_fam = 1 if d119`x'==1
	}
	lab val dv_help_fam yesno
	lab var dv_help_fam		"Sought help from own family"

	//sources of help: husband's family
	gen dv_help_hfam = 0 if dv_help_seek==1
	foreach x in i o p q r {
	replace dv_help_hfam = 1 if d119`x'==1
	}
	lab val dv_help_hfam yesno
	lab var dv_help_hfam		"Sought help from husband's family"

	//sources of help: husband
	gen dv_help_husb = 0 if dv_help_seek==1
	foreach x in a j {
	replace dv_help_husb = 1 if d119`x'==1
	}
	lab val dv_help_husb yesno
	lab var dv_help_husb		"Sought help from husband"

	//sources of help: boyfriend
	gen dv_help_bf = 0 if dv_help_seek==1
	foreach x in k l {
	replace dv_help_bf = 1 if d119`x'==1
	}
	lab val dv_help_bf yesno
	lab var dv_help_bf		"Sought help from boyfriend"

	//sources of help: friend
	gen dv_help_friend = 0 if dv_help_seek==1
	foreach x in s t xd {
	replace dv_help_friend = 1 if d119`x'==1
	}
	lab val dv_help_friend yesno
	lab var dv_help_friend		"Sought help from friend"

	//sources of help: neighbor
	gen dv_help_neighbor = 0 if dv_help_seek==1
	foreach x in u {
	replace dv_help_neighbor = 1 if d119`x'==1
	}
	lab val dv_help_neighbor yesno
	lab var dv_help_neighbor		"Sought help from neighbor"

	//sources of help: religious leader
	gen dv_help_relig = 0 if dv_help_seek==1
	foreach x in xf {
	replace dv_help_relig = 1 if d119`x'==1
	}
	lab val dv_help_relig yesno
	lab var dv_help_relig		"Sought help from religious leader"

	//sources of help: doctor or medical personnel
	gen dv_help_doc = 0 if dv_help_seek==1
	foreach x in xh {
	replace dv_help_doc = 1 if d119`x'==1
	}
	lab val dv_help_doc yesno
	lab var dv_help_doc		"Sought help from doctor or medical personnel"

	//sources of help: police
	gen dv_help_police = 0 if dv_help_seek==1
	foreach x in xe {
	replace dv_help_police = 1 if d119`x'==1
	}
	lab val dv_help_police yesno
	lab var dv_help_police		"Sought help from police"

	//sources of help: lawyer
	gen dv_help_lawyer = 0 if dv_help_seek==1
	foreach x in xg {
	replace dv_help_lawyer = 1 if d119`x'==1
	}
	lab val dv_help_lawyer yesno
	lab var dv_help_lawyer		"Sought help from lawyer"

	//sources of help: social work organization
	gen dv_help_sw = 0 if dv_help_seek==1
	foreach x in xb {
	replace dv_help_sw = 1 if d119`x'==1
	}
	lab val dv_help_sw yesno
	lab var dv_help_sw		"Sought help from social work organization"

	//sources of help: other
	gen dv_help_other = 0 if dv_help_seek==1
	foreach x in v w x xa xc xi xj xk {
	replace dv_help_other = 1 if d119`x'==1
	}
	lab val dv_help_other yesno
	lab var dv_help_other		"Sought help from other"


