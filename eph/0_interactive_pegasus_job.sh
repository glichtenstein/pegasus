#!/bin/bash
# Description: This script is used to submit an interactive job to the Pegasus cluster.
# It requests 24 cores for 10 days.
# Usage: bash 0_interactive_pegasus_job.sh
bsub -n 24 -q sccc -P sccc_hpc -W 240:00 -Is bash