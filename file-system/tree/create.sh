#!/bin/bash

# Check if the input string parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 '<input_string>' [base_directory]"
  exit 1
fi

# Input string defining directory structure (with 2-space indentation)
input_string="$1"

# Base directory where structure will be created (default to current directory if not provided)
base_dir="${2:-.}"

# Loop through each line in the input string
prev_level=0
prev_path="$base_dir"

while IFS= read -r line; do
  # Trim leading spaces from the line
  trimmed_line=$(echo "$line" | sed 's/^[ ]*//')

  # Calculate current level based on indentation (2 spaces = 1 level)
  indent=$(echo "$line" | grep -o '  ' | wc -l)

  # Determine full path (directory or file)
  if [[ $indent -gt $prev_level ]]; then
    current_path="$prev_path/$trimmed_line"
  elif [[ $indent -eq $prev_level ]]; then
    current_path=$(dirname "$prev_path")/"$trimmed_line"
  else
    diff=$((prev_level - indent))
    current_path=$(dirname "$prev_path")
    for ((i = 0; i < diff; i++)); do
      current_path=$(dirname "$current_path")
    done
    current_path="$current_path/$trimmed_line"
  fi

  # --- Check for file extension to determine if it's a file ---
  if [[ "$trimmed_line" == *.* ]]; then
    # Create the file (touch creates an empty file if it doesn't exist)
    touch "$current_path"
    echo "File created: $current_path"
  else
    # Create the directory
    mkdir -p "$current_path"
    echo "Directory created: $current_path"
  fi

  # Create the directory
  mkdir -p "$current_path"

  # Update previous values
  prev_path="$current_path"
  prev_level=$indent

done <<<"$input_string"

echo "Directory structure created successfully."
