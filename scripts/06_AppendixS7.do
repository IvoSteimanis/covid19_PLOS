*--------------------------------------------------------------------------
* SCRIPT: 06_AppendixS7.do
* PURPOSE:	1) Prepare Datasets
*				o Data from Microcensus
*				o Our Dataset
*			2) Fig. S5.	Age distribution: sample vs. census
*			3) Table S6.	Sample means vs. census data
*			4) Table S7.	Study sample vs. unvaccinated population
*--------------------------------------------------------------------------



*------------------------------------------------
* 1) Prepare Datasets
*------------------------------------------------
* Census Data

import excel "$working_ANALYSIS/data/alter_geschlecht_zensus_det.xlsx", sheet("12411-0013") cellrange(A5:CP54) firstrow clear
rename *, lower
drop if e == . // empty cell
drop unter1jahr-t // above 18

*** Adjust to our datapath
** Gender
replace gender = "male" if gender == "männlich"
replace gender = "female" if gender == "weiblich"
replace gender = "total" if gender == "Insgesamt"
lab define female1 0 "male" 1 "female" 99 "total"
encode gender, label(female1) gen(female)
drop gender

** For all Germany (Totals across counties)
foreach var in u v w x y z aa ab ac ad ae af ag ah ai aj ak al am an ao ap aq ar as at au av aw ax ay az ba bb bc bd be bf bg bh bi bj bk bl bm bn bo bp bq br bs bt bu bv bw bx by bz ca cb cc cd ce cf cg ch ci cj ck cl cm cn jahreundmehr {
egen age_`var' = total(`var'), by(female)
}
keep if county == "Berlin" // same across all counties

rename age_u age18
rename age_v age19
rename age_w age20
rename age_x age21
rename age_y age22
rename age_z age23
rename age_aa age24
rename age_ab age25
rename age_ac age26
rename age_ad age27
rename age_ae age28
rename age_af age29
rename age_ag age30
rename age_ah age31
rename age_ai age32
rename age_aj age33
rename age_ak age34
rename age_al age35
rename age_am age36
rename age_an age37
rename age_ao age38
rename age_ap age39
rename age_aq age40
rename age_ar age41
rename age_as age42
rename age_at age43
rename age_au age44
rename age_av age45
rename age_aw age46
rename age_ax age47
rename age_ay age48
rename age_az age49
rename age_ba age50
rename age_bb age51
rename age_bc age52
rename age_bd age53
rename age_be age54
rename age_bf age55
rename age_bg age56
rename age_bh age57
rename age_bi age58
rename age_bj age59
rename age_bk age60
rename age_bl age61
rename age_bm age62
rename age_bn age63
rename age_bo age64
rename age_bp age65
rename age_bq age66
rename age_br age67
rename age_bs age68
rename age_bt age69
rename age_bu age70
rename age_bv age71
rename age_bw age72
rename age_bx age73
rename age_by age74
rename age_bz age75
rename age_ca age76
rename age_cb age77
rename age_cc age78
rename age_cd age79
rename age_ce age80
rename age_cf age81
rename age_cg age82
rename age_ch age83
rename age_ci age84
rename age_cj age85
rename age_ck age86
rename age_cl age87
rename age_cm age88
rename age_cn age89
rename age_jahreundmehr age90
*egen age70_above = rowtotal(age70 - age90)

** Calculate share of pop
* Total
egen total = rowtotal(age18 - age70)
* Share of group of total

forvalues i = 18/90 {
gen share`i' = age`i' / total
}

*age70_above 
*rename age70_above age70
drop u - insgesamt
drop county
save "$working_ANALYSIS/data/census_raw.dta", replace


*keep female age18 age19 age20 age21 age22 age23 age24 age25 age26 age27 age28 age29 age30 age31 age32 age33 age34 age35 age36 age37 age38 age39 age40 age41 age42 age43 age44 age45 age46 age47 age48 age49 age50 age51 age52 age53 age54 age55 age56 age57 age58 age59 age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 age70 




** Cumulative Share
order female total share*
gen number_cum18=share18
forvalues i = 19/70 {
egen number_cum`i'=rowtotal(share18-share`i')
}

reshape long age share number_cum, i(female)
rename age population
rename _j age

* Dataset
gen data = 2
save "$working_ANALYSIS/processed/census_clean.dta", replace




