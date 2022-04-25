*--------------------------------------------------------------------
* SCRIPT: 02_analysis.do
* PURPOSE: replicates most tables and figures and saves the results
*--------------------------------------------------------------------

*--------------------------------------------------
* STRUCTURE OF THE DO-FILE
/*

	1) Analysis Main Manuscript
	2) Analysis Supplementary Online Materials

*/
*--------------------------------------------------

*LOAD DATASET
use "$working_ANALYSIS/processed/corona_ger_clean.dta", clear

*----------------------------------------------------------------------
* Setting globals
{
global w1_treatments w1_t2 w1_t3
global treatments t2 t3 t4
global control female i.age_grps i.edu adj_hh_income married //as specified in PAP
global five_c confidence_mrna confidence_vector complacency constraints calculation collective
global five_c_lagged l_confidence_mrna l_confidence_vector l_complacency l_constraints l_calculation l_collective
global x_2 no_action denied_vaccine_past z_c19_risk_index z_NA z_net_anticipated_regret z_dogmatism
global x_2_lagged l_no_action l_denied_vaccine_past z_l_c19_risk_index z_l_NA z_l_net_anticipated_regret z_l_dogmatism

*globals for heterogeneous effects
global heterogeneous_PAP no_action denied_vaccine_past z_c19_risk_index z_NA z_net_anticipated_regret z_dogmatism 
global heterogeneous_PAP_lagged l_no_action l_denied_vaccine_past z_l_c19_risk_index z_l_NA z_l_net_anticipated_regret z_l_dogmatism
}
*----------------------------------------------------------------------




*--------------------------------------------------------------
* 1) ANALYSIS MAIN MANUSCRIPT
*--------------------------------------------------------------
*Table 1	Summary statistics
global summary_statistics intent_mrna intent_vector confidence_mrna confidence_vector constraints complacency calculation collective no_action /// outcome variables
no_action denied_vaccine_past c19_risk_index NA net_anticipated_regret dogmatism  /// explanatory variables
female age1 age2 age3 age4 age5 edu1 edu2 edu3 edu4 inc_1 inc_2 inc_3 inc_4  hh_member_0_14 hh_member_14_99 married // control variables
estpost tabstat $summary_statistics if wave==1, statistics(count mean sd min max) columns(statistics)
esttab . using "$working_ANALYSIS/results/tables/Table1.rtf", cells("count(fmt(0)) mean(fmt(%9.2fc)) sd(fmt(%9.2fc)) min(fmt(0)) max(fmt(0))")  not nostar unstack nomtitle nonumber nonote label replace


*Fig. 1.	Study Design & Treatment Groups
* Created in powerpoint


*Fig. 2.	Sample distribution over Germany
* Created in extra do-file "04_figure2_germany_map.do"


*Fig. 3.	Vaccination intentions
tab1 d_intention intent_mrna intent_vector if wave==1
ranksum intent_mrna if treatment_w1!=2, by(treatment_w1)
ranksum intent_mrna if treatment_w1!=1, by(treatment_w1)
ttest intent_mrna = intent_vector if wave == 1
reg intent_mrna $five_c if wave==1, vce(hc3)
bys treatment_w1: sum intent_mrna if wave==1, detail

* Panel a:
catplot intent_mrna  if wave == 1,  asyvar  percent  yla(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%")  title("mRNA") bargap(20) blabel(bar, format(%9.0f)  pos(center))  l1title("")  b1title("") legend(rows(1) pos(6) ring(1))  ytitle("")
gr save  "$working_ANALYSIS/results/intermediate/figure3_a1.gph", replace 

catplot intent_vector  if wave == 1,  asyvar  percent  yla(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%")  title("Vector") bargap(20) blabel(bar, format(%9.0f)  pos(center))  l1title("")  b1title("") legend(rows(1) pos(6) ring(1))  ytitle("")
gr save  "$working_ANALYSIS/results/intermediate/figure3_a2.gph", replace 

grc1leg  "$working_ANALYSIS/results/intermediate/figure3_a1.gph" "$working_ANALYSIS/results/intermediate/figure3_a2.gph", rows(1) title("{bf:A } Distribution", pos(11) span)
gr save  "$working_ANALYSIS/results/intermediate/figure3_a.gph", replace

* Panel b:
reg intent_mrna w1_t2 w1_t3 $control $x_2 if wave == 1, vce(hc3)
est store intent_mrna

coefplot (intent_mrna, ), nokey  keep(w1_t2 w1_t3 no_action denied_vaccine_past z_c19_risk_index z_NA z_net_anticipated_regret z_dogmatism)  coeflabels(w1_t2  = "T1: Debunking"  w1_t3 = "T2: Benefits" no_action = "No action (=1)" denied_vaccine_past = "Denied other vaccine (=1)" z_c19_risk_index = "Risk perception (std.)" z_NA = "Emotional response (std.)" z_net_anticipated_regret = "Net anticipated regret (std.)" z_dogmatism = "Dogmatism (std.)", labsize()) xline(0, lpattern(dash) lcolor(gs3)) title("{bf:B } Determinants vaccination intention (mRNA)", pos(11) span) xtitle("Regression estimated impact relative to control") msymbol(d)  xla(-1.5(0.5)1.5, nogrid) grid(none) levels(95 90) ciopts(lwidth(0.3 1) lcolor(*.8 *.2)  msize() recast(rcap)) mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", cond(@pval<.1, "*", "")))) mlabsize() mlabposition(12) mlabgap(-0.1) 
gr save  "$working_ANALYSIS/results/intermediate/figure3_b.gph", replace

gr combine  "$working_ANALYSIS/results/intermediate/figure3_a.gph" "$working_ANALYSIS/results/intermediate/figure3_b.gph", rows(2) xsize(7.5) ysize(8.5)
gr_edit plotregion1.graph1.title.style.editstyle size(13pt) editcopy
gr_edit plotregion1.graph1.plotregion1.graph1.title.style.editstyle size(12pt) editcopy
gr_edit plotregion1.graph1.plotregion1.graph2.title.style.editstyle size(12pt) editcopy
gr_edit plotregion1.graph1.plotregion1.graph1.scaleaxis.style.editstyle majorstyle(tickstyle(textstyle(size(12-pt)))) editcopy
gr_edit plotregion1.graph1.plotregion1.graph1.scaleaxis.style.editstyle majorstyle(tickstyle(textstyle(size(12-pt)))) editcopy
gr_edit plotregion1.graph1.plotregion1.graph2.scaleaxis.style.editstyle majorstyle(tickstyle(textstyle(size(12-pt)))) editcopy
gr_edit plotregion1.graph1.plotregion1.graph2.scaleaxis.style.editstyle majorstyle(tickstyle(textstyle(size(12-pt)))) editcopy
gr_edit plotregion1.graph1.plotregion1.graph1.plotregion1.barlabels[1].style.editstyle size(12-pt) editcopy
gr_edit plotregion1.graph1.plotregion1.graph2.plotregion1.barlabels[1].style.editstyle size(12-pt) editcopy
gr_edit plotregion1.graph1.legend.Edit , style(key_gap(tiny)) keepstyles 
gr_edit plotregion1.graph1.legend.Edit, style(labelstyle(size(10-pt))) style(labelstyle(color(custom)))
gr_edit plotregion1.graph2.title.style.editstyle size(13pt) editcopy
gr_edit plotregion1.graph2.yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(10pt)))) editcopy
gr_edit plotregion1.graph2.xaxis1.title.style.editstyle size(10pt) editcopy
gr_edit plotregion1.graph2.xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(10pt)))) editcopy
gr export  "$working_ANALYSIS/results/figures/figure3_intentions.tif", replace width(4500)



