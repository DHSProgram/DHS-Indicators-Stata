/*****************************************************************************************************
Program: 			FP_DISCONT.do
Purpose: 			Create contraceptive discontinuation rates
Data inputs: 		Event data files (created from IR files)
Data outputs:		data set with 12-month discontinuation rates
Author:				Trevor Croft 
Date last modified: Jun 06 2019 by Courtney Allen for codeshare project

NOTE: 				this code can also be found in the online Contraceptive Tutorial: Example 9
LINK HERE ---->>>>  https://www.dhsprogram.com/data/calendar-tutorial/ 				
*****************************************************************************************************/


/*----------------------------------------------------------------------------//

Outputs:
Tables_Discont_ 12m.xlsx	This excel file has a table listing 12-month discontinuation
							rates by reason, method, and switching. The table also includes
							the	unweighted and weighted Ns.
							
eventsfile.dta				Events dataset file for the survey
/----------------------------------------------------------------------------*/


	/* -------------------------------------------------
	NOTE ON DISCONTINUATION RATES
		When calculating discontinuation rates using event 
		files note that the denominator in this table 
		is all women, including sterilized women also 
		includes missing methods to match the final reports.
		
		If you don't have stcompet installed, use the 
		line below to find it and follow instructions
		to install it:
		findit stcompet
	--------------------------------------------------*/


//STEP 1
	/* -------------------------------------------------
		Calculate exposure, late entries and censoring 
		for the	period 3-62 months prior to the interview
	--------------------------------------------------*/

	//gen wt
	gen wt = v005/1000000

	//drop events that were ongoing when calendar began
	drop if v017 == ev900

	//drop births, terminations, pregnancies, and episodes of non-use
	//keep missing methods. to exclude missing change 99 below to 100.
	drop if (ev902 > 80 & ev902 < 99) | ev902==0 

	// time from beginning of event to interview
	gen tbeg_int = v008 - ev900
	label var tbeg_int "time from beginning of event to interview"

	//time from end of event to interview
	gen tend_int = v008 - ev901
	label var tend_int "time from end of event to interview"

	//discontinuation variable
	gen discont = 0
	replace discont = 1 if ev903 != 0

	//censoring those who discontinue in last three months
	replace discont = 0 if tend_int < 3
	label var discont "discontinuation indicator"
	tab discont
	tab ev903 discont, m

	//generate late entry variable
	gen entry = 0
	replace entry = tbeg_int - 62 if tbeg_int >= 63
	tab tbeg_int entry

	//taking away exposure time outside of the 3 to 62 month window
	gen exposure = ev901a
	replace exposure = ev901a - (3 - tend_int) if tend_int < 3
	recode exposure -3/0=0

	//drop those events that started in the month of the interview and two months prior
	drop if tbeg_int < 3

	//drop events that started and ended before 62 months prior to survey
	drop if tbeg_int > 62 & tend_int > 62

	//to remove sterilized women from denominator use the command below - not used for DHS standard
	*replace exposure = . if ev902 == 6

	//censor any discontinuations that are associated with use > 59 months (not censored here in this example)
	*replace discont = 0 if (exposure - entry) > 59


// Step 2 
		/* -------------------------------------------------
		Recode contraceptive methods, discontinuation reason, 
		and construct switching
		--------------------------------------------------*/

	// recode contraceptive method
		/* -------------------------------------------------
		NOTE: IUD, Periodic Abstinence, and Withdrawal skipped 
		and grouped with other due to small numbers of cases. 
		You can tab ev902 to examine categories with few cases.
		--------------------------------------------------*/
	recode ev902 						///
		(1  = 1 "Pill")						///
	/*	(2  = 2 "IUD") */					///
		(3  = 3 "Injectables")	 			///
		(11 = 4 "Implant")					///
		(5  = 5 "Male condom")				///
	/*	(8  = 6 "Periodic abstinence") */  ///
	/*	(9  = 7 "Withdrawal") */			///
		(13 18 = 8 "LAM/EC")				///
		(nonmissing = 9 "Other")			///
		(missing = .), gen(method)
		
	tab ev902 method, m
	
		/* -------------------------------------------------
		NOTE: LAM and Emergency contraception are grouped here
		Other category is Female Sterilization, Male sterilization,
		Other Traditional, Female Condom, Other Modern, Standard 
		Days Method	plus IUD, Periodic Abstinence, Withdrawal
		You need to adjust global meth_list below if changing
		the grouping of methods above.
		--------------------------------------------------*/

	// change name of reasons label list to avoid labels we don't want 
	label copy reason ev903
	label val ev903 ev903
	label drop reason // we don't want the labels for reason being copied to var reason

	// recode reasons for discontinuation - ignoring switching
	recode ev903 			     						///
		(0 .     = .)		     						///
		(1       = 1 "Method failure")	     			///
		(2       = 2 "Desire to become pregnant")		///
		(9 12 13 = 3 "Other fertility related reasons")	///
		(4 5     = 4 "Side effects/health concerns")	///
		(7       = 5 "Wanted more effective method")	///
		(6 8 10  = 6 "Other method related")			///
		(nonmissing = 7 "Other/DK") if discont==1, gen(reason)
	label var reason "Reason for discontinuation"
	tab reason
	tab ev903 reason if discont==1, m

	//switching methods
	sort caseid ev004
	
	//switching directly from one method to the next, with no gap
	by caseid: gen switch = 1 if ev901+1 == ev900[_n+1]
	
	//if reason was "wanted more effective method" allow for a 1-month gap
	by caseid: replace switch = 1 if ev903 == 7 & ev901+2 >= ev900[_n+1] & ev905 == 0
	
	//not a switch if returned back to the same method
	by caseid: replace switch = . if ev902 == ev902[_n+1] & ev901+1 == ev900[_n+1]
	tab switch
		/* -------------------------------------------------
		NOTE: that these are likely rare, so there may be
		no or few changes from the command above 
		--------------------------------------------------*/
	
	//calculate variable for switching for discontinuations we are using
	gen discont_sw = .
	replace discont_sw = 1 if switch == 1 & discont == 1
	replace discont_sw = 2 if discont_sw == . & ev903 != 0 & ev903 != . & discont == 1
	label def discont_sw 1 "switch" 2 "other reason"
	label val discont_sw discont_sw
	tab discont_sw