*------------------------------------------------
* Adjust our data to census data
*------------------------------------------------
use "$working_ANALYSIS/processed/corona_ger_clean.dta", clear
keep if wave == 1 // only for first wave

* Sum in age across gender
*replace age = 70 if age >= 70 // if full age distribution

drop if age > 70
gen population = 1
collapse (sum) population, by(age female)
sort female age

** Calculate share of pop
* Total
egen total = total(population), by(female)

* Share of group of total
gen share = population/total

save "$working_ANALYSIS/processed/rep_data.dta", replace


*** Total Across Gender
use "$working_ANALYSIS/processed/corona_ger_clean.dta", clear
keep if wave == 1 // only for first wave

* Sum in age across gender
*replace age = 70 if age >= 70 // if full age distribution

drop if age > 70

* Replace Female = Total
drop female
generate female = 99


* Sum in age group across sample
gen population = 1
collapse (sum) population, by(age female)
sort female age

** Calculate share of pop
* Total
egen total = total(population), by(female)

* Share of group of total
gen share = population/total

save "$working_ANALYSIS/processed/rep_data1.dta", replace


*** Apepend to devision by gender
use "$working_ANALYSIS/processed/rep_data.dta", clear
append using "$working_ANALYSIS/processed/rep_data1.dta"

*** Reshape to wide
reshape wide population share, i(female) j(age)

** Cumulative Share
order female total population* share*
gen number_cum18=share18
forvalues i = 19/70 {
egen number_cum`i'=rowtotal(share18-share`i')
}

reshape long population share number_cum, i(female)
rename _j age

*** Dataset
gen data = 1
append using "$working_ANALYSIS/processed/census_clean.dta"

lab define data1 1 "Own Sample" 2 "Census"
lab val data data1

lab define female1 0 "male" 1 "female" 99 "total", replace
lab val female female1
order data total female population* share*

drop if age > 70


save "$working_ANALYSIS/processed/rep.dta", replace



*---------------------------------------------------
* 2) Fig. S5.	Age distribution: sample vs. census
*---------------------------------------------------

*******
* Female
****
use "$working_ANALYSIS/processed/rep.dta", clear
keep if female == 1
*reshape long number_cum share population, i(data)
replace number_cum = 1 if number_cum >= .999999
*rename _j age_group


* Cumulative Distribution Function
twoway ///
(line number_cum age if data==1 , ) /// Our Sample
(line number_cum age if data==2 , ) /// Germany
, xtitle("Age (in years)") ytitle("Cumulative distribution function") ///
title("Female") ///
xlabel(18 "18" 30 "30" 40 "40" 50 "50" 60 "60" 70 "70", angle(0)) ///
legend(order(1 "Our Sample (Age 18-70)" 2 "Germany (Age 18-70)" ) position(5) ring(0) row())
graph save "$working_ANALYSIS/results/intermediate/rep_female_cdi", replace


*******
* Male
****
use "$working_ANALYSIS/processed/rep.dta", clear
keep if female == 0
*reshape long number_cum share population, i(data)
replace number_cum = 1 if number_cum >= .999999
*rename _j age_group

* Cumulative Distribution Function
twoway ///
(line number_cum age if data==1 , ) /// Our Sample
(line number_cum age if data==2 , ) /// Germany
, xtitle("Age (in years)") ytitle("") ///
title("Male") ///
xlabel(18 "18" 30 "30" 40 "40" 50 "50" 60 "60" 70 "70", angle(0)) ///
legend(order(1 "Our Sample (Age 18-70)" 2 "Germany (Age 18-70)" ) position(5) ring(0) )
graph save "$working_ANALYSIS/results/intermediate/rep_male_cdi", replace


*******
* Total
****
use "$working_ANALYSIS/processed/rep.dta", clear
keep if female == 99
replace number_cum = 1 if number_cum >= .999999

* Cumulative Distribution Function
twoway ///
(line number_cum age if data==1 , ) /// Our Sample
(line number_cum age if data==2 , ) /// Germany
, xtitle("Age (in years)") ytitle("") ///
title("Total") ///
xlabel(18 "18" 30 "30" 40 "40" 50 "50" 60 "60" 70 "70", angle(0)) ///
legend(order(1 "Our Sample (Age 18-70)" 2 "Germany (Age 18-70)" ) position() ring() rows(1) )
graph save "$working_ANALYSIS/results/intermediate/rep_total_cdi", replace