*Fig. 4.	Self-reported actions: Balanced panel
*Panel A Vaccination (in-)action across waves
bys wave: tab vaccine_status if panel==1 

mylabels 0(20)100, myscale(@) local(pctlabel) suffix("%")
catplot vaccine_status if panel==1, over(wave) stack asyvar percent(wave)  yla(`pctlabel', nogrid)  title("{bf:A } Vaccination (in-)action across waves", span pos(11)) bargap(20) blabel(bar, format(%9.0f) pos(center)) l1title("")  b1title("") legend(rows(2) pos(6) ring(1) size()) /*xsize(3.165) ysize(2)*/
gr save "$working_ANALYSIS/results/intermediate/figure4_a.gph", replace



*Panel B Treatment effects on in-actions
ttest vaccinated if panel==1 & wave==2, by(benefits_control)
tab vaccinated benefits_control if panel==1 & wave==2, chi

foreach i of global heterogeneous_PAP_lagged  {
	foreach j of global treatments {
		gen `i'_`j' = `i'*`j'
	}
}

reg no_action $treatments l_no_action $control $x_2_lagged , vce(hc3)
est store hesitancy1
reg no_action $treatments l_no_action l_no_action_t2 l_no_action_t3 l_no_action_t4 $control $x_2_lagged, vce(robust)
est store hesitancy2

coefplot (hesitancy1, offset(0.2)) (hesitancy2, offset(-0.2)),   keep(t2 t3 t4 l_no_action  l_no_action_t2 l_no_action_t3 l_no_action_t4)  coeflabels(t2  = "T1: Debunking"  t3 = "T2: Benefits" t4 = "T3: Facilitation" l_no_action = "Baseline: No action (=1)" l_no_action_t2 = "Interaction: T1*No action" l_no_action_t3 = "Interaction: T2*No action" l_no_action_t4 = "Interaction: T3*No action") xline(0, lpattern(dash) lcolor(gs3)) title("{bf:B } Treatment effects on in-action", span pos(11) size()) xtitle("Regression estimated impact relative to control in pp")  legend(order(3 "No interaction" 6 "With interaction") pos(4) ring(0) rows(2) size() ) msymbol(d)  xla(-.5(0.1).5, nogrid) grid(none) levels(95 90) ciopts(lwidth(0.3 1)  msize()  lcolor(*.8 *.2) recast(rcap)) mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", cond(@pval<.1, "*", ""))))  mlabsize() mlabposition(12) 
gr save "$working_ANALYSIS/results/intermediate/figure4_b.gph", replace

gr combine "$working_ANALYSIS/results/intermediate/figure4_a.gph" "$working_ANALYSIS/results/intermediate/figure4_b.gph",  rows(2) xsize(7.5) ysize(8.5)
gr_edit .plotregion1.graph1.title.style.editstyle size(14-pt) editcopy
gr_edit .plotregion1.graph2.title.style.editstyle size(14-pt) editcopy
gr_edit .plotregion1.graph1.grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph1.grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph1.scaleaxis.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph1.scaleaxis.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph1.scaleaxis.title.style.editstyle size(12-pt) editcopy
gr_edit .plotregion1.graph1.scaleaxis.title.style.editstyle size(10-pt) editcopy
gr_edit .plotregion1.graph1.scaleaxis.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph1.legend.Edit, style(labelstyle(size(10-pt))) style(labelstyle(color(custom)))
gr_edit .plotregion1.graph1.legend.Edit , style(rows(1)) style(cols(0)) keepstyles 
gr_edit .plotregion1.graph1.legend.Edit, style(labelstyle(color(custom)))
gr_edit .plotregion1.graph1.legend.Edit, style(labelstyle(color(custom)))
gr_edit .plotregion1.graph1.plotregion1.barlabels[6].style.editstyle size(10-pt) editcopy
gr_edit .plotregion1.graph2.yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph2.yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph2.xaxis1.title.style.editstyle size(10-pt) editcopy
gr_edit .plotregion1.graph2.xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph2.legend.Edit, style(labelstyle(size(10-pt))) style(labelstyle(color(custom)))
gr_edit .plotregion1.graph2.legend.Edit , style(key_gap(tiny)) keepstyles 
gr_edit .plotregion1.graph2.plotregion1.plot6.style.editstyle label(textstyle(size(2.77778))) editcopy
gr_edit .plotregion1.graph2.plotregion1.plot6.style.editstyle marker(fillcolor("220 38 127")) editcopy
gr_edit .plotregion1.graph2.plotregion1.plot5.style.editstyle area(linestyle(color("247 204 225"))) editcopy
gr_edit .plotregion1.graph2.plotregion1.plot4.style.editstyle area(linestyle(color("220 38 127"))) editcopy
gr_edit .plotregion1.graph1.scaleaxis.title.text = {}
save "$working_ANALYSIS/results/intermediate/figure4_inaction.gph", replace
gr export "$working_ANALYSIS/results/figures/figure4_inaction.tif", replace width(4500)




