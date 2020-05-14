all: csv/Patient.csv csv/Observation.csv csv/ObservationPatient.csv csv/Bloodpressure.csv


# Ausführliches Makefile (könnte auch als allgemeine Regel formuliert werden)
# 
# Generierte Daten (können alle gelöscht werden)
# *.gen.xsl = Generierte XSLT Stylesheets
# *.fhir.xml= FHIR Ressource Bundles
# * .csv	= Ergebnistabelle als CSV
# 
# Echte 
# Generate.xsl = Generator Stylesheet
# *.src.xml	= CSV Spezifikation (Vorschlag FM)
# saxon9he.jar = Bibliothek zur XSLT Verarbeitung
#
# Das makefile kann auch parallel (make -j4) gestartet werden

g=generate-saxon.xsl
#g=generate-libxslt.xsl


csv/Patient.csv: config/Patient-src.xml fhir/Patient-fhir.xml
	java -Xmx1000m -jar saxon9he.jar config/Patient-src.xml ${g} > tmp/Patient-gen.xsl
	java -Xmx1000m -jar saxon9he.jar fhir/Patient-fhir.xml tmp/Patient-gen.xsl > $@
	
csv/Observation.csv:  config/Observation-src.xml fhir/Observation-fhir.xml
	java -Xmx1000m -jar saxon9he.jar config/Observation-src.xml ${g} > tmp/Observation-gen.xsl
	java -Xmx1000m -jar saxon9he.jar fhir/Observation-fhir.xml tmp/Observation-gen.xsl > $@

csv/ObservationPatient.csv: config/ObservationPatient-src.xml fhir/ObservationPatient-fhir.xml
	java -Xmx1000m -jar saxon9he.jar config/ObservationPatient-src.xml ${g} > tmp/ObservationPatient-gen.xsl
	java -Xmx1000m -jar saxon9he.jar fhir/ObservationPatient-fhir.xml tmp/ObservationPatient-gen.xsl > $@

csv/Bloodpressure.csv: config/Bloodpressure-src.xml fhir/Bloodpressure-fhir.xml
	java -Xmx1000m -jar saxon9he.jar config/Bloodpressure-src.xml ${g} > tmp/Bloodpressure-gen.xsl
	java -Xmx1000m -jar saxon9he.jar fhir/Bloodpressure-fhir.xml tmp/Bloodpressure-gen.xsl > $@

fhir/Bloodpressure-fhir.xml:
	wget -O $@ 'http://hapi.fhir.org/baseR4/Observation?code=http://loinc.org|85354-9&_format=xml&_count=100'
	
fhir/Patient-fhir.xml: 
	wget -O $@ 'http://hapi.fhir.org/baseR4/Patient?_format=xml&_count=100'
	
fhir/Observation-fhir.xml:
	wget -O $@ 'http://hapi.fhir.org/baseR4/Observation?code=http://loinc.org|3141-9&_format=xml&_count=100'

fhir/ObservationPatient-fhir.xml:
	wget -O $@ 'http://hapi.fhir.org/baseR4/Observation?code=http://loinc.org|3141-9&_include=Observation:patient&_format=xml&_count=100'

clean:
	rm -f fhir/* csv/* tmp/* 