//Step 3
		/* -------------------------------------------------
		Calculate the competing risks cumulative incidence 
		for each method and for all methods
		--------------------------------------------------*/

	//create global lists of the method variables included
	levelsof method
	global meth_codes `r(levels)'
	
	//modify meth_list and methods_list according to the methods included
		/* -------------------------------------------------
		for example, update global lists as below if needed
		global meth_list pill IUD inj impl mcondom pabst withdr lamec other
		global methods_list `" "Pill" "IUD" "Injectables" "Implant" "Male condom" "Periodic abstinence" "Withdrawal" "LAM/EC" "Other" "All methods" "'
		--------------------------------------------------*/
	global meth_list pill inj impl mcondom lamec other
	global methods_list `" "Pill" "Injectables" "Implant" "Male condom" "LAM/EC" "Other" "All methods" "'
	
	//create list of rates for later use
	global drate_list 
	global drate_list_sw 
	foreach m in $meth_list {
		global drate_list $drate_list drate_`m'
		global drate_list_sw $drate_list_sw drate_`m'_sw
	}

	//competing risks estimates - first all methods and then by method
	tokenize allmeth $meth_list
	foreach x in 0 $meth_codes {

		//by reason - no switching
		//declare time series data for st commands
		stset exposure if `x' == 0 | method == `x' [iw=wt], failure(reason==1) enter(entry)
		stcompet discont_`1' = ci, compet1(2) compet2(3) compet3(4) compet4(5) compet5(6) compet6(7) 
		//convert rate to percentage
		gen drate_`1' = discont_`1' * 100

		//switching
		//declare time series data for st commands
		stset exposure if `x' == 0 | method == `x' [iw=wt], failure(discont_sw==1) enter(entry)
		stcompet discont_`1'_sw = ci, compet1(2) 
		//convert rate to percentage
		gen drate_`1'_sw = discont_`1'_sw * 100

		//Get the label for the method and label the variables appropriately
		local lab1 All methods
		if `x' > 0 {
			local lab1 : label method `x'
		}
		label var drate_`1' "Rate for `lab1'"
		label var drate_`1'_sw "Rate for `lab1' for switching"
		
		//shift to next method name in token list
		macro shift
	}

	//keep just the variables we need for output
	keep caseid method drate* exposure reason discont_sw wt entry

	//save data file with cumulative incidence variables added to each case
	save "drates.dta", replace


//Step 4
		/* -------------------------------------------------
		Calculate and save the weighted and unweighted denominators
		and convert into format for adding to dataset of results
		--------------------------------------------------*/
		
	//calculate unweighted Ns for entries in the first month of the life table
	drop if entry != 0
	collapse (count) methodNunwt = entry, by(method)
	save "method_Ns.dta", replace

	//calculate weighted Ns, for total episodes including late entries
	use "drates.dta", clear
	collapse (count) methodNwt = entry [iw=wt], by(method)

	//merge in the unweighted Ns
	merge 1:1 method using "method_Ns.dta"

	//drop the merge variable
	drop _merge

	//switch rows (methods) and columns (weighted and unweighted counts)
		/* -------------------------------------------------
		NOTE: this will create a file that will have a row 
		for weight Ns and a row for unweighted Ns with methods
		as the variables
		--------------------------------------------------*/
	
	//first transpose the file
	xpose, clear
	
	// rename the variables v1 to v9 to match the drate variable list (ignoring all methods)
	tokenize $drate_list
	local num : list sizeof global(drate_list)
	forvalues x = 1/`num' { // this list is a sequential list of numbers up to the count of vars
		rename v`x' `1'
		mac shift
	}
	
	//drop the first line with the method code as the methods are now variables
	drop if _n == 1
	
	//generate the reason code (to be used last for the Ns)
	gen reason = 9 + _n

	//save the final Ns - two rows, one for weighhted N, one for unweighted N
	save "method_Ns.dta", replace


