#!/bin/bash

# Function to recursively read the directory structure and generate JSON
generate_json_structure() {
  local dir="${1:-$(pwd)}"

  find "$dir" -type d -o -type f | while IFS= read -r path; do
    relative_path=$(realpath --relative-to="$dir" "$path")

    if [[ -d "$path" ]]; then
      echo "{\"path\": \"$relative_path\"},"
    elif [[ -f "$path" ]]; then
      content=$(<"$path")
      # Escape double quotes in content
      content=$(echo "$content" | sed 's/\"/\\"/g')
      echo "{\"path\": \"$relative_path\", \"content\": \"$content\"},"
    fi
  done
}

# Main logic to wrap the output into a JSON array
output_json() {
  local dir="$1"
  
  echo "["
  generate_json_structure "$dir" | sed '$ s/,$//'
  echo "]"
}

# Ensure a directory path is provided
#if [[ -z "$1" ]]; then
#  echo "Please provide a directory path."
#  exit 1
#fi

# Run the function and output the JSON
output_json "$1"
