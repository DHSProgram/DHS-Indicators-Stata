/*****************************************************************************************************
Program: 			FE_CBR.do - DHS8 update
Purpose: 			Code to calculate Crude Birth Rate
Data inputs: 			PR dataset and the age-specific fertility rates in Table 5.1
Data outputs:			coded variables, output on screen, Excel table
Author:				Tom Pullum
Date last modified: January 31, 2024, by Tom Pullum
Note:				This do file is run AFTER FE_FERT.do 
*****************************************************************************************************/

/*
Variables created in this file:
CBR 		"Crude Birth Rate"
CBR_urban	"Crude Birth Rate - Urban"
CBR_rural	"Crude Birth Rate - Rural"

The CBR is calculated with the asfrs for the past 3 years and the current population totals

This program constructs a row with "age"=300 to be added to table 5.1.
The rest of table 5.1 was constructed in FE_FERT.do
FE_FERT.do must be run BEFORE THIS PROGRAM because the age-specific fertility rates 
  in that table are used here.

Potential fertility in age group 10-14 is included in the CBR but using the
  unadjusted asfr for 10-14, not the Lexis-adjusted asfr. Modifications would be
  needed to use the Lexis-adjusted asfr and the effect would be negligible.
  The Lexis-adjusted asfr would be preferable.

*/
****************************************************************************

program define make_CBR

use "$datapath//$prdata.dta", clear

* Reduce to the de facto population
keep if hv103==1
gen wt = hv005/1000000

* Calculate the population totals
total wt, over(hv025)
matrix B=e(b)
scalar stotalpop_urban=B[1,1]
scalar stotalpop_rural=B[1,2]

* Reduce to women
keep if hv104==2

* Construct age in 5-year intervals such that 10-14 is age=0 and 50+ is age=8
gen age=-2+int(hv105/5)
replace age=8 if hv105>=50
keep wt age hv025
collapse (sum) wt, by(age hv025)
rename wt women
save CBRtemp.dta, replace

* Save urban and rural versions of CBRtemp.dta
use CBRtemp.dta, clear
keep if hv025==1
keep age women
sort age
save CBRurban.dta, replace

use CBRtemp.dta, clear
keep if hv025==2
keep age women
sort age
save CBRrural.dta, replace

* Prepare urban and rural versions of the rest of table 5.1

* Calculate the number of births using the asfrs for the past 3 years in table_5pt1_current_fertility.dta
foreach lur in urban rural {
use "$resultspath/table_5pt1_current_fertility.dta", clear
keep age rate_`lur'
sort age
merge age using CBR`lur'.dta
keep if age>=0 & age<=7
drop _merge
gen births=women*rate_`lur'
total births
matrix B=e(b)
scalar stotalbirths_`lur'=B[1,1]
scalar sCBR_`lur'=stotalbirths_`lur'/stotalpop_`lur' 
}
scalar sCBR_total=(stotalbirths_urban+stotalbirths_rural)/(stotalpop_urban+stotalpop_rural)

end

****************************************************************************

program define make_table_5pt1_CBR

* Add a line for the CBR to table 5.1
clear
set obs 1
gen age=300
foreach lurt in urban rural total {
gen rate_`lurt'=sCBR_`lurt'
}

label define age 300 "CBR"
label values age age

list, table clean
save "$resultspath/table_5pt1_CBR.dta", replace
export excel using "$resultspath/FE_tables.xlsx", sheet("Table 5.1_CBR") sheetreplace firstrow(var)

end

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
* Execution begins here

make_CBR
make_table_5pt1_CBR

erase CBRrural.dta
erase CBRurban.dta
erase CBRtemp.dta
program drop _all





