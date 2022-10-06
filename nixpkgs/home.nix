{ config, pkgs, ... }:
let
  fonts = with pkgs; [
    # NOTE: run `fc-cache -f` once finished switching
    #       since it isn't done automatically
    font-awesome
    gohufont
    ibm-plex
    ubuntu_font_family
    (nerdfonts.override {
      fonts = [
        "IBMPlexMono"
        "DejaVuSansMono"
        "Gohu"
        "UbuntuMono"
        "Ubuntu"
      ];
    })
  ];

  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
    scheme-basic
    xetex
    memoir
    fontawesome5
    geometry
    anyfontsize
    framed
    titlesec
    plex
    enumitem
    latexmk;
  });
  user = {
    # Dynamically load the user.
    name = builtins.getEnv "USER";
    home = builtins.getEnv "HOME";
  };
in
  {
    nixpkgs.config.allowUnfree = true;
    imports = [
      ./nvim.nix
      ./x.nix
      ./tmux.nix
    ];
    home = {
      username = user.name;
      homeDirectory = user.home;
      packages = with pkgs; [
        ripgrep
        fd
        nsxiv
        youtube-dl
        maim
        nodejs
        tex
        zathura
        clang
        acpi
        kitty
        htop
        xsel

        # Misc
        discord
      ]
      ++ fonts;

      stateVersion = "22.05";
    };

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${config.home.homeDirectory}/desktop";
        documents = "${config.home.homeDirectory}/documents";
        download = "${config.home.homeDirectory}/downloads";
        music = "${config.home.homeDirectory}/music";
        pictures = "${config.home.homeDirectory}/pictures";
        publicShare = "${config.home.homeDirectory}/public";
        templates = "${config.home.homeDirectory}/templates";
        videos = "${config.home.homeDirectory}/videos";
      };
    };

    programs = {
      firefox = {
        enable = true;
      };
      rofi = {
        enable = true;
      };
      bat = {
        enable = true;
      };
      fzf = {
        enable = true;
      };
      mpv = {
        enable = true;
      };
      fish = {
        enable = true;
        shellAbbrs = {
          hms = "home-manager switch";
          nvc = "vim ${config.xdg.configHome}/nvim/lua/settings.lua";
        };
        shellAliases = {
          vol = "alsamixer";
          home = "vim ${config.xdg.configHome}/nixpkgs/home.nix";
          sxiv = "nsxiv";
        };
      };
      home-manager.enable = true;
    };
  }
