*--------------------------------------------------------------------------------------
* SCRIPT: 1_3_merge_generate.do
* PURPOSE: merges the cleaned data from both waves and generates additional variables
*--------------------------------------------------------------------------------------

*----------------------------
* 1. APPEND DATA & PREPARE PANEL DATA

use  "$working_ANALYSIS/processed/corona_ger_wave1_clean.dta", clear
append using "$working_ANALYSIS/processed/corona_ger_wave2_clean.dta"

xtset respondi_id wave  //Mark dataset as panel dataset


{
** Identifier for the participation in each wave
gen particip_w2 = 0
replace particip_w2 = 1 if f.wave == 2 & wave == 1
replace particip_w2 = 1 if wave == 2
lab var particip_w2 "First wavers that participated in second wave"
gen particip_w1 = 0
replace particip_w1  = 1 if l.wave == 1 & wave == 2
lab var particip_w1 "Second wavers who's observation was not excluded in first wave"


** Mark those of the balanced panel (used for panel-analysis)
gen panel = .
replace panel = 0 if particip_w2==0 & wave == 1 
replace panel = 1 if particip_w2==1 & wave == 1 | particip_w1==1 & wave == 2 
lab var panel "Only in first wave (0) or in both waves (1)"
label define panel1 0 "Only 1st wave" 1 "1st & 2nd wave"
lab val panel panel1
drop if panel == . //37 people who participated in w2 but were dropped from w1
}
*----------------------------



