# Fhir2Tables

## Abfragen
### Erstellen einer Abfrage
Das Erstellen einer Abfrage ist im Wesentlichen durch das Schreiben einer Spezifikation in Form eines R-Skriptes erledigt.  
Das Spezifikationsskript muss 4 Elemente enthalten.
1. Der baseR4-Endpoint des FHIR-Servers:
```endpoint```
2. Die FHIR-Suchanfrage:
```fhir.search```
3. Die Struktur der aus dem Bundle zu erstellenden Tabellen:
```tables.design```
4. Eine Funktion, die die Daten wie gewünscht filtert:
```filter.data```  

Beispiel einer Spezifikation zum Abfragen aller vollständigen Datensätze aller Patienten und Aufnahmen zu allen Untersuchungen:  
**spec.R:**

```
###
# Endpunkt des fhir r4 Servers
###
endpoint <-  "https://vonk.fire.ly/R4/"
#endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir search ohne Endpunktangabe
###
fhir.search <- paste0(
	"MedicationStatement?",
	"_include=MedicationStatement:context&",
	"_include=MedicationStatement:subject&",
	"_format=xml&",
	"_pretty=true&",
	"_count=500000" )


###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Arzneimittelbescheinigung = list(
		".//MedicationStatement",
		list(
			AID = "id/@value",
			STATUS = "status/@value",
			STATUS.BEGRUENDUNG.SYSTEM  = "statusReason/coding/system/@value",
			STATUS.BEGRUENDUNG.CODE    = "statusReason/coding/code/@value",
			STATUS.BEGRUENDUNG.ANZEIGE = "statusReason/coding/display/@value",
			BEGRUENDUNG.CODE.SYSTEM  = "reasonCode/coding/system/@value",
			BEGRUENDUNG.CODE.WERT    = "reasonCode/coding/code/@value",
			BEGRUENDUNG.CODE.ANZEIGE = "reasonCode/coding/display/@value",
			MEDIKATION.SYSTEM  = "medicationCodeableConcept/coding/system/@value",
			MEDIKATION.CODE    = "medicationCodeableConcept/coding/code/@value",
			MEDIKATION.ANZEIGE = "medicationCodeableConcept/coding/display/@value",
			PATIENT = "subject/reference/@value",
			BESUCH  = "context/reference/@value",
			BEGINN  = "effectivePeriod/start/@value",
			ENDE    = "effectivePeriod/end/@value",
			DATUM   = "dateAsserted/@value"
		)
	),
	Aufnahmen = list(
		".//Encounter",
		list(
			EID           = "id/@value",
			PATIENTEN.ID  = "subject/reference/@value",
			TEILNEHMER.ID = "participant/individual/reference/@value",
			BEGINN        = "period/start/@value",
			ENDE          = "period/end/@value",
			SYSTEM        = "class/system/@value",
			CODE          = "class/code/@value",
			DISPLAY       = "class/display/@value"
		)
	),
	Patienten = list(
		".//Patient",
		list(
			PID             = "id/@value",
			NAME.VERWENDUNG = "name/use/@value",
			VORNAME         = "name/given/@value",
			NACHNAME        = "name/family/@value",
			GESCHLECHT      = "gender/@value",
			GEBURTSTAG      = "birthDate/@value"
		)
	)
)

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
filter.data <- function( list.of.tables ) {

  ###
  # filter here whatever you want!
  ###

  ###
  # nur komplette Datensaetze erwuenscht
  ###
  list.of.tables <- lapply( list.of.tables, na.omit )

  ###
  # gib gefilterte Daten zurueck
  ###
  list.of.tables
}
```
### Ausführen einer Abfrage
Aus dem Ordner **api**, indem sich das R-Skript **fhi.R** befindet, startet man eine Abfrage mit folgender Eingabe in die Kommandozeile:  
```Rscript fhi.R -s specification-file -o output-directory```  
Hierbei sind:  
```specification-file```: der Name des R-Skriptes, das die Abfrage spezifiziert (in der Regel spec.R)  
und  
```output-directory```: der Name des Verzeichnisses, in dem die Resultate gespeichert werden sollen (z.B. result).
Es empfiehlt sich, eine Variable anzuulegen, die den Pfad zu fhi.R enthaelt, um so das Skript aus den Testverzeichnissen selbst auszufuehren.
```
$ fhiR=$(realpath .)/fhi.R
```
So kann das Script auch aus den Testverzeichnissen selbst gestartet werden, soll das Ergebnisverzeichnis "result" heissen, sogar ohne Angabe eines Zielverzeichnisses:
```
$ Rscript $fhiR -s spec.R
```
### 4 vorbereitete Testabfragen
Einige spec.R Dateien von vorbereiteten Testabfragen befinden sich im Ordner tests.  
```
.
├── fhi.R
├── fhir2tables.Rproj
├── pilotanalyse
│   ├── 1
│   │   └── spec.R
│   ├── 2
│   │   └── spec.R
│   ├── 3
│   │   └── spec.R
│   └── 4
│       └── spec.R
├── README.md
├── readme.txt
└── tests
    ├── 1
    │   └── spec.R
    ├── 2
    │   └── spec.R
    ├── 3
    │   └── spec.R
    ├── 4
    │   └── spec.R
    ├── fhir-search
    │   ├── spec-count-obs-with-pat-and-enc-age-gt-65.R
    │   ├── spec-count-obs-with-pat-and-enc.R
    │   ├── spec-pat-revincl.R
    │   ├── spec.R
    │   └── spec.R.save
    └── MedicationStatement
        ├── result
        │   ├── Arzneimittelbescheinigung.csv
        │   ├── Aufnahmen.csv
        │   ├── Patienten.csv
        │   └── tables.RData
        └── spec-medication-statement.R

```  
Man erkennt, dass ein Beispiel-Test mit der abgebildeten spec-medication-statement.R im Ordner MedicationStatement bereits ausgeführt wurde und Resultate erzeugt hat. (Resultate nicht im Repo vorhanden)
```
.../fhir2tables/tests/MedicationStatement/$ Rscript $fhiR -s spec-medication-statement.R
```


### Erreichbare Endpoints  
  - "http://demo.oridashi.com.au:8305/"  
  - "http://test.fhir.org/r4/"  
  - "https://vonk.fire.ly/R4/"  
    - vonk scheint die besten Daten zu haben, doch nur wenige  
  - "https://hapi.fhir.org/baseR4/"  
    - hapi hat viele aber auch viele unsinnige Daten und scheint bereits ueberlastet zu sein
	- ab 21:30 wird es besser  

## Polar Use Cases Tests ... will be continued
