/*****************************************************************************************************
Program: 			FE_CBR.do
Purpose: 			Code to calculate Crude Birth Rate
Data inputs: 		PR data files
Data outputs:		coded variables
Author:				Courtney Allen for the code share project
Date last modified: October 23, 2019 by Courtney Allen
Note:				Creates a scalar. This do file must be run after the TFR.do 
					because the scalars that store the ASFRs are needed. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
CBR 		"Crude Birth Rate"
CBR_urban	"Crude Birth Rate - Urban"
CBR_rural	"Crude Birth Rate - Rural"

----------------------------------------------------------------------------*/

//create weight
gen wt = hv005/1000000

//cut age group into 5 yr groups
egen agegroup = cut(hv105), at(0,15,20,25,30,35,40,45,50,999)

//de facto population counts
	//count of entire de facto population by residence type
	summ hv103 [iw=wt] if hv103==1 
	scalar hh_pop = r(sum_w)

	//count of entire de facto population - urban
	summ hv103 [iw=wt] if hv103==1 & hv025==1
	scalar hh_pop_res1= r(sum_w)

	//count of entire de facto population - rural
	summ hv103 [iw=wt] if hv103==1 & hv025==2
	scalar hh_pop_res2= r(sum_w)

scalar CBR = 0
scalar CBR_urban = 0
scalar CBR_rural = 0

//counts for each age group
tokenize 1 2 3 4 5 6 7
forvalues i = 15(5)45 { 
	//count of de facto women by age group
	summ hv104 [iw=wt] if hv103==1 & hv104==2  & agegroup==`i'
	scalar women_pop_`i' = r(sum_w)

	//divide women by population
	scalar CBR_pop_`i' = women_pop_`i'/hh_pop

	//multiply by ASFRs for each age band
	scalar CBR_pop_`i'_temp = CBR_pop_`i'*cbr_r`1'*1000
	
	
//counts for each age group by residence type
forvalues j = 1/2 {
	//count of de facto women by residence type and age group
	summ hv104 [iw=wt] if hv103==1 & hv104==2 & agegroup==`i' & hv025==`j'
	scalar women_pop_`i'_res`j' = r(sum_w)
	
	//divide women by population
	scalar CBR_pop_`i'_res`j' = women_pop_`i'_res`j' /hh_pop_res`j'
	
	//multiply by ASFRs for each age band (r1-r7 are scalars for ASFRs created in the TFR.do file)
	scalar CBR_pop_`i'_temp_res`j' = (CBR_pop_`i'_res`j'*r`1'_`j'*1000)	
	}

	//sum to create CBR for urban and rural
	scalar CBR_urban = CBR_urban + CBR_pop_`i'_temp_res1
	scalar CBR_rural = CBR_rural + CBR_pop_`i'_temp_res2

	//sum to CBR 
	scalar CBR = CBR + CBR_pop_`i'_temp
mac shift
}

//create variables
gen CBR_urban = CBR_urban
gen CBR_rural = CBR_rural
gen CBR = CBR
	
//make output file
keep CBR*
collapse CBR CBR_urban CBR_rural
scalar sfn="$irdata"
scalar scid=substr(sfn,1,2)
scalar spv =substr(sfn,5,2)
local lcid=scid
local lpv=spv

export excel "Tables_`lcid'`lpv'_CBR.xlsx", firstrow(var) replace






