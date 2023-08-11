/*********************************************************************
Program: 			PH_WATER.do
Purpose: 			creates variable for binary improved water source according to JSTOR standard 
Data inputs: 		hr or pr file
Data outputs:		none
Author of do file:	04/08/2018	Courtney Allen
Date last modified: 06/23/2023	Courtney Allen - for codeshare project
Note:				These indicators can also be computed using the HR or PR file.
					If you want to produce estimates for households, use the HR file.
					If you want to produce estimates for the de jure population, 
					use the PR file and select for dejure household memebers using
					hv102==1. Please see the Guide to DHS Statistics.  
					
					10/3/2022 Shireen Assaf to use hv000 and hv007 instead of file names. This alternative will not be effected by changes in data file versions. 
*****************************************************************************************************/

/*------------------------------------------------------------------------------
This do file can be run on any loop of countries indicating the dataset with
the country code (hv000) and the year (hv007) when necessary. 
Code should be same for pr or hr files.

VARIABLES CREATED
	ph_wtr_trt_boil		"Treated water by boiling before drinking"
	ph_wtr_trt_chlor	"Treated water by adding bleach or chlorine before drinking"
	ph_wtr_trt_cloth	"Treated water by straining through cloth before drinking"
	ph_wtr_trt_filt		"Treated water by ceramic, sand, or other filter before drinking"
	ph_wtr_trt_solar	"Treated water by solar disinfection before drinking"
	ph_wtr_trt_stand	"Treated water by letting stand and settle before drinking"
	ph_wtr_trt_other	"Treated water by other means before drinking"
	ph_wtr_trt_none		"Did not treat water before drinking"
	ph_wtr_trt_appr		"Appropriately treated water before drinking"
	ph_wtr_source 		"Source of drinking water"
	ph_wtr_improve 		"Improved drinking water" 
	ph_wtr_time			"Round trip time to obtain drinking water"
	ph_wtr_basic		"Basic water service"
	ph_wtr_avail		"Availability of water among those using piped water or water from tube well or borehole"

NOTE: 
STANDARD CATEGORIES FOR WATER SOURCE BY IMPROVED/UNIMPROVED
	0-unimproved 
		30	 well - protection unspecified	
		32	 unprotected well
		40	 spring - protection unspecified
		42	 unprotected spring
		43	 surface water (river/dam/lake/pond/stream/canal/irrigation channel)
		96	 other	
	1-improved
		11	 piped into dwelling
		12	 piped to yard/plot
		13	 public tap/standpipe
		14	 piped to neighbor
		15	 piped outside of yard/lot
		21	 tube well or borehole
		31	 protected well
		41	 protected spring
		51	 rainwater
		61	 tanker truck	
		62	 cart with small tank, cistern, drums/cans
		65	 purchased water	
		71	 bottled water
		72	 purified water, filtration plant
		73	 satchet water
	
------------------------------------------------------------------------------*/
// create yesno label for most basic binary indicators
cap label define yesno 0"No" 1"Yes"

