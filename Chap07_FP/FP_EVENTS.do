/*****************************************************************************************************
Program: 			FP_EVENTS.do
Purpose: 			Create Events Files from Calendar Data
Data inputs: 		IR data files
Data outputs:		Reshaped events file for analysis
Author:				Trevor Croft 
Date last modified: Mar 5 2019 by Courtney Allen for codeshare project 				
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
ev004		"Event number"
ev900  		"CMC event begins"
ev901  		"CMC event ends"
ev901a 		"Duration of event"
ev902a 		"Event code (alpha)"
ev903a 		"Discontinuation code (alpha)"
ev902  		"Event code"
ev903  		"Discontinuation code"
ev904  		"Prior event code" 
ev904x 		"Duration of prior event"
ev905  		"Next event code"
ev905x 		"Duration of next event"
ev906a 		"Married at end of episode (alpha)"
ev906  		"Married at end of episode"
/----------------------------------------------------------------------------*/


//SETUP
	//keep minimal variables due
	keep caseid v001 v002 v003 v005 v007 v008 v011 v017 v018 v019 v021 v023 v101 v102 v106 v190 vcal_*

	//set up which calendar columns to look at - column numbers can vary across phases of DHS
	local col1 1 // method use and pregnancies - always column 1
	local col2 2 // reasons for discontinuation - usually column 2
	local col3 3 // marriage - when it exists it is usually column 3
	
	//check to see if marriage calendar exists
		capture confirm variable vcal_`col3'
			if _rc!=0 { 						// variable does not exist
				display "Marriage column does not exist"
				local marr_col 
				local col3
				}
			else { 								// variable exists, but is it empty?
			if vcal_`col3'=="" { 				//variable is empty
				display "Marriage column exists but is empty"
				local marr_col 
				local col3
				}
			else {
				display "Marriage column exists and contains data"
				}
		}
	  
 
	  

//PART 1 

		/*---------------------------------------------------
		Convert calendar into separate variables per month.
		Starting at the chronological beginning of the 
		calendar, episodes are counted when there is a change
		from one month to another.
		---------------------------------------------------*/

	//set length of calendar
	local vcal_len = strlen(vcal_`col1'[1])	
	
	//set episode number to 0
	gen eps = 0								
	
	//set prev calendar column 1 to anything
	gen prev_vcal1 = "_"					 
	
	//create vars for each month of calendar
	forvalues j = `vcal_len'(-1)1 {			
		local i = `vcal_len' - `j' + 1
			
		//contraceptive method, non-use, or birth, pregnancy, or termination
		gen vcal1_`i' = substr(vcal_`col1',`j',1)	
			
		//reason for discontinuation
		gen vcal2_`i' = substr(vcal_`col2',`j',1)	

	//check if we have marriage info
	if "`marr_col'"!="" { 							
		gen vcal3_`i' = substr(vcal_`col3',`j',1)
			
		//set up parameter to add into reshape below, and collapse further below
		local vcal3_ vcal3_							
		local ev906 ev906a=vcal3_
			}
	  
	//increase the episode number if there is a change in vcal_1
	replace eps = eps+1 if vcal1_`i' != prev_vcal1	
	
	//set the episode number
	gen int ev004`i' = eps 						
	
	//save the vcal1 value for the next time through the loop
	replace prev_vcal1 = vcal1_`i'				
}


//PART 2 
		
		/*---------------------------------------------------
		Reshape data into a file with one record per month
		of the calendar.
		---------------------------------------------------*/

	//drop the calendar variables now we have the separate month by month variables
	drop vcal_* eps prev_vcal1

	//reshape the new month by month variables into a long format
	reshape long ev004 vcal1_ vcal2_ `vcal3_', i(caseid) j(i)

	//update the discontinuation code to a blank if it is empty
	replace vcal2_ = " " if vcal2_ == ""

	//label the event number variable
	label variable ev004 "Event number"


