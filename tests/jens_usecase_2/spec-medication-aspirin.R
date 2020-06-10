###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir.search.request ohne Endpunktangabe
###
fhir.search.request <- paste0(
	"MedicationStatement?",
	"_code=http://snomed.info/ct",
	"_code=370167008",
	"_format=xml&",
	"_pretty=true&",
	"_count=500000" )

###http://www.whocc.no/atc 
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
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
filter.data <- function( lot ) {

	#lapply( lot, na.omit )
	lot
}

