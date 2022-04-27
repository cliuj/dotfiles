{ config, pkgs, ... }:
let
  # Vim theme
  vim-dark-meadow = pkgs.vimUtils.buildVimPlugin {
    name = "vim-dark-meadow";
    src = pkgs.fetchFromGitHub {
      owner = "cliuj";
      repo = "vim-dark-meadow";
      rev = "a37ab0d045e315521c94bd19255c4f4c2a7825fe";
      sha256 = "1xlm8yshh6jp2kjkgyc0mkzbd3w9sylfpl132yyvdqy77ahsf5py";
    };
  };

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
  home = {
    file = {
      ".xinitrc".text = ''
        picom -b
        exec xmonad
      '';
    };
    username = user.name;
    homeDirectory = user.home;
    packages = with pkgs; [
      arandr
      ripgrep
      fd
      sxiv
      youtube-dl
      maim
      xmobar
      xwallpaper
      nodejs
      tex
      zathura
      clang
      acpi
      kitty
      htop

      # LSP
      rnix-lsp
      gopls
      haskell-language-server

      # Misc
      discord

      # Needed for arandr
      yaru-theme
    ]
    ++ fonts;

    sessionVariables = {
      EDITOR = "vim";
    };
    stateVersion = "21.11";
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
    };
    mpv = {
      enable = true;
    };
    fish = {
      enable = true;
      shellAbbrs = {
        hms = "home-manager switch";
        v = "nvim";
        xrr = "xmonad --recompile && xmonad --restart";
        xmc = "vim ${config.home.homeDirectory}/.xmonad/xmonad.hs";
        xbc = "vim ${config.xdg.configHome}/xmobar/xmobarrc";
        nvc = "vim ${config.xdg.configHome}/nvim/lua/settings.lua";
        tl = "tmux list-sessions";
        ta = "tmux attach";
      };
      shellAliases = {
        t = "tmux";
        vim = "nvim";
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
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-dark-meadow
        vim-nix

        # UI
        galaxyline-nvim
        nvim-web-devicons
        nvim-tree-lua
        telescope-nvim
        telescope-fzf-native-nvim

        # LSP
        coc-nvim
        coc-go
        coc-json
        coc-pairs
        coc-yaml
        coc-vimtex

        # Completion
        nvim-autopairs

        # Misc
        vim-rooter
        vim-floaterm
        markdown-preview-nvim
        vimtex
      ];
      extraConfig = ''
      lua << EOF
      local settings_lua = "${config.xdg.configHome}/nvim/lua/settings.lua"
      vim.defer_fn(function()
        vim.cmd ([[
          packadd vim-nix
          packadd galaxyline-nvim
          packadd nvim-web-devicons
          packadd nvim-tree-lua
          packadd telescope-nvim
          packadd telescope-fzf-native-nvim

          packadd coc-nvim
          packadd coc-go
          packadd coc-json
          packadd coc-pairs
          packadd coc-yaml
          packadd coc-vimtex

          packadd nvim-autopairs

          packadd vim-rooter
          packadd vim-floaterm
          packadd markdown-preview-nvim
          packadd vimtex
          doautocmd BufRead
        ]])
        vim.defer_fn(function()
          dofile(settings_lua)
        end, 15)
      end, 0)
      EOF
      '';
    };
    home-manager.enable = true;
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
