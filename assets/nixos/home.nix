{ pkgs, inputs, ... }:

{
  home.username = "piffytu";
  home.homeDirectory = "/home/piffytu";

  home.stateVersion = "26.05";

  imports = [
    inputs.noctalia.homeModules.default
  ];

  # PROGRAMS --------------------------------------------------------------
  programs.noctalia = {
    enable = true;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = false;
      };
    };
  };

  programs.zsh = {
    enable = true;
    initContent = builtins.readFile ./dotfiles/zshrc;
  };

  programs.obs-studio = {
    enable = true;
  };
  
  # PACKAGES --------------------------------------------------------------
  home.packages = with pkgs; [
    # Desktop
    mpv
    mpvpaper
    waypaper
    
    # Apps
    kitty
    kew
    btop
    prismlauncher
    helix
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    kdePackages.dolphin
  ];


  # OTHER -----------------------------------------------------------------
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
