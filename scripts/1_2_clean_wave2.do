*--------------------------------------------------------------------------
* SCRIPT: 1_2_clean_wave2.do
* PURPOSE: cleans the raw excel data from the follow-up survey
*--------------------------------------------------------------------------

*----------------------------
* 1) Load dataset downloaded from SoSci
use "$working_ANALYSIS/data/wave2_follow_up_raw.dta", clear


{
/*   Variable und Value Labels */
label variable CASE "Interview-Nummer (fortlaufend)"
label variable SERIAL "Seriennummer (sofern verwendet)"
label variable REF "Referenz (sofern im Link angegeben)"
label variable QUESTNNR "Fragebogen, der im Interview verwendet wurde"
label variable MODE "Interview-Modus"
label variable STARTED "Zeitpunkt zu dem das Interview begonnen hat (Europe/Berlin)"
label variable BE02_01 "sreening: ... 18 Jahre alt oder älter bin."
label variable BE02_04 "sreening: ... die oben genannten Informationen gelesen und verstanden habe."
label variable BE02_05 "sreening: ... an dieser Forschung teilnehmen und mit der Umfrage fortfahren möchte."
label variable BE05_01 "attention_check: Was ist Ihre Lieblingsfarbe?"
label variable BE06_FmF "Format"
label variable BE06_RV1 "POST/GET-Variable: tic"
label variable BE06_RV2 "POST/GET-Variable: psID"
label variable BE08 "attention_reminder: Ausweichoption (negativ) oder Anzahl ausgewählter Optionen"
label variable BE08_01 "attention_reminder: Ich versichere, alle Fragen aufmerksam zu lesen"
label variable SD01_01 "Alter: Ich bin   ... Jahre"
label variable SD02 "Geschlecht"
label variable SD06 "Kinder_12_18"
label variable SD10_01 "Politische Orientierung: Links/Rechts"
label variable SD11 "Partei"
label variable SD12 "Gesundheit"
label variable SD13 "Schwanger"
label variable RP01_01 "Ansteckung: … Sie sich mit Corona zu infizieren?"
label variable RP01_02 "Ansteckung: ... sich jemand von Ihren Freunden oder Familienmitgliedern mit Corona infiziert?"
label variable RP01_03 "Ansteckung: ... sich der durchschnittliche Deutsche mit Corona infiziert?"
label variable RP02 "Stärke Verlauf"
label variable RP03_01 "Verlauf: Sie an Langzeitfolgen nach einer Genesung von Corona leiden würden?"
label variable RP03_02 "Verlauf: Sie an Corona sterben würden, wenn Sie sich infizieren würden?"
label variable RP04_01 "Self-Eval Selbst: Kein Risiko für mich/Hohes Risiko für mich"
label variable RP05_01 "Self-Eval Andere: Kein Risiko für andere/Hohes Risiko für andere"
label variable RP06_01 "Maßnahmen: Nein, keine Maßnahmen nötig/Ja, Maßnahmen dringend nötig"
label variable RP07 "Maßnahmen_Grund: Ausweichoption (negativ) oder Anzahl ausgewählter Optionen"
label variable RP07_01 "Maßnahmen_Grund: Corona ist kein Problem, dass Maßnahmen erfordert"
label variable RP07_02 "Maßnahmen_Grund: Regelt sich von selbst"
label variable RP07_03 "Maßnahmen_Grund: Es gibt kein Corona"
label variable RP07_04 "Maßnahmen_Grund: Bauchgefühl"
label variable RP07_05 "Maßnahmen_Grund: Anderer Grund"
label variable RP08_01 "Emotionen: Aufgeregt"
label variable RP08_02 "Emotionen: Alarmiert"
label variable RP08_03 "Emotionen: Nervös"
label variable RP08_04 "Emotionen: Aufmerksam"
label variable RP08_05 "Emotionen: Ängstlich"
label variable AC01 "erkrankt"
label variable AC01_01 "erkrankt: Ja, Datum"
label variable AC02 "Impfstatus"
label variable AC03 "Termin2_Voll"
label variable AC03_01 "Termin2_Voll: Datum"
label variable AC04 "Termin1_Teil"
label variable AC04_01 "Termin1_Teil: Datum"
label variable AC05 "Termin2_Teil"
label variable AC05_01 "Termin2_Teil: Datum"
label variable AC07 "Termin1_Reg"
label variable AC07_01 "Termin1_Reg: Datum"
label variable AC08 "Ort_Voll"
label variable AC08_03 "Ort_Voll: Anderer Ort"
label variable AC09 "Ort_Teil_Reg"
label variable AC11 "priogruppe"
label variable AC12_01 "Chargenbezeichnung: Chargenbezeichnung (Ch.-B.) der letzten Impfung"
label variable AC13 "Impfung_Abgelehnt"
label variable IV10_05 "Prime_Check: ... über die Sicherheit und Effektivität der Corona-Impfstoffe?"
label variable IV10_06 "Prime_Check: ... über die Vorteile für vollständig geimpfte Personen?"
label variable IV11 "mails_erhalten"
label variable IV12 "mails_gelesen_1"
label variable IV18 "mails_gelesen_2"
label variable IV19 "mails_gelesen_3"
label variable IV20 "mails_gelesen_4"
label variable IV21 "mails_gelesen_5"
label variable IV13 "mails_links_1"
label variable IV22 "mails_links_2"
label variable IV23 "mails_links_3"
label variable IV24 "mails_links_4"
label variable IV25 "mails_links_5"
label variable IV14_01 "mails_inhalt: [01]"
label variable IV15_01 "mails_bewertung: ... informativ"
label variable IV15_02 "mails_bewertung: ... hilfreich"
label variable IV15_03 "mails_bewertung: ... nervig"
label variable IV15_04 "mails_bewertung: ... irreführend"
label variable IN01_03 "confidence1: mRNA-Impfstoffe (BioNTech/Pfizer, Moderna)"
label variable IN01_04 "confidence1: Vektor-Impfstoffe (AstraZeneca, Johnson&amp;Johnson)"
label variable IN02_01 "confidence2: mRNA-Impfstoffe (BioNTech/Pfizer, Moderna)"
label variable IN02_02 "confidence2: Vektor-Impfstoffe (AstraZeneca, Johnson&amp;Johnson)"
label variable IN03_01 "confidence3: mRNA-Impfstoffe (BioNTech/Pfizer, Moderna)"
label variable IN03_02 "confidence3: Vektor-Impfstoffe (AstraZeneca, Johnson&amp;Johnson)"
label variable IN04_01 "rest: Mein Immunsystem ist so stark, es schützt mich auch vor einer Erkrankung an Corona."
label variable IN04_02 "rest: Corona ist nicht so schlimm, dass ich mich dagegen impfen lassen müsste."
label variable IN04_03 "rest: Alltagsstress hält mich davon ab, mich impfen zu lassen."
label variable IN04_04 "rest: Es ist für mich aufwändig, eine Impfung zu erhalten."
label variable IN04_05 "rest: Mein Unwohlsein bei Arztbesuchen hält mich vom Impfen ab."
label variable IN04_06 "rest: Wenn ich daran denke, mich impfen zu lassen, wäge ich Nutzen und Risiken ab, um die bestmögliche Entscheidung z..."
label variable IN04_07 "rest: Ich überlege für jede Impfung sehr genau, ob sie sinnvoll für mich ist."
label variable IN04_08 "rest: Ein volles Verständnis über die Thematik der Impfung ist mir wichtig, bevor ich mich impfen lasse."
label variable IN04_09 "rest: Wenn alle geimpft sind, brauche ich mich nicht auch noch impfen zu lassen."
label variable IN04_10 "rest: Ich lasse mich impfen, weil ich auch Menschen mit einem schwachen Immunsystem schützen kann."
label variable IN04_11 "rest: Impfen ist eine gemeinschaftliche Maßnahme, um die Verbreitung von Krankheiten zu verhindern."
label variable IN05_01 "intention: mRNA-Impfstoffe (z.B. BioNTech/Pfizer, Moderna)"
label variable IN05_02 "intention: Vaxzevria-Impfstoffe (z.B. AstraZeneca)"
label variable IN06_01 "Gründe_Voll: Um mich zu schützen"
label variable IN06_02 "Gründe_Voll: Um Menschen in meinem Umfeld zu schützen"
label variable IN06_03 "Gründe_Voll: Um meinen Teil zur Überwindung der Krise zu leisten (Herdenimmunität)"
label variable IN06_04 "Gründe_Voll: Um Vorteile zu erhalten (z.B. Aufhebung der Kontakt- und Reiseeinschränkungen)"
label variable IN06_05 "Gründe_Voll: Um meine Arbeit behalten zu können"
label variable IN07_01 "Gründe_Teil: Um mich zu schützen"
label variable IN07_02 "Gründe_Teil: Um Menschen in meinem Umfeld zu schützen"
label variable IN07_03 "Gründe_Teil: Um meinen Teil zur Überwindung der Krise zu leisten (Herdenimmunität)"
label variable IN07_04 "Gründe_Teil: Um Vorteile zu erhalten (z.B. Aufhebung der Kontakt- und Reiseeinschränkungen)"
label variable IN08_01 "Gründe_Inaction: Bin noch nicht an der Reihe (Priorisierung)"
label variable IN08_02 "Gründe_Inaction: Habe noch nicht die Zeit dafür gefunden"
label variable IN08_03 "Gründe_Inaction: Weiß nicht, wo ich mich anmelden kann"
label variable IN08_04 "Gründe_Inaction: Kann mich aufgrund vorrübergehenden Zustandes momentan nicht impfen lassen (Schwanger, innerhalb der..."
label variable IN09_01 "Gründe_Nicht: Kann mich aus medizinischen Gründen nicht impfen lassen (z.B. schwanger, Erkrankung, etc.)"
label variable IN09_02 "Gründe_Nicht: Halte es nicht für nötig"
label variable IN09_03 "Gründe_Nicht: Halte es für schädlich"
label variable IN10_01 "Gründe_Andere1: Andere"
label variable IN10_02 "Gründe_Andere1: Andere"
label variable IN11_05 "Gründe_Andere2: Andere: %input:IN10_01%"
label variable IN11_06 "Gründe_Andere2: Andere: %input:IN10_02%"
label variable IN11_07 "Gründe_Andere2: Andere: %input:IN10_03%"
label variable IN12_01 "Gründe_Andere_detail: [01]"
label variable IN14_05 "Gründe_Inaction_Andere2: Andere: %input:IN13_01%"
label variable IN14_06 "Gründe_Inaction_Andere2: Andere: %input:IN13_02%"
label variable IN14_07 "Gründe_Inaction_Andere2: Andere: %input:IN13_03%"
label variable IN15_01 "Überzeugungsarbeit: In der Familie"
label variable IN15_02 "Überzeugungsarbeit: Im engen Freundeskreis"
label variable IN15_03 "Überzeugungsarbeit: In sozialen Netzwerken (z.B. Facebook, Instagram etc.)"
label variable IN16_01 "Überzeugungsarbeit_Andere1: Andere"
label variable IN17_01 "Überzeugungsarbeit_Andere1: Andere: %input:IN16_01%"
label variable IN17_02 "Überzeugungsarbeit_Andere1: Andere: %input:IN16_02%"
label variable IN17_03 "Überzeugungsarbeit_Andere1: Andere: %input:IN16_03%"
label variable IN18_01 "Überzeugungsarbeit_erklärung: [01]"
label variable IN19_01 "intention_detail_angebot: mRNA-Impfstoffe (z.B. BioNTech/Pfizer, Moderna)"
label variable IN19_02 "intention_detail_angebot: Vaxzevria-Impfstoffe (z.B. AstraZeneca)"
label variable IN20_01 "intention_detail_einrichtung: mRNA-Impfstoffe (z.B. BioNTech/Pfizer, Moderna)"
label variable IN20_02 "intention_detail_einrichtung: Vaxzevria-Impfstoffe (z.B. AstraZeneca)"
label variable IN21_01 "intention_detail_einrichtung: mRNA-Impfstoffe (z.B. BioNTech/Pfizer, Moderna)"
label variable IN21_02 "intention_detail_einrichtung: Vaxzevria-Impfstoffe (z.B. AstraZeneca)"
label variable IN32_01 "intention_detail_sanction1: mRNA-Impfstoffe (z.B. BioNTech/Pfizer, Moderna)"
label variable IN32_02 "intention_detail_sanction1: Vaxzevria-Impfstoffe (z.B. AstraZeneca)"
label variable IN33_01 "intention_detail_sanction2: mRNA-Impfstoffe (z.B. BioNTech/Pfizer, Moderna)"
label variable IN33_02 "intention_detail_sanction2: Vaxzevria-Impfstoffe (z.B. AstraZeneca)"
label variable IN22 "wta_50"
label variable IN23 "wta_100"
label variable IN24 "wta_250"
label variable IN25 "wta_500"
label variable IN26 "wta_1000"
label variable IN27 "wta_5000"
label variable IN28 "wta_10000"
label variable IN29 "wta_which"
label variable IN30 "mails_einstellung"
label variable IN31_01 "mails_einstellung_grund: [01]"
label variable DT01_03 "FOMO: Ich befürchte, dass ich es bereuen werde, geimpft worden zu sein, wenn ich später Nebenwirkungen von der Impfun..."
label variable DT01_04 "FOMO: Ich befürchte, dass ich es bereuen werde, nicht geimpft worden zu sein, wenn ich später schwer an Corona erkranke."
label variable DT02 "Empirical Social Norms"
label variable DT16 "Empirical Social Norms"
label variable DT17_01 "intention_children: mRNA-Impfstoffe (z.B. BioNTech/Pfizer, Moderna)"
label variable DT03 "Injunctive Social Norms"
label variable CC03 "Meaningless Responses"
label variable CC06_01 "Anmerkungen: [01]"
label variable TIME001 "Verweildauer Seite 1"
label variable TIME005 "Verweildauer Seite 5"
label variable TIME006 "Verweildauer Seite 6"
label variable TIME007 "Verweildauer Seite 7"
label variable TIME008 "Verweildauer Seite 8"
label variable TIME009 "Verweildauer Seite 9"
label variable TIME010 "Verweildauer Seite 10"
label variable TIME011 "Verweildauer Seite 11"
label variable TIME012 "Verweildauer Seite 12"
label variable TIME013 "Verweildauer Seite 13"
label variable TIME014 "Verweildauer Seite 14"
label variable TIME015 "Verweildauer Seite 15"
label variable TIME016 "Verweildauer Seite 16"
label variable TIME017 "Verweildauer Seite 17"
label variable TIME018 "Verweildauer Seite 18"
label variable TIME019 "Verweildauer Seite 19"
label variable TIME020 "Verweildauer Seite 20"
label variable TIME021 "Verweildauer Seite 21"
label variable TIME022 "Verweildauer Seite 22"
label variable TIME023 "Verweildauer Seite 23"
label variable TIME024 "Verweildauer Seite 24"
label variable TIME025 "Verweildauer Seite 25"
label variable TIME026 "Verweildauer Seite 26"
label variable TIME027 "Verweildauer Seite 27"
label variable TIME028 "Verweildauer Seite 28"
label variable TIME029 "Verweildauer Seite 29"
label variable TIME030 "Verweildauer Seite 30"
label variable TIME031 "Verweildauer Seite 31"
label variable TIME032 "Verweildauer Seite 32"
label variable TIME033 "Verweildauer Seite 33"
label variable TIME034 "Verweildauer Seite 34"
label variable TIME035 "Verweildauer Seite 35"
label variable TIME036 "Verweildauer Seite 36"
label variable TIME037 "Verweildauer Seite 37"
label variable TIME038 "Verweildauer Seite 38"
label variable TIME039 "Verweildauer Seite 39"
label variable TIME040 "Verweildauer Seite 40"
label variable TIME041 "Verweildauer Seite 41"
label variable TIME042 "Verweildauer Seite 42"
label variable TIME043 "Verweildauer Seite 43"
label variable TIME044 "Verweildauer Seite 44"
label variable TIME_SUM "Verweildauer gesamt (ohne Ausreißer)"
label variable MAILSENT "Versandzeitpunkt der Einladungsmail (nur für nicht-anonyme Adressaten)"
label variable LASTDATA "Zeitpunkt als der Datensatz das letzte mal geändert wurde"
label variable FINISHED "Wurde die Befragung abgeschlossen (letzte Seite erreicht)?"
label variable Q_VIEWER "Hat der Teilnehmer den Fragebogen nur angesehen, ohne die Pflichtfragen zu beantworten?"
label variable LASTPAGE "Seite, die der Teilnehmer zuletzt bearbeitet hat"
label variable MAXPAGE "Letzte Seite, die im Fragebogen bearbeitet wurde"
label variable MISSING "Anteil fehlender Antworten in Prozent"
label variable MISSREL "Anteil fehlender Antworten (gewichtet nach Relevanz)"
label variable TIME_RSI "Maluspunkte für schnelles Ausfüllen"
label variable DEG_TIME "Maluspunkte für schnelles Ausfüllen"


label define valueLabelsBE02_01 1 "Ja" 2 "Nein" -9 "nicht beantwortet"
label values BE02_01 BE02_04 BE02_05 SD06 SD13 AC13 DT05 valueLabelsBE02_01
label define valueLabelsBE06_FmF 1 "Computer" 2 "Fernsehgerät" 3 "Tablet" 4 "Mobilgerät" 5 "Smartphone" -2 "unbekannt"
label values BE06_FmF valueLabelsBE06_FmF
label define valueLabelsBE08_01 1 "nicht gewählt" 2 "ausgewählt"
label values BE08_01 RP07_01 RP07_02 RP07_03 RP07_04 RP07_05 valueLabelsBE08_01
label define valueLabelsSD02 1 "Weiblich" 2 "Männlich" 3 "Möchte ich nicht sagen" 4 "Ziehe es vor, mich selbst zu beschreiben:" -9 "nicht beantwortet"
label values SD02 valueLabelsSD02
label define valueLabelsSD10_01 1 "Links" 10 "Rechts" -1 "Keines" -9 "nicht beantwortet"
label values SD10_01 valueLabelsSD10_01
label define valueLabelsSD11 1 "SPD" 2 "CDU" 3 "CSU" 4 "FDP" 5 "Bündnis 90 / Die Grünen" 6 "Die Linke" 7 "AfD" 8 "NPD / Republikaner / Die Rechte" 9 "Andere:" 10 "Keiner" -9 "nicht beantwortet"
label values SD11 valueLabelsSD11
label define valueLabelsSD12 1 "Sehr gut" 2 "Gut" 3 "Zufriedenstellend" 4 "Schlecht" 5 "Sehr schlecht" -9 "nicht beantwortet"
label values SD12 valueLabelsSD12
label define valueLabelsRP01_01 1 "Niedrig (0%)" 101 "Hoch (100%)" -9 "nicht beantwortet"
label values RP01_01 RP01_02 RP01_03 RP03_01 RP03_02 valueLabelsRP01_01
label define valueLabelsRP02 1 "Keine Symptome" 2 "Milde Symptome (z.B. Symptome die einer starken Erkältung oder Grippe ähneln)" 3 "Starke Symptome (z.B. akute Atemnot die ärztliche Behandlung nötig macht)" -9 "nicht beantwortet"
label values RP02 valueLabelsRP02
label define valueLabelsRP04_01 1 "Kein Risiko für mich" 101 "Hohes Risiko für mich" -9 "nicht beantwortet"
label values RP04_01 valueLabelsRP04_01
label define valueLabelsRP05_01 1 "Kein Risiko für andere" 101 "Hohes Risiko für andere" -9 "nicht beantwortet"
label values RP05_01 valueLabelsRP05_01
label define valueLabelsRP06_01 1 "Nein, keine Maßnahmen nötig" 7 "Ja, Maßnahmen dringend nötig" -9 "nicht beantwortet"
label values RP06_01 valueLabelsRP06_01
label define valueLabelsRP08_01 1 "Überhaupt nicht" 7 "Extrem" -9 "nicht beantwortet"
label values RP08_01 RP08_02 RP08_03 RP08_04 RP08_05 IV15_01 IV15_02 IV15_03 IV15_04 valueLabelsRP08_01
label define valueLabelsAC01 1 "Ja, Datum:" 2 "Nein" -9 "nicht beantwortet"
label values AC01 valueLabelsAC01
label define valueLabelsAC02 1 "Bin vollständig geimpft (alle nötigen Impfungen erhalten)" 2 "Bin teilgeimipft (erste von zwei Impfungen erhalten)" 3 "Habe noch keine Impfung, aber einen Impftermin" 4 "Habe noch keinen Impftermin, aber mich für eine Warteliste angemeldet" 5 "Habe weder einen Impftermin, noch mich auf eine Warteliste schreiben lassen" -9 "nicht beantwortet"
label values AC02 valueLabelsAC02
label define valueLabelsAC03 1 "Datum:" -9 "nicht beantwortet"
label values AC03 AC04 AC07 valueLabelsAC03
label define valueLabelsAC05 1 "Datum:" 2 "Habe nicht vor die Zweitimpfung vorzunehmen" -9 "nicht beantwortet"
label values AC05 valueLabelsAC05
label define valueLabelsAC08 1 "Hausarzt" 2 "Impfzentrum" 3 "Anderer Ort:" -9 "nicht beantwortet"
label values AC08 AC09 valueLabelsAC08
label define valueLabelsAC11 1 "Priorisierungsgruppe 1" 2 "Priorisierungsgruppe 2" 3 "Priorisierungsgruppe 3" 4 "Bin in keiner Priorisierungsgruppe" 5 "Weiß ich nicht" -9 "nicht beantwortet"
label values AC11 valueLabelsAC11
label define valueLabelsIV10_05 1 "Gar nicht" 7 "Voll und ganz" -9 "nicht beantwortet"
label values IV10_05 IV10_06 valueLabelsIV10_05
label define valueLabelsIV11 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "> 4" -9 "nicht beantwortet"
label values IV11 IV21 valueLabelsIV11
label define valueLabelsIV12 1 "0" 2 "1" -9 "nicht beantwortet"
label values IV12 valueLabelsIV12
label define valueLabelsIV18 1 "0" 2 "1" 3 "2" -9 "nicht beantwortet"
label values IV18 valueLabelsIV18
label define valueLabelsIV19 1 "0" 2 "1" 3 "2" 4 "3" -9 "nicht beantwortet"
label values IV19 valueLabelsIV19
label define valueLabelsIV20 1 "0" 2 "1" 3 "2" 4 "3" 5 "4" -9 "nicht beantwortet"
label values IV20 valueLabelsIV20
label define valueLabelsIV13 1 "0" 2 "1" -1 "Wurden keine Links angezeigt" -9 "nicht beantwortet"
label values IV13 valueLabelsIV13
label define valueLabelsIV22 1 "0" 2 "1" 3 "2" -1 "Wurden keine Links angezeigt" -9 "nicht beantwortet"
label values IV22 valueLabelsIV22
label define valueLabelsIV23 1 "0" 2 "1" 3 "2" 4 "3" -1 "Wurden keine Links angezeigt" -9 "nicht beantwortet"
label values IV23 valueLabelsIV23
label define valueLabelsIV24 1 "0" 2 "1" 3 "2" 4 "3" 5 "4" -1 "Wurden keine Links angezeigt" -9 "nicht beantwortet"
label values IV24 valueLabelsIV24
label define valueLabelsIV25 1 "0" 2 "1" 3 "2" 4 "3" 5 "4" 6 "&gt; 4" -1 "Wurden keine Links angezeigt" -9 "nicht beantwortet"
label values IV25 valueLabelsIV25
label define valueLabelsIN01_03 1 "Stimme gar nicht zu" 7 "Stimme voll und ganz zu" -9 "nicht beantwortet"
label values IN01_03 IN01_04 IN02_01 IN02_02 IN03_01 IN03_02 IN04_01 IN04_02 IN04_03 IN04_04 IN04_05 IN04_06 IN04_07 IN04_08 IN04_09 IN04_10 IN04_11 DT01_03 DT01_04 valueLabelsIN01_03
label define valueLabelsIN05_01 1 "Auf keinen Fall" 7 "Auf jeden Fall" -9 "nicht beantwortet"
label values IN05_01 IN05_02 IN19_01 IN19_02 IN20_01 IN20_02 IN21_01 IN21_02 IN32_01 IN32_02 IN33_01 IN33_02 DT17_01 valueLabelsIN05_01
label define valueLabelsIN06_01 1 "Nicht wichtig" 7 "Sehr wichtig" -9 "nicht beantwortet"
label values IN06_01 IN06_02 IN06_03 IN06_04 IN06_05 IN07_01 IN07_02 IN07_03 IN07_04 IN08_01 IN08_02 IN08_03 IN08_04 IN09_01 IN09_02 IN09_03 valueLabelsIN06_01
label define valueLabelsIN11_05 1 "" 7 "" -9 "nicht beantwortet"
label values IN11_05 IN11_06 IN11_07 IN14_05 IN14_06 IN14_07 valueLabelsIN11_05
label define valueLabelsIN15_01 1 "Nie" 7 "Immer" -1 "Trifft nicht zu" -9 "nicht beantwortet"
label values IN15_01 IN15_02 IN15_03 valueLabelsIN15_01
label define valueLabelsIN17_01 1 "" 7 "" -1 "" -9 "nicht beantwortet"
label values IN17_01 IN17_02 IN17_03 valueLabelsIN17_01
label define valueLabelsIN22 1 "Impfen und 50 Euro Bonus erhalten" 2 "Nicht impfen" -9 "nicht beantwortet"
label values IN22 valueLabelsIN22
label define valueLabelsIN23 1 "Impfen und 100 Euro Bonus erhalten" 2 "Nicht impfen" -9 "nicht beantwortet"
label values IN23 valueLabelsIN23
label define valueLabelsIN24 1 "Impfen und 250 Euro Bonus erhalten" 2 "Nicht impfen" -9 "nicht beantwortet"
label values IN24 valueLabelsIN24
label define valueLabelsIN25 1 "Impfen und 500 Euro Bonus erhalten" 2 "Nicht impfen" -9 "nicht beantwortet"
label values IN25 valueLabelsIN25
label define valueLabelsIN26 1 "Impfen und 1.000 Euro Bonus erhalten" 2 "Nicht impfen" -9 "nicht beantwortet"
label values IN26 valueLabelsIN26
label define valueLabelsIN27 1 "Impfen und 5.000 Euro Bonus erhalten" 2 "Nicht impfen" -9 "nicht beantwortet"
label values IN27 valueLabelsIN27
label define valueLabelsIN28 1 "Impfen und 10.000 Euro Bonus erhalten" 2 "Nicht impfen" -9 "nicht beantwortet"
label values IN28 valueLabelsIN28
label define valueLabelsIN29 1 "Bonus:" 2 "Würde mich nie impfen lassen" -9 "nicht beantwortet"
label values IN29 valueLabelsIN29
label define valueLabelsIN30 1 "Ablehnung erhöht [1]" 2 "[2]" 3 "[3]" 4 "Keine Veränderung [4]" 5 "[5]" 6 "[6]" 7 "Zustimmung erhöht [7]" -9 "nicht beantwortet"
label values IN30 valueLabelsIN30
label define valueLabelsDT02 1 "1 Niemand" 2 "2" 3 "3" 4 "4 Einige" 5 "5" 6 "6" 7 "7 Alle" -9 "nicht beantwortet"
label values DT02 DT16 valueLabelsDT02
label define valueLabelsDT03 1 "1 Hohe Erwartung, dass ich mich nicht impfen lasse" 2 "2" 3 "3" 4 "4 Keine Erwartungen" 5 "5" 6 "6" 7 "7 Hohe Erwartung, dass ich mich impfen lasse" -9 "nicht beantwortet"
label values DT03 valueLabelsDT03
label define valueLabelsCC03 1 "Ich habe alle Aufgaben, wie in den Instruktionen verlangt, bewältigt." 2 "Manchmal habe ich irgendetwas geklickt, weil ich unmotiviert war oder mich einfach nicht ausgekannt habe." 3 "Ich habe häufig irgendetwas angeklickt, damit ich schnell fertig werde." 4 "Aufgrund von technischen Problemen konnte ich nicht alle Fragen entsprechend beantworten" -9 "nicht beantwortet"
label values CC03 valueLabelsCC03
label define valueLabelsFINISHED 0 "abgebrochen" 1 "ausgefüllt"
label values FINISHED valueLabelsFINISHED
label define valueLabelsQ_VIEWER 0 "Teilnehmer" 1 "Durchklicker"
label values Q_VIEWER valueLabelsQ_VIEWER

}
*----------------------------



