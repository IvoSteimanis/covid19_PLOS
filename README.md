# Replication Package
This repository contains the raw data and code that replicates tables and figures for the following paper: <br><br>
__Title:__ Repeated information of benefits reduces COVID-19 vaccination hesitancy: Experimental evidence from Germany <br>
__Authors:__ Max Burger<sup>1,*</sup>, Matthias Mayer<sup>1</sup> & Ivo Steimanis<sup>1</sup> <br>
__Affiliations:__ <sup>1</sup> Department of Economics, Philipps University Marburg, 35032 Marburg, Germany <br>
__*Correspondence to:__ Max Burger maximilian.burger@wiwi.uni-marburg.de <br>
__ORCID:__ Burger: 0000-0003-2334-3885, Mayer: 0000-0003-0323-9124, Steimanis: 0000-0002-8550-4675 <br>
__Classification:__ Social Sciences, Economic Sciences <br>
__Keywords:__ vaccination hesitancy, vaccination intentions, vaccination action, survey experiment, repeated information <br>

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6327480.svg)](https://doi.org/10.5281/zenodo.6327480)
## Abstract
__Background:__ Many countries, such as Germany, struggle to vaccinate enough people against COVID-19 despite the availability of safe and efficient vaccines. With new variants emerging and the need for booster vaccinations, overcoming vaccination hesitancy gains importance. The research to date has unveiled some promising, albeit contentious, interventions to increase vaccination intentions. However, these have yet to be tested for their effectiveness in increasing vaccination rates. <br><br>
__Methods & Results:__ We conducted a preregistered survey experiment with N=1,324 participants in Germany in May/June 2021, which was followed by a series of emails reminding participants to get vaccinated in August and concluded by a follow-up survey in September. We experimentally assess whether debunking vaccination myths, highlighting the benefits of being vaccinated, or merely sending vaccination reminders decreases hesitancy. In the survey experiment, we find no increase in the intention to vaccinate regardless of the information provided. However, communicating vaccination benefits over several weeks reduced vaccination hesitancy, i.e., not being vaccinated, by 9 percentage points, which translates into a 27% reduction compared to the control group. Debunking vaccination myths and reminders alone also decreased hesitancy, yet not significantly.<br><br>
__Discussion:__ Our findings suggest that if soft governmental interventions such as information campaigns are employed, highlighting benefits should be given preference over debunking vaccination myths. Furthermore, it seems that repeated messages affect vaccination action while one-time messages might be insufficient, even for increasing vaccination intentions. Our study highlights the importance of testing interventions outside of survey experiments that are limited to measuring vaccination intentions – not actions – and immediate changes in attitudes and intentions – not long-term changes.

## License
The data are licensed under a Creative Commons Attribution 4.0 International Public License. The code is licensed under a Modified BSD License. See __LICENSE.txt__ for details.

## Software requirements
All analysis were done in Stata version 16:
- Add-on packages are included in __scripts/libraries/stata__ and do not need to be installed by user. The names, installation sources, and installation dates of these packages are available in __scripts/libraries/stata/stata.trk__.

## Instructions
1.	Save the folder __‘replication_PLOS’__ to your local drive.
2.	Open the master script __‘run.do’__ and change the global pointing to the working direction (line 20) to the location where you save the folder on your local drive 
3.	Run the master script __‘run.do’__  to replicate the analysis and generate all tables and figures reported in the paper and supplementary online materials

## Datasets
- Wave 1 – Survey experiment: __‘wave1_survey_experiment_raw.dta’__
- Wave 2 – Follow-up Survey: __‘wave2_follow_up_raw.dta'__
- Map: shape-files __‘plz2stellig.shp’ ‘OSM_PLZ.shp’__, area codes __‘Postleitzahlengebiete_-_OSM.csv’__,  (all links to the sources can be found in the script ‘04_figure2_germany_map.do’)
- Pretest: __‘pre-test_corona_raw.dta’__
- For Appendix S7: __‘alter_geschlecht_zensus_det.xlsx’, ‘vaccination_landkreis_raw.dta’, ‘census2020_age_gender.csv’__ (all links to the sources can be found in the script ‘06_AppendixS7.do’)
- For Appendix S10: ‘__vaccination_landkreis_raw.dta’__ (all links to the sources can be found in the script ‘07_AppendixS10.do’)

## Descriptions of scripts
__1_1_clean_wave1.do__ <br>
This script processes the raw data from wave 1, the survey experiment <br>
__1_2_clean_wave2.do__ <br>
This script processes the raw data from wave 2, the follow-up survey <br>
__1_3_merge_generate.do__ <br>
This script creates the datasets used in the main analysis and for robustness checks by merging the cleaned data from wave 1 and 2, tests the exclusion criteria and creates additional variables <br>
__02_analysis.do__ <br>
This script estimates regression models in Stata, creates figures and tables, saving them to __results/figures and results/tables__ <br>
__03_robustness_checks_no_exclusion.do__ <br>
This script runs the main analysis using the dataset without applying the exclusion criteria. Results are saved in __results/tables__ <br>
__04_figure2_germany_map.do__  <br>
This script creates Figure 2 in the main manuscript using publicly available data on vaccination numbers in Germany. <br>
__05_figureS1_dogmatism_scale.do__ <br>
This script creates Figure S1 using data from a pretest to adjust the dogmatism scale. <br>
__06_AppendixS7.do__ <br>
This script creates the figures and tables provided in Appendix S7 on the representativity of our sample compared to the German average using publicly available data about the age distribution in Germany. <br>
__07_AppendixS10.do__ <br>
This script creates the figures and tables provided in Appendix S10 on the external validity of vaccination rates in our sample using publicly available data on vaccination numbers in Germany.





