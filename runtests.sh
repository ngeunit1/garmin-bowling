#!/usr/bin/env bash

output=$($1)
echo "$output"
if [[ $output == *"PASSED"* ]]; then
  exit 0
fi
exit 1