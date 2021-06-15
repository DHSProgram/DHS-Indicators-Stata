/*********************************************************************
Program: 			PH_WATER.do
Purpose: 			creates variable for binary improved water source according to JSTOR standard 
Data inputs: 		hr or pr file
Data outputs:		none
Author of do file:	04/08/2018	Courtney Allen
Date last modified: 09/04/2020	Courtney Allen - for codeshare project
Note:				These indicators can also be computed using the HR or PR file.
					If you want to produce estimates for households, use the HR file.
					If you want to produce estimates for the de jure population, 
					use the PR file and select for dejure household memebers using
					hv102==1. Please see the Guide to DHS Statistics.  
*****************************************************************************************************/

/*------------------------------------------------------------------------------
This do file can be run on any loop of countries indicating the dataset name 
with variable called filename. Code should be same for pr or hr files.

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
	NOTE: this cycles through ALL country specific coding and ends around 
	line 2252. 
	Close bracket around line 130 to hide country specific code.
	--------------------------------------------------------------------------*/
	
	// check if "hr" or "pr" file is being used
	foreach x in hr pr {
	
	// recode country specific responses to standard codes
	if filename=="af`x'71"  {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="al`x'71"  {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="am`x'42"  {
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
	if filename=="am`x'54"  {
	recode hv201 ///
	21 = 32 ///
	32 = 41 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="am`x'61"  {
	recode hv201 ///
	14 = 11 ///
	, gen (ph_wtr_source)
	}
	if filename=="am`x'72"  {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="ao`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	33 = 21 ///
	63 = 62 ///
	, gen (ph_wtr_source)
	}
	if filename=="bd`x'31"  {
	recode hv201 ///
	22 = 32 ///
	31 = 43 ///
	32 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="bd`x'3a"  {
	recode hv201 ///
	22 = 32 ///
	31 = 43 ///
	32 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="bd`x'41"  {
	recode hv201 ///
	22 = 32 ///
	31 = 43 ///
	32 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="bd`x'4j"  {
	recode hv201 ///
	22 = 32 ///
	23 = 31 ///
	24 = 32 ///
	41 = 43 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="bf`x'21"  {
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
	if filename=="bf`x'31"  {
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
	if filename=="bf`x'43"  {
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
	if filename=="bf`x'7a"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="bj`x'31"  {
	recode hv201 ///
	22 = 31 ///
	23 = 32 ///
	31 = 41 ///
	32 = 43 ///
	41 = 51 ///
	42 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="bj`x'41"  {
	recode hv201 ///
	22 = 31 ///
	23 = 32 ///
	41 = 40 ///
	42 = 43 ///
	52 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="bj`x'51"  {
	recode hv201 ///
	52 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="bj`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="bo`x'31"  {
	recode hv201 ///
	12 = 13 ///
	13 = 14 ///
	21 = 30 ///
	32 = 43 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if filename=="bo`x'3b"  {
	recode hv201 ///
	13 = 15 ///
	21 = 30 ///
	31 = 43 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if filename=="bo`x'41"  {
	recode hv201 ///
	13 = 15 ///
	22 = 32 ///
	42 = 43 ///
	45 = 14 ///
	, gen (ph_wtr_source)
	}
	if filename=="bo`x'51"  {
	recode hv201 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="br`x'21"  {
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
	if filename=="br`x'31"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if filename=="bu`x'70"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="bu`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="cd`x'51"  {
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
	if filename=="cf`x'31"  {
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
	if filename=="cg`x'51"  {
	recode hv201 ///
	13 = 14 ///
	21 = 32 ///
	22 = 32 ///
	32 = 31 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="ci`x'35"  {
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
	if filename=="ci`x'3a"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="ci`x'51"  {
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
	if filename=="cm`x'22"  {
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
	if filename=="cm`x'31"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	22 = 32 ///
	31 = 43 ///
	41 = 51 ///
	51 = 65 ///
	, gen (ph_wtr_source)
	}
	if filename=="cm`x'44"  {
	recode hv201 ///
	13 = 14 ///
	14 = 15 ///
	22 = 32 ///
	31 = 32 ///
	41 = 43 ///
	42 = 41 ///
	, gen (ph_wtr_source)
	}
	if filename=="cm`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	92 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="co`x'22"  {
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
	if filename=="co`x'31"  {
	recode hv201 ///
	12 = 11 ///
	13 = 15 ///
	14 = 13 ///
	21 = 30 ///
	31 = 43 ///
	41 = 51 ///
	51 = 61 ///
	, gen (ph_wtr_source)
	}
	if filename=="co`x'41"  {
	recode hv201 ///
	12 = 11 ///
	21 = 30 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="co`x'53"  {
	recode hv201 ///
	12 = 11 ///
	22 = 32 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="co`x'61"  {
	recode hv201 ///
	12 = 11 ///
	22 = 32 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="co`x'72"  {
	recode hv201 ///
	12 = 11 ///
	22 = 32 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="dr`x'21"  {
	recode hv201 ///
	21 = 30 ///
	31 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if filename=="dr`x'32"  {
	recode hv201 ///
	21 = 30 ///
	31 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if filename=="dr`x'41"  {
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
	if filename=="dr`x'4b"  {
	recode hv201 ///
	21 = 30 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="eg`x'21"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 43 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if filename=="eg`x'33"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="eg`x'42"  {
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
	if filename=="eg`x'4a"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	23 = 30 ///
	31 = 30 ///
	32 = 30 ///
	33 = 30 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="eg`x'51"  {
	recode hv201 ///
	21 = 32 ///
	22 = 42 ///
	31 = 21 ///
	32 = 31 ///
	33 = 41 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="et`x'41"  {
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
	if filename=="et`x'51"  {
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
	if filename=="et`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="ga`x'41"  {
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
	if filename=="ga`x'61"  {
	recode hv201 ///
	32 = 31 ///
	33 = 32 ///
	34 = 32 ///
	, gen (ph_wtr_source)
	}
	if filename=="gh`x'31"  {
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
	, gen (ph_wtr_source)
	}
	if filename=="gh`x'41"  {
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
	if filename=="gh`x'4b"  {
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
	if filename=="gh`x'5a"  {
	recode hv201 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="gh`x'72"  {
	recode hv201 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="gh`x'7b"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="gh`x'82"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="gn`x'41"  {
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
	if filename=="gn`x'52"  {
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
	if filename=="gn`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="gu`x'34"  {
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
	if filename=="gu`x'41"  {
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
	if filename=="gu`x'71"  {
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
	if filename=="gy`x'51"  {
	recode hv201 ///
	22 = 32 ///
	81 = 43 ///
	91 = 62 ///
	92 = 72 ///
	, gen (ph_wtr_source)
	}
	if filename=="hn`x'52"  {
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
	if filename=="hn`x'62"  {
	recode hv201 ///
	13 = 11 ///
	14 = 11 ///
	31 = 30 ///
	44 = 13 ///
	45 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="ht`x'31"  {
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
	if filename=="ht`x'42"  {
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
	if filename=="ht`x'52"  {
	recode hv201 ///
	63 = 43 ///
	64 = 65 ///
	, gen (ph_wtr_source)
	}
	if filename=="ht`x'61"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	32 = 31 ///
	33 = 32 ///
	34 = 32 ///
	72 = 65 ///
	, gen (ph_wtr_source)
	}
	if filename=="ht`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 65 ///
	, gen (ph_wtr_source)
	}
	if filename=="ia`x'23"  {
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
	if filename=="ia`x'42"  {
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
	if filename=="id`x'21"  {
	recode hv201 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	41 = 51 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if filename=="id`x'31"  {
	recode hv201 ///
	22 = 31 ///
	23 = 32 ///
	31 = 41 ///
	32 = 42 ///
	33 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="id`x'3a"  {
	recode hv201 ///
	22 = 31 ///
	23 = 32 ///
	31 = 41 ///
	32 = 42 ///
	33 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="id`x'42"  {
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
	if filename=="id`x'51"  {
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
	, gen (ph_wtr_source)
	}
	if filename=="id`x'63"  {
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
	if filename=="id`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 71 ///
	, gen (ph_wtr_source)
	}
	if filename=="jo`x'31"  {
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
	if filename=="jo`x'42"  {
	recode hv201 ///
	41 = 40 ///
	, gen (ph_wtr_source)
	}
	if filename=="ke`x'33"  {
	recode hv201 ///
	12 = 13 ///
	22 = 32 ///
	31 = 43 ///
	32 = 43 ///
	41 = 51 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if filename=="ke`x'3a"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 43 ///
	32 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="ke`x'42"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	32 = 31 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="ke`x'7a"  {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="kh`x'42"  {
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
	if filename=="kk`x'31"  {
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
	if filename=="kk`x'42"  {
	recode hv201 ///
	21 = 32 ///
	22 = 32 ///
	23 = 32 ///
	24 = 43 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if filename=="km`x'32"  {
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
	if filename=="ky`x'31"  {
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
	if filename=="lb`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="ls`x'41"  {
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
	if filename=="ls`x'61"  {
	recode hv201 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="ma`x'21"  {
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
	if filename=="ma`x'43"  {
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
	if filename=="mb`x'53"  {
	recode hv201 ///
	63 = 62 ///
	81 = 41 ///
	82 = 42 ///
	, gen (ph_wtr_source)
	}
	if filename=="md`x'21"  {
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
	if filename=="md`x'31"  {
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
	if filename=="md`x'42"  {
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
	if filename=="md`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="ml`x'32"  {
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
	if filename=="ml`x'41"  {
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
	if filename=="ml`x'7a"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="mm`x'71"  {
	recode hv201 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="mv`x'52"  {
	recode hv201 ///
	52 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="mv`x'71"  {
	recode hv201 ///
	14 = 13 ///
	52 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="mw`x'22"  {
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
	if filename=="mw`x'41"  {
	recode hv201 ///
	21 = 32 ///
	32 = 21 ///
	41 = 40 ///
	42 = 43 ///
	44 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="mw`x'4e"  {
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
	if filename=="mw`x'7a"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="mw`x'7i"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="mz`x'31"  {
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
	if filename=="mz`x'41"  {
	recode hv201 ///
	11 = 12 ///
	12 = 14 ///
	21 = 12 ///
	22 = 14 ///
	23 = 32 ///
	41 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="mz`x'62"  {
	recode hv201 ///
	33 = 21 ///
	, gen (ph_wtr_source)
	}
	if filename=="mz`x'71"  {
	recode hv201 ///
	33 = 21 ///
	, gen (ph_wtr_source)
	}
	if filename=="mz`x'7a"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="nc`x'31"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	31 = 43 ///
	32 = 40 ///
	41 = 51 ///
	61 = 65 ///
	, gen (ph_wtr_source)
	}
	if filename=="nc`x'41"  {
	recode hv201 ///
	31 = 30 ///
	32 = 30 ///
	41 = 43 ///
	42 = 40 ///
	61 = 72 ///
	, gen (ph_wtr_source)
	}
	if filename=="ng`x'41"  {
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
	if filename=="ng`x'4b"  {
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
	if filename=="ng`x'61"  {
	recode hv201 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="ng`x'6a"  {
	recode hv201 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="ng`x'71"  {
	recode hv201 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="ng`x'7a"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	92 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="ni`x'22"  {
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
	if filename=="ni`x'31"  {
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
	if filename=="ni`x'51"  {
	recode hv201 ///
	41 = 40 ///
	, gen (ph_wtr_source)
	}
	if filename=="ni`x'61"  {
	recode hv201 ///
	63 = 65 ///
	, gen (ph_wtr_source)
	}
	if filename=="nm`x'21"  {
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
	if filename=="nm`x'41"  {
	recode hv201 ///
	21 = 32 ///
	22 = 42 ///
	31 = 21 ///
	32 = 31 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="np`x'31"  {
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
	if filename=="np`x'41"  {
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
	if filename=="np`x'51"  {
	recode hv201 ///
	44 = 41 ///
	, gen (ph_wtr_source)
	}
	if filename=="np`x'61"  {
	recode hv201 ///
	44 = 41 ///
	, gen (ph_wtr_source)
	}
	if filename=="np`x'7h"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="pe`x'21"  {
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
	if filename=="pe`x'31"  {
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
	if filename=="pe`x'41"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	41 = 40 ///
	42 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="pe`x'51"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	41 = 40 ///
	, gen (ph_wtr_source)
	}
	if filename=="pe`x'5i"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	41 = 40 ///
	, gen (ph_wtr_source)
	}
	if filename=="pe`x'61"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	41 = 40 ///
	, gen (ph_wtr_source)
	}
	if filename=="pe`x'6a"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	41 = 40 ///
	, gen (ph_wtr_source)
	}
	if filename=="pe`x'6i"  {
	recode hv201 ///
	21 = 30 ///
	22 = 30 ///
	41 = 40 ///
	, gen (ph_wtr_source)
	}
	if filename=="pg`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="ph`x'31"  {
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
	if filename=="ph`x'3b"  {
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
	if filename=="ph`x'41"  {
	recode hv201 ///
	21 = 32 ///
	, gen (ph_wtr_source)
	}
	if filename=="ph`x'52"  {
	recode hv201 ///
	33 = 32 ///
	72 = 14 ///
	73 = 14 ///
	, gen (ph_wtr_source)
	}
	if filename=="ph`x'61"  {
	recode hv201 ///
	33 = 32 ///
	, gen (ph_wtr_source)
	}
	if filename=="ph`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="pk`x'21"  {
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
	if filename=="pk`x'52"  {
	recode hv201 ///
	22 = 21 ///
	, gen (ph_wtr_source)
	}
	if filename=="pk`x'61"  {
	recode hv201 ///
	22 = 21 ///
	63 = 72 ///
	, gen (ph_wtr_source)
	}
	if filename=="pk`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	63 = 72 ///
	, gen (ph_wtr_source)
	}
	if filename=="rw`x'21"  {
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
	if filename=="rw`x'41"  {
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
	if filename=="rw`x'53"  {
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
	if filename=="rw`x'5a"  {
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
	if filename=="rw`x'7a"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="sl`x'72"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="sn`x'21"  {
	recode hv201 ///
	11 = 12 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	23 = 21 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	51 = 61 ///
	71 = 96 ///
	, gen (ph_wtr_source)
	}
	if filename=="sn`x'32"  {
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
	if filename=="sn`x'4a"  {
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
	if filename=="sn`x'51"  {
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
	if filename=="sn`x'7z"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="sn`x'80"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="td`x'31"  {
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
	if filename=="td`x'41"  {
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
	if filename=="tg`x'31"  {
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
	if filename=="tg`x'61"  {
	recode hv201 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="tg`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="tj`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="tl`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="tr`x'31"  {
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
	if filename=="tr`x'41"  {
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
	if filename=="tr`x'4a"  {
	recode hv201 ///
	11 = 12 ///
	21 = 30 ///
	31 = 30 ///
	42 = 40 ///
	81 = 72 ///
	, gen (ph_wtr_source)
	}
	if filename=="tz`x'21"  {
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
	if filename=="tz`x'3a"  {
	recode hv201 ///
	12 = 13 ///
	21 = 30 ///
	22 = 30 ///
	31 = 40 ///
	32 = 43 ///
	33 = 43 ///
	34 = 43 ///
	41 = 51 ///
	, gen (ph_wtr_source)
	}
	if filename=="tz`x'41"  {
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
	if filename=="tz`x'4a"  {
	recode hv201 ///
	21 = 32 ///
	32 = 21 ///
	44 = 43 ///
	45 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="tz`x'4i"  {
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
	if filename=="tz`x'51"  {
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
	if filename=="tz`x'63"  {
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
	if filename=="tz`x'7b"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="tz`x'7i"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="ug`x'33"  {
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
	if filename=="ug`x'41"  {
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
	if filename=="ug`x'52"  {
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
	if filename=="ug`x'5a"  {
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
	if filename=="ug`x'61"  {
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
	, gen (ph_wtr_source)
	}
	if filename=="ug`x'6a"  {
	recode hv201 ///
	81 = 41 ///
	, gen (ph_wtr_source)
	}
	if filename=="ug`x'72"  {
	recode hv201 ///
	22 = 21 ///
	44 = 41 ///
	63 = 62 ///
	, gen (ph_wtr_source)
	}
	if filename=="ug`x'7b"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	63 = 62 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="ug`x'7i"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	63 = 62 ///
	72 = 73 ///
	, gen (ph_wtr_source)
	}
	if filename=="uz`x'31"  {
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
	if filename=="vn`x'31"  {
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
	if filename=="vn`x'41"  {
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
	, gen (ph_wtr_source)
	}
	if filename=="vn`x'52"  {
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
	if filename=="ye`x'21"  {
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
	if filename=="ye`x'61"  {
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
	if filename=="za`x'31"  {
	recode hv201 ///
	31 = 43 ///
	41 = 51 ///
	51 = 61 ///
	61 = 71 ///
	, gen (ph_wtr_source)
	}
	if filename=="za`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="zm`x'21"  {
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
	if filename=="zm`x'31"  {
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
	if filename=="zm`x'42"  {
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
	if filename=="zm`x'71"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	if filename=="zw`x'31"  {
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
	if filename=="zw`x'42"  {
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
	if filename=="zw`x'52"  {
	recode hv201 ///
	71 = 62 ///
	81 = 43 ///
	, gen (ph_wtr_source)
	}
	if filename=="zw`x'72"  {
	recode hv201 ///
	13 = 14 ///
	14 = 13 ///
	, gen (ph_wtr_source)
	}
	} //bracket closes country specific section
	
	
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
{
	if filename=="kh`x'42"  {
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
	}
	if filename=="kh`x'42"  {
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

	if filename=="kh`x'51"  {
	gen ph_wtr_source_wet = hv201w
	}
	if filename=="kh`x'51"  {
	gen ph_wtr_source_dry = hv201d
	}
	if filename=="kh`x'61"  {
	gen ph_wtr_source_wet = sh104b
	}
	if filename=="kh`x'61"  {
	gen ph_wtr_source_dry = sh102
	}
	if filename=="kh`x'73"  {
	gen ph_wtr_source_wet = sh104b
	}
	if filename=="kh`x'73"  {
	gen ph_wtr_source_dry = sh102
	}

	//check if interview took place in dry season or wet season
	if filename=="kh`x'42" | filename=="kh`x'51" |filename=="kh`x'61" | filename=="kh`x'73" {
	recode hv006 (11/12 2/4=1 "dry season") (5/10=2 "rainy season"), gen(interview_season)
	replace ph_wtr_source = ph_wtr_source_dry if interview_season==1 //dry season interviews
	replace ph_wtr_source = ph_wtr_source_wet if interview_season==2 //rainy season interviews
	}
} //end of bracket that closes Cambodia specific section
	*/


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

