rm( list = ls( ) )

#setwd("examples/sequentially_download/")

###
# https://polar-fhir.github.io/fhircrackr/
###

# install v0.1.2
# devtools::install_github( "POLAR-fhir/fhircrackr" )
install.packages("fhircrackr")

library("fhircrackr")

#endpoint <- "https://blaze.life.uni-leipzig.de/fhir"
endpoint <- "https://hapi.fhir.org/baseR4"

fhir_search_request <- paste0(
	"Observation?",
	"code=72514-3&",
	"_count=500" )

fsr <- fhircrackr::paste_paths(path1 = endpoint, path2 = fhir_search_request)

max_bundles <- 2

design <- list(
	Observations = list(
		"//Observation"
	)
)

separator <- " | "

brackets <- c("<", ">")

post_processing <- function(lot) {

	# return list of tables
	lot
}

output_directory <- "results_72514-3-Blaze"

if( ! dir.exists(output_directory)) {
	
	dir.create(output_directory, recursive = T)
}

back <- getwd()

setwd(output_directory)

cnt <- 0

while(! is.null(fsr) && cnt < 5) {

	bundles <- fhircrackr::fhir_search(request = fsr, max_bundles = max_bundles, verbose = 2)

	list_of_tables <- fhircrackr::fhir_crack(bundles = bundles, design = design, sep = separator, brackets = brackets)

	list_of_tables <- post_processing(list_of_tables)

	for(n in names(list_of_tables)) {

		write.table(list_of_tables[[n]], file = paste0(n, "_", cnt, ".csv"), na = "", sep = ";", dec = ".", row.names = F, quote = F)
	}

	save(list_of_tables, file = paste0("tables_", cnt, ".RData"))

	cnt <- cnt + 1

	fsr <- fhircrackr::fhir_next_bundle_url()
}

all <- list()

for(fn in dir(pattern = "RData")) {
	load(fn)
	for( n in names(list_of_tables)) {
		all[[n]][[fn]] <- list_of_tables[[n]]
	}
}

all <- lapply(
	all,
	function(lot) {
		data.table::rbindlist(lot, fill = TRUE)
	}
)

save(all, file = "all.RData")

setwd( back )

cat( "   fin\n" )
