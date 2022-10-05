{ config, pkgs, home, ... }:

{
  home = {

    file = {
      ".xinitrc".text = ''
        picom -b
        exec xmonad
      '';
    };

    packages = with pkgs; [
      arandr
      xmobar
      xwallpaper
      yaru-theme
    ];
  };

  programs = {
    fish = {
      shellAliases = {
        suslock = "betterlockscreen -s";
        lock = "betterlockscreen -l";
      };
    };
  };

  services = {
    picom = {
      enable = true;
    };
    betterlockscreen = {
      enable = true;
    };
  };

  xsession = {
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };

}
