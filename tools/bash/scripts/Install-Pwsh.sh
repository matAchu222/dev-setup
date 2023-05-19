#!/bin/bash
# Set bash 'strict mode'
# See here for details and tipps: http://redsymbol.net/articles/unofficial-bash-strict-mode/

# Stop on error
set -e
# Stop on undefined variable
set -u
# Stop on error in pipeline
set -o pipefail
# Set IFS to only use newline and tab as delimiters
IFS=$'\n\t'

# Start of main script

# This bash scripts checks if PowerShell Core is installed on an Ubuntu system and if not, installs it
# It is based on the official PowerShell Core installation script for Linux. See here for details:
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux

# Check if this script is run within bash and Ubuntu
if [ ! "$(uname -r)" ]; then
    echo "This script must be run within Ubuntu"
    exit 1
fi
echo "This script is run within Ubuntu"

# Check if PowerShell Core is already installed
if [ -x "$(command -v pwsh)" ]; then
    echo "PowerShell Core is already installed"
    exit 0
fi
echo "PowerShell Core is not installed"

GithubOwner="PowerShell"
GithubRepo="PowerShell"
GithubUrl="https://api.github.com/repos/$GithubOwner/$GithubRepo/releases"

# Query Github API for PowerShell Core releases
GithubReleases=$(curl -s $GithubUrl | grep tag_name | cut -d '"' -f 4)

# Save this in a variable GithubReleases and use it to present the user with a list of available PowerShell Core versions
echo "Available PowerShell Core versions:"
for Release in $GithubReleases; do
    echo $Release
done

# Present user with choice of PowerShell Core versions
while true; do
    read -p "Please select a PowerShell Core version: " Version
    if [[ $GithubReleases =~ (^|[[:space:]])"$Version"($|[[:space:]]) ]]; then
        echo "You selected $Version"
        break
    else
        echo "Invalid version. Please select a valid version."
    fi
done

# Get the download URL for the selected PowerShell Core version
DownloadUrl=$(curl -s $GithubUrl | grep -A 10 $Version | grep "browser_download_url" | grep "deb_amd64.deb" | cut -d '"' -f 4)
# Download the selected PowerShell Core version to the current directory
DownloadedFile=$(basename $DownloadUrl)
echo "Downloading $DownloadedFile"
wget -q $DownloadUrl

# Install the downloaded package
sudo dpkg -i $DownloadedFile

# Resolve missing dependencies and finish the install (if necessary)
sudo apt-get install -f

echo "Done!"