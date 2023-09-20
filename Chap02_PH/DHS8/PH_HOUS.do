/*****************************************************************************************************
Program: 			PH_HOUS.do - DHS8 update
Purpose: 			Code to compute household characteristics, possessions, and smoking in the home
Data inputs: 		HR dataset
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: September 11, 2023 by Courtney Allen
Note:				These indicators can also be computed using the PR file but you would need to select for dejure household members
					using hv102==1. Please see the Guide to DHS Statistics.  
					There may be some other country specific household possessions available in the dataset that may not be coded here. 
					
					9 new indicators in DHS8 see below.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

ph_electric		"Have electricity"
ph_floor		"Flooring material"
ph_rooms_sleep	"Rooms for sleeping"
ph_cook_place	"Place for cooking" - NEW indicator in DHS8
ph_cook_tech	"Type of cooking technology" - NEW indicator in DHS8
ph_cook_fuel	"Type of cooking fuel" - NEW indicator in DHS8
ph_cook_clean 	"Using clean or solid fuels and technologies" - NEW indicator in DHS8	
ph_heat_tech	"Heating technology" - NEW indicator in DHS8
ph_heat_fuel	"Heating fuel" - NEW indicator in DHS8
ph_light		"Lighting fuel and technology" - NEW indicator in DHS8
ph_rely_clean_cook	"Reliance on clean fuels and tech for cooking" - NEW indicator in DHS8
ph_rely_solid_cook	"Reliance on solid fuels for cooking" - NEW indicator in DHS8
ph_rely_clean_heat	"Reliance on clean fuels and tech for heating" - NEW indicator in DHS8
ph_rely_clean_light	"Reliance on clean fuels and tech for lighting" - NEW indicator in DHS8
ph_rely_clean_all	"Reliance on clean fuels and tech for cooking, heating, and lighting" - NEW indicator in DHS8

ph_smoke		"Frequency of smoking at home"	
ph_radio		"Owns a radio"
ph_tv			"Owns a tv"
ph_mobile		"Owns a mobile phone"
ph_tel			"Owns a non-mobile telephone"
ph_comp			"Owns a computer"
ph_frig			"Owns a refrigerator"
ph_bike			"Owns a bicycle"
ph_cart			"Owns a animal drawn cart"
ph_moto			"Owns a motorcycle/scooter"
ph_car			"Owns a car or truck"
ph_boat			"Owns a boat with a motor"
ph_agriland		"Owns agricultural land"
ph_animals		"Owns livestock or farm animals"

----------------------------------------------------------------------------*/

cap label define yesno 0"No" 1"Yes"

*** Household characteristics ***

//Have electricity
gen ph_electric= hv206 
label values ph_electric yesno
label var ph_electric "Have electricity"

//Flooring material
gen ph_floor= hv213 
label values ph_floor HV213
label var ph_floor "Flooring material"

//Number of rooms for sleeping
recode hv216 (1=1 "One") (2=2 "Two") (3/98=3 "Three or more") (else=9 "Missing") , gen(ph_rooms_sleep)
label var ph_rooms_sleep "Rooms for sleeping"

//Frequency of smoking in the home
gen ph_smoke= hv252
replace ph_smoke = 9 if hv252==. 
label define HV252 9"Missing" , modify
label values ph_smoke HV252	
label var ph_smoke "Frequency of smoking at home"

//Place for cooking
gen ph_cook_place = .
replace ph_cook_place = 1 if hv241==1 & hv242==1
replace ph_cook_place = 2 if hv241==1 & hv242==0 
replace ph_cook_place = 3 if hv241==2 
replace ph_cook_place = 4 if hv241==3
replace ph_cook_place = 5 if hv241==6
replace ph_cook_place = 9 if hv241==. 
replace ph_cook_place = 6 if hv222==95
label define ph_cook_place_lab 	1 "In house, separate room/kitchen" 	///
								2 "In house, no separate room/kitchen" 	///
								3 "In separate building" ///
								4 "Outdoors" ///
								5 "Other" 	 ///
								6 "No food cooked in household" ///
								9 "Missing", modify
label values ph_cook_place ph_cook_place_lab
label var ph_cook_place "Place for cooking"

