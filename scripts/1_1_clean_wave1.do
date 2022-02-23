*--------------------------------------------------------------------------
* SCRIPT: 1_1_clean_wave1.do
* PURPOSE: cleans the raw excel data from the survey experiment 
*--------------------------------------------------------------------------

*----------------------------
* 1) Load dataset downloaded from SoSci
use "$working_ANALYSIS/data/wave1_survey_experiment_raw.dta", clear

*----------------------------



*----------------------------
* Variable und Value Labels
{
label variable CASE "Interview-Nummer (fortlaufend)"
label variable SERIAL "Seriennummer (sofern verwendet)"
label variable REF "Referenz (sofern im Link angegeben)"
label variable QUESTNNR "Fragebogen, der im Interview verwendet wurde"
label variable MODE "Interview-Modus"
label variable STARTED "Zeitpunkt zu dem das Interview begonnen hat (Europe/Berlin)"
label variable BE02_01 "sreening: ... 18 Jahre alt oder älter bin."
label variable BE02_02 "sreening: ... bisher keine Corona Impfung erhalten habe (weder voll- noch teilgeimpft)."
label variable BE02_03 "sreening: ... einverstanden bin, im Rahmen dieses Forschungsprojektes bis zu vier E-Mails zu erhalten."
label variable BE02_04 "sreening: ... die oben genannten Informationen gelesen und verstanden habe."
label variable BE02_05 "sreening: ... an dieser Forschung teilnehmen und mit der Umfrage fortfahren möchte."
label variable BE05_01 "attention_check: Was ist Ihre Lieblingsfarbe?"
label variable BE06_FmF "Format"
label variable BE06_RV1 "POST/GET-Variable: tic"
label variable BE06_RV2 "POST/GET-Variable: psID"
label variable BE07_01 "respondi-id: Respondi ID"
label variable BE08 "attention_reminder: Ausweichoption (negativ) oder Anzahl ausgewählter Optionen"
label variable BE08_01 "attention_reminder: Ich versichere, alle Fragen aufmerksam zu lesen"
label variable SD01_01 "Alter: Ich bin   ... Jahre"
label variable SD02 "Geschlecht"
label variable SD03 "Familienstand"
label variable SD04 "Einkommen"
label variable SD05 "Formale Bildung"
label variable SD06 "Kinder_12_18"
label variable SD07_01 "Personen_Haushalt: Personen unter 14 Jahren"
label variable SD07_02 "Personen_Haushalt: Personen im Alter von 14 Jahren oder Älter"
label variable SD08_01 "Ort: Postleitzahl"
label variable SD09 "Dichte"
label variable SD10_01 "Politische Orientierung: Links/Rechts"
label variable SD11 "Partei"
label variable SD11_09 "Partei: Andere"
label variable SD12 "Gesundheit"
label variable SD13 "Schwanger"
label variable SD14_01 "quotenstopp: agegroup-gender"
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
label variable AC06 "Termin0_Reg"
label variable AC06_01 "Termin0_Reg: Datum"
label variable AC07 "Termin1_Reg"
label variable AC07_01 "Termin1_Reg: Datum"
label variable AC08 "Ort_Voll"
label variable AC09 "Ort_Teil_Reg"
label variable AC09_03 "Ort_Teil_Reg: Anderer Ort"
label variable AC10 "Liste_Reg: Ausweichoption (negativ) oder Anzahl ausgewählter Optionen"
label variable AC10_01 "Liste_Reg: Hausarzt"
label variable AC10_02 "Liste_Reg: Impfzentrum"
label variable AC10_03 "Liste_Reg: Andere Ort"
label variable AC10_03a "Liste_Reg: Andere Ort (offene Eingabe)"
label variable AC11 "priogruppe"
label variable AC12_01 "Chargenbezeichnung: Chargenbezeichnung (Ch.-B.) der letzten Impfung"
label variable IV01_CP "treatment: Vollständige Leerungen der Urne bisher"
label variable IV01 "treatment: Gezogener Code"
label variable IV02 "T1 Debunking Teaser"
label variable IV03_01 "T1 Sorting: Schnelle Zulassung"
label variable IV03_02 "T1 Sorting: Effektivität des Schutz"
label variable IV03_03 "T1 Sorting: Nebenwirkungen"
label variable IV03_04 "T1 Sorting: Nachwirkung der Impfung"
label variable IV04_01 "T1 Bedenken Reduziert: Schnelle Zulassung"
label variable IV04_02 "T1 Bedenken Reduziert: Effektivität des Schutz"
label variable IV04_03 "T1 Bedenken Reduziert: Nebenwirkungen"
label variable IV04_04 "T1 Bedenken Reduziert: Nachwirkung der Impfung"
label variable IV06 "T2 Benefits Teaser"
label variable IV07_01 "T2 Sorting: Eigener Schutz"
label variable IV07_02 "T2 Sorting: Schutz anderer"
label variable IV07_03 "T2 Sorting: Aufhebung Kontaktbeschränkung"
label variable IV07_04 "T2 Sorting: Keine Quarantäne"
label variable IV08_05 "T2 Zustimmung erhöht: Eigner Schutz"
label variable IV08_06 "T2 Zustimmung erhöht: Schutz der anderen"
label variable IV08_07 "T2 Zustimmung erhöht: Aufhebung der Kontaktbeschränkung und Reisefreiheit"
label variable IV08_08 "T2 Zustimmung erhöht: Aufhebung der Quarantänepflicht"
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
label variable IN10_03 "Gründe_Andere1: Andere"
label variable IN11_05 "Gründe_Andere2: Andere: %input:IN10_01%"
label variable IN11_06 "Gründe_Andere2: Andere: %input:IN10_02%"
label variable IN11_07 "Gründe_Andere2: Andere: %input:IN10_03%"
label variable IN12_01 "Gründe_Andere_detail: [01]"
label variable IN13_01 "Gründe_Inaction_Andere1: Andere"
label variable IN14_05 "Gründe_Inaction_Andere2: Andere: %input:IN13_01%"
label variable IN14_06 "Gründe_Inaction_Andere2: Andere: %input:IN13_02%"
label variable IN14_07 "Gründe_Inaction_Andere2: Andere: %input:IN13_03%"
label variable IN15_01 "Überzeugungsarbeit: In der Familie"
label variable IN15_02 "Überzeugungsarbeit: Im engen Freundeskreis"
label variable IN15_03 "Überzeugungsarbeit: In sozialen Netzwerken (z.B. Facebook, Instagram etc.)"
label variable IN17_01 "Überzeugungsarbeit_Andere1: Andere: %input:IN16_01%"
label variable IN17_02 "Überzeugungsarbeit_Andere1: Andere: %input:IN16_02%"
label variable IN17_03 "Überzeugungsarbeit_Andere1: Andere: %input:IN16_03%"
label variable IN18_01 "Überzeugungsarbeit_erklärung: [01]"
label variable DT01_03 "FOMO: Ich befürchte, dass ich es bereuen werde, geimpft worden zu sein, wenn ich später Nebenwirkungen von der Impfun..."
label variable DT01_04 "FOMO: Ich befürchte, dass ich es bereuen werde, nicht geimpft worden zu sein, wenn ich später schwer an Corona erkranke."
label variable DT02 "Empirical Social Norms"
label variable DT16 "Empirical Social Norms"
label variable DT03 "Injunctive Social Norms"
label variable DT05 "Impfvergangenheit"
label variable DT06_01 "Dogmatismus: Jede Person, die ehrlich und wahrhaftig nach der Wahrheit sucht, wird am Ende zu den gleichen Schlüssen ..."
label variable DT06_02 "Dogmatismus: Die Dinge, an die ich glaube, sind so vollkommen wahr, dass ich niemals an ihnen zweifeln könnte."
label variable DT06_03 "Dogmatismus: Meine Meinungen sind richtig und werden sich bewähren."
label variable DT06_04 "Dogmatismus: Meine Meinungen und Überzeugungen passen perfekt zusammen und ergeben ein glasklares &quot;Bild&quot; de..."
label variable DT06_05 "Dogmatismus: Es gibt keine Entdeckungen oder Fakten, die mich dazu bringen könnten, meine Meinung über die wichtigste..."
label variable DT06_06 "Dogmatismus: Ich bin weit davon entfernt, endgültige Schlüsse über die zentralen Fragen des Lebens zu ziehen."
label variable DT06_07 "Dogmatismus: Ich bin mir absolut sicher, dass meine Vorstellungen über die grundlegenden Fragen des Lebens richtig sind."
label variable DT06_08 "Dogmatismus: Wenn Personen in Bezug auf die wichtigsten Dinge im Leben &quot;aufgeschlossen&quot; sind, werden sie wa..."
label variable DT06_09 "Dogmatismus: In zwanzig Jahren werden sich einige meiner Meinungen über die wichtigen Dinge des Lebens wahrscheinlich..."
label variable DT07_11 "Risiko Präferenz: Überhaupt nicht bereit, Risiken einzugehen/Sehr bereit, Risiken einzugehen"
label variable DT15_11 "Zeit Präferenz: Beschreibt mich überhaupt nicht/Beschreibt mich perfekt"
label variable DT09 "svo1"
label variable DT10 "svo2"
label variable DT11 "svo3"
label variable DT12 "svo4"
label variable DT13 "svo5"
label variable DT14 "svo6"
label variable CC03 "Meaningless Responses"
label variable CC06_01 "Anmerkungen: [01]"
label variable TIME001 "Verweildauer Seite 1"
label variable TIME003 "Verweildauer Seite 3"
label variable TIME004 "Verweildauer Seite 4"
label variable TIME005 "Verweildauer Seite 5"
label variable TIME006 "Verweildauer Seite 6"
label variable TIME007 "Verweildauer Seite 7"
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
label variable TIME020 "Time at Treatment 1: Debunking"
label variable TIME021 "Verweildauer Seite 21"
label variable TIME022 "Time at Treatment 2: Benefits"
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
label values BE02_01 BE02_02 BE02_03 BE02_04 BE02_05 SD06 SD13 DT05 valueLabelsBE02_01
label define valueLabelsBE06_FmF 1 "Computer" 2 "Fernsehgerät" 3 "Tablet" 4 "Mobilgerät" 5 "Smartphone" -2 "unbekannt"
label values BE06_FmF valueLabelsBE06_FmF
label define valueLabelsBE08_01 1 "nicht gewählt" 2 "ausgewählt"
label values BE08_01 RP07_01 RP07_02 RP07_03 RP07_04 RP07_05 AC10_01 AC10_02 AC10_03 valueLabelsBE08_01
label define valueLabelsSD02 1 "Weiblich" 2 "Männlich" 3 "Möchte ich nicht sagen" 4 "Ziehe es vor, mich selbst zu beschreiben:" -9 "nicht beantwortet"
label values SD02 valueLabelsSD02
label define valueLabelsSD03 1 "Verheiratet" 2 "Eingetragene gleichgeschlechtliche Partnerschaft (Eintragung war bis 2017 möglich und kann weiterhin gültig sein)" 3 "Ledig, war nie Verheiratet" 4 "Geschieden / eingetragene gleichgeschlechtliche Partnerschaft aufgehoben" 5 "Verwitwet" 6 "Möchte ich nicht beantworten" -9 "nicht beantwortet"
label values SD03 valueLabelsSD03
label define valueLabelsSD04 1 "weniger als 250 €" 2 "250 € bis unter 500 €" 3 "500 € bis unter 1000 €" 4 "1000 € bis unter 1500 €" 5 "1500 € bis unter 2000 €" 6 "2000 € bis unter 2500 €" 7 "2500 € bis unter 3000 €" 8 "3000 € bis unter 3500 €" 9 "3500 € bis unter 4000 €" 10 "4000 € bis unter 4500 €" 11 "4500 € bis unter 5000 €" 12 "5000 € und mehr" -9 "nicht beantwortet"
label values SD04 valueLabelsSD04
label define valueLabelsSD05 1 "Noch Schüler" 2 "Schule beendet ohne Abschluss" 3 "Hauptschulabschluss/Volksschulabschluss" 4 "Realschulabschluss (Mittlere Reife)" 6 "Fachhochschulreife (Abschluss einer Fachoberschule)" 7 "Abitur, allgemeine oder fachgebundene Hochschulreife (Gymnasium bzw. EOS)" 8 "Fach-/ Hochschulabschluss (Master, Bachelor, Diplom, Magister, Staatsexamen, etc.)" 9 "Anderer Schulabschluss:" -9 "nicht beantwortet"
label values SD05 valueLabelsSD05
label define valueLabelsSD09 1 "&lt; 1.000" 2 "1.000 – 5.000" 3 "5.000 – 25.000" 4 "25.000 - 50.000" 5 "50.000 – 100.000" 6 "100.000 – 250.000" 7 "250.000 - 500.000" 8 "&gt; 500.000" -9 "nicht beantwortet"
label values SD09 valueLabelsSD09
label define valueLabelsSD10_01 1 "Links" 10 "Rechts" -1 "Keines" -9 "nicht beantwortet"
label values SD10_01 valueLabelsSD10_01
label define valueLabelsSD11 1 "SPD" 2 "CDU" 3 "CSU" 4 "FDP" 5 "Bündnis 90 / Die Grünen" 6 "Die Linke" 7 "AfD" 8 "NPD / Republikaner / Die Rechte" 9 "Andere:" 10 "Keiner" -9 "nicht beantwortet"
label values SD11 valueLabelsSD11
label define valueLabelsSD12 1 "Sehr gut" 2 "Gut" 3 "Zufriedenstellend" 4 "Schlecht" 5 "Sehr schlecht" -9 "nicht beantwortet"
label values SD12 valueLabelsSD12
label define valueLabelsRP02 1 "Keine Symptome" 2 "Milde Symptome (z.B. Symptome die einer starken Erkältung oder Grippe ähneln)" 3 "Starke Symptome (z.B. akute Atemnot die ärztliche Behandlung nötig macht)" -9 "nicht beantwortet"
label values RP02 valueLabelsRP02
label define valueLabelsRP06_01 1 "Nein, keine Maßnahmen nötig" 7 "Ja, Maßnahmen dringend nötig" -9 "nicht beantwortet"
label values RP06_01 valueLabelsRP06_01
label define valueLabelsRP08_01 1 "Überhaupt nicht" 7 "Extrem" -9 "nicht beantwortet"
label values RP08_01 RP08_02 RP08_03 RP08_04 RP08_05 valueLabelsRP08_01
label define valueLabelsAC01 1 "Ja, Datum:" 2 "Nein" -9 "nicht beantwortet"
label values AC01 valueLabelsAC01
label define valueLabelsAC02 1 "Bin vollständig geimpft (alle nötigen Impfungen erhalten)" 2 "Bin teilgeimipft (erste von zwei Impfungen erhalten)" 3 "Habe noch keine Impfung, aber einen Impftermin" 4 "Habe noch keinen Impftermin, aber mich für eine Warteliste angemeldet" 5 "Habe weder einen Impftermin, noch mich auf eine Warteliste schreiben lassen" -9 "nicht beantwortet"
label values AC02 valueLabelsAC02
label define valueLabelsAC03 1 "Datum:" -9 "nicht beantwortet"
label values AC03 AC04 AC05 AC06 AC07 valueLabelsAC03
label define valueLabelsAC08 1 "Hausarzt" 2 "Impfzentrum" 3 "Anderer Ort:" -9 "nicht beantwortet"
label values AC08 AC09 valueLabelsAC08
label define valueLabelsAC11 1 "Priorisierungsgruppe 1" 2 "Priorisierungsgruppe 2" 3 "Priorisierungsgruppe 3" 4 "Bin in keiner Priorisierungsgruppe" 5 "Weiß ich nicht" -9 "nicht beantwortet"
label values AC11 valueLabelsAC11
label define valueLabelsIV01 1 "Debunk" 2 "Benefits" 3 "Facilitator" 4 "Control"
label values IV01 valueLabelsIV01
label define valueLabelsIV02 1 "1 Sehr wenige" 2 "2" 3 "3" 4 "4 Enige" 5 "5" 6 "6" 7 "7 Der Großteil" -9 "nicht beantwortet"
label values IV02 valueLabelsIV02
label define valueLabelsIV03_01 1 "Rangplatz 1" 2 "Rangplatz 2" 3 "Rangplatz 3" 4 "Rangplatz 4" -9 "nicht eingeordnet"
label values IV03_01 IV03_02 IV03_03 IV03_04 IV07_01 IV07_02 IV07_03 IV07_04 valueLabelsIV03_01
label define valueLabelsIV04_01 1 "Gar nicht reduziert" 7 "Vollständig reduziert" -1 "Hatte diesbezüglich keine Bedenken" -9 "nicht beantwortet"
label values IV04_01 IV04_02 IV04_03 IV04_04 valueLabelsIV04_01
label define valueLabelsIV06 1 "1 Sehr wenige" 2 "2" 3 "3" 4 "4 Einige" 5 "5" 6 "6" 7 "7 Der Großteil" -9 "nicht beantwortet"
label values IV06 valueLabelsIV06
label define valueLabelsIV08_05 1 "Gar nicht bewusst" 7 "Volkommen bewusst" -9 "nicht beantwortet"
label values IV08_05 IV08_06 IV08_07 IV08_08 valueLabelsIV08_05
label define valueLabelsIN01_03 1 "Stimme gar nicht zu" 7 "Stimme voll und ganz zu" -9 "nicht beantwortet"
label values IN01_03 IN01_04 IN02_01 IN02_02 IN03_01 IN03_02 IN04_01 IN04_02 IN04_03 IN04_04 IN04_05 IN04_06 IN04_07 IN04_08 IN04_09 IN04_10 IN04_11 DT01_03 DT01_04 DT06_01 DT06_02 DT06_03 DT06_04 DT06_05 DT06_06 DT06_07 DT06_08 DT06_09 valueLabelsIN01_03
label define valueLabelsIN05_01 1 "Auf keinen Fall" 7 "Auf jeden Fall" -9 "nicht beantwortet"
label values IN05_01 IN05_02 valueLabelsIN05_01
label define valueLabelsIN06_01 1 "Nicht wichtig" 7 "Sehr wichtig" -9 "nicht beantwortet"
label values IN06_01 IN06_02 IN06_03 IN06_04 IN06_05 IN07_01 IN07_02 IN07_03 IN07_04 IN08_01 IN08_02 IN08_03 IN08_04 IN09_01 IN09_02 IN09_03 valueLabelsIN06_01
label define valueLabelsIN11_05 1 "" 7 "" -9 "nicht beantwortet"
label values IN11_05 IN11_06 IN11_07 IN14_05 IN14_06 IN14_07 valueLabelsIN11_05
label define valueLabelsIN15_01 1 "Nie" 7 "Immer" -1 "Trifft nicht zu" -9 "nicht beantwortet"
label values IN15_01 IN15_02 IN15_03 valueLabelsIN15_01
label define valueLabelsIN17_01 1 "" 7 "" -1 "" -9 "nicht beantwortet"
label values IN17_01 IN17_02 IN17_03 valueLabelsIN17_01
label define valueLabelsDT02 1 "1 Niemand" 2 "2" 3 "3" 4 "4 Einige" 5 "5" 6 "6" 7 "7 Alle" -9 "nicht beantwortet"
label values DT02 DT16 valueLabelsDT02
label define valueLabelsDT03 1 "1 Hohe Erwartung, dass ich mich nicht impfen lasse" 2 "2" 3 "3" 4 "4 Keine Erwartungen" 5 "5" 6 "6" 7 "7 Hohe Erwartung, dass ich mich impfen lasse" -9 "nicht beantwortet"
label values DT03 valueLabelsDT03
label define valueLabelsDT07_11 1 "Überhaupt nicht bereit, Risiken einzugehen [0]" 11 "Sehr bereit, Risiken einzugehen [10]" 2 "[1]" 3 "[2]" 4 "[3]" 5 "[4]" 6 "[5]" 7 "[6]" 8 "[7]" 9 "[8]" 10 "[9]" -9 "nicht beantwortet"
label values DT07_11 valueLabelsDT07_11
label define valueLabelsDT15_11 1 "Beschreibt mich überhaupt nicht [0]" 11 "Beschreibt mich perfekt [10]" 2 "[1]" 3 "[2]" 4 "[3]" 5 "[4]" 6 "[5]" 7 "[6]" 8 "[7]" 9 "[8]" 10 "[9]" -9 "nicht beantwortet"
label values DT15_11 valueLabelsDT15_11
label define valueLabelsDT09 1 "85 € | 85 €" 2 "85 € | 76 €" 3 "85 € | 68 €" 4 "85 € | 59 €" 5 "85 € | 50 €" 6 "85 € | 41 €" 7 "85 € | 33 €" 8 "85 € | 24 €" 9 "85 € | 15 €" -9 "nicht beantwortet"
label values DT09 valueLabelsDT09
label define valueLabelsDT10 1 "85 € | 15 €" 2 "87 € | 19 €" 3 "89 € | 24 €" 4 "91 € | 28 €" 5 "93 € | 33 €" 6 "94 € | 37 €" 7 "96 € | 41 €" 8 "98 € | 46 €" 9 "100 € | 50 €" -9 "nicht beantwortet"
label values DT10 valueLabelsDT10
label define valueLabelsDT11 1 "50 € | 100 €" 2 "54 € | 98 €" 3 "59 € | 96 €" 4 "63 € | 64 €" 5 "68 € | 93 €" 6 "72 € | 91 €" 7 "76 € | 89 €" 8 "81 € | 87 €" 9 "85 € | 85 €" -9 "nicht beantwortet"
label values DT11 valueLabelsDT11
label define valueLabelsDT12 1 "50 € | 100 €" 2 "54 € | 89 €" 3 "59 € | 79 €" 4 "63 € | 68 €" 5 "68 € | 58 €" 6 "72 € | 47 €" 7 "76 € | 36 €" 8 "81 € | 26 €" 9 "85 € | 15 €" -9 "nicht beantwortet"
label values DT12 valueLabelsDT12
label define valueLabelsDT13 1 "100 € | 50 €" 2 "94 € | 56 €" 3 "88 € | 63 €" 4 "81 € | 69 €" 5 "75 € | 75 €" 6 "69 € | 81 €" 7 "63 € | 88 €" 8 "56 € | 94 €" 9 "50 € | 100 €" -9 "nicht beantwortet"
label values DT13 valueLabelsDT13
label define valueLabelsDT14 1 "100 € | 50 €" 2 "98 € | 54 €" 3 "96 € | 59 €" 4 "94 € | 63 €" 5 "93 € | 68 €" 6 "91 € | 72 €" 7 "89 € | 76 €" 8 "87 € | 81 €" 9 "85 € | 85 €" -9 "nicht beantwortet"
label values DT14 valueLabelsDT14
label define valueLabelsCC03 1 "Ich habe alle Aufgaben, wie in den Instruktionen verlangt, bewältigt." 2 "Manchmal habe ich irgendetwas geklickt, weil ich unmotiviert war oder mich einfach nicht ausgekannt habe." 3 "Ich habe häufig irgendetwas angeklickt, damit ich schnell fertig werde." 4 "Aufgrund von technischen Problemen konnte ich nicht alle Fragen entsprechend beantworten" -9 "nicht beantwortet"
label values CC03 valueLabelsCC03
label define valueLabelsFINISHED 0 "abgebrochen" 1 "ausgefüllt"
label values FINISHED valueLabelsFINISHED
label define valueLabelsQ_VIEWER 0 "Teilnehmer" 1 "Durchklicker"
label values Q_VIEWER valueLabelsQ_VIEWER
}

