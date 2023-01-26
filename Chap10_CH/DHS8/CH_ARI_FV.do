/*****************************************************************************************************
Program: 			CH_ARI_FV.do - DHS8 update
Purpose: 			Code ARI and fever variables.
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Jan 24, 2023 by Shireen Assaf 

Notes:				!! Check notes for ARI/fever care and treatment variables which are country specific.
					
					NGO source of treatment was added as a treatment source
					New antibiotics for fever treatment included
					
					2 new indicators in DHS8, see below
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_ari				"ARI symptoms in the 2 weeks before the survey"
ch_ari_care			"Advice or treatment sought for ARI symptoms"
ch_ari_care_day		"Advice or treatment sought for ARI symptoms on the same or next day"

ch_ari_public		"ARI treatment sought from public sector among children with ARI"
ch_ari_public_trt	"ARI treatment sought from public sector among children with ARI that sought treatment"
ch_ari_govh			"ARI treatment sought from government hospital among children with ARI"
ch_ari_govh_trt		"ARI treatment sought from government hospital among children with ARI that sought treatment"
ch_ari_govcent 		"ARI treatment sought from government health center among children with ARI"
ch_ari_govcent_trt 	"ARI treatment sought from government health center among children with ARI that sought treatment"
ch_ari_private		"ARI treatment sought from private sector among children with ARI"
ch_ari_private_trt	"ARI treatment sought from private sector among children with ARI that sought treatment"
ch_ari_pclinc 		"ARI treatment sought from private hospital/clinic among children with ARI"
ch_ari_pclinc_trt 	"ARI treatment sought from private hospital/clinic  among children with ARI that sought treatment"
ch_ari_pdoc			"ARI treatment sought from private doctor among children with ARI"
ch_ari_pdoc_trt		"ARI treatment sought from private doctor among children with ARI that sought treatment"
ch_ari_pharm		"ARI treatment sought from pharmacy among children with ARI"
ch_ari_pharm_trt	"ARI treatment sought from pharmacy among children with ARI that sought treatment"
ch_ari_ngo			"ARI treatment sought from NGO medical sector among children with ARI"  - NEW Indicator in DHS8
ch_ari_ngo_trt		"ARI treatment sought from NGO medical sector among children with ARI that sought treatment"  - NEW Indicator in DHS8	 

ch_fever			"Fever symptoms in the 2 weeks before the survey"
ch_fev_care			"Advice or treatment sought for fever symptoms"
ch_fev_care_day		"Advice or treatment sought for ARI symptoms on the same or next day"
ch_fev_antib		"Antibiotics taken for fever symptoms"
----------------------------------------------------------------------------*/

** ARI indicators ***

//ARI symptoms
* ari defintion differs by survey according to whether h31c is included or not
	scalar h31c_included=1
		capture confirm numeric variable h31c, exact 
		if _rc>0 {
		* h31c is not present
		scalar h31c_included=0
		}
		if _rc==0 {
		* h31c is present; check for values
		summarize h31c
		  if r(sd)==0 | r(sd)==. {
		  scalar h31c_included=0
		  }
		}

if h31c_included==1 {
	gen ch_ari=0
	cap replace ch_ari=1 if h31b==1 & (h31c==1 | h31c==3)
	replace ch_ari =. if b5==0
}

if h31c_included==0 {
	gen ch_ari=0
	cap replace ch_ari=1 if h31b==1 & (h31==2)
	replace ch_ari =. if b5==0
}
	
/* survey specific changes
if srvy=="IAKR23"|srvy=="PHKR31" {
	drop ch_ari
	gen ch_ari=0
	replace ch_ari=1 if h31b==1 & (h31==2|h31==1)
	replace ch_ari =. if b5==0
}
*/
	
label var ch_ari "ARI symptoms in the 2 weeks before the survey"
	