//Type of cooking technology - NEW indicator in DHS8	
gen ph_cook_tech = hv222
replace ph_cook_tech = 6 if hv222==6 & hv223==1
replace ph_cook_tech = 7 if hv222==6 & hv223!=1
replace ph_cook_tech = 8 if hv222==7 & hv240==1
replace ph_cook_tech = 9 if hv222==7 & (hv240==0 | hv240==8)
replace ph_cook_tech = 10 if hv222==8 & hv240==1
replace ph_cook_tech = 11 if hv222==8 & (hv240==0 | hv240==8)
replace ph_cook_tech = 12 if hv222==9

label define ph_cook_tech_lab   1 "Electric stove" 	///
								2 "Solar cooker" 	///
								3 "LGP/natural gas stove" ///
								4 "Piped natural gas stove" ///
								5 "Biogas stove" 	///
								6 "Liquid fuel stove using alc/ethanol" 	///
								7"Liquid fuel stove not using alc/ethanol" 	///
								8 "Manufact. solid fuel stove with chimney" ///
								9 "Manufact. solid fuel stove without chimney" ///
								10 "Trad. solid fuel stove with chimney" 	///
								11 "Trad. solid fuel stove without chimney"	///
								12 "Three stone stove/open fire" 			///
								95 "No food cooked in house" 96 "Other"
label values ph_cook_tech ph_cook_tech_lab
label var ph_cook_tech "Type of cooking technology"


//Type of cooking fuel
gen ph_cook_fuel = hv223
replace ph_cook_fuel = 1 if inrange(hv222, 1, 5) | (hv222==6 & hv223==1)
replace ph_cook_fuel = 13 if hv223==2 //recoding to order categories to match final report
replace ph_cook_fuel = 14 if hv223==3 //recoding to order categories to match final report
replace ph_cook_fuel= 99 if hv226==.
replace ph_cook_fuel= 95 if hv222==95
label define HV223 1 "Clean fuels and technologies" 13 "Gasoline/diesel" 14 "Kerosene/paraffin" 95 "No food cooked in house"99 "Missing", modify
label values ph_cook_fuel HV223
label var ph_cook_fuel "Type of cooking fuel"

//Type of clean or solid cooking fuels and technologies
gen ph_cook_clean = .
replace ph_cook_clean = 1 if inrange(hv222, 1, 5) | (hv222==6 & hv223==1)
replace ph_cook_clean = 2 if inrange(hv223, 4, 12)
replace ph_cook_clean = 3 if inlist(hv223, 2, 3, 96)
replace ph_cook_clean = 3 if hv223==1 & hv222!=6
replace ph_cook_clean = 95 if hv222==95
label define cook_clean 1 "Clean fuels and technologies" 2 "Solid fuels" 3 "Other fuels" 95 "No food cooked in house" 99 "Missing", modify
label values ph_cook_clean cook_clean
label var ph_cook_clean "Clean or solid fuels and technologies"


*** Heating and lighting ***

//Heating technology - NEW indicator in DHS8	
gen ph_heat_tech = hv259
replace ph_heat_tech = 2 if hv259==2 & hv260==1
replace ph_heat_tech = 3 if hv259==2 & inlist(hv260, 0, 8)
replace ph_heat_tech = 4 if hv259==3 & hv260==1
replace ph_heat_tech = 5 if hv259==3 & inlist(hv260, 0, 8)
replace ph_heat_tech = 6 if hv259==4 & hv260==1
replace ph_heat_tech = 7 if hv259==4 & inlist(hv260, 0, 8)
replace ph_heat_tech = 8 if hv259==5 & hv260==1
replace ph_heat_tech = 9 if hv259==5 & inlist(hv260, 0, 8)
replace ph_heat_tech = 10 if hv259==6
replace ph_heat_tech = 99 if hv259==. 
label define ph_heat_lab 1 "Central heating" ///
						 2 "Manufact. space heater w chimney" 		///
						 3 "Manufact. space heater w/out chimney" 	///
						 4 "Trad. space heater w chimney" 			///
						 5 "Trad. space heater w/out chimney" 		///
						 6 "Manufact. cookstove w chimney" 			///	
						 7 "Manufact. cookstove w/out chimney" 		///
						 8 "Trad. cookstove w chimney" 9 "Trad. cookstove w/out chimney" ///
						 10 "Three-stone stove/open fire" 			///
						 95 "No heating in household" 				///
						 96 "Other" 99 "Missing" , modify
label values ph_heat_tech ph_heat_lab
label var ph_heat_tech "Heating technology"

