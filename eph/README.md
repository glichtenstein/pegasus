# Pegasus Execution Environment

This README outlines the steps and variables needed to run jobs on Pegasus.

## Environment Setup

Before executing any scripts, connect to the Pegasus host and navigate to the working directory:

```bash
ssh user@pegasus.idsc.miami.edu
cd /projectnb/sccc_hpc/eph/
```

## Execution Steps

Run the following scripts in order:

1. **0_interactive_pegasus_job.sh**  
   Starts an interactive Pegasus job on the host.

2. **1_download_GEO_processed_data.sh**  
   Downloads the processed GEO data.

3. **2_download_GEO_SRA_accessions.sh**  
   Retrieves the GEO SRA accession data.

4. **3_download_SRA_fastqs.sh**  
   Downloads the SRA FASTQ files.

Refer to each script for further instructions.