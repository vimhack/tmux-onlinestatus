#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$CURRENT_DIR" || exit 1

source shared.sh

online_option="@online_icon"
offline_option="@offline_icon"
online_fgcolor_option="@online_fgcolor"
offline_fgcolor_option="@offline_fgcolor"
curl_timeout_option="@curl_timeout"
url_to_curl_option="@url_to_curl"
terminal_proxy_option="@terminal_proxy"
check_interval_option="@check_interval_seconds"

online_icon_default=" ✔"
offline_icon_default=" X"
online_fgcolor_default="#00afaf"
offline_fgcolor_default="#767676"
curl_timeout_default="3"
url_to_curl_default="https://www.google.com"
terminal_proxy_default=""
# in seconds
check_interval_default=10

print_status() {
    online_icon=$(get_tmux_option "$online_option" "$online_icon_default")
    offline_icon=$(get_tmux_option "$offline_option" $offline_icon_default)
    online_fgcolor=$(get_tmux_option "$online_fgcolor_option" "$online_fgcolor_default")
    offline_fgcolor=$(get_tmux_option "$offline_fgcolor_option" $offline_fgcolor_default)
    timeout=$(get_tmux_option "$curl_timeout_option" "$curl_timeout_default")
    url=$(get_tmux_option "$url_to_curl_option" "$url_to_curl_default")
    terminal_proxy=$(get_tmux_option "$terminal_proxy_option" "$terminal_proxy_default")

    curl_command="curl --connect-timeout $timeout $url >/dev/null 2>&1"
    if ! eval "$curl_command"; then
        [[ -n "$terminal_proxy" ]] && eval "$terminal_proxy"
        eval "$curl_command" && echo "#[fg=$online_fgcolor]$online_icon" ||
            echo "#[fg=$offline_fgcolor]$offline_icon"
    else
        echo "#[fg=$online_fgcolor]$online_icon"
    fi
}

main() {
    local update_interval=$(get_tmux_option "$check_interval_option" $check_interval_default)
    local current_time=$(date "+%s")
    local previous_update=$(get_tmux_option "@previous_update_time")
    local delta=$((current_time - previous_update))

    if [[ -z "$previous_update" ]] || [[ $delta -ge $update_interval ]]; then
        local value=$(print_status)
        if [ "$?" -eq 0 ]; then
            set_tmux_option "@previous_update_time" "$current_time"
            set_tmux_option "@previous_value" "$value"
        fi
    fi

    echo -n "$(get_tmux_option "@previous_value")"
}

main
