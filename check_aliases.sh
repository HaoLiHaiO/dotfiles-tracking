#!/bin/bash
echo "Running alias check script"
date

DIR="${1:-$HOME}"
echo "Using directory: $DIR"

alias_lines=$(grep -h -E "^\s*alias\s" "$DIR/.bashrc" "$DIR/.zshrc" "$DIR/.bash_aliases" "$DIR/.zsh_aliases" 2>/dev/null | grep -vE "^\s*#" | grep -vE "^\s*$")

echo "Alias lines found:"
echo "$alias_lines"

echo "$alias_lines" | awk -F'=' '{gsub(/^[ \t]+|[ \t]+$/, "", $1); sub(/^alias[ \t]+/, "", $1); print $1}' | sort | uniq -d | while read -r alias; do
    echo "Duplicate alias found: $alias"
done
