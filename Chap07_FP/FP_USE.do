/*****************************************************************************************************
Program: 			FP_USE.do
Purpose: 			Code contraceptive use indicators (ever and current use). Also source of method, brands, and information given. 
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Jan 31 2019 by Shireen Assaf 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
fp_evuse_any		"Ever used any contraceptive method"
fp_evuse_mod		"Ever used any modern method"
fp_evuse_fster		"Ever used female sterilization"
fp_evuse_mster		"Ever used male sterilization"
fp_evuse_pill		"Ever used pill"
fp_evuse_iud		"Ever used IUD"
fp_evuse_inj		"Ever used injectables"
fp_evuse_imp		"Ever used implants"
fp_evuse_mcond		"Ever used male condoms"
fp_evuse_fcond		"Ever used female condom"
fp_evuse_diaph		"Ever used diaphragm"
fp_evuse_lam		"Ever used LAM"
fp_evuse_ec			"Ever used emergency contraception"
fp_evuse_omod		"Ever used other modern method"
fp_evuse_trad		"Ever used any traditional method"
fp_evuse_rhy		"Ever used rhythm"
fp_evuse_wthd		"Ever used withdrawal"
fp_evuse_other		"Ever used other"

fp_cruse_any		"Currently use any contraceptive method"
fp_cruse_mod		"Currently use any modern method
fp_cruse_fster		"Currently use female sterilization"
fp_cruse_mster		"Currently use male sterilization"
fp_cruse_pill		"Currently use pill"
fp_cruse_iud		"Currently use IUD"
fp_cruse_inj		"Currently use injectables"
fp_cruse_imp		"Currently use implants"
fp_cruse_mcond		"Currently use male condoms"
fp_cruse_fcond		"Currently use female condom"
fp_cruse_diaph		"Currently use diaphragm"
fp_cruse_lam		"Currently use LAM"
fp_cruse_ec			"Currently use emergency contraception"
fp_cruse_omod		"Currently use other modern method"
fp_cruse_trad		"Currently use any traditional method"
fp_cruse_rhy		"Currently use rhythm"
fp_cruse_wthd		"Currently use withdrawal"
fp_cruse_other		"Currently use other"

fp_ster_age			"Age at time of sterilization for women"
fp_ster_median		"Median age at time of sterilization for women"

fp_source_tot		"Source of contraception - total"
fp_source_fster		"Source for female sterilization"
fp_source_pill		"Source for pill"
fp_source_iud		"Source for IUD"
fp_source_inj		"Source for injectables"
fp_source_imp		"Source for implants"
fp_source_mcond		"Source for male condom"

fp_brand_pill		"Pill users using a social marketing brand"
fp_brand_cond		"Male condom users using a social marketing brand"

fp_info_sideff		"Informed about side effects or problems among female sterilization, pill, IUD, injectables, and implant users"
fp_info_what_to_do	"Informed of what to do if experienced side effects among female sterilization, pill, IUD, injectables, and implant users"
fp_info_other_meth	"Informed of other methods by health or FP worker among female sterilization, pill, IUD, injectables, and implant users"
fp_info_all 		"Informed of all three (method information index) among female sterilization, pill, IUD, injectables, and implant users"

----------------------------------------------------------------------------*/

*** Ever use of contraceptive methods ***
* many surveys have these variables in the data files but have no observations, i.e. the data were not collected in the survey

*To correct for the situation where variables that should be named as v305_0`i' but where named v305_`i', where i is from 1 to 9.  
forvalues i=1/9{
cap gen v305_0`i' = v305_`i'
}

//Ever use any method
gen fp_evuse_any = (v302>0 & v302<8)
label var fp_evuse_any "Ever used any contraceptive method"

//Ever use modern method
gen fp_evuse_mod = v302==3
label var fp_evuse_mod "Ever used any modern method"

//Ever use female sterilization  
gen fp_evuse_fster = (v305_06>0 & v305_06<8)
label var fp_evuse_fster "Ever used female sterilization"

//Ever use male sterilization  
gen fp_evuse_mster = (v305_07>0 & v305_07<8)
label var fp_evuse_mster "Ever used male sterilization"

//Ever use the contraceptive pill 
gen fp_evuse_pill = (v305_01>0 & v305_01<8)
label var fp_evuse_pill "Ever used pill"

//Ever use Interuterine contraceptive device 
gen fp_evuse_iud = (v305_02>0 & v305_02<8)
label var fp_evuse_iud "Ever used IUD"

//Ever use injectables (Depo-Provera) 
gen fp_evuse_inj = (v305_03>0 & v305_03<8)
label var fp_evuse_inj "Ever used injectables"

//Ever use implants (Norplant) 
gen fp_evuse_imp = (v305_11>0 & v305_11<8)
label var fp_evuse_imp "Ever used implants"