//ARI care-seeking
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** The code below only excludes h32t and h32v. 
*** Some surveys also exclude pharmacies, shop, or other sources.
gen ch_ari_care=0 if ch_ari==1
foreach c in a b c d e f g h i j k l m n o p q r na nb nc nd ne s u w x {
replace ch_ari_care=1 if ch_ari==1 & h32`c'==1
}
/* If you want to also remove pharmacy for example as a source of treatment (country specific condition) you can remove 
* the 'k in the list on line 79 or do the following.
replace ch_ari_care=0 if ch_ari==1 & h32k==1
replace ch_ari_care =. if b5==0
*/
label var ch_ari_care "Advice or treatment sought for ARI symptoms"

//ARI care-seeking same or next day
*for surveys that do not have the variable h46b
cap gen h46b=.

gen ch_ari_care_day=0 if ch_ari==1
replace ch_ari_care_day=1 if ch_ari==1 & h46b<2
replace ch_ari_care_day =. if b5==0

label var ch_ari_care_day "Advice or treatment sought for ARI symptoms on the same or next day"

	scalar h46b_included=1
		capture confirm numeric variable h46b, exact 
		if _rc>0 {
		* h46b is not present
		scalar h46b_included=0
		}
		if _rc==0 {
		* h46b is present; check for values
		summarize h46b
		  if r(sd)==0 | r(sd)==. {
		  scalar h46b_included=0
		  }
		}

if h46b_included==0{
replace ch_ari_care_day=.
}

*** ARI treatment by source *** 
* Two population bases: 1. among children with ARI symptoms, 2. among children with ARI symptoms that sought treatment
* This is country specific and needs to be checked to produce the specific source of interest. 
* Some sources are coded below and the same logic can be used to code other sources. h32a-z indicates the source.

//ARI treamtment in public sector
gen ch_ari_public=0 if ch_ari==1
replace ch_ari_public=1 if ch_ari==1 & (h32a==1 | h32b==1 | h32c==1 | h32d==1 | h32e==1 | h32f==1 | h32g==1 | h32h==1 | h32i==1 )
replace ch_ari_public =. if b5==0
label var ch_ari_public "ARI treatment sought from public sector among children with ARI"

gen ch_ari_public_trt=0 if ch_ari_care==1
replace ch_ari_public_trt=1 if ch_ari_care==1 & (h32a==1 | h32b==1 | h32c==1 | h32d==1 | h32e==1 | h32f==1 | h32g==1 | h32h==1 | h32i==1 )
replace ch_ari_public_trt =. if b5==0
label var ch_ari_public_trt "ARI treatment sought from public sector among children with ARI that sought treatment"

//ARI treamtment in government hospital
gen ch_ari_govh=0 if ch_ari==1
replace ch_ari_govh=1 if ch_ari==1 & h32a==1
replace ch_ari_govh =. if b5==0
label var ch_ari_govh "ARI treatment sought from government hospital among children with ARI"

gen ch_ari_govh_trt=0 if ch_ari_care==1
replace ch_ari_govh_trt=1 if ch_ari_care==1 & h32a==1
replace ch_ari_govh_trt =. if b5==0
label var ch_ari_govh_trt "ARI treatment sought from government hospital among children with ARI that sought treatment"

//ARI treamtment in government health center
gen ch_ari_govcent=0 if ch_ari==1
replace ch_ari_govcent=1 if ch_ari==1 & h32b==1
replace ch_ari_govcent =. if b5==0
label var ch_ari_govcent "ARI treatment sought from government health center among children with ARI"

gen ch_ari_govcent_trt=0 if ch_ari_care==1
replace ch_ari_govcent_trt=1 if ch_ari_care==1 & h32b==1
replace ch_ari_govcent_trt =. if b5==0
label var ch_ari_govcent_trt "ARI treatment sought from government health center among children with ARI that sought treatment"

//ARI treatment from a private sector
gen ch_ari_private=0 if ch_ari==1
replace ch_ari_private=1 if ch_ari==1 & (h32j==1 | h32k==1 | h32l==1 | h32m==1 | h32n==1 | h32o==1 | h32p==1 | h32q==1 | h32r==1 )
replace ch_ari_private =. if b5==0
label var ch_ari_private "ARI treatment sought from private sector among children with ARI"

gen ch_ari_private_trt=0 if ch_ari_care==1
replace ch_ari_private_trt=1 if ch_ari_care==1 & (h32j==1 | h32k==1 | h32l==1 | h32m==1 | h32n==1 | h32o==1 | h32p==1 | h32q==1 | h32r==1 )
replace ch_ari_private_trt =. if b5==0
label var ch_ari_private_trt "ARI treatment sought from private sector among children with ARI that sought treatment"

//ARI treatment from a private hospital/clinic
gen ch_ari_pclinc=0 if ch_ari==1
replace ch_ari_pclinc=1 if ch_ari==1 & h32j==1
replace ch_ari_pclinc =. if b5==0
label var ch_ari_pclinc "ARI treatment sought from private hospital/clinic among children with ARI"

gen ch_ari_pclinc_trt=0 if ch_ari_care==1
replace ch_ari_pclinc_trt=1 if ch_ari_care==1 & h32j==1
replace ch_ari_pclinc_trt =. if b5==0
label var ch_ari_pclinc_trt "ARI treatment sought from private hospital/clinic  among children with ARI that sought treatment"

//ARI treatment from a private doctor
gen ch_ari_pdoc=0 if ch_ari==1
replace ch_ari_pdoc=1 if ch_ari==1 & h32l==1
replace ch_ari_pdoc =. if b5==0
label var ch_ari_pdoc "ARI treatment sought from private doctor among children with ARI"

gen ch_ari_pdoc_trt=0 if ch_ari_care==1
replace ch_ari_pdoc_trt=1 if ch_ari_care==1 & h32l==1
replace ch_ari_pdoc_trt =. if b5==0
label var ch_ari_pdoc_trt "ARI treatment sought from private doctor among children with ARI that sought treatment"

//ARI treatment from a pharmacy
gen ch_ari_pharm=0 if ch_ari==1
replace ch_ari_pharm=1 if ch_ari==1 & h32k==1
replace ch_ari_pharm =. if b5==0
label var ch_ari_pharm "ARI treatment sought from a pharmacy among children with ARI"

gen ch_ari_pharm_trt=0 if ch_ari_care==1
replace ch_ari_pharm_trt=1 if ch_ari_care==1 & h32k==1
replace ch_ari_pharm_trt =. if b5==0
label var ch_ari_pharm_trt "ARI treatment sought from a pharmacy among children with ARI that sought treatment"

//ARI treatment from NGO medical sector  - NEW Indicator in DHS8
gen ch_ari_ngo=0 if ch_ari==1
replace ch_ari_ngo=1 if ch_ari==1 & (h32na==1 | h32nb==1 | h32nc==1 | h32nd==1 | h32ne==1)
replace ch_ari_ngo =. if b5==0
label var ch_ari_ngo "ARI treatment sought from NGO medical sector among children with ARI"

gen ch_ari_ngo_trt=0 if ch_ari_care==1
replace ch_ari_ngo_trt=1 if ch_ari_care==1 & (h32na==1 | h32nb==1 | h32nc==1 | h32nd==1 | h32ne==1)
replace ch_ari_ngo_trt =. if b5==0
label var ch_ari_ngo_trt "ARI treatment sought from NGO medical sector among children with ARI that sought treatment"


*** Fever indicators ***

//Fever 
gen ch_fever=0
cap replace ch_fever=1 if h22==1 
replace ch_fever =. if b5==0
label var ch_fever "Fever symptoms in the 2 weeks before the survey"
	
//Fever care-seeking
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** The code below only excludes excludes h32t and h32v. 
*** Some surveys may also exclude other sources.
gen ch_fev_care=0 if ch_fever==1
foreach c in a b c d e f g h i j l k m n o p q r na nb nc nd ne s u w x {
replace ch_fev_care=1 if ch_fever==1 & h32`c'==1
}
replace ch_fev_care =. if b5==0
label var ch_fev_care "Advice or treatment sought for fever symptoms"

//Fever care-seeking same or next day
gen ch_fev_care_day=0 if ch_fever==1
replace ch_fev_care_day=1 if ch_fever==1 & ch_fev_care==1 & h46b<2
replace ch_fev_care_day =. if b5==0
label var ch_fev_care_day "Advice or treatment sought for fever symptoms on the same or next day"

//Given antibiotics for fever 
gen ch_fev_antib=0 if ch_fever==1
cap replace ch_fev_antib=1 if ch_fever==1 & (h37i==1 | h37j==1 | h37n==1 | h37o==1)
cap replace ch_fev_antib=1 if ch_fever==1 & (ml13i==1 | ml13j ==1 |  ml13n = 1 | ml13o = 1)
replace ch_fev_antib =. if b5==0
label var ch_fev_antib "Antibiotics taken for fever symptoms"

