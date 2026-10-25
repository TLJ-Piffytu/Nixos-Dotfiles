#!/usr/bin/env bash
set -euo pipefail

# DEBUG VARIABLES
# DO NOT CHANGE
HOME_DST="$HOME"
NIXOS_DST="/etc/nixos"

# Check for root
if [[ "$EUID" -eq 0 ]]; then
    echo "Please run this script as your normal user, without sudo." >&2
    exit 1
fi

# Directory containing this script
echo "Getting Directories..."
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Source and Destination files
print_dir() {
  printf '* Dir: %s=%s\n' "$1" "$2"
}

echo ""
echo "Source Directories: "
ASSETS="$SCRIPT_DIR/assets"
print_dir "ASSETS" "$ASSETS"
NIXOS_SRC="$ASSETS/nixos"
print_dir "NIXOS_SRC" "$NIXOS_SRC"
DOTCONFIG_SRC="$ASSETS/dotconfig"
print_dir "DOTCONFIG_SRC" "$DOTCONFIG_SRC"
DOTLOCAL_SRC="$ASSETS/dotlocal"
print_dir "DOTLOCAL_SRC" "$DOTLOCAL_SRC"

echo ""
echo "Destination Directories: "
print_dir "NIXOS_DST" "$NIXOS_DST"
DOTCONFIG_DST="$HOME_DST/.config"
print_dir "DOTCONFIG_DST" "$DOTCONFIG_DST"
DOTLOCAL_DST="$HOME_DST/.local"
print_dir "DOTLOCAL_DST" "$DOTLOCAL_DST"

if [[ -f "$SCRIPT_DIR/.done" ]]; then
    printf "\nInstalling flake.nix and home.nix..."

    sudo mv "$NIXOS_DST/DIS_flake.DIS_nix" "$NIXOS_DST/flake.nix"
    sudo mv "$NIXOS_DST/DIS_flake.DIS_nix" "$NIXOS_DST/flake.nix"

    echo "Done!"
    echo ""
    echo "Run 'nixos-rebuild switch' again!"
fi

# Validate Sources
for dir in "$NIXOS_SRC" "$DOTCONFIG_SRC" "$DOTLOCAL_SRC"; do
    if [[ ! -d "$dir" ]]; then
        printf 'Error: Source directory not found: %s\n' "$dir" >&2
        exit 1
    fi
done

# Wait for user response
echo ""
echo "Please check the source and destination directories. Only continue if they are correct!"
read -rp "Continue with installation? [y/N] " CONFIRM

if [[ "$CONFIRM" != [yY] ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Installation
echo ""
echo "Starting installation..."
echo ""

# Install non-privileged files first
echo "Installing user files..."

print_install() {
  printf '* Installing assets from %s to %s\n' "$1" "$2"
}

mkdir -p "$DOTLOCAL_DST" "$DOTCONFIG_DST"

print_install "$DOTLOCAL_SRC" "$DOTLOCAL_DST"
cp -a "$DOTLOCAL_SRC/." "$DOTLOCAL_DST/"

print_install "$DOTCONFIG_SRC" "$DOTCONFIG_DST"
cp -a "$DOTCONFIG_SRC/." "$DOTCONFIG_DST/"

# Install nixos config files
echo ""
echo "Installing system files..."
echo "* This may require elevated privilages!"

sudo mkdir -p "$NIXOS_DST"

print_install "$NIXOS_SRC" "$NIXOS_DST"
sudo cp -a "$NIXOS_SRC/." "$NIXOS_DST/"
echo "* Fixing ownership"
sudo chown root:root -R "$NIXOS_DST/"

printf "* Disabling %s and %s\n" "$NIXOS_DST/flake.nix" "$NIXOS_DST/home.nix"
sudo mv "$NIXOS_DST/flake.nix" "$NIXOS_DST/DIS_flake.DIS_nix"
sudo mv "$NIXOS_DST/home.nix" "$NIXOS_DST/DIS_home.DIS_nix"

touch "$SCRIPT_DIR/.done" 

echo "Done!"
echo ""
echo "Run 'nixos-rebuild switch' then rerun this script!"
