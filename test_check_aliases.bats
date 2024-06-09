#!/usr/bin/env bats

setup() {
    TMP_DIR=$(mktemp -d)
    echo "Creating temporary directory: $TMP_DIR"
    echo "alias ll='ls -lA'" > "$TMP_DIR/.bash_aliases"
    echo "alias la='ls -aF'" >> "$TMP_DIR/.bash_aliases"
    echo "alias ll='ls -la'" >> "$TMP_DIR/.bash_aliases"
}

teardown() {
    echo "Removing temporary directory: $TMP_DIR"
    rm -rf "$TMP_DIR"
}

@test "Detect duplicate aliases" {
    run bash check_aliases.sh "$TMP_DIR"

    echo "Script output:"
    echo "$output"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Duplicate alias found: ll"* ]]
}

@test "No duplicate aliases" {
    echo "alias ll='ls -lA'" > "$TMP_DIR/.bash_aliases"
    echo "alias la='ls -aF'" >> "$TMP_DIR/.bash_aliases"

    run bash check_aliases.sh "$TMP_DIR"

    echo "Script output:"
    echo "$output"

    [ "$status" -eq 0 ]
    [[ "$output" != *"Duplicate alias found:"* ]]
}
