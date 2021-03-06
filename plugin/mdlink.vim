" File: mdlink.vim
" Author: Genki Uchimura <gamurai@gmail.com>
" Description: vim plugin for convert url to markdown format.
if exists("g:loaded_mdlink")
  finish
endif
let g:loaded_mdlink = 1

let s:config_exists = 1
try
  execute 'source $HOME/.mdlink-vim'
catch
  let s:config_exists = 0
endtry

if s:config_exists == 1
  source $HOME/.mdlink-vim
endif

if !exists('g:mdlink_vim')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! MarkdownLinkOnlyOnCursor call mdlink#make_markdown_link_with_title(1)
command! -range MarkdownLink <line1>,<line2>call mdlink#make_markdown_link_with_title(0)

let &cpo = s:save_cpo
unlet s:save_cpo

