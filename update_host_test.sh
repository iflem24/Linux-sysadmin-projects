#!/bin/bash

# Define the hosts file path
hosts_file="/etc/ansible/hosts"

# Define the section header
section="[new-installs]"

# Function to validate IP address
validate_ip() {
    local ip=$1
    # Using grep with regex to validate IP address format
    if echo "$ip" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
        return 0
    else
        return 1
    fi
}

# Prompt user for IP address and validate it
while true; do
    read -p "Enter the IP address to add to [$section]: " ip_address
    if validate_ip "$ip_address"; then
        break
    else
        echo "Invalid IP address format. Please enter a valid IP address."
    fi
done

# Check if the section exists in the hosts file
if grep -q "^\[$section\]$" "$hosts_file"; then
    # Section exists, replace or add the IP address
    if grep -q "^\[$section\]$" "$hosts_file"; then
        # Remove existing IP address if present
        sed -i "/^\[$section\]$/,$ {/^[0-9]/d}" "$hosts_file"
    fi
    # Append the IP address to the section
    echo "$ip_address" >> "$hosts_file"
else
    # Section does not exist, add the section header and IP address
    echo -e "\n[$section]" >> "$hosts_file"
    echo "$ip_address" >> "$hosts_file"
fi

echo "IP address $ip_address added to [$section] in $hosts_file"
