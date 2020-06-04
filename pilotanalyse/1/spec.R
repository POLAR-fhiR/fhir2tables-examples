###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir search request
# hole alle MedicationStatement mit den dazugehoerigen Patienten und Aufnahmen
###
fhir.search <- "MedicationStatement/?_format=xml&_include=MedicationStatement:subject&_include=MedicationStatement:context&_count=10000000"

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	MedStat = list(
		".//MedicationStatement",
		list(
			MS.ID         = "id/@value",
			COCO.SYSTEM   = "medicationCodeableConcept/coding/system/@value",
			COCO.CODE     = "medicationCodeableConcept/coding/code/@value",
			COCO.SYSTEM   = "medicationCodeableConcept/coding/display/@value",
			TEXT          = "medicationCodeableConcept/text/@value",
			PATIENT.ID    = "subject/reference/@value",
			ENCOUNTER.ID  = "context/@value",
			DOSAGE.TEXT   = "dosage/text/@value",
			DOSAGE.TIMING = "dosage/timing/repeat/frequency/@value",
			DOSAGE.TIMING = "dosage/timing/repeat/period/@value",
			DOSAGE.TIMING = "dosage/timing/repeat/periodUnit/@value"
		)
	),
	Patients = list(
		".//Patient",
		list(
			PAT.ID      = "id/@value",
			NAME.TEXT   = "name/text/@value",
			NAME.FAMILY = "name/family/@value",
			NAME.GIVEN  = "name/given/@value",
			GENDER      = "gender/@value",
			BIRTHDATE   = "birthDate/@value"
		)
	),
	Encounter = list(
		".//Encounter",
		list(
			ENC.ID = "id/value",
			CLASS.SYSTEM = "class/system/@value",
			CLASS.SYSTEM = "class/code/@value",
			TYPE.CODING.SYTEM     = "type/coding/system/@value",
			TYPE.CODING.CODE      = "type/coding/code/@value",
			TYPE.CODING.DISPLAY   = "type/coding/display/@value",
			TYPE.TEXT             = "type/text/@value",
			PATIENT.REFERENCE     = "subject/reference/@value",
			PATIENT.DISPLAY       = "subject/display/@value",
			PARTICIPANT.REFERENCE = "participant/individual/reference/@value",
			PARTICIPANT.REFERENCE = "participant/individual/display/@value",
			PERIOD.START          = "period/start/@value",
			PERIOD.END            = "period/end/@value"
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

