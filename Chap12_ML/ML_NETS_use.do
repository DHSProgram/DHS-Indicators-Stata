/*****************************************************************************************************
Program: 			ML_NETS_use.do
Purpose: 			HOUSEHOLD USE OF ITNS
Data inputs: 		PR survey list
Data outputs:		coded variables
Author:				Cameron Taylor
Date last modified: March 14 2019 by Cameron Taylor
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
mal_netcat	Mosquito net categorization
mal_itn		ITN
----------------------------------------------------------------------------*/

*** De facto household population who slept the night before the survey under an insecticide-treated net (ITN) ***
*** Children under age 5 who slept the night before the survey under an insecticide treated net (ITN) ***
*** Pregnant women age 15-49 who slept the night before the survey under an insecticide-treated net (ITN) ***


//Categorizing nets
	gen mal_netcat=0 if hml12==0
	replace mal_netcat=1 if hml12==1|hml12==2
	replace mal_netcat=2 if hml12==3
	lab var mal_netcat "Mosquito net categorization"

//ITN net variable
	gen mal_itn=(mal_netcat==1)
	lab var mal_itn "ITN"