*----------------------------



*----------------------------
* 2. RENAME LOWER, DROP TEST-OBSERVATIONS & LABEL VARIABLES
{

*** RENAME
rename *, lower

*** DROP OBSERVATIONS
*Test-observationen löschen [um ca. 17.00 online gegangen; alles davor tests]
drop if case <=891

*löschen, wenn nicht bis Ende
keep if lastpage==33


*** Save Raw Data
save "$working_ANALYSIS/data/corona_ger_wave1_raw.dta", replace



** Setup
rename be05_01 attention_check
rename be06_fmf device
rename be06_rv1 respondi_tic
destring be06_rv2 , generate(respondi_id)
gen wave = 1
lab var wave "Wave"


** Sociodemografics
rename sd01_01 age
rename sd02 gender 
rename sd03 marital
rename sd04 income
rename sd05 edu
rename sd05_09 edu_other
lab var edu_other "Other: Education"
rename sd06 children_12_18
rename sd07_01 hh_member_0_14
rename sd07_02 hh_member_14_99
rename sd08_01 zip_code
rename sd09 pop_density
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
rename rp07    no_measures_reason
label define no_measure_reasons1 1 "Corona does not require any measures" 2 "Regulates itself" 3 "There is no Corona" 4 "Belly feeling" 5 "Other", replace
lab val no_measures_reason no_measure_reasons1
rename rp07_05a no_measures_reason_other
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
rename ac06_01 date_reg0
rename ac07_01 date_reg1
rename ac11 priority_group
rename ac12_01 batch_nr

rename ac10 vaccine_place_reg
lab define vaccine_place_reg1 1 "General Practitioner" 2 "Vaccination Center" 3 "Other", replace
lab val vaccine_place_reg vaccine_place_reg1
lab var vaccine_place_reg "Place where registered for vaccination"

rename ac10_03a vaccine_place_reg_other 
lab var vaccine_place_reg_other "OTHER: Place where registered for vaccination"


** Induced Variation / Treatment
rename iv01 treatment
rename iv02 t1_teaser
rename iv03_01 t1_sort_admission
rename iv03_02 t1_sort_effectivity
rename iv03_03 t1_sort_side
rename iv03_04 t1_sort_long
rename iv04_01 t1_reduced_admission
rename iv04_02 t1_reduced_effectivity
rename iv04_03 t1_reduced_side
rename iv04_04 t1_reduced_long
rename iv06 t2_teaser
rename iv07_01 t2_sort_protect_self
rename iv07_02 t2_sort_protect_other
rename iv07_03 t2_sort_travel
rename iv07_04 t2_sort_quarantine
rename iv08_05 t2_aware_protect_self
rename iv08_06 t2_aware_protect_other
rename iv08_07 t2_aware_travel
rename iv08_08 t2_aware_quarantine
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
rename in10_01 reason_action_other1
rename in10_02 reason_action_other2
rename in10_03 reason_action_other3
rename in11_05 reason_action_other1_importance
rename in11_06 reason_action_other2_importance
rename in11_07 reason_action_other3_importance
rename in12_01 reason_action_detail
rename in13_01 reason_inaction_other1
rename in13_02 reason_inaction_other2
rename in13_03 reason_inaction_other3
rename in14_05 reason_inaction_other1_imp
rename in14_06 reason_inaction_other2_imp
rename in14_07 reason_inaction_other3_imp
rename in15_01 convince_family
rename in15_02 convince_friends
rename in15_03 convince_socialmedia
rename in16_01 convince_other1
rename in16_02 convince_other2
rename in16_03 convince_other3
rename in17_01 convince_other1_strength
rename in17_02 convince_other2_strength
rename in17_03 convince_other3_strength
rename in18_01 convince_other_detail


** Determinants
* Regret
rename dt01_03 fomo1
rename dt01_04 fomo2

* Norms
rename dt02 norms1
rename dt16 norms2
rename dt03 norms3

* Dogmatism
rename dt06_01 dog1
rename dt06_02 dog2
rename dt06_03 dog3
rename dt06_04 dog4
rename dt06_05 dog5
rename dt06_06 dog6
rename dt06_07 dog7
rename dt06_08 dog8
rename dt06_09 dog9


* Preferences
rename dt07_11 risk
rename dt15_11 time

rename dt09 svo1
rename dt10 svo2
rename dt11 svo3
rename dt12 svo4
rename dt13 svo5
rename dt14 svo6

*** Comments
rename cc03 responses
rename cc06_01 comments

*** Time on pages
rename time001 time_welcome
rename time005 time_quality_check
rename time006 time_attention_remind
gen time_prime = .
replace time_prime = time020 if time020 != .
replace time_prime = time022 if time022 != .
rename dt05 denied_vaccine_past



*** LABEL

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
lab var marital "Marital status"
lab var income "Income Category"
lab var edu "Education"
lab var children_12_18 "Do you have a child in the age of 12-18?"
lab var hh_member_0_14 "Household members aged 0-14"
lab var hh_member_14_99 "Household members above 14 years"
lab var zip_code "First 2 digits of zip-code"
lab var pop_density "Population density at place living at"
lab var pol_orientation "Political orientation (left/right)"
lab var pol_party "Party feeling most attached to"
lab var pol_party_other "Other: Party feeling most attached to"
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
lab var no_measures_reason_other "Other: Why are no measures to be taken against corona?"
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
lab var date_reg0 "Registered: Date of registration"
lab var date_reg1 "Registered: Date of first vaccination"
lab var priority_group "Which priority group are you assigned to?"
lab var batch_nr "What's the batch number of your vaccination?"
lab var treatment "Treatment (1 Debunk, 2 Benefits, 3 Facilitator, 4 Control)"
lab var t1_teaser "Debunk teaser: How many are concerned due to the corona-vaccine?"
lab var t1_sort_admission "Sort: Quick admission of vaccines"
lab var t1_sort_effectivity "Sort: Effectivity of vaccines"
lab var t1_sort_side "Sort: Side Effects of vaccines"
lab var t1_sort_long "Sort: Long-term effects of vaccines"
lab var t1_reduced_admission "Concerns reduced regarding quick admission of vaccines"
lab var t1_reduced_effectivity "Concerns reduced regarding effectivity of vaccines"
lab var t1_reduced_side "Concerns reduced regarding side Effects of vaccines"
lab var t1_reduced_long "Concerns reduced regarding long-term effects of vaccines"
lab var t2_teaser "Benefits teaser: How many are aware of benefits of vaccine?"
lab var t2_sort_protect_self "Sort: Protection of self through vaccine"
lab var t2_sort_protect_other "Sort: Protection of others through vaccine"
lab var t2_sort_travel "Sort: Removal of travel & meeting restrictions"
lab var t2_sort_quarantine "Sort: Removal of duty to quarantine"
lab var t2_aware_protect_self "Aware of the fact that vaccine helps to protect self"
lab var t2_aware_protect_other "Aware of the fact that vaccine helps to protect others"
lab var t2_aware_travel "Aware of the fact that no travel & meeting restrictions when vaccinated"
lab var t2_aware_quarantine "Aware of the fact that no duty to quarantine when vaccinated"
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
lab var reason_inaction1 "It's not my turn yet"
lab var reason_inaction2 "Didn't have the time yet"
lab var reason_inaction3 "Not sure where to register"
lab var reason_inaction4 "Not able to get vaccinated due to other reasons"
lab var reason_not1 "Cannot get vaccinated due to medical issues"
lab var reason_not2 "Dont think its necessary get vaccinated"
lab var reason_not3 "Think its harmful to get vaccinated"
lab var reason_action_other1 "Other reason for not/getting vaccinated"
lab var reason_action_other2 "Other reason for not/getting vaccinated"
lab var reason_action_other3 "Other reason for not/getting vaccinated"
lab var reason_action_other1_importance "Importance other reason for not/getting vaccinated"
lab var reason_action_other2_importance "Importance other reason for not/getting vaccinated"
lab var reason_action_other3_importance "Importance other reason for not/getting vaccinated"
lab var reason_action_detail "Detailed explanation of own reasons (not) to get vaccinated"
lab var reason_inaction_other1 "Other reason for not taking action though willing to get vaccinated"
lab var reason_inaction_other2 "Other reason for not taking action though willing to get vaccinated"
lab var reason_inaction_other3 "Other reason for not taking action though willing to get vaccinated"
lab var reason_inaction_other1_imp "Importance of other reason for not taking action though willing to get vaccinated"
lab var reason_inaction_other2_imp "Importance of other reason for not taking action though willing to get vaccinated"
lab var reason_inaction_other3_imp "Importance of other reason for not taking action though willing to get vaccinated"
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
lab var dog1 "In the end others will come to the same conclusions"
lab var dog2 "Things I believe in are fully true and I will not draw them into question"
lab var dog3 "My oppinion are correct"
lab var dog4 "My opinion and beliefs perfectly match each other"
lab var dog5 "Nothing could change my opinion on the important matters of life"
lab var dog6 "I am far from drawing final conclusions on the central questions of life"
lab var dog7 "I am asbolute sure my image of the central questions of life are correct"
lab var dog8 "If people are open regarding the important things of life they will come to the wrong conclusions"
lab var dog9 "In 20 years my opinion regarding important things in life will have changed"
lab var risk "Risk preference"
lab var time "Time preference"
lab var svo1 "SVO decision 1"
lab var svo2 "SVO decision 2"
lab var svo3 "SVO decision 3"
lab var svo4 "SVO decision 4"
lab var svo5 "SVO decision 5"
lab var svo6 "SVO decision 6"
lab var comments "Further comments"
lab var time_welcome "Time on welcome page"
lab var time_quality_check "Time on quality check page"
lab var time_attention_remind "Time on attention reminder page"
lab var time_prime "Time on prime information page"

}

