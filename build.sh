#!/bin/bash

set -e

echo -e "\n\n\nCI Build\n"

DIR=$(dirname "$(readlink -f "$0")")

dotnet build --configuration Release "$DIR"

echo -e "\n\n\nCI Build Done!\n"
