#!/bin/bash
# Script to download GEO processed/supplementary data
# Usage: ./1_download_GEO_processed_data.sh -i GEO_accessions.csv -o results

usage() {
    echo "Usage: $0 -i input_file -o output_directory"
    echo "Example: bash $0 -i GEO_accessions.csv -o results"
    exit 1
}

# Parse command-line options
while getopts "i:o:" opt; do
    case "$opt" in
        i) INPUT_FILE="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        *) usage ;;
    esac
done

# Ensure required parameters are provided
if [[ -z "$INPUT_FILE" || -z "$OUTPUT_DIR" ]]; then
    usage
fi

# Validate input file
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Base FTP URL for GEO
BASE_URL="ftp://ftp.ncbi.nlm.nih.gov/geo/series"

# Process each GEO accession in the input file
while IFS= read -r accession || [ -n "$accession" ]; do
    [[ -z "$accession" || "$accession" =~ ^# ]] && continue

    echo "Processing accession: $accession"

    num_part=$(echo "$accession" | grep -oP '\d+')
    [[ -z "$num_part" ]] && { echo "Warning: Could not extract numeric part from '$accession'. Skipping."; continue; }

    range_dir=$(printf "GSE%03dnnn" $((num_part / 1000)))
    ftp_url="$BASE_URL/$range_dir/$accession/"

    accession_output_dir="$OUTPUT_DIR/$accession"
    mkdir -p "$accession_output_dir/processed_data"

    echo "Downloading data from: $ftp_url"
    wget -r -np -nH --cut-dirs=5 -P "$accession_output_dir/processed_data" "$ftp_url"

    echo "Download complete for: $accession"
done < "$INPUT_FILE"

echo "All GEO processed data downloads completed."
