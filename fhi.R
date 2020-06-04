rm( list = ls( ) )

devtools::install_github( "TPeschel/fhiR", quiet = T )

###
# https://tpeschel.github.io/fhiR/
###

#library( fhiR )

arg <- commandArgs( T )

spec.file <- arg[ which( arg == "-s" ) + 1 ]
out.dir   <- arg[ which( arg == "-o" ) + 1 ]

if( length( spec.file ) < 1 || is.na( spec.file ) ) spec.file <- "spec.R"

if( length( out.dir ) < 1 || is.na( out.dir ) ) out.dir <- "result"

source( spec.file )

url     <- fhiR::paste.paths( path1 = endpoint, path2 = fhir.search )

bundles <- fhiR::fhir.search( url )

# list of tables
list.of.tables <- fhiR::result2dfs( bundles, tables.design )

list.of.tables <- filter.data( list.of.tables )

if( ! dir.exists( out.dir ) ) dir.create( out.dir, recursive = T )

back <- getwd( )

setwd( out.dir )

for( n in names( list.of.tables ) ) {
	
	write.table( list.of.tables[[ n ]], file = paste0( n, ".csv" ), na = "", sep = ";", dec = ".", row.names = F, quote=F )
}

save( list.of.tables, file = "tables.RData" )

setwd( back )
