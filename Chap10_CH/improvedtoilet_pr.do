/*********************************************************************
program: 			improvedtoilet_allcountries.do
Purpose: 			creates variable for binary improved sanitation according to JSTOR standard 
Data inputs: 		PR dataset
Data outputs:		none
Author of do file:	03/15/2018	Courtney Allen
Date last modified: 04/16/2018	Courtney Allen - to use a filename var
					05/08/2018	Courtney Allen - to use new codes 10, 15, 16
					01/28/2019 	Courtney Allen - includes all new surveys
**********************************************************************/

/*
-This do file can be run on any loop of countries indicating the dataset name 
with `c'. 
-Code should be same for pr or pr files (must replace all 'pr' with 'pr').
-Generates two variables:
	Variable 1 - toilet (the standard DHS-7 recode for water source)
		10	 improved but shared toilet
		11	 flush - to piped sewer system
		12	 flush - to septic tank
		13	 flush - to pit latrine
		14	 flush - to somewhere else
		15	 flush - don't know where		
		16   flush - unspecified		
		20   pit latrine - improved but shared
		21	 pit latrine - ventilated improved pit (vip)
		22	 pit latrine - with slab
		23	 pit latrine - without slab / open pit
		31	 no facility/bush/field
		41	 composting toilet
		42	 bucket toilet
		43	 hanging toilet/latrine
		44	 river/stream/sea/pond/lake
		51	 other improved
		96	 other
							
	
	Variable 2 - toiletimprove (binary variable for improved/unimproved water source according to JMP) 
		0-unimproved 
			10   improved but shared toilet
			14	 flush - to somewhere else
			15   flush - don't know where
			20   pit latrine - improved but shared
			23	 pit latrine - without slab / open pit
			31	 no facility/bush/field
			42	 bucket toilet
			43	 hanging toilet/latrine
			44	 river/stream/sea/pond/lake
			96	 other
		1-improved
			11	 flush - to piped sewer system
			12	 flush - to septic tank
			13	 flush - to pit latrine
			16	 flush - unspecified
			21	 pit latrine - ventilated improved pit (vip)
			22	 pit latrine - with slab
			41	 composting toilet
			51	 other improved
*/

*create var to generate filename
*gen filename = substr("`c'",1,6)


********************************************************************************
*FIRST CREATE STANDARD CODES FOR ALL SURVEYS
********************************************************************************