*----------------------------
* 2) Generate/Replace
{

** Swap measures from first wave to second (socio-economics)
* Some measures (e.g. socio-economics) have been asked only in the first wave. These information are to be copied to the observations of the second wave
foreach var in income marital edu children_12_18 hh_member_0_14 hh_member_14_99 pop_density zip_code {
replace `var' = l.`var' if wave == 2
}


*Female
gen female = 0
replace female = 1 if gender == 1
lab define female1 0 "not female" 1 "female" 
lab val female female1


*** Treatment Variables
replace treatment = l1.treatment if wave == 2
replace treatment_w1 = l1.treatment_w1 if wave == 2

*** Change Treatment variable
/*
Has been defined as 1-Debunk 2-Benefits 3-Facilitator 4-Control
Change to 0-Control 1-Facilitator 2-Debunk 3-Benefits  
*/
rename treatment treatment_orig
gen treatment = .
replace treatment = (treatment_orig - 4) * (-1)
tab treatment_orig treatment
drop treatment_orig

*change order of treatments
gen treatment_aux = 0 if treatment == 0
replace treatment_aux = 1 if treatment == 3
replace treatment_aux = 2 if treatment == 2
replace treatment_aux = 3 if treatment == 1
drop treatment
rename treatment_aux treatment
lab def treatie 0 "Control" 1 "T1: Debunk" 2 "T2: Benefits" 3 "T3: Facilitation", replace
lab val treatment treatie
lab val treatment_w1 treatie

*treatment dummies: for both waves seperately
tab treatment, gen(t)
tab treatment_w1, gen(w1_t)

*benefits-control dummy identifer
gen benefits_control = 0 if treatment == 0
replace benefits_control = 1 if treatment == 2

*vaccine hesitancy
gen no_action = .
replace no_action = 1 if vaccine_status == 5
replace no_action = 0 if vaccine_status != 5
lab var no_action "No vaccination action taken"

tab vaccine_status, gen(vac_stat)

gen vaccinated = 0
replace vaccinated = 1 if vaccine_status == 1 | vaccine_status == 2

*correct batch number
save "$working_ANALYSIS/data/temp.dta", replace
preserve
keep if batch_nr != "" & wave == 2
keep batch_nr respondi_id wave 
export excel using "$working_ANALYSIS/data/batch_nr.xlsx", replace firstrow(variables) 
restore

import excel "$working_ANALYSIS/data/batch_nr_klass.xlsx", sheet("Sheet1") firstrow clear
drop batch_nr
save "$working_ANALYSIS/data/batch_correct.dta" , replace

use "$working_ANALYSIS/data/temp.dta", clear
merge 1:1 respondi_id wave using "$working_ANALYSIS/data/batch_correct.dta"
erase "$working_ANALYSIS/data/temp.dta"
drop if _merge == 2
drop _merge
replace batch_correct = 0 if batch_correct == . & wave == 2 & vaccine_status <= 2 // vaccinated & in wave 2

*Education
/* Original -> New
1-Noch Schüler -> Missing?
3-Hauptschulabschluss -> Same + Kommentar: "hauptschulabschluss mit lehre"
4-Realschule
6-Fachhochschulreife + Abitur -> Abitur
7-Hochschulabschluss -> Hochschulabschluss + Kommentare "Promotion", "Universität - Doktor"
8-Other -> Missing
*/

rename edu edu_orig
gen edu = .
replace edu = 1 if edu_orig == 2 | edu_orig == 3 | edu_other == "hauptschulabschluss mit lehre" 
replace edu = 2 if edu_orig == 4  | edu_orig == 1 | edu_other == "Abgeschlossene Lehre" | edu_orig == 1 | edu_other == "Betriebswirt (VWA)" | edu_other == "abgeschlossene Ausbildung" | edu_other == "abgeschlossene Berufsausbildung" | edu_other == "10.Klasse POS"
replace edu = 3 if edu_orig == 6 | edu_orig == 7
replace edu = 4 if edu_orig == 8 | edu_other == "Promotion" | edu_other == "Universität - Doktor"
lab define edu2 1 "Haubschulabschluss" 2 "Realschulabschluss" 3 "Abitur" 4 "Universitärer Abschluss"
lab val edu edu2
lab var edu "Education"
*some selected "other education" in w2 yet clearified their education in w1
*list of respondi_ids: 
replace edu = 2 if respondi_id == 5461723731314
replace edu = 4 if respondi_id == 5533215836578
replace edu = 2 if respondi_id == 5799339831578
replace edu = 4 if respondi_id == 6045700932041
replace edu = 2 if respondi_id == 6489117481005
replace edu = 1 if respondi_id == 6490739619369

tab edu, gen(edu)


*generate weighted hh income
gen adj_hh_income = income / (1 + 0.3*hh_member_0_14 + 0.5*hh_member_14_99)

*income categories
gen income_cat = 1 if income <= 3
replace income_cat = 2 if income > 3 & income <= 7
replace income_cat = 3 if income > 7 & income <= 10
replace income_cat = 4 if income > 10
lab def inc_cats 1 "HH income <= 1000€" 2 "HH income > 1000€ <= 3000€" 3 "HH income > 3000€ <= 4500" 4 "HH income > 4500€", replace
lab val income_cat inc_cats
tab income_cat, gen(inc_)

*marital status
gen married = 1 if marital == 1
replace married = 0 if marital != 1

*generate age group
gen age_grps = 1 if age < 30
replace age_grps = 2 if age >= 30 & age < 40
replace age_grps = 3 if age >= 40 & age < 50
replace age_grps = 4 if age >= 50 & age < 65
replace age_grps = 5 if age >= 65
lab def age_cats 1 "Age: <30" 2 "Age: 30-39" 3 "Age: 40-49" 4 "Age: 50-64" 5 "Age: 65+", replace
lab val age_grps age_cats
tab age_grps, gen(age)

* negative emotions
alpha upset alert nervous attentive anxious
*alpha = 0.88
egen NA = rowmean(upset alert nervous attentive anxious)

* anticipated regret: Anticipated regret was measured by two items. If I take a Corona vaccine, I might regret it./If I do NOT take a Corona vaccine, I might regret it. The score on the first item was subtracted from the score of the second item to achieve a measure of net-anticipated regret. Item construction was in accordance with Brewer et al. (2016) specification of anticipated regret measures.
pwcorr fomo1 fomo2, sig
gen net_anticipated_regret = fomo2-fomo1

*covid risk perception
alpha risk_eval_self risk_eval_others 
*alpha=0.91
egen c19_risk_index = rowmean(risk_eval_self risk_eval_others)
lab var c19_risk_index "Perceived risks of COVID19 for oneself and others."

gen risk_progression = 0 if progression == 1
replace risk_progression = 50 if progression == 2
replace risk_progression = 100 if progression == 3

egen risk_self_score = rowmean(risk_infect_self risk_progression long_covid death_covid)

gen line_45degree = _n
egen temp = count(case)
replace line_45degree = (line_45degree/temp)*100
replace line_45degree = 0 if case==202
drop temp

bysort risk_self_score risk_eval_self: gen temp = _n
bysort risk_self_score risk_eval_self: egen weight_risk_self = max(temp)
drop temp

egen risk_others_score = rowmean(risk_infect_others risk_infect_average)
bysort risk_others_score risk_eval_others: gen temp = _n
bysort risk_others_score risk_eval_others: egen weight_risk_others = max(temp)
drop temp

*dogmatism
alpha dog1 dog2 dog3 dog4 dog5 dog6 dog7 dog8 dog9
* alpha=0.78
*reverse items
gen dog6_r = 8 - dog6
gen dog9_r = 8 - dog9
egen dogmatism = rowmean(dog1 dog2 dog3 dog4 dog5 dog6_r dog7 dog8 dog9_r)
lab var dogmatism "Higher values are associated with stronger dogmatism."

* difference intention mrna and vector
gen d_intention = intent_mrna - intent_vector
lab var d_intention "Difference in intention to get vaccinated (mRNA - Vector)"
gen prefer_mrna = 1 if d_intention > 0
replace prefer_mrna = 0 if d_intention <= 0

* FIVE C
*** Check whether Alpha ok
alpha confidence1_mrna confidence2_mrna confidence3_mrna // alpha = .95
alpha confidence1_vector confidence2_vector confidence3_vector // alpha = .92
alpha complacency1 complacency2 // alpha = .78
alpha constraints1 constraints2 constraints3  // alpha = .77
alpha calculation1 calculation2 calculation3 // alpha = .79
alpha collective1 collective2 collective3 // alpha = .83

alpha confidence1_mrna confidence1_vector confidence2_mrna confidence2_vector confidence3_mrna confidence3_vector constraints1 constraints2 constraints3 calculation1 calculation2 calculation3 collective1 collective2 collective3 // alpha .91


*** Build indices
** i) Confidence
gen confidence_mrna = (confidence1_mrna + confidence2_mrna + confidence3_mrna)/3
lab var confidence_mrna "Index: Confidence in mrna vaccines"
gen confidence_vector = (confidence1_vector + confidence2_vector + confidence3_vector)/3
lab var confidence_vector "Index: Confidence in vector vaccines"

