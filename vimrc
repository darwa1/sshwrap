# --- shrap ops note helpers: F5 timestamp block, F6 target block ---

# Use Readline keybindings (works in interactive bash). Requires: set -o emacs (default).
# If you're in vi mode, switch with: set -o emacs

# Fold line exactly as requested (escaped for bash)
__FOLD_LINE='\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'

# ANSI colors
__YELLOW_BG=$'\e[43m'
__BLACK_FG=$'\e[30m'
__RESET=$'\e[0m'

# Helper: build a highlighted timestamp string.
# Note: the "highlighted yellow" effect only displays on terminals that support ANSI;
# it will be inserted into your command line as escape codes.
__shrap_ts() {
  # Example format: 2026-02-05 09:12:34 EST
  date '+%Y-%m-%d %H:%M:%S %Z'
}

# Bind F5: insert folded highlighted timestamp block
bind -x '"\e[15~]":__shrap_insert_ts_block'
__shrap_insert_ts_block() {
  local ts
  ts="$(__shrap_ts)"
  # Insert into current readline buffer
  READLINE_LINE+=$'\n'"${__FOLD_LINE}"$'\n'
  READLINE_LINE+="${__YELLOW_BG}${__BLACK_FG} ${ts} ${__RESET}"$'\n'
  READLINE_LINE+="${__FOLD_LINE}"$'\n'
  READLINE_POINT=${#READLINE_LINE}
}

# Bind F6: insert target section + folds
bind -x '"\e[17~]":__shrap_insert_target_block'
__shrap_insert_target_block() {
  READLINE_LINE+=$'\n'"ip      -      hostname      -      entityid"$'\n'
  READLINE_LINE+="===================================================" $'\n'
  READLINE_LINE+="${__FOLD_LINE}"$'\n'
  READLINE_LINE+="${__FOLD_LINE}"$'\n'
  READLINE_POINT=${#READLINE_LINE}
}
