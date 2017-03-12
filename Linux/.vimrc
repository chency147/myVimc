" Vundle配置
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" 插件列表
Plugin 'VundleVim/Vundle.vim'
Plugin 'dracula/vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'


call vundle#end()
filetype plugin indent on

" 显示行号
set nu

" 设置Tab为4格宽度
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab

" 自动缩进
set autoindent
set cindent

" 设置语法高亮并设置主题
syntax on
color dracula

" 设置不产生Swap文件
set nobackup
set nowritebackup
set noswapfile

" 如果是Gvim
if has('gui_running')
	set guifont=Monospace\ 12
	set lines=25 columns=120
	" 隐藏工具栏和菜单栏，按F2键切换显示状态
	set guioptions-=m
	set guioptions-=T
	map <silent> <F2> :if &guioptions =~# 'T' <Bar>
				\set guioptions-=T <Bar>
				\set guioptions-=m <bar>
				\else <Bar>
				\set guioptions+=T <Bar>
				\set guioptions+=m <Bar>
				\endif<CR>
endif
" Airlie 配置
" 是否打开tabline
let g:airline#extensions#tabline#enabled = 1
set laststatus=2
