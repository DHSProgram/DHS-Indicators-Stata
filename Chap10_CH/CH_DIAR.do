/*****************************************************************************************************
Program: 			CH_DIAR.do
Purpose: 			Code diarrhea variables.
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: March 15 2019 by Shireen Assaf 
Notes:				Check notes for diarrhea care and treatment variables which are country specific.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_diar				"Diarrhea in the 2 weeks before the survey"
ch_diar_care		"Advice or treatment sought for diarrhea"

ch_diar_liq			"Amount of liquids given for child with diarrhea"
ch_diar_food		"Amount of food given for child with diarrhea"

ch_diar_ors			"Given oral rehydration salts for diarrhea"
ch_diar_rhf			"Given recommended homemade fluids for diarrhea"
ch_diar_ors_rhf		"Given either ORS or RHF for diarrhea"
ch_diar_zinc		"Given zinc for diarrhea"
ch_diar_zinc_ors	"Given zinc and ORS for diarrhea"
ch_diar_ors_fluid	"Given ORS or increased fluids for diarrhea"
ch_diar_ort			"Given oral rehydration treatment and increased liquids for diarrhea"
ch_diar_ort_feed	"Given ORT and continued feeding for diarrhea"
ch_diar_antib		"Given antibiotic drugs for diarrhea"
ch_diar_antim		"Given antimotility drugs for diarrhea"
ch_diar_intra		"Given Intravenous solution for diarrhea"
ch_diar_other		"Given home remedy or other treatment  for diarrhea"
ch_diar_notrt		"No treatment for diarrhea"

ch_diar_govh 		"Diarrhea treatment sought from government hospital among children with diarrhea"
ch_diar_govh_trt 	"Diarrhea treatment sought from government hospital among children with diarrhea that sought treatment"
ch_diar_govh_ors 	"Diarrhea treatment sought from government hospital among children with diarrhea that received ORS"
ch_diar_govcent 	"Diarrhea treatment sought from government health center among children with diarrhea"
ch_diar_govcent_trt "Diarrhea treatment sought from government health center among children with diarrhea that sought treatment"
ch_diar_govcent_ors "Diarrhea treatment sought from government health center among children with diarrhea that received ORS"
ch_diar_pclinc 		"Diarrhea treatment sought from private hospital/clinic among children with diarrhea"
ch_diar_pclinc_trt 	"Diarrhea treatment sought from private hospital/clinic among children with diarrhea that sought treatment"
ch_diar_pclinc_ors 	"Diarrhea treatment sought from private hospital/clinic among children with diarrhea that received ORS"
ch_diar_pdoc 		"Diarrhea treatment sought from private doctor among children with diarrhea"
ch_diar_pdoc_trt 	"Diarrhea treatment sought from private doctor among children with diarrhea that sought treatment"
ch_diar_pdoc_ors 	"Diarrhea treatment sought from private doctor among children with diarrhea that received ORS"
ch_diar_pharm 		"Diarrhea treatment sought from a pharmacy among children with diarrhea"
ch_diar_pharm_trt 	"Diarrhea treatment sought from a pharmacy among children with diarrhea that sought treatment"
ch_diar_pharm_ors 	"Diarrhea treatment sought from a pharmacy among children with diarrhea that received ORS"
----------------------------------------------------------------------------*/
	
//Diarrhea symptoms
gen ch_diar=0
replace ch_diar=1 if h11==1 | h11==2
replace ch_diar =. if b5==0
label var ch_diar "Diarrhea in the 2 weeks before the survey"

