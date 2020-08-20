# Reduce timeout
	export KEYTIMEOUT=1

	vim_ins_mode="%{$fg[blue]%}[INS]%{$reset_color%}"
	vim_cmd_mode="%{$fg[green]%}[CMD]%{$reset_color%}"

	function zle-keymap-select {	# Change cursor shape for different vi modes + decent rprompt indicator
	  if [[ ${KEYMAP} == vicmd ]] ||
	     [[ $1 = 'block' ]]; then
	    echo -ne '\e[1 q'
	    vim_mode=${vim_cmd_mode}
	  elif [[ ${KEYMAP} == main ]] ||
	       [[ ${KEYMAP} == viins ]] ||
	       [[ ${KEYMAP} = '' ]] ||
	       [[ $1 = 'beam' ]]; then
	    echo -ne '\e[5 q'
	    vim_mode=${vim_ins_mode}
	  fi
	  zle reset-prompt
	}
	zle -N zle-keymap-select
	# init `vi insert` as keymap
	zle-line-init() {
	    zle -K viins
	    echo -ne "\e[5 q"
	}
	zle -N zle-line-init

# ci", ci', ci`, di", etc
	autoload -U select-quoted
	zle -N select-quoted
	for m in visual viopp; do
	  for c in {a,i}{\',\",\`}; do
	    bindkey -M $m $c select-quoted
	  done
	done

# ci{, ci(, ci<, di{, etc
	autoload -U select-bracketed
	zle -N select-bracketed
	for m in visual viopp; do
	  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
	    bindkey -M $m $c select-bracketed
	  done
	done

# Edit line in vim with ctrl-e:
	autoload edit-command-line; zle -N edit-command-line
	bindkey "^x^e" edit-command-line

# Move by physical lines, just like gj/gk in vim :)
# Credits to http://leahneukirchen.org/dotfiles/.zshrc# .zshrc interactive configuration file for zsh
	_physical_up_line()   { zle backward-char -n $COLUMNS }
	_physical_down_line() { zle forward-char  -n $COLUMNS }
	zle -N physical-up-line _physical_up_line
	zle -N physical-down-line _physical_down_line
	for m in visual viopp vicmd; do
		bindkey -M $m "gk" physical-up-line
		bindkey -M $m "gj" physical-down-line
	done
# Completion menu movements
	bindkey -M menuselect 'h' vi-backward-char
	bindkey -M menuselect 'k' vi-up-line-or-history
	bindkey -M menuselect 'l' vi-forward-char
	bindkey -M menuselect 'j' vi-down-line-or-history
# Allow ctrl-p, ctrl-n for navigate history
	bindkey '^P' up-history
	bindkey '^N' down-history

# Classic movements
	bindkey -M viins "^A" beginning-of-line
	bindkey -M viins "^E" end-of-line