grc1leg "$working_ANALYSIS/results/intermediate/rep_female_cdi" "$working_ANALYSIS/results/intermediate/rep_male_cdi" "$working_ANALYSIS/results/intermediate/rep_total_cdi", title() rows(1) legendfrom("$working_ANALYSIS/results/intermediate/rep_female_cdi") xsize(7.5)
gr_edit .plotregion1.graph1.plotregion1.plot1.style.editstyle line(color("220 38 127")) editcopy
gr_edit .plotregion1.graph2.plotregion1.plot1.style.editstyle line(color("220 38 127")) editcopy
gr_edit .plotregion1.graph3.plotregion1.plot1.style.editstyle line(color("220 38 127")) editcopy
gr_edit .legend.Edit, style(labelstyle(size(vsmall))) style(labelstyle(color(custom)))
gr_edit .legend.plotregion1.key[1].view.style.editstyle line(color("220 38 127")) editcopy
gr_edit .plotregion1.graph1.title.style.editstyle size(small) editcopy
gr_edit .plotregion1.graph2.title.style.editstyle size(small) editcopy
gr_edit .plotregion1.graph3.title.style.editstyle size(small) editcopy
graph save "$working_ANALYSIS/results/intermediate/figureS5_age_distribution.gph", replace
graph export "$working_ANALYSIS/results/figures/figureS5_age_distribution.tif", replace width(4500)



*---------------------------------------------------
* 3) Table S6.	Sample means vs. census data
*---------------------------------------------------

*** Our Sample
use "$working_ANALYSIS/processed/corona_ger_clean.dta", clear
keep if wave == 1 // only for first wave

** Gen: Household Size
gen hh_member = hh_member_0_14 + hh_member_14_99
gen hh_member_cat = hh_member
replace hh_member_cat = 4 if hh_member>=4
tab hh_member_cat, gen(hh_member)

** Gen Education
gen abitur = 0
replace abitur = 1 if edu >= 3 // Abitur / Uni abschluss
 
** Summarize
sum age female if age <= 70 
sum abitur hh_member1 hh_member2 hh_member3 hh_member4 hh_member5 


*** Germany
** Age
use "$working_ANALYSIS/data/census_raw.dta", clear
reshape long age share , i(female)
rename age population
rename _j age

gen weighted_age = age*share
egen average_age = total(weighted_age) if age < 90, by(female) // 61.05
egen average_age_70 = total(weighted_age) if age<=70, by(female) // 45.03

** Gender
egen total_female = total(population) if age<=70, by(female)
display 28252814 / 56960324

** Household Size
/*
Data From Statistisches Bundesamt:
https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Haushalte-Familien/Tabellen/1-2-privathaushalte-bundeslaender.html
*/

clear
input households single total_shared shared2 shared3 shared4 shared5 hh_member member_per_hh
40545 16476 24069 13778	4915 3970 1407 82181 2.03
end

gen share_single = single / households
foreach var in shared2 shared3 shared4 shared5 {
gen share_`var' = `var'/ households
}

** Education
/*
From: https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Migration-Integration/Tabellen/migrationshintergrund-schulabschluss.html
Fochhochschulreife: 5850
Abitur: 19063
Gesamt: 81870
*/
display (5850 + 19063) / 81870





*---------------------------------------------------
* 4) Table S7.	Study sample vs. unvaccinated population
*---------------------------------------------------

*Extracting vaccination numbers

*import delimited "https://raw.githubusercontent.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland/master/Aktuell_Deutschland_Landkreise_COVID-19-Impfungen.csv" , clear ///we don't have to download it ever time again
*save "$datapath\vaccination_landkreis_raw.dta", replace

use"$working_ANALYSIS/data/vaccination_landkreis_raw.dta", clear // for your convenience the dataset is already stored in the replication package
rename landkreisid_impfort AGS
drop if AGS == "u"
destring AGS, replace
lab var AGS "Amtlichen Gemeindeschluessel"

drop if altersgruppe == "12-17" | altersgruppe == "u"

gen group_id = 1 if altersgruppe == "18-59"
replace group_id = 2 if altersgruppe == "60+"
replace group_id = 3 if altersgruppe == "12-17"