//PART 3
		
		/*---------------------------------------------------
		Calculate CMC for each month and drop months beyond 
		the month of interview.
		---------------------------------------------------*/
	
	//create the century month code (CMC) for each month
	gen cmc=v017+i-1

	//drop the blank episode after the date of interview
	drop if i > v019

	//capture the variable labels for the v variables
	foreach v of varlist v*{ 
		local l`v' : variable label `v'
		} 
	//and the value labels for the variables kept in the beginning: v101 v102 v106 v190 
	foreach v of varlist v1*{ 
		local `v'lbl : value label `v'
		}
 

//PART 4

		/*---------------------------------------------------
		Convert from a single month per record to an event 
		per record. Each event will have newly created 
		variables containing the start (ev900) and end (ev901)
		dates of the event as well as the duration (ev901a)
		of that event.
		---------------------------------------------------*/

	//collapse the episodes within each case, keeping start and end, the event code,
	//and other useful information (this list will be similar to the variables kept in beginning on line 30)
	collapse (first) v001 v002 v003 v005 v007 v008 v011 v017 v018 v019 v021 v023 v101 v102 v106 v190 ///
	  (first) ev900=cmc (last) ev901=cmc (count) ev901a=cmc ///
	  (last) ev902a=vcal1_ ev903a=vcal2_ `ev906', by(caseid ev004)

	//replace the variable label for all of the v//variables
	foreach v of varlist v*{
		label variable `v' `"`l`v''"'
		}
	//and the value labels for v101 v102 v106 v190
	foreach v of varlist v1*{ 
		label val `v' ``v'lbl'
		}

	//label the variables created in the collapse statement
	label variable ev900  "CMC event begins"
	label variable ev901  "CMC event ends"
	label variable ev901a "Duration of event"
	label variable ev902a "Event code (alpha)"
	label variable ev903a "Discontinuation code (alpha)"
	format ev004 %2.0f
	format ev900 ev901 %4.0f


//PART 5

		/*---------------------------------------------------
		Convert the event string variable for the episode (ev902a) 
		to numeric (ev902)
		
		NOTE: Set up a list of codes used in the calendar, with 
		the position in the string of codes being the code that 
		will be assigned use a tilde (~) to mark gaps in the 
		coding that are not used for this survey.
		
		Emergency contraception (E), Other modern method (M) and 
		Standard days method (S) are recent additions as standard 
		codes and may mean something different in earlier surveys. 
		Some of the codes are survey specific so this will need 
		adjusting.
		---------------------------------------------------*/

	//tab vcal1_ to see the full list of codes to handle for the survey you are using
	local methodlist = "123456789WNALCFEMS~"

	//convert the contraceptive methods to numeric codes, using the position in the string
	gen ev902 = strpos("`methodlist'",ev902a)
	
	//now convert the birth, termination and pregnancy codes to 81, 82, 83 respectively
	gen preg = strpos("BTP",ev902a)
	replace ev902 = preg+80 if preg>0
	drop preg

	//convert the missing code to 99
	replace ev902 = 99 if ev902a == "?"
	
	//now check if there are any codes that were not converted, and change these to -1
	replace ev902 = -1 if ev902 == 0 & ev902a != "0"

	//list cases where the event code was not recoded
	list caseid ev004 ev902 ev902a if ev902==-1


//PART 6

		/*---------------------------------------------------
		Convert the discontinuation string variable for the 
		episode (ev903a) to numeric (ev903).
		---------------------------------------------------*/
	
	//set up a list of codes used in the calendar
	//use a tilde (~) to mark gaps in the coding that are not used for this survey 
	local reasonlist = "123456789CFAD~~~~"
	
	//convert the reasons for discontinuation to numeric codes, using the position in the string
	gen ev903 = strpos("`reasonlist'",ev903a) if ev903a != " "
	
	//now convert the special codes for other, don't know and missing to 96, 98, 99 respectively
	gen special = strpos("W~K?",ev903a)
	replace ev903 = special + 95 if special > 0
	drop special
	
	//now check if there are any codes that were not converted, and change these to -1.
	replace ev903 = -1 if ev903 == 0 & ev903a != " "

	//list cases where the reason for discontinuation code was not recoded
	list caseid ev004 ev903 ev903a if ev903==-1


//PART 7

		/*---------------------------------------------------
		Capture the prior and next events and their durations.
		---------------------------------------------------*/

	//capture the previous event and its duration for this respondent
	by caseid: gen ev904  = ev902[_n-1]  if _n > 1
	by caseid: gen ev904x = ev901a[_n-1] if _n > 1
	
	//capture the following event and its duration for this respondent
	by caseid: gen ev905  = ev902[_n+1]  if _n < _N
	by caseid: gen ev905x = ev901a[_n+1] if _n < _N


//PART 8

		/*---------------------------------------------------
		Label the events file variables
		---------------------------------------------------*/

	//label the event file variables and values
	label variable ev902  "Event code"
	label variable ev903  "Discontinuation code"
	label variable ev904  "Prior event code"
	label variable ev904x "Duration of prior event"
	label variable ev905  "Next event code"
	label variable ev905x "Duration of next event"
	label def event ///
		  0 "No method used" ///
		  1 "Pill" ///
		  2 "IUD" ///
		  3 "Injectable" ///
		  4 "Diaphragm" ///
		  5 "Condom" ///
		  6 "Female sterilization" ///
		  7 "Male sterilization" ///
		  8 "Periodic abstinence/Rhythm" ///
		  9 "Withdrawal" ///
		 10 "Other traditional methods" ///
		 11 "Norplant" ///
		 12 "Abstinence" ///
		 13 "Lactational amenorrhea method" ///
		 14 "Female condom" ///
		 15 "Foam and Jelly" ///
		 16 "Emergency contraception" ///
		 17 "Other modern method" ///
		 18 "Standard days method" ///
		 81 "Birth" ///
		 82 "Termination" ///
		 83 "Pregnancy" ///
		 99 "Missing" ///
		 -1 "***Unknown code not recoded***" 
	label def reason ///
		  0 "No discontinuation" ///
		  1 "Became pregnant while using" ///
		  2 "Wanted to become pregnant" ///
		  3 "Husband disapproved" ///
		  4 "Side effects" ///
		  5 "Health concerns" ///
		  6 "Access/availability" ///
		  7 "Wanted more effective method" ///
		  8 "Inconvenient to use" ///
		  9 "Infrequent sex/husband away" ///
		 10 "Cost" ///
		 11 "Fatalistic" ///
		 12 "Difficult to get pregnant/menopause" ///
		 13 "Marital dissolution" ///
		 96 "Other" ///
		 98 "Don't know" ///
		 99 "Missing" ///
		 -1 "***Unknown code not recoded***" 
	label val ev902 event
	label val ev903 reason
	label val ev904 event
	label val ev905 event
	format ev901a ev902 ev903 ev904 ev904x ev905 ev905x %2.0f


//PART 9

		/*---------------------------------------------------
		Convert marriage codes (ev906a) to numeric (ev906),
		if marriage code exists
		---------------------------------------------------*/
	
	//confirm existence of marriage variable
	capture confirm variable ev906a
	if !_rc { 	// variable exists
	  gen ev906 = 7
	  replace ev906=0 if ev906a=="0"
	  replace ev906=1 if ev906a=="X"
	  replace ev906=9 if ev906a=="?"
	  label variable ev906a "Married at end of episode (alpha)"
	  label variable ev906  "Married at end of episode"
	  label def marriage 0 "Not married" 1 "Married" 7 "Unknown code" 9 "Missing" 
	  label val ev906 marriage
	  format ev906 %1.0f
	}
	*/

//PART 10
	
	/*---------------------------------------------------
	Save events file. See begining of do file for list of
	created variables.
	---------------------------------------------------*/

	//save the events file
	save eventsfile.dta, replace