//Step 5 
		/* -------------------------------------------------
		Combine components for results output
		--------------------------------------------------*/

	//Prepare resulting data for output
		/* -------------------------------------------------
		NOTE: This code can be used to produce rates for 
		different durations for use, but is here set for
		12-month discontinuation rates
		--------------------------------------------------*/

	//Loop through possible discontinuation rates for 6, 12, 24 and 36 months
	*foreach x in 6 12 24 36 {
	
	//current version presents only 12-month discontinuation rates:
	local x 12

	//open the working file with the rates attached to each case
	use "drates.dta", clear	

	//collect information from relevant time period only
	drop if exposure > `x'

	//keep only discontinuation information
	keep method drate* exposure reason discont_sw wt

	//save smaller dataset for x-month duration which we will use in collapse commands below
	save "drates_`x'm.dta", replace

	//collapsing data for reasons, all reasons, switching, merging and adding method Ns
	
	//reasons for discontinuation
		//collapse by discontinuation category and save
		collapse (max) $drate_list drate_allmeth, by(reason)
		
		//drop missing values
		drop if reason == .
		save "reasons.dta", replace

	//all reasons
		//calculate total discontinuation and save
		collapse (sum) $drate_list drate_allmeth
		gen reason = 8
		save "allreasons.dta", replace

	//switching data
	use "drates_`x'm.dta"
		//collapse and save a file just for switching
		collapse (max) $drate_list_sw drate_allmeth_sw, by(discont_sw)
		//only keep row for switching, not for other reasons
		drop if discont_sw != 1
		//we no longer need discont_sw and don't want it in the resulting file
		drop discont_sw 
		gen reason = 9	// switching
		//rename switching variables to match the non-switching names
		rename drate_*_sw drate_*
		save "switching.dta", replace

	//Go back to data by reasons and merge "all reasons" and switching data to it
	use "reasons.dta"
	append using "allreasons.dta" 	// all reasons
	append using "switching.dta" 	// switching 
	append using "method_Ns.dta" 	// weighted and unweighted numbers
	label def reason 8 "All reasons" 9 "Switching" 10 "Weighted N" 11 "Unweighted N", add

	//replace empty cells with zeros for each method
	//sum the weighted and unweighted Ns into the all methods variable
	foreach z in drate_allmeth $drate_list {
		replace `z' = 0 if `z' == .
		
		// sum the method Ns to give the total Ns
		replace drate_allmeth = drate_allmeth + `z' if reason >= 10
	}
	
	save "drates_`x'm.dta", replace


//Step 6
		/* -------------------------------------------------
		Output results in various ways
		--------------------------------------------------*/

	//simple output with reasons in rows and methods in columns
	*list reason $drate_list drate_allmeth, tab div abb(16) sep(9) noobs linesize(160)
	*to create a csv file for the rates you can use the code in the next line. 
	*outsheet reason $drate_list drate_allmeth using rates_`x'm.csv, comma replace	

	//outputting as excel file with putexcel	
	putexcel set "Tables_Discont_`x'm.xlsx", replace
	putexcel B1 = "Reasons for discontinuation"
	putexcel A2 = "Contraceptive method"
	
	//list out the contraceptive methods
	local row = 2
	foreach method of global methods_list {
		local row = `row'+1
		putexcel A`row' = "`method'"
	}

	putexcel B3:J`row', nformat(number_d2)
	putexcel K3:L`row', nformat(number)

	tokenize B C D E F G H I J K L
	local recs = [_N]
	
	//loop over reasons for discontinuation
	forvalues j = 1/`recs' {
		local lab1 : label reason `j'
		putexcel `1'2 = "`lab1'", txtwrap
		local k = 2
		//loop over contraceptive methods
		local str
		foreach i in $drate_list drate_allmeth {
			local k = `k'+1
			local str `str' `1'`k' = `i'[`j']
		}
		
		//output results for method
		putexcel `str'
		mac shift
	}


	//Convert results dataset into long format for use with other tab commands
	reshape long drate_, i(reason) j(method_name) string
	gen method = .
	tokenize $meth_list allmeth
	foreach m in $meth_codes 10 {
		replace method = `m' if method_name == "`1'"
		mac shift
	}
	label var method "Contraceptive method"
	label def method			///
		1 "Pill"				///
		2 "IUD"					///
		3 "Injectables"	 		///
		4 "Implant"				///
		5 "Male condom"			///
		6 "Periodic abstinence"	///
		7 "Withdrawal"			///
		8 "LAM/EC"				///
		9 "Other"				///
		10 "All methods"
	label val method method

	//Now tabulate (using table instead of tab to avoid extra Totals)
	table method reason [iw=drate_], cellwidth(10) f(%3.1f)


	//close loop if multiple durations used and file clean up
	//add below closing brace if foreach is used for different durations (see line 305)
	*}


	//clean up working files
	erase "drates.dta"
	erase "reasons.dta"
	erase "allreasons.dta"
	erase "switching.dta"
	erase "method_Ns.dta"
	
	*these are the discontinuation rates stored as a Stata data file. If you wish to have this file uncomment the line below.
	erase "drates_12m.dta"
