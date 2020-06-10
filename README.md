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
4. Eine Funktion namens post.processing, die die Daten wie gewünscht filtert und weiterverarbeitet:
```post.processing( list.of.tables )```  

Beispiel einer Spezifikation zum Abfragen aller vollständigen Datensätze aller Patienten und Aufnahmen zu allen Blutdruckuntersuchungen mit anschliessender Alterberechnung der Patienten zum Zeitpunkt der Unteruschung/Aufnahme:  
**spec.R:**

```
###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir.search.request ohne Endpunktangabe
###
fhir.search.request <- paste0(
	"Observation?",
	"&code=http://loinc.org|85354-9",
	"&_include=Observation:subject",
	"&_include=Observation:encounter",
	"&_format=xml",
	"&_pretty=true",
	"&_count=500000" )

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Observation = list(
		entry   = ".//Observation",
		items = list( 
			O.OID  = "id/@value",
			O.PID  = "subject/reference/@value",
			O.EID  = "encounter/reference/@value",
			DIA    = "component[code/coding/code/@value='8462-4']/valueQuantity/value/@value", 
			SYS    = "component[code/coding/code/@value='8480-6']/valueQuantity/value/@value",
			DATE   = "effectiveDateTime/@value"
		)
	),
	Encounter = list(
		".//Encounter",
		list(
			E.EID = "id/@value",
			E.PID = "subject/reference/@value",
			START = "period/start/@value",
			END   = "period/end/@value"
		)
	),
	Patient = list(
		".//Patient",
		list(
			P.PID      = "id/@value", 
			VORNAME    = "name/given/@value", 
			NACHNAME   = "name/family/@value",
			GESCHLECHT = "gender/@value", 
			GEBURTSTAG = "birthDate/@value" 
		)
	)
)

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
# lot: list of tables
###
post.processing <- function( lot ) {

	lot <- lapply(
		lot,
		function( df ) {
			
			#df <- lot[[ 1 ]]
		
			# find all names with .xID
			pids <- names( df )[ grep( "\\.[A-Z]ID", names( df ) ) ]
			
			for( p in pids ) {
				
				#p <- pids[[ 1 ]]
				# extract id
				df[[ p ]] <- stringr::str_extract( df[[ p ]], "[0-9]+$" )
			}
			
			df
		}
	)
	
	lot$ALL <- 
		merge( 
			merge( 
				lot$Observation, 
				lot$Patient, 
				by.x = "O.PID", 
				by.y = "P.PID",
				all = F
			),
			lot$Encounter, 
			by.x = "O.EID",
			by.y = "E.EID",
			all = F
		)
	
	lot$ALL$AGE <- round( as.double( as.Date( lot$ALL$DATE ) - as.Date( lot$ALL$GEBURTSTAG ) ) / 365.25, 2 )
	
	# loesche evtl noch alle nicht vollstaendigen Datansaetze
	# lot <- lapply( lot, na.omit )

	lot
}

```
### Ausführen eines Tests
Aus dem Ordner **api**, indem sich das R-Skripte **fhi.R** befindet, startet man einen Test mit folgender Eingabe in die Kommandozeile:  
```Rscript fhi.R -s specification-file -o output-directory -n number-of-bundles -S separator```  

Hierbei sind:  
  - ```specification-file```: der Name des R-Skriptes, das die Abfrage spezifiziert (in der Regel spec.R)  
  - ```output-directory```: der Name des Verzeichnisses, in dem die Resultate gespeichert werden sollen (z.B. result).  
  - ```number-of-bundles```: die maximale Anzahl an herunterzuladenden Bundles  
  - ```separator```: a separator string for multiple entries in a resource  

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
- das spec-file soll spec-medication-test.R heissen
- das Ausgabeverzeichnis soll 'medications' heissen
- bitte nur die ersten 5 Bundles downloaden!
- als Separator fuer Mehrfacheintraege ' › '
```
$ Rscript $fhiR -s spec-medication-test.R -o medications -n 5 -S ' › '
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
