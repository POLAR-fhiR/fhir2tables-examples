#!/bin/bash
cd ../../
fhiR=$(pwd .)/allBundles.R
cd tests/Jens_usecase_1
Rscript $fhiR -s spec.R -o result
