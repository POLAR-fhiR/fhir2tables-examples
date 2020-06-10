rm( list = ls( ) )

#devtools::install_github( "POLAR-fhiR/fhiR", ref = "f4d1fa9a0eed5b8e1b4690d37de6acb77cca6037", quiet = T, force = F )
devtools::install_github( "POLAR-fhiR/fhiR", quiet = T )

###
# https://polar-fhir.github.io/fhiR/
###

#library( fhiR )

arg <- commandArgs( T )

spec.file   <- arg[ which( arg == "-s" ) + 1 ]
out.dir     <- arg[ which( arg == "-o" ) + 1 ]
max.bundles <- arg[ which( arg == "-n" ) + 1 ]

if( length( spec.file ) < 1 || is.na( spec.file ) ) spec.file <- "spec.R"

if( length( out.dir ) < 1 || is.na( out.dir ) ) out.dir <- "result"

if( length( max.bundles ) < 1 || is.na( max.bundles ) ) max.bundles <- Inf

source( spec.file )

url     <- fhiR::paste.paths( path1 = endpoint, path2 = fhir.search.request )

bundles <- fhiR::get.bundles( request = url, max.bundles = max.bundles, verbose = T )

list.of.tables <- fhiR::bundles2dfs( bundles, tables.design )

list.of.tables <- post.processing( list.of.tables )

if( ! dir.exists( out.dir ) ) dir.create( out.dir, recursive = T )

back <- getwd( )

setwd( out.dir )

for( n in names( list.of.tables ) ) {
	
	write.table( list.of.tables[[ n ]], file = paste0( n, ".csv" ), na = "", sep = ";", dec = ".", row.names = F, quote=F )
}

save( list.of.tables, file = "tables.RData" )

setwd( back )
