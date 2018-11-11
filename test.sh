#!/bin/bash

set -e

DIR=$(dirname "$(readlink -f "$0")")
TEST_ROOT_DIR="${TEST_ROOT_DIR:-test}"
TEST_RESULTS_DIR="${TEST_RESULTS_DIR:-$DIR/build/}"
PROJECT=${PROJECT:-Pastdev.Dotnet.Xunit.Math.Test}
PROJECT_RESULTS_FILE="$PROJECT.trx"

rm -f "$TEST_RESULTS_DIR/$PROJECT_RESULTS_FILE"

dotnet test \
    --logger "trx;LogFileName=$PROJECT_RESULTS_FILE" \
    --results-directory "$TEST_RESULTS_DIR" \
    "$TEST_ROOT_DIR/$PROJECT/$PROJECT.csproj"
