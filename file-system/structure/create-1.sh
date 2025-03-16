#!/bin/bash

# Take input arguments
JSON_INPUT="$1"
TARGET_PATH="${2:-$(pwd)}"

# Function to create directories and files based on JSON input
create_structure() {
  local json="$1"
  local base_path="$2"
  # {{ edit_1: Read JSON from file if path is given, otherwise treat as literal JSON }}
  if [[ -f "$json" ]]; then
    json=$(cat "$json")
  fi
  # {{ edit_1 end }}

  echo "$json" | jq -c '.[]' | while IFS= read -r item; do
    local path
    local content
    path=$(echo "$item" | jq -r '.path')
    content=$(echo "$item" | jq -r '.content // empty')

    # Determine if path is a directory or file
    if [[ -z "$content" ]]; then
      # Create directory, including parent directories if necessary
      mkdir -p "$base_path/$path"
    else
      # Create the parent directory if it does not exist
      mkdir -p "$(dirname "$base_path/$path")"

      # Create the file with the specified content
      echo -e "$content" >"$base_path/$path"
    fi
  done
}

# Ensure jq is installed
if ! command -v jq &>/dev/null; then
  echo "jq command not found. Please install jq."
  exit 1
fi

# Run the function with provided arguments
create_structure "$JSON_INPUT" "$TARGET_PATH"
