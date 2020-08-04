# 1 - a variable named endpoint that stores the endpoint of the fhir server
# 2 - a variable named fhir_search_request that stores the fhir search request without the endpoint part
# 3 - a variable named max_bundles: the limit of downloaded bundle count
# 4 - a variable named design that stores the design of the resulting data frames
# 5 - a variable named output_directory: the name of the directory where the results should be saved. if it does not exist it will be created.
# 6 - a variable named separator: a separator for multiply values in a resource. default is ' -+- '
# 7 - a variable named brackets: brackets surrounding the indices for multiply values in a resource. no brackets mean no indexing.
# 8 - a function named post_processing that allows some post processing on the constructed data frames.


###
# 1 endpoints of a fhir r4 server
###
#endpoint <-  "https://vonk.fire.ly/R4/"
endpoint <- "https://hapi.fhir.org/baseR4"


###
# 2 fhir_search_request ohne Endpunktangabe
###
# all blood pressure observations with their related patients and encounters
fhir_search_request <- paste0(
	"Observation?",
	"code=http://loinc.org|85354-9",
	"&_include=Observation:subject",
	"&_include=Observation:encounter",
	"&_count=500" )


###
# 3 max_bundles
###
# get all bunles available
max_bundles <- Inf


###
# 4 design
###
# select what's interresting
design <- list(
	Observations = list(
		"//Observation",
		list( 
			O.OID = "id/@value",
			O.PID = "subject/reference/@value",
			O.EID = "encounter/reference/@value",
			DIA   = "component[code/coding/code/@value='8462-4']/valueQuantity/value/@value", 
			SYS   = "component[code/coding/code/@value='8480-6']/valueQuantity/value/@value",
			DATE  = "effectiveDateTime/@value"
		)
	),
	Encounters = list(
		"//Encounter",
		list(
			E.EID = "id/@value",
			E.PID = "subject/reference/@value",
			START = "period/start/@value",
			END   = "period/end/@value"
		)
	),
	Patients = list(
		"//Patient",
		list(
			P.PID    = "id/@value", 
			GVN.NAME = "name/given/@value", 
			FAM.NAME = "name/family/@value",
			SEX      = "gender/@value", 
			DOB      = "birthDate/@value" 
		)
	)
)


###
# 5 output_directory
###
output_directory <- "results"


###
# 6 separator
###
separator <- " | "


###
# 7 brackets for multi entries
###
# we doen't need brackets, because we don't add indices
brackets <- c("<", ">")


###
# 8 filter Data in Tables before Export into output directory
###
post_processing <- function( lot ) {

	#make ids mergeable
	lot <- lapply(
		lot,
		function( df ) {
			
			# find all names with .xID
			pids <- names( df )[ grep( "\\.[A-Z]ID", names( df ) ) ]
			
			for( p in pids ) {
				
				# extract id
				df[[ p ]] <- stringr::str_extract( df[[ p ]], "[0-9]+$" )
			}
			
			df
		}
	)
	
	#merge all tables by ids
	lot$ALL <- 
		merge( 
			merge( 
				lot$Observations, 
				lot$Patients, 
				by.x = "O.PID", 
				by.y = "P.PID",
				all = F
			),
			lot$Encounters, 
			by.x = "O.EID",
			by.y = "E.EID",
			all = F
		)
	
	# add age column
	lot$ALL$AGE <- round( as.double( as.Date( lot$ALL$DATE ) - as.Date( lot$ALL$DOB ) ) / 365.25, 2 )
	
	
	# select only interresting columns
	lot$ALL <- lot$ALL[ , c( "O.PID", "O.OID", "O.EID", "GVN.NAME", "FAM.NAME", "SEX", "AGE", "DIA", "SYS" ) ]

	# return list of tables
	lot
}

