# Observation bloot pressure from loinc
###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"#
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir search ohne Endpunktangabe
###
fhir.search <- "Observation?code=http://loinc.org|85354-9&_format=xml&_count=50"

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Observation = list(
		entry   = ".//Observation",
		items = list( 
			PID   = "subject/reference/@value",
			OID   = "id/@value",
			DIA   = "component[.//code/@value='8462-4']/valueQuantity/value/@value", 
			SYS   = "component[.//code/@value='8480-6']/valueQuantity/value/@value",
			DATE  = "effectiveDateTime/@value"
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
  #list.of.tables <- lapply( list.of.tables, na.omit )

  ###
  # gib gefilterte Daten zurueck
  ###
  list.of.tables
}

