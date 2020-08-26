cal plug#begin('~/.local/share/nvim/plugged')

"" Utilities
	Plug 'ptzz/lf.vim'
	Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
	Plug 'rbgrouleff/bclose.vim'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'scrooloose/nerdcommenter'
		let g:NERDSpaceDelims = 1
		let g:NERDCompactSexyComs = 1
		let g:NERDCustomDelimiters = { 'lf': { 'left': '#' } }	" Fix lfrc comments
	Plug 'mbbill/undotree'
	Plug 'junegunn/goyo.vim'
	Plug 'jamessan/vim-gnupg'
	" Neovim in the browser :)
	Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

"" Markdown
" Live Preview
	Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Markdown Table of Contents
	Plug 'mzlogin/vim-markdown-toc'

" " Vimtex
	" Plug 'lervag/vimtex'
	" Plug 'KeitaNakamura/tex-conceal.vim'
		" se conceallevel=1
		" let g:tex_conceal='abdmg'
		" hi Conceal ctermbg=none

" Various filetypes support
	Plug 'Konfekt/vim-office'
	Plug 'alx741/vinfo'
	Plug 'chrisbra/csv.vim'

" Autocompletion
	Plug 'Shougo/deoplete.nvim'
	Plug 'Shougo/neco-vim'
	Plug 'Shougo/neco-syntax'
	Plug 'sirver/ultisnips'
		let g:UltiSnipsExpandTrigger = '<tab>'
		let g:UltiSnipsJumpForwardTrigger = '<tab>'
		let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
		let g:UltiSnipsSnippetDirectories = ['UltiSnips',$HOME.'/.config/nvim/UltiSnips']
		let g:UltiSnipsSnippetsDir = $HOME."/.config/nvim/UltiSnips"

"" Appearance
" Color highlighting
	Plug 'ap/vim-css-color'

" Colorschemes
	Plug 'dylanaraps/wal.vim'
	Plug 'gruvbox-community/gruvbox'
	Plug 'iCyMind/NeoSolarized' 	" NeoSolarized

" Airline
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

" Syntax highlighting
	Plug 'VebbNix/lf-vim'
	Plug 'cespare/vim-toml'
	Plug 'bfrg/vim-cpp-modern'

" Icons
	Plug 'ryanoasis/vim-devicons'

cal plug#end()
