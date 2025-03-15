#!/bin/bash
# Description: This script is used to submit an interactive job to the Pegasus cluster.
bsub -n 24 -q sccc -P sccc_hpc -Is bash
