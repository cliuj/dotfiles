{ config, pkgs, ... }:
let
  fonts = with pkgs; [
    font-awesome
    gohufont
    ibm-plex
    (nerdfonts.override {
      fonts = [
        "IBMPlexMono"
        "DejaVuSansMono"
        "Gohu"
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
    ];
    home = {
      username = user.name;
      homeDirectory = user.home;
      packages = with pkgs; [
        ripgrep
        fd
        sxiv
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

      sessionVariables = {
        SPLIT = "v"; # For nnn preview-tui
      };
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
      nnn = {
        enable = true;
        extraPackages = with pkgs; [
          exa
          tree
          ueberzug
        ];
        plugins = {
          mappings = {
            c = "fzcd";
            f = "finder";
            v = "imgview";
            p = "preview-tui";
          };
          src = (pkgs.fetchFromGitHub {
            owner = "jarun";
            repo = "nnn";
            rev = "3f58f6111c95a38f2bfbdde92c42bf54edeb5927"; # v4.5
            sha256 = "1jgc6ircamhr73sipcl8ckf3dwc264yx8qc2679k6sa6da0h0fmr";
            fetchSubmodules = true;
          }) + "/plugins";
        };
      };
      mpv = {
        enable = true;
      };
      fish = {
        enable = true;
        shellAbbrs = {
          hms = "home-manager switch";
          xrr = "xmonad --recompile && xmonad --restart";
          xmc = "vim ${config.home.homeDirectory}/.xmonad/xmonad.hs";
          xbc = "vim ${config.xdg.configHome}/xmobar/xmobarrc";
          nvc = "vim ${config.xdg.configHome}/nvim/lua/settings.lua";
          tl = "tmux list-sessions";
          ta = "tmux attach";
        };
        shellAliases = {
          t = "tmux";
          vol = "alsamixer";
          nnn = "nnn -e";
          home = "vim ${config.xdg.configHome}/nixpkgs/home.nix";
          suslock = "slock systemctl suspend -i";
          lock = "slock";
        };
      };
     tmux = {
        enable = true;
        baseIndex = 1;
        historyLimit = 10000;
        keyMode = "vi";
        shortcut = "space";
        extraConfig = ''
          # Set the prefix to Ctrl-Space
          unbind C-b
          set -g prefix C-Space
          bind a send-prefix

          set -g mouse on
          # Set vim-keys for copy and pasting
          bind p paste-buffer
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi y send-keys -X copy-selection
          bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

          # Set vim-keys for pane switching
          bind -n C-h select-pane -L
          bind -n C-j select-pane -D
          bind -n C-k select-pane -U
          bind -n C-l select-pane -R

          # Set vim-keys for resizing
          bind -n M-Up resize-pane -U 5
          bind -n M-Left resize-pane -L 5
          bind -n M-Down resize-pane -D 5
          bind -n M-Right resize-pane -R 5

          # Rebind split keys
          bind-key s split-window -v
          bind-key v split-window -h

          # Bind change window keys
          bind-key k previous-window
          bind-key j next-window

          # Bind change session-clients
          bind-key h switch-client -p
          bind-key l switch-client -n

          # Bind to R for quick config reload
          bind-key r 'source-file "${config.xdg.configHome}/tmux/tmux.conf" ; display-message "Reloaded ${config.xdg.configHome}/tmux/tmux.conf"'

          # Set timeout for <esc> to 0 for
          # nvim in tmux
          set -sg escape-time 0

          # Theme
          set -g status-bg black
          set -g status-fg white
        '';
      };
      home-manager.enable = true;
    };
  }
