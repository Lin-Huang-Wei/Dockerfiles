#!/bin/bash

_make_complete() {
    local cur cmds
    cur="${COMP_WORDS[COMP_CWORD]}"

    makefile="$(pwd)/Makefile"

    if [[ -f "$makefile" ]]; then
      # 只列出 Makefile 中的目標，過濾掉文件和參數
      cmds=$(grep -E '^\s*\.PHONY\s*:\s*' "$makefile" | sed -E 's/^\s*\.PHONY\s*:\s*//g' | grep -v help)

      COMPREPLY=( $(compgen -W "${cmds}" -- "${cur}") )
    fi
}

complete -o nospace -o default -F _make_complete make
