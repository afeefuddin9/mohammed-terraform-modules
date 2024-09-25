#!/bin/bash

# Define the base directory
base_dir="/c/Users/7000036986/Desktop/mohammed-terraform-modules/Terraform-Modules"

# Find and delete all .git directories within the base directory
find "$base_dir" -type d -name ".git*" -exec rm -rf {} +

# Find and delete all .terraform* directories or files within the base directory
find "$base_dir" -name ".terraform*" -exec rm -rf {} +

# Output confirmation message for each deleted .git and .terraform* directory or file
echo "Deleted the following .git directories:"
find "$base_dir" -type d -name ".git"

echo "Deleted the following .terraform* directories or files:"
find "$base_dir" -name ".terraform*"