*Fig. 5.	Determinants of being unvaccinated: Five C
reg no_action $treatments $control $five_c_lagged if l_no_action & wave==2, vce(hc3)
est store determinants_inaction

coefplot (determinants_inaction, msize(3pt)), keep($five_c_lagged)  coeflabels(l_confidence_mrna = "Confidence: mRNA" l_confidence_vector = "Confidence: Vector" l_complacency = "Complacency" l_constraints = "Constraints" l_calculation = "Calculation" l_collective = "Collective") xline(0, lpattern(dash) lcolor(gs3)) xtitle("Regression estimated impact", size())  msymbol(d)  xla(-.2(0.05).2, nogrid) grid(none) levels(95 90) ciopts(lwidth(0.3 1) lcolor(*.8 *.2) recast(rcap)) mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", cond(@pval<.1, "*", ""))))   mlabsize(medium)  mlabposition(12) mlabgap(0.5) xsize(7.5) ysize(3)
gr_edit .xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(7-pt)))) editcopy
gr_edit .xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(7-pt)))) editcopy
gr_edit .xaxis1.title.style.editstyle size(7-pt) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(7-pt)))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(7-pt)))) editcopy
gr save "$working_ANALYSIS/results/intermediate/figure5_determinants_inaction.gph", replace
gr export "$working_ANALYSIS/results/figures/figure5_determinants_inaction.tif", replace width(4500)



*Fig. 6.	Reasons stated for vaccination hesitancy
* Network graph was created using Gephi 0.9.2




*Fig. 7.	Effectiveness of interventions to decrease hesitancy
preserve
drop if wave!=2
drop if vaccine_status != 5

*Panel A: Effectiveness of vaccination premiums
distplot wta if vaccine_status == 5 , over() ///
	text(0.137 1  "0.10", place(c) size(small)) ///
	text(0.145 2  "0.11", place(c) size(small)) ///
	text(0.172 3  "0.14", place(c) size(small)) ///
	text(0.210 4  "0.18", place(c) size(small)) ///
	text(0.260 5  "0.22", place(c) size(small)) ///
	text(0.305 6  "0.27", place(c) size(small)) ///
	text(0.340 7  "0.30", place(c) size(small)) ///
	text(0.430 8  "0.40", place(c) size(small)) ///
	text(1.03 9  "1.00", place(c) size(small)) ///
	xlabel( 1 "50" 2 "100" 3 "250" 4 "500" 5 "1,000" 6 "5,000" 7 "10,000" 8 ">10,000" 9 "never" )  xtitle(" ") title("{bf:A  }Effectiveness of vaccination premiums", pos(11) span)
gr_edit .xaxis1.reset_rule 0.8 9.2 0 , tickset(major) ruletype(range) 
graph save "$working_ANALYSIS/results/intermediate/figure7_a", replace


*Panel B: Effectiveness of hesitancy interventions
graph bar wta_50 home invitation shopping visit tests placeholder together, ///
	bargap(0) blabel(bar, format(%12.2f)) yscale(on) legend(on pos(6) row(1) color(%0) fcolor(%0) lcolor(%0) region(fcolor(%0) lcolor(%0)) size(0) symxsize(0) symysize(0)  )  ///
	text(-0.006 8  "50 Euro", place(c) j(c) size(small) ) ///
	text(-0.006 20  "At", place(c) j(c) size(small)) ///
	text(-0.011 20  "home", place(c) j(c) size(small)) ///
	text(-0.006 32  "In-", place(c) j(c) size(small)) ///
	text(-0.011 32  "vitation", place(c) j(c) size(small)) ///
	text(-0.006 44  "Shop-", place(c) j(c) size(small)) ///
	text(-0.011 44  "ping", place(c) j(c) size(small)) ///
	text(-0.016 44  "center", place(c) j(c) size(small)) ///
	text(-0.006 56  "Ex-", place(c) j(c) size(small)) ///
	text(-0.011 56  "clusion", place(c) j(c) size(small)) ///
	text(-0.006 68  "No", place(c) j(c) size(small)) ///
	text(-0.011 68  "free", place(c) j(c) size(small)) ///
	text(-0.016 68  "tests", place(c) j(c) size(small)) ///
	text(-0.006 92  "Total", place(c) j(c) size(small)) ///
	title("{bf:B  }Effectiveness of hesitancy interventions", pos(11) span)
graph save "$working_ANALYSIS/results/intermediate/figure7_b", replace

graph combine "$working_ANALYSIS/results/intermediate/figure7_a"  "$working_ANALYSIS/results/intermediate/figure7_b" , row(1) xsize(7.5) ysize(3)
gr_edit .plotregion1.graph1.yoffset = -2.6
gr_edit .plotregion1.graph1.title.yoffset = 2.6
gr_edit .plotregion1.graph1.title.style.editstyle size(12-pt) editcopy
gr_edit .plotregion1.graph1.yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph1.yaxis1.title.style.editstyle size(10-pt) editcopy
gr_edit .plotregion1.graph1.xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox1.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox2.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox3.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox4.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox5.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox6.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox7.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox8.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox9.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.title.style.editstyle size(12-pt) editcopy
gr_edit .plotregion1.graph2.scaleaxis.style.editstyle majorstyle(tickstyle(textstyle(size(10-pt)))) editcopy
gr_edit .plotregion1.graph2.plotregion1.barlabels[1].style.editstyle size(10-pt) editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox1.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox2.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox3.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox4.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox5.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox6.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox7.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox8.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox9.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox10.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox11.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox12.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox13.style.editstyle size(10-pt) color("86 64 91") editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox14.style.editstyle size(10-pt) color("86 64 91") editcopy
graph save "$working_ANALYSIS/results/intermediate/figure7_interventions_hesitancy", replace
gr export "$working_ANALYSIS/results/figures/figure7_interventions_hesitancy.tif", replace width(4500)
restore









*--------------------------------------------------------------
* 2) ANALYSIS SUPPLEMENTARY ONLINE MATERIALS
*--------------------------------------------------------------
*Table S1.	Complete dogmatism scale
*Created in word.

