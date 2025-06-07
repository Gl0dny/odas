#!/bin/bash

# ODAS (Open embeddeD Audition System) Installation Script
# ========================================================
#
# This script installs and builds ODAS.
# It automatically installs any missing tools or libraries using apt.
#
# Usage:
#   ./install.sh

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${GREEN}Starting ODAS installation...${NC}"

# Prevent running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}Please do not run this script as root${NC}"
    exit 1
fi

# Function to check and install a package if not present
install_if_missing() {
    PACKAGE=$1
    if ! dpkg -s "$PACKAGE" &> /dev/null; then
        echo -e "${YELLOW}Installing missing package: $PACKAGE${NC}"
        sudo apt-get install -y "$PACKAGE"
    else
        echo -e "${GREEN}Package $PACKAGE is already installed.${NC}"
    fi
}

# Function to check and install a tool if missing
install_tool_if_missing() {
    TOOL=$1
    PACKAGE=${2:-$1}
    if ! command -v "$TOOL" &> /dev/null; then
        echo -e "${YELLOW}Tool $TOOL is missing. Installing package: $PACKAGE${NC}"
        sudo apt-get install -y "$PACKAGE"
    else
        echo -e "${GREEN}Tool $TOOL is already installed.${NC}"
    fi
}

echo -e "${YELLOW}Updating package lists...${NC}"
sudo apt-get update

# Install required tools
echo -e "${YELLOW}Checking and installing required tools...${NC}"
install_tool_if_missing cmake
install_tool_if_missing make
install_tool_if_missing gcc
install_tool_if_missing git
install_tool_if_missing sudo

# Install required libraries
echo -e "${YELLOW}Checking and installing required libraries...${NC}"
install_if_missing libfftw3-dev
install_if_missing libasound2-dev
install_if_missing libconfig-dev
install_if_missing libpulse-dev

# Create build directory
echo -e "${YELLOW}Creating build directory...${NC}"
mkdir -p "$SCRIPT_DIR/build"
cd "$SCRIPT_DIR/build"

# Configure project with CMake
echo -e "${YELLOW}Configuring project with CMake...${NC}"
cmake ..

# Build
echo -e "${YELLOW}Building ODAS...${NC}"
make -j"$(nproc)"

# Create local bin directory
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Create symlinks
echo -e "${YELLOW}Creating symlinks in $LOCAL_BIN...${NC}"
BUILD_BIN="$SCRIPT_DIR/build/bin"

if [ ! -f "$BUILD_BIN/odaslive" ] || [ ! -f "$BUILD_BIN/odasserver" ]; then
    echo -e "${RED}Error: Executables not found in $BUILD_BIN${NC}"
    exit 1
fi

ln -sf "$BUILD_BIN/odaslive" "$LOCAL_BIN/odas"
ln -sf "$BUILD_BIN/odasserver" "$LOCAL_BIN/odasserver"

# Add ~/.local/bin to PATH if not already there
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    echo -e "${YELLOW}Adding $LOCAL_BIN to PATH in .bashrc${NC}"
    echo "export PATH=\"\$PATH:$LOCAL_BIN\"" >> "$HOME/.bashrc"
    echo -e "${YELLOW}Please restart your terminal or run 'source ~/.bashrc'${NC}"
fi

# Done
echo -e "${GREEN}ODAS installation completed successfully!${NC}"
echo -e "${YELLOW}You can now run:${NC}"
echo -e "  ${GREEN}odas -c config/odaslive/respeaker_4_mic_array.cfg${NC}"
echo -e "  ${GREEN}odasserver -c config/odasserver/respeaker_4_mic_array.cfg${NC}"