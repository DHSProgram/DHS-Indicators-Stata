/*****************************************************************************************************
Program: 			FP_Need.do
Purpose: 			Code contraceptive unmet need, met need, demand satisfied, intention to use
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: Feb 1 2019 by Shireen Assaf 
					March 17 2021 by Trevor Croft to update coding to match v626a when generating for older surveys, 
					  and allow for DHS-7 surveys in general code and add in some survey-specific code
*****************************************************************************************************/

/*----------------------------------------------------------------------------
fp_unmet_space			"Unmet need for spacing"
fp_unmet_limit			"Unmet need for limiting"
fp_unmet_tot			"Unmet need total"
fp_met_space			"Met need for spacing"
fp_met_limit			"Met need for limiting"
fp_met_tot				"Met need total"
fp_demand_space			"Total demand for spacing"
fp_demand_limit			"Total demand for limiting"
fp_demand_tot			"Total demand -total"
fp_demsat_mod			"Demand satisfied by modern methods"
fp_demsat_any			"Demand satisfied by any method"

fp_future_use			"Intention of use of contraception in the future among non-users"
----------------------------------------------------------------------------*/

gen srvy=substr("$irdata", 1, 6)

* check if unmet need variable v626a is present
scalar v626a_included=1
		capture confirm numeric variable v626a, exact 
		if _rc>0 {
		* v626a is not present
		scalar v626a_included=0
		}
		if _rc==0 {
		* v626a is present; check for values
		summarize v626a
		  if r(sd)==0 | r(sd)==. {
		  scalar v626a_included=0
		  }
		}

