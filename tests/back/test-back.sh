#!/bin/sh

echo "---- Results: ----"
if [ "one" = "one" ]; then
  echo "[√] PASS"
  exit 0
else
  echo "[x] FAIL"
  exit 1
fi