*Fig. S1.	Compression of dogmatism scale
*created in extra do-file "06_figureS1_dogmatism_scale"

*Table S2.	Balance table: Main sample and excluded
* created in extra do-file "03_robustness_checks_no_exclusion"

*Fig. S2.	Differential attrition across treatments
cibar particip_w2 if wave == 1,  over1(treatment) bargap(10) barlabel(on) blsize(8pt) blfmt(%9.2f) blpos(11) graphopts(legend(ring (1) pos(6) rows(1))  yla(0(0.2)1) xla() ytitle("Share of returners") xsize(7.5)) ciopts(lcolor(gs3) lpattern(dash)) 
gr_edit .plotregion1.textbox1.xoffset = -0.5
gr_edit .plotregion1.textbox2.xoffset = -0.5
gr_edit .plotregion1.textbox3.xoffset = -0.5
gr_edit .plotregion1.textbox4.xoffset = -0.5
gr save "$working_ANALYSIS/results/intermediate/figureS2_differential_attrition_rates.gph", replace
gr export "$working_ANALYSIS/results/figures/figureS2_differential_attrition_rates.tif", replace width(3165)
* ttests
reg particip_w2 i.treatment if wave==1


*Table S3.	Selective attrition across treatments
global selective_attrition vac_stat5 intent_mrna confidence_mrna complacency constraints calculation collective

iebaltab $selective_attrition if wave == 1, grpvar(particip_w2) onerow rowvarlabels save("$working_ANALYSIS/results/tables/attrition_socioecon_full") replace // full sample
iebaltab $selective_attrition if wave == 1 & treatment == 0, grpvar(particip_w2)  ftest fmissok onerow  rowvarlabels save("$working_ANALYSIS/results/tables/attrition_socioecon_c") replace // control 
iebaltab $selective_attrition if wave == 1 & treatment == 1, grpvar(particip_w2)  ftest fmissok onerow  rowvarlabels save("$working_ANALYSIS/results/tables/attrition_socioecon_t1") replace // T1 
iebaltab $selective_attrition if wave == 1 & treatment == 2, grpvar(particip_w2)  ftest fmissok onerow  rowvarlabels save("$working_ANALYSIS/results/tables/attrition_socioecon_t2") replace // T2
iebaltab $selective_attrition if wave == 1 & treatment == 3, grpvar(particip_w2)  ftest fmissok onerow  rowvarlabels save("$working_ANALYSIS/results/tables/attrition_socioecon_t3") replace // T3

iebaltab $selective_attrition if wave == 1 & particip_w2==0, grpvar(treatment) onerow rowvarlabels save("$working_ANALYSIS/results/tables/TableS3_panelA") replace
iebaltab $selective_attrition if wave == 1 & particip_w2==1, grpvar(treatment) onerow rowvarlabels save("$working_ANALYSIS/results/tables/TableS3_panelB") replace


*Fig. S3.	Participants’ adjustments to the calculated risk perception score
*Panel A: Participants' adjustments to the calculated risk perception score
twoway (scatter line_45degree line_45degree, msymbol(none) connect(direct) lpattern(solid) lwidth(vthin) lcolor(gs10) ) (scatter risk_self_score risk_eval_self [w=weight_risk_self*weight_risk_self] if wave==1, msize() mcolor() mlcolor() mlwidth(vthin)) , legend(off) xtitle("Calculated score") ytitle("Adjusted score") title("{bf:A  }Adjustments to personal risk")
gr save "$working_ANALYSIS/results/intermediate/figureS3_a", replace

*Panel B
twoway (scatter line_45degree line_45degree, msymbol(none) connect(direct) lpattern(solid) lwidth(vthin) lcolor(gs10) ) (scatter risk_others_score risk_eval_others [w=weight_risk_others*weight_risk_others] if wave==1, msize() mcolor() mlcolor() mlwidth(vthin)) ,legend(off) xtitle("Calculated score") ytitle("Adjusted score") title("{bf:B  }Adjustments to risk of others")
gr save "$working_ANALYSIS/results/intermediate/figureS3_b", replace

gr combine "$working_ANALYSIS/results/intermediate/figureS3_a" "$working_ANALYSIS/results/intermediate/figureS3_b", graphregion(margin(zero)) xsize(7.5)
gr save "$working_ANALYSIS/results/intermediate/figureS3_risk_adjustment.gph", replace
gr export "$working_ANALYSIS/results/figures/figureS3_risk_adjustment.tif", replace width(4500)


*Table S4.	Balancing across treatments: Survey experiment
global balance_panel female age1 age2 age3 age4 age5 edu1 edu2 edu3 edu4 adj_hh_income married no_action denied_vaccine_past c19_risk_index NA net_anticipated_regret dogmatism 
iebaltab $balance_panel if panel==1 & wave==1 , grpvar(treatment)  rowvarlabels save("$working_ANALYSIS/results/tables/TableS4_balancing_panel_dataset") ftest fmissok replace
* joint f-tests no significant differnces in terms of socio-economics and other pre-specified variables potentially influencing intentions and vaccine hesitancy



*Fig. S4.	Priming check: Variation in feeling informed
tab t1_reduced_admission, gen(d_t1_admission)
tab t1_reduced_effectivity, gen(d_t1_effectivity)
tab t1_reduced_side, gen(d_t1_side_effects)
tab t1_reduced_long, gen(d_t1_longterm_effects)
tab1 t1_reduced_admission t1_reduced_effectivity t1_reduced_side t1_reduced_long 
sum d_t1_admission8 d_t1_effectivity8 d_t1_side_effects8 d_t1_longterm_effects8
egen n_not_concerned = rowtotal(d_t1_admission8 d_t1_effectivity8 d_t1_side_effects8 d_t1_longterm_effects8) if treatment_w1==1 & wave==1
g d_concerned = 1 if n_not_concerned==0
replace d_concerned = 0 if n_not_concerned > 0
replace d_concerned = . if n_not_concerned == .
tab n_not_concerned d_concerned
global t1_convincing t1_reduced_admission t1_reduced_effectivity t1_reduced_side t1_reduced_long
foreach x of varlist $t1_convincing {
	sum `x' if `x'!=99, detail
	}
