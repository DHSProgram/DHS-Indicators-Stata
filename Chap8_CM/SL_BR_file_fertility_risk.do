***Prep to look at trend in fertility risk across biths in last 5 years

* combine BR files from 2008 and 2013
use C:\Users\27092\Desktop\SierraLeoneFA\data\SLBR51FL.dta, clear
gen yr=1
save C:\Users\27092\Desktop\SierraLeoneFA\data\SLBRcombined.dta, replace

use C:\Users\27092\Desktop\SierraLeoneFA\data\SLBR61FL.dta, clear
gen yr=2

append using C:\Users\27092\Desktop\SierraLeoneFA\data\SLBRcombined.dta

label var yr "year of survey"
label define yr 1"2008" 2"2013"
label values yr yr

save C:\Users\27092\Desktop\SierraLeoneFA\data\SLBRcombined.dta, replace
cd "C:\Users\27092\Desktop\SierraLeoneFA\data"
use SLBRcombined.dta, clear

* svyset
gen wt= v005/1000000
egen strata=group(yr v025 v022)
egen v001r=group(yr v001)
* checked the final reports for number of strata, v022 was the correct one to use
svyset v001r [pw=wt], strata(strata) singleunit(centered)

g months_ago = v008 - b3 

* Coding covariates

* age at birth
g ageb=(b3-v011)/12
g agebirth=1 if ageb<18
replace agebirth=2 if ageb>=18 & ageb<35
replace agebirth=3 if ageb>=35 & ageb<40
replace agebirth=4 if ageb>=40 
label var agebirth "Age at Birth,cat"
lab define agebirth2  1 "<18 years" 2 "18-34 years" 3 "35-39 years" 4 "40+ years"
lab val agebirth agebirth2
ta ageb agebirth

svy: ta agebirth yr if months_ago<60, col  

*under18
g under18=(agebirth==1)
ta agebirth under18 , mis
lab define under18_2  0 "No" 1 "Yes <18" 
lab val under18 under18_2
ta  agebirth under18

*over40
g over40=(agebirth==4)
ta agebirth over40 , mis
lab define over40  0 "No" 1 "Yes >40" 
lab val over40 over40
ta  agebirth over40

* parity
recode bord (4/16=4 "4+"), gen(parity)
svy: ta parity yr if months_ago<60, col  

***Most recent birth was the fourth or greater
g bord4=(bord>3)
label var bord4 "Parity of 4 or more"
svy: ta bord4 yr if months_ago<60, col  

****birth interval less than 24 months birth to birth (this is "high risk"
**less than 36 months would be medium risk, as per HRB report 
g bint24=(b11<24)
label var bint "Birth interval <24 months"
svy: ta bint yr if months_ago<60, col  

**less than 36 months would be medium risk, as per HRB report 
g bint36=(b11<36)
label var bint36 "Birth interval <36 months"
svy: ta bint36 yr if months_ago<60, col  

**bintcat, as per HRB report 
g bintcat= 1 if b11<24
replace bintcat= 2 if b11>23 & b11<36
replace bintcat= 3 if b11>35 & b11<48
replace bintcat= 4 if b11>47 
lab define bintcat  1 "<24 mo" 2 "24-35 mo" 3 "36-47 mo" 4 "48+ mo"
lab val bintcat bintcat
lab var bintcat "Preceding birth interval"
svy: ta bintcat yr if months_ago<60, col  
ta b11 bintcat

***avoiable high risk birth (woman young or old, short interval or multiple birth) using 36 months as cutoff (not 36 months like Shea)
g hrb=(agebirth==1|agebirth==1|bint36==1|bord4==1)
label var hrb "Avoidable high risk birth"
svy: ta hrb yr if months_ago<60, col  

* education
recode v106 (0=0 "none") (1=1 "primary") (2/3=2 "secondary+"), gen(edu)

svy: ta edu yr if months_ago<60, col  

* region
* use v024
svy: ta v024 yr if months_ago<60, col  

* locality
* use v025
svy: ta v025 yr if months_ago<60, col  

* wealth
* use v190
svy: ta v190 yr if months_ago<60, col  

**HIGH RISK FERTILITY BEHAVIOR: 
tabout agebirth parity bord4 bintcat hrb edu v024 v025 v190 if yr==1 & months_ago <60 using SLresults_pregrisk.xls  [iweight=wt] , oneway replace c(col lb ub se) f(4) svy nwt(wt)sebnone per pop
tabout agebirth parity bord4 bintcat hrb edu v024 v025 v190 if yr==2 & months_ago <60 using SLresults_pregrisk.xls  [iweight=wt], oneway append c(col lb ub se) f(4)  svy nwt(wt)sebnone per pop

*Young age (<18 years), Older age (40-49 years), Short preceding birth interval (bint36), High parity (bord4), Any risk (hrb)					
* YOUNG 2008 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 under18 if yr==1 & months_ago<60 using SLresults_under18.xls [iweight=wt], /*
*/ replace c(row ci) stats(chi2) svy nwt(wt)sebnone per pop
* YOUNG 2013 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 under18 if yr==2 & months_ago<60 using SLresults_under18.xls [iweight=wt], /*
*/ append c(row ci) stats(chi2) svy nwt(wt)sebnone per pop

* OLD AGE 2008 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 over40 if yr==1 & months_ago<60 using SLresults_over40.xls [iweight=wt], /*
*/ replace c(row ci) stats(chi2) svy nwt(wt)sebnone per pop
* OLD AGE 2013 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 over40 if yr==2 & months_ago<60 using SLresults_over40.xls [iweight=wt], /*
*/ append c(row ci) stats(chi2) svy nwt(wt)sebnone per pop

* SHORT BIRTH SPACING 2008 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 bint36 if yr==1 & months_ago<60 using SLresults_bint36.xls [iweight=wt], /*
*/ replace c(row ci) stats(chi2) svy nwt(wt)sebnone per pop
* OLD AGE 2013 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 bint36 if yr==2 & months_ago<60 using SLresults_bint36.xls [iweight=wt], /*
*/ append c(row ci) stats(chi2) svy nwt(wt)sebnone per pop

* BIRTH ORDER  2008 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 bord4 if yr==1 & months_ago<60 using SLresults_bord4.xls [iweight=wt], /*
*/ replace c(row ci) stats(chi2) svy nwt(wt)sebnone per pop
* OLD AGE 2013 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 bord4 if yr==2 & months_ago<60 using SLresults_bord4.xls [iweight=wt], /*
*/ append c(row ci) stats(chi2) svy nwt(wt)sebnone per pop

* HRB  2008 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 hrb if yr==1 & months_ago<60 using SLresults_hrb.xls [iweight=wt], /*
*/ replace c(row ci) stats(chi2) svy nwt(wt)sebnone per pop
* HRB 2013 (by edu, wealth, v025, v024)
tabout edu v190 v025 v024 hrb if yr==2 & months_ago<60 using SLresults_hrb.xls [iweight=wt], /*
*/ append c(row ci) stats(chi2) svy nwt(wt)sebnone per pop

/*
* Chi tests
svy: ta agebirth yr if months_ago <60, col // no change
svy: ta parity yr if months_ago <60, col // sig .013
svy: ta bord4 yr if months_ago <60, col // no change
svy: ta bint yr if months_ago <60, col // sig 0.0209
svy: ta hrb yr if months_ago <60, col // sig 0.0198
svy: ta edu yr if months_ago <60, col // no change
svy: ta v024 yr if months_ago <60, col // sig .0000
svy: ta v025 yr if months_ago <60, col //  sig .000
svy: ta v190 yr if months_ago <60, col // no change

