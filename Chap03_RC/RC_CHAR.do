/*****************************************************************************************************
Program: 			RC_CHAR.do
Purpose: 			Code to compute respondent characteristics in men and women
Data inputs: 		IR or MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Oct 1, 2019 by Shireen Assaf 
Note:				The indicators below can be computed for men and women. 
					For women and men the indicator is computed for age 15-49 in line 55 and 262. This can be commented out if the indicators are required for all women/men.
					Please check the note on health insurance. This can be country specific and also reported for specific populations. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
rc_edu				"Highest level of schooling attended or completed"
rc_edu_median		"Median years of education"
rc_litr_cats		"Level of literacy"
rc_litr				"Literate - higher than secondary or can read part or whole sentence"
rc_media_newsp		"Reads a newspaper at least once a week"
rc_media_tv			"Watches television at least once a week"
rc_media_radio		"Listens to radio at least once a week"
rc_media_allthree	"Accesses to all three media at least once a week"
rc_media_none		"Accesses none of the three media at least once a week"
rc_intr_ever		"Ever used the internet"
rc_intr_use12mo		"Used the internet in the past 12 months"
rc_intr_usefreq		"Internet use frequency in the past month - among users in the past 12 months"
rc_empl				"Employment status"
rc_occup			"Occupation among those employed in the past 12 months"
rc_empl_type		"Type of employer among those employed in the past 12 months"
rc_empl_earn		"Type of earnings among those employed in the past 12 months"
rc_empl_cont		"Continuity of employment among those employed in the past 12 months"
rc_hins_ss			"Health insurance coverage - social security"
rc_hins_empl		"Health insurance coverage - other employer-based insurance"
rc_hins_comm		"Health insurance coverage - mutual health org. or community-based insurance"
rc_hins_priv		"Health insurance coverage - privately purchased commercial insurance"
rc_hins_other		"Health insurance coverage - other type of insurance"
rc_hins_any			"Have any health insurance"
rc_tobc_cig			"Smokes cigarettes"
rc_tobc_other		"Smokes other type of tobacco"
rc_tobc_smk_any		"Smokes any type of tobacco"
rc_smk_freq			"Smoking frequency"
rc_cig_day			"Average number of cigarettes smoked per day"
rc_tobc_snuffm		"Uses snuff smokeless tobacco by mouth"
rc_tobc_snuffn		"Uses snuff smokeless tobacco by nose"
rc_tobc_chew		"Chews tobacco"
rc_tobv_betel		"Uses betel quid with tobacco"
rc_tobc_osmkless	"Uses other type of smokeless tobacco"
rc_tobc_anysmkless	"Uses any type of smokeless tobacco"
rc_tobc_any			"Uses any type of tobacco - smoke or smokeless"
----------------------------------------------------------------------------*/

