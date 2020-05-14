# Fhir2Tables

Vergleich zweier Ansätze zur Extraktion und Transformation von Daten aus FHIR-Bundles zu Tabellen.

## 1. Ansätze
1. Download, Extraktion, Tranformation in R unter Nutzung des Packages xml2
2. Download, Extraktion, Tranformation via makefile, java und XSLT

## 2. Examples
1. Download aller Untersuchungen mit den dazugehoerenden Patienten und Treffen  
1.1 ```$ Rscript exampleObsWithPatEnc00.R```  
exampleObsWithPatEnc00 laed alle Pages des durch den fhir search request  
```
endpoint/Observation? \
_include=Observation:encounter& \
_include=Observation:patient& \
_format=xml&_pretty=true& \
_count=1000000
```  
angeforderten Bundles und erstellt fuer alle Untersuchungen, Patienten und Treffen jeweils eine eigene Tabelle, deren Spalten durch das Argument
```entries.obs <- list(
	Observation = list(
		entry   = ".//Observation",
		items = list(
			OID   = ".//id/@value",
			PID   = ".//subject/reference/@value",
			VALUE = ".//valueQuantity/value/@value",
			UNIT  = ".//valueQuantity/unit/@value",
			TEXT  = ".//code/text/@value",
			CODE  = ".//code/coding/code/@value",
			DATE  = ".//effectiveDateTime/@value"
		)
	),
	Encounter = list(
		entry = ".//Encounter",
		items = list(
			EID     = ".//id/@value",
			PAT.ID  = ".//subject/reference/@value",
			PRT.ID  = ".//participant/individual/reference/@value",
			START   = ".//period/start/@value",
			END     = ".//period/end/@value",
			SYSTEM  = ".//class/system/@value",
			CODE    = ".//class/code/@value",
			DISPLAY = ".//class/display/@value"
		)
	),
	Patient = list(
		entry   = ".//Patient",
		items = list(
			PID      = ".//id/@value",
			NAME.U   = ".//name/use/@value",
			NAME.G   = ".//name/given/@value",
			NAME.F   = ".//name/family/@value",
			SEX      = ".//gender/@value",
			BIRTHDAY = ".//birthDate/@value"
		)
	)
```
festgelegt werden.  
Die dabei entstehenden Daten wie die Bundle Pages (.xml) und die Ergebnisdataframes werden im Ordner ./data/exampleObsWithPatEnc als RData und csv Dateien gesichert.
### Verwendete endpoints  
  - "https://vonk.fire.ly/R4/"  
  - "http://demo.oridashi.com.au:8305/"  
  - "http://test.fhir.org/r4/"  
  - "https://hapi.fhir.org/baseR4/"  

  vonk scheint die besten Daten zu haben, doch nur wenige  
  hapi hat viele aber auch viele unsinnige Daten und scheint bereits ueberlastet zu sein
