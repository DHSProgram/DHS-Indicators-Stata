/*****************************************************************************************************
Program: 			CH_SIZE.do
Purpose: 			Code child size variables.
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: March 12 2019 by Shireen Assaf 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_size_birth	"Size of child at birth as reported by mother"
ch_report_bw	"Has a reported birth weight"
ch_below_2p5	"Birth weight less than 2.5 kg"
----------------------------------------------------------------------------*/

//Child's size at birth
recode m18 (5=1 "Very small") (4=2 "Smaller than average") (1/2 =3 "Average or larger") (8/9=9 "Don't know/missing"), gen(ch_size_birth)

//Child's reported birth weight
recode m19 (0/9000=1) (else=0), gen(ch_report_bw)

//Child before 2.5kg
recode m19 (0/2499=1) (else=0) if ch_report_bw==1, gen(ch_below_2p5)
