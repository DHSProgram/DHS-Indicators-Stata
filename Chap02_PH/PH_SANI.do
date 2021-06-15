/*********************************************************************
program: 			SANI.do
Purpose: 			creates variable for binary improved sanitation according to JSTOR standard 
Data inputs: 		hr or pr file
Data outputs:		none
Author of do file:	03/15/2018	Courtney Allen
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

VARIABLES CREATED:
	
	ph_sani_type		"Type of sanitation facility"
	ph_sani_improve		"Access to improved sanitation"
	ph_sani_basic		"Basic or limited sanitation facility"
	ph_sani_location	"Location of sanitation facility"
		

NOTE: 
STANDARD CATEGORIES FOR WATER SOURCE BY IMPROVED/UNIMPROVED
	1-improved
		11	 flush - to piped sewer system
		12	 flush - to septic tank
		13	 flush - to pit latrine
		14	 flush - to somewhere else
		15   flush - don't know where
		16	 flush - unspecified
		20   pit latrine - improved but shared
		21	 pit latrine - ventilated improved pit (vip)
		22	 pit latrine - with slab
		41	 composting toilet
		51	 other improved
	2-unimproved 
		23	 pit latrine - without slab / open pit
		42	 bucket ph_sani_type
		43	 hanging toilet/latrine
		96	 other
	3-open defecation
		31	 no facility/bush/field/river/sea/lake

------------------------------------------------------------------------------*/

