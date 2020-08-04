rm( list = ls( ) )

cat( "----------------------------------------------------------------------------------------------------------------------\n" )
cat( "\nTest for the R-Package fhiR\n---- --- --- --------- ----\n" )
cat( "Usage:\n$ Rscript fhi.R -s spec-file\n" )
cat( "-s spec-file: a R-Script containing:\n" )
cat( "  1 - a variable named endpoint that stores the endpoint of the fhir server\n" )
cat( "  2 - a variable named fhir_search_request that stores the fhir search request without the endpoint part\n" )
cat( "  3 - a variable named maximal_number_of_bundles: the limit of downloaded bundle count.\n" )
cat( "  4 - a variable named design that stores the design of the resulting data frames\n" )
cat( "  5 - a variable named output_directory: the name of the directory where the results should be saved. if it does not exist it will be created.\n" )
cat( "  6 - a variable named separator: a separator for multiply values in a resource.\n" )
cat( "  7 - a variable named brackets: brackets surrounding the indices for multiply values in a resource. brackets=NULL means no indexing.\n" )
cat( "  8 - a function named post_processing that allows some post processing on the constructed data frames\n" )
cat( "----------------------------------------------------------------------------------------------------------------------\n" )

cat( "   - 0 download fhiR package if required...\n" )

###
# https://polar-fhir.github.io/fhircrackr/
###

# install v0.1.2
devtools::install_github( "POLAR-fhir/fhircrackr" )

# install v0.1.1
#install.packages( "fhircrackr" )

library( "fhircrackr" )

arg <- commandArgs( T )

spec_file   <- arg[ which( arg == "-s" ) + 1 ]

if( length( spec_file ) < 1 || is.na( spec_file ) ) spec_file <- "spec.R"

cat( "   - 1 load spec-file...\n" )

source( spec_file )

fsr <- fhircrackr::paste_paths( path1 = endpoint, path2 = fhir_search_request )

cat( "   - 2 get bundles...\n" )

bundles <- fhircrackr::fhir_search( request = fsr, max_bundles = max_bundles, verbose = 2 )

cat( "   - 3 convert bundles to data frames...\n" )

# bis version v0.1.2
#list_of_tables <- fhircrackr::fhir_crack( bundles = bundles, design = design, sep = separator, brackets = brackets, add_indices = ! is.null( brackets ) )

# ab version v0.1.2
list_of_tables <- fhircrackr::fhir_crack( bundles = bundles, design = design, sep = separator, brackets = brackets )

cat( "   - 4 post processing...\n" )

list_of_tables <- post_processing( list_of_tables )

cat( "   - 5 saving data...\n" )

if( ! dir.exists( output_directory ) ) {
	
	cat( paste0( "   - 5.1 create directory: ", output_directory, "...\n" ) )
	
	dir.create( output_directory, recursive = T )
	
} else cat( paste0( "   - 5.1 directory ", output_directory, " already exists. do nothing...\n" ) )

back <- getwd( )

setwd( output_directory )

cat( "   - 5.2 write csv tables...\n" )

for( n in names( list_of_tables ) ) {
	
	write.table( list_of_tables[[ n ]], file = paste0( n, ".csv" ), na = "", sep = ";", dec = ".", row.names = F, quote = F )
}

cat( "   - 5.3 write tables.RData...\n" )

save( list_of_tables, file = "tables.RData" )

setwd( back )

cat( "   - 6 fin\n" )
