#!/usr/bin/env bash
set -euo pipefail

HOME_DIR="$HOME"
NIXOS_DIR="/etc/nixos/"

DOTCONFIG_FILES=(
  "kitty/"
  "noctalia/"
  "helix/"
  "hypr/"
  "yazi/"
)

DOTLOCAL_FILES=(
  "bin/fetch"
)

NIXOS_FILES=(
  "configuration.nix"
  "flake.nix"
  "home.nix"
  "dotfiles/"
)

# Check for root
if [[ "$EUID" -eq 0 ]]; then
    echo "Please run this script as your normal user, without sudo." >&2
    exit 1
fi

echo "Getting directories..."
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"


# Directory containing this script
print_dir() {
  printf '* Dir: %s=%s\n' "$1" "$2"
}

# Source and Destination files
echo ""
echo "Source Directories: "
NIXOS_SRC="$NIXOS_DIR"
print_dir "NIXOS_SRC" "$NIXOS_SRC"
DOTCONFIG_SRC="$HOME_DIR/.config/"
print_dir "DOTCONFIG_SRC" "$DOTCONFIG_SRC"
DOTLOCAL_SRC="$HOME_DIR/.local/"
print_dir "DOTLOCAL_SRC" "$DOTLOCAL_SRC"

echo ""
echo "Destination Directories: "
NIXOS_DST="$SCRIPT_DIR/assets/nixos/"
print_dir "NIXOS_DST" "$NIXOS_DST"
DOTCONFIG_DST="$SCRIPT_DIR/assets/dotconfig"
print_dir "DOTCONFIG_DST" "$DOTCONFIG_DST"
DOTLOCAL_DST="$SCRIPT_DIR/assets/dotlocal"
print_dir "DOTLOCAL_DST" "$DOTLOCAL_DST"

echo ""
echo "Selected Files: "

print_selected() {
  printf '* To %s from %s\n' "$1" "$2"
}

echo "DOTCONFIG"
# .config files
for file in "${DOTCONFIG_FILES[@]}"; do
    print_selected $DOTCONFIG_DST "$DOTCONFIG_SRC$file"
done

echo ""
echo "DOTLOCAL"
# .local files
for file in "${DOTLOCAL_FILES[@]}"; do
    print_selected $DOTLOCAL_DST "$DOTLOCAL_SRC$file"
done

echo ""
echo "NIXOS"
# nixos files
for file in "${NIXOS_FILES[@]}"; do
    print_selected $NIXOS_DST "$NIXOS_SRC$file"
done

# Wait for user response
echo ""
echo "Please check the source and destination directories. Only continue if they are correct!"
read -rp "Continue with installation? [y/N] " CONFIRM

if [[ "$CONFIRM" != [yY] ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Copying
echo ""
echo "Copying Files and Directories..."
echo ""

print_copy() {
  printf '* Copied %s to %s successfully\n' "$1" "$2"
}

print_skip() {
  printf '! Skipped %s: File not found\n' "$1"
}

echo "Copying .config"
for file in "${DOTCONFIG_FILES[@]}"; do
  SRC="$DOTCONFIG_SRC$file"
  if [[ -e $SRC ]]; then
    cp -r "$SRC" "$DOTCONFIG_DST"
    print_copy "$SRC" "$DOTCONFIG_DST"
  else
    print_skip "$SRC"
  fi
done

echo "Copying .local"
for file in "${DOTLOCAL_FILES[@]}"; do
  SRC="$DOTLOCAL_SRC$file"
  if [[ -e $SRC ]]; then
    cp -r "$SRC" "$DOTLOCAL_DST"
    print_copy "$SRC" "$DOTLOCAL_DST"
  else
    print_skip "$SRC"
  fi
done

echo "Copying nixos, may need elevated permissions"
for file in "${NIXOS_FILES[@]}"; do
  SRC="$NIXOS_SRC$file"
  if [[ -e $SRC ]]; then
    sudo cp -r "$SRC" "$NIXOS_DST"
    print_copy "$SRC" "$NIXOS_DST"
  else
    print_skip "$SRC"
  fi
done
