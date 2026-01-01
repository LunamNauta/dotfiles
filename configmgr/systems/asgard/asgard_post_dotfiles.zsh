# Add extensions to make yazi more useful
log_message "Instsalling yazi extensions..."
ya pkg add yazi-rs/plugins:full-border
ya pkg add yazi-rs/plugins:mount
ya pkg add imsi32/yatline
ya pkg add imsi32/yatline-catppuccin
ya pkg add yazi-rs/plugins:smart-enter
ya pkg add dedukun/bookmarks

# Fix hyprland stuff
sed -i 's/monitor = , 1920x1080@60, auto, 1.25/monitor = , 1920x1080@120, auto, 1/' $HOME/.config/hypr/hyprland.conf

