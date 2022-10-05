{ config, pkgs, home, ... }:

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
in {
  home = {
    sessionVariables = {
      EDITOR = "vim";
    };
    packages = with pkgs; [
      # LSP
      rnix-lsp
      gopls
      haskell-language-server
    ];
  };

  programs = {
    fish = {
      shellAbbrs = {
        v = "nvim";
      };
      shellAliases = {
        vim = "nvim";
      };
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
  };
}
