/*******************************************************************************
Program: 			CM_PMR.do - DHS8 update
Purpose: 			Construct table on perinatal mortality for the Child Mortality Chapter. 			
Data outputs:			Table 8.4 for the generic Chapter 8 report on child mortality  
Author: 			Tom Pullum			
Date last modified:		May 2024 for DHS8
********************************************************************************/

********************************************************************************

program define prepare_data

use "$datapath//$grdata.dta", clear
gen wt=v005/1000000

* Reduce the file to births and stillbirths in months 0-59 before the survey
keep if p19<60 & (p32==1 | p32==2)

* Construct the outcome variables

gen stillbirth=0
gen  enn_death=0
replace stillbirth=1 if p32==2
replace  enn_death=1 if p32==1 & p6<=106

replace stillbirth=stillbirth*wt
replace enn_death=enn_death*wt
gen case=wt

* Construct covariates that are needed for table 8.4

* Mother's age at outcome 
gen age_years=int((p3-v011)/12)
gen age_int=1
replace age_int=2 if age_years>=20
replace age_int=3 if age_years>=30
replace age_int=4 if age_years>=40
label variable age_int "Mother's age at outcome"
label define age_int 1 "<20" 2 "20-29" 3 "30-39" 4 "40-49"
label values age_int age_int

gen preg_int=2 if p11<15
replace preg_int=2 if p11-p20>=15
replace preg_int=3 if p11-p20>=27
replace preg_int=4 if p11-p20>=39
replace preg_int=1 if p11==.
label variable preg_int "Prev. preg. interval"
label define preg_int 1 "First pregnancy" 2 "<15" 3 "15-26" 4 "27-38" 5 "39+"
label values preg_int preg_int 

gen total=1
label variable total "Total"
label define total 1 "Total"
label values total total

* You can add more covariates, constructed or in the data file

save  "$resultspath/GRtemp.dta", replace

end

*********************************************************************************

program define make_table_8pt4

* Format of table 8.4:
* col1 is stillbirths
* col2 is enn_deaths
* col6 is n
* col3 is 1000* col1/col6
* col4 is 1000* col2col6
* col5 is col3 + col4
* col7 is col1 / col2

* Construct table 8.4 by looping over covariates and collapsing
* You can add other covariates
* They will be sequenced in the table as they are in lcovars

local lcovars age_int preg_int $gcovars
* display "`lcovars'"

scalar srun=1

* BEGIN LOOP OVER THE COVARIATES
foreach lc of local lcovars {
use  "$resultspath/GRtemp.dta", clear
keep stillbirth enn_death wt case `lc'
local llabel : variable label `lc'
scalar slabel="`llabel'"
levelsof `lc', local(levels)

collapse (sum) stillbirth enn_death case, by(`lc') 

gen str30 variable_label=slabel
gen str30 category_label="."
  foreach li of local levels {
  local lname : label (`lc') `li' 
  scalar sname="`lname'"
  replace category_label=sname if `lc'==`li'
  }

rename `lc' value
gen str30 variable="`lc'"

gen vrun=srun

  if srun>1 {
  append using  "$resultspath/CM_PMR.dta"
  }

save  "$resultspath/CM_PMR.dta", replace
scalar srun=srun+1
}
* END LOOP OVER THE COVARIATES

replace variable_label=strproper(variable_label)
replace category_label=strproper(category_label)
gen st_rate=1000*stillbirth/case
gen enn_rate=1000*enn_death/case
gen peri_rate=st_rate+enn_rate
gen ratio=stillbirth/enn_death
label variable stillbirth "Stillbirths"
label variable enn_death "ENN deaths"
label variable case "Pregnancies 28+ weeks"
label variable st_rate "Stillbirth rate"
label variable enn_death "ENN rate"
label variable peri_rate "Perinatal rate"
label variable ratio "Ratio stillbirths to ENN deaths"
order variable value variable_label category_label stillbirth enn_death st_rate enn_rate peri_rate case ratio
sort vrun category
drop vrun
format stillbirth enn_death *rate case %7.0fc
format ratio %7.1f
list, table clean noobs ab(15)
save  "$resultspath/table_8pt4.dta", replace
export excel  "$resultspath/CM_tables.xlsx", sheet("Table 8.4") sheetreplace firstrow(var)

erase  "$resultspath/GRtemp.dta"
erase  "$resultspath/CM_PMR.dta"
end

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
* Execution begins here

prepare_data
make_table_8pt4