** ii) Complacency 
gen complacency = (complacency1 + complacency2) / 2
lab var complacency "Index: Complacency"

** iii) Constraints
gen constraints = (constraints1 + constraints2 + constraints3) / 3
lab var constraints "Index: Constraints keeping one from getting vaccinated"

** iv) Calculation
gen calculation = (calculation1 + calculation2 + calculation3) / 3
lab var calculation "Index: Colculating behavior towards vaccination"

** v) Collective
gen collective1_r = (collective1-8) * (-1)
gen collective = (collective1_r + collective2 + collective3) / 3
lab var collective "Index: Collective understanding of vaccination"

*label likert scales with english labels
lab def likely 1 "1='Never'" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7='Definitely'", replace
lab val intent_mrna likely
lab val intent_vector likely


* SVO ANGLES
* get values of money distribution for each choice
* SVO 1
gen svo1_self = 85 if svo1==1
gen svo1_other = 85 if svo1==1
replace svo1_other = 76 if svo1==2
replace svo1_other = 68 if svo1==3
replace svo1_other = 59 if svo1==4
replace svo1_other = 50 if svo1==5
replace svo1_other = 41 if svo1==6
replace svo1_other = 33 if svo1==7
replace svo1_other = 24 if svo1==8
replace svo1_other = 15 if svo1==9

*SVO 2
gen svo2_self = 85 if svo2==1
replace svo2_self = 87 if svo2==2
replace svo2_self = 89 if svo2==3
replace svo2_self = 91 if svo2==4
replace svo2_self = 93 if svo2==5
replace svo2_self = 94 if svo2==6
replace svo2_self = 96 if svo2==7
replace svo2_self = 98 if svo2==8
replace svo2_self = 100 if svo2==9

