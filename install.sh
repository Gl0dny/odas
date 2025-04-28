#!/bin/bash

# ODAS Installation Script
# This script installs ODAS and its dependencies

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${GREEN}Starting ODAS installation...${NC}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}Please do not run this script as root${NC}"
    exit 1
fi

# Check for required tools
echo -e "${YELLOW}Checking for required tools...${NC}"
command -v cmake >/dev/null 2>&1 || { echo -e "${RED}cmake is required but not installed.${NC}"; exit 1; }
command -v make >/dev/null 2>&1 || { echo -e "${RED}make is required but not installed.${NC}"; exit 1; }
command -v gcc >/dev/null 2>&1 || { echo -e "${RED}gcc is required but not installed.${NC}"; exit 1; }

# Create build directory
echo -e "${YELLOW}Creating build directory...${NC}"
mkdir -p "$SCRIPT_DIR/build"
cd "$SCRIPT_DIR/build"

# Configure with CMake
echo -e "${YELLOW}Configuring with CMake...${NC}"
cmake ..

# Build
echo -e "${YELLOW}Building ODAS...${NC}"
make -j$(nproc)

# Create local bin directory if it doesn't exist
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Create symlinks for the executables
echo -e "${YELLOW}Creating symlinks for executables...${NC}"
BUILD_BIN="$SCRIPT_DIR/build/bin"

# Check if executables exist
if [ ! -f "$BUILD_BIN/odaslive" ] || [ ! -f "$BUILD_BIN/odasserver" ]; then
    echo -e "${RED}Error: ODAS executables not found in $BUILD_BIN${NC}"
    echo -e "${YELLOW}Please check the build directory and try again${NC}"
    exit 1
fi

# Create symlinks in user's local bin directory
ln -sf "$BUILD_BIN/odaslive" "$LOCAL_BIN/odaslive"
ln -sf "$BUILD_BIN/odasserver" "$LOCAL_BIN/odasserver"

# Add local bin to PATH if not already present
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    echo -e "${YELLOW}Adding $LOCAL_BIN to PATH in .bashrc${NC}"
    echo "export PATH=\"\$PATH:$LOCAL_BIN\"" >> "$HOME/.bashrc"
    echo -e "${YELLOW}Please restart your terminal or run 'source ~/.bashrc' to update PATH${NC}"
fi

echo -e "${GREEN}ODAS installation completed successfully!${NC}"
echo -e "${YELLOW}You can now run odaslive or odasserver from anywhere${NC}"
echo -e "${YELLOW}Executables are available in $LOCAL_BIN${NC}"