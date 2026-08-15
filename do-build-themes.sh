#!/usr/bin/env bash
set -euo pipefail

source ./env.sh
rm -rf build
./build-themes.py
