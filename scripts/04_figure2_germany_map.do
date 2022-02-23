*--------------------------------------------------
* SCRIPT: 04_figure2_germany_map.do
* PURPOSE: Creates study site map (Figure 2)
*--------------------------------------------------


// Sample map: oservations per PLZ (2 digits)

clear
cd "$working_ANALYSIS/processed/map"

spshape2dta "$working_ANALYSIS/data/map/plz2stellig.shp", replace saving(germany_2plz) // source: https://opendata-esri-de.opendata.arcgis.com/

use germany_2plz_shp, clear
*scatter _Y _X, msize(tiny) msymbol(point)
merge m:1 _ID using germany_2plz 
drop rec_header shape_order _merge _CX _CY
destring plz, replace

geo2xy _Y _X, proj (web_mercator) replace //apparently to make it look better...
*scatter _Y _X, msize(tiny) msymbol(point)

sort _ID
save, replace


*Prepare observations
use "$working_ANALYSIS/processed/corona_ger_clean.dta", clear
keep if wave==1
gen observations = 1
collapse (sum) observations, by(zip_code)
sort zip_code 
rename zip_code plz
save plz_obs_2dig.dta, replace

use germany_2plz, clear
destring plz, replace
merge m:1 plz using "plz_obs_2dig.dta"
drop _merge

geo2xy _CY _CX, proj (web_mercator) replace //apparently to make it look better...

compress
save germany_obs_2dig, replace



use germany_obs_2dig, clear
spmap observations using germany_2plz_shp, id(_ID) fcolor(YlGnBu) ocolor(white ..) osize(0.1pt ..) clmethod(custom) clbreaks(0(5)35) legstyle(2) title("{bf:A  }Observations across Germany", size(10pt) pos(11) span)
gr_edit .legend.Edit, style(labelstyle(size(8-pt)))
gr_edit .legend.yoffset = -1
graph save "$working_ANALYSIS/results/intermediate/figure2_map_a.gph", replace



// Vaccination map
clear
import delimited "https://raw.githubusercontent.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland/master/Aktuell_Deutschland_Landkreise_COVID-19-Impfungen.csv", clear

rename landkreisid_impfort AGS
drop if AGS == "u"
destring AGS, replace
lab var AGS "Amtlichen Gemeindeschluessel"

keep if impfschutz == 1 //all first dose vaccinations (2=fully vaccinated, 3=refresh)

gen age_group = 1 if altersgruppe == "18-59"
replace age_group = 2 if altersgruppe == "60+"
replace age_group = 3 if altersgruppe == "12-17"

gen date = date(impfdatum, "YMD")
format date %td
drop if date > date("20210602","YMD") //select here the time horizen you want to count. In this case, we only need vaccination numbers until 2021-06-02

rename anzahl no_vacc_AGS
collapse (sum) no_vacc_AGS, by(AGS)
egen tota_no_vaccines = total(no_vacc_AGS) //According to the RKI, 36.6 and 37.2 million were vaccinated on June 1st and 2nd respectively. Here we have 36,537,064 vaccinated individuals

keep AGS no_vacc_AGS
save no_vacc_AGS.dta, replace


*Vaccination share per AGS
import delimited "$working_ANALYSIS/data/map/Postleitzahlengebiete_-_OSM.csv", clear //source: https://opendata-esri-de.opendata.arcgis.com/
drop if ags == "#N/A"
destring ags, replace
gen AGS = floor(ags/1000)

bysort AGS: egen population_AGS = total(einwohner)
merge m:1 AGS using "no_vacc_AGS.dta"
keep if _merge == 3 //we loose AGS 9363, 9565 and 17000 (=197,695 vaccinations)
gen vac_share = no_vacc_AGS / population_AGS
gen unvac_share = 1 - vac_share

rename ïobjectid objectid
keep objectid unvac_share
sum unvac_share
save vac_share_AGS.dta, replace


*Shapefile
clear

spshape2dta "$working_ANALYSIS/data/map/OSM_PLZ.shp", replace saving(germany_AGS)
use germany_AGS_shp
merge m:1 _ID using germany_AGS 
rename OBJECTID objectid
keep _ID _X _Y objectid
sort _ID
save germany_AGS_shp.dta, replace


*Merge vac_share with coordinates
use germany_AGS, clear
rename OBJECTID objectid
merge 1:1 objectid using vac_share_AGS.dta
drop _merge
compress
save germany_vac_share_AGS, replace


use germany_vac_share_AGS, clear
spmap unvac_share using germany_AGS_shp, id(objectid) fcolor(BuYlRd) ocolor(white ..) osize(0pt ..) clmethod(custom) clbreaks(0(0.1)0.95)  legstyle(2) title("{bf:B  }Unvaccinated rate in Germany on June 2, 2021", size(10pt) pos(11) span)
gr_edit .legend.Edit, style(labelstyle(size(8-pt)))
gr_edit .legend.yoffset = -1
graph save "$working_ANALYSIS/results/intermediate/figure2_map_b.gph", replace



// Combine both maps
graph combine "$working_ANALYSIS/results/intermediate/figure2_map_a.gph" "$working_ANALYSIS/results/intermediate/figure2_map_b.gph", row(1)
gr_edit .plotregion1.graph2.legend.yoffset = -3
gr_edit .plotregion1.graph1.legend.yoffset = -3
gr_edit .plotregion1.graph1.legend.xoffset = -1
gr_edit .plotregion1.graph2.legend.xoffset = -1
gr_edit .plotregion1.graph2.plotregion1.AddTextBox added_text editor 5975445.3592471 952490.6959761244
gr_edit .plotregion1.graph2.plotregion1.added_text_new = 1
gr_edit .plotregion1.graph2.plotregion1.added_text_rec = 1
gr_edit .plotregion1.graph2.plotregion1.added_text[1].style.editstyle  angle(default) size( sztype(relative) val(3.4722) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit .plotregion1.graph2.plotregion1.added_text[1].style.editstyle size(6-pt) editcopy
gr_edit .plotregion1.graph2.plotregion1.added_text[1].text = {}
gr_edit .plotregion1.graph2.plotregion1.added_text[1].text.Arrpush © OpenStreetMap contributors
gr_edit .plotregion1.graph2.plotregion1.added_text[1].DragBy -16371.28371776983 464535.1813884209
gr save "$working_ANALYSIS/results/intermediate/figure2_map.gph", replace
gr export "$working_ANALYSIS/results/figures/figure2_map.tif", replace width(4500)





** EOF