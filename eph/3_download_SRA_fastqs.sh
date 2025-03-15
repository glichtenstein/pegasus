#!/bin/bash
# Script to download and convert SRA files to FASTQ format.
#
# USAGE:
#   bash 3_download_SRA_fastqs.sh -i results
#
# PARAMETERS:
#   -i  Directory where GEO processed results are stored (contains GSE folders with *_SRR_accessions.csv)
#
# EXAMPLE:
#   bash 3_download_SRA_fastqs.sh -i results
#
# EXPECTED INPUT FOLDER STRUCTURE:
#   results/
#   ├── GSE243413/
#   │   ├── supplementary_data/
#   │   ├── GSE243413_SRR_accessions.csv
#
# OUTPUT FOLDER STRUCTURE (after this script):
#   results/
#   ├── GSE243413/
#   │   ├── fastq_files/
#   │   │   ├── SRRxxxxxxx_1.fastq.gz
#   │   │   ├── SRRxxxxxxx_2.fastq.gz
#   │   ├── sra_files/
#   │   │   ├── SRRxxxxxxx.sra

set -e  # Exit on error

# Function to print usage
usage() {
    echo "Usage: $0 -i input_dir"
    echo "Example: bash $0 -i results"
    echo
    echo "This script fetches FASTQ files from SRA using prefetch and fasterq-dump."
    echo "It expects that '2_download_GEO_SRA_accessions.sh' was successfully executed."
    echo
    echo "FASTQ files will be stored under results/GSE****/fastq_files/"
    echo "SRA files will be stored under results/GSE****/sra_files/"
    exit 1
}

# Parse command-line options
while getopts "i:" opt; do
    case "$opt" in
        i) INPUT_DIR="$OPTARG" ;;
        *) usage ;;
    esac
done

# Ensure required parameter is provided
if [[ -z "$INPUT_DIR" ]]; then
    usage
fi

# Load Miniforge3 module
echo "Loading Miniforge3 module..."
module load miniforge3 || { echo "Error: Failed to load Miniforge3."; exit 1; }

# Define Conda environment
ENV_NAME="sra_env"
ENV_DIR="$HOME/$ENV_NAME"

# Create Conda environment if it doesn't exist
if [[ ! -d "$ENV_DIR" ]]; then
    echo "Creating Conda environment: $ENV_NAME..."
    conda create -y -p "$ENV_DIR" -c bioconda sra-tools
    conda install -y -p "$ENV_DIR" -c conda-forge pigz
fi

# Activate Conda environment
echo "Activating Conda environment..."
conda activate "$ENV_DIR" || { echo "Error: Failed to activate Conda environment."; exit 1; }

# Process each GSE folder
find "$INPUT_DIR" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r gse_dir; do
    gse_id=$(basename "$gse_dir")
    csv_file="$gse_dir/${gse_id}_SRR_accessions.csv"

    # Skip if no CSV file found
    if [[ ! -f "$csv_file" ]]; then
        echo "Warning: No SRR accession file found for $gse_id. Skipping..."
        continue
    fi

    fastq_outdir="$gse_dir/fastq_files"
    sra_outdir="$gse_dir/sra_files"

    mkdir -p "$fastq_outdir"
    mkdir -p "$sra_outdir"

    echo "Processing GSE: $gse_id -> FASTQs: $fastq_outdir, SRAs: $sra_outdir"

    # Read and process each SRR accession
    while IFS= read -r srr_accession; do
        if [[ -n "$srr_accession" ]]; then
            echo "Fetching FASTQ for accession: $srr_accession"

            # Download SRA file
            prefetch --max-size 300gb --output-directory "$sra_outdir" "$srr_accession"

            # Check if the .sra file exists
            if [[ ! -f "$sra_outdir/$srr_accession/$srr_accession.sra" ]]; then
                echo "Error: Prefetch failed for $srr_accession"
                continue
            fi

            # Convert SRA to FASTQ
            fasterq-dump --outdir "$fastq_outdir" --split-files "$sra_outdir/$srr_accession/$srr_accession.sra" \
            --threads 24 --mem 16GB --progress

            # Compress FASTQ files with pigz for faster performance
            pigz -p 24 "$fastq_outdir"/*.fastq
        fi
    done < "$csv_file"
done

# Deactivate Conda environment
conda deactivate

echo "All FASTQ downloads completed."
