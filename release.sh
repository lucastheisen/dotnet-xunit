#!/bin/bash

set -e

echo -e "\n\n\nCI Release\n"

DIR=$(dirname "$(readlink -f "$0")")
ARTIFACTS_DIR="${TEST_RESULTS_DIR:-$DIR/build}"
REMOTE_REPO_URL="${REMOTE_REPO_URL:-$(git remote get-url origin)}"
NUGET_API_KEY="${NUGET_API_KEY:+--api-key $NUGET_API_KEY}"
NUGET_SOURCE="${NUGET_SOURCE:+--source $NUGET_SOURCE}"

if dotnet tool list --tool-path . | grep nbgv > /dev/null 2>&1; then
  echo "Updating nbgv"
  dotnet tool update --tool-path . nbgv
else
  echo "Installing nbgv"
  dotnet tool install --tool-path . nbgv
fi

NUGET_VERSION=$(./nbgv get-version | grep "NuGet" | sed 's/NuGet.*:[[:space:]]*//')
echo "Version: [$NUGET_VERSION]"
GIT_TAG="v$NUGET_VERSION"
echo "Git tag: [$GIT_TAG]"

if git remote get-url __CI__; then
  git remote set-url __CI__ "$REMOTE_REPO_URL"
else
  git remote add __CI__ "$REMOTE_REPO_URL"
fi

git tag -am "Release $GIT_TAG" "$GIT_TAG"
git push __CI__ "$GIT_TAG"

rm -rf "$ARTIFACTS_DIR"/*.nupkg
dotnet pack \
  --configuration Release \
  --no-restore \
  --no-build \
  --include-symbols \
  --include-source \
  --output $ARTIFACTS_DIR

FAILED=0
for NUPKG in "$ARTIFACTS_DIR"/*.nupkg; do
  echo "Pushing $NUPKG"

  if [[ "$NUPKG" =~ symbols.nupkg$ ]]; then
    echo "Skipping symbols package [$NUPKG]"
    continue
  fi

  set +e
  dotnet nuget push $NUGET_API_KEY $NUGET_SOURCE $NUPKG
  EXIT_CODE=$?
  set -e

  if [ $EXIT_CODE != 0 ]; then
    FAILED=$EXIT_CODE
  fi
done

if [ 0 != $FAILED ]; then
  echo "Some push failed: $FAILED"
  exit $FAILED
fi

echo -e "\n\n\nCI Release Done!\n"
