#!/bin/bash

# Prompt user for input
read -p "Enter the file name containing the list of hosts: " file_name
read -p "Enter the number of ping packets to send: " packet_count
read -p "Enter the time interval between ping packets (in seconds): " interval

# Get timestamp for log file
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Create log file
log_file="ping_log_${timestamp}.txt"
touch $log_file

# Loop through each host in file and ping it
while read host; do
  # Ping host and get packet statistics
  ping_result=$(ping -c $packet_count -i $interval $host)
  packet_loss=$(echo "$ping_result" | awk '/packet loss/{print $6}' | cut -d "%" -f 1)
  packet_loss=${packet_loss:-0} # handle case where packet loss is not found
  packet_received=$(($packet_count - $packet_loss))

  # Write result to console and log file
  if [[ $packet_loss -eq 0 ]]; then
    echo "$host is up"
    echo "${timestamp},${host},${packet_count},${packet_received},0%" >> $log_file
  else
    echo "$host is down"
    echo "${timestamp},${host},${packet_count},${packet_received},${packet_loss}%" >> $log_file
  fi
done < $file_name

echo "Results logged to $log_file"