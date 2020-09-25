/*****************************************************************************************************
Program: 			DV_prtnr.do
Purpose: 			Code domestic violence for spousal violence indicators from the IR file
Data inputs: 		IR data files
Data outputs:		coded variables
Author:				Courtney Allen 
Date last modified: September 09 2020
*****************************************************************************************************/

/*______________________________________________________________________________
Variables created in this file:
	
//CURRENT PARTNER VIOLENCE	
	----------------------------------------------------------------------------
	*each indicator in this series has an additional 2 variables with the suffixes
	"12m"	indicates event occurred in last 12 months, and 
	"12m_f" indicates a new variable that describes if the event that occurred 
	often or sometimes.*
	
	For example:
	dv_prtnr_slap				"Ever slapped by partner"
	dv_prtnr_slap_12m			"Slapped in past 12 mos. by partner"
	dv_prtnr_slap_12m_f		"Slapped in past 12 mos. by partner, frequency"
	----------------------------------------------------------------------------

	//physical
	dv_prtnr_phy	  
	dv_prtnr_push				"Ever pushed, shook, or had something thrown at her in past 12 mos. by partner"
	dv_prtnr_slap				"Ever slapped by partner"
	dv_prtnr_twist				"Ever had arm twisted or hair pulled mos. by partner"
	dv_prtnr_punch				"Ever punched with first or something else that could hurt her by partner"
	dv_prtnr_kick				"Ever kicked, dragged, or beat up by partner"
	dv_prtnr_choke				"Ever tried to choke or burn her by partner"
	dv_prtnr_weapon				"Ever threatened or attacked with a knife, gun, or other weapon by partner"
		 
	//sexual
	dv_prtnr_sex				"Ever experienced any sexual violence by partner"
	dv_prtnr_force				"Physically forced to have sex when she did not want to by partner"
	dv_prtnr_force_act			"Physically forced to perform other sexual acts when she did not want to by partner"
	dv_prtnr_threat_act			"Forced with threats or in any other way to perform sexual acts she did not want to by partner"
		
	//emotional
	dv_prtnr_emot				"Any emotional violence by partner"
	dv_prtnr_humil				"Humiliated in front of others by partner"
	dv_prtnr_threat				"Threatened to hurt or harm her or someone she cared about by partner"
	dv_prtnr_insult				"Insulted or made to feel bad about herself by partner"
		
	//combinations of violence (combinations do not need a _freq variable)
	dv_prtnr_phy_sex			"Ever experienced physical AND sexual violence by partner"
	dv_prtnr_phy_sex_emot		"Ever experienced physical AND sexual AND emotional violence by partner"
	dv_prtnr_phy_sex_any		"Ever experienced physical OR sexual violence by partner"
	dv_prtnr_phy_sex_emot_any	"Ever experienced physical OR sexual OR emotional violence by partner"
				
//ANY PARTNER VIOLENCE	
	dv_aprtnr_phy				"Experienced physical by any partner"
	dv_aprtnr_sex				"Experienced sexual violence by any partner"
	dv_aprtnr_emot				"Experienced emotional violence by any partner"
	dv_aprtnr_phy_sex			"Experienced physical and sexual violence by any partner"
	dv_aprtnr_phy_sex_any		"Ever experienced physical OR sexual violence by any partner"
	dv_aprtnr_phy_sex_emot		"Ever experienced physical AND sexual AND emotional violence by any partner"
	dv_aprtnr_phy_sex_emot_any	"Ever experienced physical OR sexual OR emotional violence by any partner"
		
	dv_prtnr_viol_years	"Experience of physical or sexual violence by partner by specific exact years since marriage - among women only married once"
	dv_prtnr_viol_none	"Did not experience physical or sexual violence by partner - among women only married once"
	
//VIOLENCE BY MARRIAGE DURATION
	dv_marr_viol_0		"Exp"erience of violence by exact marriage duration: before marriage"
	dv_marr_viol_2		"Exp"erience of violence by exact marriage duration: 2 yrs of marriage"
	dv_marr_viol_5		"Exp"erience of violence by exact marriage duration: 5 yrs of marriage"
	dv_marr_viol_10		"Exp"erience of violence by exact marriage duration: 10 yrs of marriage"

//INITIATION OF SPOUSAL VIOLENCE BY WOMEN
	dv_prtnr_cuts		"Have cuts, bruises, or aches as a result of the violence by partner"
	dv_prtnr_injury		"Have eye injuries, sprains, dislocations, or burns as a result of the violence by partner"
	dv_prtnr_broken		"Deep wounds, broken bones, broken teeth, or any other serious injury as a result of the violence by partner"
	dv_prtnr_injury_any	"Have any injury as a result of the violence by partner"
		
	dv_abusedhus_phy	  "Ever committed physical violence against partner when he was not already beating or physically hurting her"
	dv_abusedhus_phy_12m "Committed physical violence against partner in past 12 mos. when he was not already beating or physically hurting her"

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
_____________________________________________________________________________*/

