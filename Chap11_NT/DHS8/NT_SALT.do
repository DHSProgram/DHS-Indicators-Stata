/*****************************************************************************************************
Program: 			NT_SALT.do
Purpose: 			Code to compute salt indicators in households
Data inputs: 		HR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Dec 26, 2019 by Shireen Assaf 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

nt_salt_any	"Salt among all households"
nt_salt_iod	"Households with iodized salt"

----------------------------------------------------------------------------*/

//Salt among all households
recode hv234a (0/1=1 "With salt tested") (6=2 "With salt but not tested") (3=3 "No salt in household"), gen(nt_salt_any) 
label var nt_salt_any "Salt among all households"

//Have iodized salt
gen nt_salt_iod= hv234a==1 if hv234a<3
label var nt_salt_iod "Households with iodized salt"
