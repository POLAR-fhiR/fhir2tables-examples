#!/bin/bash
Rscript fhi.R -s ../tests/1/spec.R ../tests/1/result #blodd pressure example
Rscript fhi.R -s ../tests/2/spec.R ../tests/2/result #patient resource example
Rscript fhi.R -s ../tests/3/spec.R ../tests/3/result #observation example
Rscript fhi.R -s ../tests/4/spec.R ../tests/4/result #patient and observation example together
