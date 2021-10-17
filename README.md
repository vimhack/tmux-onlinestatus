# Tmux Online Status

A tmux plugin that displays online status in tmux status bar.

## Installation

### With [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

Add plugin to the list of TPM plugins in `.tmux.conf`:

```tmux
set -g @plugin 'vimhack/tmux-onlinestatus#main'
```

Hit `prefix + I` to fetch the plugin and source it.

`#{online_status}` interpolation should now work.

### Manual Installation

Clone the repo:

```sh
$ git clone https://github.com/vimhack/tmux-onlinestatus ~/clone/path
```

Add this line to the bottom of `.tmux.conf`:

```tmux
run-shell ~/clone/path/online_status.tmux
```

Reload Tmux environment:

```sh
$ tmux source-file ~/.tmux.conf
```

## Custom Configurations

You can change the default options, for example:

Add the follows in `.tmux.conf`:

```tmux
set -g @online_icon " "
set -g @offline_icon " "
set -g @online_fgcolor "#00afaf"
set -g @offline_fgcolor "#767676"
set -g @curl_timeout 6
set -g @url_to_curl "https://www.google.com"
set -g @terminal_proxy "http://yourproxyip:port"
```

`#{online_status}` interpolation should now work.
