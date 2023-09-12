/*********************************************************************
program: 			SANI.do
Purpose: 			creates variable for binary improved sanitation according to JSTOR standard 
Data inputs: 		hr or pr file
Data outputs:		none
Author of do file:	03/15/2018	Courtney Allen
Date last modified: 07/12/2023	Courtney Allen -  update countries for codeshare project
Note:				These indicators can also be computed using the HR or PR file.
					If you want to produce estimates for households, use the HR file.
					If you want to produce estimates for the de jure population, 
					use the PR file and select for dejure household memebers using
					hv102==1. Please see the Guide to DHS Statistics. 
					
					09/30/2022 Shireen Assaf to use hv000 and hv007 instead of file names. This alternative will not be effected by changes in data file versions. 
*****************************************************************************************************/

/*------------------------------------------------------------------------------
This do file can be run on any loop of countries. Code should be same for pr or hr files.

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
	NOTE: this cycles through ALL country specific coding and ends around line 1098.
	--------------------------------------------------------------------------*/

	//recode country specific responses to standard codes
	if hv000=="AF7" {
	recode hv205 ///
	43 = 23 ///
	44 = 51 ///
	, gen (ph_sani_type)
	}
	if hv000=="AM4" & hv007==2000 {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="AM4" & hv007==2005  {
	recode hv205 ///
	41 = 42 ///
	, gen (ph_sani_type)
	}
	if hv000=="AM6"  {
	recode hv205 ///
	44 = 15 ///
	, gen (ph_sani_type)
	}
	if hv000=="AO7"  {
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
	* same recode for 4 surveys: three that all have hv000=BD3 (BDHR31, BDHR3A, and BDHR41) and one that is BD4
	if hv000=="BD3" | hv000=="BD4" {
	recode hv205 ///
	11 = 12 ///
	21 = 22 ///
	22 = 23 ///
	24 = 43 ///
	, gen (ph_sani_type)
	}
	* same recode for 3 surveys: BFHR21, BFHR31, and BFHR43. BFHR31 and BFHR43 do not have a 41 category for hv205 and BFHR43 does not have a 12 category. 
	if hv000=="BF2" | hv000=="BF3" | hv000=="BF4" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="BJ3"  {
	recode hv205 ///
	21 = 22 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="BJ4"  {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="BJ5"  {
	recode hv205 ///
	15 = 14 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="BO3" & hv007<95 {
	recode hv205 ///
	11 = 15 ///
	13 = 12 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="BO3" & hv007==98  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="BO4"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="BR2"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="BR3"  {
	recode hv205 ///
	12 = 14 ///
	13 = 14 ///
	21 = 22 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="BU6" & inrange(hv007,2012,2013) {
	recode hv205 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="CD5"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	23 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="CF3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="CG5" & hv007==2005 {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	} 
	if hv000=="CG5" & hv007==2009 {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	}
	if hv000=="CI3" & hv007==94  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	23 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="CI3" & hv007>97 {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="CI5"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="CM2"  {
	recode hv205 ///
	11 = 15 ///
	21 = 42 ///
	22 = 23 ///
	32 = 31 ///
	33 = 31 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="CM3"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="CM4"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="CO2"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="CO3"  {
	recode hv205 ///
	12 = 13 ///
	13 = 14 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="CO4" & hv007==2000 {
	recode hv205 ///
	12 = 13 ///
	13 = 14 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="CO4" & hv007>=2004 {
	recode hv205 ///
	13 = 14 ///
	21 = 23 ///
	22 = 31 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys COHR61 and COHR72
	if hv000=="CO5" |  (hv000=="CO7" & hv007>=2015)   {
	recode hv205 ///
	13 = 14 ///
	21 = 23 ///
	22 = 31 ///
	, gen (ph_sani_type)
	}
	if hv000=="DR2"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="DR3" & hv007==96 {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 22 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="DR3" & hv007==99 {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	* same recode for 3 surveys: DRHR4B, DRHR52, and DRHR5A
	if hv000=="DR4" | hv000=="DR5" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 22 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="EG2"  {
	recode hv205 ///
	13 = 15 ///
	14 = 15 ///
	21 = 23 ///
	22 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	* same recode for 4 surveys: EGHR33, EGHR42, EGHR4A, and EGHR51. Only EGHR51 has category 32 for hv205
	if hv000=="EG3" | hv000=="EG4" {
	recode hv205 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	32 = 42 ///
	, gen (ph_sani_type)
	}
	if hv000=="EG5"  {
	recode hv205 ///
	12 = 15 ///
	13 = 15 ///
	, gen (ph_sani_type)
	}
	if hv000=="EG6"  {
	recode hv205 ///
	16 = 12 ///
	17 = 11 ///
	18 = 11 ///
	, gen (ph_sani_type)
	}
	if hv000=="ET4" & hv007==1992 {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="ET4" & hv007==1997  {
	recode hv205 ///
	24 = 41 ///
	25 = 42 ///
	26 = 43 ///
	, gen (ph_sani_type)
	}
	if hv000=="GA3"  {
	recode hv205 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	*same recode for three surveys: GHHR31, GHHR41, and GHHR4B. Only GHHR4B has category 32 for hv205 and only GHHR41 has category 23. 
	if hv000=="GH2" | hv000=="GH3" | hv000=="GH4" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	23 = 42 ///
	32 = 42 ///
	, gen (ph_sani_type)
	}
	if hv000=="GH7" & hv007==2019 {
	recode hv205 ///
	16 = 51 ///
	, gen (ph_sani_type)
	}
	if hv000=="GN3"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	31 = 23 ///
	41 = 31 ///
	, gen (ph_sani_type)
	}
	if hv000=="GN4"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	23 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="GU3" & hv007==95  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="GU3" & hv007>98 {
	recode hv205 ///
	12 = 11 ///
	13 = 12 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="GU6"  {
	recode hv205 ///
	13 = 14 ///
	14 = 15 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="GY4"  {
	recode hv205 ///
	61 = 43 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys HNHR52 and HNHR62
	if hv000=="HN5" | hv000=="HN6" {
	recode hv205 ///
	13 = 15 ///
	21 = 51 ///
	22 = 41 ///
	24 = 31 ///
	, gen (ph_sani_type)
	}
	if hv000=="HT3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	23 = 21 ///
	24 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="HT4"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="HT5"  {
	recode hv205 ///
	51 = 42 ///
	61 = 43 ///
	, gen (ph_sani_type)
	}
	if hv000=="HT6"  {
	recode hv205 ///
	44 = 43 ///
	45 = 51 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: IAHR23 and IAHR42. Only IAHR23 has category 41 for hv205
	if hv000=="IA2" | hv000=="IA3" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	22 = 23 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: IAHR52 (2005-2006), IAHR74 (2015-16), and IAHR7E (2019-21)
	if hv000=="IA5" | hv000=="IA6" | hv000=="IA7" {
	recode hv205 ///
	44 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="ID4"  {
	recode hv205 ///
	11 = 12 ///
	12 = 14 ///
	21 = 15 ///
	41 = 23 ///
	51 = 31 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: IDHR51 and IDHR63. Only IDHR51 has categories 33 to 36 for hv205
	if hv000=="ID5" | hv000=="ID6" {
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
	if hv000=="ID7" & hv007==2017 {
	recode hv205 ///
	16 = 14 ///
	17 = 15 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: JOHR31 and JOHR42. Only JOHR42 has category 22 for hv205
	if hv000=="JO3" | hv000=="JO4" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: JOHR51 and JOHR61 both are hv000=JO5
	if hv000=="JO5"  {
	recode hv205 ///
	12 = 13 ///
	13 = 14 ///
	, gen (ph_sani_type)
	}
	* same recode for three surveys: KEHR33, KEHR3A, and KEHR42. Only KEHR33 has category 41 for hv205 and there is no category 12 in KEHR42
	if hv000=="KE2" | hv000=="KE3" | hv000=="KE4" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="KH4"  {
	recode hv205 ///
	11 = 12 ///
	12 = 14 ///
	21 = 22 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys KKHR31 and KKHR42, both are hv000=KK3. Only KKHR31 has categories 12 and 22 for hv205
	if hv000=="KK3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="KM3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="KY3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="LS4"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="MA2"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="MA4"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	22 = 23 ///
	32 = 42 ///
	, gen (ph_sani_type)
	}
	if hv000=="MB4"  {
	recode hv205 ///
	31 = 41 ///
	41 = 42 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: MDHR21 and MDHR31. Only MDHR21 has categories 12, 23, and 41 for hv205
	if hv000=="MD2" | hv000=="MD3" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	23 = 22 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="MD4"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="MD5"  {
	recode hv205 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: MDHR61 and MDHR6A both are hv000=MD6
	if hv000=="MD6"  {
	recode hv205 ///
	23 = 22 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="ML3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: MLHR41 and MLHR53
	if hv000=="ML4" | (hv000=="ML5" & hv007==2006) {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	* same recode for 3 surveys: MWHR22, MWHR41, and MWHR4E. Only MWHR22 has categories 12 and 41 for hv205
	if hv000=="MW2" | hv000=="MW4"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="MW5"  {
	recode hv205 ///
	11 = 15 ///
	, gen (ph_sani_type)
	}
	if hv000=="MZ3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="MZ4"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 31 ///
	30 = 31 ///
	, gen (ph_sani_type)
	}
	if hv000=="MZ6" & hv007==2011  {
	recode hv205 ///
	16 = 15 ///
	, gen (ph_sani_type)
	}
	if hv000=="MZ6" & hv007==2015 {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: NCHR31 and NCHR41. NCHR31 does not have category 32 for hv205 and NCHR41 does not have category 24 for hv205
	if hv000=="NC3" | hv000=="NC4" {
	recode hv205 ///
	15 = 14 ///
	21 = 23 ///
	22 = 21 ///
	24 = 43 ///
	30 = 31 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: NGHR41 and NGHR4B. NGHR41 does not have category 32 for hv205 and NGHR4B does not have categories 12 and 23
	if hv000=="NG3" | hv000=="NG4" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	23 = 42 ///
	, gen (ph_sani_type)
	}
	if hv000=="NI2"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	13 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="NI3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="NI5"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="NM2"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	23 = 42 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="NM4"  {
	recode hv205 ///
	11 = 15 ///
	12 = 22 ///
	21 = 23 ///
	22 = 21 ///
	23 = 42 ///
	, gen (ph_sani_type)
	}
	if hv000=="NP3"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	31 = 42 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if hv000=="NP4"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="NP8"  {
	recode hv205 ///
	44 = 42 ///
	45 = 51 ///
	, gen (ph_sani_type)
	}
	if hv000=="PE2"  {
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
	if hv000=="PE3"  {
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
	if hv000=="PE4"  {
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
	* same recode for five surveys: PEHR51, PEHR5I, PEHR61, PEHR61, and PEHR6I
	if hv000=="PE5" | hv000=="PE6" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	22 = 12 ///
	24 = 31 ///
	32 = 31 ///
	, gen (ph_sani_type)
	}
	if hv000=="PH2"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 23 ///
	24 = 43 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: PHHR3B and PHHR41. Only PHHR3B has category 30 for hv205 and only PHHR41 has category 32
	if hv000=="PH3" | hv000=="PH4" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 13 ///
	22 = 23 ///
	30 = 31 ///
	31 = 43 ///
	, gen (ph_sani_type)
	}
	if hv000=="PH6"  {
	recode hv205 ///
	51 = 15 ///
	, gen (ph_sani_type)
	}
	if hv000=="PH7"  {
	recode hv205 ///
	71 = 15 ///
	, gen (ph_sani_type)
	}
	if hv000=="PK2"  {
	recode hv205 ///
	13 = 15 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="PK5"  {
	recode hv205 ///
	13 = 14 ///
	14 = 15 ///
	, gen (ph_sani_type)
	}
	if hv000=="RW2"  {
	recode hv205 ///
	13 = 15 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	* same recode for three surveys: RWHR41, RWHR53, and RWHR5A
	if hv000=="RW4" | hv000=="RW5"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="SL5"  {
	recode hv205 ///
	71 = 31 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: SNHR21 and SNHR32 both are hv000=SN2 . Only survey SNHR32 has category 41 for hv205
	if hv000=="SN2"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	if hv000=="SN4"  {
	recode hv205 ///
	11 = 15 ///
	12 = 14 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	* same recode for 6 surveys: SNHR61, SNHR6D, SNHR6R, SNHR7H, SNHR7I, and SNHRG0. All are hv000=SN6. 
	if hv000=="SN6" {
	recode hv205 ///
	24 = 22 ///
	26 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="SZ5"  {
	recode hv205 ///
	11 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: TDHR31 and TDHR41
	if hv000=="TD3" | hv000=="TD4" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="TD6"  {
	recode hv205 ///
	11 = 12 ///
	12 = 13 ///
	13 = 14 ///
	14 = 15 ///
	, gen (ph_sani_type)
	}
	if hv000=="TG3"  {
	recode hv205 ///
	21 = 22 ///
	22 = 23 ///
	23 = 12 ///
	24 = 22 ///
	, gen (ph_sani_type)
	}
	if hv000=="TR2"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 13 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: TRHR41 and TRHR4A. Only survey TRHR41 has category 12 for hv205
	if hv000=="TR3" | hv000=="TR4" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 13 ///
	, gen (ph_sani_type)
	}
	* same recode for 5 surveys: TZHR21, TZHR3A, TZHR41, TZHR4A, and TZHR4I. Only surveys TZHR21 and TZHR3A have category 12 for hv205
	if hv000=="TZ2" | hv000=="TZ3" | hv000=="TZ4" | (hv000=="TZ5" & inrange(hv007,2003,2004)) {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="TZ5" & inrange(hv007,2007,2008) {
	recode hv205 ///
	24 = 23 ///
	, gen (ph_sani_type)
	}
	* same recode for three surveys: TZHR6A, TZHR7B, and TZHR7I
	if hv000=="TZ6" | hv000=="TZ7" {
	recode hv205 ///
	24 = 22 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: UGHR33 and UGHR41. Only UGHR33 has category 12 for hv205
	if hv000=="UG3" | hv000=="UG4" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: UGHR52 and UGHR5A.
	if hv000=="UG5"  {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	25 = 22 ///
	, gen (ph_sani_type)
	}
	* There are multiple surveys with country code UG6 in the year 2011 (UGHR6A and UGHR61), so need to specify maximum month of interview. UGHR61 had interviews up until hv006 (month) = 12. UGHR6A has no survey specific coding necessary.
	if hv000=="UG6" & hv007==2011 {
		qui summ hv006
		if r(max)==12 {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	23 = 22 ///
	24 = 23 ///
	25 = 22 ///
	41 = 51 ///
	, gen (ph_sani_type)
	} 
	if (hv000=="UG6" & inrange(hv007,2014,2015)) {
	recode hv205 ///
	24 = 22 ///
	25 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="UZ3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys VNHR31 and VNHR41. Both are hv000=VNT
	if hv000=="VNT" {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="VN5" {
	recode hv205 ///
	11 = 15 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="YE2" {
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
	if hv000=="YE6"  {
	recode hv205 ///
	24 = 23 ///
	25 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="ZA3"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 42 ///
	22 = 23 ///
	, gen (ph_sani_type)
	}
	if hv000=="ZA7" & hv007==2016 {
	recode hv205 ///
	23 = 21 ///
	44 = 51 ///
	, gen (ph_sani_type)
	}
	* same recode for three surveys: ZMHR21, ZMHR31, and ZMHR42. Only survey ZMHR21 has category 41 for hv025 and survey ZMHR42 does not have categories 41 or 12. 
	if hv000=="ZM2" | hv000=="ZM3" | hv000=="ZM4"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	41 = 96 ///
	, gen (ph_sani_type)
	}
	* same recode for two surveys: ZWHR31 and ZWHR42. Only survey ZWHR31 has category 12 for hv205. 
	if hv000=="ZW3" | hv000=="ZW4"  {
	recode hv205 ///
	11 = 15 ///
	12 = 15 ///
	21 = 23 ///
	22 = 21 ///
	, gen (ph_sani_type)
	}
	if hv000=="ZW5" {
	recode hv205 ///
	91 = 41 ///
	92 = 42 ///
	, gen (ph_sani_type)
	}

	* End of country specific codes
	
	********************************************************************************
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

