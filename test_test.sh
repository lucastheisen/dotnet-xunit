#!/bin/bash


DIR=$(dirname "$(readlink -f "$0")")
TESTER="$DIR/test.sh"

PROJECT=Pastdev.Dotnet.Xunit.Math.IntegrationTest $TESTER

