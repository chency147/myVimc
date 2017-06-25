set nocompatible
filetype on

" 显示行号
set nu

" 设置Tab为4个空格
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" 自动缩进
set autoindent
set cindent

" 设置语法高亮并设置主题
syntax on
color desert

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
set laststatus=2
