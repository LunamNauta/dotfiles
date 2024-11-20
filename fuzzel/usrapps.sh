#!/bin/bash

SELECTION="$(printf "\
Firefox\0icon\x1ffirefox\n\
Firefox (Private)\0icon\x1ffirefox\n\
LibreOffice (Main)\0icon\x1flibreoffice-main\n\
LibreOffice (Writer)\0icon\x1flibreoffice-writer\n\
LibreOffice (Calc)\0icon\x1flibreoffice-calc\n\
LibreOffice (Base)\0icon\x1flibreoffice-base\n\
LibreOffice (Math)\0icon\x1flibreoffice-math\n\
LibreOffice (Impress)\0icon\x1flibreoffice-impress\n\
Thunderbird Mail\0icon\x1fthunderbird\n\
KeePassXC\0icon\x1fkeepassxc\n\
Steam\0icon\x1fsteam\n\
" | fuzzel --dmenu -l 11 -p "Usr App: \
")"

case $SELECTION in
	*"Firefox")
        exec firefox;;
    *"Firefox (Private)")
        exec firefox -private-window;;
    *"LibreOffice (Main)")
        exec libreoffice;;
    *"LibreOffice (Writer)")
        exec lowriter;;
    *"LibreOffice (Calc)")
        exec localc;;
    *"LibreOffice (Base)")
        exec lobase;;
    *"LibreOffice (Math)")
        exec lomath;;
    *"LibreOffice (Impress)")
        exec loimpress;;
    *"Thunderbird Mail")
        exec thunderbird;;
	*"KeePassXC")
        exec keepassxc;;
	*"Steam")
        exec steam;;
esac
