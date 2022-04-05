*---------------------------------*
*---------- G R A P H S ----------*
*---------------------------------*

cd "$root"
use stateleveldatabase_paper1_data2019_clean

*Graph: FLP and share of the employment in the agricultural sector in Mexican States
twoway (scatter flp_rate2019 pct_employ_agri_2019, msize(vsmall) mlabel(state_abrev) mlabsize(vsmall) mlabposition(12)) (qfit flp_rate2019 pct_employ_agri_2019), legend(off) ///
ytitle(Female Labor Participation Rate) ytitle(, size(vsmall)) ylabel(, labsize(vsmall)) ///
xtitle(Share of the employment in the agricultural sector) xtitle(, size(vsmall)) xlabel(, labsize(vsmall)) ///
title(Female Labor Participation and Share of the Employment in the Agricultural Sector (2019), size(small)) /// 
subtitle(Made by Isaac López-Moreno, size(vsmall))
graph export "$root\flp_agri_mexico_2019.png", replace

*Graph: FLP and share of the employment in the industrial sector in Mexican States
twoway (scatter flp_rate2019 pct_employ_ind_2019, msize(vsmall) mlabel(state_abrev) mlabsize(vsmall) mlabposition(12)) (qfit flp_rate2019 pct_employ_ind_2019), legend(off) /// 
ytitle(Female Labor Participation Rate) ytitle(, size(vsmall)) ylabel(, labsize(vsmall)) ///
xtitle(Share of the employment in the industrial sector) xtitle(, size(vsmall)) xlabel(, labsize(vsmall)) /// 
title(Female Labor Participation and Share of the Employment in the Industrial Sector (2019), size(small)) ///
subtitle(Made by Isaac López-Moreno, size(vsmall))
graph export "$root\flp_ind_mexico_2019.png", replace

*Graph: FLP and share of the employment in the service sector in Mexican States
twoway (scatter flp_rate2019 pct_employ_serv_2019, msize(vsmall) mlabel(state_abrev) mlabsize(vsmall) mlabposition(12)) (qfit flp_rate2019 pct_employ_serv_2019), legend(off) /// 
ytitle(Female Labor Participation Rate) ytitle(, size(vsmall)) ylabel(, labsize(vsmall)) /// 
xtitle(Share of the employment in the service sector) xtitle(, size(vsmall)) xlabel(, labsize(vsmall)) /// 
title(Female Labor Participation and Share of the Employment in the Service Sector (2019), size(small)) /// 
subtitle(Made by Isaac López-Moreno, size(vsmall))
graph export "$root\flp_serv_mexico_2019.png", replace




cd "$root"
use worldbankdata_employment_agri_ind_serv_flp_2019

rename employ_agri_2019 agri_employ_2019
rename employ_ind_2019 ind_employ_2019
rename employ_serv_2019 serv_employ_2019


*Graph: FLP and share of the employment in the agricultural sector ACROSS COUNTRIES (2019)
twoway (scatter flpr_2019 agri_employ_2019, msize(tiny) mlabel(country_code) mlabsize(tiny) mlabposition(12)) (qfit flpr_2019 agri_employ_2019), legend(off) ///
ytitle(Female Labor Participation Rate) ytitle(, size(vsmall)) ylabel(, labsize(vsmall)) ///
xtitle(Share of the employment in the agricultural sector) xtitle(, size(vsmall)) xlabel(, labsize(vsmall)) ///
title(Female Labor Participation and Share of the Employment in the Agricultural Sector across countries (2019), size(small)) /// 
subtitle(Made by Isaac López-Moreno, size(vsmall))
graph export "$root\flp_agri_countries_2019.png", replace

*Graph: FLP and share of the employment in the industrial sector ACROSS COUNTRIES (2019)
twoway (scatter flpr_2019 ind_employ_2019, msize(tiny) mlabel(country_code) mlabsize(tiny) mlabposition(12)) (qfit flpr_2019 ind_employ_2019), legend(off) ///
ytitle(Female Labor Participation Rate) ytitle(, size(vsmall)) ylabel(, labsize(vsmall)) ///
xtitle(Share of the employment in the industrial sector) xtitle(, size(vsmall)) xlabel(, labsize(vsmall)) ///
title(Female Labor Participation and Share of the Employment in the Industrial Sector across countries (2019), size(small)) /// 
subtitle(Made by Isaac López-Moreno, size(vsmall))
graph export "$root\flp_ind_countries_2019.png", replace

*Graph: FLP and share of the employment in the service sector ACROSS COUNTRIES (2019)
twoway (scatter flpr_2019 serv_employ_2019, msize(tiny) mlabel(country_code) mlabsize(tiny) mlabposition(12)) (qfit flpr_2019 serv_employ_2019), legend(off) ///
ytitle(Female Labor Participation Rate) ytitle(, size(vsmall)) ylabel(, labsize(vsmall)) ///
xtitle(Share of the employment in the service sector) xtitle(, size(vsmall)) xlabel(, labsize(vsmall)) ///
title(Female Labor Participation and Share of the Employment in the Service Sector across countries (2019), size(small)) /// 
subtitle(Made by Isaac López-Moreno, size(vsmall))
graph export "$root\flp_serv_countries_2019.png", replace