//Heating fuel - NEW indicator in DHS8	
gen ph_heat_fuel = hv261
replace ph_heat_fuel = 1 if inrange(hv261, 1, 6) | hv259==1
label define HV261 1 "Clean fuels and technologies", modify
label values ph_heat_fuel HV261
label var ph_heat_fuel "Heating fuel"

//Type of Lighting Technology - NEW indicator in DHS8	
gen ph_light = hv262
replace ph_light = 1 if inrange(hv262, 1,5)
label define HV262 1 "Clean fuels and technologies", modify
label values ph_light HV262
label var ph_light "Lighting fuel and technology"


*** Primary reliance on clean fuels and technologies ***

//Primary reliance on clean fuels and technologies for cooking - NEW indicator in DHS8	
gen ph_rely_clean_cook = 0 if hv222!=95
replace ph_rely_clean_cook = 1 if inrange(hv222, 1, 5) | (hv222==6 & hv223==1)
label values ph_rely_clean_cook yesno
label var ph_rely_clean_cook "Reliance on clean fuels and tech for cooking"

//Primary reliance on solid fuels for cooking - NEW indicator in DHS8	
gen ph_rely_solid_cook = 0 if hv222!=95
replace ph_rely_solid_cook = 1 if inrange(hv223, 4, 12)
label values ph_rely_solid_cook yesno
label var ph_rely_solid_cook "Reliance on solid fuels and tech for cooking"


//Primary reliance on clean fuels and technologies for heating - NEW indicator in DHS8	
gen ph_rely_clean_heat = 0 if hv259!=95
replace ph_rely_clean_heat = 1 if inrange(hv261, 1, 6) | hv259==1
label values ph_rely_clean_heat yesno
label var ph_rely_clean_heat "Reliance on clean fuels and tech for heating"

//Primary reliance on clean fuels and technologies for lighting - NEW indicator in DHS8	
gen ph_rely_clean_light = 0 if  hv262!=95
replace ph_rely_clean_light = 1 if inrange(hv262, 1,5)
label values ph_rely_clean_light yesno
label var ph_rely_clean_light "Reliance on clean fuels and tech for lighting"

//Primary reliance on clean fuels and technologies for lighting - NEW indicator in DHS8	
gen ph_rely_clean_all = 0 
replace ph_rely_clean_all = 1 if (ph_rely_cook_clean==1 | hv222==95) & (ph_rely_heat_clean==1 | hv259==95) & (ph_rely_light_clean==1 | hv262==95)
label values ph_rely_clean_all yesno
label var ph_rely_clean_all "Reliance on clean fuels and tech for cooking, heating, and lighting"


*** Household possessions ***

//Radio
gen ph_radio= hv207==1
label values ph_radio yesno
label var ph_radio "Owns a radio"

//TV
gen ph_tv= hv208==1
label values ph_tv yesno
label var ph_tv "Owns a tv"

//Mobile phone
gen ph_mobile= hv243a==1
label values ph_mobile yesno
label var ph_mobile "Owns a mobile phone"

//Non-mobile phone
gen ph_tel= hv221==1
label values ph_tel yesno
label var ph_tel "Owns a non-mobile telephone"

//Computer
gen ph_comp= hv243e==1
label values ph_comp yesno
label var ph_comp "Owns a computer"

//Refrigerator
gen ph_frig= hv209==1
label values ph_frig yesno
label var ph_frig "Owns a refrigerator"

//Bicycle
gen ph_bike= hv210==1
label values ph_bike yesno
label var ph_bike "Owns a bicycle"

//Animal drawn cart
gen ph_cart= hv243c==1
label values ph_cart yesno
label var ph_cart "Owns an animal drawn cart"

//Motorcycle or scooter
gen ph_moto= hv211==1
label values ph_moto yesno
label var ph_moto "Owns a motorcycle/scooter"

//Car or truck
gen ph_car= hv212==1
label values ph_car yesno
label var ph_car "Owns a car or truck"

//Boat with a motor
gen ph_boat= hv243d==1
label values ph_boat yesno
label var ph_boat "Owns a boat with a motor"

//Agricultural land
gen ph_agriland= hv244==1
label values ph_agriland yesno
label var ph_agriland "Owns agricultural land"

//Livestook
gen ph_animals= hv246==1
label values ph_animals yesno
label var ph_animals "Owns livestock or farm animals"

