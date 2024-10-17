/*******************************************************************************
Program: 				FEmain.do - DHS8 update
Purpose: 				Main file for the Fertility Chapter. 
						The main file will call other do files that will produce
						the FE indicators and produce tables.
Data outputs:			Coded variables, table output on screen, and in excel tables.  
Author: 				Tom Pullum and Courtney Allen
Date last modified:		September 4, 2020 by Courtney Allen
*******************************************************************************/

* SPECIFY GLOBALS AND PATHS. OTHERWISE THE EXECUTABLE LINES BEGIN AFTER THE MULTIPLE ROWS OF ASTERISKS
set more off

* User name for internal DHS use. Please disregard and adjust paths to your own.
global user 39585	

* Specify data path
global datapath "C:/Users//$user//ICF/Analysis - Shared Resources/Data/DHSdata"

* Specify working path
global workingpath "C:/Users//$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap05_FE/DHS8"

* Specify results path
global resultspath "C:/Users//$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap05_FE/DHS8"

cd "$workingpath"

* Specify the covariates; can be changed; extra covariates are added to some tables
* v024=region, v025=urban/rural, v106=education, v149=, v190=wealth quintile
global gcovars "v024 v025 v106 v149 v190 total"

* Select your survey

* IR File
global irdata "NPIR82FL"
	
*PR File
global prdata "NPPR82FL"
	
*KR File
global krdata "NPKR82FL"

*BR File
global brdata "NPBR82FL"

*NR File
global nrdata "NPNR82FL"

*MR File
*The MR file is only needed for the second row of table 5.13, using FE_FERT
global mrdata "NPMR82FL"


********************************************************************************	

/*

LIST OF THE STANDARD TABLES AND THE STANDARD RECODE FILES THEY USE

Table 5.1 Current fertility
Constructed with FE_RATES (IR file)
(The CBR is calculated with FE_CBR, using the PR file and asfrs from FE_RATES)

Table 5.2 Fertility by background characteristics
Constructed with FE_RATES (IR file) and FE_FERT (IR file); standard covariates

Table 5.3.1 Trends in age-specific fertility rates
Constructed with FE_RATES (IR file)

Table 5.3.2 Trends in age-specific and total fertility rates
Requires reference to the asfrs in table 5.1 and earlier final reports or STATcompiler
(Not constructed with the Chapter 5 programs)

Table 5.4 Children ever-born and living
Constructed with FE_FERT (IR file)

Table 5.5 Birth intervals
Constructed with FE_INT (BR file)
Standard covariates plus four recodes

Table 5.6 Postpartum amenorrhea, abstinence, and insusceptibility 
Constructed with FE_PPA (NR file)

Table 5.7 Median duration of postpartum amenorrhea, abstinence, and insusceptibility
Constructed with FE_PPA (NR file)
Standard covariates plus one recode

Table 5.8 Age at first menstruation
Constructed with FE_FERT (IR file), using fe_mens 

Table 5.9 Menopause
Constructed with FE_FERT (IR file), using fe_meno

Table 5.10 Age at first birth
Constructed with FE_FERT (IR file)

Table 5.11 Median age at first birth
Constructed with FE_FERT (IR file), using fe_birth_never, fe_afb_*, fe_mafb_8
Standard covariates

Table 5.12 Teenage pregnancy (with covariates)
Constructed with FE_FERT (IR file)
Standard covariates plus one recode

Table 5.13 Sexual and reproductive health behaviors before age 15
Constructed with FE_FERT (IR file), using fe_teen_*
The last row of Table 5.13 uses the MR file

Table 5.14 Pregnancy outcome (with covariates)
Constructed with FE_OUTCOMES (NR file)

Table 5.15 Induced abortion rates (with just v025 in the final report)
Constructed with FE_OUTCOMES (IR file)



********************************************************************************

STANDARD TABLES PRODUCED BY EACH OF THE DO FILES FOR CHAPTER 5:	

Tables produced by FE_RATES:
  without covariates: 5.1 (by v025, and not including CBR or age 10-14), 5.3.1 
  with covariates: 5.2 (TFR)

Produced by FE_CBR: CBR for table 5.1 (by v025)

Produced by FE_ASFR_10_14: rates for age 10-14 for table 5.1 (by v025)

Table produced by FE_INT (with covariates): 5.5 

Tables produced by FE_FERT:
  without covariates: 5.4, 5.8, 5.9, 5.10, 5.13
  with covariates: 5.2 (cols 2 and 3), 5.11, 5.12, 5.13

Tables produced by FE_PPA:
  without covariates: 5.6
  with covariates: 5.7

Tables produced by FE_OUTCOMES:
  with covariates: 5.14 
  with v025 as the only covariate: 5.15

DHS7 programs dropped for DHS8:
FE_tables is dropped; all tables are produced within the other programs

DHS7 programs renamed for DHS8:
FE_TFR is renamed to FE_RATES; it produces asfrs and GFR as well as TFR
FE_MEDIANS is renamed FE_PPA; identify the topic rather than the statistic 

FE_RATES, FE_CBR, FE_ASFR_10_14, and FE_PPA will run on pre-DHS8 files

*/
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
* EXECUTION BEGINS HERE

* FE_RATES produces the usual age-specific, general, and total fertility rates.
* It includes an option to give wanted fertility rates. 
* If you want the wanted fertility rates, you can use FE_RATES by switching the
*   scalar "sWANTED_FERTILITY_RATES" from 0 to 1.
program drop _all

* Uses the IR file
* Formerly named FE_TFR in DHS7 files
scalar sWANTED_FERTILITY_RATES=0
do FE_RATES.do

* Uses the PR file and output from FE_RATES
* must be run AFTER FE_RATES
do FE_CBR.do

* Uses the IR file
do FE_ASFR_10_14.do

* Uses the IR file, with optional use of the MR file at the very end
do FE_FERT.do

* Uses the BR file
do FE_INT.do

* Uses the NR file
* Was previously named FE_MEDIANS and ran on the KR file for births only
do FE_PPA.do

* Uses the NR file and the IR file
* Produce the tables on pregnancy outcomes and induced abortions, 5.14 and 5.15
do FE_OUTCOMES.do

