#!/bin/bash
#cd ../../
#fhiR=$(pwd .)/allBundles.R
#cd tests/jens_usecase_2
#echo $fhiR
#Rscript $fhiR -s spec-blutdruck.R -o resultBlutdruck
cd ../../
fhiR=$(pwd .)/allBundles.R
cd tests/jens_usecase_2
Rscript $fhiR -s spec-medication-simvastitin.R -o result

