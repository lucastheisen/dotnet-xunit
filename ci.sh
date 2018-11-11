#!/bin/bash

set -e

echo -e "\n\n\nCI\n"

DIR=$(dirname "$(readlink -f "$0")")

"$DIR/build.sh"

PROJECTS=" \
  Pastdev.Dotnet.Xunit.Math  
  Pastdev.Dotnet.Xunit.Command  
  " \
  "$DIR/test.sh"

"$DIR/release.sh"
