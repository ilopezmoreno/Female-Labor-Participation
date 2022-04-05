***** Probit Regressions *****

* Notes: 
* The double hashtag symbol "##" asks Stata to run a regression using the two variables but also an interaction term using both variables.
* The single hashtag symbol "#" asks Stata to run a regression using the square value of the variable "eda", which means "age". 
* vce (robust) asks Stata to report robust standard errors 
* "margins" command asks Stata to show the predicted probability of being part of the economically active population for each scenario.
* "atmeans" indicates stata to show the predicted probability of an specific variable holding the other variable at their means

* Base category explanation
* ib(1).educ = In the variable "educ" (which shows the level of education) I will use as a base category option 1: having just elementary school or less
* ib(6).e_con = In the variable "e_con" (which shows the marital) I will use as a base category option 6: being single 
* ib(1).hij5c = In the variable "hij5c" (which shows the number of kids) I will use as a base category option 1: no kids
* ib(none). =  In the variables where I use this command, I'm indicating stata that I don't want to use any option as a base category. 
* In order to work, I need to indicate at the end of the regression that I dont a constant term. Therefore, I need to indicate "noconstant"
* c.eda = "c." indicates stata that the variable "age" is a continous variable.
* i.educ = "i" indicates stata that the variable "educ" is a categorical variable.


* In this regression, I want to know the probability of being part of the economically active population 
* Depending on the sex and the population size of the locality where the respondent lives. 
probit clase1 female##t_loc c.eda#c.eda ib(1).educ ib(6).e_con [fweight=fac], vce (robust) 
margins female, at(t_loc=(1(1)4)) atmeans vsquish
marginsplot, ///
title("Predicted probability of men and woman working, depending on the population size of the locality in which they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Population Size") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_sex_tloc.png", replace
graph save Graph "$root\prob_sex_tloc.gph", replace

 

* In this regression, I want to know the probability of being part of the economically active population only for WOMEN
* Dependent on the population size of the locality where the respondent lives.
probit clase1 ib(none).t_loc c.eda#c.eda ib(1).educ ib(6).e_con if female==1, vce (robust) noconstant
margins t_loc, atmeans vsquish
marginsplot, ///
title("Predicted probability of a woman working, depending on the population size of the locality in which they live. ") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Population Size") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) 
graph export "$root\prob_women_tloc.png", replace
graph save Graph "$root\prob_women_tloc.gph", replace


* In this regression, I want to know the probability of being part of the economically active population only for MEN
* Dependent on the population size of the locality where the respondent lives.
probit clase1 ib(none).t_loc if male==1, vce (robust) noconstant
margins t_loc
marginsplot, ///
title("Predicted probability of a man working, depending on the population size of the locality in which they live. ") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Population Size") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall))
graph export "$root\prob_men_tloc.png", replace
graph save Graph "$root\prob_men_tloc.gph", replace



* In this regression, I want to know the probability of being part of the economically active population only for WOMEN
* Dependent on the population size of the locality where the respondent lives and the age of the respondent. 
probit clase1 ib(none).t_loc c.eda##c.eda if female==1, vce (robust) noconstant
margins t_loc, at(eda=(15(1)80)) atmeans vsquish
* The graph will indicate the predicted probability of working women considering their age & population size of their locality.
marginsplot, ///
title("Predicted probability of a woman working, depending on their age and the population size of the locality in which they live. ") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Age") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) ///
legend(size(vsmall))
graph export "$root\prob_women_tloc_age.png", replace
graph save Graph "$root\prob_women_tloc_age.gph", replace



* In this regression, I want to know the probability of being part of the economically active population for MEN & WOMEN
* Dependent on the age of the respondent. 
probit clase1 i.female##c.eda c.eda#c.eda, vce (robust)
margins female, at(eda=(20(5)90)) vsquish
* The graph will indicate the predicted probability of working for men & women considering their age 
marginsplot, ///
title("Predicted probability of men and woman working, depending on their age.") title(,size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(small)) ///
xtitle("Age") xtitle(, size(small)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) ///
legend(size(vsmall))
graph export "$root\prob_sex_age.png", replace
graph save Graph "$root\prob_sex_age.gph", replace