cap gen dwt = d005/1000000
label define frequency 0 "no" 1 "often" 2 "sometimes"


********************************************************************************
**covariates needed for tables
********************************************************************************
	//duration of marriage
	recode v512 (0/1= 1 "<2") (2/4=2 "2-4") (5/9=3 "5-9") (10/50=4 "10+"), gen(mar_years)
	label var mar_years "Years since first cohabitation"


	
********************************************************************************	
**Current partner physical violence, by types of violence
********************************************************************************	

	//ANY PARTNER VIOLENCE
		//ever
		gen dv_prtnr_phy = 0 if v044==1 & v502>0
		foreach x in a b c d e f g j {
			replace dv_prtnr_phy = 1 if d105`x'>0 & d105`x'<=3
			
			}
		label val dv_prtnr_phy yesno
		label var dv_prtnr_phy	"Any physical violence by partner"

		//in last 12 months
		gen dv_prtnr_phy_12m = 0 if v044==1 & v502>0
		foreach x in a b c d e f g j {
			replace dv_prtnr_phy_12m = 1 if (d105`x'==1 | d105`x'==2)
			}
		label val dv_prtnr_phy_12m yesno
		label var dv_prtnr_phy_12m	"Any physical violence in past 12 mos. by partner"

		//in last 12 months, freq
		gen dv_prtnr_phy_12m_f = 0 if v044==1 & v502>0
		foreach x in 2 1 {
			replace dv_prtnr_phy_12m_f = `x' if (d105a==`x')
			replace dv_prtnr_phy_12m_f = `x' if (d105b==`x')
			replace dv_prtnr_phy_12m_f = `x' if (d105c==`x')
			replace dv_prtnr_phy_12m_f = `x' if (d105d==`x')
			replace dv_prtnr_phy_12m_f = `x' if (d105e==`x')
			replace dv_prtnr_phy_12m_f = `x' if (d105f==`x')
			replace dv_prtnr_phy_12m_f = `x' if (d105g==`x')
			replace dv_prtnr_phy_12m_f = `x' if (d105j==`x')
			}
		label val dv_prtnr_phy_12m_f frequency
		label var dv_prtnr_phy_12m_f	"Any physical violence in past 12 mos. by partner, frequency"
	

	
	//TYPE OF VIOLENCE: PUSHED, SHOOK, OR SOMETHING THROWN AT HER
		//ever
		gen dv_prtnr_push = 0 if v044==1 & v502>0
		replace dv_prtnr_push = 1 if d105a>0 & d105a<=3
		label val dv_prtnr_push yesno
		label var dv_prtnr_push		"Ever pushed, shook, or had something thrown at her by partner"

		//in the last 12 months
		gen dv_prtnr_push_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_push_12m = 1 if (d105a==1 | d105a==2)
		label val dv_prtnr_push_12m yesno
		label var dv_prtnr_push_12m		"Pushed, shook, or had something thrown at her in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_push_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_push_12m_f = 1 if d105a==1 
		replace dv_prtnr_push_12m_f = 2 if d105a==2 
		label val dv_prtnr_push_12m_f frequency
		label var dv_prtnr_push_12m_f		"Pushed, shook, or had something thrown at her in past 12 mos. by partner, frequency"

	
	
	//TYPE OF VIOLENCE: SLAPPED
		//ever
		gen dv_prtnr_slap = 0 if v044==1 & v502>0
		replace dv_prtnr_slap = 1 if d105b>0 & d105b<=3
		label val dv_prtnr_slap yesno
		label var dv_prtnr_slap		"Ever slapped by partner"

		//in the last 12 months
		gen dv_prtnr_slap_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_slap_12m = 1 if (d105b==1 | d105b==2)
		label val dv_prtnr_slap_12m yesno
		label var dv_prtnr_slap_12m		"Slapped in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_slap_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_slap_12m_f = 1 if d105b==1
		replace dv_prtnr_slap_12m_f = 2 if d105b==2
		label val dv_prtnr_slap_12m_f frequency
		label var dv_prtnr_slap_12m_f		"Slapped in past 12 mos. by partner, frequency"

	
	
	//TYPE OF VIOLENCE: ARM TWISTED OR HAIR PULLED
		//ever
		gen dv_prtnr_twist = 0 if v044==1 & v502>0
		replace dv_prtnr_twist = 1 if d105j>0 & d105j<=3
		label val dv_prtnr_twist yesno
		label var dv_prtnr_twist	"Had arm twisted or hair pulled in past partner"

		//in the last 12 months
		gen dv_prtnr_twist_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_twist_12m = 1 if (d105j==1 | d105j==2)
		label val dv_prtnr_twist_12m yesno
		label var dv_prtnr_twist_12m	"Had arm twisted or hair pulled in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_twist_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_twist_12m_f = 1 if d105j==1
		replace dv_prtnr_twist_12m_f = 2 if d105j==2
		label val dv_prtnr_twist_12m_f frequency
		label var dv_prtnr_twist_12m_f	"Had arm twisted or hair pulled in past 12 mos. by partner, frequency"

	
	
	//TYPE OF VIOLENCE: PUNCHED
		//ever
		gen dv_prtnr_punch = 0 if v044==1 & v502>0
		replace dv_prtnr_punch = 1 if d105c>0 & d105c<=3
		label val dv_prtnr_punch yesno
		label var dv_prtnr_punch	"Punched with first or something else that could hurt her by partner"

		//in the last 12 months
		gen dv_prtnr_punch_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_punch_12m = 1 if (d105c==1 | d105c==2)
		label val dv_prtnr_punch_12m yesno
		label var dv_prtnr_punch_12m	"Punched with first or something else that could hurt her in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_punch_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_punch_12m_f = 1 if d105c==1 
		replace dv_prtnr_punch_12m_f = 2 if d105c==2
		label val dv_prtnr_punch_12m_f frequency
		label var dv_prtnr_punch_12m_f	"Punched with first or something else that could hurt her in past 12 mos. by partner, frequency"
	
	
	
	//TYPE OF VIOLENCE: KICKED, DRAGGED, BEAT UP
		//ever
		gen dv_prtnr_kick = 0 if v044==1 & v502>0
		replace dv_prtnr_kick = 1 if d105d>0 & d105d<=3
		label val dv_prtnr_kick yesno
		label var dv_prtnr_kick		"Kicked, dragged, or beat up by partner"

		//in the last 12 months
		gen dv_prtnr_kick_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_kick_12m = 1 if (d105d==1 | d105d==2)
		label val dv_prtnr_kick_12m yesno
		label var dv_prtnr_kick_12m		"Kicked, dragged, or beat up in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_kick_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_kick_12m_f = 1 if d105d==1 
		replace dv_prtnr_kick_12m_f = 2 if d105d==2
		label val dv_prtnr_kick_12m_f frequency
		label var dv_prtnr_kick_12m_f		"Kicked, dragged, or beat up in past 12 mos. by partner, frequency"

		
		
	//TYPE OF VIOLENCE: CHOKED
		//ever
		gen dv_prtnr_choke = 0 if v044==1 & v502>0
		replace dv_prtnr_choke = 1 if d105e>0 & d105e<=3
		label val dv_prtnr_choke yesno
		label var dv_prtnr_choke	"Tried to choke or burn her by partner"

		//in the last 12 months
		gen dv_prtnr_choke_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_choke_12m = 1 if (d105e==1 | d105e==2)
		label val dv_prtnr_choke_12m yesno
		label var dv_prtnr_choke_12m	"Tried to choke or burn her in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_choke_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_choke_12m_f = 1 if d105e==1
		replace dv_prtnr_choke_12m_f = 2 if d105e==2
		label val dv_prtnr_choke_12m_f frequency
		label var dv_prtnr_choke_12m_f	"Tried to choke or burn her in past 12 mos. by partner, frequency"

	
	
	//TYPE OF VIOLENCE: THREATENED WITH WEAPON
		//ever
		gen dv_prtnr_weapon = 0 if v044==1 & v502>0
		replace dv_prtnr_weapon = 1 if d105f>0 & d105f<=3
		label val dv_prtnr_weapon yesno
		label var dv_prtnr_weapon	"Threatened or attacked with a knife, gun, or weapon by partner"

		//in the last 12 months
		gen dv_prtnr_weapon_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_weapon_12m = 1 if d105f==1 | d105f==2
		label val dv_prtnr_weapon_12m yesno
		label var dv_prtnr_weapon_12m	"Threatened or attacked with a knife, gun, or weapon in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_weapon_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_weapon_12m_f = 1 if d105f==1 
		replace dv_prtnr_weapon_12m_f = 2 if d105f==2
		label val dv_prtnr_weapon_12m_f frequency
		label var dv_prtnr_weapon_12m_f	"Threatened or attacked with a knife, gun, or weapon in past 12 mos. by partner, frequency"
	
	
	
	
	
********************************************************************************	
**Current partner sexual violence: types of violence
********************************************************************************
	//ANY SEXUAL VIOLENCE
		//ever
		gen dv_prtnr_sex = 0 if v044==1 & v502>0
		foreach x in h i k {
			replace dv_prtnr_sex = 1 if d105`x'>0  & d105`x'<=3
			}
		label val dv_prtnr_sex yesno
		label var dv_prtnr_sex	"Any sexual violence in past by partner"
		
		//in the last 12 months
		gen dv_prtnr_sex_12m = 0 if v044==1 & v502>0
		foreach x in h i k {
			replace dv_prtnr_sex_12m = 1 if (d105`x'==1 | d105`x'==2)
			}
		label val dv_prtnr_sex_12m yesno
		label var dv_prtnr_sex_12m	"Any sexual violence in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_sex_12m_f = 0 if v044==1 & v502>0
		foreach x in 2 1 {
			replace dv_prtnr_sex_12m_f = `x' if d105h==`x'
			replace dv_prtnr_sex_12m_f = `x' if d105i==`x'
			replace dv_prtnr_sex_12m_f = `x' if d105k==`x'
			}
		label val dv_prtnr_sex_12m_f frequency
		label var dv_prtnr_sex_12m_f	"Any sexual violence in past 12 mos. by partner, frequency"

		
		
	//TYPE OF VIOLENCE: FORCED TO HAVE SEX
		//ever
		gen dv_prtnr_force = 0 if v044==1 & v502>0
		replace dv_prtnr_force = 1 if d105h>0 & d105h<=3
		label val dv_prtnr_force yesno
		label var dv_prtnr_force	"Physically forced to have unwanted sex by partner"
		
		//in the last 12 months
		gen dv_prtnr_force_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_force_12m = 1 if (d105h==1 | d105h==2)
		label val dv_prtnr_force_12m yesno
		label var dv_prtnr_force_12m	"Physically forced to have unwanted sex in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_force_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_force_12m_f = 1 if d105h==1
		replace dv_prtnr_force_12m_f = 2 if d105h==2
		label val dv_prtnr_force_12m_f frequency
		label var dv_prtnr_force_12m_f	"Physically forced to have unwanted sex in past 12 mos. by partner, frequency"

		
		
	//TYPE OF VIOLENCE: FORCED TO PERFORM OTHER SEXUAL ACTS
		//ever
		gen dv_prtnr_force_act = 0 if v044==1 & v502>0
		replace dv_prtnr_force_act = 1 if d105k>0 & d105k<=3
		label val dv_prtnr_force_act yesno
		label var dv_prtnr_force_act	"Physically forced to perform other sexual acts when she did not want to by partner"
		
		//in the last 12 months
		gen dv_prtnr_force_act_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_force_act_12m = 1 if (d105k==1 | d105k==2)
		label val dv_prtnr_force_act_12m yesno
		label var dv_prtnr_force_act_12m	"Physically forced to perform other sexual acts when she did not want to in past 12 mos. by partner"
		
		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_force_act_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_force_act_12m_f = 1 if d105k==1
		replace dv_prtnr_force_act_12m_f = 2 if d105k==2
		label val dv_prtnr_force_act_12m_f frequency
		label var dv_prtnr_force_act_12m_f	"Physically forced to perform other sexual acts when she did not want to in past 12 mos. by partner, frequency"

		
		
	//TYPE OF VIOLENCE: FORCED WITH THREATS
		//ever
		gen dv_prtnr_threat_act = 0 if v044==1 & v502>0
		replace dv_prtnr_threat_act = 1 if d105i>0 & d105i<=3
		label val dv_prtnr_threat_act yesno
		label var dv_prtnr_threat_act	"Ever forced with threats or other ways to perform sexual acts she did not want to by partner"

		//in the last 12 months
		gen dv_prtnr_threat_act_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_threat_act_12m = 1 if (d105i==1 | d105i==2)
		label val dv_prtnr_threat_act_12m yesno
		label var dv_prtnr_threat_act_12m	"Forced with threats or other ways to perform sexual acts she did not want to in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_threat_act_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_threat_act_12m_f = 1 if d105i==1
		replace dv_prtnr_threat_act_12m_f = 2 if d105i==2
		label val dv_prtnr_threat_act_12m_f frequency
		label var dv_prtnr_threat_act_12m_f	"Forced with threats or other ways to perform sexual acts she did not want to in past 12 mos. by partner, frequency"

		
		
		
		
********************************************************************************	
**Current partner emotional violence: types of violence
********************************************************************************
	
	//EXPERIENCED AND EMOTIONAL VIOLENCE
		//ever
		gen dv_prtnr_emot = 0 if v044==1 & v502>0
		foreach x in a b c {
			replace dv_prtnr_emot = 1 if d103`x'>0 & d103`x'<=3
			}
		label val dv_prtnr_emot yesno
		label var dv_prtnr_emot	"Any emotional violence by partner"

		//in the last 12 months
		gen dv_prtnr_emot_12m = 0 if v044==1 & v502>0
		foreach x in a b c {
			replace dv_prtnr_emot_12m = 1 if (d103`x'==1 | d103`x'==2)
			}
		label val dv_prtnr_emot_12m yesno
		label var dv_prtnr_emot_12m	"Any emotional violence by partner in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_emot_12m_f = 0 if v044==1 & v502>0
		foreach x in 2 1 {
			replace dv_prtnr_emot_12m_f = `x' if d103a==`x'
			replace dv_prtnr_emot_12m_f = `x' if d103b==`x'
			replace dv_prtnr_emot_12m_f = `x' if d103c==`x'
			}
		label val dv_prtnr_emot_12m_f frequency
		label var dv_prtnr_emot_12m_f	"Any emotional violence by partner in past 12 mos. by partner, frequency"

		
		
	//HUMILIATED IN FRONT OF OTHERS
		//ever
		gen dv_prtnr_humil = 0 if v044==1 & v502>0
		replace dv_prtnr_humil = 1 if d103a>0 & d103a<=3
		label val dv_prtnr_humil yesno
		label var dv_prtnr_humil "Humiliated in front of others by partner"

		//in last 12 months
		gen dv_prtnr_humil_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_humil_12m = 1 if (d103a==1 | d103a==2)
		label val dv_prtnr_humil_12m yesno
		label var dv_prtnr_humil_12m "Humiliated in front of others in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_humil_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_humil_12m_f = 1 if d103a==1
		replace dv_prtnr_humil_12m_f = 2 if d103a==2
		label val dv_prtnr_humil_12m_f frequency
		label var dv_prtnr_humil_12m_f "Humiliated in front of others in past 12 mos. by partner, frequency"

		
		
		
	//THREATENED TO HURT OR HARM HER OR SOMEONE SHE CARED ABOUT
		//ever
		gen dv_prtnr_threat = 0 if v044==1 & v502>0
		replace dv_prtnr_threat = 1 if d103b>0 & d103b<=3
		label val dv_prtnr_threat yesno
		label var dv_prtnr_threat "Threatened to hurt or harm her or someone she cared about by partner"
		
		//in the last 12 months
		gen dv_prtnr_threat_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_threat_12m = 1 if (d103b==1 | d103b==2)
		label val dv_prtnr_threat_12m yesno
		label var dv_prtnr_threat_12m "Threatened to hurt or harm her or someone she cared about in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_threat_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_threat_12m_f = 1 if d103b== 1
		replace dv_prtnr_threat_12m_f = 2 if d103b==2
		label val dv_prtnr_threat_12m_f frequency
		label var dv_prtnr_threat_12m_f "Threatened to hurt or harm her or someone she cared about in past 12 mos. by partner, frequency"

		

	//INSULTED OR MADE TO FEEL BAD ABOUT HERSELF
		//ever
		gen dv_prtnr_insult = 0 if v044==1 & v502>0
		replace dv_prtnr_insult = 1 if d103c>0 & d103c<=3
		label val dv_prtnr_insult yesno
		label var dv_prtnr_insult "Insulted or made to feel bad about herself by partner"
		
		//in the last 12 months
		gen dv_prtnr_insult_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_insult_12m = 1 if (d103c==1 | d103c==2)
		label val dv_prtnr_insult_12m yesno
		label var dv_prtnr_insult_12m "Insulted or made to feel bad about herself in past 12 mos. by partner"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_insult_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_insult_12m_f = 1 if d103c==1
		replace dv_prtnr_insult_12m_f = 2 if d103c==2
		label val dv_prtnr_insult_12m_f frequency
		label var dv_prtnr_insult_12m_f "Insulted or made to feel bad about herself in past 12 mos. by partner, frequency"
		
		
		
		
		
********************************************************************************	
**Combinations of types of violence
********************************************************************************
	
	//EXPERIENCED PHYSICAL AND SEXUAL VIOLENCE BY PARTNER
		//ever
		gen dv_prtnr_phy_sex = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex = 1 if (dv_prtnr_phy==1 & dv_prtnr_sex==1)
		label val dv_prtnr_phy_sex yesno
		label var dv_prtnr_phy_sex	"Ever experienced physical and sexual violence by partner"

		//in the last 12 months
		gen dv_prtnr_phy_sex_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_12m = 1 if (dv_prtnr_phy_12m==1 & dv_prtnr_sex_12m==1)
		label val dv_prtnr_phy_sex_12m yesno
		label var dv_prtnr_phy_sex_12m	"Experienced physical and sexual violence by partner in the last 12 months"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_phy_sex_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_12m_f = 2 if (dv_prtnr_phy_12m==2 & dv_prtnr_sex_12m==2)
		replace dv_prtnr_phy_sex_12m_f = 1 if (dv_prtnr_phy_12m==1 & dv_prtnr_sex_12m==1)
		label val dv_prtnr_phy_sex_12m_f frequency
		label var dv_prtnr_phy_sex_12m_f	"Experienced physical and sexual violence by partner in the last 12 months, frequency"
		
		
	//EXPERIENCED PHYSICAL AND SEXUAL AND EMOTIONAL VIOLENCE BY PARTNER
		//ever
		gen dv_prtnr_phy_sex_emot = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_emot = 1 if (dv_prtnr_phy==1 & dv_prtnr_sex==1 & dv_prtnr_emot==1)
		label val dv_prtnr_phy_sex_emot yesno
		label var dv_prtnr_phy_sex_emot	"Ever experienced physical and sexual and emotional violence by partner"

		//in the last 12 months
		gen dv_prtnr_phy_sex_emot_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_emot_12m = 1 if (dv_prtnr_phy_12m==1 & dv_prtnr_sex_12m==1 & dv_prtnr_emot_12m==1)
		label val dv_prtnr_phy_sex_emot_12m yesno
		label var dv_prtnr_phy_sex_emot_12m	"Experienced physical and sexual and emotional violence by partner in the last 12 months"
		
		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_phy_sex_emot_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_emot_12m_f = 2 if (dv_prtnr_phy_12m_f==2 & dv_prtnr_sex_12m_f==2 &  dv_prtnr_emot_12m_f==2)
		replace dv_prtnr_phy_sex_emot_12m_f = 1 if (dv_prtnr_phy_12m_f==1 & dv_prtnr_sex_12m_f==1 &  dv_prtnr_emot_12m_f==1)
		label val dv_prtnr_phy_sex_emot_12m_f frequency
		label var dv_prtnr_phy_sex_emot_12m_f	"Experienced physical and sexual and emotional violence by partner in the last 12 months, frequency"

		
	
	//EXPERIENCED PHYSICAL OR SEXUAL VIOLENCE BY PARTNER
		//ever
		gen dv_prtnr_phy_sex_any = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_any = 1 if (dv_prtnr_phy==1 | dv_prtnr_sex==1)
		label val dv_prtnr_phy_sex_any yesno
		label var dv_prtnr_phy_sex_any	"Ever experienced physical OR sexual violence by partner"

		//in the last 12 months
		gen dv_prtnr_phy_sex_any_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_any_12m = 1 if (dv_prtnr_phy_12m==1 | dv_prtnr_sex_12m==1)
		label val dv_prtnr_phy_sex_any_12m yesno
		label var dv_prtnr_phy_sex_any_12m	"Experienced physical OR sexual violence by partner in the last 12 months"

		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_phy_sex_any_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_any_12m_f = 2 if (dv_prtnr_phy_12m_f==2 | dv_prtnr_sex_12m_f==2)
		replace dv_prtnr_phy_sex_any_12m_f = 1 if (dv_prtnr_phy_12m_f==1 | dv_prtnr_sex_12m_f==1)
		label val dv_prtnr_phy_sex_any_12m_f frequency
		label var dv_prtnr_phy_sex_any_12m_f"Experienced physical OR sexual violence by partner in the last 12 months, frequency"

		
		
		
	//EXPERIENCED PHYSICAL OR SEXUAL OR EMOTIONAL VIOLENCE BY PARTNER
		//ever
		gen dv_prtnr_phy_sex_emot_any = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_emot_any = 1 if (dv_prtnr_phy==1 | dv_prtnr_sex==1 | dv_prtnr_emot==1)
		label val dv_prtnr_phy_sex_emot_any yesno
		label var dv_prtnr_phy_sex_emot_any	"Ever experienced physical OR sexual OR emotional violence by partner"

		//in the last 12 months
		gen dv_prtnr_phy_sex_emot_any_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_emot_any_12m = 1 if (dv_prtnr_phy_12m==1 | dv_prtnr_sex_12m==1 | dv_prtnr_emot_12m==1)
		label val dv_prtnr_phy_sex_emot_any_12m yesno
		label var dv_prtnr_phy_sex_emot_any_12m	"Experienced physical OR sexual OR emotional violence by partner in the last 12 months"
	
		//in the last 12 months by frequency (often or sometimes)
		gen dv_prtnr_phy_sex_emot_any_12m_f = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_emot_any_12m_f = 2 if (dv_prtnr_phy_12m_f==2 | dv_prtnr_sex_12m_f==2 | dv_prtnr_emot_12m_f==2)
		replace dv_prtnr_phy_sex_emot_any_12m_f = 1 if (dv_prtnr_phy_12m_f==1 | dv_prtnr_sex_12m_f==1 | dv_prtnr_emot_12m_f==1)
		label val dv_prtnr_phy_sex_emot_any_12m_f frequency
		label var dv_prtnr_phy_sex_emot_any_12m_f	"Experienced physical OR sexual OR emotional violence by partner in the last 12 months, frequency"

		
********************************************************************************	
**Violence by ANY partner in the 12 months before the survey
********************************************************************************
	
	//EXPERIENCED PHYSICAL VIOLENCE BY ANY PARTNER IN THE 12 MONTHS BEFORE SURVEY
		//ever
		gen dv_aprtnr_phy = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy = 1 if (dv_prtnr_phy==1 | (d130a>0 & d130a<=3))
		label val dv_aprtnr_phy yesno
		label var dv_aprtnr_phy "Experienced physical violence by any partner"

		//in the last 12 months
		gen dv_aprtnr_phy_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_12m = 1 if (dv_prtnr_phy_12m==1 | d130a==1)
		label val dv_aprtnr_phy_12m yesno
		label var dv_aprtnr_phy_12m "Experienced physical violence in past 12 mos. by any partner"

	//EXPERIENCED SEXUAL VIOLENCE BY ANY PARTNER IN THE 12 MONTHS BEFORE SURVEY
		//ever
		gen dv_aprtnr_sex = 0 if v044==1 & v502>0
		replace dv_aprtnr_sex = 1 if (dv_prtnr_sex==1 | (d130b>0 & d130b<=3))
		label val dv_aprtnr_sex yesno
		label var dv_aprtnr_sex "Experienced sexual violence by any partner"
		
		//in the last 12 months
		gen dv_aprtnr_sex_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_sex_12m = 1 if (dv_prtnr_sex_12m==1 | d130b==1)
		label val dv_aprtnr_sex_12m yesno
		label var dv_aprtnr_sex_12m "Experienced sexual violence in past 12 mos. by any partner"

	
	
	//EXPERIENCED EMOTIONAL VIOLENCE BY ANY PARTNER IN THE 12 MONTHS BEFORE SURVEY
		//ever
		gen dv_aprtnr_emot = 0 if v044==1 & v502>0
		replace dv_aprtnr_emot = 1 if (dv_prtnr_emot==1 | (d130c>0 & d130c<=3))
		label val dv_aprtnr_emot yesno
		label var dv_aprtnr_emot "Experienced emotional violence by any partner"
		
		//in the last 12 months
		gen dv_aprtnr_emot_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_emot_12m = 1 if (dv_prtnr_emot_12m==1 | d130c==1)
		label val dv_aprtnr_emot_12m yesno
		label var dv_aprtnr_emot_12m "Experienced emotional violence in past 12 mos. by any partner"


		
	//EXPERIENCED PHYSICAL AND SEXUAL VIOLENCE BY ANY PARTNER
		//ever
		gen dv_aprtnr_phy_sex = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex = 1 if (dv_aprtnr_phy==1 & dv_aprtnr_sex==1 )
		label val dv_aprtnr_phy_sex yesno
		label var dv_aprtnr_phy_sex "Experienced physical AND sexual violence by any partner"
		
		//in the last 12 months
		gen dv_aprtnr_phy_sex_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_12m = 1 if (dv_aprtnr_phy_12m==1 & dv_aprtnr_sex_12m==1)
		label val dv_aprtnr_phy_sex_12m yesno
		label var dv_aprtnr_phy_sex_12m "Experienced physical AND sexual violence in past 12 mos. by any partner"

		
		
	//EXPERIENCED PHYSICAL AND SEXUAL VIOLENCE AND EMOTIONAL BY ANY PARTNER
		//ever
		gen dv_aprtnr_phy_sex_emot = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_emot = 1 if (dv_aprtnr_phy==1 & dv_aprtnr_sex==1 & dv_aprtnr_emot==1)
		label val dv_aprtnr_phy_sex_emot yesno
		label var dv_aprtnr_phy_sex_emot "Experienced physical AND sexual AND emotional violence by any partner"
		
		//in the last 12 months
		gen dv_aprtnr_phy_sex_emot_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_emot_12m = 1 if (dv_aprtnr_phy_12m==1 & dv_aprtnr_sex_12m==1 & dv_aprtnr_emot_12m==1)
		label val dv_aprtnr_phy_sex_emot_12m yesno
		label var dv_aprtnr_phy_sex_emot_12m "Experienced physical AND sexual AND emotional violence in past 12 mos. by any partner"

	
	
	//EXPERIENCED PHYSICAL OR SEXUAL VIOLENCE BY ANY PARTNER
		//ever
		gen dv_aprtnr_phy_sex_any = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_any = 1 if (dv_aprtnr_phy==1 | dv_aprtnr_sex==1)
		label val dv_aprtnr_phy_sex_any yesno
		label var dv_aprtnr_phy_sex_any "Experienced physical OR sexual violence by any partner"
		
		//in the last 12 months
		gen dv_aprtnr_phy_sex_any_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_any_12m = 1 if (dv_aprtnr_phy_12m==1 | dv_aprtnr_sex_12m==1)
		label val dv_aprtnr_phy_sex_any_12m yesno
		label var dv_aprtnr_phy_sex_any_12m "Experienced physical OR sexual violence in past 12 mos. by any partner"

		
		
	//EXPERIENCED PHYSICAL OR SEXUAL VIOLENCE OR EMOTIONAL BY ANY PARTNER IN THE 12 MONTHS BEFORE SURVEY
		//ever
		gen dv_aprtnr_phy_sex_emot_any = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_emot_any = 1 if (dv_aprtnr_phy==1 | dv_aprtnr_sex==1 | dv_aprtnr_emot==1)
		label val dv_aprtnr_phy_sex_emot_any yesno
		label var dv_aprtnr_phy_sex_emot_any "Experienced physical OR sexual OR emotional violence by any partner"
	
		//in the last 12 months
		gen dv_aprtnr_phy_sex_emot_any_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_emot_any_12m = 1 if (dv_aprtnr_phy_12m==1 | dv_aprtnr_sex_12m==1 | dv_aprtnr_emot_12m==1)
		label val dv_aprtnr_phy_sex_emot_any_12m yesno
		label var dv_aprtnr_phy_sex_emot_any_12m "Experienced physical OR sexual OR emotional violence in past 12 mos. by any partner"

	

	
********************************************************************************
**Experience of violence by marital duration
********************************************************************************
	//TIMING OF FIRST VIOLENT EVENT IN MARRIAGE (among married women who only married once)
		//before marraige
		gen dv_mar_viol_0= 0 if v502==1 & v503==1 & v044==1
		replace dv_mar_viol_0 = 1 if d109==95 & v502==1 & v503==1
		label define dv_mar_viol_0 0 "other" 1 "before marriage"
		label val dv_mar_viol_0 dv_mar_viol_0
		label var dv_mar_viol_0 "Experience of violence by exact marriage duration: before marriage"

		//by 2 years of marriage
		gen dv_mar_viol_2= 0 if v502==1 & v503==1 & v044==1
		replace dv_mar_viol_2 = 1 if (d109<2 | d109==95) & v502==1 & v503==1
		label define dv_mar_viol_2 0 "other" 1 "by 2 years of marriage"
		label val dv_mar_viol_2 dv_mar_viol_2
		label var dv_mar_viol_2 "Experience of violence by exact marriage duration: 2 yrs of marriage"
		
		//by 5 years of marriage
		gen dv_mar_viol_5= 0 if v502==1 & v503==1 & v044==1
		replace dv_mar_viol_5 = 1 if (d109<5 | d109==95) & v502==1 & v503==1
		label define dv_mar_viol_5 0 "other" 1 "by 5 years of marriage"
		label val dv_mar_viol_5 dv_mar_viol_5
		label var dv_mar_viol_5 "Experience of violence by exact marriage duration: 5 yrs of marriage"

		//by 10 years of marriage
		gen dv_mar_viol_10= 0 if v502==1 & v503==1 & v044==1
		replace dv_mar_viol_10 = 1 if (d109<10 | d109==95) & v502==1 & v503==1
		label define dv_mar_viol_10 0 "other" 1 "by 10 years of marriage"
		label val dv_mar_viol_10 dv_mar_viol_10
		label var dv_mar_viol_10 "Experience of violence by exact marriage duration: 10 yrs of marriage"

		
		
		

********************************************************************************
**Injuries due to spousal violence
********************************************************************************
	
	//cuts, bruises aches
	gen dv_prtnr_cuts = 0 if v044==1 & v502>0 & dv_prtnr_phy_sex_any
	replace dv_prtnr_cuts = 1 if d110a==1
	label val dv_prtnr_cuts yesno
	label var dv_prtnr_cuts		"Have cuts, bruises, or aches as a result of the violence by partner"

	//eye injuries, sprains, dislocations, burns
	gen dv_prtnr_injury = 0 if v044==1 & v502>0 & dv_prtnr_phy_sex_any
	replace dv_prtnr_injury = 1 if d110b==1
	label val dv_prtnr_injury yesno
	label var dv_prtnr_injury		"Have eye injuries, sprains, dislocations, or burns from violence by partner"

	//deep wounds, broken bones
	gen dv_prtnr_broken = 0 if v044==1 & v502>0 & dv_prtnr_phy_sex_any
	replace dv_prtnr_broken = 1 if d110d==1
	label val dv_prtnr_broken yesno
	label var dv_prtnr_broken		"Deep wounds, broken bones/teeth, other serious injury from violence by partner"

	//any injury as result of partner violence
	gen dv_prtnr_injury_any = 0 if v044==1 & v502>0 & dv_prtnr_phy_sex_any
	replace dv_prtnr_injury_any = 1 if d110a==1 | d110b==1 | d110d==1
	label val dv_prtnr_injury_any yesno
	label var dv_prtnr_injury_any	"Have any injury from violence by partner"
		

		
		
		
********************************************************************************
**Initiation of spousal violence by women
********************************************************************************

	//committed violence against partner 
	gen dv_abusedhus_phy = 0 if v044==1 & v502>0 
	replace dv_abusedhus_phy = 1 if d112==1 | d112==2
	label val dv_abusedhus_phy yesno
	label var dv_abusedhus_phy	  "Ever committed violence against partner when he was not already beating her"

	//committed violence against partner in last 12 months
	gen dv_abusedhus_phy_12m = 0 if v044==1 & v502>0
	replace dv_abusedhus_phy_12m = 1 if d112a==1 | d112a==2
	label val dv_abusedhus_phy_12m yesno
	label var dv_abusedhus_phy_12m "Committed violence against partner in past 12 mos. when he was not already beating her"

