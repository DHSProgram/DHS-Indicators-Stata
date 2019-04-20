cd "C:\Users\28840\Desktop\Nelly"


use "NGHR71FL.DTA", clear

*Weighting the data
gen wt=hv005/1000000

*Survey Set
svyset [pw=wt], psu(hv021) strata(hv024)

*Reshaping the dataset to a long format
reshape long hml10_ hml21_ ,i(hhid) j(idx)

gen sleepnet=0
replace sleepnet=1 if hml21_==1

gen ownnet=0
replace ownnet=1 if hml10_==1

tab sleepnet if ownnet==1 [iweight=wt]

svy: tab sleepnet if ownnet==1, ci
