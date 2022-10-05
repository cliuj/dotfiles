{ config, pkgs, ... }:

{

  programs = {

    fish = {
      shellAbbrs = {
        tl = "tmux list-sessions";
        ta = "tmux attach";
      };
      shellAliases = {
        t = "tmux";
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
  };
}
