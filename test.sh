#!/bin/bash

set -e

echo -e "\n\n\nCI Test\n"

DIR=$(dirname "$(readlink -f "$0")")
TEST_ROOT_DIR="${TEST_ROOT_DIR:-test}"
TEST_RESULTS_DIR="${TEST_RESULTS_DIR:-$DIR/build/}"
PROJECTS=${PROJECTS:-Pastdev.Dotnet.Xunit.Math.Test}

FAILED=0
for PROJECT in $PROJECTS; do
  PROJECT_RESULTS_FILE="$PROJECT.trx"

  rm -f "$TEST_RESULTS_DIR/$PROJECT_RESULTS_FILE"

  set +e
  dotnet test \
    --configuration Release \
    --no-restore \
    --no-build \
    --logger "trx;LogFileName=$PROJECT_RESULTS_FILE" \
    --results-directory "$TEST_RESULTS_DIR" \
    "$TEST_ROOT_DIR/$PROJECT/$PROJECT.csproj"
  EXIT_CODE=$?
  set -e

  if [ $EXIT_CODE != 0 ]; then
    FAILED=$EXIT_CODE
  fi
done

if [ 0 != $FAILED ]; then
  echo "Some tests failed: $FAILED"
  exit $FAILED
fi

echo "Done!"
