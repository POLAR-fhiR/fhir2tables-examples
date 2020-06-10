# Observation bloot pressure from loinc
###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"#
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir.search.request ohne Endpunktangabe
###
fhir.search.request <- "Patient?_gender=male,female&_format=xml&_count=500"

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
tables.design <- list(
	Patient = list(
		entry   = ".//Patient[gender and birthDate]",
		items = list(
			PID  ="id/@value",
			GENDER = "gender/@value",
			BIRTHDATE ="birthDate/@value"
		)
	)
)

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
post.processing <- function( lot ) {

	lot
}

