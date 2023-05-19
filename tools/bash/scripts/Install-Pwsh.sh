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

GithubOwner="PowerShell"
GithubRepo="PowerShell"
GithubUrl="https://api.github.com/repos/$GithubOwner/$GithubRepo/releases"

# Query Github API for PowerShell Core releases
GithubReleases=$(curl -s $GithubUrl | grep tag_name | cut -d '"' -f 4)
# Sort the releases by version number in descending order
GithubReleases=$(echo "$GithubReleases" | sort -rV)
# Get the hightes version number which is not a preview version and save it in a variable LatestVersion
LatestVersion=$(echo "$GithubReleases" | grep -v "preview" | head -n 1)

# Check if PowerShell Core is already installed
if [ -x "$(command -v pwsh)" ]; then
    CurrentPwshVersion=$(pwsh --version)
    echo "PowerShell Core is already installed in Version '($CurrentPwshVersion)'"
    echo "Latest version is '($LatestVersion)'"
    CleanedCurrentPwshVersion=$(echo "$CurrentPwshVersion" | tr -dc '0-9.')
    CleanedLatestVersion=$(echo "$LatestVersion" | tr -dc '0-9.')
    if [ "$CleanedCurrentPwshVersion" == "$CleanedLatestVersion" ]; then
        echo "PowerShell Core is already installed in the latest version"
        exit 0
    fi
    # If newer version available ask user if he wants to update PowerShell Core
    while true; do
        read -p "Do you want to update PowerShell Core? (y/n) " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit 0;;
            * ) echo "Please answer yes or no.";;
        esac
        VersionToInstall=$LatestVersion
    done
fi

if [ ! $VersionToInstall ]; then
    # Present the user with a list of available PowerShell Core versions
    echo "Available PowerShell Core versions:"
    for Release in $GithubReleases; do
        echo $Release
    done

    # Present user with choice of PowerShell Core versions
    while true; do
        read -p "Please select a PowerShell Core version: " Version
        if [[ $GithubReleases =~ (^|[[:space:]])"$VersionToInstall"($|[[:space:]]) ]]; then
            echo "You selected $VersionToInstall"
            break
        else
            echo "Invalid version. Please select a valid version."
        fi
    done
fi

# Get the download URL for the selected PowerShell Core version
DownloadUrl=$(curl -s $GithubUrl | grep -A 10 $VersionToInstall | grep "browser_download_url" | grep "deb_amd64.deb" | cut -d '"' -f 4)
# Download the selected PowerShell Core version to the current directory
DownloadedFile=$(basename $DownloadUrl)
echo "Downloading $DownloadedFile"
wget -q $DownloadUrl

# Install the downloaded package
sudo dpkg -i $DownloadedFile

# Resolve missing dependencies and finish the install (if necessary)
sudo apt-get install -f

# Check if PowerShell Core is installed
if [ ! "$(command -v pwsh)" ]; then
    echo "PowerShell Core failed to install"
    exit 1
fi
echo "PowerShell Core is installed"

echo "Done!"