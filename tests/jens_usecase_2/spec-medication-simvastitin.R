#Datei sucht ein MedicationStatement mit dem snomed.code für Simvastitin 429374003
#Es werden auch alle Patienten Resourcen dazu gesucht.
#Auf dem hapiFHIR server findet man dann etwas
#Stand: 2020_06_10
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
	"code=http://snomed.info/ct|429374003",
	"&_include=MedicationStatement:subject",
	"&_include=MedicationStatement:encounter",
	"&_format=xml",
	"&_pretty=true",
	"&_count=500000")

###http://www.whocc.no/atc 
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Arzneimittelbescheinigung = list(
		".//MedicationStatement",
		list(
			AID = "id/@value",
			STATUS.TEXT ="text/status/@value",
			STATUS = "status/@value",
			MEDIKATION.SYSTEM  = "medicationCodeableConcept/coding/system/@value",
			MEDIKATION.CODE    = "medicationCodeableConcept/coding/code/@value",
			MEDIKATION.ANZEIGE = "medicationCodeableConcept/coding/display/@value",
			DOSAGE  = "dosage/text/@value",
			DOSAGE.TIMING ="dosage/timing/repeat/frequency/@value",
			DOSAGE.PERIOD ="dosage/timing/repeat/period/@value",
			DOSAGE.PERIOD.UNIT ="dosage/timing/repeat/periodUnit/@value",
			PATIENT = "subject/reference/@value",
			LAST.UPDATE  = "meta/lastUpdated/@value"
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

write.table(paste0(endpoint,"/",fhir.search.request), "result/fhir.search.request.txt",
			col.names =FALSE, row.names =FALSE, quote=FALSE)


DataOutput <-function(){
  dat <- read.csv("Patienten.csv",header=TRUE, sep=";")
  d <- dim(dat)	
  cat("Anzahl der Patienten = ", d[1],"\n\n")	
}



