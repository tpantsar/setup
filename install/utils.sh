#!/bin/bash

# Source a script with warning on failure
run_source() {
  local script="$1"
  echo "==> sourcing $script"
  if ! source "$script"; then
    echo "WARN: $script failed; continuing"
  fi
}

# Execute a script with warning on failure
run_exec() {
  local script="$1"
  echo "==> running $script"
  if ! bash "$script"; then
    echo "WARN: $script failed; continuing"
  fi
}
