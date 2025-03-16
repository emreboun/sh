#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <operation> <file> [<content>]"
  exit 1
fi

operation="$1"
file="$2"
content="$3"

case "$operation" in
update)
  if [ -z "$content" ]; then
    echo "Update content is required"
    exit 1
  fi
  echo "$content" >"$file"
  ;;
append)
  if [ -z "$content" ]; then
    echo "Append content is required"
    exit 1
  fi
  echo "$content" >>"$file"
  ;;
prepend)
  if [ -z "$content" ]; then
    echo "Prepend content is required"
    exit 1
  fi
  {
    echo "$content"
    cat "$file"
  } >temp.txt && mv temp.txt "$file"
  ;;
delete)
  if [ -z "$content" ]; then
    echo "Delete pattern is required"
    exit 1
  fi
  sed -i "/$content/d" "$file"
  ;;
replace)
  if [ -z "$content" ]; then
    echo "Replace pattern is required"
    exit 1
  fi
  sed -i "s/$content/new_text/" "$file"
  ;;
*)
  echo "Invalid operation. Use update, append, prepend, delete, or replace."
  exit 1
  ;;
esac

echo "Operation $operation completed successfully."