*----------------------------
* 2 RENAME & LABEL VARIABLES
{

*** RENAME
{
rename *, lower

*** DROP OBSERVATIONS
*Test-observationen löschen [um ca. 10.50 online gegangen; alles davor tests]
drop if case <=192

*löschen, wenn nicht bis Ende
keep if lastpage==44

*** Save Raw Data
save "$working_ANALYSIS/data/corona_ger_wave2_raw.dta", replace

** Setup
rename be05_01 attention_check
rename be06_fmf device
rename be06_rv1 respondi_tic
rename be06_rv2 respondi_id
gen wave = 2
lab var wave "Wave"

** Sociodemographics
rename sd01_01 age
rename sd02 gender 
rename sd06 children_12_18
rename sd10_01 pol_orientation
rename sd11 pol_party
rename sd11_09 pol_party_other
rename sd12 health
rename sd13 pregnant

** Risk perception
rename rp01_01 risk_infect_self
rename rp01_02 risk_infect_others
rename rp01_03 risk_infect_average
rename rp02    progression
rename rp03_01 long_covid
rename rp03_02 death_covid
rename rp04_01 risk_eval_self
rename rp05_01 risk_eval_others
rename rp06_01 measures
rename rp07 no_measures_reason
label define no_measure_reasons1 1 "Corona does not require any measures" 2 "Regulates itself" 3 "There is no Corona" 4 "Belly feeling" 5 "Other", replace
lab val no_measures_reason no_measure_reasons1
*rename rp07_05a no_measures_reason_other
rename rp08_01 upset // Aufgeregt => Upset ???
rename rp08_02 alert
rename rp08_03 nervous
rename rp08_04 attentive
rename rp08_05 anxious

** Action
rename ac01 had_corona
rename ac01_01 cured_date
rename ac02 vaccine_status
rename ac03_01 date_full
rename ac04_01 date_part1
rename ac05_01 date_part2
*rename ac06_01 date_reg0
rename ac07_01 date_reg1
rename ac11 priority_group
rename ac12_01 batch_nr
rename ac13 vacc_denied

/*
rename ac10 vaccine_place_reg
lab define vaccine_place_reg1 1 "General Practitioner" 2 "Vaccination Center" 3 "Other", replace
lab val vaccine_place_reg vaccine_place_reg1
lab var vaccine_place_reg "Place where registered for vaccination"

rename ac10_03a vaccine_place_reg_other 
lab var vaccine_place_reg_other "OTHER: Place where registered for vaccination"
*/


** Induced Variation / Treatment
rename iv10_05 prime_check1
rename iv10_06 prime_check2


** Intention
rename in01_03 confidence1_mrna
rename in01_04 confidence1_vector
rename in02_01 confidence2_mrna
rename in02_02 confidence2_vector
rename in03_01 confidence3_mrna
rename in03_02 confidence3_vector
rename in04_01 complacency1
rename in04_02 complacency2
rename in04_03 constraints1
rename in04_04 constraints2
rename in04_05 constraints3
rename in04_06 calculation1
rename in04_07 calculation2
rename in04_08 calculation3
rename in04_09 collective1
rename in04_10 collective2
rename in04_11 collective3
rename in05_01 intent_mrna
rename in05_02 intent_vector
rename in08_01 reason_inaction1
rename in08_02 reason_inaction2
rename in08_03 reason_inaction3
rename in08_04 reason_inaction4
rename in09_01 reason_not1
rename in09_02 reason_not2
rename in09_03 reason_not3



*** One variable capturing other reasons for all: action and inaction
/*
vaccine_status == 1 & 2 => action
vaccine_status == 5 & intention(mrna+vector)>2 => inaction but willing
intention(mrna+vector) == 2  => unwilling
*/

rename in11_05 in11_01
rename in11_06 in11_02
rename in11_07 in11_03

forvalues i=1/3 {
gen reason_willing_other`i' = ""
replace reason_willing_other`i' = in10_0`i' if vaccine_status == 1 | vaccine_status == 2 
lab var reason_willing_other`i' "Other reason for being willing to get vacc `i'"
gen reason_willing_other_imp`i' = .
replace reason_willing_other_imp`i' = in11_0`i' if vaccine_status == 1 & in10_0`i'!= ""| vaccine_status == 2
lab var reason_willing_other_imp`i' "Importance of other reason for being willing to get vacc `i'"
}



forvalues i=1/3 {
gen reason_unwilling_other`i' = ""
replace reason_unwilling_other`i' = in10_0`i' if vaccine_status >2 | vaccine_status != .
lab var reason_unwilling_other`i' "Other reason for inaction `i'"
gen reason_unwilling_other_imp`i' = .
replace reason_unwilling_other_imp`i' = in11_0`i' if vaccine_status >2 & vaccine_status != .
lab var reason_unwilling_other_imp`i' "Importance of other reason for inaction `i'"
}

rename in12_01 reason_willingness_detail
rename in15_01 convince_family
rename in15_02 convince_friends
rename in15_03 convince_socialmedia
rename in16_01 convince_other1
*rename in16_02 convince_other2
*rename in16_03 convince_other3
rename in17_01 convince_other1_strength
rename in17_02 convince_other2_strength
rename in17_03 convince_other3_strength
rename in18_01 convince_other_detail

* Detailed intention (only W2)
rename in19_01 int_offer_mrna
rename in19_02 int_offer_vector
rename in20_01 int_shopping_mrna
rename in20_02 int_shopping_vector
rename in21_01 int_mobile_mrna
rename in21_02 int_mobile_vector
rename in32_01 int_test_mrna
rename in32_02 int_test_vector
rename in33_01 int_visit_mrna
rename in33_02 int_visit_vector
rename in22 wta_50
rename in23 wta_100
rename in24 wta_250
rename in25 wta_500
rename in26 wta_1000
rename in27 wta_5000
rename in28 wta_10000
gen wta_other = .
replace wta_other = 0 if in29 == 2
replace wta_other = in29_01 if in29_01 != .
rename dt17_01 int_child


** Mails
* Mails received
rename iv11 mails_received

* Mail Perception
rename iv14_01 mails_content
rename iv15_01 mails_informative
rename iv15_02 mails_helpful
rename iv15_03 mails_annoying
rename iv15_04 mails_misleading

* Mails read
gen mails_read = .
replace mails_read = iv12 if iv12!=.
replace mails_read = iv18 if iv18!=.
replace mails_read = iv19 if iv19!=.
replace mails_read = iv20 if iv20!=.
replace mails_read = 5 if iv21!=.
lab val mails_read valueLabelsIV11 

* Links clicked
gen mails_links = .
replace mails_links = iv13 if iv13!=.
replace mails_links = iv22 if iv22!=.
replace mails_links = iv23 if iv23!=.
replace mails_links = iv24 if iv24!=.
replace mails_links = 5 if iv25!=.
lab val mails_links valueLabelsIV11 

* Intention change due to mail
rename in30 mail_int
rename in31_01 mail_int_reason




** Determinants
* Regret
rename dt01_03 fomo1
rename dt01_04 fomo2

* Norms
rename dt02 norms1
rename dt16 norms2
rename dt03 norms3




*** Comments
rename cc03 responses
rename cc06_01 comments

*** Time on pages
rename time001 time_welcome
rename time005 time_quality_check
rename time006 time_attention_remind
rename dt05 denied_vaccine_past
}


*** LABEL
{
** Setup
lab var attention_check "Attention Check: Color/House"
lab var device "Device used"
lab var respondi_tic "TIC for Respondi"
lab var respondi_id "Personal ID for Respondi"
lab var started "Time/Date when started"
lab var finished "Time/Date when finished"
lab var time_sum "Time needed (in seconds)"

** Sociodemografics
lab var age "Age"
lab var gender "Gender"
lab var pol_orientation "Political orientation (left/right)"
lab var pol_party "Party feeling most attached to"
*lab var pol_party_other "Other: Party feeling most attached to"
lab var health "Health status"
lab var pregnant "Pregnant"


** Risk perception
lab var risk_infect_self "Probability to personally get infected with corona"
lab var risk_infect_others "Probability that significant others get infected with corona"
lab var risk_infect_average "Probability that average german gets infected with corona"
lab var progression "Estimated disease progression if infected"
lab var long_covid "Probability of suffering from long-covid if infected"
lab var death_covid "Probability of dying if infected"
lab var risk_eval_self "Self-evaluation of risk for self (0 no risk; 100 high risk)"
lab var risk_eval_others "Self-evaluation of risk for others (0 no risk; 100 high risk)"
lab var measures "Are measures against corona necessary?"
lab var no_measures_reason "Why are no measures to be taken against corona?"
label define no_measure_reasons1 1 "Corona does not require any measures" 2 "Regulates itself" 3 "There is no Corona" 4 "Belly feeling" 5 "Other", replace
lab val no_measures_reason no_measure_reasons1
*lab var no_measures_reason_other "Other: Why are no measures to be taken against corona?"
lab var upset "Upset when thinking about corona" 
lab var alert "Alert when thinking about corona"
lab var nervous "Nervous when thinking about corona"
lab var attentive "Attentive when thinking about corona"
lab var anxious "Anxious when thinking about corona"


** Action
lab var had_corona "Have you had corona in the past?"
lab var cured_date "When where you symptom free?"
lab var vaccine_status "Vaccination status"
lab var date_full "Fully vaccinated: Date when last vaccination received"
lab var date_part1 "Partially vaccinated: Date when first vaccination received"
lab var date_part2 "Partially vaccinated: Date of second vaccination"
*lab var date_reg0 "Registered: Date of registration"
lab var date_reg1 "Registered: Date of first vaccination"
lab var priority_group "Which priority group are you assigned to?"
lab var batch_nr "What's the batch number of your vaccination?"
lab var prime_check1 "How informed do you feel to be on security and efficacy?"
lab var prime_check2 "How informed do you feel to be on benefits?"
lab var confidence1_mrna "mRNA: I have full confidence in vaccine"
lab var confidence1_vector "Vector: I have full confidence in vaccine"
lab var confidence2_mrna "mRna: Vaccine are effective"
lab var confidence2_vector "Vector: Vaccine are effective"
lab var confidence3_mrna "mRna: Trust that government acts in the best interest of the public"
lab var confidence3_vector "Vector: Trust that government acts in the best interest of the public"
lab var complacency1 "My immune system is strong enough to protect me form corona"
lab var complacency2 "Corona is not as bad that I would not to be vaccinated"
lab var constraints1 "Daily stress keeps me from getting vaccinated"
lab var constraints2 "It's too much hustle for me to get vaccinated"
lab var constraints3 "Me feeling bad at doctor appointments keeps me from getting vaccinated"
lab var calculation1 "I way benefits against costs when thinking about vaccination"
lab var calculation2 "For each vaccination I carefully think about whether it is useful or not"
lab var calculation3 "Full understanding of the topic is important for me before getting vaccinated"
lab var collective1 "If all are vaccinated, I dont need to get vaccinated"
lab var collective2 "I get vaccinated to protect others with a weak immune system"
lab var collective3 "Getting vaccinated is a public matter helping to prevent the spread of the disease"
lab var intent_mrna "Would you get vaccinated with an mRNA-vaccine?"
lab var intent_vector "Would you get vaccinated with a vector-vaccine?"
lab var reason_not1 "Cannot get vaccinated due to medical issues"
lab var reason_not2 "Dont think its necessary get vaccinated"
lab var reason_not3 "Think its harmful to get vaccinated"
lab var reason_willingness_detail "Detailed explanation of own reasons (not) to get vaccinated"
lab var convince_family "How often do you try to convince others in your family?"
lab var convince_friends "How often do you try to convince others of your friends?"
lab var convince_socialmedia "How often do you try to convince others via social media?"
lab var convince_other1 "Other: How often do you try to convince others?"
lab var convince_other2 "Other: How often do you try to convince others?"
lab var convince_other3 "Other: How often do you try to convince others?"
lab var convince_other1_strength "Other strengths: How often do you try to convince others?"
lab var convince_other2_strength "Other strengths: How often do you try to convince others?"
lab var convince_other3_strength "Other strengths: How often do you try to convince others?"
lab var convince_other_detail "Detailed explanation of arguments informed against"
lab var fomo1 "Afraid of regrets if vaccinated"
lab var fomo2 "Afraid of regrets if not vaccinated"
lab var norms1 "What do you think, how many of those close to you will get vaccinated?"
lab var norms2 "What do you think, how many of those close to you got already vaccinated?"
lab var norms3 "What do you think, what do those close to you expect of you regarding vaccination?"
lab var denied_vaccine_past "Refused vaccinations in the past for yourself/your child?"
lab var comments "Further comments"
lab var time_welcome "Time on welcome page"
lab var time_quality_check "Time on quality check page"
lab var time_attention_remind "Time on attention reminder page"

** Second wave only
lab var vacc_denied "Vaccination offer received and denied"
lab var mails_received "Number of mails received"
lab var mails_content "Content of mails"
lab var mails_informative "Perceived mails as informative"
lab var mails_helpful "Perceived mails as helpful"
lab var mails_annoying "Perceived mails as annoying"
lab var mails_misleading "Perceived mails as misleading"
lab var int_offer_mrna "Would vaccinate if received invitation  (mRNA)"
lab var int_offer_vector "Would vaccinate if received invitation (Vector)"
lab var int_shopping_mrna "Would vaccinate if could be during visit of establishment (mRNA)"
lab var int_shopping_vector "Would vaccinate if could be during visit of establishment (Vector)"
lab var int_mobile_mrna "Would vaccinate if mobile team would come by (mRNA)"
lab var int_mobile_vector "Would vaccinate if mobile team would come by (vector)"
lab var int_test_mrna "Would vaccinate if you needed a self-payed test (mRNA)"
lab var int_test_vector "Would vaccinate if you needed a self-payed test (vector)"
lab var int_visit_mrna "Would vaccinate if you couild participate in events only vaccinated (mRNA)"
lab var int_visit_vector "Would vaccinate if you couild participate in events only vaccinated (vector)"
lab var wta_50 "Would you get vaccinated if you received a bonus of 50 EUR"
lab var wta_100 "Would you get vaccinated if you received a bonus of 100 EUR"
lab var wta_250 "Would you get vaccinated if you received a bonus of 250 EUR"
lab var wta_500 "Would you get vaccinated if you received a bonus of 500 EUR"
lab var wta_1000 "Would you get vaccinated if you received a bonus of 1000 EUR"
lab var wta_5000 "Would you get vaccinated if you received a bonus of 5000 EUR"
lab var wta_10000 "Would you get vaccinated if you received a bonus of 10000 EUR"
lab var wta_other "For which amount would you get vaccinated (0 -> not for any amount)"
lab var mail_int "Did the mails affect your willingness to get vaccinated"
lab var mail_int_reason "Reasons for choice of affectedness in intention"
lab var int_child "Would you let your child get vaccinated"

}

}
*----------------------------



