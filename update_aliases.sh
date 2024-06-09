#!/bin/bash

DOTFILES_TRACKING_DIR="$(pwd)"
OLD_BASH_ALIASES="$HOME/.bash_aliases"
CURRENT_BASH_ALIASES="$DOTFILES_TRACKING_DIR/.bash_aliases"
BASH_ALIASES_BACKUP="$DOTFILES_TRACKING_DIR/.bash_aliases.orig"
BASHRC="$HOME/.bashrc"

echo "Backing up current .bash_aliases to $BASH_ALIASES_BACKUP..."
cp "$OLD_BASH_ALIASES" "$BASH_ALIASES_BACKUP"

echo "Updating .bash_aliases from $CURRENT_BASH_ALIASES to $OLD_BASH_ALIASES..."
cp "$CURRENT_BASH_ALIASES" "$OLD_BASH_ALIASES"

echo "Sourcing $BASHRC..."
source "$BASHRC"

echo "Update completed successfully."
