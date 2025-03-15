# Pegasus Execution Environment

This README outlines the variables and scripts needed to run jobs on Pegasus.

## Environment Variables

Define the following variables to set up the environment:

```bash
ssh "user@pegasus.idsc.miami.edu"
cd "/projectnb/sccc_hpc/eph/"
```

## Execution Steps

Execute the following scripts in order:

1. **0_interactive_pegasus_job.sh**  
   Starts an interactive Pegasus job on the host.

2. **1_download_GEO_processed_data.sh**  
   Downloads the processed GEO data.

3. **2_download_GEO_SRA_accessions.sh**  
   Retrieves the GEO SRA accessions.

4. **3_download_SRA_fastqs.sh**  
   Downloads the SRA FASTQ files.

Follow the instructions in each script for detailed usage.