*----------------------------
* 3. CHANGE VARIABLES
{
*** Change from 1-6 to 0-5
replace mails_received = (mails_received - 1)
lab val mails_received valueLabelsIV11


*** Change scale to 0-100
foreach x of varlist risk_infect_self risk_infect_others risk_infect_average death_covid long_covid risk_eval_self risk_eval_others {
	replace `x' = (`x'-1)
	}

*** Change to 1-Yes 0-No
lab def y_n 0 "No" 1 "Yes", replace
foreach x of varlist children_12_18 pregnant vacc_denied denied_vaccine_past had_corona {
	replace `x' = (`x'-2)*(-1)
	lab val `x' y_n
	}
	
	
*** Change WTA: 2 NO -> 0 NO
foreach x of varlist wta_50 wta_100 wta_250 wta_500 wta_1000 wta_5000 wta_10000 {
	replace `x' = (`x'-2)*(-1) if `x'==2
	lab val `x' y_n
	}


*** Time
** Transform start time
generate start_time= clock(started, "YMD hms") // Milliseconds since 01.01.1960; ignoring leap seconds
format start_time %tc
lab var start_time  "Date/Time when survey was started"

gen started2 = substr(started, 1, 10)
gen start_time2 =  date(started2, "YMD") // days since 01.01.1960
format start_time2 %td
lab var start_time2  "Date when survey was started"

