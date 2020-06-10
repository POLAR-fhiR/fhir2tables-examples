#hier kann man Ausgaben definieren und mit den Tabellen weiterarbeiten
#Kann für jede einzelne Anfrage von fhir search und Tabellierung angepasst werden
#print(summary(tables.design))
dat <- read.csv("Patienten.csv",header=TRUE, sep=";")
d <- dim(dat)
cat("Anzahl der Patienten = ", d[1],"\n\n")

