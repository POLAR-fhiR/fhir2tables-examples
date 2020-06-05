###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"
endpoint <- "https://hapi.fhir.org/baseR4/"

###
# fhir.search.request ohne Endpunktangabe
###
fhir.search.request <- "Patient?_format=xml&gender=male,female&_count=500"
###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Patient = list(
		entry   = ".//Patient",
		items = list( 
			PID         = "id/@value",
			NAME.GIVEN  = "name/given/@value",			
			NAME.FAMILY = "name/family/@value",
			GENDER      = "gender/@value", 
			BIRTHDATE   = "birthDate/@value" 
		)
	)
)

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
filter.data <- function( lot ) {
	
	###
	# filter here whatever you want!
	###
	
	###
	# nur komplette Datensaetze erwuenscht
	###
	lot <- lapply( lot, na.omit )
	#difftime( Sys.Date( ), Patient$BIRTHDATE, units = "days" )
	
	###
	# calc age
	###
	lot$Patient[[ "AGE [y]" ]] <- round( as.double( difftime( Sys.Date( ), as.Date( lot$Patient$BIRTHDATE ), units = "days" ) ) / 365.25, 2 ) 
	
	###
	# filter age
	###
	lot$Patient <- fhiR::coerce.types( lot$Patient[ 0 <= lot$Patient$'AGE [y]' & lot$Patient$'AGE [y]' <= 130, ] )

	###
	# gib gefilterte Daten zurueck
	###
	lot
}
