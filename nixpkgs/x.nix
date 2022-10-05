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

  xsession = {
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };

  services = {
    picom = {
      enable = true;
    };
  };
}