// create water treatment indicators

	// treated water by boiling
	gen ph_wtr_trt_boil = hv237a
	replace ph_wtr_trt_boil = 0 if hv237a>=8
	label val ph_wtr_trt_boil yesno
	label var ph_wtr_trt_boil	"Treated water by boiling before drinking"

	// treated water by adding bleach or chlorine
	gen ph_wtr_trt_chlor = hv237b
	replace ph_wtr_trt_chlor = 0 if hv237b>=8
	label val ph_wtr_trt_chlor yesno
	label var ph_wtr_trt_chlor	"Treated water by adding bleach or chlorine before drinking"

	// treated water by straining through cloth
	gen ph_wtr_trt_cloth = hv237c
	replace ph_wtr_trt_cloth = 0 if hv237c>=8
	label val ph_wtr_trt_cloth yesno
	label var ph_wtr_trt_cloth	"Treated water by straining through cloth before drinking"

	// treated water by ceramic, sand, or other filter
	gen ph_wtr_trt_filt = hv237d
	replace ph_wtr_trt_filt = 0 if hv237d>=8
	label val ph_wtr_trt_filt yesno
	label var ph_wtr_trt_filt	"Treated water by ceramic, sand, or other filter before drinking"

	// treated water by solar disinfection
	gen ph_wtr_trt_solar = hv237e
	replace ph_wtr_trt_solar = 0 if hv237e>=8
	label val ph_wtr_trt_solar yesno
	label var ph_wtr_trt_solar	"Treated water by solar disinfection"

	// treated water by letting stand and settle
	gen ph_wtr_trt_stand = hv237f
	replace ph_wtr_trt_stand = 0 if hv237f>=8
	label val ph_wtr_trt_stand yesno
	label var ph_wtr_trt_stand	"Treated water by letting stand and settle before drinking"

	// treated water by other means
	gen ph_wtr_trt_other = 0
	replace ph_wtr_trt_other = 1 if hv237g==1 | hv237h==1 | hv237j==1 | hv237k==1 | hv237x==1
	label val ph_wtr_trt_other yesno
	label var ph_wtr_trt_other	"Treated water by other means before drinking"

	// any treatment or none
	gen ph_wtr_trt_none = 0
	replace ph_wtr_trt_none = 1 if hv237!=0
	label define trt_none 0 "No treatment" 1 "Some treatment" 
	label val ph_wtr_trt_none trt_none
	label var ph_wtr_trt_none	"Did not treat water before drinking"
	
	// using appropriate treatment
	/*--------------------------------------------------------------------------
	NOTE: Appropriate water treatment includes: boil, add bleach or chlorine, 
	ceramic, sand or other filter, and solar disinfection.
	--------------------------------------------------------------------------*/
	gen ph_wtr_trt_appr = hv237a
	replace ph_wtr_trt_appr = 1 if hv237b==1 | hv237d==1 | hv237e==1 
	label val ph_wtr_trt_appr yesno
	label var ph_wtr_trt_appr	"Appropriately treated water before drinking"

