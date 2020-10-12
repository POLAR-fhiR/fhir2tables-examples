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
endpoint <- "https://blaze.life.uni-leipzig.de/fhir"


###
# 2 fhir_search_request ohne Endpunktangabe
###
# all blood pressure observations with their related patients and encounters
fhir_search_request <- paste0(
	"Observation?",
#	"code=http://loinc.org|85354-9",
#	"&_include=Observation:subject",
#	"&_include=Observation:encounter",
	"_count=500" )


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
			O.OID = "id",
			O.PID = "subject/reference",
			DATE  = "effectiveDateTime"
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
brackets <- NULL#c("<", ">")


###
# 8 filter Data in Tables before Export into output directory
###
post_processing <- function( lot ) {

	# return list of tables
	lot
}

