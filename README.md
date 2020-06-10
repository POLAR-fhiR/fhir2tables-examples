# Fhir2Tables

## Tests fuer das R-Paket fhiR
### Erstellen eines Tests
Das Erstellen eines Tests ist im Wesentlichen durch das Schreiben einer Spezifikation in Form eines R-Skriptes erledigt.  
Das Spezifikationsskript muss 4 Elemente enthalten.

1. Der baseR4-Endpoint des FHIR-Servers:
```endpoint```
2. Die FHIR-Suchanfrage:
```fhir.search.request```
3. Die Struktur der aus dem Bundle zu erstellenden Tabellen:
```tables.design```
4. Eine Funktion namens **post.processing**, die die Daten wie gewünscht filtert und weiterverarbeitet:
```post.processing( list.of.tables )```  

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
fhir.search.request <- paste0(
	"MedicationStatement?",
	"_include=MedicationStatement:context&",
	"_include=MedicationStatement:subject&",
	"_format=xml&",
	"_pretty=true&",
	"_count=500000" )


###
# Welche Daten aus den Bundles sollen wie in welchen Tabellen erzeugt werden
# 3 Tabellen Arzneimittelbescheinigung, Aufnahmen, Patient
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
post.processing <- function( list.of.tables ) {

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
### Ausführen eines Tests
Aus dem Ordner **api**, indem sich das R-Skripte **fhi.R** befindet, startet man einen Test mit folgender Eingabe in die Kommandozeile:  
```Rscript fhi.R -s specification-file -o output-directory -n number-of-bundles```  

Hierbei sind:  
  - ```specification-file```: der Name des R-Skriptes, das die Abfrage spezifiziert (in der Regel spec.R)  
  - ```output-directory```: der Name des Verzeichnisses, in dem die Resultate gespeichert werden sollen (z.B. result).  
  - ```number-of-bundles```: die maximale Anzahl an herunterzuladenden Bundles  

Es empfiehlt sich, eine Variable anzulegen, die den Pfad zur Datei **fhi.R** enthaelt, um so das Skript aus den Testverzeichnissen selbst ausfuehren zu koennen.
```
$ cd myGithubRepos/fhir2tables
```  
dort entweder
```
$ fhiR=$(realpath .)/fhi.R
```  
oder  
```
$ fhiR=$(pwd)/fhi.R
```
ausfuehren.  

Jetzt kann das Script beispielsweise aus den Testverzeichnissen gestartet werden, soll das Ergebnisverzeichnis **result** heissen, das zu verwendende spec-file **spec.R** und wünscht man alle Bundles herunterzuladen, dann genügt sogar:
```
$ Rscript $fhiR
```
Andernfalls beispielsweise:  
- spec-file:  spec-medication-test.R
- Ausgabeverzeichnis: medications
- bitte nur die ersten 5 Bundles downloaden! 
```
$ Rscript $fhiR -s spec-medication-test.R -o medications -n 5
```

### Beispieltests
Einige spec.R Dateien von vorbereiteten Testabfragen befinden sich im Ordner tests.   
- MedicationStatement
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