//Ever use male condom 
gen fp_evuse_mcond = (v305_05>0 & v305_05<8)
label var fp_evuse_mcond "Ever used male condoms"

//Ever use female condom 
gen fp_evuse_fcond = (v305_14>0 & v305_14<8)
label var fp_evuse_fcond "Ever used female condom"

//Ever use diaphragm
gen fp_evuse_diaph = (v305_04>0 & v305_04<8)
label var fp_evuse_diaph "Ever used diaphragm"

//Ever use standard days method (SDM) 
gen fp_evuse_sdm = (v305_18>0 & v305_18<8)
label var fp_evuse_sdm "Ever used standard days method"

//Ever use Lactational amenorrhea method (LAM) 
gen fp_evuse_lam = (v305_13>0 & v305_13<8)
label var fp_evuse_lam "Ever used LAM"

//Ever use emergency contraception 
gen fp_evuse_ec = (v305_16>0 & v305_16<8)
label var fp_evuse_ec "Ever used emergency contraception"

//Ever use country-specific modern methods and other modern contraceptive methods 
gen fp_evuse_omod = (v305_17>0 & v305_17<8)
label var fp_evuse_omod "Ever used other modern method"

//Ever use periodic abstinence (rhythm, calendar method) 
gen fp_evuse_rhy = (v305_08>0 & v305_08<8)
label var fp_evuse_rhy "Ever used rhythm method"

//Ever use withdrawal (coitus interruptus) 
gen fp_evuse_wthd = (v305_09>0 & v305_09<8)
label var fp_evuse_wthd "Ever used withdrawal method"

//Ever use country-specific traditional methods, and folk methods 
gen fp_evuse_other = (v305_10>0 & v305_10<8)
label var fp_evuse_other "Ever used other method"

//Ever use any traditional 
gen fp_evuse_trad=0
replace fp_evuse_trad = 1 if fp_evuse_rhy==1 | fp_evuse_wthd==1 | fp_evuse_other==1
label var fp_evuse_trad "Ever used any traditional method"

********************************************************************************/

*** Current use of contraceptive methods ***

//Currently use any method
gen fp_cruse_any = (v313>0 & v313<8)
label var fp_cruse_any "Currently used any contraceptive method"

//Currently use modern method
gen fp_cruse_mod = v313==3
label var fp_cruse_mod "Currently used any modern method"

//Currently use female sterilization  
gen fp_cruse_fster = v312==6
label var fp_cruse_fster "Currently used female sterilization"

//Currently use male sterilization  
gen fp_cruse_mster = v312==7
label var fp_cruse_mster "Currently used male sterilization"

//Currently use the contraceptive pill 
gen fp_cruse_pill = v312==1
label var fp_cruse_pill "Currently used pill"

//Currently use Interuterine contraceptive device 
gen fp_cruse_iud = v312==2
label var fp_cruse_iud "Currently used IUD"

//Currently use injectables (Depo-Provera) 
gen fp_cruse_inj = v312==3
label var fp_cruse_inj "Currently used injectables"

//Currently use implants (Norplant) 
gen fp_cruse_imp = v312==11
label var fp_cruse_imp "Currently used implants"

//Currently use male condom 
gen fp_cruse_mcond = v312==5
label var fp_cruse_mcond "Currently used male condoms"

//Currently use female condom 
gen fp_cruse_fcond = v312==14
label var fp_cruse_fcond "Currently used female condom"

//Currently use diaphragm
gen fp_cruse_diaph = v312==4
label var fp_cruse_diaph "Currently used diaphragm"

//Currently use standard days method (SDM) 
gen fp_cruse_sdm = v312==18
label var fp_cruse_sdm "Currently used standard days method"

//Currently use Lactational amenorrhea method (LAM) 
gen fp_cruse_lam = v312==13
label var fp_cruse_lam "Currently used LAM"

//Currently use emergency contraception 
gen fp_cruse_ec = v312==16
label var fp_cruse_ec "Currently used emergency contraception"

//Currently use country-specific modern methods and other modern contraceptive methods 
gen fp_cruse_omod = v312==17
label var fp_cruse_omod "Currently used other modern method"

//Currently use periodic abstinence (rhythm, calendar method) 
gen fp_cruse_rhy = v312==8
label var fp_cruse_rhy "Currently used rhythm method"

//Currently use withdrawal (coitus interruptus) 
gen fp_cruse_wthd = v312==9
label var fp_cruse_wthd "Currently used withdrawal method"

//Currently use country-specific traditional methods, and folk methods 
gen fp_cruse_other = v312==10
replace fp_cruse_other=1 if v312==35 //folklore method
label var fp_cruse_other "Currently used other method"

