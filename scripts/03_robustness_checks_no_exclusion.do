*--------------------------------------------------------------------
* SCRIPT: 03_robustness_checks_no_exclusion.do
* PURPOSE: This file runs the main analysis using the whole sample without any exclusion criterias.
*--------------------------------------------------------------------


*Load dataset without applying the exlcusion criteria
use "$working_ANALYSIS/processed/corona_ger_ROBUSTNESS", clear 


*Setting variable lists
{
*globals for excludion check
global selective_exclusion ///
/*socio-econ*/ female age1 age2 age3 age4 age5 edu1 edu2 edu3 edu4 adj_hh_income married ///
/*explanatory*/ denied_vaccine_past c19_risk_index NA net_anticipated_regret dogmatism /// 
/*outcome variables*/ intent_mrna intent_vector confidence_mrna confidence_vector constraints complacency calculation collective no_action 

global w1_treatments w1_t2 w1_t3
global treatments t2 t3 t4
global control female i.age_grps i.edu adj_hh_income married //as specified in PAP)
global five_c confidence_mrna confidence_vector complacency constraints calculation collective
global five_c_lagged l_confidence_mrna l_confidence_vector l_complacency l_constraints l_calculation l_collective
global x_2 no_action denied_vaccine_past z_c19_risk_index z_NA z_net_anticipated_regret z_dogmatism
global x_2_lagged l_no_action l_denied_vaccine_past z_l_c19_risk_index z_l_NA z_l_net_anticipated_regret z_l_dogmatism

*globals for heterogeneous effects
global heterogeneous_PAP no_action denied_vaccine_past z_c19_risk_index z_NA z_net_anticipated_regret z_dogmatism 
global heterogeneous_PAP_lagged l_no_action l_denied_vaccine_past z_l_c19_risk_index z_l_NA z_l_net_anticipated_regret z_l_dogmatism
}

*Table S2.	Balance table: Main sample and excluded
iebaltab $selective_exclusion if wave == 1, grpvar(excluded2) rowvarlabels save("$working_ANALYSIS/results/tables/TableS2_excluded_vs_nonexcluded") replace 


*Table S13.	Treatment effects vaccination intentions (without exclusion)
*MRNA
reg intent_mrna w1_t2 w1_t3 if wave == 1, vce(hc3)
outreg2 using "$working_ANALYSIS/results/tables/TableS13_vaccination_intentions_RC", addstat("Adjusted R-squared", e(r2_a)) adec(3) drop() word ctitle("MRNA") dec(2) replace
reg intent_mrna w1_t2 w1_t3 $control if wave == 1, vce(hc3)
testparm $control
local F1 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS13_vaccination_intentions_RC", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1') adec(3) word ctitle("MRNA") dec(2) append
reg intent_mrna w1_t2 w1_t3 $control $x_2 if wave == 1, vce(hc3)
testparm $control
local F1 = r(p)
testparm $x_2
local F2 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS13_vaccination_intentions_RC", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1', "Reasons", `F2') adec(3) word ctitle("MRNA") dec(2) append

*VECTOR
reg intent_vector w1_t2 w1_t3 if wave == 1, vce(hc3)
outreg2 using "$working_ANALYSIS/results/tables/TableS13_vaccination_intentions_RC", addstat("Adjusted R-squared", e(r2_a)) adec(3) drop() word ctitle("Vector") dec(2) append
reg intent_vector w1_t2 w1_t3 $control if wave == 1, vce(hc3)
testparm $control
local F1 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS13_vaccination_intentions_RC", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1') adec(3) word ctitle("Vector") dec(2) append
reg intent_vector w1_t2 w1_t3 $control $x_2 if wave == 1, vce(hc3)
est store intent_vector
testparm $control
local F1 = r(p)
testparm $x_2
local F2 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS13_vaccination_intentions_RC", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1', "Reasons", `F2') adec(3) word ctitle("Vector") dec(2) append


*Table S16.	Robustness check linear model without exclusion criteria
foreach i of global heterogeneous_PAP_lagged  {
	foreach j of global treatments {
		gen `i'_`j' = `i'*`j'
	}
}

reg no_action $treatments l_no_action , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control) word  dec(2) replace
reg no_action $treatments l_no_action $control , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control) word  dec(2) append
reg no_action $treatments l_no_action $control $x2_lagged, vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control $x2_lagged) word  dec(2) append
*with interactions
reg no_action $treatments l_no_action l_no_action_t2 l_no_action_t3 l_no_action_t4 , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control) word  dec(2) append
reg no_action $treatments l_no_action l_no_action_t2 l_no_action_t3 l_no_action_t4 $control , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control) word  dec(2) append
reg no_action $treatments l_no_action l_no_action_t2 l_no_action_t3 l_no_action_t4 $control $x2_lagged , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control $x2_lagged) word  dec(2) append




** EOF