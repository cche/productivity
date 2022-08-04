#!/bin/bash

if [[ ! -d ~/.local/share/tmux ]]; then
    mkdir ~/.local/share/tmux
fi

cp tmux-cht-commands tmux-cht-languages ~/.local/share/tmux/
cp tmux-cht.sh tgs gg ~/bin/