//Diarrhea treatment	
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** The code below only excludes traditional practitioner (usually h12t). The variable for traditional healer may be different for different surveys (you can check this by: des h12*). 
*** Some surveys also exclude pharmacies, shop, or other sources.
gen ch_diar_care=0 if ch_diar==1
foreach c in a b c d e f g h i j k l m n o p q r s u v w x {
replace ch_diar_care=1 if ch_diar==1 & h12`c'==1
}
/* If you want to also remove pharmacy for example as a source of treatment (country specific condition) you can remove 
* the 'k in the list on line 57 or do the following.
replace ch_diar_care=0 if ch_diar==1 & h12k==1
replace ch_diar_care =. if b5==0
*/
label var ch_diar_care "Advice or treatment sought for diarrhea"
    
//Liquid intake
recode h38 (5=1 "More") (4=2 "Same as usual") (3=3 "Somewhat less") (2=4 "Much less") (0=5 "None") ///
(8=9 "Don't know/missing") if ch_diar==1, gen(ch_diar_liq)
label var ch_diar_liq "Amount of liquids given for child with diarrhea"

//Food intake
recode h39 (5=1 "More") (4=2 "Same as usual") (3=3 "Somewhat less") (2=4 "Much less") (0=5 "None") ///
(1=6 "Never gave food") (8=9 "Don't know/missing") if ch_diar==1, gen(ch_diar_food)
label var ch_diar_food "Amount of food given for child with diarrhea"

//ORS
gen ch_diar_ors=0 if ch_diar==1
replace ch_diar_ors=1 if (h13==1 | h13==2 | h13b==1)
label var ch_diar_ors "Given oral rehydration salts for diarrhea"

//RHF
gen ch_diar_rhf=0 if ch_diar==1
replace ch_diar_rhf=1 if (h14==1 | h14==2)
label var ch_diar_rhf "Given recommended homemade fluids for diarrhea"

//ORS or RHF
gen ch_diar_ors_rhf=0 if ch_diar==1
replace ch_diar_ors_rhf=1 if  (h13==1 | h13==2 | h13b==1 | h14==1 | h14==2)
label var ch_diar_ors_rhf "Given either ORS or RHF for diarrhea"

//Zinc
gen ch_diar_zinc=0 if ch_diar==1
replace ch_diar_zinc=1 if ch_diar==1 & (h15e==1)
label  var ch_diar_zinc "Given zinc for diarrhea"

//Zinc and ORS
gen ch_diar_zinc_ors=0 if ch_diar==1
replace ch_diar_zinc_ors=1 if ((h13==1 | h13==2 | h13b==1) & (h15e==1))
label var ch_diar_zinc_ors "Given zinc and ORS for diarrhea"

//ORS or increased liquids
gen ch_diar_ors_fluid=0 if ch_diar==1
replace ch_diar_ors_fluid=1 if (h13==1 | h13==2 | h13b==1 | h38==5)
label var ch_diar_ors_fluid "Given ORS or increased fluids for diarrhea"

//ORT or increased liquids
gen ch_diar_ort=0 if ch_diar==1
replace ch_diar_ort=1 if (h13==1 | h13==2 | h14==1 | h14==2 | h38==5)
cap replace ch_diar_ort=1 if h13b==1 // older surveys do not have h13b
label var ch_diar_ort "Given oral rehydration treatment or increased liquids for diarrhea"

//ORT and continued feeding
gen ch_diar_ort_feed=0 if ch_diar==1
replace ch_diar_ort_feed=1 if ((h13==1 | h13==2 | h13b==1 | h14==1 | h14==2 | h38==5)&(h39>=3 & h39<=5))
label var ch_diar_ort_feed "Given ORT and continued feeding for diarrhea"

//Antibiotics
gen ch_diar_antib=0 if ch_diar==1
replace ch_diar_antib=1 if (h15==1 | h15b==1)
label var ch_diar_antib "Given antibiotic drugs for diarrhea"

//Antimotility drugs
gen ch_diar_antim=0 if ch_diar==1
replace ch_diar_antim=1 if h15a==1
label var ch_diar_antim "Given antimotility drugs for diarrhea"

//Intravenous solution
gen ch_diar_intra=0 if ch_diar==1
replace ch_diar_intra=1 if h15c==1
label var ch_diar_intra "Given Intravenous solution for diarrhea"

//Home remedy or other treatment
gen ch_diar_other=0 if ch_diar==1
replace ch_diar_other=1 if h15d==1 | h15f==1 | h15g==1 | h15h==1 | h15i==1 | h15j==1 | h15k==1 | h15l==1 | h15m==1 | h20==1
label var ch_diar_other "Given home remedy or other treatment for diarrhea"

//No treatment
gen ch_diar_notrt=0 if ch_diar==1
replace ch_diar_notrt=1 if h21a==1
* to double check if received any treatment then the indicator should be replaced to 0
foreach c in ch_diar_ors ch_diar_rhf ch_diar_ors_rhf ch_diar_zinc ch_diar_zinc_ors ch_diar_ors_fluid ch_diar_ort ch_diar_ort_feed ch_diar_antib ch_diar_antim ch_diar_intra ch_diar_other {		
replace ch_diar_notrt=0 if `c'==1
}
label var ch_diar_notrt "No treatment for diarrhea"
	

***Diarrhea treatment by source (among children with diarrhea symptoms)
* Three population bases: 1. among children with diarrhea, 2. among children with diarrhea that sought treatment
*                         3. among children with diarrhea that received ORS
* This is country specific and needs to be checked to produce the specific source of interest. 
* Some sources are coded below and the same logic can be used to code other sources. h12a-z indicates the source.

//Diarrhea treatment in government hospital
gen ch_diar_govh=0 if ch_diar==1
replace ch_diar_govh=1 if ch_diar==1 & h12a==1
replace ch_diar_govh =. if b5==0
label var ch_diar_govh "Diarrhea treatment sought from government hospital among children with diarrhea"

