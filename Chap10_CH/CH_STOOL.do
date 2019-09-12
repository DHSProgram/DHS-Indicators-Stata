/*****************************************************************************************************
Program: 			CH_STOOL.do
Purpose: 			Code disposal of child's stook variable
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: September 4 2019 by Shireen Assaf 
Notes:				This do file will drop cases. 
					This is because the denominator is the youngest child under age 2 living with the mother. 			
					The do file will also produce the tables for these indicators. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_stool_dispose	"How child's stool was disposed"
ch_stool_safe		"Child's stool was disposed of appropriately"
----------------------------------------------------------------------------*/

* keep if under 24 months and living with mother
keep if age < 24 & b9 == 0

* and keep the last born of those.
* if caseid is the same as the prior case, then not the last born
keep if _n == 1 | caseid != caseid[_n-1]

//Stool disposal method
recode v465	(1=1 "Child used toilet or latrine") (2=2 "Put/rinsed into toilet or latrine") (5=3 "Buried") (3=4 "Put/rinsed into drain or ditch") ///
			(4=5 "Thrown into garbage") (9=6 "Left in the open") (96=96 "Other") (98=99 "DK/Missing") , gen(ch_stool_dispose)
label var ch_stool_dispose "How child's stool was disposed among youngest children under age 2 living with mother"

//Safe stool disposal
recode ch_stool_dispose	(1 2 3 =1 "Safe disposal") (else=0 "not safe") , gen(ch_stool_safe)
label var ch_stool_safe	"Child's stool was disposed of appropriately among youngest children under age 2 living with mother"

****************************************************************************
* Produce tables for the above indicators 
****************************************************************************

*Age in months
recode age (0/5=1 " <6") (6/11=2 " 6-11") (12/23=3 " 12-23") (24/35=4 " 24-35") (36/47=5 " 36-47") (48/59=6 " 48-59"), gen(agecats)

gen wt=v005/1000000

//Disposal of children's stool

*Age in months (this may need to be recoded for this table)
tab agecats ch_stool_dispose [iw=wt], row nofreq 

*residence
tab v025 ch_stool_dispose [iw=wt], row nofreq 

*region
tab v024 ch_stool_dispose [iw=wt], row nofreq 

*education
tab v106 ch_stool_dispose [iw=wt], row nofreq 

*wealth
tab v190 ch_stool_dispose [iw=wt], row nofreq 

* output to excel
tabout agecats v025 v106 v024 v190 ch_stool_dispose using Tables_Stool.xls [iw=wt], c(row) f(1) replace 
**************************************************************************************************
//Safe disposal of stool

*Age in months (this may need to be recoded for this table)
tab agecats ch_stool_safe [iw=wt], row nofreq 

*residence
tab v025 ch_stool_safe [iw=wt], row nofreq 

*region
tab v024 ch_stool_safe [iw=wt], row nofreq 

*education
tab v106 ch_stool_safe [iw=wt], row nofreq 

*wealth
tab v190 ch_stool_safe [iw=wt], row nofreq 

* output to excel
tabout agecats v025 v106 v024 v190 ch_stool_safe using Tables_Stool.xls [iw=wt], c(row) f(1) append 
**************************************************************************************************