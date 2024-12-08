#!/bin/bash

SELECTION="$(printf "\
CMD+q              => open term\n\
CMD+t              => open tmux\n\
CMD+e              => open file-manager\n\
CMD+p              => open app-menu\n\
CMD+o              => open sys-menu\n\
CMD+i              => open games-menu\n\
CMD+SHIFT+c        => reload sway\n\
CMD+c              => kill window\n\
CMD+<ARROW>        => focus <ARROW>\n\
CMD+SHIFT+<ARROW>  => move <ARROW>\n\
CMD+<NUMBER>       => workspace <NUMBER>\n\
CMD+SHIFT+<NUMBER> => move to workspace <NUMBER>\n\
CMD+MINUS          => scratchpad show\n\
CMD+SHIFT+MINUS    => move to scratchpad\n\
CMD+SHIFT+e        => exit sway\n\
" | fuzzel --dmenu -l 15 -p "Keymap: \
")"