// generate type of sanitation facility  
	/*--------------------------------------------------------------------------
	NOTE: this cycles through ALL country specific coding and ends around 
	line 1491.
	Close bracket around line 59 to hide country specific code.
	--------------------------------------------------------------------------*/

	// check if "hr" or "pr" file is being used
	foreach x in hr pr {

	//recode country specific responses to standard codes
	if filename=="af`x'71"  {
	recode hv205 ///
	43 = 23 ///
	44 = 51 ///
	, gen (ph_sani_type)
	}
	if filename=="am`x'42"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="am`x'54"  {
	recode hv205 ///
	41 = 42 ///
	, gen (ph_sani_type)
	}
	if filename=="am`x'61"  {
	recode hv205 ///
	44 = 15 ///
	, gen (ph_sani_type)
	}
	if filename=="ao`x'71"  {
	recode hv205 ///
	13 = 14 ///
	14 = 11 ///
	15 = 12 ///
	16 = 14 ///
	17 = 11 ///
	18 = 12 ///
	19 = 14 ///
	22 = 21 ///
	24 = 21 ///
	25 = 21 ///
	26 = 23 ///
	27 = 21 ///
	28 = 21 ///
	29 = 23 ///
	42 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="bd`x'31"  {
	recode hv205 ///
	11 = 12 ///
	21 = 22 ///
	22 = 23 ///
	24 = 43 ///
	, gen (ph_sani_type)
	}
	if filename=="bd`x'3a"  {
	recode hv205 ///
	11 = 12 ///
	21 = 22 ///
	22 = 23 ///
	24 = 43 ///
	, gen (ph_sani_type)
	}
	if filename=="bd`x'41"  {
	recode hv205 ///
	11 = 12 ///
	21 = 22 ///
	22 = 23 ///
	24 = 43 ///
	, gen (ph_sani_type)
	}
	if filename=="bd`x'4j"  {
	recode hv205 ///
	11 = 12 ///
	21 = 22 ///
	22 = 23 ///
	24 = 43 ///
	, gen (ph_sani_type)
	}
	if filename=="bf`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="bf`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="bf`x'43"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="bj`x'31"  {
	recode hv205 ///
	21 = 22 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="bj`x'41"  {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="bj`x'51"  {
	recode hv205 ///
	15 = 14 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="bo`x'31"  {
	recode hv205 ///
	11 = 15 ///
	13 = 12 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="bo`x'3b"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="bo`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="br`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="br`x'31"  {
	recode hv205 ///
	12 = 14 ///
	13 = 14 ///
	21 = 22 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="bu`x'6a"  {
	recode hv205 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="cd`x'51"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	23 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="cf`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="cg`x'51"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="cg`x'5a"  {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="ci`x'35"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	23 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ci`x'3a"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ci`x'51"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="cm`x'22"  {
	recode hv205 ///
	11 = 15 ///
	21 = 42 ///
	22 = 23 ///
	32 = 31 ///
	33 = 31 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="cm`x'31"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="cm`x'44"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="co`x'22"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="co`x'31"  {
	recode hv205 ///
	12 = 13 ///
	13 = 14 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="co`x'41"  {
	recode hv205 ///
	12 = 13 ///
	13 = 14 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="co`x'53"  {
	recode hv205 ///
	13 = 14 ///
	21 = 23 ///
	22 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="co`x'61"  {
	recode hv205 ///
	13 = 14 ///
	21 = 23 ///
	22 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="co`x'72"  {
	recode hv205 ///
	13 = 14 ///
	21 = 23 ///
	22 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="dr`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="dr`x'32"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 22 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="dr`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="dr`x'4b"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 22 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="dr`x'52"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 22 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="dr`x'5a"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 22 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="eg`x'21"  {
	recode hv205 ///
	13 = 15 ///
	14 = 15 ///
	21 = 23 ///
	22 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="eg`x'33"  {
	recode hv205 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="eg`x'42"  {
	recode hv205 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="eg`x'4a"  {
	recode hv205 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="eg`x'51"  {
	recode hv205 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	32 = 42 ///
	, gen (ph_sani_type)
	}
	if filename=="eg`x'5a"  {
	recode hv205 ///
	12 = 15 ///
	13 = 15 ///
	, gen (ph_sani_type)
	}
	if filename=="eg`x'61"  {
	recode hv205 ///
	16 = 12 ///
	17 = 11 ///
	18 = 11 ///
	, gen (ph_sani_type)
	}
	if filename=="et`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="et`x'51"  {
	recode hv205 ///
	24 = 41 ///
	25 = 42 ///
	26 = 43 ///
	, gen (ph_sani_type)
	}
	if filename=="ga`x'41"  {
	recode hv205 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="gh`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="gh`x'41"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	23 = 42 ///
	, gen (ph_sani_type)
	}
	if filename=="gh`x'4b"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	32 = 42 ///
	, gen (ph_sani_type)
	}
	if filename=="gh`x'82"  {
	recode hv205 ///
	16 = 51 ///
	, gen (ph_sani_type)
	}
	if filename=="gn`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	31 = 23 ///
	41 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="gn`x'52"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	23 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="gu`x'34"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="gu`x'41"  {
	recode hv205 ///
	12 = 11 ///
	13 = 12 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="gu`x'71"  {
	recode hv205 ///
	13 = 14 ///
	14 = 15 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="gy`x'51"  {
	recode hv205 ///
	61 = 43 ///
	, gen (ph_sani_type)
	}
	if filename=="hn`x'52"  {
	recode hv205 ///
	13 = 15 ///
	21 = 51 ///
	22 = 41 ///
	24 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="hn`x'62"  {
	recode hv205 ///
	13 = 15 ///
	21 = 51 ///
	22 = 41 ///
	24 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="ht`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	23 = 21 ///
	24 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ht`x'42"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ht`x'52"  {
	recode hv205 ///
	51 = 42 ///
	61 = 43 ///
	, gen (ph_sani_type)
	}
	if filename=="ht`x'61"  {
	recode hv205 ///
	44 = 43 ///
	45 = 51 ///
	, gen (ph_sani_type)
	}
	if filename=="ia`x'23"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	22 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="ia`x'42"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="ia`x'52"  {
	recode hv205 ///
	44 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="ia`x'74"  {
	recode hv205 ///
	44 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="id`x'42"  {
	recode hv205 ///
	11 = 12 ///
	12 = 14 ///
	21 = 15 ///
	41 = 23 ///
	51 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="id`x'51"  {
	recode hv205 ///
	11 = 12 ///
	12 = 14 ///
	13 = 15 ///
	21 = 23 ///
	32 = 31 ///
	33 = 31 ///
	34 = 31 ///
	35 = 31 ///
	36 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="id`x'63"  {
	recode hv205 ///
	11 = 12 ///
	12 = 14 ///
	13 = 15 ///
	21 = 23 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="id`x'71"  {
	recode hv205 ///
	16 = 14 ///
	17 = 15 ///
	, gen (ph_sani_type)
	}
	if filename=="jo`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="jo`x'42"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="jo`x'51"  {
	recode hv205 ///
	12 = 13 ///
	13 = 14 ///
	, gen (ph_sani_type)
	}
	if filename=="jo`x'61"  {
	recode hv205 ///
	12 = 13 ///
	13 = 14 ///
	, gen (ph_sani_type)
	}
	if filename=="ke`x'33"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="ke`x'3a"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ke`x'42"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="kh`x'42"  {
	recode hv205 ///
	11 = 12 ///
	12 = 14 ///
	21 = 22 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="kk`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="kk`x'42"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="km`x'32"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ky`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ls`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ma`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="ma`x'43"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	22 = 23 ///
	32 = 42 ///
	, gen (ph_sani_type)
	}
	if filename=="mb`x'53"  {
	recode hv205 ///
	31 = 41 ///
	41 = 42 ///
	, gen (ph_sani_type)
	}
	if filename=="md`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	23 = 22 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="md`x'31"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="md`x'42"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="md`x'51"  {
	recode hv205 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="md`x'61"  {
	recode hv205 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="md`x'6a"  {
	recode hv205 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="ml`x'32"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="ml`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ml`x'53"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="mw`x'22"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="mw`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="mw`x'4e"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="mw`x'61"  {
	recode hv205 ///
	11 = 15 ///
	, gen (ph_sani_type)
	}
	if filename=="mz`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="mz`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 31 ///
	30 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="mz`x'62"  {
	recode hv205 ///
	16 = 15 ///
	, gen (ph_sani_type)
	}
	if filename=="mz`x'71"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="nc`x'31"  {
	recode hv205 ///
	15 = 14 ///
	21 = 23 ///
	22 = 21 ///
	24 = 43 ///
	30 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="nc`x'41"  {
	recode hv205 ///
	15 = 14 ///
	21 = 23 ///
	22 = 21 ///
	30 = 31 ///
	32 = 43 ///
	, gen (ph_sani_type)
	}
	if filename=="ng`x'41"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	23 = 42 ///
	, gen (ph_sani_type)
	}
	if filename=="ng`x'4b"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="ni`x'22"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="ni`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="ni`x'51"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="nm`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	23 = 42 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="nm`x'41"  {
	recode hv205 ///
	11 = 15 ///
	12 = 22 ///
	21 = 23 ///
	22 = 21 ///
	23 = 42 ///
	, gen (ph_sani_type)
	}
	if filename=="np`x'31"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	31 = 42 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="np`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="pe`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	23 = 22 ///
	24 = 22 ///
	25 = 23 ///
	26 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="pe`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	14 = 15 ///
	21 = 23 ///
	22 = 23 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="pe`x'41"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	14 = 15 ///
	21 = 23 ///
	22 = 23 ///
	30 = 31 ///
	41 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="pe`x'51"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	22 = 12 ///
	24 = 31 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="pe`x'5i"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	22 = 12 ///
	24 = 31 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="pe`x'61"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	22 = 12 ///
	24 = 31 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="pe`x'6a"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	22 = 12 ///
	24 = 31 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="pe`x'6i"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	22 = 12 ///
	24 = 31 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="ph`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	24 = 43 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="ph`x'3b"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 13 ///
	22 = 23 ///
	30 = 31 ///
	31 = 43 ///
	, gen (ph_sani_type)
	}
	if filename=="ph`x'41"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 13 ///
	22 = 23 ///
	31 = 43 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="ph`x'61"  {
	recode hv205 ///
	51 = 15 ///
	, gen (ph_sani_type)
	}
	if filename=="ph`x'71"  {
	recode hv205 ///
	71 = 15 ///
	, gen (ph_sani_type)
	}
	if filename=="pk`x'21"  {
	recode hv205 ///
	13 = 15 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="pk`x'52"  {
	recode hv205 ///
	13 = 14 ///
	14 = 15 ///
	, gen (ph_sani_type)
	}
	if filename=="rw`x'21"  {
	recode hv205 ///
	13 = 15 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="rw`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="rw`x'53"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="rw`x'5a"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="sl`x'51"  {
	recode hv205 ///
	71 = 31 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'32"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'4a"  {
	recode hv205 ///
	11 = 15 ///
	12 = 14 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'61"  {
	recode hv205 ///
	24 = 22 ///
	26 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'6d"  {
	recode hv205 ///
	24 = 22 ///
	26 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'6r"  {
	recode hv205 ///
	24 = 22 ///
	26 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'70"  {
	recode hv205 ///
	24 = 22 ///
	26 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'7h"  {
	recode hv205 ///
	24 = 22 ///
	26 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'7i"  {
	recode hv205 ///
	24 = 22 ///
	26 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="sn`x'g0"  {
	recode hv205 ///
	24 = 22 ///
	26 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="sz`x'51"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="td`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="td`x'41"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="td`x'71"  {
	recode hv205 ///
	11 = 12 ///
	12 = 13 ///
	13 = 14 ///
	14 = 15 ///
	, gen (ph_sani_type)
	}
	if filename=="tg`x'31"  {
	recode hv205 ///
	21 = 22 ///
	22 = 23 ///
	23 = 12 ///
	24 = 22 ///
	, gen (ph_sani_type)
	}
	if filename=="tr`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 13 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="tr`x'41"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 13 ///
	, gen (ph_sani_type)
	}
	if filename=="tr`x'4a"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 13 ///
	, gen (ph_sani_type)
	}
	if filename=="tz`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="tz`x'3a"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="tz`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="tz`x'4a"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="tz`x'4i"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="tz`x'51"  {
	recode hv205 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="tz`x'6a"  {
	recode hv205 ///
	24 = 22 ///
	, gen (ph_sani_type)
	}
	if filename=="tz`x'7b"  {
	recode hv205 ///
	24 = 22 ///
	, gen (ph_sani_type)
	}
	if filename=="tz`x'7i"  {
	recode hv205 ///
	24 = 22 ///
	, gen (ph_sani_type)
	}
	if filename=="ug`x'33"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ug`x'41"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="ug`x'52"  {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	25 = 22 ///
	, gen (ph_sani_type)
	}
	if filename=="ug`x'5a"  {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	25 = 22 ///
	, gen (ph_sani_type)
	}
	if filename=="ug`x'61"  {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	25 = 22 ///
	44 = 51 ///
	, gen (ph_sani_type)
	}
	if filename=="ug`x'72"  {
	recode hv205 ///
	24 = 22 ///
	25 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="uz`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="vn`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="vn`x'41"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="vn`x'52"  {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="ye`x'21"  {
	recode hv205 ///
	13 = 11 ///
	14 = 15 ///
	24 = 14 ///
	25 = 23 ///
	26 = 15 ///
	31 = 42 ///
	32 = 31 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="ye`x'61"  {
	recode hv205 ///
	24 = 23 ///
	25 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="za`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 42 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if filename=="za`x'71"  {
	recode hv205 ///
	23 = 21 ///
	44 = 51 ///
	, gen (ph_sani_type)
	}
	if filename=="zm`x'21"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if filename=="zm`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="zm`x'42"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="zw`x'31"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="zw`x'42"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if filename=="zw`x'52"  {
	recode hv205 ///
	91 = 41 ///
	92 = 42 ///
	, gen (ph_sani_type)
	}

} //close bracket for hiding country specific code
	
	// for all other countries
	cap gen ph_sani_type = hv205

	********************************************************************************
	// label type of sanitation
	recode ph_sani_type . = 99

	label define ph_sani_type	11	 "flush - to piped sewer system" ///
								12	 "flush - to septic tank"		///
								13	 "flush - to pit latrine"		///
								14	 "flush - to somewhere else"	///
								15	 "flush - don't know where/unspecified"			///
								21	 "pit latrine - ventilated improved pit (vip)"	///
								22	 "pit latrine - with slab"		///
								23	 "pit latrine - without slab / open pit" 		///
								31	 "no facility/bush/field/river/sea/lake" 		///
								41	 "composting toilet"			///
								42	 "bucket toilet"				///
								43	 "hanging toilet/latrine"		///
								51	 "other improved"				///
								96	 "other"						///
								99 	 "missing"
	label values ph_sani_type ph_sani_type
	label var ph_sani_type "Type of sanitation"
	
// create improved sanitation indicator
	recode ph_sani_type (11/13 15 21 22 41 51 = 1 "improved sanitation") (14 23 42 43 96 = 2 "unimproved sanitation") (31 = 3 "open defecation") (99=.), gen(ph_sani_improve)
	label var ph_sani_improve "Improved sanitation"
	*cap replace ph_sani_improve = 2 if hv225==1 //shared toilet is not improved. Note: this is used in the old definition and no longer required. 


// create basic or limited sanitation services indicator
	cap gen ph_sani_basic = .
	cap replace ph_sani_basic = 1 if ph_sani_improve==1 & hv225==0
	cap replace ph_sani_basic = 2 if ph_sani_improve==1 & hv225==1
	cap replace ph_sani_basic = 3 if ph_sani_improve==2
	cap replace ph_sani_basic = 4 if ph_sani_improve==3
	cap label define basic_label	1	 "basic sanitation"	2 "limited sanitation" 3 "unimproved sanitation" 4 "open defecation"
	cap label values ph_sani_basic basic_label
	cap label var ph_sani_basic "Basic or limited sanitation"

// create sanitation facility location indicator (this variable may sometimes be country specific - e.g. sh109a in some Ghana survyes)
	cap clonevar ph_sani_location = hv238a
	cap label var ph_sani_location	"Location of sanitation facility"