* survey specific code for surveys that do not have v626a
if v626a_included==0 {

	cap gen v626a=.
	**Set unmet need to NA for unmarried women if survey only included ever-married women or only collected necessary data for married women
	* includes DHS II survey (v605 only asked to married women),
	* Morocco 2003-04, Turkey 1998 (no sexual activity data for unmarried women),
	* Cote D'Ivoire 1994, Haiti 1994-95 (v605 only asked to married women)
	* India 2005-06 (v605 only asked to ever-married women), Nepal 2006 (v605 not asked to unmarried and "married, guana not performed" women)
	replace v626a=98 if v502!=1 & (v020==1 | substr(v000,3,1)=="2" | ///
	v000=="MA4" | v000=="TR2" | (v000=="CI3" & v007==94) | ///
	v000=="HT3" | v000=="IA5" | v000=="NP5")

	** CONTRACEPTIVE USERS - GROUP 1
	* using to limit if wants no more, sterilized, or declared infecund
	recode v626a .=4 if v312!=0 & (v605>=5 & v605<=7)
	* using to space - all other contraceptive users
	recode v626a .=3 if v312!=0

	**PREGNANT or POSTPARTUM AMENORRHEIC (PPA) WOMEN - GROUP 2
	* Determine who should be in Group 2
	* generate time since last birth
	g tsinceb=v222
	* generate time since last period in months from v215
	g       tsincep	=	int((v215-100)/30) 	if v215>=100 & v215<=190
	replace tsincep =   int((v215-200)/4.3) if v215>=200 & v215<=290
	replace tsincep =   (v215-300) 			if v215>=300 & v215<=390
	replace tsincep =	(v215-400)*12 		if v215>=400 & v215<=490
	* initialize pregnant or postpartum amenorrheic (PPA) women
	g pregPPA=1 if v213==1 | m6_1==96
	* For women with missing data or "period not returned" on date of last menstrual period, use information from time since last period
	* 	if last period is before last birth in last 5 years
	replace pregPPA=1 if (m6_1==. | m6_1==99 | m6_1==97) & tsincep>tsinceb & tsinceb<60 & tsincep!=. & tsinceb!=.
	* 	or if said "before last birth" to time since last period in the last 5 years
	replace pregPPA=1 if (m6_1==. | m6_1==99 | m6_1==97) & v215==995 & tsinceb<60 & tsinceb!=.
	* select only women who are pregnant or PPA for <24 months
	g pregPPA24=1 if v213==1 | (pregPPA==1 & tsinceb<24)

	* Classify based on wantedness of current pregnancy/last birth
	* current pregnancy
	g wantedlast = v225
	* recode 'God's will' (survey-specific response) as not in need for Niger 1992
	replace wantedlast=1 if (v000=="NI2" & wantedlast==4) 
	* last birth
	replace wantedlast = m10_1 if (wantedlast==. | wantedlast==9) & v213!=1
	* recode 'not sure' and 'don't know' (survey-specific responses) as unmet need for spacing for Cote D'Ivoire 1994 and Madagascar 1992
	recode wantedlast (4 8 = 2)
	* no unmet need if wanted current pregnancy/last birth then/at that time
	recode v626a .=7  if pregPPA24==1 & wantedlast==1
	* unmet need for spacing if wanted current pregnancy/last birth later
	recode v626a .=1  if pregPPA24==1 & wantedlast==2
	* unmet need for limiting if wanted current pregnancy/last birth not at all
	recode v626a .=2  if pregPPA24==1 & wantedlast==3
	* missing=missing
	recode v626a .=99 if pregPPA24==1 & (wantedlast==. | wantedlast==9)

	**DETERMINE FECUNDITY - GROUP 3 (Boxes refer to Figure 2 flowchart in report)
	g infec = 0
	**Box 1 - applicable only to currently married
	* married 5+ years ago, no children in past 5 years, never used contraception, excluding pregnant and PPA <24 months
	cap replace infec=1 if v502==1 & v512>=5 & v512!=. & (tsinceb>59 | tsinceb==.) & v302 ==0 & pregPPA24!=1
	* in DHS VI, v302 replaced by v302a
	cap replace infec=1 if v502==1 & v512>=5 & v512!=. & (tsinceb>59 | tsinceb==.) & v302a==0 & pregPPA24!=1 & (substr(v000,3,1)=="6" | substr(v000,3,1)=="7" | substr(v000,3,1)=="8")
	* survey-specific code for Cambodia 2010
	cap replace infec=1 if v502==1 & v512>=5 & v512!=. & (tsinceb>59 | tsinceb==.) & s313 ==0 & pregPPA24!=1 & v000=="KH5" & (v007==2010 | v007==2011)
	* survey-specific code for Tanzania 2010
	cap replace infec=1 if v502==1 & v512>=5 & v512!=. & (tsinceb>59 | tsinceb==.) & s309b==0 & pregPPA24!=1 & v000=="TZ5" & (v007==2009 | v007==2010)
	
	**Box 2
	* declared infecund on future desires for children
	replace infec=2 if v605==7
	
	**Box 3
	* menopausal/hysterectomy on reason not using contraception - slightly different recoding in DHS III and IV+
	* DHS IV+ surveys
	cap replace infec=3 if 	v3a08d==1 & (substr(v000,3,1)=="4" | substr(v000,3,1)=="5" | substr(v000,3,1)=="6" | substr(v000,3,1)=="7" | substr(v000,3,1)=="8")
	* DHSIII surveys
	cap replace infec=3 if  v375a==23 & (substr(v000,3,1)=="3" | substr(v000,3,1)=="T")
	* special code for hysterectomy for Brazil 1996, Guatemala 1995 and 1998-9  (code 23 = menopausal only)
	cap replace infec=3 if 	v375a==28 & (v000=="BR3" | v000=="GU3")
	* reason not using did not exist in DHSII, use reason not intending to use in future
	cap replace infec=3 if  v376==14 & substr(v000,3,1)=="2"
	* below set of codes are all survey-specific replacements for reason not using contraception.
	* survey-specific code for Cote D'Ivoire 1994
	cap replace infec=3 if     v000=="CI3" & v007==94 & v376==23
	* survey-specific code for Gabon 2000
	cap replace infec=3 if     v000=="GA3" & s607d==1
	* survey-specific code for Haiti 1994/95
	cap replace infec=3 if     v000== "HT3" & v376==23
	* survey-specific code for Jordan 2002
	cap replace infec=3 if     v000== "JO4" & (v376==23 | v376==24)
	* survey-specific code for Kazakhstan 1999
	cap replace infec=3 if     v000== "KK3" & v007==99 & s607d==1
	* survey-specific code for Maldives 2009
	cap replace infec=3 if     v000== "MV5" & v376==23
	* survey-specific code for Mauritania 2000
	cap replace infec=3 if     v000== "MR3" & s607c==1
	* survey-specific code for Tanzania 1999
	cap replace infec=3 if     v000== "TZ3" & v007==99 & s607d==1
	* survey-specific code for Turkey 2003
	cap replace infec=3 if     v000== "TR4" & v375a==23
	
	**Box 4
	* Time since last period is >=6 months and not PPA
	replace infec=4 if tsincep>=6 & tsincep!=. & pregPPA!=1
	
	**Box 5
	* menopausal/hysterectomy on time since last period
	replace infec=5 if v215==994
	* hysterectomy has different code for some surveys, but in 3 surveys it means "currently pregnant" - Yemen 1991, Turkey 1998, Uganda 1995)
	replace infec=5 if v215==993 & v000!="TR3" & v000!="UG3" & v000!="YE2"
	* never menstruated on time since last period, unless had a birth in the last 5 years
	replace infec=5 if v215==996 & (tsinceb>59 | tsinceb==.)
	
	**Box 6
	*time since last birth>= 60 months and last period was before last birth
	replace infec=6 if v215==995 & tsinceb>=60 & tsinceb!=.
	* Never had a birth, but last period reported as before last birth - assume code should have been 994 or 996
	replace infec=6 if v215==995 & tsinceb==.
	
	* exclude pregnant and PP amenorrheic < 24 months
	replace infec=0 if pregPPA24==1
	
	recode v626a .=9 if infec>0

	**NO NEED FOR UNMARRIED WOMEN WHO ARE NOT SEXUALLY ACTIVE
	* determine if sexually active in last 30 days
	g sexact=1 if v528>=0 & v528<=30
	* older surveys used code 95 for sex in the last 4 weeks (Tanzania 1996)
	recode sexact .=1 if v528==95
    * if unmarried and never had sex, assume no need
    recode v626a .=0 if v502!=1 & v525==0 
	* if unmarried and not sexually active in last 30 days, assume no need
	recode v626a .=8 if v502!=1 & sexact!=1

	**FECUND WOMEN - GROUP 4
	* wants within 2 years
	recode v626a .=7 if v605==1
	* survey-specific code: treat 'up to god' (country-specific response) as not in need for India (different codes for 1992-3 and 1998-9).
	recode v626a .=7 if v605==9 & v000=="IA3"
	recode v626a .=7 if v602==6 & v000=="IA2"
	* wants in 2+ years, wants undecided timing, or unsure if wants
	* survey-specific code for Lesotho 2009
	recode v605  .=4 if v000=="LS5"
	recode v626a .=1 if v605>=2 & v605<=4
	* wants no more
	recode v626a .=2 if v605==5
	recode v626a .=99

	la def v626a ///
	0 "never had sex" ///
    1 "unmet need for spacing" ///
	2 "unmet need for limiting" ///
	3 "using for spacing" ///
	4 "using for limiting" ///
	7 "no unmet need" ///
	8 "not sexually active" ///
	9 "infecund or menopausal" ///
	98 "unmarried - EM sample or no data" ///
	99 "missing"
	la val v626a v626a

}

