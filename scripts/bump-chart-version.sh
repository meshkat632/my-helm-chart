#!/bin/bash

# Default values
chart_directory="."
new_version="1.0.0"
postfix=""


# Parse command line options
while [ $# -gt 0 ]; do
  case "$1" in
    --dir)
      shift
      chart_directory="$1"
      ;;
    --version)
      shift
      new_version="$1"
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# Check if the Chart.yaml file exists
if [ ! -f "$chart_directory/Chart.yaml" ]; then
  echo "Chart.yaml not found in the $chart_directory directory."
  exit 1
fi

current_version=$(yq eval '.version' "$chart_directory/Chart.yaml")
echo "Current version: $current_version"
IFS='.' read -ra version_parts <<< "$current_version"
new_version="${version_parts[0]}.${version_parts[1]}.$((version_parts[2]+1))"
echo "New version: $new_version"
yq eval -i ".version = \"$new_version$postfix\"" "$chart_directory/Chart.yaml"
echo "Version updated to $new_version$postfix in $chart_directory/Chart.yaml"
