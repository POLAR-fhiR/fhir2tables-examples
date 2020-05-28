rm( list = ls( ) )

#remove.packages( "fhiR" )

devtools::install_github( "TPeschel/fhiR@master", quiet = T )

###
# https://tpeschel.github.io/fhiR/
###

library( fhiR )

bundle <- xml2::read_xml( "specimen.xml" )

design <- list(
	
	Specimen = list(
		"extension",
		list(
			VCS  = "valueCodeableConcept/coding/system/@value",
			CODE = "valueCodeableConcept/coding/code/@value"
		)
	)
)

( df.all <- bundle.to.dataframes( bundle, design ) )

design$Specimen[[ 1 ]] <- "extension[./@url='https://fhir.bbmri.de/StructureDefinition/StorageTemperature']"

# design <- list(
# 	
# 	Specimen = list(
# 		"extension[./@url='https://fhir.bbmri.de/StructureDefinition/StorageTemperature']",
# 		list(
# 			VCS  = "valueCodeableConcept/coding/system/@value",
# 			CODE = "valueCodeableConcept/coding/code/@value"
# 		)
# 	)
# )

( df.sel <- bundle.to.dataframes( bundle, design ) )