*----------------------------



*----------------------------
* 3. CHANGE VARIABLES
{
*** Change scale to 0-100
foreach x of varlist risk_infect_self risk_infect_others risk_infect_average death_covid long_covid risk_eval_self risk_eval_others {
	replace `x' = (`x'-1)
	}

	
*** Change to 1-Yes 0-No
lab def y_n 0 "No" 1 "Yes", replace
foreach x of varlist children_12_18 pregnant denied_vaccine_past had_corona {
	replace `x' = (`x'-2)*(-1)
	lab val `x' y_n
	}


*** Replace outside option with 99
/*
For some questions outside option was provided [political orientaiton, convincing friends&family, post-treat questions, ]
*/
foreach var in pol_orientation convince_family convince_friends convince_socialmedia t1_reduced_admission t1_reduced_effectivity t1_reduced_side t1_reduced_long {
replace `var' = 99 if `var' == .a
}
lab val t1_reduced_admission t1_reduced_effectivity t1_reduced_side t1_reduced_long
lab define reduced1 1 "Did not reduce at all" 7 "Completely reduced" 99 "Was not worried about this"
lab val t1_reduced_admission t1_reduced_effectivity t1_reduced_side t1_reduced_long reduced1
	

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
foreach var in cured_date date_full date_part1 date_part2 date_reg0 date_reg1 {
gen `var'_new = date(`var', "YMD") // days since 01.01.1960
}

foreach var in cured_date date_full date_part1 date_part2 date_reg0 date_reg1 {
format `var'_new %td
}

drop cured_date date_full date_part1 date_part2 date_reg0 date_reg1

foreach var in cured_date date_full date_part1 date_part2 date_reg0 date_reg1 {
rename `var'_new `var'
}

lab var cured_date "When where you symptom free?"
lab var date_full "Fully vaccinated: Date when last vaccination received"
lab var date_part1 "Partially vaccinated: Date when first vaccination received"
lab var date_part2 "Partially vaccinated: Date of second vaccination"
lab var date_reg0 "Registered: Date of registration"
lab var date_reg1 "Registered: Date of first vaccination"

}
*----------------------------



