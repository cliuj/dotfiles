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
      };
      shellAliases = {
        v = "nvim";
        vim = "nvim";
        vol = "alsamixer";
        home = "vim ~/.config/nixpkgs/home.nix";
        configs = "cd ~/dotfiles/configs";
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
      ];
      extraConfig = ''
      lua << EOF
      local home = os.getenv("HOME")
      vim.defer_fn(function()
        vim.cmd ([[
          colorscheme dark-meadow
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
