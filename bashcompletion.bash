#!/bin/bash

single_quote="'"

_ti() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="$(ti commands)"

	if [[ "$opts" == *${prev}* ]]; then
		opts=$(ti commands ${prev})
		if [[ $cur =~ ^\" || $cur =~ ^$single_quote ]]; then 
			cur="${cur/#\"/}";
			cur="${cur/#\'/}";
			cur="${cur/ /\\ }"
		fi
		opts="${opts//\\ /___}"
		COMPREPLY=( $(compgen -W "${second_opts}" -- ${cur}) )
		for iter in $opts; do
			# only reply with completions
			if [[ $iter =~ ^$cur ]]; then
				# swap back our escaped spaces
				COMPREPLY+=( "${iter//___/\\ }" )
			fi
		done
	else
		COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
	fi
}

complete -F _ti ti
