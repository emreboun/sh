#!/bin/bash

# Default values
path="."
depth=3

# Parse command-line options
while getopts ":d:" opt; do
  case $opt in
    d) depth=$OPTARG ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
  esac
done

# Shift out parsed options
shift $((OPTIND -1))

# If a path is provided, use it; otherwise, use default "."
if [[ -n "$1" ]]; then
  path="$1"
fi

# Function to print the directory structure
print_structure() {
  local current_path="$1"
  local indent_level="$2"
  local current_depth="$3"

  # Check if max depth reached
  if [[ "$current_depth" -gt "$depth" ]]; then
    return
  fi

  # Print directories and files
  for item in "$current_path"/*; do
    if [[ -d "$item" ]]; then
      # Print directory with "/" and indent according to depth
      printf "%${indent_level}s/\033[1;34m$(basename "$item")\033[0m\n"
      print_structure "$item" $((indent_level + 2)) $((current_depth + 1))
    elif [[ -f "$item" ]]; then
      # Print file with "-" and indent according to depth
      printf "%${indent_level}s-\033[1;32m$(basename "$item")\033[0m\n"
    fi
  done
}

# Start printing the structure from the specified path
echo "Directory structure for: $path"
print_structure "$path" 2 1

