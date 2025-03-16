#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <alias_name> <path_to_sh_file>"
  exit 1
fi

# Assign arguments to variables
alias_name="$1"
sh_file_path="$2"
bash_aliases_file="$HOME/.bash_aliases"

# Validate if the .bash_aliases file exists, create if it does not
if [ ! -f "$bash_aliases_file" ]; then
  touch "$bash_aliases_file"
fi

# Check if alias already exists in .bash_aliases
if grep -q "alias $alias_name=" "$bash_aliases_file"; then
  echo "Alias '$alias_name' already exists in $bash_aliases_file"
  exit 1
fi

# Add the alias to .bash_aliases
echo "alias $alias_name='$sh_file_path'" >>"$bash_aliases_file"

# Inform the user
echo "Alias '$alias_name' added to $bash_aliases_file"

# Optionally, reload the bash configuration to apply changes immediately
# source "$bash_aliases_file"
