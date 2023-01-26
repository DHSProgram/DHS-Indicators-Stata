/*****************************************************************************************************
Program: 			CH_SIZE.do
Purpose: 			Code child size variables.
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Jan 24, 2023 by Shireen Assaf
Notes: 				One new indicator and a few updates in DHS8:
					- use NR file instead of KR file
					- change from 5 years before survey to 2 years before the survey (using p19 for age).
					- use m80 to select live births (1,2)
					- update child's reported birth weight to indicate source
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_size_birth		"Size of child at birth as reported by mother"
ch_report_bw		"Has a reported birth weight from either source"
ch_report_bw_source	"Reported birth weight by source" - NEW Indicator in DHS8
ch_below_2p5		"Birth weight less than 2.5 kg"
----------------------------------------------------------------------------*/

//Child's size at birth
recode m18 (5=1 "Very small") (4=2 "Smaller than average") (1/2 =3 "Average or larger") (8/9=9 "Don't know/missing") if p19<24 & m80<=2 , gen(ch_size_birth)
label var ch_size_birth	"Size of child at birth as reported by mother"

//Child's reported birth weight by either source
recode m19a (0 8 9=0 "Not weighed") (else=1 "Either source") if p19<24 & m80<=2 , gen(ch_report_bw)
label var ch_report_bw "Has a reported birth weight from either source"

//Child's reported birth weight by source - NEW Indicator in DHS8
recode m19a (0 8 9=0 "Not weighed") (1=1 "Written report") (2=2 "Mother's report") if p19<24 & m80<=2 , gen(ch_report_bw_source)
label var ch_report_bw_source "Reported birth weight by source"

//Child before 2.5kg
recode m19 (0/2499=1) (else=0) if ch_report_bw==1 & p19<24 & m80<=2, gen(ch_below_2p5) 
label values ch_below_2p5 yesno
label var ch_below_2p5 "Birth weight less than 2.5 kg"

