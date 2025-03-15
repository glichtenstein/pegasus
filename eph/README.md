# Pegasus Execution Environment

This README outlines the steps and variables needed to run jobs on Pegasus.

## Environment Setup

Before executing any scripts, connect to the Pegasus host and navigate to the working directory:

```bash
ssh user@pegasus.idsc.miami.edu
cd /projectnb/sccc_hpc/eph/
```

## Execution Steps

Execute the following commands in sequence:

- **0_interactive_pegasus_job.sh**  
  Starts an interactive Pegasus job on the host.
  ```bash
  bash 0_interactive_pegasus_job.sh
  ```

- **1_download_GEO_processed_data.sh**  
  Downloads the processed GEO data.
  ```bash
  bash 1_download_GEO_processed_data.sh
  ```

- **2_download_GEO_SRA_accessions.sh**  
  Retrieves the GEO SRA accession data.
  ```bash
  bash 2_download_GEO_SRA_accessions.sh
  ```

- **3_download_SRA_fastqs.sh**  
  Downloads the SRA FASTQ files.
  ```bash
  bash 3_download_SRA_fastqs.sh
  ```

Refer to each script for further instructions.