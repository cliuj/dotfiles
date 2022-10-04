/**
 * About: Common configuration for linux-based systems
 * Usage:
 *    1) Import this file into your "/etc/nixos/configuration.nix"
 */

{ config, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  programs = {
    fish.enable = true;
    git.enable = true;
    neovim.enable = true;
  };

  networking = {
    networkmanager.enable = true;
  };

  security = {
    doas = {
      enable = true;
      extraRules = [
        { groups = [ "wheel" ]; keepEnv = true; persist = true; }
      ];
    };
    # No reason to keep sudo if we're using doas
    sudo.enable = false;
  };

  # Disable sleep on laptop lid close
  services = {
    logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
    };

    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      layout = "us";
      xkbOptions = "ctrl:nocaps";
      libinput.enable = true;
    };

    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };

  # Audio needs to be grouped together
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
