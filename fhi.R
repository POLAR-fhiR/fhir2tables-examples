rm( list = ls( ) )

cat( "----------------------------------------------------------------------------------------------------------------------\n" )
cat( "\nTest for the R-Package fhiR\n---- --- --- --------- ----\n" )
cat( "Usage:\n$ Rscript fhi.R -s spec-file -o output-directory -n maximal-number-of-bundles -S separator-for-multiply-values\n" )
cat( "-s spec-file: a R-Script containing:\n" )
cat( "  - a variable named endpoint that stores the endpoint of the fhir server\n" )
cat( "  - a variable named fhir.search.request that stores the fhir search request without the endpoint part\n" )
cat( "  - a variable named tables.design that stores the design of the resulting data frames\n" )
cat( "  - a function named post.processing that allows some post processing on the constucted data frames\n" )
cat( "-o output-directory: the name of the directory where the results should be saved. if it does not exist it will be created.\n" )
cat( "-n maximal-number-of-bundles-directory: the limit of downloaded bundle count.\n" )
cat( "-S separator-for-multiply-values: a separator for multiply values in a resource. default is ' -+- '\n\n" )
cat( "----------------------------------------------------------------------------------------------------------------------\n" )

#devtools::install_github( "POLAR-fhiR/fhiR", ref = "f4d1fa9a0eed5b8e1b4690d37de6acb77cca6037", quiet = T, force = F )
cat( "   - 0 download fhiR package if required...\n" )

devtools::install_github( "POLAR-fhiR/fhiR", quiet = T )

###
# https://polar-fhir.github.io/fhiR/
###

#library( fhiR )

arg <- commandArgs( T )

spec.file   <- arg[ which( arg == "-s" ) + 1 ]
out.dir     <- arg[ which( arg == "-o" ) + 1 ]
max.bundles <- arg[ which( arg == "-n" ) + 1 ]
separator   <- arg[ which( arg == "-S" ) + 1 ]

if( length( spec.file ) < 1 || is.na( spec.file ) ) spec.file <- "spec.R"

if( length( out.dir ) < 1 || is.na( out.dir ) ) out.dir <- "result"

if( length( max.bundles ) < 1 || is.na( max.bundles ) ) max.bundles <- Inf

if( length( separator ) < 1 || is.na( separator ) ) separator <- " › "

cat( "   - 1 load spec-file...\n" )

source( spec.file )

url     <- fhiR::paste.paths( path1 = endpoint, path2 = fhir.search.request )

cat( "   - 2 get bundles...\n" )

bundles <- fhiR::get.bundles( request = url, max.bundles = max.bundles, verbose = T )

cat( "   - 3 convert bundles to data frames...\n" )

list.of.tables <- fhiR::bundles2dfs( bundles = bundles, design = tables.design, sep = separator )

cat( "   - 4 post processing...\n" )

list.of.tables <- post.processing( list.of.tables )

cat( "   - 5 saving data...\n" )

if( ! dir.exists( out.dir ) ) {
	
	cat( paste0( "   - 5.1 create directory: ", out.dir, "...\n" ) )
	
	dir.create( out.dir, recursive = T )
} else cat( paste0( "   - 5.1 directory ", out.dir, " already exists. do nothing...\n" ) )

back <- getwd( )

setwd( out.dir )

cat( "   - 5.2 write csv tables...\n" )

for( n in names( list.of.tables ) ) {
	
	write.table( list.of.tables[[ n ]], file = paste0( n, ".csv" ), na = "", sep = ";", dec = ".", row.names = F, quote=F )
}

cat( "   - 5.3 write tables.RData...\n" )

save( list.of.tables, file = "tables.RData" )

setwd( back )

cat( "   - 6 fin\n" )
