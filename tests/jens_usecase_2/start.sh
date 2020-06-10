#!/bin/bash
cd ../../
#fhiR=$(pwd .)/allBundles.R
fhiR=$(pwd .)/allBundlesWithOutput.R
cd tests/jens_usecase_2
Rscript $fhiR -s spec-medication-simvastitin.R -o result

