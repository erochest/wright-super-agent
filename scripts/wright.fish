#!/usr/bin/env fish
# WRIGHT — Launch your agent from anywhere (fish shell).
#
# Fish auto-loads functions from ~/.config/fish/functions/.
# Link or copy this file there:
#
#   ln -s /Users/ericrochester/p/2026/wright/scripts/wright.fish \
#         ~/.config/fish/functions/wright.fish
#
# Usage:
#   wright                    # launch from current directory
#   wright --model sonnet     # override model
#   wright --resume           # resume last conversation

function wright --description "Launch WRIGHT architecture agent from any directory"
    set -l target_dir (pwd)
    cd /Users/ericrochester/p/2026/wright
    ENABLE_EXPERIMENTAL_MCP_CLI=true claude --permission-mode auto --add-dir $target_dir $argv
    set -l exit_code $status
    cd $target_dir
    return $exit_code
end
