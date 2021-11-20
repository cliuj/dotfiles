{ config, pkgs, ... }:

{
  home = {
    username = "cliuj";
    homeDirectory = "/home/cliuj";
    packages = with pkgs; [
      arandr
      ripgrep
      fd
      bat
      fzf
      nodejs
      nnn
      sxiv
      mpv
      youtube-dl
      maim
      picom
      xmobar

      # LSP
      rnix-lsp
      gopls
      haskell-language-server

      # Needed for arandr
      yaru-theme
    ];
    sessionVariables = {
      EDITOR = "neovim";
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
      };
      shellAliases = {
        vim = "nvim";
        vol = "alsamixer";
        home = "vim ~/.config/nixpkgs/home.nix";
        suslock = "slock systemctl suspend -i";
        lock = "slock";
      };
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
