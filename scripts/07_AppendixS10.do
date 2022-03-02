*--------------------------------------------------
* SCRIPT: 07_AppendixS10.do
* PURPOSE: External validity - vaccination rates in sample compared to German average
*--------------------------------------------------

*Data Preperation

*Vaccination rate in our sample
use "$working_ANALYSIS/processed/corona_ger_clean.dta", clear
keep if wave==2
keep wave vaccinated treatment
bysort treatment: gen N = _n
bysort treatment: egen treatment_sample = max(N)
bysort treatment: egen treatment_vaccinated = total(vaccinated) //141 139 152 125
gen vacc_share_experiment = treatment_vaccinated / treatment_sample
keep if N==1

bysort treatment: gen vacc_share_experiment2 = treatment_vaccinated/treatment_sample
gen unvacc_likelihood_experiment = 1-vacc_share_experiment

gen date = date("20210602","YMD") //technically the correct date is Sep. 18, yet it's easier to program like this
format date %td

keep date treatment unvacc_likelihood_experiment
reshape wide unvacc_likelihood_experiment, i(date) j(treatment)
rename unvacc_likelihood_experiment0 unvacc_control
rename unvacc_likelihood_experiment1 unvacc_debunk
rename unvacc_likelihood_experiment2 unvacc_benefits
rename unvacc_likelihood_experiment3 unvacc_facilitation
save "$working_ANALYSIS/processed/unvacc_share_experiment", replace


*import delimited "https://raw.githubusercontent.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland/master/Aktuell_Deutschland_Landkreise_COVID-19-Impfungen.csv" , clear //we don't have to download it ever time again (15.12.2021)
*save "$datapath\vaccination_landkreis_raw.dta", replace
use "$working_ANALYSIS/data/vaccination_landkreis_raw.dta", clear //so that we don't have to always download the data

rename landkreisid_impfort AGS
drop if AGS == "u"
destring AGS, replace
lab var AGS "Amtlichen Gemeindeschluessel"

drop if altersgruppe == "u"
drop if altersgruppe == "12-17" //we are only interested in people 18+ years old
keep if impfschutz == 1 //all first dose vaccinations (2=fully vaccinated, 3=refresh)

gen age_group = 1 if altersgruppe == "18-59"
replace age_group = 2 if altersgruppe == "60+"
replace age_group = 3 if altersgruppe == "12-17"

gen date = date(impfdatum, "YMD")
format date %td

*drop if date > date("20210918","YMD") //select here the time horizen you want to count. The last survey was completed on 2021-09-18.

bysort age_group (date): gen cum_vaccines_AGS = sum(anzahl)
bysort age_group date: egen cum_daily_vaccines = max(cum_vaccines_AGS)
bysort age_group date: gen first = _n
keep if first == 1
keep date age_group cum_daily_vaccines
order date age_group cum_daily_vaccines
sort date age_group cum_daily_vaccines

gen vaccines_last_day = cum_daily_vaccines if date==date("20210918","YMD")
egen cum_vaccines = total(vaccines_last_day) //51,093,100 (inclduing 12-17 year olds: 52,850,700)

save "$working_ANALYSIS/processed/cum_daily_vaccination", replace
use "$working_ANALYSIS/processed/cum_daily_vaccination", clear

merge m:1 age_group using "$working_ANALYSIS/processed/census_age_population.dta"
keep if _merge == 3
sort date
bysort date: egen total_population = total(age_population)

rename cum_daily_vaccines cum_daily_vaccines_age
bysort date: egen cum_daily_vaccines = total(cum_daily_vaccines_age)
bysort date: gen first = _n
keep if first == 1

keep date cum_daily_vaccines total_population

gen vacc_share = cum_daily_vaccines/total_population //vaccination rate here is 74% for the total population (incl. 0-17 years) it is 64%
gen unvacc_likelihood = 1-vacc_share

gen unvacc_likelihood_start = unvacc_likelihood if date==date("20210602","YMD")
gen unvacc_likelihood_end = unvacc_likelihood if date==date("20210918","YMD")
egen unvacc_likelihood_germany = rowtotal(unvacc_likelihood_start unvacc_likelihood_end)
replace unvacc_likelihood_germany = . if unvacc_likelihood_germany == 0


merge 1:1 date using "$working_ANALYSIS/processed/unvacc_share_experiment"
keep date unvacc_likelihood unvacc_likelihood_start unvacc_likelihood_end unvacc_likelihood_germany unvacc_control unvacc_debunk unvacc_benefits unvacc_facilitation

foreach x in unvacc_control unvacc_debunk unvacc_benefits unvacc_facilitation {
	replace `x' = `x' * unvacc_likelihood
	egen  `x'_end = max(`x')
	replace `x'_end = . if date!=date("20210918","YMD")
	replace `x' = `x'_end if date==date("20210918","YMD")
	replace `x' = unvacc_likelihood if date==date("20210602","YMD")
}

keep date unvacc_likelihood unvacc_likelihood_germany unvacc_control unvacc_debunk unvacc_benefits unvacc_facilitation

save "$working_ANALYSIS/processed/cum_daily_vaccination_figures", replace


*Fig a) Share of unvaccinated over time
use "$working_ANALYSIS/processed/cum_daily_vaccination_figures", clear
drop if date<date("20210501","YMD")
drop if date>=date("20211101","YMD")

twoway (scatter unvacc_likelihood date, connect(L) ms(none) xline(22433, lpattern(dash)) xline(22541, lpattern(dash))) ///
	(scatter unvacc_control date, connect(L) ms(none) ) ///
	(scatter unvacc_debunk date, connect(L) ms(none) ) ///
	(scatter unvacc_benefits date, connect(L) ms(none) ) ///
	(scatter unvacc_facilitation date, connect(L) ms(none) ), legend(order(1 "Germany" 2 "C: Control" 3 "T1: Debunking" 4 "T2: Benefits" 5 "T3: Facilitation") pos(2) cols(1) ring(0)) ytitle("Unvaccination rate (18 yeras and older)") xtitle("") title("{bf:A } Unvaccination rate Germany", pos(11) span) 
graph save "$working_ANALYSIS/results/intermediate/FigureS10_a", replace

	


*Fig b) Likellihood of getting vaccinated

use "$working_ANALYSIS/processed/corona_ger_clean.dta", clear
keep if wave==2

cibar vaccinated, over(treatment)   graphopts(graphregion(fcolor(none)) yline(.40269291, lpattern(dash) lcolor(gray) ) text(.40269291 4.8 "German   average", orientation(vertical) size(small) color(gray) ) ylab(0(0.1)1) legend(pos(2) ring(0) cols(1)) ytitle("Likellihood of getting vaccinated") title("{bf:B } Likelihood of getting vaccinated", pos(11) span) ) 
graph save "$working_ANALYSIS/results/intermediate/FigureS10_b", replace


graph combine "$working_ANALYSIS/results/intermediate/FigureS9_a" "$working_ANALYSIS/results/intermediate/FigureS9_b", row(1) xsize(7.5)
gr_edit .plotregion1.graph1.legend.xoffset = 4
gr_edit .plotregion1.graph1.yoffset = -1
gr_edit .plotregion1.graph1.title.yoffset = 1
gr save "$working_ANALYSIS/results/intermediate/FigureS10_external_validity.gph", replace
gr export "$working_ANALYSIS/results/figures/FigureS10_external_validity.tif", replace width(4500)





** EOF