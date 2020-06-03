###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"
endpoint <- "https://hapi.fhir.org/baseR4/"

###
# fhir search ohne Endpunktangabe
###
fhir.search <- "Patient?"
fhir.search <- paste0( fhir.search, "_revinclude=*" )
fhir.search <- paste0( fhir.search, "&_birthDate=lt1955-06-02T00:00" )
fhir.search <- paste0( fhir.search, "and_effectiveDateTime=gt2000-01-01T00:00" )
fhir.search <- paste0( fhir.search, "and_period:start=gt2020-01-01T00:00" )
fhir.search <- paste0( fhir.search, "&_count=100000" )
fhir.search <- paste0( fhir.search, "&_format=xml" )
#fhir.search <- paste0( fhir.search, "&_summary=count" )

#fhir.search <- "Patient?_revinclude=*&_birthDate=lt1955-06-02T00:00and_effectiveDateTime=gt2010-01-01T00:00&_format=xml&_summary=count"

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
# tables.design <- list(
# 	Total = list(
# 		"/Bundle",
# 		list(
# 			value = "total/@value"
# 		)
# 	)
# )
tables.design <- list(
	Patient = list(
		".//Patient",
		list(
			P.ID = "id/@value",
			DOB  = "birthDate/@value",
			SEX  = "gender/@value",
			NAME.G = "name/given/@value",
			NAME.G = "name/family/@value"
		)
	),
	Observation = list(
		".//Observation",
		list(
			O.ID         = "id/@value",
			STATUS       = "status/@value",
			CODE.SYSTEM  = "code/coding/system/@value",
			CODE.CODE    = "code/coding/code/@value",
			CODE.DISPLAY = "code/coding/display/@value",
			P.ID         = "subject/reference/@value",
			VQ.VALUE     = "valueQuantity/value/@value",
			VQ.UNIT      = "valueQuantity/unit/@value",
			VQ.SYSTEM    = "valueQuantity/system/@value",
			VQ.CODE      = "valueQuantity/code/@value"
		)
	),
	Encounter = list(
		".//Encounter",
		list(
			E.ID            = "id/@value",
			CODING.SYSTEM   = "type/coding/system/@value",
			CODING.VALUE    = "type/coding/code/@value",
			CODING.DISPLAY  = "type/coding/display/@value",
			TEXT            = "type/text/@value",
			P.ID            = "subject/reference/@value",
			P.NAME          = "subject/display/@value",
			PARTICIPANT.ID  = "participant/individual/reference/@value",
			PARTICIPANT.DSP = "participant/individual/display/@value",
			START           = "period/start/@value",
			END             = "period/end/@value",
			DIAGNOSE.COND   = "diagnosis/condition/display/@value"
		)
	),
	MedicationStatement = list(
		".//MedicationStatement",
		list(
			MS.ID       = "id/@value",
			STATUS      = "status/@value",
			CC.SYSTEM   = "medicationCodeableConcept/coding/system/@value",
			CC.VALUE    = "medicationCodeableConcept/coding/code/@value",
			CC.DISPLAY  = "medicationCodeableConcept/coding/display/@value",
			CC.TEXT     = "medicationCodeableConcept/text/@value",
			P.ID        = "subject/reference/@value",
			DOSAGE.TEXT = "dosage/text/@value",
			TIMING.FRQ.VALUE  = "dosage/timing/repeat/frequency/@value",
			TIMING.FRQ.PERIOD = "dosage/timing/repeat/period/@value",
			TIMING.FRQ.UNIT   = "dosage/timing/repeat/periodUnit/@value"
		)
	),
	MedicationRequest = list(
		".//MedicationRequest",
		list(
			MR.ID   = "id/@value",
			STATUS  = "status/@value",
			CC.TEXT = "medicationCodeableConcept/text/@value",
			P.ID    = "subject/reference/@value"
		)
	)
)


###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
filter.data <- function( lot ) {

	lot
}