gen svo2_other = 15 if svo2==1
replace svo2_other = 19 if svo2==2
replace svo2_other = 24 if svo2==3
replace svo2_other = 28 if svo2==4
replace svo2_other = 33 if svo2==5
replace svo2_other = 37 if svo2==6
replace svo2_other = 41 if svo2==7
replace svo2_other = 46 if svo2==8
replace svo2_other = 50 if svo2==9

*SVO 3
gen svo3_self = 50 if svo3==1
replace svo3_self = 54 if svo3==2
replace svo3_self = 59 if svo3==3
replace svo3_self = 63 if svo3==4
replace svo3_self = 68 if svo3==5
replace svo3_self = 72 if svo3==6
replace svo3_self = 76 if svo3==7
replace svo3_self = 81 if svo3==8
replace svo3_self = 85 if svo3==9

gen svo3_other = 100 if svo3==1
replace svo3_other = 98 if svo3==2
replace svo3_other = 96 if svo3==3
replace svo3_other = 94 if svo3==4
replace svo3_other = 93 if svo3==5
replace svo3_other = 91 if svo3==6
replace svo3_other = 89 if svo3==7
replace svo3_other = 87 if svo3==8
replace svo3_other = 85 if svo3==9

*SVO 4
gen svo4_self = 50 if svo4==1
replace svo4_self = 54 if svo4==2
replace svo4_self = 59 if svo4==3
replace svo4_self = 63 if svo4==4
replace svo4_self = 68 if svo4==5
replace svo4_self = 72 if svo4==6
replace svo4_self = 76 if svo4==7
replace svo4_self = 81 if svo4==8
replace svo4_self = 85 if svo4==9

gen svo4_other = 100 if svo4==1
replace svo4_other = 89 if svo4==2
replace svo4_other = 79 if svo4==3
replace svo4_other = 68 if svo4==4
replace svo4_other = 58 if svo4==5
replace svo4_other = 47 if svo4==6
replace svo4_other = 36 if svo4==7
replace svo4_other = 26 if svo4==8
replace svo4_other = 15 if svo4==9

*SVO 5
gen svo5_self = 100 if svo5==1
replace svo5_self = 94 if svo5==2
replace svo5_self = 88 if svo5==3
replace svo5_self = 81 if svo5==4
replace svo5_self = 75 if svo5==5
replace svo5_self = 69 if svo5==6
replace svo5_self = 63 if svo5==7
replace svo5_self = 56 if svo5==8
replace svo5_self = 50 if svo5==9

gen svo5_other = 50 if svo5==1
replace svo5_other = 56 if svo5==2
replace svo5_other = 63 if svo5==3
replace svo5_other = 69 if svo5==4
replace svo5_other = 75 if svo5==5
replace svo5_other = 81 if svo5==6
replace svo5_other = 88 if svo5==7
replace svo5_other = 94 if svo5==8
replace svo5_other = 100 if svo5==9

*SVO 6
gen svo6_self = 100 if svo6==1
replace svo6_self = 98 if svo6==2
replace svo6_self = 96 if svo6==3
replace svo6_self = 94 if svo6==4
replace svo6_self = 93 if svo6==5
replace svo6_self = 91 if svo6==6
replace svo6_self = 89 if svo6==7
replace svo6_self = 87 if svo6==8
replace svo6_self = 85 if svo6==9

gen svo6_other = 50 if svo6==1
replace svo6_other = 54 if svo6==2
replace svo6_other = 59 if svo6==3
replace svo6_other = 63 if svo6==4
replace svo6_other = 68 if svo6==5
replace svo6_other = 72 if svo6==6
replace svo6_other = 76 if svo6==7
replace svo6_other = 81 if svo6==8
replace svo6_other = 85 if svo6==9

*mean amount kept and transferred
egen svo_self = rowmean(svo*_self)
egen svo_other = rowmean(svo*_other)

*calculate svo angles
gen svo_angle = atan((svo_other-50)/(svo_self-50))*180/c(pi)
bys treatment_w1: sum svo_angle age if wave==1
*why are svo-angles only missing in the benefits and debunking treatment but not in the control?


