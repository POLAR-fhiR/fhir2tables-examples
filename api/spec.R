###
# Endpunkt des fhir r4 Servers
###
endpoint <-  "https://vonk.fire.ly/R4/"
#endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir search ohne Endpunktangabe
###
fhir.search <- "Observation?_include=Observation:encounter&_include=Observation:patient&_format=xml&_pretty=true&_count=1000000"

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Besuch = list(
		".//Observation",
		list(
			OID     = "id/@value",
			PID     = "subject/reference/@value",
			WERT    = "valueQuantity/value/@value", 
			EINHEIT = "valueQuantity/unit/@value", 
			TEXT    = "code/text/@value",
			CODE    = "code/coding/code/@value",
			DATUM   = "effectiveDateTime/@value"
		)
	),
	Aufnahme = list(
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
	Patient = list(
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

