/*****************************************************************************************************
Program: 			ML_FEVER.do - DHS8 update
Purpose: 			Code indicators on fever, fever care-seeking, and antimalarial drugs
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and Cameron Taylor
Date last modified: July 11, 2023 by Cameron Taylor and Shireen Assaf
Notes:				There are similarities between the fever code in this do file and the ARI/Fever code for Chapter 10. 
					Several indicators (on care and specific antimalarial drugs) are country specific. Please see notes in the code.
					
					1 new indicator in DHS8, see below
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ml_fever			"Fever symptoms in the 2 weeks before the survey"
ml_fev_care			"Advice or treatment sought for fever symptoms"
ml_fev_care_day		"Advice or treatment sought for fever symptoms on the same or next day"
ml_stick			"Child received heel or finger stick"
ml_told_malaria		"Diagnosed with malaria by a healthcare provider" - NEW Indicator in DHS8

ml_fev_govh			"Fever treatment sought from government hospital among children with fever"
ml_fev_govh_trt		"Fever treatment sought from government hospital among children with fever that sought treatment"
ml_fev_govcent		"Fever treatment sought from government health center among children with fever"
ml_fev_govcent_trt	"Fever treatment sought from government health center among children with fever that sought treatment"
ml_fev_phosp		"Fever treatment sought from private hospital/clinic among children with fever"
ml_fev_phosp_trt	"Fever treatment sought from private hospital/clinic  among children with fever that sought treatment"
ml_fev_pdoc			"Fever treatment sought from private doctor among children with fever"
ml_fev_pdoc_trt		"Fever treatment sought from private doctor among children with fever that sought treatment"
ml_fev_pharm		"Fever treatment sought from a pharmacy among children with fever"
ml_fev_pharm_trt	"Fever treatment sought from a pharmacy among children with fever that sought treatment"

ml_antimal			"Child took any antimalarial"
ml_act				"Child took an ACT"
ml_sp_fan			"Child took SP/Fansider"
ml_chloro			"Child took Chloroquine"
ml_amodia			"Child took Amodiaquine"
ml_quin_pill		"Child took Quinine pills"
ml_quin_inj			"Child took Quinine injection or IV"
ml_artes_rec		"Child took Artesunate rectal"
ml_artes_inj		"Child took Artesunate injection or intravenous"
ml_antimal_other	"Child took other antimalarial"
----------------------------------------------------------------------------*/

*** Fever and care-seeking ***
//Fever
gen ml_fever=(h22==1)
replace ml_fever =. if b5==0
lab var ml_fever "Fever symptoms in the 2 weeks before the survey"

//Fever care-seeking
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** the code below only excludes traditional practitioner (h32t). Some surveys also exclude pharmacies (h32k), shop (h32s) or other sources.
*** In some surveys traditional practitioner is h32w. Please check the data file using des h32*
gen ml_fev_care=0 if ml_fever==1
foreach c in a b c d e f g h i j k l m n na nb nc nd ne o p q r s u v w x{
replace ml_fev_care=1 if ml_fever==1 & h32`c'==1
}
/* If you want to also remove pharmacy for example as a source of treatment (country specific condition) you can remove 
* the 'k in the list on line 53 or do the following.
replace ml_fev_care=0 if ml_fever==1 & h32k==1
*/
replace ml_fev_care =. if b5==0
label var ml_fev_care "Advice or treatment sought for fever symptoms"

//Fever care-seeking same or next day
gen ml_fev_care_day=0 if ml_fever==1
replace ml_fev_care_day=1 if ml_fever==1 & ml_fev_care==1 & h46b<2
replace ml_fev_care_day =. if b5==0
label var ml_fev_care_day "Advice or treatment sought for fever symptoms on the same or next day"

//Child with fever received heel or finger stick 
gen ml_stick=0 if ml_fever==1
replace ml_stick=1 if h47==1 & ml_fever==1
replace ml_stick =. if b5==0
lab var ml_stick "Child received heel or finger stick"

//Diagnosed with malaria by a healthcare provider - NEW Indicator in DHS8
gen ml_told_malaria=0 if ml_fever==1
replace ml_told_malaria=1 if h71==1
replace ml_told_malaria =. if b5==0
lab var ml_told_malaria "Diagnosed with malaria by a healthcare provider"

*** Fever treatment by source *** 
* Two population bases: 1. among children with fever symptoms, 2. among children with fever symptoms that sought treatment
* This is country specific and needs to be checked to produce the specific source of interest. 
* Some sources are coded below and the same logic can be used to code other sources. h32a-z indicates the source.

//Fever treamtment in government hospital
gen ml_fev_govh=0 if ml_fever==1
replace ml_fev_govh=1 if ml_fever==1 & h32a==1
replace ml_fev_govh =. if b5==0
label var ml_fev_govh "Fever treatment sought from govt hospital among children with fever"

gen ml_fev_govh_trt=0 if ml_fever==1 & h32y==0
replace ml_fev_govh_trt=1 if ml_fever==1 & h32a==1
replace ml_fev_govh_trt =. if b5==0
label var ml_fev_govh_trt "Fever treatment sought from govt hospital among children with fever that sought treatment"

//Fever treamtment in government health center
gen ml_fev_govcent=0 if ml_fever==1
replace ml_fev_govcent=1 if ml_fever==1 & h32b==1
replace ml_fev_govcent =. if b5==0
label var ml_fev_govcent "Fever treatment sought from govt health center among children with fever"

gen ml_fev_govcent_trt=0 if ml_fever==1 & h32y==0
replace ml_fev_govcent_trt=1 if ml_fever==1 & h32b==1 
replace ml_fev_govcent_trt =. if b5==0
label var ml_fev_govcent_trt "Fever treatment from govt health center among children with fever that sought treatment"

//Fever treatment from a private hospital
gen ml_fev_phosp=0 if ml_fever==1
replace ml_fev_phosp=1 if ml_fever==1 & h32j==1
replace ml_fev_phosp =. if b5==0
label var ml_fev_phosp "Fever treatment sought from private hospital among children with fever"

gen ml_fev_phosp_trt=0 if if ml_fever==1 & h32y==0
replace ml_fev_phosp_trt=1 if ml_fever==1 & h32j==1
replace ml_fev_phosp_trt =. if b5==0
label var ml_fev_phosp_trt "Fever treatment sought from private hospital  among children with fever that sought treatment"

//Fever treatment from a pharmacy
gen ml_fev_pharm=0 if ml_fever==1
replace ml_fev_pharm=1 if ml_fever==1 & h32k==1
replace ml_fev_pharm =. if b5==0
label var ml_fev_pharm "Fever treatment sought from a pharmacy among children with fever"

gen ml_fev_pharm_trt=0 if if ml_fever==1 & h32y==0
replace ml_fev_pharm_trt=1 if ml_fever==1 & h32k==1
replace ml_fev_pharm_trt =. if b5==0
label var ml_fev_pharm_trt "Fever treatment sought from a pharmacy among children with fever that sought treatment"

//Fever treatment from a private doctor
gen ml_fev_pdoc=0 if ml_fever==1
replace ml_fev_pdoc=1 if ml_fever==1 & h32l==1
replace ml_fev_pdoc =. if b5==0
label var ml_fev_pdoc "Fever treatment sought from private doctor among children with fever"

gen ml_fev_pdoc_trt=0 if if ml_fever==1 & h32y==0
replace ml_fev_pdoc_trt=1 if ml_fever==1 & h32l==1
replace ml_fev_pdoc_trt =. if b5==0
label var ml_fev_pdoc_trt "Fever treatment sought from private doctor among children with fever that sought treatment"




*** Antimalarial drugs ***
*Child with fever in past 2 weeks took any antimalarial
* This may need to be updated according to country specifications. 
* There may be additional survey-specific antimalarials in h37f and h37g or "s" variables. For instance in Ghana 2016 MIS there is s412f, s412g, s412h. Please search the date file.
* Also some drugs may be grouped. Please check final report and data files and adjust the code accordingly.
gen ml_antimal=0 if ml_fever==1
foreach x in a aa ab b c d da e f g h {
	replace ml_antimal=1 if h37`x'==1
	}