*----------------------------
* 4. EXCLUDING OBSERVATIONS
{
*** Exclusion criteria
/*
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

* Inattention: Only pages that should have been primed
/*
Apply rule of less than 3 minutes per page only to pages that should have been primed [i.e. Page 23] as otherwise many observations are kicked out; 
originaly we also had 
time012 time013 time014 time015 time016 time017 time019  time024 time025 time026 time027 time028 time029
in for inattention
*/
gen exclude_inattention = 0
foreach var in  time023 { // hier wird nur die Verweildauer auf Seite 23 berücksichtigt. 
replace exclude_inattention = 1 if `var'> 180 & `var'!=. 
}
lab var exclude_inattention "More than 3 minutes on one question page"


*some (n=29) participants somehow did the survey twice. Keep only the first attempt
sort respondi_id start_time
by respondi_id: gen newid = 1 if _n==1
order newid respondi_id
drop if newid == . // 29 observations

tab vaccine_status //19 fully + 72 partially vaccinated
*drop if vaccine_status < 3 //drop 91 observations

tab exclude_rush // 69 observations
*drop if exclude_rush == 1

tab exclude_inattention //16 observations
*drop if exclude_inattention == 1

gen exclude_sloppy=0
replace exclude_sloppy=1 if responses != 1
tab exclude_sloppy // 88 observations
*drop if exclude_sloppy == 1

/*
- These two drop out as they are merged to have differences in age between waves
- In the no-exc merge file they appear twice
- In the general file they appear only once [wave 1; i.e. have been dropped in wave 2] 
	=> Excluded in wave 2 but not wave 1 in general dataset
	=> In second wave they have been found to have rushed through
	=> Therefore, we didn't calculate the incorrect age difference and didn't drop them from wave 1; waht now?
*/
*drop if respondi_id == 6218392296714 | respondi_id == 6206287104823


}
tab wave
* Sample size: N=1,623
*----------------------------



