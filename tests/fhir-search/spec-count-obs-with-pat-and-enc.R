###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"
endpoint <- "https://hapi.fhir.org/baseR4/"

###
# fhir search ohne Endpunktangabe
###
fhir.search <- "Observation?_include=Observation:patient&_include:Observation:context"
fhir.search <- paste0( fhir.search, "&_format=xml&_summary=count" )

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Total = list(
		"/Bundle",
		list(
			value = "total/@value"
		)
	)
)
	

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
filter.data <- function( lot ) {

	lot
}

