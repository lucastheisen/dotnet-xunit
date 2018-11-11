#!/bin/bash

set -e

DIR=$(dirname "$(readlink -f "$0")")

dotnet build --configuration Release "$DIR"
