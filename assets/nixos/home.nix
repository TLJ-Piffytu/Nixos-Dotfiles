{ pkgs, inputs, ... }:

{
  home.username = "piffytu";
  home.homeDirectory = "/home/piffytu";

  home.stateVersion = "26.05";

  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings = { # This may also be a string or path to a .toml file.
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
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
