# Fhir2Tables

Vergleich zweier Ansätze zur Extraktion und Transformation von Daten aus FHIR-Bundles zu Tabellen.

## 1. Ansätze
1. Download, Extraktion, Transformation via makefile, java und XSLT
2. Download, Extraktion, Transformation in R unter Nutzung des Packages xml2

## 2. Beispiele
### Verwendete Endpoints  
  - "http://demo.oridashi.com.au:8305/"  
  - "http://test.fhir.org/r4/"  
  - "https://vonk.fire.ly/R4/"  
    - vonk scheint die besten Daten zu haben, doch nur wenige  
  - "https://hapi.fhir.org/baseR4/"  
    - hapi hat viele aber auch viele unsinnige Daten und scheint bereits ueberlastet zu sein
	- ab 21:30 wird es besser  

### 2.1 Patient
Liefere für alle Patienten die ID, das Geschlecht und das Geburtsdatum.  

FHIR Search: http://hapi.fhir.org/baseR4/Patient?_format=xml  
Spezifikationen:
  - **java-xslt**
```
<table of="Patient”>
	<column label="PID" search="id/@value"/>
	<column label="GENDER" search ="gender/@value"/>
	<column label="BIRTHDATE" search ="birthDate/@value"/>
</tab>
```
  - **puRe**  
```
list(
	Patient = list(
		entry = ".//Patient",
		list(
			PID       = "id/@value",
			GENDER    = "gender/@value",
			BIRTHDATE = "birthdDate/@value"
		)
	)
)
```

### 2.2 Observation
Liefere für alle Untersuchungen die Patienten-ID, das Gewicht und das Erhebungsdatum.  

FHIR Search: http://hapi.fhir.org/baseR4/Observation?code=http://loinc.org|3141-9&_format=xml  
Spezifikationen:
  - **java-xslt**
```
<table of="Observation">
	<column label="PID" search ="$patientId"/>
	<column label="WEIGHT" search ="valueQuantity/value/@value"/>
	<column label="DATE" search ="effectiveDateTime/@value"/>
</tab>
```  
  - **puRe**  
```
list(
	Observation = list(
		entry = ".//Observation",
		list(
			PID    = "subject/reference/id/@value",
			WEIGHT = "valueQuantity/value/@value",
			DATE   = "effectiveDateTime/@value"
		)
	)
)
```

## 3. Polar Use Cases