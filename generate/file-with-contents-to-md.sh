#!/bin/bash

# Check if correct arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory> <output_file>"
    exit 1
fi

directory="$1"
output_file="$2"

# Ensure output file exists or create it
touch "$output_file"

# Empty the output file
> "$output_file"

# Function to process files recursively
process_files() {
    local dir="$1"
    
    # Iterate through files and directories
    for filepath in "$dir"/*; do
        if [ -d "$filepath" ]; then
            # Recursively process directories
            process_files "$filepath"
        elif [ -f "$filepath" ]; then
            # Append file path as comment and file content
            echo "//${filepath}" >> "$output_file"
            cat "$filepath" >> "$output_file"
            echo "" >> "$output_file"  # Add newline separator
        fi
    done
}

# Start processing files
process_files "$directory"

echo "Concatenation completed. Output saved to $output_file"
