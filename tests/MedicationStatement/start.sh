#!/bin/bash
cd ../../
fhiR=$(pwd .)/allBundles.R
cd tests/MedicationStatement
Rscript $fhiR -s spec-medication-statement.R -o result
