# Title     : Test for Yeliz
# Objective : fhiR Example
# Created by: tpeschel
# Created on: 29.05.20

###
# endpoint of the fhir r4 Servers
###
#endpoint <-  "https://vonk.fire.ly/R4/"
endpoint <- "https://hapi.fhir.org/baseR4"

###
# fhir search without endpoint
###
fhir.search <- paste0(
	"Patient?",
	"_revinclude=Patient:context&",
	"_revinclude=MedicationStatement:subject&",
	"_format=xml&",
	"_pretty=true&",
	"_count=500000" )