replace ml_antimal =. if b5==0
lab var ml_antimal "Child took any antimalarial"

*The antimalarial durg indicators below are among children with fever symptoms in the 2 weeks preceding the survey who took any antimalarial medication.	
//Child with fever in past 2 weeks took an ACT
gen ml_act=0 if ml_fever==1 & ml_antimal==1
replace ml_act=1 if h37e==1 
replace ml_act =. if b5==0
lab var ml_act "Child took an ACT"

//Child with fever in past 2 weeks took SP/Fansider
gen ml_sp_fan=0 if ml_fever==1 & ml_antimal==1
replace ml_sp_fan=1 if h37a==1
replace ml_sp_fan =. if b5==0
lab var ml_sp_fan "Child took SP/Fansider"

//Child with fever in past 2 weeks took Chloroquine 
gen ml_chloro=0 if ml_fever==1 & ml_antimal==1
replace ml_chloro=1 if h37b==1
replace ml_chloro =. if b5==0
lab var ml_chloro "Child took Chloroquine"

//Child with fever in past 2 weeks took Amodiaquine  
gen ml_amodia=0 if ml_fever==1 & ml_antimal==1
replace ml_amodia=1 if h37c==1
replace ml_amodia =. if b5==0
lab var ml_amodia "Child took Amodiaquine"

//Child with fever in past 2 weeks took Quinine pills  
gen ml_quin_pill=0 if ml_fever==1 & ml_antimal==1
replace ml_quin_pill=1 if h37d==1
replace ml_quin_pill =. if b5==0
lab var ml_quin_pill "Child took Quinine pills"

//Child with fever in past 2 weeks took Quinine injection or intravenous (IV)  
gen ml_quin_inj=0 if ml_fever==1 & ml_antimal==1
replace ml_quin_inj=1 if h37da==1
replace ml_quin_inj =. if b5==0
lab var ml_quin_inj "Child took Quinine injection or IV"

//Child with fever in past 2 weeks took Artesunate rectal
gen ml_artes_rec=0 if ml_fever==1 & ml_antimal==1
replace ml_artes_rec=1 if h37aa==1
replace ml_artes_rec =. if b5==0
lab var ml_artes_rec "Child took Artesunate rectal"

//Child with fever in past 2 weeks took Artesunate injection or intravenous
gen ml_artes_inj=0 if ml_fever==1 & ml_antimal==1
replace ml_artes_inj=1 if h37ab==1
replace ml_artes_inj =. if b5==0
lab var ml_artes_inj "Child took Artesunate injection or intravenous"

//Child with fever in past 2 weeks took other antimalarial
gen ml_antimal_other=0 if ml_fever==1 & ml_antimal==1
replace ml_antimal_other=1 if h37h==1
replace ml_antimal_other =. if b5==0
lab var ml_antimal_other "Child took other antimalarial"