gen date = date(impfdatum, "YMD")
format date %td
drop if date > date("20210602","YMD") //select here the time horizen you want to count. In this case, we only need vaccination numbers until 2021-06-02

gen temp = (AGS*10+impfschutz)*10+group_id //to create an id for wide transformation
drop impfdatum
reshape wide anzahl, i(temp) j(date)
egen no_vaccinations = rowtotal(anzahl22276 - anzahl22433) //add last anzahl*date combination
reshape long anzahl, i(temp) j(date)
format date %td
drop temp

keep if date == date("20210602","YMD") //the cut-off we are interested in
keep if impfschutz == 1 //all first dose vaccinations (2=fully vaccinated, 3=refresh)

drop anzahl altersgruppe
reshape wide no_vaccinations, i(group_id) j(AGS)
egen no_vacc_age = rowtotal(no_vaccinations1001-no_vaccinations17000) //check if it is the sum over all variables!!
keep group_id no_vacc_age date

rename group_id age_group
lab define age_l 1 "18-59" 2 "60+"
lab value age_group age_l

save "$working_ANALYSIS/processed/no_vacc_age_Mai.dta", replace


*Population of Germany (>=18 years)

import delimited "$working_ANALYSIS/data/census2020_age_gender.csv", delimiter(";") varnames(8) clear //source: https://www-genesis.destatis.de/
gen date = date(v1, "DMY")
format date %td
drop v1 deutsche ausländer
rename insgesamt population
rename v2 age_lable
order date population

gen age = _n
replace age = age-1
egen age_population1 = total(population) if age<18
egen age_population2 = total(population) if age>=18 & age<=59
egen age_population3 = total(population) if age>=60 & age<=85
egen age_population = rowtotal(age_population1 age_population2 age_population3)
drop age_population1 age_population2 age_population3

gen age_group = 0 if age<18
replace age_group = 1 if age>=18 & age<=59
replace age_group = 2 if age>=60 & age<=85
lab define age_l 0 "0-17" 1 "18-59" 2 "60+"
lab value age_group age_l

drop if age_group == .
bysort age_group: gen first = _n
keep if first == 1

egen pop_total = total(age_population) //83155024

keep date age_group age_population
compress

save "$working_ANALYSIS/processed/census_age_population.dta", replace


use "$working_ANALYSIS/processed/census_age_population.dta", clear
drop if age_group == 0

merge 1:1 age_group using "$working_ANALYSIS/processed/no_vacc_age_Mai.dta"
drop _merge
order date age_group age_population no_vacc_age

gen vacc_share_age = no_vacc_age / age_population
lab var vacc_share_age "Percentage of vaccinated people per age group"
gen no_unvacc_age = age_population - no_vacc_age
lab var no_unvacc_age "Number of unvaccinated people per age group"

egen total_unvacc_pop_age = total(no_unvacc_age)
gen share_unvacc_age = no_unvacc_age/total_unvacc_pop_age

/*		population	vccinated	Percent
18-59	45321312	18044528	.39814663
60+		24089772	18390390	.76341069
					--------	--------
					32976166	1.0

					
*Unvaccinated Population of Germany (>=18 years)
				
		population	unvccinated	Percent
18-59	45321312	27276784	.82716662
60+		24089772	5699382		.17283337
					--------	--------
					32976166	1.0				*/


//Our sample

use "$working_ANALYSIS/processed/corona_ger_clean.dta", clear
keep if wave==1
gen population = 1
collapse (sum) population, by(age)
sort age

egen total_pop = total(population)
egen age_population2 = total(population) if age>=18 & age<=59
egen age_population3 = total(population) if age>=60 & age<=85
egen age_population = rowtotal( age_population2 age_population3)
drop age_population2 age_population3

gen age_group = 1 if age>=18 & age<=59
replace age_group = 2 if age>=60 & age<=85
lab define age_l 0 "0-17" 1 "18-59" 2 "60+"
lab value age_group age_l
bysort age_group: gen first = _n
keep if first == 1

gen age_pop_share = age_population/total_pop
keep age_group age_population age_pop_share
order age_group age_population age_pop_share

/*		unvccinated		Percent
18-59	1121			.8466768
60+		203				.1533233
		---------		---------
		1324			1.0
		*/




		
** EOF