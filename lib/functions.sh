#!/usr/bin/env bash
apply_shell_expansion() {
    declare file="$1"
    declare data=$(< "$file")
    declare delimiter="__apply_shell_expansion_delimiter__"
    declare command="cat <<$delimiter"$'\n'"$data"$'\n'"$delimiter"
    eval "$command"
}