*types based on angles
* Altruism: SVO◦ > 57.15◦
* Prosociality: 22.45◦ < SVO◦ < 57.15◦
* Individualism: –12.04◦ < SVO◦ < 22.45◦
* Competitiveness: SVO◦ < –12.04◦
recode svo_angle (min/-12.03=1)(-12.04/22.44=2)(22.45/57.15=3) (57.16/max=4), gen(svo_type)
label var svo_type "Categorization of social preferences based on SVO measure"
label define svo_type_lab 1 "competitive" 2 "individualistic" 3 "prosocial" 4 "altruistic", replace
label values svo_type svo_type_lab


* Hypothetical willingness to accept (WTA) vaccination
gen wta = .
replace wta = 1 if wta_50 == 1
replace wta = 2 if wta_100 == 1
replace wta = 3 if wta_250 == 1
replace wta = 4 if wta_500 == 1
replace wta = 5 if wta_1000 == 1
replace wta = 6 if wta_5000 == 1
replace wta = 7 if wta_10000 == 1
replace wta = 8 if wta_other !=.
replace wta = 9 if wta_other == 0
replace wta = . if vaccine_status == 2 //2 people answered the WTA questions altough they shouldn't have seen it.
lab var wta "WTA"
lab def wta_l 1 "50" 2 "100" 3 "250" 4 "500" 5 "1,000" 6 "5,000" 7 "10,000" 8 ">10,000" 9 "never"
lab val wta wta_l

* Other policies to increase vaccination rates
gen invitation = 0 if int_offer_mrna != .
replace invitation = 1 if int_offer_mrna == 6 | int_offer_mrna == 7
gen home = 0 if int_mobile_mrna != .
replace home = 1 if int_mobile_mrna == 6 | int_mobile_mrna == 7
gen shopping = 0 if int_shopping_mrna != .
replace shopping = 1 if int_shopping_mrna == 6 | int_shopping_mrna == 7
gen tests = 0 if int_test_mrna != .
replace tests = 1 if int_test_mrna == 6 | int_test_mrna == 7
gen visit = 0 if int_visit_mrna != .
replace visit = 1 if int_visit_mrna == 6 | int_visit_mrna == 7
gen together = 0 if int_offer_mrna != .
replace together = 1 if invitation == 1 | home == 1 | shopping == 1 | tests == 1 | visit == 1 | wta_50 == 1
gen placeholder = . if together !=0

gen bar_category = 1 if wta_50 == 1
replace bar_category = 2 if invitation == 1 | home ==1 | shopping == 1
replace bar_category = 3 if visit ==1 | tests == 1
replace bar_category = 4 if together == 1
gen placeholder2 = placeholder
gen placeholder3 = placeholder

*lagging variables
sort respondi_id wave
foreach var in no_action denied_vaccine_past prefer_mrna svo_angle c19_risk_index NA net_anticipated_regret dogmatism intent_mrna confidence_mrna confidence_vector complacency constraints calculation collective{
gen l_`var' = l.`var'
}

*standardize explanatory variables
foreach x of varlist svo_angle c19_risk_index NA net_anticipated_regret dogmatism l_svo_angle l_c19_risk_index l_NA l_net_anticipated_regret l_dogmatism {
	egen z_`x' = std(`x')
}

