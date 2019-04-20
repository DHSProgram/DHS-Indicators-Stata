/*****************************************************************************************************
Program: 			CH_ARI_FV.do
Purpose: 			Code ARI and fever variables.
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: March 13 2019 by Shireen Assaf 
Notes:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_ari				"ARI symptoms in the 2 weeks before the survey"
ch_ari_care			"Advice or treatment sought for ARI symptoms"
ch_ari_care_day		"Advice or treatment sought for ARI symptoms on the same or next day"

ch_ari_govh			"ARI treatment sought from government hospital among children with ARI"
ch_ari_govh_trt		"ARI treatment sought from government hospital among children with ARI that sought treatment"
ch_ari_pdoc			"ARI treatment sought from private doctor among children with ARI"
ch_ari_pdoc_trt		"ARI treatment sought from private doctor among children with ARI that sought treatment"
ch_ari_pharm		"ARI treatment sought from pharmacy among children with ARI"
ch_ari_pharm_trt	"ARI treatment sought from pharmacy among children with ARI that sought treatment"

ch_fev				"Fever symptoms in the 2 weeks before the survey"
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
*** the code below only excludes shop (h32s) and traditional practitioner (h32t). Some surveys also exclude pharmacies (h32k) or other sources.
gen ch_ari_care=0 if ch_ari==1
foreach c in a b c d e f g h i j k l m n o p q r {
replace ch_ari_care=1 if ch_ari==1 & h32`c'==1
}
* If you want to also remove pharmacy as a source of treatment (country specific condition)
replace ch_ari_care=0 if ch_ari==1 & h32k==1
replace ch_ari_care =. if b5==0
label var ch_ari_care "Advice or treatment sought for ARI symptoms"

//ARI care-seeking same or next day
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

***ARI treatment by source (among children with ARI symptoms)
* This is country specific and needs to be checked to produce the specific source of interest. 
* Some sources are coded below and the same logic can be used to code other sources. h32a-z indicates the source.

//ARI treamtment in government hospital
gen ch_ari_govh=0 if ch_ari==1
replace ch_ari_govh=1 if ch_ari==1 & h32a==1
replace ch_ari_govh =. if b5==0
label var ch_ari_govh "ARI treatment sought from government hospital among children with ARI"

gen ch_ari_govh_trt=0 if ch_ari_care==1
replace ch_ari_govh_trt=1 if ch_ari_care==1 & h32a==1
replace ch_ari_govh_trt =. if b5==0
label var ch_ari_govh_trt "ARI treatment sought from government hospital among children with ARI that sought treatment"

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


*** Fever indicators ***

//Fever 
gen ch_fev=0
cap replace ch_fev=1 if h22==1 
replace ch_fev =. if b5==0
label var ch_fev "Fever symptoms in the 2 weeks before the survey"
	
//Fever care-seeking
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** the code below only excludes shop (h32s) and traditional practitioner (h32t). Some surveys also exclude pharmacies (h32k) or other sources.
gen ch_fev_care=0 if ch_fev==1
foreach c in a b c d e f g h i j k l m n o p q r {
replace ch_fev_care=1 if ch_fev==1 & h32`c'==1
}
* If you want to also remove pharmacy as a source of treatment (country specific condition)
replace ch_fev_care=0 if ch_fev==1 & h32k==1

replace ch_fev_care =. if b5==0
label var ch_fev_care "Advice or treatment sought for fever symptoms"

//Fever care-seeking same or next day
gen ch_fev_care_day=0 if ch_fev==1
replace ch_fev_care_day=1 if ch_fev==1 & ch_fev_care==1 & h46b<2
replace ch_fev_care_day =. if b5==0
label var ch_fev_care_day "Advice or treatment sought for ARI symptoms on the same or next day"

//Fiven antibiotics for fever 
gen ch_fev_antib=0 if ch_fev==1
replace ch_fev_antib=1 if ch_fev==1 & (h37i==1 | h37j==1)
cap replace ch_fev_antib=1 if ch_fev==1 & (ml13i==1 | ml13j ==1)
replace ch_fev_antib =. if b5==0
label var ch_fev_antib "Antibiotics taken for fever symptoms"