* indicators from IR file
if file=="IR" {
* limiting to women age 15-49
drop if v012>49

label define yesno 0"No" 1"Yes"

*** Education ***

//Highest level of education
gen rc_edu= v149
label values rc_edu V149
label var rc_edu "Highest level of schooling attended or completed"

//Median years of education
gen eduyr=v133 
replace eduyr=20 if v133>20 & v133<95
replace eduyr=. if v133>95 | v149>7 

summarize eduyr [fweight=v005], detail
* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 
	replace dummy=1 if eduyr<sp50 
	summarize dummy [fweight=v005]
	scalar sL=r(mean)
	drop dummy
	
	gen dummy=. 
	replace dummy=0 
	replace dummy=1 if eduyr <=sp50 
	summarize dummy [fweight=v005]
	scalar sU=r(mean)
	drop dummy

	gen rc_edu_median=round(sp50-1+(.5-sL)/(sU-sL),.01)
	label var rc_edu_median	"Median years of education"
	
//Literacy level
recode v155 (2=1 ) (1=2) (0=3) (3=4) (4=5), gen(rc_litr_cats)
replace rc_litr_cats=0 if v106==3
label define rc_litr_cats 0"Higher than secondary education" 1"Can read a whole sentence"2 "Can read part of a sentence" 3 "Cannot read at all" ///
4 "No card with required language" 5 "Blind/visually impaired"
label values rc_litr_cats rc_litr_cats
label var rc_litr_cats	"Level of literacy"

//Literate 
gen rc_litr=0
replace rc_litr=1 if v106==3 | v155==1 | v155==2	
label values rc_litr yesno
label var rc_litr "Literate - higher than secondary or can read part or whole sentence"

*** Media exposure ***

//Media exposure - newspaper
recode v157 (2/3=1 "Yes") (0/1=0 "No"), gen(rc_media_newsp)
label var rc_media_newsp "Reads a newspaper at least once a week"

//Media exposure - TV
recode v159 (2/3=1 "Yes") (0/1=0 "No"), gen(rc_media_tv)
label var rc_media_tv "Watches television at least once a week"

//Media exposure - Radio
recode v158 (2/3=1 "Yes") (0/1=0 "No"), gen(rc_media_radio)
label var rc_media_radio "Listens to radio at least once a week"

//Media exposure - all three
gen rc_media_allthree=0
replace rc_media_allthree=1 if inlist(v157,2,3) & inlist(v158,2,3) & inlist(v159,2,3) 
label values rc_media_allthree yesno
label var rc_media_allthree "Accesses to all three media at least once a week"

//Media exposure - none
gen rc_media_none=0
replace rc_media_none=1 if (v157!=2 & v157!=3) & (v158!=2 & v158!=3) & (v159!=2 & v159!=3) 
label values rc_media_none yesno
label var rc_media_none "Accesses none of the three media at least once a week"

//Ever used internet
recode v171a (0=0 "No") (1/3=1 "Yes"), gen(rc_intr_ever) 
label var rc_intr_ever "Ever used the internet"

//Used interent in the past 12 months
recode v171a (0 2/3=0 "No") (1=1 "Yes"), gen(rc_intr_use12mo) 
label var rc_intr_use12mo "Used the internet in the past 12 months"

//Internet use frequency
gen rc_intr_usefreq= v171b if v171a==1
label values rc_intr_usefreq V171B
label var rc_intr_usefreq "Internet use frequency in the past month - among users in the past 12 months"

*** Employment ***
//Employment status
recode v731 (0=0 "Not employed in last 12 months") (1=1 "Not curcently working but was employed in last 12 months") (2/3=2 "Curcently employed") (8=9 "Don't know/missing"), gen(rc_empl)
label var rc_empl "Employment status"

//Occupation
recode v717 (1=1 "Professional") (2=2 "Clerical") (3 7=3 "Sales and services") (8=4 "Skilled manual") (9=5 "Unskilled manual") (6=6 "Domestic service") (4/5=7 "Agriculture") (96/99 .=9 "Don't know/missing") if inlist(v731,1,2,3), gen(rc_occup)
label var rc_occup "Occupation among those employed in the past 12 months"

//Type of employer
gen rc_empl_type=v719 if inlist(v731,1,2,3)
label values rc_empl_type V719
label var rc_empl_type "Type of employer among those employed in the past 12 months"

//Type of earnings
gen rc_empl_earn=v741 if inlist(v731,1,2,3)
label values rc_empl_earn V741
label var rc_empl_earn "Type of earnings among those employed in the past 12 months"

//Continuity of employment
gen rc_empl_cont=v732 if inlist(v731,1,2,3)
label values rc_empl_cont V732
label var rc_empl_cont "Continuity of employment among those employed in the past 12 months"

*** Health insurance ***
* Note: The different types of health insurance can be country specific. Please check the v481* variables to see which ones you need.
* In addition, some surveys report this for all women/men and some report it among those that have heard of insurance. Please check what the population of interest is for reporting these indicators.
//Health insurance - Social security
gen rc_hins_ss = v481c==1
label var rc_hins_ss "Health insurance coverage - social security"

//Health insurance - Other employer-based insurance
gen rc_hins_empl = v481b==1
label var rc_hins_empl "Health insurance coverage - other employer-based insurance"

//Health insurance - Mutual Health Organization or community-based insurance
gen rc_hins_comm = v481a==1
label var rc_hins_comm "Health insurance coverage - mutual health org. or community-based insurance"

//Health insurance - Privately purchased commercial insurance
gen rc_hins_priv = v481d==1
label var rc_hins_priv "Health insurance coverage - privately purchased commercial insurance"

//Health insrance - Other
gen rc_hins_other=0
	foreach i in e f g h x {
	replace rc_hins_other=1 if v481`i'==1
	} 
label var rc_hins_other "Health insurance coverage - other type of insurance"

//Health insurance - Any
gen rc_hins_any=0
	foreach i in a b c d e f g h x {
	replace rc_hins_any=1 if v481`i'==1
	}
label var rc_hins_any "Have any health insurance"

*** Tobacco use ***

//Smokes cigarettes
gen rc_tobc_cig=inlist(v463aa,1,2) | v463e==1
label var rc_tobc_cig "Smokes cigarettes"

//Smokes other type of tobacco
gen rc_tobc_other= v463b==1 | v463f==1 | v463g==1 
label var rc_tobc_other "Smokes other type of tobacco"

//Smokes any type of tobacco
gen rc_tobc_smk_any= inlist(v463aa,1,2) | v463e==1 | v463b==1 | v463f==1 | v463g==1 
label var rc_tobc_smk_any "Smokes any type of tobacco"

//Snuff by mouth
gen rc_tobc_snuffm = v463h==1
label values rc_tobc_snuffm yesno
label var rc_tobc_snuffm "Uses snuff smokeless tobacco by mouth"

//Snuff by nose
gen rc_tobc_snuffn = v463d==1
label values rc_tobc_snuffn yesno
label var rc_tobc_snuffn "Uses snuff smokeless tobacco by nose"

//Chewing tobacco
gen rc_tobc_chew = v463c==1
label values rc_tobc_chew yesno
label var rc_tobc_chew "Chews tobacco"

//Betel quid with tobacco
gen rc_tobv_betel = v463i==1
label values rc_tobv_betel yesno
label var rc_tobv_betel "Uses betel quid with tobacco"

//Other type of smokeless tobacco
*Note: there may be other types of smokeless tobacco, please check all v463* variables. 
gen rc_tobc_osmkless = v463l==1
label values rc_tobc_osmkless yesno
label var rc_tobc_osmkless "Uses other type of smokeless tobacco"

//Any smokeless tobacco
gen rc_tobc_anysmkless=0
	foreach i in h d c l {
	replace rc_tobc_anysmkless=1 if v463`i'==1
	}
replace rc_tobc_anysmkless=1 if rc_tobc_osmkless==1
label values rc_tobc_anysmkless yesno
label var rc_tobc_anysmkless "Uses any type of smokeless tobacco"

//Any tobacco 
gen rc_tobc_any= inlist(v463aa,1,2) | inlist(v463ab,1,2)
label values rc_tobc_any yesno
label var rc_tobc_any "Uses any type of tobacco - smoke or smokeless"
}


* indicators from MR file
if file=="MR" {
* limiting to men age 15-49
drop if mv012>49

label define yesno 0"No" 1"Yes"

*** Education ***

//Highest level of education
gen rc_edu= mv149
label values rc_edu MV149
label var rc_edu "Highest level of schooling attended or completed"

//Median years of education
gen eduyr=mv133 
replace eduyr=20 if mv133>20 & mv133<95
replace eduyr=. if mv133>95 | mv149>7 

summarize eduyr [fweight=mv005], detail
* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 
	replace dummy=1 if eduyr<sp50 
	summarize dummy [fweight=mv005]
	scalar sL=r(mean)
	drop dummy
	
	gen dummy=. 
	replace dummy=0 
	replace dummy=1 if eduyr <=sp50 
	summarize dummy [fweight=mv005]
	scalar sU=r(mean)
	drop dummy

	gen rc_edu_median=round(sp50-1+(.5-sL)/(sU-sL),.01)
	label var rc_edu_median	"Median years of education"
	
//Literacy level
recode mv155 (2=1 ) (1=2) (0=3) (3=4) (4=5), gen(rc_litr_cats)
replace rc_litr_cats=0 if mv106==3
label define rc_litr_cats 0"Higher than secondary education" 1"Can read a whole sentence"2 "Can read part of a sentence" 3 "Cannot read at all" ///
4 "No card with required language" 5 "Blind/visually impaired"
label values rc_litr_cats rc_litr_cats
label var rc_litr_cats	"Level of literacy"

//Literate 
gen rc_litr=0
replace rc_litr=1 if mv106==3 | mv155==1 | mv155==2	
label values rc_litr yesno
label var rc_litr "Literate - higher than secondary or can read part or whole sentence"

*** Media exposure ***

//Media exposure - newspaper
recode mv157 (2/3=1 "Yes") (0/1=0 "No"), gen(rc_media_newsp)
label var rc_media_newsp "Reads a newspaper at least once a week"

//Media exposure - TV
recode mv159 (2/3=1 "Yes") (0/1=0 "No"), gen(rc_media_tv)
label var rc_media_tv "Watches television at least once a week"

//Media exposure - Radio
recode mv158 (2/3=1 "Yes") (0/1=0 "No"), gen(rc_media_radio)
label var rc_media_radio "Listens to radio at least once a week"

//Media exposure - all three
gen rc_media_allthree=0
replace rc_media_allthree=1 if inlist(mv157,2,3) & inlist(mv158,2,3) & inlist(mv159,2,3) 
label values rc_media_allthree yesno
label var rc_media_allthree "Accesses to all three media at least once a week"

//Media exposure - none
gen rc_media_none=0
replace rc_media_none=1 if (mv157!=2 & mv157!=3) & (mv158!=2 & mv158!=3) & (mv159!=2 & mv159!=3) 
label values rc_media_none yesno
label var rc_media_none "Accesses none of the three media at least once a week"

//Ever used internet
recode mv171a (0=0 "No") (1/3=1 "Yes"), gen(rc_intr_ever) 
label var rc_intr_ever "Ever used the internet"

//Used interent in the past 12 months
recode mv171a (0 2/3=0 "No") (1=1 "Yes"), gen(rc_intr_use12mo) 
label var rc_intr_use12mo "Used the internet in the past 12 months"

//Internet use frequency
gen rc_intr_usefreq= mv171b if mv171a==1
label values rc_intr_usefreq MV171B
label var rc_intr_usefreq "Internet use frequency in the past month - among users in the past 12 months"

*** Employment ***

//Employment status
recode mv731 (0=0 "Not employed in last 12 months") (1=1 "Not currently working but was employed in last 12 months") (2/3=2 "Currently employed") (8=9 "Don't know/missing"), gen(rc_empl)
label var rc_empl "Employment status"

//Occupation
recode mv717 (1=1 "Professional") (2=2 "Clerical") (3 7=3 "Sales and services") (8=4 "Skilled manual") (9=5 "Unskilled manual") (6=6 "Domestic service") (4/5=7 "Agriculture") (96/99 .=9 "Don't know/missing") if inlist(mv731,1,2,3), gen(rc_occup)
label var rc_occup "Occupation among those employed in the past 12 months"

* Some survyes do not ask the following employment questions so a capture was added to skip these variables if they are not present. 
//Type of employer
cap gen rc_empl_type=mv719 if inlist(mv731,1,2,3)
cap label values rc_empl_type MV719
cap label var rc_empl_type "Type of employer among those employed in the past 12 months"

//Type of earnings
cap gen rc_empl_earn=mv741 if inlist(mv731,1,2,3)
cap label values rc_empl_earn MV741
cap label var rc_empl_earn "Type of earnings among those employed in the past 12 months"

//Continuity of employment
cap gen rc_empl_cont=mv732 if inlist(mv731,1,2,3)
cap label values rc_empl_cont MV732
cap label var rc_empl_cont "Continuity of employment among those employed in the past 12 months"

*** Health insurance ***
* Note: The different types of health insurance can be country specific. Please check the v481* variables to see which ones you need.
* In addition, some surveys report this for all women/men and some report it among those that have heard of insurance. Please check what the population of interest is for reporting these indicators.

//Health insurance - Social security
gen rc_hins_ss = mv481c==1
label var rc_hins_ss "Health insurance coverage - social security"

//Health insurance - Other employer-based insurance
gen rc_hins_empl = mv481b==1
label var rc_hins_empl "Health insurance coverage - other employer-based insurance"

//Health insurance - Mutual Health Organization or community-based insurance
gen rc_hins_comm = mv481a==1
label var rc_hins_comm "Health insurance coverage - mutual health org. or community-based insurance"

//Health insurance - Privately purchased commercial insurance
gen rc_hins_priv = mv481d==1
label var rc_hins_priv "Health insurance coverage - privately purchased commercial insurance"

//Health insrance - Other
gen rc_hins_other=0
	foreach i in e f g h x {
	replace rc_hins_other=1 if mv481`i'==1
	} 
label var rc_hins_other "Health insurance coverage - other type of insurance"

//Health insurance - Any
gen rc_hins_any=0
	foreach i in a b c d e f g h x {
	replace rc_hins_any=1 if mv481`i'==1
	}
label var rc_hins_any "Have any health insurance"

*** Tobacco Use ***

//Smokes cigarettes
gen rc_tobc_cig=0
	foreach i in a b c {
	replace rc_tobc_cig= 1 if mv464`i'>0 & mv464`i'<=888
	replace rc_tobc_cig= 1 if mv484`i'>0 & mv484`i'<=888
	}
label var rc_tobc_cig "Smokes cigarettes"

//Smokes other type of tobacco
gen rc_tobc_other= 0
	foreach i in d e f g {
	replace rc_tobc_other= 1 if mv464`i'>0 & mv464`i'<=888
	replace rc_tobc_other= 1 if mv484`i'>0 & mv464`i'<=888
	}
label var rc_tobc_other "Smokes other type of tobacco"

//Smokes any type of tobacco
gen rc_tobc_smk_any= 0
	foreach i in a b c d e f g {
	replace rc_tobc_smk_any= 1 if mv464`i'>0 & mv464`i'<=888
	replace rc_tobc_smk_any= 1 if mv484`i'>0 & mv464`i'<=888
	}
label var rc_tobc_smk_any "Smokes any type of tobacoo"

//Smoking frequency
gen rc_smk_freq=mv463aa
label define rc_smk_freq 0"Non-smoker" 1"Daily smoker" 2"Occasional smoker"
label values rc_smk_freq rc_smk_freq
label var rc_smk_freq "Smoking frequency"

//Average numberof cigarettes per day
	foreach i in a b c {
	gen cig`i'=mv464`i'
	replace cig`i'=0 if cig`i'==888
	qui sum cig`i'
		if r(N)==0 {
		replace cig`i'=0
		}
	}	
