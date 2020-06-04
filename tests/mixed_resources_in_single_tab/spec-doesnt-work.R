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
	"_count=500000" )

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Observation = list(
		entry   = ".//resource",
		items = list( 
			O.PID  = "Observation/subject/reference/@value",
			O.OID   = "Observation/id/@value",
			DIA    = "Observation/component[code/coding/code/@value='8462-4']/valueQuantity/value/@value", 
			SYS    = "Observation/component[code/coding/code/@value='8480-6']/valueQuantity/value/@value",
			DATE   = "Observation/effectiveDateTime/@value",
			P.PID           = "Patient/id/@value", 
			VORNAME         = "Patient/name/given/@value", 
			NACHNAME        = "Patient/name/family/@value",
			GESCHLECHT      = "Patient/gender/@value", 
			GEBURTSTAG      = "Patient/birthDate/@value" 
		)
	)
)

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
filter.data <- function( lot ) {
	
	#lapply( lot, na.omit )
	lot
}