* In this regression, I want to know the probability of being part of the economically active population 
* depending on the percentage of agricultural jobs in the municipality where they live
probit clase1 female##c.pct_agri_employ c.eda##c.eda ib(1).educ ib(6).e_con if eda>=16, vce (robust) 
//**** margins, dydx(*) atmeans post
margins female, at(pct_agri_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of men and woman working, depending on the percentage of agricultural jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of agricultural jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_agri.png", replace
graph save Graph "$root\prob_pct_agri.gph", replace


* In this regression, I want to know the probability of being part of the economically active population 
* depending on the percentage of agricultural jobs in the municipality where they live
 probit clase1 female##c.pct_agri_employ c.eda##c.eda ib(1).educ ib(6).e_con ib(1).hij5c if female==1 & eda>=16, vce (robust) 
//**** margins, dydx(*) atmeans post
margins female, at(pct_agri_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of a woman working, depending on the percentage of agricultural jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of agricultural jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_agri_women.png", replace
graph save Graph "$root\prob_pct_agri_women.gph", replace



* In this regression, I want to know the probability of being part of the economically active population 
* depending on the percentage of industrial jobs in the municipality where they live. 
probit clase1 female##c.pct_ind_employ c.eda##c.eda ib(1).educ ib(6).e_con if eda>=16, vce (robust) 
//**** margins, dydx(*) atmeans post
margins female, at(pct_ind_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of men and woman working, depending on the percentage of industrial jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of industrial jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_ind.png", replace
graph save Graph "$root\prob_pct_ind.gph", replace



* In this regression, I want to know the probability of being part of the economically active population 
* depending on the percentage of service jobs in the municipality where they live
probit clase1 female##c.pct_serv_employ c.eda##c.eda ib(1).educ ib(6).e_con if eda>=16, vce (robust) 
//**** margins, dydx(*) atmeans post
margins female, at(pct_serv_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of men and woman working, depending on the percentage of service jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of service jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_serv.png", replace
graph save Graph "$root\prob_pct_serv.gph", replace



* In this regression, I want to know the probability of being part of the economically active population ONLY FOR WOMEN
* depending on the percentage of agricultural jobs in the municipality where they live and the number of kids
probit clase1 ib(none).hij5c c.pct_agri_employ c.eda##c.eda ib(1).educ ib(6).e_con if female==1 & eda>=16, vce (robust) noconstant
margins hij5c, at(pct_agri_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of a woman working, depending on the number of kids & the percentage of agricultural jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of agricultural jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_agri_kids.png", replace
graph save Graph "$root\prob_pct_agri_kids.gph", replace



* In this regression, I want to know the probability of being part of the economically active population 
* depending on the percentage of agricultural jobs in the municipality where they live and the marital status
probit clase1 ib(none).e_con c.pct_agri_employ c.eda##c.eda ib(1).educ ib(1).hij5c if female==1 & eda>=16, vce (robust) noconstant
//**** margins, dydx(*) atmeans post
margins e_con, at(pct_agri_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of a woman working, depending on the percentage of agricultural jobs in the municipality where they live & the marital status.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of agricultural jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_agri_marital.png", replace
graph save Graph "$root\prob_pct_agri_marital.gph", replace



* In this regression, I want to know the probability of being part of the economically active population 
* depending on the percentage of agricultural jobs in the municipality where they live and the educational level
probit clase1 ib(none).educ c.pct_agri_employ c.eda##c.eda ib(6).e_con ib(1).hij5c if female==1 & eda>=16, vce (robust) noconstant
margins educ, at(pct_agri_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of men and woman working, depending on their education level & the percentage of agricultural jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of agricultural jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_agri_educ.png", replace
graph save Graph "$root\prob_pct_agri_educ.gph", replace



* In this regression, I want to know the probability of being part of the economically active population 
* depending on the age of the respondent and the percentage of agricultural jobs in the municipality where they live 
probit clase1 ib(none).employ_share_agri c.eda##c.eda if female==1 & eda>=16, vce (robust) noconstant
//**** margins, dydx(*) atmeans post
margins employ_share_agri, at(eda=(16(4)80)) vsquish
marginsplot, ///
title("Predicted probability of a woman working, depending on her age and the percentage of agricultural jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Age") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_agrishare_age.png", replace
graph save Graph "$root\prob_agrishare_age.gph", replace


* In this regression, I want to know the probability of being part of the economically active population 
* depending on the percentage of industrial jobs in the municipality where they live. 
probit clase1 female##c.pct_ind_employ c.eda##c.eda female##est ib(40).est i.ent ib(1).educ ib(6).e_con if eda>=16, vce (robust) 
//**** margins, dydx(*) atmeans post
margins female, at(pct_ind_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of men and woman working, depending on the percentage of industrial jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of industrial jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_ind.png", replace
graph save Graph "$root\prob_pct_ind.gph", replace



* In this regression, I want to know the probability of being part of the economically active population 
* depending on the percentage of service jobs in the municipality where they live
probit clase1 female##c.pct_serv_employ c.eda##c.eda female##est ib(40).est i.ent ib(1).educ ib(6).e_con if eda>=16, vce (robust) 
//**** margins, dydx(*) atmeans post
margins female, at(pct_serv_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of men and woman working, depending on the percentage of service jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of service jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_serv.png", replace
graph save Graph "$root\prob_pct_serv.gph", replace



* In this regression, I want to know the probability of being part of the economically active population 
* depending on the percentage of agricultural jobs in the municipality where they live
probit clase1 female##c.pct_agri_employ c.eda##c.eda female##est ib(40).est i.ent ib(1).educ ib(6).e_con if eda>=16, vce (robust) 
//**** margins, dydx(*) atmeans post
margins female, at(pct_agri_employ=(0(5)100)) atmeans vsquish
marginsplot, ///
title("Predicted probability of men and woman working, depending on the percentage of agricultural jobs in the municipality where they live.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Percentage of agricultural jobs in the municipality where they live") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_agri.png", replace
graph save Graph "$root\prob_pct_agri.gph", replace



* In this regression I want to test the hypothesis that married women are less likely to work in the industrial sector compared to non-married women. 
probit w_job_ind ib(none).e_con c.eda#c.eda ib(1).educ ib(1).hij5c ib(10).est [fweight=fac], vce (robust) noconstant
margins e_con, at(eda=(18(1)65)) atmeans vsquish
marginsplot, ///
title("Predicted probability of a woman working in the industrial sector, depending on the marital status.") title(, size(vsmall)) ///
ytitle("Predicted probability") ytitle(, size(vsmall)) ///
xtitle("Age") xtitle(, size(vsmall)) ///
ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) /// 
legend(size(vsmall))
graph export "$root\prob_pct_agri_marital.png", replace
graph save Graph "$root\prob_pct_agri_marital.gph", replace
