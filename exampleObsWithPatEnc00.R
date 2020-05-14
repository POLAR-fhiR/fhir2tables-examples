###
# free mem
###
rm( list =ls ( ) )

source( "rxml4.R" )

###
# some server to try out
###

endpoint <- "https://vonk.fire.ly/R4/"
#endpoint <- "http://demo.oridashi.com.au:8305/"
#endpoint <- "http://test.fhir.org/r4/"
#endpoint <- "https://hapi.fhir.org/baseR4/"

###
# a fhir search request for all observations and their relating encounters, subject and patients
###
url.obs <- bind.paths( endpoint, "Observation?_include=Observation:encounter&_include=Observation:patient&_format=xml&_pretty=true&_count=1000000" )

###
# which data will be found in which bundle entry?
###
entries.obs <- list(
	Observation = list(
		entry   = ".//Observation",
		items = list(
			OID   = "id/@value",
			PID   = "subject/reference/@value",
			VALUE = "valueQuantity/value/@value", 
			UNIT  = "valueQuantity/unit/@value", 
			TEXT  = "code/text/@value",
			CODE  = "code/coding/code/@value",
			DATE  = "effectiveDateTime/@value"
		)
	),
	Encounter = list(
		entry = ".//Encounter",
		items = list( 
			EID     = "id/@value",
			PAT.ID  = "subject/reference/@value",
			PRT.ID  = "participant/individual/reference/@value",
			START   = "period/start/@value",
			END     = "period/end/@value",
			SYSTEM  = "class/system/@value",
			CODE    = "class/code/@value",
			DISPLAY = "class/display/@value"
		)
	),
	Patient = list(
		entry   = ".//Patient",
		items = list( 
			PID      = "id/@value", 
			NAME.U   = "name/use/@value", 
			NAME.G   = "name/given/@value", 
			NAME.F   = "name/family/@value",
			SEX      = "gender/@value", 
			BIRTHDAY = "birthDate/@value" 
		)
	)
)

dir.obs <- "data/obsWithPatEnc"

xmls <- fhir.get.bundle.as.xml.list.from.server( url.obs )

save.xmls.in.directory( xmls, dir.obs )

#rm( xmls )

#xmls <- fhir.get.bundle.as.xml.list.from.dir( dir.obs )

data.obs <- fhir.get.bundle.entries.as.dataframes( xmls, entries.obs )

# data.obs$Observation
# data.obs$Patient
# data.obs$Encounter

save( data.obs, file = bind.paths( dir.obs, "data.RData" ) )

for( n in names( data.obs ) ) {
	
	d <- data.obs[[ n ]]
	
	write.table( d, bind.paths( dir.obs, paste0( n, ".csv" ) ), sep = ";", row.names = F )
}

# rm( data.obs )
# 
# load( bind.paths( dir.obs, "data.RData" ) )
	  
