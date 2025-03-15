#!/bin/bash
# Description: This script is used to submit an interactive job to the Pegasus cluster.
bsub -n 24 -q sccc -P sccc_hpc -Is bash

# request 10 days of runtime
#bsub -n 24 -q sccc -P sccc_hpc -W 240:00 -Is bash