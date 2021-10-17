#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$CURRENT_DIR" || exit 1

source scripts/shared.sh

interpolations=(
    "\#{online_status}"
)

commands=(
    "#($CURRENT_DIR/scripts/online_status.sh)"
)

do_interpolation() {
    local all_interpolated="$1"
    for ((i = 0; i < ${#commands[@]}; i++)); do
        all_interpolated=${all_interpolated//${interpolations[$i]}/${commands[$i]}}
    done
    echo "$all_interpolated"
}

update_tmux_option() {
    local option="$1"
    local option_value="$(get_tmux_option "$option")"
    local new_option_value="$(do_interpolation "$option_value")"

    set_tmux_option "$option" "$new_option_value"
}

main() {
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}

main
