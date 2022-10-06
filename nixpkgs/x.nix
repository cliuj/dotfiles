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
      shellAbbrs = {
          xrr = "xmonad --recompile && xmonad --restart";
          xmc = "vim ${config.home.homeDirectory}/.xmonad/xmonad.hs";
          xbc = "vim ${config.xdg.configHome}/xmobar/xmobarrc";
      };
    };
  };

  services = {
    picom = {
      enable = true;
      shadow = false;
      # Rounded corners sometimes interferes with the WM's border, thus
      # opacity is used as an indicator for focused window instead of
      # border
      inactiveOpacity = "0.93";
      extraOptions = ''
        corner-radius = 20;
        rounded-corners-exclude = [
          "class_g = 'xmobar'",
          "window_type = 'dock'"
        ];
      '';
      vSync = true;
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
