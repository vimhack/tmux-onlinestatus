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

online_icon_default=" ✔"
offline_icon_default=" X"
online_fgcolor_default="#00afaf"
offline_fgcolor_default="#767676"
curl_timeout_default="3"
url_to_curl_default="https://www.google.com"
terminal_proxy_default=""

print_icon() {
    online_icon=$(get_tmux_option "$online_option" "$online_icon_default")
    offline_icon=$(get_tmux_option "$offline_option" $offline_icon_default)
    online_fgcolor=$(get_tmux_option "$online_fgcolor_option" "$online_fgcolor_default")
    offline_fgcolor=$(get_tmux_option "$offline_fgcolor_option" $offline_fgcolor_default)
    timeout=$(get_tmux_option "$curl_timeout_option" "$curl_timeout_default")
    url=$(get_tmux_option "$url_to_curl_option" "$url_to_curl_default")
    terminal_proxy=$(get_tmux_option "$terminal_proxy_option" "$terminal_proxy_default")

    curl_command="curl --connect-timeout $timeout $url >/dev/null 2>&1"
    if ! eval "$curl_command"; then
        [[ -n "$terminal_proxy" ]] && export all_proxy="$terminal_proxy"
        eval "$curl_command" && echo "#[fg=$online_fgcolor]$online_icon" ||
            echo "#[fg=$offline_fgcolor]$offline_icon"
    else
        echo "#[fg=$online_fgcolor]$online_icon"
    fi
}

main() {
    print_icon
}

main
