#!/usr/bin/env bash

version_pat='s/^tmux[^0-9]*([.0-9]+).*/\1/p'

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"

# Keep ^H (Ctrl-Backspace) mapped to ^W (i.e. delete word backwards)
tmux bind-key -n C-h send-keys C-w

# Rebind ^W to custom key table
tmux bind-key -n C-w switch-client -T vimtable
tmux bind-key -T vimtable h if-shell "$is_vim" "send-keys C-w h" "select-pane -L"
tmux bind-key -T vimtable j if-shell "$is_vim" "send-keys C-w j" "select-pane -D"
tmux bind-key -T vimtable k if-shell "$is_vim" "send-keys C-w k" "select-pane -U"
tmux bind-key -T vimtable l if-shell "$is_vim" "send-keys C-w l" "select-pane -R"
tmux bind-key -T vimtable p if-shell "$is_vim" "send-keys C-w p" "select-pane -l"

tmux_version="$(tmux -V | sed -En "$version_pat")"
tmux setenv -g tmux_version "$tmux_version"

#echo "{'version' : '${tmux_version}', 'sed_pat' : '${version_pat}' }" > ~/.tmux_version.json

tmux if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
  "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
tmux if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
  "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

# tmux bind-key -T copy-mode-vi C-h select-pane -L
# tmux bind-key -T copy-mode-vi C-j select-pane -D
# tmux bind-key -T copy-mode-vi C-k select-pane -U
# tmux bind-key -T copy-mode-vi C-l select-pane -R
# tmux bind-key -T copy-mode-vi C-\\ select-pane -l
