#!/bin/bash
# label.sh - Script to generate random labels for server environments.

# Helper function to check if a label already exists
label_exists() {
    local label=$1
    local metafiles=$(find "$HOME/.mg" -type f -name metadata -exec grep -l "Label=$label" {} \;)
    [[ -n "$metafiles" ]]
}

generate_random_label() {
    local words=("adventure" "banana" "comet" "dragon" "echo" "fiesta" "galaxy" "hippo" "igloo" "joker"
                 "koala" "llama" "mango" "nebula" "octopus" "pirate" "quasar" "robot" "star" "turtle"
                 "unicorn" "volcano" "whale" "xylophone" "yeti" "zebra" "axolotl" "blimp" "cactus" "doodle")
    local label=""
    while true; do
        local word1=${words[$RANDOM % ${#words[@]}]}
        local word2=${words[$RANDOM % ${#words[@]}]}
        local number=$((RANDOM % 100 + 1))
        label="${word1}-${word2}-${number}"
        if ! label_exists "$label"; then
            echo "$label"
            break
        fi
    done
}
