# Reduce timeout
	export KEYTIMEOUT=1
# Change cursor shape for different vi modes + decent rprompt indicator
	vim_ins_mode="%{$fg_bold[blue]%}[INS]%{$reset_color%}"
	vim_cmd_mode="%{$fg_bold[green]%}[CMD]%{$reset_color%}"
## Document cursor types:
#  1 -> blinking block
#  2 -> solid block
#  3 -> blinking underscore
#  4 -> solid underscore
#  5 -> blinking vertical bar
#  6 -> solid vertical bar
	zle-keymap-select() {
	  if [[ ${KEYMAP} == vicmd ]] ||
	     [[ $1 = 'block' ]]; then
	    printf '\e[1 q'
	    vim_mode=${vim_cmd_mode}
	  elif [[ ${KEYMAP} == main ]] ||
	       [[ ${KEYMAP} == viins ]] ||
	       [[ ${KEYMAP} = '' ]] ||
	       [[ $1 = 'beam' ]]; then
	    printf '\e[5 q'
	    vim_mode=${vim_ins_mode}
	  fi
	  zle reset-prompt
	}
	zle -N zle-keymap-select
	# init `vi insert` as keymap
	zle-line-init() {
	    zle -K viins
	    printf "\e[5 q"
	}
	zle -N zle-line-init

# ci", ci', ci`, di", etc
	autoload -U select-quoted
	zle -N select-quoted
	for m in visual vicmd viopp; do
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

# Edit line in vim with Ctrl+x+e:
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
	bindkey -M viins "^a" beginning-of-line
	bindkey -M viins "^e" end-of-line
	bindkey -M viins '^u' kill-whole-line
	bindkey -M viins '^b' backward-char
	bindkey -M viins '^f' forward-char

# Better, incremental searching using vi mode(!)
	bindkey -M vicmd '?' history-incremental-search-backward
	bindkey -M vicmd '/' history-incremental-search-forward
	bindkey -M viins '^k' history-incremental-search-backward
	bindkey -M viins '^j' history-incremental-search-forward

# Fix broken keys
## ^w, backspace and ^h working even after returning from command mode (annoying)
	bindkey '^?' backward-delete-char
	bindkey '^h' backward-delete-char
  bindkey '^w' vi-backward-kill-word
## Delete/Insert (replace mode)
	bindkey '^[[P' delete-char
	for m in visual viopp vicmd; do
	    bindkey -M $m '^[[4h' vi-replace
	done
## Pgup(also `gg`)/Pgdown
	bindkey '^[[5~' beginning-of-buffer-or-history
	bindkey '^[[6~' end-of-buffer-or-history
## Home/End
	bindkey '^[[H' beginning-of-line
	bindkey '^[[4~' end-of-line
