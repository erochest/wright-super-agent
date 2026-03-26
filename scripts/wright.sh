#!/usr/bin/env bash
# WRIGHT — Launch your agent from anywhere.
#
# This function starts Claude Code with WRIGHT's full infrastructure
# (persona, rules, knowledge, skills, plugins) and adds your current
# working directory for code access.
#
# Setup:
#   Add this line to your ~/.bashrc or ~/.zshrc:
#
#     source "/Users/ericrochester/p/2026/wright/scripts/wright.sh"
#
#   Then restart your terminal or run: source ~/.bashrc (or ~/.zshrc)
#
# Usage:
#   wright                    # launch from current directory
#   wright --model sonnet     # override model
#   wright --resume           # resume last conversation
#
# Permission mode:
#   Uses --permission-mode auto by default. Auto mode runs a classifier
#   on every non-trivial action — safer than bypass, less interruptive
#   than default. If auto mode causes false positives, add specific allow
#   patterns to .claude/settings.local.json rather than disabling the
#   classifier entirely.

function wright() {
    local target_dir
    target_dir="$(pwd)"
    (cd "/Users/ericrochester/p/2026/wright" && ENABLE_EXPERIMENTAL_MCP_CLI=true claude --permission-mode auto --add-dir "$target_dir" "$@")
}
