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

echo "[" > "$output_file"

# Function to process files recursively
process_files() {
    local dir="$1"
    local first_entry=true
    
    # Iterate through files and directories
    for filepath in "$dir"/*; do
        if [ -d "$filepath" ]; then
            # Recursively process directories
            process_files "$filepath"
        elif [ -f "$filepath" ]; then
            # Add comma if not the first entry
            if [ "$first_entry" = false ]; then
                echo "," >> "$output_file"
            fi
            first_entry=false
            
            # Read file content safely
            file_content=$(jq -Rs . < "$filepath")
            
            # Append JSON object to file
            echo "  {\"path\": \"$filepath\", \"content\": $file_content}" >> "$output_file"
        fi
    done
}

# Start processing files
process_files "$directory"

echo "
]" >> "$output_file"

echo "JSON generation completed. Output saved to $output_file"
