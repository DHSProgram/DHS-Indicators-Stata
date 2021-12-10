


# The DHS Program Code Share Project

This project is aimed at providing Stata, SPSS, and R code for all DHS Program indicators listed in the Guide to DHS Statistics. The code is published on the [DHS Program Github site] (https://github.com/DHSProgram) which contains three repositories: DHS-Indicators-Stata, DHS-Indicators-SPSS, and DHS-Indicators-R. Users can download the code from these repositories or clone the repository to their own Github site. Users can also suggest changes to the code that will be reviewed by DHS Program staff before acceptance. 


[The Guide to DHS Statistics] (https://www.dhsprogram.com/Data/Guide-to-DHS-Statistics/index.cfm) contains 19 Chapters. Chapters 2-19 cover the chapters that would be found in a DHS final report assuming all  modules such as domestic violence, female genital cutting, and fistula were included in a survey. These chapters also cover DHS modules for Malaria and HIV Prevalence, as well as those not part of the core questionnaires. Chapter one is an introduction that does not require code. 


The Guide defines an indicator, names the pertinent variables, and explains how the indicator is computed. The DHS Program Code Share Project follows the instructions in the guide required to produce the indicators. 


## General instructions:
This DHS Code Share Project provides the code that can be used to produce these indicators as well as the standard tables found in a DHS Final Report. The code is organized into one folder for each chapter to follow the organization of the Guide to DHS Statistics. Each chapter has a two-letter abbreviation as shown in the table below. IndicatorList.xlsx provides a list of all the indicators along with their labels that will be coded in this project. 

## Main files:
Each folder contains a Main File from which the user can run all the code files (.do, .sps, or .R files) that will code the indicators and produce the tables for that chapter. The user only needs to change the paths in the Main File and the file name for the survey of interest. The user should not delete the globals (macros), and should only change to the correct path and survey for their project. 
Before running any code, it is advisable to read the Main File for a specific chapter and the associated code files for any notes. For some chapters a selection is required to choose the population of interest; for example, selecting the age group for the children’s vaccination indicators in the CH_VAC.do file or for indicators restricted to married women versus all women in the Family Planning chapter. 
The user may also select the indicators they are interested in for the chapter. Therefore, certain code files can be commented out in the Main Files so they do not run, or certain sections within a code file can also be commented out. If certain indicators are commented out, the same indicators in the table code file for the tabulations will also need to be commented out. 

## Country-specific changes in indicators:
There are some country specific changes that may be required. For instance, what is considered a skilled attendant at delivery or what qualifies as a treatment source for acute respiratory infection (ARI) or fever may differ from survey to survey. The user can check the DHS Final Report of the survey to know the correct changes required (in the footnote for the table of interest) and make the change in the code files. Instructions for these specific changes for an indicator are given in the code files to guide the user on how to make the change. 

## Working with older surveys:
Additionally, because the indicators that are created using the Code Share Project are based on the Guide to DHS Statistics, they reflect the standard variables that are available in a recent DHS survey dataset. If the provided code is used to create indicators from older surveys, it is possible the variable names have changed over time or are not available in the older survey. The user may need to check the dataset in use for the availability of the variables needed for coding and may have to adjust for missing variables or rename variables accordingly. Some of the code files will generate the variables with missing values for old surveys if the survey does not have that variable. 
In addition, older surveys (mainly before 2000) do not have a wealth index in the dataset and the files would need to be merged with a WI file to include the wealth index. For anthropometry indicators, surveys before roughly 2006 need to be merged with a HW file to obtain the WHO haz, waz, and whz indicators. Please visit https://www.dhsprogram.com/data/Merging-Datasets.cfm to learn how to merge DHS datasets. 

## Checking for small observations:
Tabulations do not check for the number of observations. The DHS convention is to suppress estimates that are based on less than 25 unweighted observations and to place in parenthesis any estimate based on 25-49 observations. It is the user’s responsibility to check the number of unweighted observations before relying on the estimate. The tabulations also do not provide any statistical testing or confidence intervals.  

## Creating tables 
For all table syntax files, the default age selection for women/men is 15-49. Cases outside this age range are dropped. If a different age selection is required, you can make this change in the table syntax file. Please read the notes at the top of each table syntax file. 
### SPSS
There are two commands that can be used for producing tables for the indicators in SPSS: ctables and crosstab. The ctables command (Custom Tables) is easier to use and more powerful, however the Custom Tables module is a separate module that must be purchased in addition to the SPSS Base module. If the user does not have this module installed then they can use the crosstab command. The current SPSS code for producing tables has both commands available with the crosstab commands commented out. Please use the appropriate command for your needs.
### Stata
In Stata the tabout command is used to create tables. This is a package that needs to be installed before it can be used. To install tabout, enter "ssc install tabout" in the Stata command window.

**********************************************************************************************************************************************************

## Completion list (this list will be updated periodically)

|Ch. | Title | Ch. Acronym |Stata code | SPSS code | R code |
|---|---|---|---|---|---|
|   2|Population & Housing|PH|X|X||
|   3|Respondents’ Characteristics|RC|X|X|X|
|   4|Marriage & Sexual Activity|MS|X|X||
|   5|   Fertility|FE|X|X|X|
|   6|   Fertility Preferences|FF|X|X|X|
|   7|   Family Planning |FP|X|X|X|
|   8|   Infant & Child Mortality|CM|X|X|X|
|   9|   Reproductive Health|RH|X|X|X|
|  10|   Child Health|CH|X|X||
|  11|   Nutrition of Children & Adults|NT|X|X||
|  12|   Malaria| ML|X|X||
|  13|   HIV-AIDS Knowledge, Attitudes, & Behaviors |HK|X|X||
|  14|   HIV Prevalence|HV|X|X|X|
|  15|   Women’s Empowerment|WE|X|X|X|
|  16|   Adult & Maternal Mortality|AM|X|X|X|
|  17|   Domestic Violence|DV|X|X|X|
|  18|	 Female Genital Cutting|FG|X|X||
|  19|	 Fistula |FS|X|X||

**********************************************************************************************************************************************************

For questions please email: codeshare@DHSProgram.com