if filename=="afpr70"  {
recode hv205 ///
43 = 23 ///
44 = 51 ///
, gen (toilet)
}
if filename=="alpr50"  {
gen toilet = hv205
}
if filename=="alpr71"  {
gen toilet = hv205
}
if filename=="ampr42"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 23 ///
, gen (toilet)
}
if filename=="ampr54"  {
recode hv205 ///
41 = 42 ///
, gen (toilet)
}
if filename=="ampr61"  {
recode hv205 ///
44 = 96 ///
, gen (toilet)
}
if filename=="ampr72"  {
gen toilet = hv205
}
if filename=="aopr51"  {
gen toilet = hv205
}
if filename=="aopr62"  {
recode hv205 ///
15 = 16 ///
, gen (toilet)
}
if filename=="aopr71"  {
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
26 = 43 ///
27 = 21 ///
28 = 21 ///
29 = 43 ///
42 = 23 ///
, gen (toilet)
}
if filename=="azpr52"  {
gen toilet = hv205
}
if filename=="bdpr31"  {
recode hv205 ///
11 = 12 ///
21 = 22 ///
22 = 23 ///
24 = 43 ///
, gen (toilet)
}
if filename=="bdpr3a"  {
recode hv205 ///
11 = 12 ///
21 = 22 ///
22 = 23 ///
24 = 43 ///
, gen (toilet)
}
if filename=="bdpr41"  {
recode hv205 ///
11 = 12 ///
21 = 22 ///
22 = 23 ///
24 = 43 ///
, gen (toilet)
}
if filename=="bdpr4j"  {
recode hv205 ///
11 = 12 ///
21 = 22 ///
22 = 23 ///
24 = 43 ///
, gen (toilet)
}
if filename=="bdpr51"  {
gen toilet = hv205
}
if filename=="bdpr61"  {
gen toilet = hv205
}
if filename=="bdpr72"  {
gen toilet = hv205
}
if filename=="bfpr21"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
41 = 96 ///
, gen (toilet)
}
if filename=="bfpr31"  {
recode hv205 ///
11 = 16 ///
12 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="bfpr43"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="bfpr62"  {
gen toilet = hv205
}
if filename=="bfpr70"  {
gen toilet = hv205
}
if filename=="bjpr31"  {
recode hv205 ///
21 = 22 ///
22 = 23 ///
, gen (toilet)
}
if filename=="bjpr41"  {
recode hv205 ///
11 = 16 ///
22 = 23 ///
, gen (toilet)
}
if filename=="bjpr51"  {
recode hv205 ///
15 = 14 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="bjpr61"  {
gen toilet = hv205
}
if filename=="bopr31"  {
recode hv205 ///
11 = 16 ///
13 = 12 ///
21 = 23 ///
, gen (toilet)
}
if filename=="bopr3b"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
13 = 16 ///
21 = 23 ///
22 = 23 ///
, gen (toilet)
}
if filename=="bopr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
, gen (toilet)
}
if filename=="bopr51"  {
gen toilet = hv205
}
if filename=="brpr21"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
41 = 96 ///
, gen (toilet)
}
if filename=="brpr31"  {
recode hv205 ///
12 = 14 ///
13 = 44 ///
21 = 22 ///
22 = 23 ///
, gen (toilet)
}
if filename=="bupr61"  {
gen toilet = hv205
}
if filename=="bupr6h"  {
recode hv205 ///
24 = 23 ///
, gen (toilet)
}
if filename=="bupr70"  {
gen toilet = hv205
}
if filename=="cdpr50"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
23 = 21 ///
, gen (toilet)
}
if filename=="cdpr61"  {
gen toilet = hv205
}
if filename=="cfpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="cgpr51"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="cgpr5h"  {
recode hv205 ///
11 = 16 ///
22 = 23 ///
, gen (toilet)
}
if filename=="cgpr60"  {
gen toilet = hv205
}
if filename=="cipr35"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 23 ///
23 = 21 ///
, gen (toilet)
}
if filename=="cipr3a"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="cipr50"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="cipr62"  {
gen toilet = hv205
}
if filename=="cmpr22"  {
recode hv205 ///
11 = 16 ///
21 = 42 ///
22 = 23 ///
32 = 44 ///
33 = 31 ///
41 = 96 ///
, gen (toilet)
}
if filename=="cmpr31"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="cmpr44"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="cmpr61"  {
gen toilet = hv205
}
if filename=="copr22"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
41 = 96 ///
, gen (toilet)
}
if filename=="copr31"  {
recode hv205 ///
12 = 13 ///
13 = 14 ///
21 = 23 ///
, gen (toilet)
}
if filename=="copr41"  {
recode hv205 ///
12 = 13 ///
13 = 14 ///
21 = 23 ///
, gen (toilet)
}
if filename=="copr53"  {
recode hv205 ///
12 = 13 ///
13 = 14 ///
21 = 23 ///
22 = 44 ///
, gen (toilet)
}
if filename=="copr61"  {
recode hv205 ///
12 = 13 ///
13 = 14 ///
21 = 23 ///
22 = 44 ///
, gen (toilet)
}
if filename=="copr72"  {
recode hv205 ///
12 = 13 ///
13 = 14 ///
21 = 23 ///
22 = 44 ///
, gen (toilet)
}
if filename=="drpr21"  {
recode hv205 ///
11 = 16 ///
12 = 16 ///
21 = 23 ///
22 = 23 ///
41 = 96 ///
, gen (toilet)
}
if filename=="drpr32"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 22 ///
22 = 23 ///
23 = 22 ///
24 = 23 ///
, gen (toilet)
}
if filename=="drpr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="drpr4a"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 23 ///
24 = 23 ///
, gen (toilet)
}
if filename=="drpr52"  {
recode hv205 ///
11 = 16 ///
12 = 16 ///
21 = 22 ///
22 = 23 ///
23 = 22 ///
24 = 23 ///
, gen (toilet)
}
if filename=="drpr5a"  {
recode hv205 ///
11 = 16 ///
12 = 16 ///
21 = 22 ///
22 = 23 ///
23 = 22 ///
24 = 23 ///
, gen (toilet)
}
if filename=="drpr61"  {
gen toilet = hv205
}
if filename=="drpr6a"  {
gen toilet = hv205
}
if filename=="egpr21"  {
recode hv205 ///
13 = 22 ///
14 = 22 ///
21 = 23 ///
22 = 23 ///
41 = 96 ///
, gen (toilet)
}
if filename=="egpr33"  {
recode hv205 ///
12 = 22 ///
13 = 22 ///
21 = 23 ///
, gen (toilet)
}
if filename=="egpr42"  {
recode hv205 ///
12 = 22 ///
13 = 22 ///
21 = 23 ///
, gen (toilet)
}
if filename=="egpr4a"  {
recode hv205 ///
12 = 22 ///
13 = 22 ///
21 = 23 ///
, gen (toilet)
}
if filename=="egpr51"  {
recode hv205 ///
13 = 22 ///
21 = 23 ///
32 = 42 ///
, gen (toilet)
}
if filename=="egpr5a"  {
recode hv205 ///
13 = 22 ///
, gen (toilet)
}
if filename=="egpr61"  {
recode hv205 ///
16 = 12 ///
17 = 11 ///
18 = 11 ///
, gen (toilet)
}
if filename=="etpr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="etpr51"  {
recode hv205 ///
24 = 41 ///
25 = 42 ///
26 = 43 ///
, gen (toilet)
}
if filename=="etpr61"  {
gen toilet = hv205
}
if filename=="etpr70"  {
gen toilet = hv205
}
if filename=="gapr41"  {
recode hv205 ///
22 = 23 ///
, gen (toilet)
}
if filename=="gapr60"  {
gen toilet = hv205
}
if filename=="ghpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="ghpr41"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
23 = 42 ///
, gen (toilet)
}
if filename=="ghpr4b"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
32 = 42 ///
, gen (toilet)
}
if filename=="ghpr5a"  {
gen toilet = hv205
}
if filename=="ghpr72"  {
gen toilet = hv205
}
if filename=="ghpr7b"  {
gen toilet = hv205
}
if filename=="gmpr60"  {
gen toilet = hv205
}
if filename=="gnpr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
31 = 23 ///
41 = 31 ///
, gen (toilet)
}
if filename=="gnpr52"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
23 = 21 ///
, gen (toilet)
}
if filename=="gnpr62"  {
gen toilet = hv205
}
if filename=="gupr34"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 23 ///
, gen (toilet)
}
if filename=="gupr41"  {
recode hv205 ///
12 = 11 ///
13 = 12 ///
21 = 23 ///
, gen (toilet)
}
if filename=="gupr71"  {
recode hv205 ///
13 = 14 ///
14 = 15 ///
22 = 23 ///
, gen (toilet)
}
if filename=="gypr51"  {
recode hv205 ///
61 = 43 ///
, gen (toilet)
}
if filename=="gypr5i"  {
gen toilet = hv205
}
if filename=="hnpr52"  {
recode hv205 ///
13 = 16 ///
21 = 51 ///
22 = 41 ///
24 = 44 ///
, gen (toilet)
}
if filename=="hnpr62"  {
recode hv205 ///
13 = 16 ///
21 = 51 ///
22 = 41 ///
24 = 44 ///
, gen (toilet)
}
if filename=="htpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 23 ///
23 = 21 ///
24 = 20 ///
, gen (toilet)
}
if filename=="htpr42"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="htpr52"  {
recode hv205 ///
51 = 42 ///
61 = 43 ///
, gen (toilet)
}
if filename=="htpr61"  {
recode hv205 ///
44 = 43 ///
45 = 51 ///
, gen (toilet)
}
if filename=="htpr70"  {
gen toilet = hv205
}
if filename=="iapr23"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
13 = 16 ///
21 = 23 ///
22 = 23 ///
41 = 96 ///
, gen (toilet)
}
if filename=="iapr42"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
13 = 16 ///
21 = 23 ///
22 = 23 ///
, gen (toilet)
}
if filename=="iapr52"  {
recode hv205 ///
44 = 23 ///
, gen (toilet)
}
if filename=="iapr74"  {
recode hv205 ///
44 = 23 ///
, gen (toilet)
}
if filename=="idpr21"  {
gen toilet = hv205
}
if filename=="idpr31"  {
gen toilet = hv205
}
if filename=="idpr3a"  {
gen toilet = hv205
}
if filename=="idpr42"  {
recode hv205 ///
11 = 12 ///
12 = 14 ///
21 = 10 ///
31 = 44 ///
41 = 23 ///
51 = 31 ///
, gen (toilet)
}
if filename=="idpr51"  {
recode hv205 ///
11 = 12 ///
12 = 14 ///
13 = 10 ///
21 = 23 ///
32 = 44 ///
33 = 31 ///
34 = 44 ///
35 = 31 ///
36 = 31 ///
, gen (toilet)
}
if filename=="idpr63"  {
recode hv205 ///
11 = 12 ///
12 = 14 ///
13 = 10 ///
21 = 23 ///
32 = 44 ///
, gen (toilet)
}
if filename=="jopr21"  {
gen toilet = hv205
}
if filename=="jopr31"  {
recode hv205 ///
11 = 16 ///
12 = 16 ///
21 = 23 ///
, gen (toilet)
}
if filename=="jopr42"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 23 ///
, gen (toilet)
}
if filename=="jopr51"  {
recode hv205 ///
12 = 13 ///
13 = 14 ///
, gen (toilet)
}
if filename=="jopr61"  {
recode hv205 ///
12 = 13 ///
13 = 14 ///
, gen (toilet)
}
if filename=="jopr6c"  {
gen toilet = hv205
}
if filename=="kepr33"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
41 = 96 ///
, gen (toilet)
}
if filename=="kepr3a"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="kepr42"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="kepr52"  {
gen toilet = hv205
}
if filename=="kepr71"  {
gen toilet = hv205
}
if filename=="kepr7a"  {
gen toilet = hv205
}
if filename=="kepr7h"  {
gen toilet = hv205
}
if filename=="khpr42"  {
recode hv205 ///
11 = 12 ///
12 = 11 ///
21 = 22 ///
22 = 23 ///
, gen (toilet)
}
if filename=="khpr51"  {
gen toilet = hv205
}
if filename=="khpr61"  {
gen toilet = hv205
}
if filename=="khpr73"  {
gen toilet = hv205
}
if filename=="kkpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="kkpr42"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
, gen (toilet)
}
if filename=="kmpr32"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="kmpr61"  {
gen toilet = hv205
}
if filename=="kypr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="kypr61"  {
gen toilet = hv205
}
if filename=="lbpr51"  {
gen toilet = hv205
}
if filename=="lbpr5a"  {
gen toilet = hv205
}
if filename=="lbpr61"  {
gen toilet = hv205
}
if filename=="lbpr6a"  {
gen toilet = hv205
}
if filename=="lbpr70"  {
gen toilet = hv205
}
if filename=="lspr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="lspr61"  {
gen toilet = hv205
}
if filename=="lspr71"  {
gen toilet = hv205
}
if filename=="mapr21"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
41 = 96 ///
, gen (toilet)
}
if filename=="mapr43"  {
recode hv205 ///
11 = 16 ///
12 = 16 ///
13 = 96 ///
21 = 23 ///
22 = 23 ///
32 = 42 ///
, gen (toilet)
}
if filename=="mbpr53"  {
recode hv205 ///
31 = 41 ///
41 = 42 ///
, gen (toilet)
}
if filename=="mdpr21"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
23 = 22 ///
41 = 96 ///
, gen (toilet)
}
if filename=="mdpr31"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="mdpr42"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="mdpr51"  {
recode hv205 ///
24 = 23 ///
, gen (toilet)
}
if filename=="mdpr61"  {
recode hv205 ///
23 = 22 ///
24 = 23 ///
, gen (toilet)
}
if filename=="mdpr6h"  {
recode hv205 ///
23 = 22 ///
24 = 23 ///
, gen (toilet)
}
if filename=="mdpr71"  {
gen toilet = hv205
}
if filename=="mlpr32"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 23 ///
, gen (toilet)
}
if filename=="mlpr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="mlpr53"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="mlpr60"  {
gen toilet = hv205
}
if filename=="mlpr6a"  {
gen toilet = hv205
}
if filename=="mlpr70"  {
gen toilet = hv205
}
if filename=="mmpr71"  {
gen toilet = hv205
}
if filename=="mvpr52"  {
gen toilet = hv205
}
if filename=="mvpr71"  {
gen toilet = hv205
}
if filename=="mwpr22"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
41 = 96 ///
, gen (toilet)
}
if filename=="mwpr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="mwpr4e"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="mwpr61"  {
recode hv205 ///
11 = 16 ///
, gen (toilet)
}
if filename=="mwpr6h"  {
gen toilet = hv205
}
if filename=="mwpr71"  {
gen toilet = hv205
}
if filename=="mwpr7h"  {
gen toilet = hv205
}
if filename=="mwpr7i"  {
gen toilet = hv205
}
if filename=="mzpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 23 ///
, gen (toilet)
}
if filename=="mzpr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 31 ///
30 = 31 ///
, gen (toilet)
}
if filename=="mzpr51"  {
gen toilet = hv205
}
if filename=="mzpr62"  {
recode hv205 ///
15 = 16 ///
, gen (toilet)
}
if filename=="mzpr71"  {
recode hv205 ///
11 = 16 ///
12 = 16 ///
22 = 21 ///
, gen (toilet)
}
if filename=="ncpr31"  {
recode hv205 ///
15 = 14 ///
21 = 23 ///
22 = 21 ///
24 = 43 ///
30 = 31 ///
, gen (toilet)
}
if filename=="ncpr41"  {
recode hv205 ///
13 = 12 ///
15 = 14 ///
21 = 23 ///
22 = 21 ///
30 = 31 ///
32 = 43 ///
, gen (toilet)
}
if filename=="ngpr21"  {
gen toilet = hv205
}
if filename=="ngpr41"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
23 = 42 ///
, gen (toilet)
}
if filename=="ngpr4b"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
32 = 44 ///
, gen (toilet)
}
if filename=="ngpr53"  {
gen toilet = hv205
}
if filename=="ngpr61"  {
gen toilet = hv205
}
if filename=="ngpr6a"  {
gen toilet = hv205
}
if filename=="ngpr71"  {
gen toilet = hv205
}
if filename=="nipr22"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
13 = 16 ///
21 = 23 ///
22 = 21 ///
41 = 96 ///
, gen (toilet)
}
if filename=="nipr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 23 ///
, gen (toilet)
}
if filename=="nipr51"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="nipr61"  {
gen toilet = hv205
}
if filename=="nmpr21"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
23 = 42 ///
41 = 96 ///
, gen (toilet)
}
if filename=="nmpr41"  {
recode hv205 ///
11 = 16 ///
12 = 22 ///
21 = 23 ///
22 = 21 ///
23 = 42 ///
, gen (toilet)
}
if filename=="nmpr51"  {
gen toilet = hv205
}
if filename=="nmpr61"  {
gen toilet = hv205
}
if filename=="nppr31"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
31 = 42 ///
32 = 31 ///
, gen (toilet)
}
if filename=="nppr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="nppr51"  {
gen toilet = hv205
}
if filename=="nppr60"  {
gen toilet = hv205
}
if filename=="nppr7h"  {
gen toilet = hv205
}
if filename=="pepr21"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
23 = 22 ///
24 = 22 ///
25 = 23 ///
26 = 23 ///
41 = 96 ///
, gen (toilet)
}
if filename=="pepr31"  {
recode hv205 ///
11 = 16 ///
12 = 16 ///
13 = 16 ///
14 = 16 ///
21 = 23 ///
22 = 23 ///
31 = 44 ///
32 = 31 ///
, gen (toilet)
}
if filename=="pepr41"  {
recode hv205 ///
11 = 16 ///
12 = 16 ///
13 = 16 ///
14 = 16 ///
21 = 23 ///
22 = 23 ///
30 = 31 ///
41 = 44 ///
, gen (toilet)
}
if filename=="pepr51"  {
recode hv205 ///
11 = 31 ///
12 = 16 ///
24 = 43 ///
31 = 44 ///
32 = 31 ///
, gen (toilet)
}
if filename=="pepr5i"  {
recode hv205 ///
11 = 31 ///
12 = 16 ///
24 = 43 ///
31 = 44 ///
32 = 31 ///
, gen (toilet)
}
if filename=="pepr61"  {
recode hv205 ///
11 = 31 ///
12 = 16 ///
24 = 43 ///
31 = 44 ///
32 = 31 ///
, gen (toilet)
}
if filename=="pepr6a"  {
recode hv205 ///
11 = 31 ///
12 = 16 ///
24 = 43 ///
31 = 44 ///
32 = 31 ///
, gen (toilet)
}
if filename=="pepr6i"  {
recode hv205 ///
11 = 31 ///
12 = 16 ///
24 = 43 ///
31 = 44 ///
32 = 31 ///
, gen (toilet)
}
if filename=="phpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 23 ///
24 = 43 ///
41 = 96 ///
, gen (toilet)
}
if filename=="phpr3b"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 13 ///
22 = 23 ///
30 = 31 ///
31 = 43 ///
, gen (toilet)
}
if filename=="phpr41"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 13 ///
22 = 23 ///
31 = 43 ///
32 = 31 ///
, gen (toilet)
}
if filename=="phpr52"  {
gen toilet = hv205
}
if filename=="phpr61"  {
recode hv205 ///
51 = 96 ///
, gen (toilet)
}
if filename=="phpr70"  {
recode hv205 ///
71 = 96 ///
, gen (toilet)
}
if filename=="pkpr21"  {
recode hv205 ///
13 = 16 ///
41 = 96 ///
, gen (toilet)
}
if filename=="pkpr52"  {
recode hv205 ///
13 = 14 ///
14 = 15 ///
, gen (toilet)
}
if filename=="pkpr61"  {
gen toilet = hv205
}
if filename=="pkpr71"  {
gen toilet = hv205
}
if filename=="pypr21"  {
gen toilet = hv205
}
if filename=="rwpr21"  {
recode hv205 ///
13 = 16 ///
41 = 96 ///
, gen (toilet)
}
if filename=="rwpr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="rwpr53"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="rwpr5a"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="rwpr61"  {
gen toilet = hv205
}
if filename=="rwpr6q"  {
gen toilet = hv205
}
if filename=="rwpr70"  {
gen toilet = hv205
}
if filename=="rwpr7a"  {
gen toilet = hv205
}
if filename=="slpr51"  {
recode hv205 ///
71 = 44 ///
, gen (toilet)
}
if filename=="slpr61"  {
gen toilet = hv205
}
if filename=="slpr71"  {
gen toilet = hv205
}
if filename=="snpr21"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="snpr32"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
41 = 96 ///
, gen (toilet)
}
if filename=="snpr4h"  {
recode hv205 ///
11 = 16 ///
12 = 14 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="snpr50"  {
gen toilet = hv205
}
if filename=="snpr5h"  {
gen toilet = hv205
}
if filename=="snpr61"  {
recode hv205 ///
24 = 51 ///
26 = 23 ///
, gen (toilet)
}
if filename=="snpr6d"  {
recode hv205 ///
24 = 51 ///
26 = 23 ///
, gen (toilet)
}
if filename=="snpr6r"  {
recode hv205 ///
24 = 51 ///
26 = 23 ///
, gen (toilet)
}
if filename=="snpr70"  {
recode hv205 ///
24 = 51 ///
26 = 23 ///
, gen (toilet)
}
if filename=="snpr7h"  {
recode hv205 ///
24 = 51 ///
26 = 23 ///
, gen (toilet)
}
if filename=="snpr7i"  {
recode hv205 ///
24 = 51 ///
26 = 23 ///
, gen (toilet)
}
if filename=="snpr7z"  {
gen toilet = hv205
}
if filename=="snprg0"  {
recode hv205 ///
24 = 51 ///
26 = 23 ///
, gen (toilet)
}
if filename=="stpr50"  {
gen toilet = hv205
}
if filename=="szpr51"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="tdpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="tdpr41"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="tdpr71"  {
recode hv205 ///
11 = 12 ///
12 = 13 ///
13 = 14 ///
14 = 15 ///
, gen (toilet)
}
if filename=="tgpr31"  {
recode hv205 ///
21 = 22 ///
22 = 23 ///
23 = 12 ///
24 = 22 ///
, gen (toilet)
}
if filename=="tgpr61"  {
gen toilet = hv205
}
if filename=="tgpr71"  {
gen toilet = hv205
}
if filename=="tjpr61"  {
gen toilet = hv205
}
if filename=="tjpr70"  {
gen toilet = hv205
}
if filename=="tlpr61"  {
gen toilet = hv205
}
if filename=="tlpr71"  {
gen toilet = hv205
}
if filename=="trpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 13 ///
22 = 23 ///
, gen (toilet)
}
if filename=="trpr41"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 13 ///
, gen (toilet)
}
if filename=="trpr4a"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 13 ///
, gen (toilet)
}
if filename=="tzpr21"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="tzpr3a"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="tzpr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="tzpr4a"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="tzpr4i"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="tzpr51"  {
recode hv205 ///
15 = 16 ///
24 = 23 ///
, gen (toilet)
}
if filename=="tzpr63"  {
gen toilet = hv205
}
if filename=="tzpr6a"  {
recode hv205 ///
24 = 23 ///
, gen (toilet)
}
if filename=="tzpr7a"  {
recode hv205 ///
24 = 23 ///
, gen (toilet)
}
if filename=="tzpr7q"  {
recode hv205 ///
24 = 21 ///
, gen (toilet)
}
if filename=="uapr51"  {
gen toilet = hv205
}
if filename=="ugpr33"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="ugpr41"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="ugpr52"  {
recode hv205 ///
11 = 16 ///
22 = 23 ///
23 = 22 ///
24 = 23 ///
25 = 22 ///
, gen (toilet)
}
if filename=="ugpr5h"  {
recode hv205 ///
11 = 16 ///
22 = 23 ///
23 = 22 ///
24 = 23 ///
25 = 22 ///
, gen (toilet)
}
if filename=="ugpr60"  {
recode hv205 ///
11 = 16 ///
22 = 23 ///
23 = 22 ///
24 = 23 ///
25 = 22 ///
44 = 51 ///
, gen (toilet)
}
if filename=="ugpr6a"  {
gen toilet = hv205
}
if filename=="ugpr72"  {
recode hv205 ///
24 = 22 ///
25 = 23 ///
, gen (toilet)
}
if filename=="ugpr7a"  {
gen toilet = hv205
}
if filename=="uzpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="vnpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="vnpr41"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="vnpr52"  {
recode hv205 ///
11 = 16 ///
22 = 23 ///
, gen (toilet)
}
if filename=="yepr21"  {
recode hv205 ///
13 = 11 ///
14 = 12 ///
24 = 14 ///
25 = 23 ///
26 = 16 ///
31 = 42 ///
32 = 31 ///
41 = 96 ///
, gen (toilet)
}
if filename=="yepr61"  {
recode hv205 ///
24 = 23 ///
25 = 23 ///
, gen (toilet)
}
if filename=="zapr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 42 ///
22 = 23 ///
, gen (toilet)
}
if filename=="zapr71"  {
recode hv205 ///
23 = 21 ///
44 = 51 ///
, gen (toilet)
}
if filename=="zmpr21"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
41 = 96 ///
, gen (toilet)
}
if filename=="zmpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="zmpr42"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="zmpr51"  {
gen toilet = hv205
}
if filename=="zmpr61"  {
gen toilet = hv205
}
if filename=="zwpr31"  {
recode hv205 ///
11 = 16 ///
12 = 10 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="zwpr42"  {
recode hv205 ///
11 = 16 ///
21 = 23 ///
22 = 21 ///
, gen (toilet)
}
if filename=="zwpr52"  {
recode hv205 ///
91 = 41 ///
92 = 42 ///
, gen (toilet)
}
if filename=="zwpr62"  {
gen toilet = hv205
}
if filename=="zwpr71"  {
gen toilet = hv205
}

********************************************************************************
*CREATE LABELS AND IMPROVED SANITATION VARIABLE
********************************************************************************

label define toilet			10	 "improved but shared toilet"	///
							11	 "flush - to piped sewer system" ///
							12	 "flush - to septic tank"		///
							13	 "flush - to pit latrine"		///
							14	 "flush - to somewhere else"	///
							15	 "flush - don't know where"		///
							16   "flush - unspecified"			///
							20   "pit latrine - improved but shared" ///
							21	 "pit latrine - ventilated improved pit (vip)"	///
							22	 "pit latrine - with slab"		///
							23	 "pit latrine - without slab / open pit" ///
							31	 "no facility/bush/field" 		///
							41	 "composting toilet"			///
							42	 "bucket toilet"				///
							43	 "hanging toilet/latrine"		///
							44	 "river/stream/sea/pond/lake"	///
							51	 "other improved"				///
							96	 "other"						
label values toilet toilet

recode toilet (11/13 16 21 22 41 51 = 1 "improved toilet") (10 14 15 20 23 31 42/44 96 = 0 "unimproved") (99=.), gen(toiletimprove)
cap recode hv225 .=0 9=0
*cap replace toiletimprove = 0 if hv225==1 //shared toilet is not improved. Note: this is used in the old definition and no longer required. 
replace toiletimprove = . if hv102!=1 //only for dejure



*drop filename
