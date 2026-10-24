# Nixos-Dotfiles
## Introduction
My NixOS configuration made for personal use.

## Installation
### Install NixOS
The easiest way to install NixOS is to use the graphical iso.
**When installing NixOS through the graphical iso make sure to choose no window manager / no desktop enviroment!**
### Edit configuration.nix
Once installed edit your `/etc/nixos/configuration.nix` and add `git` to your `environment.systemPackages`:
```
  environment.systemPackages = with pkgs; [    
    git
    helix
  ];
```
You can also add an editor of your choice if you don't like nano.
### Rebuild the system
Then rebuild the system:
```
  sudo nixos-rebuild switch
```
Once it's done `reboot` into the new generation.
### Clone the repo
Clone this repo using `git` and `cd` into it:
```
  git clone github.com/TLJ-Piffytu/Nixos-Dotfiles
  cd Nixos-Dotfiles
```
