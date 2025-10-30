#!/bin/bash
# Exit on error
set -e

# Define the Flutter version and download URL
FLUTTER_VERSION="3.35.7"
FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_PATH="$HOME/flutter"

# Check if Flutter is installed, if not, download and install it
if ! command -v flutter &> /dev/null
then
    echo "Flutter SDK not found. Downloading and installing version ${FLUTTER_VERSION}..."
    mkdir -p "$HOME"
    wget -qO flutter-sdk.tar.xz "$FLUTTER_SDK_URL"
    tar -xf flutter-sdk.tar.xz -C "$HOME"
    # Add Flutter to the PATH for the current script execution
    export PATH="$FLUTTER_PATH/bin:$PATH"
else
    echo "Flutter is already installed."
fi

# Verify the Flutter installation
echo "Verifying Flutter installation..."
flutter doctor

# Install project dependencies
echo "Installing project dependencies..."
flutter pub get

# Build the Flutter web application
echo "Building the web application for production..."
flutter build web

echo "Build script finished successfully."
