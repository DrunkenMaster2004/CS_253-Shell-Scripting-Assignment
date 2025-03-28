#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file1> <file2>"
    exit 1
fi

file1=$1
file2=$2

# Check if both files exist
if [ ! -f "$file1" ]; then
    echo "Files not found , Usage: $0 <file1> <file2>"
    exit 1
fi

if [ ! -f "$file2" ]; then
    echo "Usage: $0 <file1> <file2>"
    exit 1
fi

# Function to find common prefix length of two strings
find_common_prefix_length() {
    local str1="$1"
    local str2="$2"
    
    # If either string is empty, return 0
    if [ -z "$str1" ] || [ -z "$str2" ]; then
        echo 0
        return
    fi
    
    local len=0
    local min_len=$(( ${#str1} < ${#str2} ? ${#str1} : ${#str2} ))
    
    for (( i=0; i<min_len; i++ )); do
        if [ "${str1:$i:1}" = "${str2:$i:1}" ]; then
            len=$((len + 1))
        else
            break
        fi
    done
    
    echo $len
}

# Process each line of both files
exec 3< "$file1"
exec 4< "$file2"

# Output file
output_file="common_prefixes.txt"
> "$output_file"  # Clear the output file

while true; do
    # Read lines from both files
    read -r line1 <&3 || line1=""
    read -r line2 <&4 || line2=""
    
    # Break if both files have ended
    if [ -z "$line1" ] && [ -z "$line2" ]; then
        break
    fi
    
    # Find common prefix length
    prefix_length=$(find_common_prefix_length "$line1" "$line2")
    
    # Write to output file
    echo "$prefix_length" >> "$output_file"
done

# Close file descriptors
exec 3<&-
exec 4<&-

echo "Common prefix counts have been written to $output_file"