** Transform finish time
generate finish_time= clock(lastdata, "YMD hms") // Milliseconds since 01.01.1960; ignoring leap seconds
format finish_time %tc
lab var finish_time  "Date/Time when survey was ended"


** Transfer other dates
foreach var in cured_date date_full date_part1 date_part2 /*date_reg0*/ date_reg1 {
gen `var'_new = date(`var', "YMD") // days since 01.01.1960
}

foreach var in cured_date date_full date_part1 date_part2 /*date_reg0*/ date_reg1 {
format `var'_new %td
}

drop cured_date date_full date_part1 date_part2 /*date_reg0*/ date_reg1

foreach var in cured_date date_full date_part1 date_part2 /*date_reg0*/ date_reg1 {
rename `var'_new `var'
}

lab var cured_date "When where you symptom free?"
lab var date_full "Fully vaccinated: Date when last vaccination received"
lab var date_part1 "Partially vaccinated: Date when first vaccination received"
lab var date_part2 "Partially vaccinated: Date of second vaccination"
*lab var date_reg0 "Registered: Date of registration"
lab var date_reg1 "Registered: Date of first vaccination"


}
*----------------------------




*----------------------------
* 4. EXCLUDING OBSERVATIONS
{
/* Exclusion criteria
--- In each wave
(1) Only participants who complete the survey are included in the analysis.
(2) No rushing: Total time needed > 5; No inattention: time / page > 3 minutes
--- In panel sample
(3) Participants who fail the attention test twice will be excluded.
--- Extra:
(4) Participants who stated to not have filled out with high attention (not set in PAP as exclusion criteria)
*/

** (2) Time
* Rushing through
gen exclude_rush = 0
replace exclude_rush = 1 if time_sum <300 // less than 300 sec in survey
lab var exclude_rush "Less than 5 minutes in survey"

* Inattention
*(excluding: Chargenbezeichnung(16), 5Cs (2,21), Justice (38), Risk perception (10), pages with open questions (18,19, 33, 34), non-relevant for Corona (>37))
gen exclude_inattention = 0
/* Don't use for 2nd wave
foreach var in time007 time008 time009 time011 time012 time013 time014 time015 time017 time022 time023 time024 time025 time026 time027 time028 time029 time030 time031 time032 time035 time036 time037 {
replace exclude_inattention = 1 if `var'> 180 & `var'!=. 
}
*/
lab var exclude_inattention "More than 3 minutes on one question page"

* some participants somehow did the survey twice. Keep only the first attempt
sort respondi_id start_time
by respondi_id: gen newid = 1 if _n==1
order newid respondi_id
drop if newid == . // 8 observations

tab exclude_rush // 30 observations
*drop if exclude_rush == 1

tab exclude_inattention //0 observations (did not check)
*drop if exclude_inattention == 1

gen exclude_sloppy=0
replace exclude_sloppy=1 if responses != 1
tab exclude_sloppy // 66 observations
*drop if exclude_sloppy == 1

}
tab  wave
* Sample size: N=987
*----------------------------