// generate water source indicator 
	/*--------------------------------------------------------------------------
	NOTE: this cycles through ALL country specific coding and ends around line 2252. 
	--------------------------------------------------------------------------*/
		
	// recode country specific responses to standard codes
	if hv000=="AF7" & hv007==1394 {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="AL7" & hv007<=2018 {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if  hv000=="AM4" & hv007==2000 {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="AM4" & hv007==2005 {
	recode hv201 ///
	21 = 32 ///
	32 = 41 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="AM6" {
	recode hv201 ///
	14 = 11 ///
	, gen (ph_wtr_source)
	}
	if hv000=="AM7" & inrange(hv007,2015,2016) {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="AO7" & inrange(hv007,2015,2016) {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	33 = 21 ///
	63 = 62 ///
	, gen (ph_wtr_source)
	}
	* same recode for 3 surveys that all have hv000=BD3 (BDHR31, BDHR3A, and BDHR41). BDHR41 does not have category 41 for hv201
	if hv000=="BD3" {
	recode hv201 ///
	22 = 32 ///
	31 = 43 ///
	32 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BD4" {
	recode hv201 ///
	22 = 32 ///
	23 = 31 ///
	24 = 32 ///
	41 = 43 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BF2" {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	51 = 61 ///
	61 = 71 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BF3" {
	recode hv201 ///
	12 = 11 ///
	21 = 30 ///
	22 = 30 ///
	23 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	51 = 71 ///
	61 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BF4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BF7" & inrange(hv007,2017,2018) {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BJ3"  {
	recode hv201 ///
	22 = 31 ///
	23 = 32 ///
	31 = 41 ///
	32 = 43 ///
	41 = 51 ///
	42 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BJ4"  {
	recode hv201 ///
	22 = 31 ///
	23 = 32 ///
	41 = 40 ///
	42 = 43 ///
	52 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BJ5"  {
	recode hv201 ///
	52 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BJ7" & inrange(hv007,2017,2018) {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BO3" & hv007<95  {
	recode hv201 ///
	12 = 13 ///
	13 = 14 ///
	21 = 30 ///
	32 = 43 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BO3" & hv007==98   {
	recode hv201 ///
	13 = 15 ///
	21 = 30 ///
	31 = 43 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BO4"  {
	recode hv201 ///
	13 = 15 ///
	22 = 32 ///
	42 = 43 ///
	45 = 14 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BO5"  {
	recode hv201 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BR2"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BR3"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="BU7" & inrange(hv007,2016,2017) {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="CD5"  {
	recode hv201 ///
	32 = 31 ///
	33 = 31 ///
	34 = 32 ///
	35 = 32 ///
	36 = 32 ///
	44 = 43 ///
	45 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="CF3"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	23 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="CG5" & hv007==2005 {
	recode hv201 ///
	13 = 14 ///
	21 = 32 ///
	22 = 32 ///
	32 = 31 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	
	* same recode for two surveys: CIHR35 and CIHR3A both are hv000=CI3. Only survey CIHR35 has categories 51 and 61 for hv201
	if hv000=="CI3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="CI5"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	42 = 40 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="CM2"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	22 = 32 ///
	31 = 43 ///
	41 = 51 ///
	51 = 96 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="CM3"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	22 = 32 ///
	31 = 43 ///
	41 = 51 ///
	51 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="CM4"  {
	recode hv201 ///
	13 = 14 ///
	14 = 15 ///
	22 = 32 ///
	31 = 32 ///
	41 = 43 ///
	42 = 41 ///
	, gen (ph_wtr_source)
	}
	if hv000=="CM7" & inrange(hv007,2018,2019) {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	92 = 73 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: COHR22 and COHR31. Only survey COHR22 has category 71 for hv201
	if hv000=="CO2" | hv000=="CO3" {
	recode hv201 ///
	12 = 11 ///
	13 = 15 ///
	14 = 13 ///
	21 = 30 ///
	31 = 43 ///
	41 = 51 ///
	51 = 61 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="CO4" & hv007<=2000 {
	recode hv201 ///
	12 = 11 ///
	21 = 30 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
* same recode for two surveys COHR53, COHR61, COHR72
	if hv000=="CO4" & hv007>=2004 |  inrange(hv000, "CO5", "CO7")  {
	recode hv201 ///
	12 = 11 ///
	22 = 32 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys COHR61 and COHR72
	if hv000=="CO5" | (hv000=="CO7" & inrange(hv007,2015,2016))   {
	recode hv201 ///
	12 = 11 ///
	22 = 32 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: DRHR21 and DRHR32. Only survey DRHR21 has category 71 for hv201
	if hv000=="DR2" | (hv000=="DR3" & hv007==96) {
	recode hv201 ///
	21 = 30 ///
	31 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="DR3" & hv007==99  {
	recode hv201 ///
	22 = 32 ///
	23 = 32 ///
	25 = 31 ///
	26 = 31 ///
	31 = 40 ///
	32 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="DR4" & hv007==2002  {
	recode hv201 ///
	21 = 30 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: EGHR21 and EGHR33. Only survey EGHR21 has category 71 for hv201
	if hv000=="EG2" | hv000=="EG3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 43 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: EGHR42 and EGHR4A. Both surveys are hv000=EG4. Only survey EGHR42 has category 72 for hv201
	if hv000=="EG4" & hv007<2005  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	23 = 30 ///
	31 = 30 ///
	32 = 30 ///
	33 = 30 ///
	41 = 43 ///
	72 = 65 ///
	, gen (ph_wtr_source)
	}
	* this is survey EGHR51 which is also hv000=EG4 as the previous two surveys. Use hv007=2005 to specify 
	if hv000=="EG4" & hv007==2005  {
	recode hv201 ///
	21 = 32 ///
	22 = 42 ///
	31 = 21 ///
	32 = 31 ///
	33 = 41 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ET4" & hv007==1992  {
	recode hv201 ///
	13 = 15 ///
	21 = 32 ///
	22 = 42 ///
	23 = 31 ///
	24 = 41 ///
	31 = 43 ///
	32 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ET4" & hv007==1997  {
	recode hv201 ///
	13 = 15 ///
	21 = 32 ///
	22 = 42 ///
	31 = 21 ///
	32 = 31 ///
	33 = 41 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
* same recode for ETHR71 and ETHR81
	if hv000=="ET7" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GA3"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 31 ///
	22 = 31 ///
	23 = 32 ///
	24 = 32 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	41 = 51 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GA6"  {
	recode hv201 ///
	32 = 31 ///
	33 = 32 ///
	34 = 32 ///
	, gen (ph_wtr_source)
	}
	*same recode for two surveys: GHHR31 and GHHR41. Only survey GHHR41 has category 61 for hv201
	if hv000=="GH2" | hv000=="GH3"   {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	23 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	35 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GH4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	81 = 73 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: GHHR5A and GHHR72
	if hv000=="GH5" | hv000=="GH6" {
	recode hv201 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: GHHR7B and GHHR82. Both are hv000=GH7
	if hv000=="GH7" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GM7"  {
	recode  hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GN3"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	31 = 41 ///
	32 = 42 ///
	33 = 43 ///
	34 = 43 ///
	35 = 43 ///
	41 = 51 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GN4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	34 = 21 ///
	44 = 43 ///
	45 = 43 ///
	, gen (ph_wtr_source)
	}
* same recode for GNHR71 and GNHR81. Both are hv000==GN7
	if hv000=="GN7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GU3" & hv007==95  {
	recode hv201 ///
	11 = 13 ///
	12 = 13 ///
	13 = 15 ///
	22 = 30 ///
	32 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GU3" & hv007>98   {
	recode hv201 ///
	11 = 13 ///
	12 = 13 ///
	13 = 15 ///
	14 = 13 ///
	21 = 30 ///
	31 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GU6"  {
	recode hv201 ///
	14 = 15 ///
	31 = 13 ///
	32 = 30 ///
	41 = 43 ///
	42 = 43 ///
	43 = 41 ///
	44 = 42 ///
	, gen (ph_wtr_source)
	}
	if hv000=="GY4"  {
	recode hv201 ///
	22 = 32 ///
	81 = 43 ///
	91 = 62 ///
	92 = 72 ///
	, gen (ph_wtr_source)
	}
	if hv000=="HN5"  {
	recode hv201 ///
	13 = 11 ///
	14 = 11 ///
	21 = 32 ///
	31 = 30 ///
	32 = 21 ///
	41 = 43 ///
	62 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="HN6"  {
	recode hv201 ///
	13 = 11 ///
	14 = 11 ///
	31 = 30 ///
	44 = 13 ///
	45 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="HT3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	35 = 43 ///
	41 = 51 ///
	51 = 61 ///
	52 = 65 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="HT4"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 30 ///
	32 = 30 ///
	44 = 43 ///
	45 = 43 ///
	81 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="HT5"  {
	recode hv201 ///
	63 = 43 ///
	64 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="HT6"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	32 = 31 ///
	33 = 32 ///
	34 = 32 ///
	72 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="HT7" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="IA2"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	23 = 21 ///
	24 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="IA3"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	22 = 21 ///
	23 = 30 ///
	24 = 32 ///
	25 = 31 ///
	26 = 32 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if hv000=="IA7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	92 = 72 ///
	, gen (ph_wtr_source)
	}	
	if hv000=="ID2"  {
	recode hv201 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	41 = 51 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: IDHR31 (1994) and IDHR3A (1997). Both are hv000=ID3
	if hv000=="ID3"  {
	recode hv201 ///
	22 = 31 ///
	23 = 32 ///
	31 = 41 ///
	32 = 42 ///
	33 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ID4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: IDHR51 (2002) and IDHR63 (2007). Only IDHR63 has category 81 for hv201
	if hv000=="ID5" | hv000=="ID6" {
	recode hv201 ///
	33 = 32 ///
	34 = 32 ///
	35 = 32 ///
	36 = 31 ///
	37 = 31 ///
	38 = 31 ///
	44 = 40 ///
	45 = 43 ///
	46 = 43 ///
	47 = 43 ///
	81 = 72 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ID7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="JO3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="JO4"  {
	recode hv201 ///
	41 = 40 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KE2"  {
	recode hv201 ///
	12 = 13 ///
	22 = 32 ///
	31 = 43 ///
	32 = 43 ///
	41 = 51 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KE3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 43 ///
	32 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KE4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	32 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KE6" {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KE7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KH4"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 32 ///
	22 = 32 ///
	32 = 31 ///
	33 = 21 ///
	34 = 31 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KH8"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KK3" & hv007==95  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KK3" & hv007==99  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	24 = 43 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KM3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	41 = 51 ///
	42 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="KY3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if hv000=="LB7" & hv007==2016  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="LB7" & inrange(hv007,2019,2020)  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	92 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="LS4"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	34 = 31 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="LS5"  {
	recode hv201 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MA2"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MA4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MB4"  {
	recode hv201 ///
	63 = 62 ///
	81 = 41 ///
	82 = 42 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MD2"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MD3"  {
	recode hv201 ///
	22 = 30 ///
	23 = 32 ///
	24 = 21 ///
	25 = 30 ///
	26 = 32 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MD4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	*same recode for two surveys: MDHR7- (2016) and MDHR8- (2021), both have hv000==MD7
	if hv000=="MD7"   {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ML3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	23 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ML4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	*same recode for two surveys: MLHR7- (2018) and MDHR8- (2021), both have hv000==ML7
	if hv000=="ML7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MM7"  {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MR7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MV5"  {
	recode hv201 ///
	52 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MV7"  {
	recode hv201 ///
	14 = 13 ///
	52 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MW2"  {
	recode hv201 ///
	12 = 13 ///
	13 = 12 ///
	22 = 30 ///
	23 = 31 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MW4" & hv007==2000  {
	recode hv201 ///
	21 = 32 ///
	32 = 21 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MW4" & inrange(hv007,2004,2005)  {
	recode hv201 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	*same recode for two surveys: MWHR7A (2015) and MWHR7I (2017). Both are hv000=MW7
	if hv000=="MW7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MZ3"  {
	recode hv201 ///
	12 = 14 ///
	21 = 30 ///
	22 = 30 ///
	23 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MZ4"  {
	recode hv201 ///
	11 = 12 ///
	12 = 14 ///
	21 = 12 ///
	22 = 14 ///
	23 = 32 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: MZHR62 (2011) and MZHR71 (2015). Both are hv000=MZ6
	if hv000=="MZ6"  {
	recode hv201 ///
	33 = 21 ///
	, gen (ph_wtr_source)
	}
	if hv000=="MZ7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NC3"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	31 = 43 ///
	32 = 40 ///
	41 = 51 ///
	61 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NC4"  {
	recode hv201 ///
	31 = 30 ///
	32 = 30 ///
	41 = 43 ///
	42 = 40 ///
	61 = 72 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NG3"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	52 = 61 ///
	61 = 71 ///
	71 = 21 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NG4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	62 = 65 ///
	, gen (ph_wtr_source)
	}
	* same recode for three surveys: NGHR61 (2010), NGHR6A (2013), and NGHR71 (2015). All are hv000=NG6
	if hv000=="NG6"  {
	recode hv201 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NG7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	92 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NG8"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NI2"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NI3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 31 ///
	23 = 32 ///
	24 = 32 ///
	25 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	41 = 51 ///
	51 = 62 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NI5"  {
	recode hv201 ///
	41 = 40 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NI6"  {
	recode hv201 ///
	63 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NI7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NM2"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	35 = 21 ///
	41 = 51 ///
	51 = 61 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NM4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 42 ///
	31 = 21 ///
	32 = 31 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NP3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	23 = 21 ///
	24 = 21 ///
	31 = 40 ///
	32 = 43 ///
	34 = 41 ///
	, gen (ph_wtr_source)
	}
	if hv000=="NP4"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 21 ///
	32 = 21 ///
	41 = 40 ///
	42 = 43 ///
	43 = 41 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: NPHR51 (2006) and NPHR61 (2011). 
	if hv000=="NP5" | hv000=="NP6" {
	recode hv201 ///
	44 = 41 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: NPHR7H (2016) and NPHR81 (2022). 
	if hv000=="NP7" | hv000=="NP8" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="PE2"  {
	recode hv201 ///
	12 = 13 ///
	13 = 12 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	41 = 51 ///
	51 = 61 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="PE3"  {
	recode hv201 ///
	12 = 11 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	41 = 51 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	* same recode for six surveys: PEHR41,51,5I,61,6A,and 6I. The last three surveys all are hv000=PE6. Only survey PEHR41 has category 42 for hv201
	if hv000=="PE4" | hv000=="PE5"  | hv000=="PE6" {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="PG7" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="PH2"  {
	recode hv201 ///
	12 = 13 ///
	21 = 11 ///
	22 = 12 ///
	23 = 30 ///
	24 = 30 ///
	31 = 32 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="PH3"  {
	recode hv201 ///
	21 = 31 ///
	22 = 32 ///
	31 = 41 ///
	32 = 42 ///
	33 = 43 ///
	34 = 43 ///
	35 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="PH4"  {
	recode hv201 ///
	21 = 32 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: PHHR52 (2008) and PHHR61 (2013). Only survey PHHR52 has categories 72 and 73 fpr hv201 
	if hv000=="PH5" |  hv000=="PH6" {
	recode hv201 ///
	33 = 32 ///
	72 = 14 ///
	73 = 14 ///
	, gen (ph_wtr_source)
	}

	* same recode for two surveys: PHHR71 (2017) and PHHR81 (2022)	
	if hv000=="PH7" | hv000=="PH8"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="PK2"  {
	recode hv201 ///
	12 = 13 ///
	13 = 12 ///
	23 = 21 ///
	24 = 32 ///
	32 = 43 ///
	41 = 51 ///
	51 = 61 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: PKHR52 (2006) and PKHR61 (2012). Only survey PKHR61 has category 63 for hv201
	if hv000=="PK5" |hv000=="PK6"  {
	recode hv201 ///
	22 = 21 ///
	63 = 72 ///
	, gen (ph_wtr_source)
	}
	if hv000=="PK7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	63 = 72 ///
	, gen (ph_wtr_source)
	}
	if hv000=="RW2"  {
	recode hv201 ///
	12 = 13 ///
	13 = 12 ///
	23 = 21 ///
	24 = 21 ///
	31 = 40 ///
	32 = 43 ///
	41 = 51 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	* same recode for three surveys: RWHR41, RWHR53, and RWHR5A. Survey RWHR41 does not have category 21 for hv201
	if hv000=="RW4" | hv000=="RW5"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: RWHR7- (2017) and RWHR8- (2019-20), both have hv000=="RW7"
	if hv000=="RW7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: SLHR73 (2016) and SLHR7A- (2019), both have hv000=="SL7"
	if hv000=="SL7" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: SNHR21 (1992-93) and SNHR32 (1997). Both are hv000=SN2. Only survey SNHR32 has categories 34, 41, and 61 for variable hv201
	if hv000=="SN2"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	23 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: SNHR4A (2005) and SNHR51 (2006).
	if hv000=="SN4" | hv000=="SN5" {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	* same recode for four surveys: SNHR7Z (2017), SNHR80 (2018), SNHR8B (2019), SNHR8I (2020-21), all are hv000==SN7
	if hv000=="SN7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TD3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 32 ///
	22 = 31 ///
	23 = 32 ///
	24 = 31 ///
	31 = 43 ///
	32 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TD4"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 32 ///
	22 = 32 ///
	32 = 31 ///
	44 = 43 ///
	52 = 65 ///
	53 = 65 ///
	54 = 65 ///
	55 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TG3"  {
	recode hv201 ///
	12 = 14 ///
	22 = 31 ///
	23 = 32 ///
	31 = 41 ///
	32 = 43 ///
	41 = 51 ///
	42 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TG6"  {
	recode hv201 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TG7" & hv007==2017  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TJ7" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TL7" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TR2"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	42 = 43 ///
	51 = 61 ///
	61 = 71 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TR3"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 41 ///
	32 = 40 ///
	33 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	71 = 72 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TR4"  {
	recode hv201 ///
	11 = 12 ///
	21 = 30 ///
	31 = 30 ///
	42 = 40 ///
	81 = 72 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TR7"  {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: TZHR21 (1991-92) and TZHR3A (1996). Only survey TZHR21 has categories 51 and 71 for hv201
	if hv000=="TZ2" | (hv000=="TZ3" & hv007==96) {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	35 = 43 ///
	41 = 51 ///
	51 = 61 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TZ3" & hv007==99  {
	recode hv201 ///
	21 = 32 ///
	22 = 31 ///
	23 = 21 ///
	31 = 41 ///
	32 = 42 ///
	33 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TZ5" & inrange(hv007,2003,2004)  {
	recode hv201 ///
	21 = 32 ///
	32 = 21 ///
	44 = 43 ///
	45 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TZ4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	24 = 32 ///
	32 = 31 ///
	33 = 31 ///
	34 = 21 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	62 = 65 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TZ5" & inrange(hv007,2007,2008) {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	24 = 32 ///
	32 = 31 ///
	33 = 31 ///
	34 = 21 ///
	42 = 43 ///
	44 = 43 ///
	62 = 65 ///
	91 = 62 ///
	, gen (ph_wtr_source)
	}
	if hv000=="TZ5" & inrange(hv007,2009,2010) {
	recode hv201 ///
	22 = 32 ///
	23 = 32 ///
	24 = 32 ///
	25 = 32 ///
	33 = 31 ///
	34 = 31 ///
	35 = 31 ///
	36 = 21 ///
	45 = 40 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys: TZHR7B (2015-16) and TZHR7I (2017), both are hv000=TZ7
	if hv000=="TZ7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="UG3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	23 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 41 ///
	41 = 51 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="UG4"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	32 = 31 ///
	33 = 21 ///
	34 = 21 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	81 = 41 ///
	, gen (ph_wtr_source)
	}
	if hv000=="UG5" & hv007==2006  {
	recode hv201 ///
	22 = 21 ///
	23 = 21 ///
	33 = 31 ///
	34 = 31 ///
	35 = 32 ///
	36 = 32 ///
	44 = 43 ///
	45 = 43 ///
	46 = 43 ///
	91 = 41 ///
	, gen (ph_wtr_source)
	}
	if hv000=="UG5" & inrange(hv007,2009,2010) {
	recode hv201 ///
	22 = 32 ///
	23 = 32 ///
	33 = 31 ///
	34 = 31 ///
	35 = 21 ///
	44 = 43 ///
	45 = 43 ///
	46 = 43 ///
	, gen (ph_wtr_source)
	}
	* same recode can be used for two surveys: UGHR61 and UGHR6A. Only survey UGHR61 has categories 22,23,33,34,35,36,44,45 and 46 and only survey UGHR6A has category 81 for hv201. Both surveys are hv000=UG6 and both are also hv007=2011
	if hv000=="UG6" & hv007==2011  {
	recode hv201 ///
	22 = 21 ///
	23 = 21 ///
	33 = 31 ///
	34 = 31 ///
	35 = 32 ///
	36 = 32 ///
	44 = 43 ///
	45 = 43 ///
	46 = 43 ///
	81 = 41 ///
	, gen (ph_wtr_source)
	}
	if hv000=="UG6" & inrange(hv007,2014,2015) {
	recode hv201 ///
	22 = 21 ///
	44 = 41 ///
	63 = 62 ///
	, gen (ph_wtr_source)
	}
	if  hv000=="UG7" & hv007==2016 {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	63 = 62 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="UG7" & inrange(hv007,2018,2019) {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	63 = 62 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if hv000=="UZ3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	* same recode for two surveys VNHR31 and VNHR41. Both are hv000=VNT. Only survey VNHR31 has category 61 for hv201
	if hv000=="VNT" {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="VN5"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	31 = 30 ///
	32 = 30 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="YE2"  {
	recode hv201 ///
	13 = 11 ///
	14 = 12 ///
	23 = 21 ///
	24 = 32 ///
	32 = 43 ///
	35 = 51 ///
	36 = 43 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="YE6"  {
	recode hv201 ///
	14 = 72 ///
	15 = 72 ///
	32 = 30 ///
	43 = 40 ///
	44 = 41 ///
	45 = 43 ///
	72 = 62 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZA3"  {
	recode hv201 ///
	31 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZA7" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZM2"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	51 = 61 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZM3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 32 ///
	23 = 32 ///
	24 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZM4"  {
	recode hv201 ///
	22 = 32 ///
	23 = 32 ///
	24 = 32 ///
	32 = 31 ///
	33 = 31 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZM7"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZW3"  {
	recode hv201 ///
	12 = 13 ///
	21 = 31 ///
	22 = 32 ///
	23 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZW4"  {
	recode hv201 ///
	21 = 31 ///
	22 = 32 ///
	23 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZW5"  {
	recode hv201 ///
	71 = 62 ///
	81 = 43 ///
	, gen (ph_wtr_source)
	}
	if hv000=="ZW7" {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	
	
	// for all other countries
	cap gen ph_wtr_source = hv201

	
	// special code for Cambodia 
	/*--------------------------------------------------------------------------
	Cambodia collects data on water source for both the wet season and dry season.
	
	Below, an indicator is created for the dry season and water source and a wet
	season water source. For all following indicators that use water source, only
	the water source that corresponds to the season of interview (hv006 = month 
	of interview) is used.
	
	e.g. If the interview took place during the dry season, then the dry season 
	water source is used for standard indicators in this code.
	
	Bracket on 2276 hides code for Cambodia specific section
	--------------------------------------------------------------------------*/
	
	if hv000=="KH4" {
	recode sh22b ///
	11 = 12 ///
	12 = 13 ///
	21 = 32 ///
	22 = 32 ///
	32 = 31 ///
	33 = 21 ///
	34 = 31 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source_wet)

	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 32 ///
	22 = 32 ///
	32 = 31 ///
	33 = 21 ///
	34 = 31 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source_dry)
	}

	if hv000=="KH5" & inrange(hv007,2005,2006) {
	gen ph_wtr_source_wet = hv201w
	gen ph_wtr_source_dry = hv201d
	}

	if hv000=="KH5" & inrange(hv007,2010,2011)  {
	gen ph_wtr_source_wet = sh104b
	gen ph_wtr_source_dry = sh102	
	}
	
	if hv000=="KH6"  {
	gen ph_wtr_source_wet = sh104b	
	gen ph_wtr_source_dry = sh102
	}
	
	//check if interview took place in dry season or wet season
	if hv000=="KH4" | hv000=="KH5" | hv000=="KH6"  {
	recode hv006 (11/12 2/4=1 "dry season") (5/10=2 "rainy season"), gen(interview_season)
	replace ph_wtr_source = ph_wtr_source_dry if interview_season==1 //dry season interviews
	replace ph_wtr_source = ph_wtr_source_wet if interview_season==2 //rainy season interviews
	}

************************************************************************************************

	// create water source labels
	recode ph_wtr_source . = 99

	cap label define ph_wtr_source 	11   "piped into dwelling"				///
									12	 "piped to yard/plot" 				///
									13	 "public tap/standpipe" 			///
									14	 "piped to neighbor"				///
									15	 "piped outside of yard/lot" 		///
									21	 "tube well or borehole" 			///
									30	 "well - protection unspecified" 	///
									31	 "protected well" 					///
									32	 "unprotected well"					///
									40	 "spring - protection unspecified" 	///
									41	 "protected spring" 				///
									42	 "unprotected spring"				///
									43	 "surface water (river/dam/lake/pond/stream/canal/irrigation channel)" ///
									51	 "rainwater"						///
									61	 "tanker truck"						///
									62	 "cart with small tank, cistern, drums/cans" ///
									65	 "purchased water"					///
									71	 "bottled water"					///
									72	 "purified water, filtration plant" ///
									73	 "satchet water"					///
									96	 "other"							///			
									99	 "missing"			
	cap label values ph_wtr_source ph_wtr_source
	cap label var ph_wtr_source "Source of drinking water"
	*/

// improved water source
recode ph_wtr_source (11/15 21 31 41 51 61/73 = 1 "improved water") (30 32 40 42 43 96 = 0 "unimproved/surface water") (99=99 "missing"), gen(ph_wtr_improve)
label var ph_wtr_improve "Improved Water Source"

// time to obtain drinking water (round trip)
recode hv204 (0 996 = 0 "water on premises") ( 1/30 = 1 "30 minutes or less") (31/900 = 2 "More than 30 minutes") (998/max = 3 "don't know"), gen(ph_wtr_time)
label var ph_wtr_time "Round trip time to obtain water"
	
// basic or limited water source
gen ph_wtr_basic = .
replace ph_wtr_basic = 1 if ph_wtr_improve==1 & ph_wtr_time<=1
replace ph_wtr_basic = 2 if ph_wtr_improve==1 & ph_wtr_time>1
replace ph_wtr_basic = 3 if ph_wtr_improve==0
label define wtr_basic_label	1	 "basic water services"	2 "limited water services" 3 "unimproved water source"
label values ph_wtr_basic wtr_basic_label
label var ph_wtr_basic "Basic or limited water services"

// availability of piped water or water from tubewell
cap clonevar ph_wtr_avail = hv201a
cap label var ph_wtr_avail "Availability of water among those using piped water or water from tube well or borehole"

