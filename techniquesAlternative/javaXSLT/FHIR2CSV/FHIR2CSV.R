library("xml2")
library("xslt")

# found same idea (no implementation) in 
# XSLT Cookbook: Solutions and Examples for XML and XSLT Developers von Sal Mangano
# page 533
convert <- function(src,fhir,csv,generator="generate-libxslt.xsl") {
  # Create specific Stylesheet for according to table specification
  csv_config <- read_xml(src, package = "xslt")
  generator_xsl <- read_xml(generator, package = "xslt")
  csv_xsl <- xml_xslt(csv_config, generator_xsl)  

  tmpfile = tempfile(pattern ="read_fhir",tmpdir=".",fileext=".xml")
  strip_namespace(fhir,tmpfile)
  fhir_data <- read_xml(tmpfile, package="xslt") 
  file.remove(tmpfile)

  # apply generated Stylesheet to fhir data
  text=xml_xslt(fhir_data, csv_xsl);
  # write csv file
  write(text,file=csv)
}

# FHIR Data contains nasty Namespace declarations, making search uncomfortable
strip_namespace <- function(src,dst) {
  # warn=FALSE suppreses missing EOL warning for last line
  data_as_text <- readLines(src,warn=FALSE)
  # Brute force: remove them and write temporary file
  data_as_text_no_namespace = gsub(' xmlns="http://hl7.org/fhir"','',data_as_text)
  writeLines(data_as_text_no_namespace,dst)
}
args <- commandArgs(trailingOnly = TRUE)

if (length(args)==0) {
  stop("Usage: RScript.exe FHIR2CSV.R xml-bundle table-config", call.=FALSE)
} 
print (args)

convert(args[1],args[2],args[3])

