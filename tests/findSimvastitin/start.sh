#!/bin/bash
cd ../../
fhiR=$(pwd .)/fhi.R
cd tests/findSimvastitin
Rscript $fhiR -s spec.R -o result