*----------------------------
* 5. GENERATE
{

*** Attention Check correct (SETUP)
replace attention_check = lower(attention_check) // All entries to lower case
replace attention_check = "haus" if attention_check == ",,haus"
replace attention_check = "haus" if attention_check == "„haus“"
replace attention_check = "haus" if attention_check == " haus" 
gen attention_check_correct = strpos(attention_check, "haus") // Mark all that contain the word 'haus'
lab var attention_check_correct "The correct word (Haus) was entered"


*** Vaccination place: One joint variable for those fully/partly vaccinated (ACTION)
gen vaccine_place = .
replace vaccine_place = ac08 if ac08 != .
*replace vaccine_place = ac09 if ac09 != .
lab var vaccine_place "Place where vaccination took place"
 
gen vaccine_place_other = ""
replace vaccine_place_other = ac08_03 if ac08_03 != ""
*replace vaccine_place_other = ac09_03 if ac09_03 != ""
lab var vaccine_place_other "OTHER: Place where vaccination took place"


*** Reasons to get vaccinated:One joint variable for those fully/partly/planning to get vaccinated (INTENTION)
gen reason_action1 = .
replace reason_action1 = in06_01 if in06_01  !=. 
replace reason_action1 = in07_01 if in07_01  !=. 
lab var reason_action1 "To protect myself"

gen reason_action2 = .
replace reason_action2 = in06_02 if in06_02  !=. 
replace reason_action2 = in07_02 if in07_02  !=. 
lab var reason_action2 "Protect significant others"

gen reason_action3 = .
replace reason_action3 = in06_03 if in06_03  !=. 
replace reason_action3 = in07_03 if in07_03  !=. 
lab var reason_action3 "Contribute to getting over the crisis"

gen reason_action4 = .
replace reason_action4 = in06_04 if in06_04  !=. 
replace reason_action4 = in07_04 if in07_04  !=. 
lab var reason_action4 "Enjoy benefits"

gen reason_action5 = .
replace reason_action5 = in06_05 if in06_05 !=. 
lab var reason_action5 "To keep my job"








/*Ausweich Option ("Hatte keine Bedenken") wurde als ".a" gespeichert.
replace iv04_01 = -1 if iv04_01 == .a
replace iv04_02 = -1 if iv04_02 == .a
replace iv04_03 = -1 if iv04_03 == .a
replace iv04_04 = -1 if iv04_04 == .a
*/

}
*----------------------------



