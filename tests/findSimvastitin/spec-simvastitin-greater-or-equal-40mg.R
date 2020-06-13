#Datei sucht ein MedicationStatement mit snomed.codec für Simvastitin und einer Mindesteinnahme von 40mg
#Es werden auch alle Patienten Resourcen dazu gesucht.
#Auf dem hapiFHIR server findet man dann etwas
#Stand: 2020_06_13
###
# Endpunkt des fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"
#endpoint <- "https://try.smilecdr.com:8000/"
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir.search.request ohne Endpunktangabe
###
simvastatin.all <- data.frame( 
	SNOMED = c( 
		"96304005",                                      "319996000",                                     "319997009",
		"320000009",                                     "320006003",                                     "376180003",
		"376181004",                                     "376638003",                                     "376834003",
		"387584000",                                     "414175005",                                     "414176006",
		"414177002",                                     "414178007",                                     "414179004",
		"427750007",                                     "427953000",                                     "428789004",
		"429374003",                                     "714580001"
	),
	TEXT  = c(
		"Simvastatin",                                   "Simvastatin 10mg tablet",                       "Simvastatin 20mg tablet",                  
		"Simvastatin 40mg tablet",                       "Simvastatin 80mg tablet",                       "Simvastatin 10mg",
		"Simvastatin 20mg",                              "Simvastatin 40mg",                              "Simvastatin 5mg tablet",
		"Simvastatin",                                   "Ezetimibe + simvastatin",                       "Simvastatin 10mg / ezetimibe 10mg tablet",
		"Simvastatin 20mg / ezetimibe 10mg tablet",      "Simvastatin 40mg / ezetimibe 10mg tablet",      "Simvastatin 80mg / ezetimibe 10mg tablet",
		"Simvastatin 80mg orally disintegrating tablet", "Simvastatin 10mg orally disintegrating tablet", "Simvastatin 80mg / ezetimibe 10mg tablet",
		"Simvastatin 40mg orally disintegrating tablet", "Oral form simvastatin"
	)
)

simvastitin.snomed.codes <- paste0( simvastatin.all$SNOMED, collapse = "," )

got.mg <- grep( "mg", simvastatin.all$TEXT )

simvastitin.ge.40mg <- simvastatin.all[ got.mg, ]

simvastitin.ge.40mg <- simvastitin.ge.40mg[ 40 <= gsub( "mg", "", stringi::stri_extract( simvastitin.ge.40mg$TEXT, regex = "([0-9]+)mg" ) ), ]

simvastitin.ge.40mg.snomed.codes <- paste0( simvastitin.ge.40mg$SNOMED, collapse = "," )

fhir.search.request <- paste0(
	"MedicationStatement?",
	paste0( "code=http://snomed.info/ct|", simvastitin.ge.40mg.snomed.codes ),
	"&_include=MedicationStatement:subject",
	"&_include=MedicationStatement:encounter",
	"&_format=xml",
	"&_pretty=true",
	"&_count=500" )


tables.design <- list(
	MedicationStatement = list(
		"/Bundle/entry/resource/MedicationStatement",
		list(
			MS.AID             = "id/@value",
			STATUS.TEXT        = "text/status/@value",
			STATUS             = "status/@value",
			MEDICATION.SYSTEM  = "medicationCodeableConcept/coding/system/@value",
			MEDICATION.CODE    = "medicationCodeableConcept/coding/code/@value",
			MEDICATION.ANZEIGE = "medicationCodeableConcept/coding/display/@value",
			DOSAGE             = "dosage/text/@value",
			DOSAGE.TIMING      = "dosage/timing/repeat/frequency/@value",
			DOSAGE.PERIOD      = "dosage/timing/repeat/period/@value",
			DOSAGE.PERIOD.UNIT = "dosage/timing/repeat/periodUnit/@value",
			MS.PID             = "subject/reference/@value",
			LAST.UPDATE        = "meta/lastUpdated/@value"
		)
	),
	Patient = list(
		"/Bundle/entry/resource/Patient",
		list(
			P.PID           = "id/@value",
			NAME.USE        = "name/use/@value",
			NAME.GIVEN      = "name/given/@value",
			NAME.FAMILY     = "name/family/@value",
			GENDER          = "gender/@value",
			BIRTHDATE       = "birthDate/@value"
		)
	),
	Encounter = list(
		"/Bundle/entry/resource/Encounter",
		list(
			E.EID = "id/@value",
			E.PID = "subject/reference/@value",
			START = "period/start/@value",
			END   = "period/end/@value"
		)
	)
)

###
# filtere Daten in Tabellen vor dem Export ins Ausgabeverzeichnis
###
post.processing <- function( lot ) {
	
	# extract Patient IDS in all tables in references and ids
	lot <- lapply(
		lot,
		function( df ) {
			
			# find all names with .xID
			pids <- names( df )[ grep( "\\.[A-Z]ID", names( df ) ) ]
			
			for( p in pids ) {
				
				# extract id (number)
				df[[ p ]] <- stringr::str_extract( df[[ p ]], "[[:alpha:]]+$" )
			}
			
			df
		}
	)
	
	# merge all tables by patient's ids
	all. <- data.frame( )
	
	#find 1st not empty data frame and store id for later merging
	for( l in lot ) {
		
		if( 0 < nrow( l ) ) {
			
			all. <- l
			
			pid.left <- names( l )[ grep( "PID$", names( l ) ) ]
			
			break
		}
	}
	
	# merge all not empty data frames to all.
	for( l in lot ) {
		
		if( 0 < nrow( l ) && ! identical( l, all. ) ) {
			
			# find patient's id
			pid.right <- names( l )[ grep( "PID$", names( l ) ) ]
			
			all. <- merge(
				all.,
				l,
				by.x = pid.left,
				by.y = pid.right,
				all  = T 
			)
		}
	}
	
	lot$ALL <- all.
	
	lot
}
