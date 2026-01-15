# Add extensions to make yazi more useful
log_message "Instsalling yazi extensions..."
rm -r ~/.config/yazi/plugins
rm ~/.config/yazi/package.toml
ya pkg add yazi-rs/plugins:full-border
ya pkg add yazi-rs/plugins:mount
ya pkg add yazi-rs/plugins:smart-enter
ya pkg add dedukun/bookmarks

# Fix hyprland stuff
sed -i 's/monitor = , 1920x1080@60, auto, 1.25/monitor = , 1920x1080@120, auto, 1/' $HOME/.config/hypr/hyprland.conf
hyprctl reload