*----------------------------
* 5. GENERATE
{
*** Attention Check correct (SETUP)
replace attention_check = lower(attention_check) // All entries to lower case
replace attention_check = "haus" if attention_check == ",,haus"
replace attention_check = "haus" if attention_check == "„haus“"
gen attention_check_correct = strpos(attention_check, "haus") // Mark all that contain the word 'haus'
lab var attention_check_correct "The correct word (Haus) was entered"


*** Vaccination place: One joint variable for those fully/partly vaccinated (ACTION)
gen vaccine_place = .
replace vaccine_place = ac08 if ac08 != .
replace vaccine_place = ac09 if ac09 != .
lab var vaccine_place "Place where vaccination took place"
 
gen vaccine_place_other = ""
replace vaccine_place_other = ac08_03 if ac08_03 != ""
replace vaccine_place_other = ac09_03 if ac09_03 != ""
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


*** Treatment variable for Wave 1
gen treatment_w1 = .
replace treatment_w1 = treatment  if treatment == 1 | treatment == 2
replace treatment_w1 = 0 if treatment == 3 | treatment == 4
lab var treatment_w1 "Treatment in wave 1"
lab define treat_w1 0 "Control" 1 "Debunk" 2 "Benefits"
lab val treatment_w1 treat_w1





*** Quota
** Age group
gen age_group = .
replace age_group = 1 if age>=18 & age<= 25
replace age_group = 2 if age>=26 & age<= 35
replace age_group = 3 if age>=36 & age<= 45
replace age_group = 4 if age>=46 & age<= 55
replace age_group = 5 if age>=56 & age<= 69
replace age_group = 6 if age> 69
lab var age_group "Age Group"
label define age_group1 1 "18-25" 2 "26-35" 3 "36-45" 4 "46-55" 5 "56-69" 6 ">= 70" , replace
lab val age_group age_group1

gen quota = .
replace quota = 1 if sd14_01 == "1-1"  // f : 18-25
replace quota = 2 if sd14_01 == "1-2"  // m : 18-25
replace quota = 3 if sd14_01 == "2-1"  // f : 26-35
replace quota = 4 if sd14_01 == "2-2"  // m : 26-35
replace quota = 5 if sd14_01 == "3-1"  // f : 36-45
replace quota = 6 if sd14_01 == "3-2"  // m : 36-45
replace quota = 7 if sd14_01 == "4-1"  // f : 46-55
replace quota = 8 if sd14_01 == "4-2"  // m : 46-55
replace quota = 9 if sd14_01 == "5-1"  // f : 56-69
replace quota = 10 if sd14_01 == "5-2" // m : 56-69
lab var quota "Quota for gender-age combinations"
label define quota1 1 "female: 18-25" 2 "male: 18-25" 3 "female: 26-35" 4 "male: 26-35" 5 "female: 36-45" 6 "male: 36-45" 7 "female: 46-55" 8 "male: 46-55" 9 "female: 56-69" 10 "male: 56-69", replace
lab val quota quota1





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
/*Setup*/ case start_time start_time2 finish_time time_sum  device respondi_tic respondi_id wave attention_check attention_check_correct sd14_01 quota exclude_rush exclude_inattention exclude_sloppy ///
/*Sociodemografics*/ age age_group gender marital income edu edu_other children_12_18 hh_member_0_14 hh_member_14_99 zip_code pop_density pol_orientation pol_party pol_party_other health pregnant ///
/*Risk perception*/ risk_infect_self risk_infect_others risk_infect_average progression long_covid death_covid risk_eval_self risk_eval_others measures no_measures_reason no_measures_reason_other upset alert nervous attentive anxious ///
/*Action*/ had_corona cured_date vaccine_status date_full date_part1 date_part2 date_reg0 date_reg1 vaccine_place vaccine_place_other vaccine_place_reg vaccine_place_reg_other priority_group batch_nr reason_action1 reason_action2 reason_action3 reason_action4 reason_action5 reason_action_other1 reason_action_other2 reason_action_other3 reason_action_other1_importance reason_action_other2_importance reason_action_other3_importance reason_inaction1 reason_inaction2 reason_inaction3 reason_inaction4 reason_inaction_other1 reason_inaction_other2 reason_inaction_other3 reason_inaction_other1_imp reason_inaction_other2_imp reason_inaction_other3_imp reason_not1 reason_not2 reason_not3 reason_action_detail convince_family convince_friends convince_socialmedia convince_other1 convince_other2 convince_other3 convince_other1_strength convince_other2_strength convince_other3_strength convince_other_detail ///
/*Induced Variation*/ treatment treatment_w1 t1_teaser t1_sort_admission t1_sort_effectivity t1_sort_side t1_sort_long t1_reduced_admission t1_reduced_effectivity t1_reduced_side t1_reduced_long t2_teaser t2_sort_protect_self t2_sort_protect_other t2_sort_travel t2_sort_quarantine t2_aware_protect_self t2_aware_protect_other t2_aware_travel t2_aware_quarantine prime_check1 prime_check2 ///
/*5 cs*/ confidence1_mrna confidence1_vector confidence2_mrna confidence2_vector confidence3_mrna confidence3_vector complacency1 complacency2 constraints1 constraints2 constraints3 calculation1 calculation2 calculation3 collective1 collective2 collective3 ///
/*Intention*/ intent_mrna intent_vector ///
/*Det1Fomo*/ fomo1 fomo2 ///
/*Det2Norms*/ norms1 norms2 norms3 denied_vaccine_past ///
/*Det3Dogmatism*/ dog1 dog2 dog3 dog4 dog5 dog6 dog7 dog8 dog9 ///
/*Det4Preferences*/ risk time svo1 svo2 svo3 svo4 svo5 svo6 ///
/*Comments*/ responses comments ///
/*Time spent on pages*/ time_welcome time_quality_check time_attention_remind time_prime




*** Keep
keep ///
/*Setup*/ case start_time start_time2 finish_time time_sum  device respondi_tic respondi_id wave attention_check attention_check_correct sd14_01 quota exclude_rush exclude_inattention exclude_sloppy ///
/*Sociodemografics*/ age age_group gender marital income edu edu_other children_12_18 hh_member_0_14 hh_member_14_99 zip_code pop_density pol_orientation pol_party pol_party_other health pregnant ///
/*Risk perception*/ risk_infect_self risk_infect_others risk_infect_average progression long_covid death_covid risk_eval_self risk_eval_others measures no_measures_reason no_measures_reason_other upset alert nervous attentive anxious ///
/*Action*/ had_corona cured_date vaccine_status date_full date_part1 date_part2 date_reg0 date_reg1 vaccine_place vaccine_place_other vaccine_place_reg vaccine_place_reg_other priority_group batch_nr reason_action1 reason_action2 reason_action3 reason_action4 reason_action5 reason_action_other1 reason_action_other2 reason_action_other3 reason_action_other1_importance reason_action_other2_importance reason_action_other3_importance reason_inaction1 reason_inaction2 reason_inaction3 reason_inaction4 reason_inaction_other1 reason_inaction_other2 reason_inaction_other3 reason_inaction_other1_imp reason_inaction_other2_imp reason_inaction_other3_imp reason_not1 reason_not2 reason_not3 reason_action_detail convince_family convince_friends convince_socialmedia convince_other1 convince_other2 convince_other3 convince_other1_strength convince_other2_strength convince_other3_strength convince_other_detail ///
/*Induced Variation*/ treatment treatment_w1 t1_teaser t1_sort_admission t1_sort_effectivity t1_sort_side t1_sort_long t1_reduced_admission t1_reduced_effectivity t1_reduced_side t1_reduced_long t2_teaser t2_sort_protect_self t2_sort_protect_other t2_sort_travel t2_sort_quarantine t2_aware_protect_self t2_aware_protect_other t2_aware_travel t2_aware_quarantine prime_check1 prime_check2 ///
/*5 cs*/ confidence1_mrna confidence1_vector confidence2_mrna confidence2_vector confidence3_mrna confidence3_vector complacency1 complacency2 constraints1 constraints2 constraints3 calculation1 calculation2 calculation3 collective1 collective2 collective3 ///
/*Intention*/ intent_mrna intent_vector ///
/*Det1Fomo*/ fomo1 fomo2 ///
/*Det2Norms*/ norms1 norms2 norms3 denied_vaccine_past ///
/*Det3Dogmatism*/ dog1 dog2 dog3 dog4 dog5 dog6 dog7 dog8 dog9 ///
/*Det4Preferences*/ risk time svo1 svo2 svo3 svo4 svo5 svo6 ///
/*Comments*/ responses comments ///
/*Time spent on pages*/ time_welcome time_quality_check time_attention_remind time_prime

}
*----------------------------







*----------------------------
* 7. SAVE

save "$working_ANALYSIS/processed/corona_ger_wave1_clean.dta", replace

*----------------------------






** EOF