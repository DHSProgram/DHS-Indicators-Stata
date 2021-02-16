/*****************************************************************************************************
Program: 			DV_tables.do
Purpose: 			produce tables for domestic violence indicators
Author:				Courtney Allen
Date last modified: September 09 2020 by Courtney Allen

*Note this do file will produce the following tables in excel:
	1. 	Tables_DV_viol:		Contains the tables for indicators of experiencing violence ever and help seeking
	2. 	Tables_DV_cntrl:	Contains the tables for marital control indicators
	3. 	Tables_DV_prtnr:	Contains the tables for indicators of experiencing violence by their partners ever and help seeking


Notes: 
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

cap gen dwt = d005/1000000

	//subgroups
	local subgroup dv_age residence region marital work livingchild education wealth 

	**************************************************************************************************
	* Indicators for physical violence: excel file DV_tables will be produced
	**************************************************************************************************
//EXPERIENCE OF PHYSICAL VIOLENCE (Tables_DV_viol)
	//Experience of physical violence since age 15

	tab dv_age 	  	dv_phy  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_phy  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_phy  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_phy  [iw=dwt], row nofreq   	//by marital status
	tab work	  	dv_phy  [iw=dwt], row nofreq   	//by working status
	tab livingchild dv_phy  [iw=dwt], row nofreq  	//by number of living children
	tab education 	dv_phy  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_phy  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup'  dv_phy using Tables_DV_viol.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) replace 
	*/

	**************************************************************************************************
	//Experience of physical violence in last 12 months

	tab dv_age 	  	dv_phy_12m  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_phy_12m  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_phy_12m  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_phy_12m  [iw=dwt], row nofreq   //by marital status
	tab work	  	dv_phy_12m  [iw=dwt], row nofreq   //by working status
	tab livingchild dv_phy_12m  [iw=dwt], row nofreq  	//by number of living children
	tab education 	dv_phy_12m  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_phy_12m  [iw=dwt], row nofreq 	//by wealth

	tab dv_age 	  	dv_phy_12m_f   [iw=dwt], row nofreq 	//by age
	tab residence 	dv_phy_12m_f   [iw=dwt], row nofreq	//by residence 
	tab region    	dv_phy_12m_f   [iw=dwt], row nofreq 	//by region
	tab marital   	dv_phy_12m_f   [iw=dwt], row nofreq  //by marital status
	tab work	  	dv_phy_12m_f   [iw=dwt], row nofreq  //by working status
	tab livingchild dv_phy_12m_f   [iw=dwt], row nofreq  //by number of living children
	tab education 	dv_phy_12m_f   [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_phy_12m_f   [iw=dwt], row nofreq 	//by wealth
	
	* output to excel
	tabout `subgroup' dv_phy_12m using Tables_DV_viol.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	tabout `subgroup' dv_phy_12m_f  using Tables_DV_viol.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/

	**************************************************************************************************
	//Physcial violence during pregnancy
	tab dv_age 		dv_phy_preg	 [iw=dwt], row nofreq 	//by age
	tab residence 	dv_phy_preg  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_phy_preg  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_phy_preg  [iw=dwt], row nofreq   //by marital status
	tab work	  	dv_phy_preg  [iw=dwt], row nofreq   //by working status
	tab livingchild dv_phy_preg  [iw=dwt], row nofreq  	//by number of living children
	tab education 	dv_phy_preg  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_phy_preg  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' dv_phy_preg using Tables_DV_viol.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/
	
	**************************************************************************************************
	//Persons committing physical violence
	tab dv_phy_hus_curr		[iw=dwt] //by current husband
	tab dv_phy_hus_form		[iw=dwt] //by former husband
	tab dv_phy_bf_curr  	[iw=dwt] //by current boyfriend
	tab dv_phy_bf_form		[iw=dwt] //by former boyfriend
	tab dv_phy_father		[iw=dwt] //by father
	tab dv_phy_mother		[iw=dwt] //by mother
	tab dv_phy_sibling		[iw=dwt] //by sibling
	tab dv_phy_bychild		[iw=dwt] //by child
	tab dv_phy_other_rel	[iw=dwt] //by other relative
	tab dv_phy_mother_inlaw	[iw=dwt] //by mother in law
	tab dv_phy_father_inlaw	[iw=dwt] //by father in law
	tab dv_phy_other_inlaw	[iw=dwt] //by other in law
	tab dv_phy_teacher		[iw=dwt] //by teacher
	tab dv_phy_atwork		[iw=dwt] //by employer or someone at work
	tab dv_phy_police		[iw=dwt] //by police or soldier
	tab dv_phy_other		[iw=dwt] //by other

	* output to excel
	tabout  dv_phy_hus_curr 	marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_phy_hus_form		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_phy_bf_curr  	    marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_phy_bf_form		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append   
	tabout dv_phy_father		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_phy_mother		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_phy_sibling		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_phy_bychild		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_phy_other_rel	    marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_phy_mother_inlaw	marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_phy_father_inlaw	marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_phy_other_inlaw	marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append   
	tabout dv_phy_teacher		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_phy_atwork		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append   
	tabout dv_phy_police		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_phy_other		    marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	*/

	
	**************************************************************************************************

//EXPERIENCE OF SEXUAL VIOLENCE
	//Experience of sexual violence ever
		//ever
		tab dv_age 	  	dv_sex  [iw=dwt], row nofreq 	//by age
		tab residence 	dv_sex  [iw=dwt], row nofreq	//by residence 
		tab region    	dv_sex  [iw=dwt], row nofreq 	//by region
		tab marital   	dv_sex  [iw=dwt], row nofreq	//by marital status
		tab work	  	dv_sex  [iw=dwt], row nofreq    //by working status
		tab livingchild dv_sex  [iw=dwt], row nofreq  	//by number of living children
		tab education 	dv_sex  [iw=dwt], row nofreq 	//by education
		tab wealth    	dv_sex  [iw=dwt], row nofreq 	//by wealth

		//in last 12 months
		tab dv_age 	  	dv_sex_12m  [iw=dwt], row nofreq 	//by age
		tab residence 	dv_sex_12m  [iw=dwt], row nofreq	//by residence 
		tab region    	dv_sex_12m  [iw=dwt], row nofreq 	//by region
		tab marital   	dv_sex_12m  [iw=dwt], row nofreq	//by marital status
		tab work	  	dv_sex_12m  [iw=dwt], row nofreq    //by working status
		tab livingchild dv_sex_12m  [iw=dwt], row nofreq  	//by number of living children
		tab education 	dv_sex_12m  [iw=dwt], row nofreq 	//by education
		tab wealth    	dv_sex_12m  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' dv_sex using Tables_DV_viol.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	tabout `subgroup' dv_sex_12m using Tables_DV_viol.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/

	**************************************************************************************************
	//Persons committing sexual violence
	tab dv_sex_hus_curr		[iw=dwt] //by current husband
	tab dv_sex_hus_form		[iw=dwt] //by former husband
	tab dv_sex_bf		 	[iw=dwt] //by current or former boyfriend
	tab dv_sex_father		[iw=dwt] //by father
	tab dv_sex_brother		[iw=dwt] //by sibling
	tab dv_sex_other_rel	[iw=dwt] //by other relative
	tab dv_sex_inlaw		[iw=dwt] //by in law
	tab dv_sex_friend		[iw=dwt] //by friend
	tab dv_sex_friend_fam	[iw=dwt] //by friend of the family 
	tab dv_sex_teacher		[iw=dwt] //by teacher
	tab dv_sex_atwork		[iw=dwt] //by employer or someone at work
	tab dv_sex_relig		[iw=dwt] //by police or soldier
	tab dv_sex_police		[iw=dwt] //by police or soldier
	tab dv_sex_stranger		[iw=dwt] //by other
	tab dv_sex_other		[iw=dwt] //by other
	tab dv_sex_missing		[iw=dwt] //by other

	* output to excel
	tabout dv_sex_hus_curr 		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_sex_hus_form		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_sex_bf	 	    marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_sex_father		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_sex_brother		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_sex_other_rel	    marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_sex_inlaw			marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_sex_friend		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append   
	tabout dv_sex_friend_fam	marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append   
	tabout dv_sex_teacher		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_sex_atwork		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append   
	tabout dv_sex_relig			marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_sex_police		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_sex_stranger		marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append  
	tabout dv_sex_other		    marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	tabout dv_sex_missing	    marital_2	using Tables_DV_viol.xls [iw=dwt], c(col) npos(row) nwt(dwt) f(1) append 
	*/

	**************************************************************************************************
	//Age at first experienced sexual violence
	foreach x in 10 12 15 18 22 {
	tab dv_age 	  	dv_sex_age_`x'  [iw=dwt], row nofreq 	//by age
	tab marital   	dv_sex_age_`x'  [iw=dwt], row nofreq    //by marital status

	* output to excel
	tabout dv_age marital_2 dv_sex_age_`x' using Tables_DV_viol.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append h2("Note: ignore age groups that are too young")
	}
	tabout dv_age marital_2 dv_sex using Tables_DV_viol.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/
	
	
	**************************************************************************************************
	//Experience of different forms of violence
	tab dv_age dv_phy			[iw=dwt] //ever physical violence
	tab dv_age dv_sex			[iw=dwt] //ever sexual violence
	tab dv_age dv_phy_sex	  	[iw=dwt] //physical AND sexual violence
	tab dv_age dv_phy_sex_any	[iw=dwt] //physical OR sexual violence
	tab dv_age dv_viol_type     [iw=dwt] //only physical, only sexual, or both
	
	* output to excel
	tabout dv_age dv_phy_only 			using Tables_DV_viol.xls [iw=dwt], c(row) npos(col) nwt(dwt) f(1) append
	tabout dv_age dv_sex_only 			using Tables_DV_viol.xls [iw=dwt], c(row) npos(col) nwt(dwt) f(1) append
	tabout dv_age dv_phy_sex_any	 	using Tables_DV_viol.xls [iw=dwt], c(row) npos(col) nwt(dwt) f(1) append
	tabout dv_age dv_phy_sex		 	using Tables_DV_viol.xls [iw=dwt], c(row) npos(col) nwt(dwt) f(1) append
	*/

	
********************************************************************************

//HELP SEEKING FOR THOSE EXPERIENCE VIOLENCE (Tables_DV_viol)
	tab dv_age 	  	dv_help_seek  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_help_seek  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_help_seek  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_help_seek  [iw=dwt], row nofreq  //by marital status
	tab work	  	dv_help_seek  [iw=dwt], row nofreq 	//by working status
	tab livingchild dv_help_seek  [iw=dwt], row nofreq  //by number of living children
	tab education 	dv_help_seek  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_help_seek  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout dv_viol_type `subgroup' dv_help_seek using Tables_DV_viol.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	

	
//SOURCES OF HELP
	tab dv_help_fam 	dv_viol_type  [iw=dwt], row nofreq 	//by age
	tab dv_help_hfam 	dv_viol_type  [iw=dwt], row nofreq	//by residence 
	tab dv_help_husb   	dv_viol_type  [iw=dwt], row nofreq 	//by region
	tab dv_help_bf   	dv_viol_type  [iw=dwt], row nofreq  //by marital status
	tab dv_help_friend 	dv_viol_type  [iw=dwt], row nofreq 	//by working status
	tab dv_help_neighbor dv_viol_type  [iw=dwt], row nofreq  //by number of living children
	tab dv_help_relig 	dv_viol_type  [iw=dwt], row nofreq 	//by education
	tab dv_help_doc    	dv_viol_type  [iw=dwt], row nofreq 	//by wealth
	tab dv_help_police 	dv_viol_type  [iw=dwt], row nofreq 	//by wealth
	tab dv_help_lawyer 	dv_viol_type  [iw=dwt], row nofreq 	//by wealth
	tab dv_help_sw    	dv_viol_type  [iw=dwt], row nofreq 	//by wealth
	tab dv_help_other  	dv_viol_type  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout dv_help_fam 	dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_hfam dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_husb dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_bf 	dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_friend 	dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_neighbor dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_relig 	dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_doc 		dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_polic 	dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_lawyer 	dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_sw 	 	dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 
	tabout dv_help_other 	dv_viol_type using Tables_DV_viol.xls [iw=dwt] , c(col) npos(col) nwt(dwt) f(1) append 

	
**************************************************************************************************


//MARITAL CONTROL (Tables_DV_cntrl)
	//partner jealous if spoke to other men
	tab dv_age 	  	dv_prtnr_jeals  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_prtnr_jeals  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_prtnr_jeals  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_prtnr_jeals  [iw=dwt], row nofreq   //by marital status
	tab work	  	dv_prtnr_jeals  [iw=dwt], row nofreq   //by working status
	tab livingchild dv_prtnr_jeals  [iw=dwt], row nofreq  	//by number of living children
	tab education 	dv_prtnr_jeals  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_prtnr_jeals  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' afraid dv_prtnr_jeals using Tables_DV_cntrl.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) replace 
	*/

	//accused her of being unfaithful
	tab dv_age 	  	dv_prtnr_accus  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_prtnr_accus  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_prtnr_accus  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_prtnr_accus  [iw=dwt], row nofreq   	//by marital status
	tab work	  	dv_prtnr_accus  [iw=dwt], row nofreq   	//by working status
	tab livingchild dv_prtnr_accus  [iw=dwt], row nofreq  	//by number of living children
	tab education 	dv_prtnr_accus  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_prtnr_accus  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' afraid  dv_prtnr_accus using Tables_DV_cntrl.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/

	
	//prevented her from meeting female friends
	tab dv_age 	  	dv_prtnr_friends  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_prtnr_friends  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_prtnr_friends  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_prtnr_friends  [iw=dwt], row nofreq  //by marital status
	tab work	  	dv_prtnr_friends  [iw=dwt], row nofreq  //by working status
	tab livingchild dv_prtnr_friends  [iw=dwt], row nofreq  //by number of living children
	tab education 	dv_prtnr_friends  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_prtnr_friends  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' afraid dv_prtnr_friends using Tables_DV_cntrl.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/


	//tried to limit her contact with her family
	tab dv_age 	  	dv_prtnr_fam  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_prtnr_fam  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_prtnr_fam  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_prtnr_fam  [iw=dwt], row nofreq  //by marital status
	tab work	  	dv_prtnr_fam  [iw=dwt], row nofreq  //by working status
	tab livingchild dv_prtnr_fam  [iw=dwt], row nofreq  //by number of living children
	tab education 	dv_prtnr_fam  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_prtnr_fam  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' afraid dv_prtnr_fam using Tables_DV_cntrl.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/

	//insisted on knowing where she is at all times
	tab dv_age 	  	dv_prtnr_where  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_prtnr_where  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_prtnr_where  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_prtnr_where  [iw=dwt], row nofreq  	//by marital status
	tab work	  	dv_prtnr_where  [iw=dwt], row nofreq  	//by working status
	tab livingchild dv_prtnr_where  [iw=dwt], row nofreq  	//by number of living children
	tab education 	dv_prtnr_where  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_prtnr_where  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' afraid dv_prtnr_where using Tables_DV_cntrl.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/


	//did not trust her with money
	tab dv_age 	  	dv_prtnr_money  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_prtnr_money  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_prtnr_money  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_prtnr_money  [iw=dwt], row nofreq  	//by marital status
	tab work	  	dv_prtnr_money  [iw=dwt], row nofreq 	//by working status
	tab livingchild dv_prtnr_money  [iw=dwt], row nofreq  	//by number of living children
	tab education 	dv_prtnr_money  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_prtnr_money  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' afraid dv_prtnr_money using Tables_DV_cntrl.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/

	
	//displays 3 or more behaviors
	tab dv_age 	  	dv_prtnr_cntrl_3  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_prtnr_cntrl_3  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_prtnr_cntrl_3  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_prtnr_cntrl_3  [iw=dwt], row nofreq  	//by marital status
	tab work	  	dv_prtnr_cntrl_3  [iw=dwt], row nofreq 	//by working status
	tab livingchild dv_prtnr_cntrl_3  [iw=dwt], row nofreq  	//by number of living children
	tab education 	dv_prtnr_cntrl_3  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_prtnr_cntrl_3  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' afraid dv_prtnr_cntrl_3 using Tables_DV_cntrl.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/

	//displays none of the behaviors
	tab dv_age 	  	dv_prtnr_cntrl_0  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_prtnr_cntrl_0  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_prtnr_cntrl_0  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_prtnr_cntrl_0  [iw=dwt], row nofreq  	//by marital status
	tab work	  	dv_prtnr_cntrl_0  [iw=dwt], row nofreq 	//by working status
	tab livingchild dv_prtnr_cntrl_0  [iw=dwt], row nofreq  	//by number of living children
	tab education 	dv_prtnr_cntrl_0  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_prtnr_cntrl_0  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' afraid dv_prtnr_cntrl_0 using Tables_DV_cntrl.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	*/

********************************************************************************

//TYPES OF SPOUSAL VIOLENCE (Tables_DV_prtnr)
	
	//physical violence by recent/current partner
		tab 	dv_prtnr_phy  			[iw=dwt], 
		tab 	dv_prtnr_phy_12m 		[iw=dwt],  
		tab 	dv_prtnr_phy_12m_f   	[iw=dwt],  

	* output to excel
	tabout dv_prtnr_phy dv_prtnr_phy_12m dv_prtnr_phy_12m_f  using Tables_DV_prtnr.xls [iw=dwt] , c(cell) oneway npos(col) nwt(dwt) f(1) replace 
	
	*/
	
	//types of violence
	foreach x in 	phy push slap twist punch kick choke weapon sex force force_act threat_act emot humil threat insult phy_sex_any phy_sex_emot_any {
		tab 	dv_prtnr_`x'  				[iw=dwt], 
		tab 	dv_prtnr_`x'_12m 			[iw=dwt],  
		tab 	dv_prtnr_`x'_12m_f   	[iw=dwt],  

	* output to excel
	tabout dv_prtnr_`x' dv_prtnr_`x'_12m dv_prtnr_`x'_12m_f  using Tables_DV_prtnr.xls [iw=dwt] , c(cell) oneway npos(col) nwt(dwt) f(1) append 
	}
	*/
	
	//physical violence by any partner
	foreach x in 	 phy sex emot phy_sex_any phy_sex_emot_any {
		tab 	dv_aprtnr_`x'  				[iw=dwt], 
		tab 	dv_aprtnr_`x'_12m 			[iw=dwt],  

	* output to excel
	tabout dv_aprtnr_`x' dv_aprtnr_`x'_12m  using Tables_DV_prtnr.xls [iw=dwt] , c(cell) oneway npos(col) nwt(dwt) f(1) append 
	}
	*/
	
	
	
	foreach x in 	phy sex emot phy_sex  phy_sex_emot phy_sex_any phy_sex_emot_any {
	tab dv_age 	  	dv_prtnr_`x'  [iw=dwt], row nofreq 	//by age
	tab residence 	dv_prtnr_`x'  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_prtnr_`x'  [iw=dwt], row nofreq 	//by region
	tab marital   	dv_prtnr_`x'  [iw=dwt], row nofreq  //by marital status
	tab work	  	dv_prtnr_`x'  [iw=dwt], row nofreq 	//by working status
	tab livingchild dv_prtnr_`x'  [iw=dwt], row nofreq  //by number of living children
	tab education 	dv_prtnr_`x'  [iw=dwt], row nofreq 	//by education
	tab wealth    	dv_prtnr_`x'  [iw=dwt], row nofreq 	//by wealth

	* output to excel
	tabout `subgroup' dv_prtnr_`x' using Tables_DV_prtnr.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	}
	*/

	
	//violence by empowerment indicators
	foreach x in 	phy sex emot phy_sex  phy_sex_emot phy_sex_any phy_sex_emot_any {
	tab husb_edu 			dv_prtnr_`x'  [iw=dwt], row nofreq 	//by husband's education
	tab husb_drink 			dv_prtnr_`x'  [iw=dwt], row nofreq	//by husband's alcohol consumption
	tab edu_diff    		dv_prtnr_`x'  [iw=dwt], row nofreq 	//by spousal education difference
	tab age_diff   			dv_prtnr_`x'  [iw=dwt], row nofreq  //by spousal age difference
	tab dv_prtnr_cntrl_cat	dv_prtnr_`x'  [iw=dwt], row nofreq 	//by marital control behaviors
	tab decisions 			dv_prtnr_`x'  [iw=dwt], row nofreq  //by decisions women participate in
	tab beating 			dv_prtnr_`x'  [iw=dwt], row nofreq 	//by reasons husband's beating is justified
	tab father_beat    		dv_prtnr_`x'  [iw=dwt], row nofreq 	//by father beat mother
	tab afraid	    		dv_prtnr_`x'  [iw=dwt], row nofreq 	//by fear of husband

	* output to excel
	tabout husb_edu husb_drink edu_diff age_diff dv_prtnr_cntrl_cat decisions beating ///
	father_beat afraid dv_prtnr_`x' using Tables_DV_prtnr.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	}
	*/
	
	//violence by any partner in last 12 months
	foreach x in 	phy sex emot phy_sex  phy_sex_emot phy_sex_any phy_sex_emot_any {
	tab dv_age 	  	dv_aprtnr_`x'_12m  [iw=dwt], row nofreq //by age
	tab residence 	dv_aprtnr_`x'_12m  [iw=dwt], row nofreq	//by residence 
	tab region    	dv_aprtnr_`x'_12m  [iw=dwt], row nofreq //by region
	tab marital   	dv_aprtnr_`x'_12m  [iw=dwt], row nofreq //by marital status
	tab work	  	dv_aprtnr_`x'_12m  [iw=dwt], row nofreq //by working status
	tab livingchild dv_aprtnr_`x'_12m  [iw=dwt], row nofreq //by number of living children
	tab education 	dv_aprtnr_`x'_12m  [iw=dwt], row nofreq //by education
	tab wealth    	dv_aprtnr_`x'_12m  [iw=dwt], row nofreq //by wealth

	* output to excel
	tabout `subgroup' dv_prtnr_`x'_12m using Tables_DV_prtnr.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	}
	*/

	//violence by duration of marriage
	foreach x in 	dv_mar_viol_0 dv_mar_viol_2 dv_mar_viol_5 dv_mar_viol_10 {
	tab mar_years 	  	`x'  [iw=dwt], row nofreq //by years of marriage

	* output to excel
	tabout mar_years `x' using Tables_DV_prtnr.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	}

	//injuries due to spousal violence
	foreach x in 		cuts injury broken injury_any {
	tab dv_phy 	  		dv_prtnr_`x'  [iw=dwt], row nofreq //by every experienced physical violence
	tab dv_phy_12m 	  	dv_prtnr_`x'  [iw=dwt], row nofreq //by every experienced physical violence
	tab dv_sex	  		dv_prtnr_`x'  [iw=dwt], row nofreq //by every experienced sexual violence
	tab dv_sex_12m 	  	dv_prtnr_`x'  [iw=dwt], row nofreq //by every experienced sexual violence in last 12 months
	tab dv_phy_sex_any	dv_prtnr_`x'  [iw=dwt], row nofreq //by every experienced physical OR sexual violence
	tab dv_phy_sex_any_12m 	dv_prtnr_`x'  [iw=dwt], row nofreq //by every experienced physical OR sexual violence in last 12 months

	* output to excel
	tabout dv_phy dv_phy_12m dv_sex dv_sex_12m dv_phy_sex_any dv_phy_sex_any_12m dv_prtnr_`x' using Tables_DV_prtnr.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	}

********************************************************************************

//INITIATE VIOLENCE AGAINST HUSBAND	
	foreach x in dv_abusedhus_phy dv_abusedhus_phy_12m {	
	tab dv_prtnr_phy `x' 	[iw=dwt], row nofreq 	//by ever experienced spousal physical violence 
	tab dv_prtnr_phy_12m `x' [iw=dwt], row nofreq 	//by experienced spousal physical violence in last 12 mos.
	tab dv_age 	  	`x'		[iw=dwt], row nofreq 	//by age
	tab residence 	`x'  	[iw=dwt], row nofreq	//by residence 
	tab region    	`x'  	[iw=dwt], row nofreq 	//by region
	tab marital   	`x'  	[iw=dwt], row nofreq    //by marital status
	tab work	  	`x'  	[iw=dwt], row nofreq    //by working status
	tab livingchild `x'  	[iw=dwt], row nofreq  	//by number of living children
	tab education 	`x'  	[iw=dwt], row nofreq 	//by education
	tab wealth    	`x'  	[iw=dwt], row nofreq 	//by wealth
	
	
	* output to excel
	tabout dv_prtnr_phy dv_prtnr_phy_12m `subgroup'  husb_edu husb_drink ///
			edu_diff age_diff dv_prtnr_cntrl_cat decisions beating father_beat ///
			afraid `x' using Tables_DV_prtnr.xls [iw=dwt] , c(row) npos(col) nwt(dwt) f(1) append 
	}
	*/
	
