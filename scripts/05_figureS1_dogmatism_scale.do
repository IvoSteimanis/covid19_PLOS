*--------------------------------------------------------------------
* SCRIPT: 05_figureS1_dogmatism_scale.do
* PURPOSE: replicates Figure S1 - construction of the dogmatism scale
*--------------------------------------------------------------------
*Load dogmatism data from pretest
use "$working_ANALYSIS/data/pre-test_corona_raw.dta", clear

*PCA
pca dt06_01 dt06_02 dt06_03 dt06_04 dt06_05 dt06_06 dt06_07 dt06_08 dt06_09 dt06_10 dt06_11 dt06_12 dt06_13 dt06_14 dt06_15 dt06_16 dt06_17 dt06_18, blanks(0.15) comp(3) //dt06_18 loads in the opposite direction of what it should -> exlude it

*First iteration
pca dt06_01 dt06_02 dt06_03 dt06_04 dt06_05 dt06_06 dt06_07 dt06_08 dt06_09 dt06_10 dt06_11 dt06_12 dt06_13 dt06_14 dt06_15 dt06_16 dt06_17 , blanks(0.2) comp(1)
matrix list e(L)
matrix define loadings = e(L)

preserve
xsvmat double loadings, names(col) rownames(var) saving("$working_ANALYSIS/processed/dog_pca_pre-test", replace)
use "$working_ANALYSIS/processed/dog_pca_pre-test", clear
gen dropped = 1
replace dropped = 0 if Comp1 <= -.19 | Comp1 >= 0.19
encode var, gen(var_nr)
save "$working_ANALYSIS/processed/dog_pca_pre-test", replace

twoway (dropline Comp1 var_nr if dropped == 0, horizontal mlabel(Comp1) mlabformat(%12.2f) mlabposition(top)) (dropline Comp1 var_nr if dropped == 1, horizontal mlabel(Comp1)  mlabformat(%12.2f) mlabposition(top)  ), ylabel(1(1)17, valuelabel) xtitle(loadings) legend(order(1 "Preserved" 2 "Excluded") rows(1))ytitle("") title("{bf:A } First iteration", pos(11) span)
graph save "$working_ANALYSIS/results/intermediate/dog_loadings1", replace
restore

*Second iteration
pca dt06_01 dt06_03 dt06_05 dt06_06 dt06_07 dt06_08 dt06_09 dt06_10 dt06_12 dt06_13 dt06_15 dt06_16, blanks(0.2) comp(1) //drop 5 & 7
matrix list e(L)
matrix define loadings = e(L)

preserve
xsvmat double loadings, names(col) rownames(var) saving("$working_ANALYSIS/processed/dog_pca_pre-test2", replace)
use "$working_ANALYSIS/processed/dog_pca_pre-test2", clear
gen dropped = 1
replace dropped = 0 if Comp1 <= -.20 | Comp1 >= 0.20
save "$working_ANALYSIS/processed/dog_pca_pre-test2", replace

use "$working_ANALYSIS/processed/dog_pca_pre-test", clear
keep var var_nr
merge 1:1 var using "$working_ANALYSIS/processed/dog_pca_pre-test2"

twoway (dropline Comp1 var_nr if dropped == 0, horizontal mlabel(Comp1) mlabformat(%12.2f) mlabposition(top)) (dropline Comp1 var_nr if dropped == 1, horizontal mlabel(Comp1)  mlabformat(%12.2f) mlabposition(top)  ), ylabel(1(1)17, valuelabel) xtitle(loadings) ytitle("") title("{bf:B } Second iteration", pos(11) span)
graph save "$working_ANALYSIS/results/intermediate/dog_loadings2", replace
restore


*final 
pca dt06_01 dt06_03 dt06_06 dt06_08 dt06_09 dt06_10 dt06_12 dt06_13 dt06_15 dt06_16, blanks(0.2) comp(1)
matrix list e(L)
matrix define loadings = e(L)

preserve
xsvmat double loadings, names(col) rownames(var) saving("$working_ANALYSIS/processed/dog_pca_pre-test3", replace)
use "$working_ANALYSIS/processed/dog_pca_pre-test3", clear
gen dropped = 1
replace dropped = 0 if Comp1 <= -.20 | Comp1 >= 0.20
save "$working_ANALYSIS/processed/dog_pca_pre-test3", replace

use "$working_ANALYSIS/processed/dog_pca_pre-test", clear
keep var var_nr
merge 1:1 var using "$working_ANALYSIS/processed/dog_pca_pre-test3"

twoway (dropline Comp1 var_nr if dropped == 0, horizontal mlabel(Comp1) mlabformat(%12.2f) mlabposition(top)) (dropline Comp1 var_nr if dropped == 1, horizontal mlabel(Comp1)  mlabformat(%12.2f) mlabposition(top)  ), ylabel(1(1)17, valuelabel) xtitle(loadings) ytitle("") title("{bf:C } Final set", pos(11) span)
graph save "$working_ANALYSIS/results/intermediate/dog_loadings3", replace
restore

grc1leg  "$working_ANALYSIS/results/intermediate/dog_loadings1" "$working_ANALYSIS/results/intermediate/dog_loadings2" "$working_ANALYSIS/results/intermediate/dog_loadings3", rows(1) xsize(7.5)
gr_edit .legend.Edit, style(labelstyle(size(vsmall))) style(labelstyle(color(custom)))
gr_edit .plotregion1.graph1.plotregion1.plot2.style.editstyle area(linestyle(color("220 38 127"))) editcopy
gr_edit .plotregion1.graph2.plotregion1.plot2.style.editstyle area(linestyle(color("220 38 127"))) editcopy
gr_edit .legend.plotregion1.key[2].view.style.editstyle area(linestyle(color("220 38 127"))) editcopy
gr_edit .legend.plotregion1.key[2].view.style.editstyle marker(fillcolor("220 38 127")) editcopy
gr_edit .plotregion1.graph1.plotregion1.plot2.style.editstyle marker(fillcolor("220 38 127")) editcopy
gr_edit .plotregion1.graph2.plotregion1.plot2.style.editstyle marker(fillcolor("220 38 127")) editcopy
gr export "$working_ANALYSIS/results/figures/figureS1_dogmatism.tif", replace width(4500)





** EOF