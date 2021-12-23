{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "cliuj";
    homeDirectory = "/home/cliuj";
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

      # LSP
      rnix-lsp
      gopls
      haskell-language-server

      # Needed for arandr
      yaru-theme
    ];
    sessionVariables = {
      EDITOR = "vim";
    };
    stateVersion = "21.05";
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
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-nvim-lua
        vim-vsnip
        vim-vsnip-integ
        cmp-vsnip

        # Completion
        nvim-autopairs

        # Misc
        vim-rooter
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

          packadd nvim-lspconfig
          packadd nvim-cmp
          packadd cmp-nvim-lsp
          packadd cmp-buffer
          packadd cmp-nvim-lua
          packadd vim-vsnip
          packadd vim-vsnip-integ
          packadd cmp-vsnip

          packadd nvim-autopairs

          packadd vim-rooter
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
