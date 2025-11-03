ssh-start(){ eval "$(ssh-agent -s)"; }
ssh-add-key(){ ssh-add "$HOME/.ssh/$1" }
