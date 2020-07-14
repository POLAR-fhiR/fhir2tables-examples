# 1 - a variable named endpoint that stores the endpoint of the fhir server
# 2 - a variable named fhir_search_request that stores the fhir search request without the endpoint part
# 3 - a variable named max_bundles: the limit of downloaded bundle count
# 4 - a variable named design that stores the design of the resulting data frames
# 5 - a variable named output_directory: the name of the directory where the results should be saved. if it does not exist it will be created.
# 6 - a variable named separator: a separator for multiply values in a resource. default is ' -+- '
# 7 - a variable named brackets: brackets surrounding the indices for multiply values in a resource. no brackets mean no indexing.
# 8 - a function named post_processing that allows some post processing on the constructed data frames.


############################
# Patients with thier Ages #
############################


###
# 1 endpoint of FHIR r4 Server
###
endpoint <-  "https://vonk.fire.ly/R4/"
#endpoint <- "https://hapi.fhir.org/baseR4/"


###
# 2 fhir_search_request without endpoint
###
fhir_search_request <- paste0(
	"Patient?",
	"_format=xml",
	"&gender=male,female",
	"&_count=500")


###
# 3 max_bundles
###
max_bundles <- Inf


###
# 4 table design
###

design <- list(
	Patient = list(
		entry   = "//Patient",
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
	
	lot <- lapply( lot, na.omit )

	###
	# calc age
	###
	lot$Patient[[ "AGE [y]" ]] <- round( as.double( difftime( Sys.Date( ), as.Date( lot$Patient$BIRTHDATE ), units = "days" ) ) / 365.25, 2 ) 

	lot
}
