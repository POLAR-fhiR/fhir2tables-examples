###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir.search.request ohne Endpunktangabe
###
fhir.search.request <- paste0(
	"Observation?",
	"&code=http://loinc.org|85354-9",
	"&_include=Observation:subject",
	"&_include=Observation:encounter",
	"&_format=xml",
	"&_pretty=true",
	"&_count=500000" )

###
# Welche Daten aus den Pages sollen wie in welchen Tabellen erzeugt werden
# Hier nur eine Tabelle Patient mit den Einträgen PID, Geschlecht und Geburtsdatum
###
tables.design <- list(
	Observation = list(
		entry   = ".//Observation",
		items = list( 
			O.OID  = "id/@value",
			O.PID  = "subject/reference/@value",
			O.EID  = "encounter/reference/@value",
			DIA    = "component[code/coding/code/@value='8462-4']/valueQuantity/value/@value", 
			SYS    = "component[code/coding/code/@value='8480-6']/valueQuantity/value/@value",
			DATE   = "effectiveDateTime/@value"
		)
	),
	Encounter = list(
		".//Encounter",
		list(
			E.EID = "id/@value",
			E.PID = "subject/reference/@value",
			START = "period/start/@value",
			END   = "period/end/@value"
		)
	),
	Patient = list(
		".//Patient",
		list(
			P.PID      = "id/@value", 
			VORNAME    = "name/given/@value", 
			NACHNAME   = "name/family/@value",
			GESCHLECHT = "gender/@value", 
			GEBURTSTAG = "birthDate/@value" 
		)
	)
)

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
filter.data <- function( lot ) {

	#lot <- list.of.tables
	#lot <- lapply( lot, na.omit )

	lot <- lapply(
		lot,
		function( df ) {
			
			#df <- lot[[ 1 ]]
		
			# find all names with .xID
			pids <- names( df )[ grep( "\\.[A-Z]ID", names( df ) ) ]
			
			for( p in pids ) {
				
				#p <- pids[[ 1 ]]
				# extract id
				df[[ p ]] <- stringr::str_extract( df[[ p ]], "[0-9]+$" )
			}
			
			df
		}
	)
	
	lot$ALL <- 
		merge( 
			merge( 
				lot$Observation, 
				lot$Patient, 
				by.x = "O.PID", 
				by.y = "P.PID",
				all = F
			),
			lot$Encounter, 
			by.x = "O.EID",
			by.y = "E.EID",
			all = F
		)
	
	lot$ALL$AGE <- round( as.double( as.Date( lot$ALL$DATE ) - as.Date( lot$ALL$GEBURTSTAG ) ) / 365.25, 2 )
	
	lot
}

