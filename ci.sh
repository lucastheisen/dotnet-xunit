#!/bin/bash

set -e

echo -e "\n\n\nCI\n"

DIR=$(dirname "$(readlink -f "$0")")

"$DIR/build.sh"

PROJECTS=" \
  Pastdev.Dotnet.Xunit.Math.Test
  Pastdev.Dotnet.Xunit.Math.IntegrationTest
  " \
  "$DIR/test.sh"

"$DIR/release.sh"

echo -e "\nCI Done!\n"