reg intent_mrna d_concerned, vce(hc3)
ttest prime_check1, by(d_concerned)
ttest intent_mrna, by(d_concerned)
reg prime_check1 $t1_convincing if d_concerned==1, vce(hc3)
reg intent_mrna $t1_convincing if d_concerned==1, vce(hc3)

ttest prime_check1 if wave==1 & treatment_w1 != 2, by(treatment_w1)
ttest prime_check2 if wave==1 & treatment_w1 != 1, by(treatment_w1)
reg prime_check1 i.treatment_w1 if wave==1, vce(hc3)
reg prime_check2 i.treatment_w1 if wave==1, vce(hc3)

cibar prime_check1 if wave==1, over1(treatment_w1) bargap(10) barlabel(on) blsize() blfmt(%9.1f) blpos(11) graphopts(ysize(2) title("{bf:A } Security and efficacy", pos(11) span)  legend(ring (1) pos(6) rows(1))  yla(1(1)7, nogrid) xla(, nogrid) ytitle("mean", )) ciopts(lcolor(gs3) lpattern(dash)) 
gr save "$working_ANALYSIS/results/intermediate/prime_t1debunk.gph", replace

cibar prime_check2 if wave==1, over1(treatment_w1) bargap(10) barlabel(on) blsize() blfmt(%9.1f) blpos(11) graphopts(ysize(2) title("{bf:B } Benefits", pos(11) span)  legend(ring (1) pos(6) rows(1))  yla(1(1)7, nogrid) xla(, nogrid) ytitle("mean", )) ciopts(lcolor(gs3) lpattern(dash)) 
gr save "$working_ANALYSIS/results/intermediate/prime_t2benefits.gph", replace


grc1leg "$working_ANALYSIS/results/intermediate/prime_t1debunk.gph" "$working_ANALYSIS/results/intermediate/prime_t2benefits.gph", rows(1) xsize(7.5)
gr_edit .plotregion1.graph1.plotregion1.textbox1.xoffset = -0.5
gr_edit .plotregion1.graph1.plotregion1.textbox2.xoffset = -0.5
gr_edit .plotregion1.graph1.plotregion1.textbox3.xoffset = -0.5
gr_edit .plotregion1.graph2.plotregion1.textbox1.xoffset = -0.5
gr_edit .plotregion1.graph2.plotregion1.textbox2.xoffset = -0.5
gr_edit .plotregion1.graph2.plotregion1.textbox3.xoffset = -0.5
gr_edit .legend.Edit, style(labelstyle(size(vsmall)))
gr save "$working_ANALYSIS/results/intermediate/figureS4_priming_check.gph", replace
gr export "$working_ANALYSIS/results/figures/figureS4_priming_check.tif", replace width(4500)



*Table S5.	Balancing across treatments: Returners
global balance_panel female age1 age2 age3 age4 age5 edu1 edu2 edu3 edu4 adj_hh_income married no_action denied_vaccine_past c19_risk_index NA net_anticipated_regret dogmatism 
iebaltab $balance_panel if panel==1 & wave==1 , grpvar(treatment)  rowvarlabels save("$working_ANALYSIS/results/tables/TableS5_treatment_balance") ftest fmissok replace
* joint f-tests no significant differnces in terms of socio-economics and other pre-specified variables potentially influencing intentions and vaccine hesitancy



*Fig. S5.	Age distribution: sample vs. census
*Code in extra do-file "06_AppendixS7.do"

*Table S6.	Sample means vs. census data
*Code in extra do-file "06_AppendixS7.do"

*Table S7.	Study sample vs. unvaccinated population
*Code in extra do-file "06_AppendixS7.do"


*Table S8.	Treatment effects vaccination intentions
*MRNA
reg intent_mrna w1_t2 w1_t3 if wave == 1, vce(hc3)
outreg2 using "$working_ANALYSIS/results/tables/TableS8_vaccination_intentions", addstat("Adjusted R-squared", e(r2_a)) adec(3) drop() word ctitle("MRNA") dec(2) replace
reg intent_mrna w1_t2 w1_t3 $control if wave == 1, vce(hc3)
testparm $control
local F1 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS8_vaccination_intentions", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1') adec(3) word ctitle("MRNA") dec(2) append
reg intent_mrna w1_t2 w1_t3 $control $x_2 if wave == 1, vce(hc3)
testparm $control
local F1 = r(p)
testparm $x_2
local F2 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS8_vaccination_intentions", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1', "Reasons", `F2') adec(3) word ctitle("MRNA") dec(2) append

*VECTOR
reg intent_vector w1_t2 w1_t3 if wave == 1, vce(hc3)
outreg2 using "$working_ANALYSIS/results/tables/TableS8_vaccination_intentions", addstat("Adjusted R-squared", e(r2_a)) adec(3) drop() word ctitle("Vector") dec(2) append
reg intent_vector w1_t2 w1_t3 $control if wave == 1, vce(hc3)
testparm $control
local F1 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS8_vaccination_intentions", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1') adec(3) word ctitle("Vector") dec(2) append
reg intent_vector w1_t2 w1_t3 $control $x_2 if wave == 1, vce(hc3)
testparm $control
local F1 = r(p)
testparm $x_2
local F2 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS8_vaccination_intentions", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1', "Reasons", `F2') adec(3) word ctitle("Vector") dec(2) append



