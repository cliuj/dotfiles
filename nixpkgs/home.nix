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
  home = {
    username = user.name;
    homeDirectory = user.home;
    packages = with pkgs; [
      arandr
      ripgrep
      fd
      bat
      fzf
      nnn
      sxiv
      mpv
      youtube-dl
      maim
      picom
      xmobar
      tmux
      xwallpaper
      nodejs
      tex
      zathura
      kitty

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
      # NOTE: Disable this for systems that can run OpenGL 3.3+.
      #       This was done to run programs that need OpenGL 2.0+,
      #       but can't because the underlying system cannot support it,
      #       i.e older hardware
      LIBGL_ALWAYS_SOFTWARE = 1;
    };
    stateVersion = "21.11";
  };

  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        hms = "home-manager switch";
        v = "nvim";
        xrr = "xmonad --recompile && xmonad --restart";
        xbc = "vim ~/.config/xmobar/xmobarrc";
        xmc = "vim ~/.xmonad/xmonad.hs";
        nvc = "vim ~/.config/nvim/lua/settings.lua";
        tl = "tmux list-sessions";
        ta = "tmux attach";
      };
      shellAliases = {
        t = "tmux";
        vim = "nvim";
        vol = "alsamixer";
        home = "vim ~/.config/nixpkgs/home.nix";
        suslock = "slock systemctl suspend -i";
        lock = "slock";
        devhs = "nix-shell --run fish -p ghc stack cabal-install";
      };
    };
   tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      historyLimit = 5000;
      keyMode = "vi";
      newSession = true;
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
      local home = os.getenv("HOME")
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
          dofile(home .. "/.config/nvim/lua/settings.lua")
        end, 15)
      end, 0)
      EOF
      '';
    };
    home-manager.enable = true;
  };
}
