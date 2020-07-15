# 1 - a variable named endpoint that stores the endpoint of the fhir server
# 2 - a variable named fhir_search_request that stores the fhir search request without the endpoint part
# 3 - a variable named max_bundles: the limit of downloaded bundle count
# 4 - a variable named design that stores the design of the resulting data frames
# 5 - a variable named output_directory: the name of the directory where the results should be saved. if it does not exist it will be created.
# 6 - a variable named separator: a separator for multiply values in a resource. default is ' -+- '
# 7 - a variable named brackets: brackets surrounding the indices for multiply values in a resource. no brackets mean no indexing.
# 8 - a function named post_processing that allows some post processing on the constructed data frames.


##############################################
# Observation blood pressure from loinc code #
##############################################


###
# 1 endpoint of FHIR r4 Server
###
#endpoint <-  "https://vonk.fire.ly/R4/"#
endpoint <- "https://hapi.fhir.org/baseR4"


###
# 2 fhir.search.request without endpoint
###
fhir_search_request <- paste0(
	"Observation?",
    "code=http://loinc.org|85354-9&_format=xml",
    "&_count=500")


###
# 3 max_bundles
###
max_bundles <- Inf
###


###
# 4 design
###
design <- list(
	Observations = list(
		"//Observation",
		list( 
			PID   = "subject/reference/@value",
			OID   = "id/@value",
			DIA   = "component[code/coding/code/@value='8462-4']/valueQuantity/value/@value", 
			SYS   = "component[code/coding/code/@value='8480-6']/valueQuantity/value/@value",
			DATE  = "effectiveDateTime/@value"
		)
	)
)


###
# 5 output_directory
###
output_directory <- "result"


###
# 6 separator
###
separator <- " › "


###
# 7 brackets
###
brackets <- NULL#c("<", ">")


###
# 8 filter Data in Tables before Export into output directory
###
post_processing <- function( lot ) {

	#dbg
	#lot <- list_of_tables
	
	lot$Observations <- lot$Observations[ 
		( ! is.na( lot$Observations$DIA ) & ! is.numeric( lot$Observations$DIA ) &  80 < lot$Observations$DIA ) |
		( ! is.na( lot$Observations$SYS ) & ! is.numeric( lot$Observations$SYS ) & 120 < lot$Observations$SYS ), ]

	lot
}