*Table S9.	Heterogeneous treatments effects: mRNA
foreach i of global heterogeneous_PAP  {
	foreach j of global w1_treatments {
		gen `i'_`j' = `i'*`j'
	}
}

foreach var of global heterogeneous_PAP  {
reg intent_mrna $w1_treatments `var' `var'_w1_t2 `var'_w1_t3  $control if wave == 1, vce(hc3)
testparm `var'_w1_t2 `var' w1_t2
local F1 = r(p)
testparm `var'_w1_t3 `var' w1_t3
local F2 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS9_heterogeneous_intention_mrna", drop($control) addstat("Interaction: T1 sig.", `F1', "Interaction: T2 sig.", `F2') adec(3) word  adjr2 dec(2)
}



*Table S10.	Heterogeneous effects: Vector
foreach var of global heterogeneous_PAP {
reg intent_vector $w1_treatments `var' `var'_w1_t2 `var'_w1_t3  $control if wave == 1, rob
testparm `var'_w1_t2 `var' w1_t2
local F1 = r(p)
testparm `var'_w1_t3 `var' w1_t3
local F2 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS10_heterogeneous_intention_vector", drop($control) addstat("Interaction: T1 sig.", `F1', "Interaction: T2 sig.", `F2') adec(3) word  adjr2 dec(2)
}



*Fig. S6.	mRNA vaccination intentions
cibar intent_mrna if wave == 1, over1(priority) bargap(10) barlabel(on) blsize(small) blfmt(%9.2f) blpos(11) graphopts(legend(ring (1) pos(6) rows(2)) xla(, nogrid) yla(1(1)7, nogrid) title("{bf: A} Intention by priority group", pos(11) span)  ytitle("Average intention")) ciopts(lcolor(gs3) lpattern(dash))
gr save "$working_ANALYSIS/results/intermediate/FigureS6_a.gph", replace

cibar intent_mrna if wave == 1, over1(treatment_w1) over2(d_priority) bargap(10) barlabel(on) blsize(small) blfmt(%9.2f) blpos(11) graphopts(legend(ring (1) pos(6) rows(1)) xla(, nogrid) yla(1(1)7, nogrid) title("{bf: B} Intention by priority group and treatment", pos(11) span)  ytitle("Average intention")) ciopts(lcolor(gs3) lpattern(dash))
gr save "$working_ANALYSIS/results/intermediate/FigureS6_b.gph", replace

gr combine  "$working_ANALYSIS/results/intermediate/FigureS6_a.gph"  "$working_ANALYSIS/results/intermediate/FigureS6_b.gph", rows(1)
gr_edit .plotregion1.graph1.yoffset = -3.5
gr_edit .plotregion1.graph1.title.yoffset = 3.5
gr_edit .plotregion1.graph1.plotregion1.textbox1.xoffset = -0.5
gr_edit .plotregion1.graph1.plotregion1.textbox2.xoffset = -0.5
gr_edit .plotregion1.graph1.plotregion1.textbox3.xoffset = -0.5
gr_edit .plotregion1.graph1.plotregion1.textbox4.xoffset = -0.5
gr_edit .plotregion1.graph2.plotregion1.textbox1.xoffset = -0.5
gr_edit .plotregion1.graph2.plotregion1.textbox2.xoffset = -0.5
gr_edit .plotregion1.graph2.plotregion1.textbox3.xoffset = -0.5
gr_edit .plotregion1.graph2.plotregion1.textbox4.xoffset = -0.5
gr_edit .plotregion1.graph2.plotregion1.textbox5.xoffset = -0.5
gr_edit .plotregion1.graph2.plotregion1.textbox6.xoffset = -0.5
gr save "$working_ANALYSIS/results/intermediate/figureS6_priority.gph", replace
gr export "$working_ANALYSIS/results/figures/figureS6_priority.tif", replace width(4500)



* Table S11.	Treatment effects vaccination intentions: Only respondents without prioritization status
reg intent_mrna w1_t2 w1_t3 if wave == 1 & priority == 0, vce(hc3)
outreg2 using "$working_ANALYSIS/results/tables/TableS11_without_priority_groups", addstat("Adjusted R-squared", e(r2_a)) adec(3) drop() word ctitle("MRNA") dec(2) replace
reg intent_mrna w1_t2 w1_t3 $control if wave == 1 & priority == 0, vce(hc3)
testparm $control
local F1 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS11_without_priority_groups", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1') adec(3) word ctitle("MRNA") dec(2) append
reg intent_mrna w1_t2 w1_t3 $control $x_2 if wave == 1 & priority == 0, vce(hc3)
testparm $control
local F1 = r(p)
testparm $x_2
local F2 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS11_without_priority_groups", addstat("Adjusted R-squared", e(r2_a), "Socio-economic", `F1', "Reasons", `F2') adec(3) word ctitle("MRNA") dec(2) append



*Table S12.	Treatment effects on 5C: Wave 1
foreach x of varlist $five_c {
	reg `x' w1_t2 w1_t3 $control if wave == 1, vce(hc3)
	est store fiveC_`x'
	testparm $control
	local F1 = r(p)
	outreg2 using "$working_ANALYSIS/results/tables/TableS12_5C_wave1", addstat("F-Test: Socio-economics", `F1') adec(3) word  adjr2 dec(2)
}



*Table S13.	Treatment effects on 5C: Wave 2
sort respondi_id wave
foreach x of varlist $five_c {
	reg `x' t2 t3 t4 l.`x' $control  if wave == 2 & panel==1, vce(hc3)
	est store fiveC2_`x'
	testparm $control
	local F1 = r(p)
	outreg2 using "$working_ANALYSIS/results/tables/TableS13_5C_wave2", addstat("F-Test: Socio-economics", `F1') adec(3) word  adjr2 dec(2)
}




*Fig. S7.	Treatment effects on 5C
*Panel a: Wave 1
foreach x of varlist $five_c {
	reg `x' w1_t2 w1_t3 $control if wave == 1, vce(hc3)
	est store fiveC_`x'
	testparm $control
	local F1 = r(p)
}
coefplot  (fiveC_confidence_mrna, ) (fiveC_confidence_vector, ) (fiveC_complacency, ) (fiveC_constraints, ) (fiveC_calculation, ) (fiveC_collective, ), keep(w1_t2 w1_t3)  coeflabels(w1_t2  = "T1: Debunking"  w1_t3 = "T2: Benefits" ) xline(0, lpattern(dash) lcolor(gs3)) title("{bf: A} Survey Experiment (n=1324)", pos(11) span) xtitle("Regression estimated impact") msymbol(d)  xla(-0.75(0.25)0.75, nogrid) grid(none)  levels(95 90) ciopts(lwidth(0.3 1) lcolor(*.8 *.2) recast(rcap)) mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", cond(@pval<.1, "*", "")))) mlabsize() mlabposition(12) mlabgap(-0.1)  legend(order(3 "Confidence: mRNA" 6 "Confidence: Vector" 9 "Complacency" 12 "Constraints" 15 "Calculation" 18 "Collective") size() pos(6) ring(1) rows(2) bmargin(small)) xsize(3.465) ysize(2) scale(1.2) 
gr save "$working_ANALYSIS/results/intermediate/FigureS7_a.gph", replace

*Panel b: Wave 2
sort respondi_id wave
foreach x of varlist $five_c {
	reg `x' t2 t3 t4 l.`x' $control  if wave == 2 & panel==1, vce(hc3)
	est store fiveC2_`x'
	testparm $control
	local F1 = r(p)
}
coefplot  (fiveC2_confidence_mrna, ) (fiveC2_confidence_vector, ) (fiveC2_complacency, ) (fiveC2_constraints, ) (fiveC2_calculation, ) (fiveC2_collective, ), keep(t2 t3 t4)  coeflabels(t2  = "T1: Debunking"  t3 = "T2: Benefits" t4 = "T3: Faciliation") xline(0, lpattern(dash) lcolor(gs3)) title("{bf: B} Follow-up (n=821)", pos(11) span) xtitle("Regression estimated impact", size()) msymbol(d)   xla(-0.75(0.25)0.75, nogrid) grid(none) levels(95 90) ciopts(lwidth(0.3 1) lcolor(*.8 *.2)  recast(rcap)) mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", cond(@pval<.1, "*", "")))) mlabsize() mlabposition(12) mlabgap(-0.1)  legend(order(3 "Confidence: mRNA" 6 "Confidence: Vector" 9 "Complacency" 12 "Constraints" 15 "Calculation" 18 "Collective") size() pos(6) ring(1) rows(2) bmargin(small)) xsize(3.465) ysize(2) scale(1.2)
gr save "$working_ANALYSIS/results/intermediate/FigureS7_b.gph", replace

grc1leg "$working_ANALYSIS/results/intermediate/FigureS7_a.gph"  "$working_ANALYSIS/results/intermediate/FigureS7_b.gph",  rows(1) xsize(7.5)
gr_edit .plotregion1.graph1.title.style.editstyle size(small) editcopy
gr_edit .plotregion1.graph1.yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy
gr_edit .plotregion1.graph1.xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy
gr_edit .plotregion1.graph1.xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy
gr_edit .plotregion1.graph1.xaxis1.title.style.editstyle size(vsmall) editcopy
gr_edit .plotregion1.graph2.title.style.editstyle size(small) editcopy
gr_edit .plotregion1.graph2.yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy
gr_edit .plotregion1.graph2.xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy
gr_edit .plotregion1.graph2.xaxis1.title.style.editstyle size(vsmall) editcopy
gr_edit .legend.Edit, style(labelstyle(size(vsmall))) style(labelstyle(color(custom)))
gr_edit .legend.Edit , style(key_gap(tiny)) keepstyles 
gr save "$working_ANALYSIS/results/intermediate/figureS7_effects_5C.gph", replace
gr export "$working_ANALYSIS/results/figures/figureS7_effects_5C.tif", replace width(4500)



*Table S14.	Treatment effects vaccination intentions (without exclusion)
* created in extra do-file "03_robustness_checks_no_exclusion"



*Table S15.	Treatment effects on inaction: Balanced Panel
reg no_action $treatments l_no_action , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS15_inaction_treatment_effects", drop($control) word  dec(2) replace
reg no_action $treatments l_no_action $control , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS15_inaction_treatment_effects", drop($control) word  dec(2) append
reg no_action $treatments l_no_action $control $x2_lagged, vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS15_inaction_treatment_effects", drop($control $x2_lagged) word  dec(2) append
*with interactions
reg no_action $treatments l_no_action l_no_action_t2 l_no_action_t3 l_no_action_t4 , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS15_inaction_treatment_effects", drop($control) word  dec(2) append
reg no_action $treatments l_no_action l_no_action_t2 l_no_action_t3 l_no_action_t4 $control , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS15_inaction_treatment_effects", drop($control) word  dec(2) append
reg no_action $treatments l_no_action l_no_action_t2 l_no_action_t3 l_no_action_t4 $control $x2_lagged , vce(robust)
outreg2 using "$working_ANALYSIS/results/tables/TableS15_inaction_treatment_effects", drop($control $x2_lagged) word  dec(2) append



*Table S16.	Robustness check using non-linear Probit models and computing margins
*Probit models and tests for interaction effects between treatment and baseline action
probit no_action i.treatment l_no_action , vce(robust)
margins, dydx(*) post
outreg2 using "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control) word  dec(2) replace
probit no_action i.treatment l_no_action $control , vce(robust)
margins, dydx(*) post
outreg2 using  "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control) word  dec(2) append
probit no_action i.treatment l_no_action $control $x2_lagged, vce(robust)
margins, dydx(*) post
outreg2 using  "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control $x2_lagged) word  dec(2) append

*predict interaction effects using margins contrast option
probit no_action treatment##l_no_action , vce(robust)
margins r.treatment#r.l_no_action, post
outreg2 using  "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control) word  dec(2) append
probit no_action treatment##l_no_action $control, vce(robust)
margins r.treatment##r.l_no_action, post
outreg2 using  "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control) word  dec(2) append
probit no_action treatment##l_no_action $control $x2_lagged, vce(robust)
margins r.treatment##r.l_no_action, post
outreg2 using  "$working_ANALYSIS/results/tables/TableS16_inaction_treatment_effects_RC", drop($control) word  dec(2) append



*Table S17.	Robustness check linear model without exclusion criteria
* created in extra do-file "03_robustness_checks_no_exclusion"



*Table S18.	Heterogeneous treatment effects as pre-registered
foreach var of global heterogeneous_PAP_lagged {
reg no_action $treatments `var' `var'_t2 `var'_t3 `var'_t4 $control, rob
testparm `var'_t2 `var' t2
local F1 = r(p)
testparm `var'_t3 `var' t3
local F2 = r(p)
testparm `var'_t4 `var' t4
local F3 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS18_vaccine_hesitancy_heterogeneous", drop($control) addstat("Interaction: T1 sig.", `F1', "Interaction: T2 sig.", `F2', "Interaction: T3 sig.", `F3') adec(2) word  adjr2 dec(2)
}



*Fig. S8.	Benefits treatment effects on inaction across socioeconomic groups
*median splits of control variables
foreach x of varlist age adj_hh_income {
	egen aux_`x' = median(`x') if panel==1 
	gen `x'_median = 1 if `x' >= aux_`x' & panel==1 
	replace `x'_median = 0 if `x' < aux_`x' & panel==1 
	drop aux_`x'
}
 
reg no_action $treatments  $control if wave==2, robust
estimates store all_sample
reg	no_action $treatments  $control if wave==2 & age < 50, robust
estimates store age_below
reg	no_action $treatments  $control if wave==2 & age >= 50, robust
estimates store age_above
reg	no_action $treatments  $control if wave==2  & female == 1 , robust
estimates store female
reg	no_action  $treatments $control if wave==2  & female == 0 , robust
estimates store male
reg	no_action $treatments  $control if wave==2  & adj_hh_income >= 3.89, robust
estimates store highSES
reg	no_action $treatments  $control if wave==2  & adj_hh_income < 3.89  , robust
estimates store lowSES

coefplot (all_sample, aseq(All Sample) level(95 90) ciopts(lwidth(0.5 1.2) lcolor(*.8 *.2) recast(rcap)) msymbol() ) ///
		(age_below, aseq(Aged Below 50) level(95 90) ciopts(lwidth(0.5 1.2) lcolor(*.8 *.2)  recast(rcap)) msymbol() ) ///
        (age_above, aseq(Aged at or Above 50) level(95 90) ciopts(lwidth(0.5 1.2) lcolor(*.8 *.2)  recast(rcap)) msymbol() ) ///
        (female, aseq(Female) level(95 90) ciopts(lwidth(0.5 1.2) lcolor(*.8 *.2)  recast(rcap)) msymbol() )  ///
		(male, aseq(Male) level(95 90) ciopts(lwidth(0.5 1.2) lcolor(*.8 *.2)  recast(rcap)) msymbol() )  ///
		(highSES, aseq(High SES) level(95 90) ciopts(lwidth(0.5 1.2) lcolor(*.8 *.2)  recast(rcap)) msymbol()) ///						
		(lowSES, aseq(Low SES) level(95 90) ciopts(lwidth(0.5 1.2) lcolor(*.8 *.2)  recast(rcap)) msymbol() )  ///
        , nooffsets coeflabels(, wrap(26))	keep(t3) swapnames drop(_cons) xline(0, lcolor(gs5) lwidth(medium)) msize() legend(off) grid(none) xscale(range(-0.5 0.5)) xlabels(-0.4(0.1)0.2, nogrid labsize()) mlabposition(1) xtitle("Regression estimated impact in percentage points", height(7))  mlabel(cond(@pval<.01, "{bf:***}", cond(@pval<.05, "{bf:**}",  cond(@pval<.10, "{bf:*}", "" )))) xsize(7.5)
gr_edit .plotregion1.plot18.style.editstyle marker(fillcolor("100 143 255*1.3")) editcopy
gr_edit .plotregion1.plot16.style.editstyle area(linestyle(color("100 143 255*1.3"))) editcopy
gr_edit .plotregion1.plot21.style.editstyle marker(fillcolor("120 94 240*1.3")) editcopy
gr_edit .plotregion1.plot19.style.editstyle area(linestyle(color("120 94 240*1.3"))) editcopy
gr save  "$working_ANALYSIS/results/intermediate/figureS8_benefits_splits.gph", replace
gr export "$working_ANALYSIS/results/figures/figureS8_benefits_splits.tif", replace width(4500)



*Table S19.	Determinants of inaction in wave 2
reg no_action $treatments if l_no_action & wave==2, vce(hc3)
testparm $treatments
local F0 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS19_determinants_inaction", drop()  addstat("Adjusted R-squared", e(r2_a), "F-Test:Treatments", `F0') adec(3) dec(2) word  replace
reg no_action  $treatments $control if l_no_action & wave==2, vce(hc3)
testparm $treatments
local F0 = r(p)
testparm $control
local F1 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS19_determinants_inaction", drop()  addstat("Adjusted R-squared", e(r2_a), "F-Test:Treatments", `F0', "F-Test: Socio-economics", `F1') adec(3) dec(2) word  append
reg no_action $treatments $control $five_c_lagged if l_no_action & wave==2, vce(hc3)
testparm $treatments
local F0 = r(p)
testparm $control
local F1 = r(p)
testparm $five_c_lagged
local F2 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS19_determinants_inaction", drop()  addstat("Adjusted R-squared", e(r2_a), "F-Test:Treatments", `F0', "F-Test: Socio-economics", `F1',  "F-Test: 5C", `F2') adec(3) dec(2) word  append
reg no_action $treatments  $control  $five_c_lagged $x_2_lagged if l_no_action & wave==2, vce(hc3)
testparm $treatments
local F0 = r(p)
testparm $control
local F1 = r(p)
testparm $five_c_lagged
local F2 = r(p)
testparm $x_2_lagged
local F3 = r(p)
outreg2 using "$working_ANALYSIS/results/tables/TableS19_determinants_inaction", drop()  addstat("Adjusted R-squared", e(r2_a), "F-Test:Treatments", `F0', "F-Test: Socio-economics", `F1',  "F-Test: 5C", `F2', "F-Test: Reasons", `F3') adec(3) dec(2) word  append



*Fig. S9.	Share of batch numbers correctly reported by treatment
cibar batch_correct if wave == 2, over1(treatment) barlabel(on) blsize(8pt) blpos(11) gap(50) bargap(10)  graphopts(legend(rows(1) pos(6) size(8pt)) yla(0(0.2)1, nogrid) ytitle("Share of correctly reported batch numbers", size(8pt) margin(medsmall)) xsize(7.5) ) ciopts(lcolor(gs3) lpattern(dash))
gr_edit .plotregion1.textbox1.xoffset = -0.5
gr_edit .plotregion1.textbox2.xoffset = -0.5
gr_edit .plotregion1.textbox3.xoffset = -0.5
gr_edit .plotregion1.textbox4.xoffset = -0.5
gr save  "$working_ANALYSIS/results/intermediate/FigS9_batchNr.gph", replace
gr export "$working_ANALYSIS/results/figures/figureS9_batchNr.tif", replace width(4500)



*Fig. S10.	Likelihood of getting vaccinated between May 2 and September 18
*Created in extra do-file "07_AppendixS10.do"






** EOF