* Recode the unmet need variable created above.	
	
//Unmet need spacing
gen fp_unmet_space = v626a==1
label var fp_unmet_space "Unmet need for spacing"

//Unmet need limiting
gen fp_unmet_limit = v626a==2
label var fp_unmet_limit "Unmet need for limiting"

//Unmet need total
gen fp_unmet_tot = (v626a==1|v626a==2)
label var fp_unmet_tot "Unmet need total"

//Met need spacing
gen fp_met_space = v626a==3
label var fp_met_space "Met need for spacing"

//Met need limiting
gen fp_met_limit = v626a==4
label var fp_unmet_limit "Met need for limiting"

//Met need total
gen fp_met_tot = (v626a==3|v626a==4)
label var fp_met_tot "Met need total"

//Total demand for spacing
gen fp_demand_space = (v626a==1|v626a==3)
label var fp_demand_space "Total demand for spacing"

//Total demand for limiting
gen fp_demand_limit = (v626a==2|v626a==4)
label var fp_demand_limit "Total demand for limiting"

//Total demand -total
gen fp_demand_tot = inlist(v626a,1,3,2,4)
label var fp_demand_tot "Total demand - total"

//Demand satisfied by modern methods
gen fp_demsat_mod=0
replace fp_demsat_mod=1 if (v626a==3 | v626a==4) & v313==3
replace fp_demsat_mod=. if !inlist(v626a,1,2,3,4) /*eliminate no need from denominator*/
label var fp_demsat_mod "Demand satisfied by modern methods"

//Demand satisfied by any methods
gen fp_demsat_any=0
replace fp_demsat_any=1 if (v626a==3 | v626a==4) 
replace fp_demsat_any=. if !inlist(v626a,1,2,3,4)  /*eliminate no need from denominator*/
label var fp_demsat_any "Demand satisfied by any methods"


//Future intention to use
gen fp_future_use = v362 
replace fp_future_use = . if  (v502!=1 | v312!=0)
label values fp_future_use V362
label var fp_future_use "Intention of use of contraception in the future among non-users"

************************
