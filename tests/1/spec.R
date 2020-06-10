# Observation bloot pressure from loinc
###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"#
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir.search.request.request ohne Endpunktangabe
###
fhir.search.request <- "Observation?code=http://loinc.org|85354-9&_format=xml&_count=500"

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
tables.design <- list(
	Observation = list(
		entry   = ".//Observation",
		items = list( 
			PID   = "subject/reference/@value",
			OID   = "id/@value",
			DIA   = "component[code/coding/code/@value='8462-4']/valueQuantity/value/@value", 
			SYS   = "component[code/coding/code/@value='8480-6']/valueQuantity/value/@value",
			DATE  = "effectiveDateTime/@value"
		)
	)
)

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
post.processing <- function( lot ) {

	lot$Observation <- lot$Observation[ 
		( ! is.na( lot$Observation$DIA ) &  80 < as.numeric( as.character( lot$Observation$DIA ) ) ) |
		( ! is.na( lot$Observation$SYS ) & 120 < as.numeric( as.character( lot$Observation$SYS ) ) ), ]

	lot
}

