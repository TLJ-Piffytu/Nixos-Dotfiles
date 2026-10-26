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

  programs.yazi = {
    enable = true;
    plugins = with pkgs.yaziPlugins; {
      smart-enter.package = smart-enter;
    };
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
  ];


  # OTHER -----------------------------------------------------------------
  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.pointerCursor = {
    gtk.enable = true;  # Enable GTK support
    x11.enable = true;  # Enable X11 support
    name = "Vanilla-DMZ";  # Name of the cursor theme
    package = pkgs.vanilla-dmz;  # Package providing the cursor theme
    size = 32;  # Size of the cursor
  };

}
