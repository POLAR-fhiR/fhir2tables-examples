rm( list = ls( ) )

cat( "----------------------------------------------------------------------------------------------------------------------\n" )
cat( "\nTest for the capability.statement function of the R-Package fhiR\n---- --- --- --------- ----\n" )
cat( "Usage:\n$ Rscript caps.R -a fhir-endpoint\n" )
cat( "-a fhir-endpoint: the url of a fhir server endpoint:\n" )
cat( "-o output-directory: the name of the directory where the results should be saved. if it does not exist it will be created.\n" )
cat( "-S separator-for-multiply-values: a separator for multiply values in a resource. default is ' -+- '\n\n" )
cat( "----------------------------------------------------------------------------------------------------------------------\n" )

#devtools::install_github( "POLAR-fhiR/fhiR", ref = "f4d1fa9a0eed5b8e1b4690d37de6acb77cca6037", quiet = T, force = F )
cat( "   - 0 download fhiR package if required...\n" )

#devtools::install_github( "POLAR-fhiR/fhiR", ref = "conformance_function", quiet = F, force = T )
devtools::install_github( "POLAR-fhiR/fhiR@conformance_function", quiet = T )

###
# https://polar-fhir.github.io/fhiR/
###

#library( fhiR )

arg <- commandArgs( T )

endpoint    <- arg[ which( arg == "-a" ) + 1 ]
out.dir     <- arg[ which( arg == "-o" ) + 1 ]
separator   <- arg[ which( arg == "-S" ) + 1 ]

if( length( endpoint ) < 1 || is.na( endpoint ) ) endpoint <- "https://vonk.fire.ly/R4"

if( length( out.dir ) < 1 || is.na( out.dir ) ) out.dir <- "result"

if( length( separator ) < 1 || is.na( separator ) ) separator <- " › "

cat( "   - 1 get conformance...\n" )

caps <- fhiR::capability.statement( endpoint, separator )

cat( "   - 2 saving data...\n" )

if( ! dir.exists( out.dir ) ) {
	
	cat( paste0( "   - 3.1 create directory: ", out.dir, "...\n" ) )
	
	dir.create( out.dir, recursive = T )
	
} else cat( paste0( "   - 3.1 directory ", out.dir, " already exists. do nothing...\n" ) )

back <- getwd( )

setwd( out.dir )

cat( "   - 3.2 write csv table...\n" )

write.table( caps, file = "caps.csv", na = "", sep = ";", dec = ".", row.names = F, quote = F )

cat( "   - 3.3 write caps.RData...\n" )

save( caps, file = "caps.RData" )

setwd( back )

cat( "   - 4 fin\n" )

