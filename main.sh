#!/bin/bash

# Function to log a message with timestamp
log_message() {
    local message="$1"
    local log_file="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "> $timestamp - $message" >> "$log_file"
}

# Check if the correct number of arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <input_file> <output_file> <log_timestamp_file>"
    exit 1
fi

input_file="$1"
output_file="$2"
log_timestamp_file="$3"

# Clear the log timestamp file
> "$log_timestamp_file"

# Check if input file exists and is not empty
if [ ! -f "$input_file" ]; then
    log_message "Input file does not exist" "$log_timestamp_file"
    echo "Error: Input file '$input_file' does not exist."
    exit 1
elif [ ! -s "$input_file" ]; then
    log_message "Input file is empty" "$log_timestamp_file"
    echo "Error: Input file '$input_file' is empty."
    exit 1
else
    log_message "Input file exists" "$log_timestamp_file"
fi

# Clear the output file
> "$output_file"

# Task (a): Extract unique IP addresses
echo "Unique IP Addresses:" >> "$output_file"
awk -F, 'NR>1 {print $1}' "$input_file" | sort -u >> "$output_file"
echo "" >> "$output_file"
log_message "Unique IP extraction completed" "$log_timestamp_file"

# Task (b): Identify top 3 HTTP methods
echo "Top 3 HTTP Methods:" >> "$output_file"
awk -F, 'NR>1 {count[$3]++} END {for (method in count) print count[method], method}' "$input_file" |
sort -nr | head -3 | while read count method; do
    echo "$method: $count" >> "$output_file"
done
echo "" >> "$output_file"
log_message "Top 3 HTTP methods identified" "$log_timestamp_file"

# Task (c): Find total requests by hour
echo "Hourly Request Count:" >> "$output_file"
awk -F, 'NR>1 {split($2, t, " "); split(t[2], h, ":"); count[h[1]]++} 
END {for (i=0; i<24; i++) printf "Hour %d: %d requests\n", i, count[i]}' "$input_file" >> "$output_file"

log_message "Hourly request count completed" "$log_timestamp_file"
log_message "Script execution completed" "$log_timestamp_file"

echo "Analysis completed. Results saved to '$output_file' and logs to '$log_timestamp_file'."

