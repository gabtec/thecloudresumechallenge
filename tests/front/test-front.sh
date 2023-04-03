#!/bin/sh

fileContent=$(cat ./website/index.html | grep h4 | xargs)

expected=$(echo "<h4>The Cloud Resume Challenge</h4> <h4>Number of page visits: <span id="vcounter">loading...</span></h4>" | xargs)

# echo $fileContent

echo "--- Results: ---"
if [ "$fileContent" = "$expected" ]; then
  echo "[√] PASS"
  exit 0
else
  echo "[x] FAIL"
  exit 1
fi