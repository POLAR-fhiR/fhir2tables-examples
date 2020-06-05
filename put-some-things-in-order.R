rm( list = ls( ) )

dir.name <- "tests/"

all.RFiles <- fhiR::paste.paths( dir.name, dir( path = dir.name, recursive = T, include.dirs = F, pattern = ".R" ) )

for( rfile in all.RFiles ) {
	
	#dbg
	#rfile <- all.RFiles[[ 1 ]]
	
	s1 <- readr::read_file( rfile )
	
	s1 <- gsub( "fhir.search", "fhir.search.request", s1 )	
	
	path  <- stringr::str_extract( rfile, "^.+/" )
	fname <- gsub( "^.+/", "", rfile )
	
#	readr::write_file( s1, fhiR::paste.paths( path, paste0( "new_", fname ) ) )
	readr::write_file( s1, fhiR::paste.paths( path, fname ) )
}
