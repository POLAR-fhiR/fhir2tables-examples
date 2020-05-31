# ###
# # Endpunkt des fhir r4 Servers
# ###
# #endpoint <-  "https://vonk.fire.ly/R4/"
# endpoint <- "https://hapi.fhir.org/baseR4"
#
# ###
# # fhir search ohne Endpunktangabe
# ###
# fhir.search <- paste0(
# 	"Observation?",
# 	"_include=Observation:encounter&",
# 	"_include=Observation:patient&",
# 	"_format=xml&",
# 	"_pretty=true&",
# 	"_count=1000" )
#
# ###
# # Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# # Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
# ###
# tables.design <- list(
# 	Untersuchungen = list(
# 		".//Observation",
# 		list(
# 			OID     = "id/@value",
# 			PID     = "subject/reference/@value",
# 			WERT    = "valueQuantity/value/@value",
# 			EINHEIT = "valueQuantity/unit/@value",
# 			TEXT    = "code/text/@value",
# 			CODE    = "code/coding/code/@value",
# 			DATUM   = "effectiveDateTime/@value"
# 		)
# 	),
# 	Aufnahmen = list(
# 		".//Encounter",
# 		list(
# 			EID           = "id/@value",
# 			PATIENTEN.ID  = "subject/reference/@value",
# 			TEILNEHMER.ID = "participant/individual/reference/@value",
# 			BEGINN        = "period/start/@value",
# 			ENDE          = "period/end/@value",
# 			SYSTEM        = "class/system/@value",
# 			CODE          = "class/code/@value",
# 			DISPLAY       = "class/display/@value"
# 		)
# 	),
# 	Patienten = list(
# 		".//Patient",
# 		list(
# 			PID             = "id/@value",
# 			NAME.VERWENDUNG = "name/use/@value",
# 			VORNAME         = "name/given/@value",
# 			NACHNAME        = "name/family/@value",
# 			GESCHLECHT      = "gender/@value",
# 			GEBURTSTAG      = "birthDate/@value"
# 		)
# 	)
# )
#
# ###
# # filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
# ###
# filter.data <- function( list.of.tables ) {
#
#   ###
#   # filter here whatever you want!
#   ###
#
#   ###
#   # nur komplette Datensaetze erwuenscht
#   ###
#   #list.of.tables <- lapply( list.of.tables, na.omit )
#
#   ###
#   # gib gefilterte Daten zurueck
#   ###
#   list.of.tables
# }
#
# cat("Achtung das richtige spec.R file wurde nicht geladen!")


# Observation bloot pressure from loinc
###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"#
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir search ohne Endpunktangabe
###
fhir.search <- "Observation?code=http://loinc.org|85354-9&_format=xml&_count=500"

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Observation = list(
		entry   = ".//Observation[.//code/coding/code/@value='8462-4' or .//code/coding/code/@value='8480-6' and .//valueQuantity/value/@value>120]",
		items = list(
			PID   = "subject/reference/@value",
			OID   = "id/@value",
			DIA   = "component[code/coding/code/@value='8462-4' and valueQuantity/value/@value>80]/valueQuantity/value/@value",
			SYS   = "component[code/coding/code/@value='8480-6' and valueQuantity/value/@value>120]/valueQuantity/value/@value",
			DATE  = "effectiveDateTime/@value"
		)
	)
)
# tables.design <- list(
# 	Observation = list(
# 		entry   = ".//Observation",
# 		items = list(
# 			PID   = "subject/reference/@value",
# 			OID   = "id/@value",
# 			DIA   = "component[code/coding/code/@value='8462-4']/valueQuantity/value/@value",
# 			SYS   = "component[code/coding/code/@value='8480-6']/valueQuantity/value/@value",
# 			DATE  = "effectiveDateTime/@value"
# 		)
# 	)
# )

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
filter.data <- function( lot ) {

	# lot$Observation <- lot$Observation[
	# 	( ! is.na( lot$Observation$DIA ) &  80 < as.numeric( as.character( lot$Observation$DIA ) ) ) |
	# 	( ! is.na( lot$Observation$SYS ) & 120 < as.numeric( as.character( lot$Observation$SYS ) ) ), ]

	lot
}

cat( "\nAchtung das richtige spec.R file wurde nicht geladen!" )


