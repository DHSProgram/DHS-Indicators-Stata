/*****************************************************************************************************
Program: 			FP_KNOW.do
Purpose: 			Code contraceptive knowledge indicators
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Jan 31 2019 by Shireen Assaf 
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
Variables created in this file:
fp_know_any			"Know any contraceptive method"
fp_know_mod			"Know any modern method"
fp_know_fster		"Know female sterilization"
fp_know_mster		"Know male sterilization"
fp_know_pill		"Know pill"
fp_know_iud			"Know IUD"
fp_know_inj			"Know injectables"
fp_know_imp			"Know implants"
fp_know_mcond		"Know male condoms"
fp_know_fcond		"Know female condom"
fp_know_ec			"Know emergency contraception"
fp_know_sdm			"Know standard days method"
fp_know_lam			"Know LAM"
fp_know_omod		"Know other modern method"
fp_know_trad		"Know any traditional method"
fp_know_rhy			"Know rhythm method"
fp_know_wthd		"Know withdrawal method"
fp_know_other		"Know other method"
fp_know_mean_all	"Mean number of methods known - all"
fp_know_mean_mar	"Mean number of methods known - among currently married"
fp_know_fert_all	"Knowledge of fertile period among all women"
fp_know_fert_rhy	"Knowledge of fertile period among rhythm method users"
fp_know_fert_sdm	"Knowledge of fertile period among standard days method users"
fp_know_fert_cor	"Correct knowledge of fertile period"
/----------------------------------------------------------------------------*/

*** Knowldge of family planning methods ***

* indicators from IR file
if file=="IR" {

*To correct for the situation where variables that should be named as v304_0`i' but where named v304_`i', where i is from 1 to 9.  
forvalues i=1/9{
cap gen v304_0`i' = v304_`i'
}

//Any method 
gen fp_know_any = (v301>0 & v301<8)
label var fp_know_any "Know any contraceptive method"

//Modern method
gen fp_know_mod = v301==3
label var fp_know_mod "Know any modern method"

//Female sterilization  
gen fp_know_fster = (v304_06>0 & v304_06<8)
label var fp_know_fster "Know female sterilization"

//Male sterilization  
gen fp_know_mster = (v304_07>0 & v304_07<8)
label var fp_know_mster "Know male sterilization"

//The contraceptive pill 
gen fp_know_pill = (v304_01>0 & v304_01<8)
label var fp_know_pill "Know pill"

//Interuterine contraceptive device 
gen fp_know_iud = (v304_02>0 & v304_02<8)
label var fp_know_iud "Know IUD"

//Injectables (Depo-Provera) 
gen fp_know_inj = (v304_03>0 & v304_03<8)
label var fp_know_inj "Know injectables"

//Implants (Norplant) 
gen fp_know_imp = (v304_11>0 & v304_11<8)
label var fp_know_imp "Know implants"

//Male condom 
gen fp_know_mcond = (v304_05>0 & v304_05<8)
label var fp_know_mcond "Know male condoms"

//Female condom 
gen fp_know_fcond = (v304_14>0 & v304_14<8)
label var fp_know_fcond "Know female condom"

//Emergency contraception 
gen fp_know_ec = (v304_16>0 & v304_16<8)
label var fp_know_ec "Know emergency contraception"

//Standard days method (SDM) 
gen fp_know_sdm = (v304_18>0 & v304_18<8)
label var fp_know_sdm "Know standard days method"

//Lactational amenorrhea method (LAM) 
gen fp_know_lam = (v304_13>0 & v304_13<8)
label var fp_know_lam "Know LAM"

//Country-specific modern methods and other modern contraceptive methods 
gen fp_know_omod = (v304_17>0 & v304_17<8)
label var fp_know_omod "Know other modern method"

//Periodic abstinence (rhythm, calendar method) 
gen fp_know_rhy = (v304_08>0 & v304_08<8)
label var fp_know_rhy "Know rhythm method"

//Withdrawal (coitus interruptus) 
gen fp_know_wthd = (v304_09>0 & v304_09<8)
label var fp_know_wthd "Know withdrawal method"

//Country-specific traditional methods, and folk methods 
gen fp_know_other = (v304_10>0 & v304_10<8)
label var fp_know_other "Know other method"

//Any traditional
gen fp_know_trad=0
replace fp_know_trad=1 if fp_know_rhy | fp_know_wthd==1 | fp_know_other==1
label var fp_know_trad "Know any traditional method"

//Mean methods known
gen fp_know_sum	=	fp_know_fster + fp_know_mster + fp_know_pill + fp_know_iud + fp_know_inj + fp_know_imp + ///
					fp_know_mcond + fp_know_fcond + fp_know_ec + fp_know_sdm + fp_know_lam + ///
					fp_know_rhy + fp_know_wthd + fp_know_omod + fp_know_other
				
sum fp_know_sum [iw=v005/1000000]
gen fp_know_mean_all=r(mean)

label var fp_know_mean_all "Mean number of methods known - all"

sum fp_know_sum if v502==1 [iw=v005/1000000]
gen fp_know_mean_mar=r(mean)

label var fp_know_mean_mar "Mean number of methods known - among currently married"


*** Knowledge of fertile period ***
recode v217 (4=1 "Just before her menstrual period begins") (1=2 "During her menstrual period") (2=3 "Right after her menstrual period has ended") ///
			(3=4 "Halfway between two menstrual periods"  ) (6=5 "Other") (5=6 "No specific time") (8=8 "Don't know") (9=9 "Missing"), gen(fp_know_fert_all)
label var fp_know_fert_all "Knowledge of fertile period among all users"

recode v217 (4=1 "Just before her menstrual period begins") (1=2 "During her menstrual period") (2=3 "Right after her menstrual period has ended") ///
			(3=4 "Halfway between two menstrual periods"  ) (6=5 "Other") (5=6 "No specific time") (8=8 "Don't know") (9=9 "Missing") if v312==8, gen(fp_know_fert_rhy)
label var fp_know_fert_rhy "Knowledge of fertile period among rhythm method users"
			
recode v217 (4=1 "Just before her menstrual period begins") (1=2 "During her menstrual period") (2=3 "Right after her menstrual period has ended") ///
			(3=4 "Halfway between two menstrual periods"  ) (6=5 "Other") (5=6 "No specific time") (8=8 "Don't know") (9=9 "Missing") if v312==18, gen(fp_know_fert_sdm)			
label var fp_know_fert_sdm "Knowledge of fertile period among standard days method users"
			
gen fp_know_fert_cor = v217==3
label var fp_know_fert_cor "Correct knowledge of fertile period"

}


