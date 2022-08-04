#!/bin/bash

if [[ ! -d ~/.local/share/tmux ]]; then
    mkdir ~/.local/share/tmux
fi

cp tmux-cht-commands tmux-cht-languages ~/.local/share/tmux/
cp tmux-cht.sh tmux-go-session.sh ~/bin/
cp tmux.conf ~/.config/tmux/tmux.conf

