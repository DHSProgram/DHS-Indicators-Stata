/*****************************************************************************************************
Program: 			PH_HOUS.do
Purpose: 			Code to compute household characteristics, possessions, and smoking in the home
Data inputs: 		HR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: April 22, 2020 by Shireen Assaf 
Note:				These indicators can also be computed using the PR file but you would need to select for dejure household memebers
					using hv102==1. Please see the Guide to DHS Statistics.  

*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:

ph_electric		"Have electricity"
ph_floor		"Flooring material"
ph_rooms_sleep	"Rooms for sleeping"
ph_cook_place	"Place for cooking"
ph_cook_fuel	"Type fo cooking fuel"
ph_cook_solid	"Using solid fuel for cooking"
ph_cook_clean	"Using clean fuel for cooking"
	
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
	
ph_smoke		"Frequency of smoking at home"
----------------------------------------------------------------------------*/

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
recode hv216 (1=1 "One") (2=2 "Two") (3/max=3 "Three or more") , gen(ph_rooms_sleep)
label var ph_rooms_sleep "Rooms for sleeping"

//Place for cooking
gen ph_cook_place = hv241 
replace ph_cook_place= 4 if hv226==95 
label define HV241 4 "No food cooked in household", modify
label values ph_cook_place HV241
label var ph_cook_place "Place for cooking"

//Type of cooking fuel
gen ph_cook_fuel= hv226 
label values ph_cook_fuel HV226
label var ph_cook_fuel "Type fo cooking fuel"

//Solid fuel for cooking
gen ph_cook_solid= inrange(hv226,6,11) 
label values ph_cook_solid yesno
label var ph_cook_solid "Using solid fuel for cooking"

//Clean fuel for cooking
gen ph_cook_clean= inrange(hv226,1,4) 
label values ph_cook_clean yesno
label var ph_cook_clean "Using clean fuel for cooking"

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
label var ph_cart "Owns a animal drawn cart"

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


*** Smoking ***

gen ph_smoke= hv252
label values ph_smoke HV252	
label var ph_smoke "Frequency of smoking at home"