gen ch_diar_govh_trt=0 if ch_diar_care==1
replace ch_diar_govh_trt=1 if ch_diar_care==1 & h12a==1
replace ch_diar_govh_trt =. if b5==0
label var ch_diar_govh_trt "Diarrhea treatment sought from government hospital among children with diarrhea that sought treatment"

gen ch_diar_govh_ors=0 if ch_diar_ors==1
replace ch_diar_govh_ors=1 if ch_diar_ors==1 & h12a==1
replace ch_diar_govh_ors =. if b5==0
label var ch_diar_govh_ors "Diarrhea treatment sought from government hospital among children with diarrhea that received ORS"

//Diarrhea treatment in government health center
gen ch_diar_govcent=0 if ch_diar==1
replace ch_diar_govcent=1 if ch_diar==1 & h12b==1
replace ch_diar_govcent =. if b5==0
label var ch_diar_govcent "Diarrhea treatment sought from government health center among children with diarrhea"

gen ch_diar_govcent_trt=0 if ch_diar_care==1
replace ch_diar_govcent_trt=1 if ch_diar_care==1 & h12b==1
replace ch_diar_govcent_trt =. if b5==0
label var ch_diar_govcent_trt "Diarrhea treatment sought from government health center among children with diarrhea that sought treatment"

gen ch_diar_govcent_ors=0 if ch_diar_ors==1
replace ch_diar_govcent_ors=1 if ch_diar_ors==1 & h12b==1
replace ch_diar_govcent_ors =. if b5==0
label var ch_diar_govcent_ors "Diarrhea treatment sought from government health center among children with diarrhea that received ORS"

//Diarrhea treatment from a private hospital/clinic
gen ch_diar_pclinc=0 if ch_diar==1
replace ch_diar_pclinc=1 if ch_diar==1 & h12j==1
replace ch_diar_pclinc =. if b5==0
label var ch_diar_pclinc "Diarrhea treatment sought from private hospital/clinic among children with diarrhea"

gen ch_diar_pclinc_trt=0 if ch_diar_care==1
replace ch_diar_pclinc_trt=1 if ch_diar_care==1 & h12j==1
replace ch_diar_pclinc_trt =. if b5==0
label var ch_diar_pclinc_trt "Diarrhea treatment sought from private hospital/clinic among children with diarrhea that sought treatment"

gen ch_diar_pclinc_ors=0 if ch_diar_ors==1
replace ch_diar_pclinc_ors=1 if ch_diar_ors==1 & h12j==1
replace ch_diar_pclinc_ors =. if b5==0
label var ch_diar_pclinc_ors "Diarrhea treatment sought from private hospital/clinic among children with diarrhea that received ORS"

//Diarrhea treatment from a private doctor
gen ch_diar_pdoc=0 if ch_diar==1
replace ch_diar_pdoc=1 if ch_diar==1 & h12l==1
replace ch_diar_pdoc =. if b5==0
label var ch_diar_pdoc "Diarrhea treatment sought from private doctor among children with diarrhea"

gen ch_diar_pdoc_trt=0 if ch_diar_care==1
replace ch_diar_pdoc_trt=1 if  ch_diar_care==1 & h12l==1
replace ch_diar_pdoc_trt =. if b5==0
label var ch_diar_pdoc_trt "Diarrhea treatment sought from private doctor among children with diarrhea that sought treatment"

gen ch_diar_pdoc_ors=0 if ch_diar_ors==1
replace ch_diar_pdoc_ors=1 if ch_diar_ors==1 &  h12a==1
replace ch_diar_pdoc_ors =. if b5==0
label var ch_diar_pdoc_ors "Diarrhea treatment sought from private doctor among children with diarrhea that received ORS"

//Diarrhea treatment from a pharmacy
gen ch_diar_pharm=0 if ch_diar==1
replace ch_diar_pharm=1 if ch_diar==1 & h12k==1
replace ch_diar_pharm =. if b5==0
label var ch_diar_pharm "Diarrhea treatment sought from a pharmacy among children with diarrhea"

gen ch_diar_pharm_trt=0 if ch_diar_care==1
replace ch_diar_pharm_trt=1 if  ch_diar_care==1 & h12k==1
replace ch_diar_pharm_trt =. if b5==0
label var ch_diar_pharm_trt "Diarrhea treatment sought from a pharmacy among children with diarrhea that sought treatment"

gen ch_diar_pharm_ors=0 if ch_diar_ors==1
replace ch_diar_pharm_ors=1 if ch_diar_ors==1 & h12k==1
replace ch_diar_pharm_ors =. if b5==0
label var ch_diar_pharm_ors "Diarrhea treatment sought from a pharmacy among children with diarrhea that received ORS"
