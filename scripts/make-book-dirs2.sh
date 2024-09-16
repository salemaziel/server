#!/bin/bash

# Iterate through all PDF and epub files in the current directory
for file in *.pdf *.epub; do
  # Extract the filename without the extension
  filename="${file%.*}"

  # Check if a directory with the filename exists, create it if not
  if [[ ! -d "$filename" ]]; then
    mkdir "$filename"
  fi

  # Move the file into the corresponding directory
  mv "$file" "$filename"
done
