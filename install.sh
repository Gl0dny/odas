#!/bin/bash

# ODAS Installation Script
# This script installs ODAS and its dependencies

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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
mkdir -p build
cd build

# Configure with CMake
echo -e "${YELLOW}Configuring with CMake...${NC}"
cmake ..

# Build
echo -e "${YELLOW}Building ODAS...${NC}"
make -j$(nproc)

# Install
echo -e "${YELLOW}Installing ODAS...${NC}"
sudo make install

# Create symlinks for convenience
echo -e "${YELLOW}Creating symlinks...${NC}"
sudo ln -sf /usr/local/bin/odaslive /usr/bin/odaslive
sudo ln -sf /usr/local/bin/odasstudio /usr/bin/odasstudio

echo -e "${GREEN}ODAS installation completed successfully!${NC}"
echo -e "${YELLOW}You can now run odaslive or odasstudio from anywhere${NC}" 