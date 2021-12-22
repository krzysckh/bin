#!/bin/sh

# clears screen
# "vt100" is the name of terminal.vim plugin
# it doesn't work with \033c sometimes
# i use \033c in urxvt, because it deletes scrollback

[ "$TERM" = "vt100" ] && /bin/clear || printf "\033c"