*** Mails
/*
Some in control stated that they received mails. In the question to state what was written in the mails they showed that they misunderstood the quesiton => Change to missing
*/
foreach var in mails_received mails_read mails_links mails_informative mails_helpful mails_annoying mails_misleading mail_int {
	replace `var'= . if treatment == 0
}






* Some more labels
lab def wave_lab 1 "Survey Experiment" 2 "Follow-up survey", replace
lab val wave wave_lab

lab def vaccine_status1 1 "Fully vaccinated" 2 "Partly vaccinated" 3 "Appointment" 4 "On waiting list" 5 "No action", replace
lab val vaccine_status vaccine_status1


}
* SAVE DATASET WITH NO EXCLUSION CRITERIA FOR ROBUSTNESS CHECKS
save "$working_ANALYSIS/processed/corona_ger_NO_exclusion.dta", replace
tab wave // 1623 wave 1; 987 wave 2 without any exclusion criteria


*** Check whether batch numbers were correctly reported:
preserve
keep if batch_nr != "" & wave == 2
keep batch_nr respondi_id wave 
export excel using "$working_ANALYSIS/processed/batch_nr.xlsx", replace firstrow(variables) 
restore

import excel "$working_ANALYSIS/data/batch_nr_klass.xlsx", sheet("Sheet1") firstrow clear
drop batch_nr
save "$working_ANALYSIS/processed/batch_correct.dta" , replace

use "$working_ANALYSIS/processed/corona_ger_NO_exclusion.dta", clear
merge 1:1 respondi_id wave using "$working_ANALYSIS/processed/batch_correct.dta"
drop if _merge == 2
replace batch_correct = 0 if batch_correct == . & wave == 2 & vaccine_status <= 2 // vaccinated & in wave 2
sum batch_correct if wave == 2

save "$working_ANALYSIS/processed/corona_ger_NO_exclusion.dta", replace

*----------------------------



*----------------------------
* 3. EXCLUDING OBSERVATIONS
*----------------------------
** Attention Check wrong twice
gen exclude_attention = 0
replace exclude_attention = 1 if attention_check_correct == 0 & l.attention_check_correct == 0  // attention check in first and second wave failed
lab var exclude_attention "attention check in first and second wave failed"

** Age and gender reported differently across waves
* Age
gen d_age = d.age
replace d_age = f.d_age if wave == 1
gen exclude_inc_age = 0
replace exclude_inc_age = 1 if d_age < 0 &  d_age > -100 | d_age > 1 &  d_age < 100 
lab var exclude_inc_age "Decreasing age or increasing age by more than 1 year"

* Gender
gen d_female = d.female
replace d_female = f.d_female if wave == 1
gen exclude_inc_female = 0
replace exclude_inc_female = 1 if d_female != 0 & d_female !=.
lab var exclude_inc_female "Changing identification as female"


*Participants who were excluded form main analysis
gen excluded = 0
replace excluded = 1 if exclude_rush == 1
replace excluded = 1 if exclude_inattention == 1
replace excluded = 1 if exclude_sloppy == 1
replace excluded = 1 if vaccine_status < 3 & wave==1
replace excluded = 1 if exclude_inc_age == 1 & respondi_id!= 6218392296714 | exclude_inc_age == 1 & respondi_id != 6206287104823
replace excluded = 1 if exclude_inc_female == 1
replace excluded = 1 if l.excluded == 1

bysort wave: tab excluded 
*What it looks like:
*wave	excluded	not excluded	total
* w1	  299		   1,324		1,623
* w2	  166		     821		  987


*Checking the numbers:
tab wave if exclude_sloppy == 0 & exclude_inattention == 0 & exclude_rush == 0 & vaccine_status  >= 3 // 1,359 remain in w1 
tab wave if exclude_sloppy == 0 & exclude_inattention == 0 & exclude_rush == 0  // 891 remain in w2 



* Distinguish between those excluded due to exclusion criteria vs. screening (i.e. already vaccinated in frist wave)
gen excluded2 = excluded
replace excluded2 = 2 if wave == 1 & vaccine_status < 3

* For robustness test use only those excluded by exclusion criteria; treat those who should have been screened out as if they would have been screened out
drop if wave == 1 & vaccine_status < 3
tab wave // w1 n=1532, w2 n=891 excluding participants that should have been screened out

save "$working_ANALYSIS/processed/corona_ger_ROBUSTNESS.dta", replace






*----------------------------
* 4. 
{

keep ///
/*Setup*/ case panel start_time start_time2 finish_time time_sum device respondi_tic respondi_id wave attention_check_correct treatment  t1 t2 t3 t4 treatment_w1 w1_t1 w1_t2 w1_t3 benefits_control particip_w1 particip_w2 excluded excluded2 ///
/*socio-demographics*/ age age_grps age1 age2 age3 age4 age5 d_age gender female marital married income adj_hh_income income_cat inc_1 inc_2 inc_3 inc_4 edu edu1 edu2 edu3 edu4 children_12_18 hh_member_0_14 hh_member_14_99 zip_code pop_density pol_orientation pol_party pol_party_other health pregnant ///
/*Perception*/ risk_infect_self risk_infect_others risk_progression risk_self_score risk_others_score line_45degree weight_risk_self weight_risk_others risk_infect_average progression long_covid death_covid risk_eval_self risk_eval_others measures no_measures_reason no_measures_reason_other upset alert nervous attentive anxious  ///
/*Vaccination Status*/ had_corona cured_date vaccine_status vaccinated vac_stat1 vac_stat2 vac_stat3 vac_stat4 vac_stat5 date_full date_part1 date_part2 date_reg0 date_reg1 vaccine_place vaccine_place_other vaccine_place_reg vaccine_place_reg_other priority_group batch_nr batch_correct reason_action1 reason_action2 reason_action3 reason_action4 reason_action5 reason_willing_other1 reason_willing_other_imp1 reason_willing_other2 reason_willing_other_imp2 reason_willing_other3 reason_willing_other_imp3 reason_inaction1 reason_inaction2 reason_inaction3 reason_inaction4 reason_unwilling_other1 reason_unwilling_other_imp1 reason_unwilling_other2 reason_unwilling_other_imp2 reason_unwilling_other3 reason_unwilling_other_imp3 reason_not1 reason_not2 reason_not3 reason_action_detail reason_willingness_detail ///
/*Convince Others*/ convince_family convince_friends convince_socialmedia convince_other1 convince_other2 convince_other3 convince_other1_strength convince_other2_strength convince_other3_strength convince_other_detail  ///
/*Treatment*/  t1_teaser t1_sort_admission t1_sort_effectivity t1_sort_side t1_sort_long t1_reduced_admission t1_reduced_effectivity t1_reduced_side t1_reduced_long t2_teaser t2_sort_protect_self t2_sort_protect_other t2_sort_travel t2_sort_quarantine t2_aware_protect_self t2_aware_protect_other t2_aware_travel t2_aware_quarantine prime_check1 prime_check2 time_prime  ///
/* 5C, intentions, action, other reasons */ confidence_mrna confidence_vector complacency constraints calculation collective intent_mrna intent_vector d_intention fomo1 fomo2 norms1 norms2 norms3 no_action denied_vaccine_past vacc_denied prefer_mrna svo_angle c19_risk_index NA net_anticipated_regret dogmatism ///
/* Lagged variables */ l_no_action l_denied_vaccine_past l_prefer_mrna l_svo_angle l_c19_risk_index l_NA l_net_anticipated_regret l_dogmatism l_intent_mrna l_confidence_mrna l_confidence_vector l_complacency l_constraints l_calculation l_collective ///
/* standardized variables */ z_svo_angle z_c19_risk_index z_NA z_net_anticipated_regret z_dogmatism z_l_svo_angle z_l_c19_risk_index z_l_NA z_l_net_anticipated_regret z_l_dogmatism ///
/*Mails*/ mails_received mails_read mails_links mails_content mails_informative mails_helpful mails_annoying mails_misleading mail_int mail_int_reason ///
/*WTA*/ int_offer_mrna int_offer_vector int_shopping_mrna int_shopping_vector int_mobile_mrna int_mobile_vector int_test_mrna int_test_vector int_visit_mrna int_visit_vector wta_50 wta_100 wta_250 wta_500 wta_1000 wta_5000 wta_10000 wta_other wta invitation home shopping tests visit together placeholder bar_category ///
/*Dogmatism*/ dog1 dog2 dog3 dog4 dog5 dog6 dog7 dog8 dog9 ///
/*Preferences*/  risk time svo1 svo2 svo3 svo4 svo5 svo6 ///
/*Comments*/ responses comments ///
/*Time spent on pages*/ time_welcome time_quality_check time_attention_remind 


order ///
/*Setup*/ case panel start_time start_time2 finish_time time_sum device respondi_tic respondi_id wave attention_check_correct treatment  t1 t2 t3 t4 treatment_w1 w1_t1 w1_t2 w1_t3 benefits_control particip_w1 particip_w2 excluded excluded2 ///
/*socio-demographics*/ age age_grps age1 age2 age3 age4 age5 d_age gender female marital married income adj_hh_income income_cat inc_1 inc_2 inc_3 inc_4 edu edu1 edu2 edu3 edu4 children_12_18 hh_member_0_14 hh_member_14_99 zip_code pop_density pol_orientation pol_party pol_party_other health pregnant ///
/*Perception*/ risk_infect_self risk_infect_others risk_progression risk_self_score risk_others_score line_45degree weight_risk_self weight_risk_others risk_infect_average progression long_covid death_covid risk_eval_self risk_eval_others measures no_measures_reason no_measures_reason_other upset alert nervous attentive anxious  ///
/*Vaccination Status*/ had_corona cured_date vaccine_status vaccinated vac_stat1 vac_stat2 vac_stat3 vac_stat4 vac_stat5 date_full date_part1 date_part2 date_reg0 date_reg1 vaccine_place vaccine_place_other vaccine_place_reg vaccine_place_reg_other priority_group batch_nr batch_correct reason_action1 reason_action2 reason_action3 reason_action4 reason_action5 reason_willing_other1 reason_willing_other_imp1 reason_willing_other2 reason_willing_other_imp2 reason_willing_other3 reason_willing_other_imp3 reason_inaction1 reason_inaction2 reason_inaction3 reason_inaction4 reason_unwilling_other1 reason_unwilling_other_imp1 reason_unwilling_other2 reason_unwilling_other_imp2 reason_unwilling_other3 reason_unwilling_other_imp3 reason_not1 reason_not2 reason_not3 reason_action_detail reason_willingness_detail ///
/*Convince Others*/ convince_family convince_friends convince_socialmedia convince_other1 convince_other2 convince_other3 convince_other1_strength convince_other2_strength convince_other3_strength convince_other_detail  ///
/*Treatment*/   t1_teaser t1_sort_admission t1_sort_effectivity t1_sort_side t1_sort_long t1_reduced_admission t1_reduced_effectivity t1_reduced_side t1_reduced_long t2_teaser t2_sort_protect_self t2_sort_protect_other t2_sort_travel t2_sort_quarantine t2_aware_protect_self t2_aware_protect_other t2_aware_travel t2_aware_quarantine prime_check1 prime_check2 time_prime  ///
/* 5C, intentions, action, other reasons */ confidence_mrna confidence_vector complacency constraints calculation collective intent_mrna intent_vector d_intention fomo1 fomo2 norms1 norms2 norms3 no_action denied_vaccine_past vacc_denied prefer_mrna svo_angle c19_risk_index NA net_anticipated_regret dogmatism ///
/* Lagged variables */ l_no_action l_denied_vaccine_past l_prefer_mrna l_svo_angle l_c19_risk_index l_NA l_net_anticipated_regret l_dogmatism l_intent_mrna l_confidence_mrna l_confidence_vector l_complacency l_constraints l_calculation l_collective ///
/* standardized variables */ z_svo_angle z_c19_risk_index z_NA z_net_anticipated_regret z_dogmatism z_l_svo_angle z_l_c19_risk_index z_l_NA z_l_net_anticipated_regret z_l_dogmatism ///
/*Mails*/ mails_received mails_read mails_links mails_content mails_informative mails_helpful mails_annoying mails_misleading mail_int mail_int_reason ///
/*WTA*/ int_offer_mrna int_offer_vector int_shopping_mrna int_shopping_vector int_mobile_mrna int_mobile_vector int_test_mrna int_test_vector int_visit_mrna int_visit_vector wta_50 wta_100 wta_250 wta_500 wta_1000 wta_5000 wta_10000 wta_other wta invitation home shopping tests visit together placeholder bar_category ///
/*Dogmatism*/ dog1 dog2 dog3 dog4 dog5 dog6 dog7 dog8 dog9 ///
/*Preferences*/  risk time svo1 svo2 svo3 svo4 svo5 svo6 ///
/*Comments*/ responses comments ///
/*Time spent on pages*/ time_welcome time_quality_check time_attention_remind 

}
*----------------------------



*For main analysis drop all participants that fit exclusion criteria
drop if excluded == 1


save "$working_ANALYSIS/processed/corona_ger_clean.dta", replace

tab wave
*wave1: 1,324	-> check
*wave2:   821	-> check



** EOF