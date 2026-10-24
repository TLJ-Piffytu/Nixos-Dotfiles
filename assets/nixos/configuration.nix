{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix 
    ];
  
  # BOOT --------------------------------------------------------------------------------
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NETWORKING --------------------------------------------------------------------------
  networking.hostName = "thinkpadt14"; # Define your hostname.
  networking.networkmanager.enable = true;

  # TIMEZONE & LOCALE -------------------------------------------------------------------
  time.timeZone = "Europe/Budapest";

  i18n.defaultLocale = "en_US.UTF-8";

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

  # INPUT -------------------------------------------------------------------------------
  programs.zsh.enable = true;
  console.keyMap = "hu";

  # SERVICES-----------------------------------------------------------------------------
  services.xserver.xkb = {
    layout = "hu";
    variant = "";
  };
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  
  # PROGRAMS-----------------------------------------------------------------------------
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # USER---------------------------------------------------------------------------------
  users.users."piffytu" = {
    isNormalUser = true;
    description = "Piffytu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  # PACKAGES-----------------------------------------------------------------------------
  fonts.packages = with pkgs; [
    corefonts
  ];

  environment.systemPackages = with pkgs; [
    # Desktop
    fastfetch
    brightnessctl
    wl-clipboard
    
    # Dev
    git
    helix
    tree-sitter

    # Misc
    curl
    wget
    unzip
    ripgrep
    fd

    # LSP
    lua-language-server
    jdk25
    jdt-language-server
    nodejs
    typescript-language-server
    prettier
  ];

  # OTHER--------------------------------------------------------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05"; 
}