*----------------------------
* 6. ORDER & KEEP
{

*** Order
order ///
/*Setup*/ case start_time start_time2 finish_time time_sum  device respondi_tic respondi_id wave attention_check attention_check_correct exclude_rush exclude_inattention exclude_sloppy ///
/*treatment*/ prime_check1 prime_check2 /// 
/*Sociodemografics*/ age children_12_18 gender pol_party_other pol_orientation pol_party pol_party_other health pregnant ///
/*Risk perception*/ risk_infect_self risk_infect_others risk_infect_average progression long_covid death_covid risk_eval_self risk_eval_others measures no_measures_reason /*no_measures_reason_other*/ upset alert nervous attentive anxious exclude_rush exclude_inattention ///
/*Action*/ had_corona cured_date vaccine_status date_full date_part1 date_part2 /*date_reg0*/ date_reg1 vaccine_place vaccine_place_other /*vaccine_place_reg vaccine_place_reg_other*/ priority_group batch_nr reason_inaction1 reason_inaction2 reason_inaction3 reason_inaction4 reason_not1 reason_not2 reason_not3 reason_willingness_detail mail_int_reason reason_willing_other1 reason_willing_other_imp1 reason_willing_other2 reason_willing_other_imp2 reason_willing_other3 reason_willing_other_imp3 reason_unwilling_other1 reason_unwilling_other_imp1 reason_unwilling_other2 reason_unwilling_other_imp2 reason_unwilling_other3 reason_unwilling_other_imp3 reason_action1 reason_action2 reason_action3 reason_action4 reason_action5 convince_family convince_friends convince_socialmedia convince_other1 convince_other2 convince_other3 convince_other1_strength convince_other2_strength convince_other3_strength convince_other_detail vacc_denied ///
/*5 cs*/ confidence1_mrna confidence1_vector confidence2_mrna confidence2_vector confidence3_mrna confidence3_vector complacency1 complacency2 constraints1 constraints2 constraints3 calculation1 calculation2 calculation3 collective1 collective2 collective3 ///
/*Mails*/ mails_received mails_read mails_links mails_content mails_informative mails_helpful mails_annoying mails_misleading mail_int mail_int_reason ///
/*Intention*/ intent_mrna intent_vector ///
/*Intention2*/ int_offer_mrna int_offer_vector int_shopping_mrna int_shopping_vector int_mobile_mrna int_mobile_vector int_test_mrna int_test_vector int_visit_mrna int_visit_vector int_child ///
/*Willingness to Accept*/ wta_50 wta_100 wta_250 wta_500 wta_1000 wta_5000 wta_10000 wta_other ///
/*Det1Fomo*/ fomo1 fomo2 ///
/*Det2Norms*/ norms1 norms2 norms3 denied_vaccine_past ///
/*Comments*/ responses comments ///
/*Time spent on pages*/ time_welcome time_quality_check time_attention_remind 



*** Keep
keep ///
/*Setup*/ case start_time start_time2 finish_time time_sum  device respondi_tic respondi_id wave attention_check attention_check_correct exclude_rush exclude_inattention exclude_sloppy ///
/*treatment*/ prime_check1 prime_check2 /// 
/*Sociodemografics*/ age children_12_18 gender pol_party_other pol_orientation pol_party pol_party_other health pregnant ///
/*Risk perception*/ risk_infect_self risk_infect_others risk_infect_average progression long_covid death_covid risk_eval_self risk_eval_others measures no_measures_reason /*no_measures_reason_other*/ upset alert nervous attentive anxious  ///
/*Action*/ had_corona cured_date vaccine_status date_full date_part1 date_part2 /*date_reg0*/ date_reg1 vaccine_place vaccine_place_other /*vaccine_place_reg vaccine_place_reg_other*/ priority_group batch_nr reason_inaction1 reason_inaction2 reason_inaction3 reason_inaction4 reason_not1 reason_not2 reason_not3 reason_willingness_detail mail_int_reason reason_willing_other1 reason_willing_other_imp1 reason_willing_other2 reason_willing_other_imp2 reason_willing_other3 reason_willing_other_imp3 reason_unwilling_other1 reason_unwilling_other_imp1 reason_unwilling_other2 reason_unwilling_other_imp2 reason_unwilling_other3 reason_unwilling_other_imp3 reason_action1 reason_action2 reason_action3 reason_action4 reason_action5 convince_family convince_friends convince_socialmedia convince_other1 convince_other2 convince_other3 convince_other1_strength convince_other2_strength convince_other3_strength convince_other_detail vacc_denied ///
/*5 cs*/ confidence1_mrna confidence1_vector confidence2_mrna confidence2_vector confidence3_mrna confidence3_vector complacency1 complacency2 constraints1 constraints2 constraints3 calculation1 calculation2 calculation3 collective1 collective2 collective3 ///
/*Mails*/ mails_received mails_read mails_links mails_content mails_informative mails_helpful mails_annoying mails_misleading mail_int mail_int_reason ///
/*Intention*/ intent_mrna intent_vector ///
/*Intention2*/ int_offer_mrna int_offer_vector int_shopping_mrna int_shopping_vector int_mobile_mrna int_mobile_vector int_test_mrna int_test_vector int_visit_mrna int_visit_vector int_child ///
/*Willingness to Accept*/ wta_50 wta_100 wta_250 wta_500 wta_1000 wta_5000 wta_10000 wta_other ///
/*Det1Fomo*/ fomo1 fomo2 ///
/*Det2Norms*/ norms1 norms2 norms3 denied_vaccine_past ///
/*Comments*/ responses comments ///
/*Time spent on pages*/ time_welcome time_quality_check time_attention_remind 


}

*----------------------------



*----------------------------
* 6. SAVE

save "$working_ANALYSIS/processed/corona_ger_wave2_clean.dta", replace

*----------------------------




** EOF