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