//Currently use any traditional 
gen fp_cruse_trad = (v313>0 & v313<3)
label var fp_cruse_trad "Currently used any traditional method"

********************************************************************************/

//Age at female sterilization
gen fp_ster_age = v320
replace fp_ster_age=. if v312!=6
label values fp_ster_age V320
label var fp_ster_age "Age at time of sterilization for women"

//Median age at sterilization
gen ster_age = int((v317 - v011) / 12)
replace ster_age = . if v312!=6 
replace ster_age = . if v320>=5 

summarize ster_age [fweight=v005], detail
* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 if v312==6 & v320<5
	replace dummy=1 if ster_age<sp50 & v312==6 & v320<5
	summarize dummy [fweight=v005]
	scalar sL=r(mean)
	drop dummy
	
	gen dummy=. 
	replace dummy=0 if v312==6 & v320<5
	replace dummy=1 if ster_age <=sp50 & v312==6 & v320<5
	summarize dummy [fweight=v005]
	scalar sU=r(mean)
	drop dummy

	gen fp_ster_median=round(sp50+(.5-sL)/(sU-sL),.01)
	label var fp_ster_median "Median age at time of sterilization for women"
	
*** Source of Contraceptive method ***
** only for women that are using a moden method and do not use LAM

//Source for all 
gen fp_source_tot = v326
label values fp_source_tot V326
label var fp_source_tot "Source of contraception - total"

//Source for female sterilization users
gen fp_source_fster = v326
replace fp_source_fster = . if v312!=6
label values fp_source_fster V326
label var fp_source_fster "Source for female sterilization"

//Source for pill users
gen fp_source_pill = v326
replace fp_source_pill = . if v312!=1
label values fp_source_pill V326
label var fp_source_pill "Source for pill"

//Source for IUD users
gen fp_source_iud = v326
replace fp_source_iud = . if v312!=2
label values fp_source_iud V326
label var fp_source_iud "Source for IUD"

//Source for injectable users
gen fp_source_inj = v326
replace fp_source_inj = . if v312!=3
label values fp_source_inj V326
label var fp_source_inj "Source for injectables"

//Source for implant users
gen fp_source_imp = v326
replace fp_source_imp = . if v312!=11
label values fp_source_imp V326
label var fp_source_imp "Source for implants"

//Source for male condom users
gen fp_source_mcond = v326
replace fp_source_mcond = . if v312!=5
label values fp_source_mcond V326
label var fp_source_mcond "Source for male condom"
*******************************************************************************

*** Brands used for pill and condom ***

//Brand used for pill
gen fp_brand_pill = v323
replace fp_brand_pill = . if v312!=1
replace fp_brand_pill = . if v323>96
label values fp_brand_pill V323
label var fp_brand_pill "Pill users using a social marketing brand"

//Brand used for male condom
gen fp_brand_cond = v323a
replace fp_brand_cond = . if v312!=5
replace fp_brand_cond = . if v323a>96
label values fp_brand_cond V323A
label var fp_brand_cond "Male condom users using a social marketing brand"

*******************************************************************************

*** Infomation given ***

//Informed of side effects
gen fp_info_sideff = 0 if inlist(v312,1,2,3,6,11) & (v008-v317<60)
replace fp_info_sideff = 1 if (v3a02==1 | v3a03==1) & inlist(v312,1,2,3,6,11) & (v008-v317<60)
label var fp_info_sideff "Informed about side effects or problems among female sterilization, pill, IUD, injectables, and implant users"

//Informed of what to do
gen fp_info_what_to_do = 0 if inlist(v312,1,2,3,6,11) & (v008-v317<60)
replace fp_info_what_to_do = 1 if v3a04==1 & inlist(v312,1,2,3,6,11) & (v008-v317<60)
label var fp_info_what_to_do "Informed of what to do if experienced side effects among female sterilization, pill, IUD, injectables, and implant users"

//Informed of other methods to use
gen fp_info_other_meth = 0 if inlist(v312,1,2,3,6,11) & (v008-v317<60)
replace fp_info_other_meth = 1 if (v3a05==1 | v3a06==1) & inlist(v312,1,2,3,6,11) & (v008-v317<60)
label var fp_info_other_meth "Informed of other methods by health or FP worker among female sterilization, pill, IUD, injectables, and implant users"

//Informed of all three (method information index)
gen fp_info_all = 0 if inlist(v312,1,2,3,6,11) & (v008-v317<60)
replace fp_info_all = 1 if ((v3a02==1 | v3a03==1) & v3a04==1 & (v3a05==1 | v3a06==1)) & inlist(v312,1,2,3,6,11) & (v008-v317<60)
label var fp_info_all "Informed of all three (method information index) among female sterilization, pill, IUD, injectables, and implant users"
