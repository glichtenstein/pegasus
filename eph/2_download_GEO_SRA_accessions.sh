#!/bin/bash
# Script to extract SRA (SRR) accessions from GEO IDs
# Usage: ./2_download_GEO_SRA_accessions.sh -i GEO_accessions.csv -o results

usage() {
    echo "Usage: $0 -i input_file -o output_directory"
    echo "Example: bash $0 -i GEO_accessions.csv -o results"
    exit 1
}

while getopts "i:o:" opt; do
    case "$opt" in
        i) INPUT_FILE="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        *) usage ;;
    esac
done

[[ -z "$INPUT_FILE" || -z "$OUTPUT_DIR" ]] && usage
[[ ! -f "$INPUT_FILE" ]] && { echo "Error: Input file '$INPUT_FILE' not found."; exit 1; }

# Ensure gse2srr.sh is available
GSE2SRR_SCRIPT="./gse2srr.sh"
if [[ ! -f "$GSE2SRR_SCRIPT" ]]; then
    wget -v -O "$GSE2SRR_SCRIPT" https://raw.githubusercontent.com/akikuno/gse2srr/refs/heads/main/gse2srr.sh
    chmod +x "$GSE2SRR_SCRIPT"
fi

while IFS= read -r accession || [ -n "$accession" ]; do
    [[ -z "$accession" || "$accession" =~ ^# ]] && continue

    output_dir="$OUTPUT_DIR/$accession"
    mkdir -p "$output_dir"

    output_file="$output_dir/${accession}_SRR_accessions.csv"
    echo "Extracting SRR accessions for: $accession -> $output_file"

    "$GSE2SRR_SCRIPT" "$accession" > "$output_file"

    echo "Saved SRR accessions to $output_file"
done < "$INPUT_FILE"

echo "All GEO to SRA conversions completed."
# Clean up
rm -f "$GSE2SRR_SCRIPT"