gen cigdaily= ciga + cigb + cigc 
recode cigdaily (1/4=1 " <5") (5/9=2 " 5-9") (10/14=3 " 10-14") (15/24=4 " 15-24") (25/95=5 " 25+") (else=9 "Don't know/missing") if rc_smk_freq==1 & cigdaily>0, gen(rc_cig_day)
label var rc_cig_day "Average number of cigarettes smoked per day"

//Snuff by mouth
gen rc_tobc_snuffm = inlist(mv464h,1,888) | inlist(mv484h,1,888)
label values rc_tobc_snuffm yesno
label var rc_tobc_snuffm "Uses snuff smokeless tobacco by mouth"

//Snuff by nose
gen rc_tobc_snuffn = inlist(mv464i,1,888) | inlist(mv484i,1,888)
label values rc_tobc_snuffn yesno
label var rc_tobc_snuffn "Uses snuff smokeless tobacco by nose"

//Chewing tobacco
gen rc_tobc_chew = inlist(mv464j,1,888) | inlist(mv484j,1,888)
label values rc_tobc_chew yesno
label var rc_tobc_chew "Chews tobacco"

//Betel quid with tobacco
gen rc_tobv_betel = inlist(mv464k,1,888) | inlist(mv484k,1,888)
label values rc_tobv_betel yesno
label var rc_tobv_betel "Uses betel quid with tobacco"

//Other type of smokeless tobacco
*Note: there may be other types of smokeless tobacco, please check all mv464* and mv484* variables. 
gen rc_tobc_osmkless = inlist(mv464l,1,888) | inlist(mv484l,1,888)
label values rc_tobc_osmkless yesno
label var rc_tobc_osmkless "Uses other type of smokeless tobacco"

//Any smokeless tobacco
gen rc_tobc_anysmkless=0
	foreach i in h i j k l  {
	replace rc_tobc_anysmkless=1 if mv464`i'>0 & mv464`i'<=888
	replace rc_tobc_anysmkless=1 if mv484`i'>0 & mv484`i'<=888
	}
replace rc_tobc_anysmkless=1 if rc_tobc_osmkless==1
label values rc_tobc_anysmkless yesno
label var rc_tobc_anysmkless "Uses any type of smokeless tobacco"

//Any tobacco 
gen rc_tobc_any= inlist(mv463aa,1,2) | inlist(mv463ab,1,2)
label values rc_tobc_any yesno
label var rc_tobc_any "Uses any type of tobacco - smoke or smokeless"
}
