#!/bin/bash

# Pre-build script with environment variables to prevent resource fork creation
# Usage: ./scripts/build_clean.sh [device-id]

set -e  # Exit on error

# Prevent macOS from creating ._ files
export COPYFILE_DISABLE=1
export COPY_EXTENDED_ATTRIBUTES_DISABLE=1

echo "🧹 Cleaning macOS resource fork files..."
find . -name "._*" -type f -delete 2>/dev/null || true

# Use dot_clean to merge resource forks
echo "🧹 Merging resource forks..."
dot_clean -m . 2>/dev/null || true

echo "🧹 Cleaning build directories..."
rm -rf build android/app/build android/.gradle ios/Pods ios/.symlinks ios/Podfile.lock || true

echo "📦 Running Flutter build with resource fork prevention..."
DEVICE_ID="${1:-emulator-5556}"

COPYFILE_DISABLE=1 COPY_EXTENDED_ATTRIBUTES_DISABLE=1 /Users/subhas/Work/flutter/bin/flutter run -d "$DEVICE_ID"
