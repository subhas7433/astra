#!/bin/bash

# Pre-build script to clean macOS resource fork files that interfere with Android Gradle
# Usage: ./scripts/build_android.sh [device-id]

set -e  # Exit on error

echo "🧹 Cleaning macOS resource fork files..."
find . -name "._*" -type f -delete 2>/dev/null || true

echo "🧹 Cleaning build directories..."
rm -rf build android/app/build android/.gradle || true

echo "📦 Running Flutter build..."
DEVICE_ID="${1:-emulator-5556}"

/Users/subhas/Work/flutter/bin/flutter run -d "$DEVICE_ID"