* indicators from MR file

* only the knowledge of contraceptive methods
if file=="MR" {

*In the case some surveys have the variables mv304_01 as mv304_1 for instance
forvalues i=1/9{
cap gen mv304_0`i' = mv304_`i'
}

//Any method 
gen fp_know_any = (mv301>0 & mv301<8)
label var fp_know_any "Know any contraceptive method"

//Modern method
gen fp_know_mod = mv301==3
label var fp_know_mod "Know any modern method"

//Female sterilization  
gen fp_know_fster = (mv304_06>0 & mv304_06<8)
label var fp_know_fster "Know female sterilization"

//Male sterilization  
gen fp_know_mster = (mv304_07>0 & mv304_07<8)
label var fp_know_mster "Know male sterilization"

//The contraceptive pill 
gen fp_know_pill = (mv304_01>0 & mv304_01<8)
label var fp_know_pill "Know pill"

//Interuterine contraceptive device 
gen fp_know_iud = (mv304_02>0 & mv304_02<8)
label var fp_know_iud "Know IUD"

//Injectables (Depo-Provera) 
gen fp_know_inj = (mv304_03>0 & mv304_03<8)
label var fp_know_inj "Know injectables"

//Implants (Norplant) 
gen fp_know_imp = (mv304_11>0 & mv304_11<8)
label var fp_know_imp "Know implants"

//Male condom 
gen fp_know_mcond = (mv304_05>0 & mv304_05<8)
label var fp_know_mcond "Know male condoms"

//Female condom 
gen fp_know_fcond = (mv304_14>0 & mv304_14<8)
label var fp_know_fcond "Know female condom"

//Emergency contraception 
gen fp_know_ec = (mv304_16>0 & mv304_16<8)
label var fp_know_ec "Know emergency contraception"

//Standard days method (SDM) 
gen fp_know_sdm = (mv304_18>0 & mv304_18<8)
label var fp_know_sdm "Know standard days method"

//Lactational amenorrhea method (LAM) 
gen fp_know_lam = (mv304_13>0 & mv304_13<8)
label var fp_know_lam "Know LAM"

//Country-specific modern methods and other modern contraceptive methods 
gen fp_know_omod = (mv304_17>0 & mv304_17<8)
label var fp_know_omod "Know other modern method"

//Periodic abstinence (rhythm, calendar method) 
gen fp_know_rhy = (mv304_08>0 & mv304_08<8)
label var fp_know_rhy "Know rhythm method"

//Withdrawal (coitus interruptus) 
gen fp_know_wthd = (mv304_09>0 & mv304_09<8)
label var fp_know_wthd "Know withdrawal method"

//Country-specific traditional methods, and folk methods 
gen fp_know_other = (mv304_10>0 & mv304_10<8)
label var fp_know_other "Know other method"

//Any traditional
gen fp_know_trad=0
replace fp_know_trad=1 if fp_know_rhy | fp_know_wthd==1 | fp_know_other==1
label var fp_know_trad "Know any traditional method"

//Mean methods known
gen fp_know_sum=fp_know_fster+fp_know_mster+fp_know_pill+fp_know_iud+fp_know_inj+fp_know_imp + ///
				fp_know_mcond+fp_know_fcond+fp_know_ec+fp_know_sdm+fp_know_lam + ///
				fp_know_rhy+fp_know_wthd+fp_know_omod+fp_know_other
				
sum fp_know_sum [iw=mv005/1000000]
gen fp_know_mean_all=r(mean)

label var fp_know_mean_all "Mean number of methods known - all"

sum fp_know_sum if mv502==1 [iw=mv005/1000000]
gen fp_know_mean_mar=r(mean)

label var fp_know_mean_mar "Mean number of methods known - among currently married"

}
