# Nixos-Dotfiles
## Introduction
My NixOS configuration made for personal use.

## Installation
### Install NixOS
The easiest way to install NixOS is to use the graphical iso.
**When installing NixOS through the graphical iso make sure to choose no window manager / no desktop enviroment!**
### Edit configuration.nix
Once installed edit your `/etc/nixos/configuration.nix` and add `git` to your `environment.systemPackages`:
``` nix
  environment.systemPackages = with pkgs; [    
    git
    helix
  ];
```
You can also add an editor of your choice if you don't like nano.
### Rebuild the system
Then rebuild the system:
``` bash
  sudo nixos-rebuild switch
```
Once it's done `reboot` into the new generation.
### Clone the repo
Clone this repo using `git` and `cd` into it:
``` bash
  git clone github.com/TLJ-Piffytu/Nixos-Dotfiles
  cd Nixos-Dotfiles
```
### Edit
Before you continue the installation you have to make some changes.

First edit `./assets/nixos/configuration.nix`:
``` bash
  hx assets/nixos/configuration.nix
```
Then change your locale, hostname and user settings:
``` nix
  ...
  
  # hostname
  networking.hostName = "<your hostname>";.
  networking.networkmanager.enable = true;
  
  # locale settings
  time.timeZone = "<Continent/City>";

  i18n.defaultLocale = "<Locale>";

  # Optional
  # these are just so my locales show up Hungarian
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };

  ...

  # user settings
  users.users."<your user>" = {
    isNormalUser = true;
    description = "<your user or name>";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  ...
```
> `extraLocaleSettings` is optional, you can delete it.
> `user.user."<your user>"` must be the user your created during installation
Next open `./assets/nixos/flake.nix`:
``` bash
  hx assets/nixos/flake.nix
```
Change `username`, `hostname` to your username and hostname
``` nix
  ...
  
  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "<your user>";
      hostname = "<your hostname>";
    in
    {
    ...
    }
  ...
```
Finally, edit `./assets/nixos/home.nix/`:
``` bash
  hx assets/nixos/home.nix
```
And change `username` and `homeDirectory`:
``` nix
{ pkgs, inputs, ... }:

{
  home.username = "<your user>";
  home.homeDirectory = "/home/<your user>";

  home.stateVersion = "26.05";

  imports = [
    inputs.noctalia.homeModules.default
  ];

  ...
}
```
