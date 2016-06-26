let s:save_cpo = &cpo
set cpo&vim

let s:github_url = "https://github.com/"
let s:github_api_url = "https://api.github.com/repos/"
let s:is_github = 0
let s:is_ghe = 0
let s:ghe_options = ['ghe_api_url', 'ghe_token', 'ghe_url']
let s:has_ghe_options = 0

function! mdlink#make_markdown_link_with_title(onlyoncursor) range
  call s:check_options()
  call s:format_url()
  let ret = s:is_cursol_on_url()
  if ret
    call s:to_markdown(s:get_url())
    return
  endif
  if a:onlyoncursor
    return
  endif
  for n in range(a:firstline, a:lastline)
    call s:cursor_to_url(n)
  endfor
endfunction

function! s:get_url()
  let reg = @r
  execute 'normal "ryiu'
  let url = @r
  let @r = reg

  return url
endfunction

function! s:is_cursol_on_url()
  if s:get_url() != ''
    return 1
  endif
  return 0
endfunction

function! s:check_options()
  let l:cnt = 0
  for opt in s:ghe_options
    if has_key(g:mdlink_vim, opt)
      let l:cnt += 1
    endif
  endfor
  if l:cnt == len(s:ghe_options)
    let s:has_ghe_options = 1
  endif
endfunction

function! s:format_url()
  if s:has_ghe_options
    for option in s:ghe_options
      if option =~ 'url'
        let g:mdlink_vim[option] = s:append_trailing_slash(g:mdlink_vim[option])
      endif
    endfor
  endif
endfunction

function! s:cursor_to_url(n)
  let l:colpos = s:get_url_col_position(a:n)

  while l:colpos != -1
    call cursor(a:n, l:colpos + 1)
    let url = s:get_url()
    call s:to_markdown(url)
    let l:colpos = s:get_url_col_position(a:n)
  endwhile

endfunction

function! s:get_url_col_position(n)
  return match(getline(a:n), '\([^([]https\?\)', 0)
endfunction

function! s:to_markdown(url)
    call s:check_url(a:url)
    let title = s:get_title(a:url)
    let reg = @r
    let @r = "[".title."](".a:url.")"
    execute 'normal viu"rP'
    let @r = reg
endfunction

function! s:append_trailing_slash(url)
  if a:url !~? '/$'
    return a:url.'/'
  endif
  return a:url
endfunction

function! s:get_title(url)
  if s:is_github || s:is_ghe
    return s:get_issue_title(a:url)
  endif
  return s:get_page_title(a:url)
endfunction

function! s:get_issue_title(url)
  let url = s:get_github_api_url(a:url)
  let auth = s:get_auth_header()
  let res = webapi#http#get(url, '', { "Authorization": auth })
  let issue = webapi#json#decode(res.content)
  try
    let title = issue.title
    return issue.title
  catch
    echo "It support only issue or pull if on private repo."
    return a:url
  endtry
endfunction

function! s:get_page_title(url)
  let res = webapi#http#get(a:url)
  let dom = webapi#html#parse(res.content)
  try
    let title = dom.childNode('head').childNode('title').value()
    return title
  catch
    echo "Title node is not exists or it's on irregular position."
    return a:url
  endtry
endfunction

function! s:check_url(url)
  let s:is_github = 0
  let s:is_ghe = 0

  if a:url =~# s:github_url
    let s:is_github = 1
  endif

  if s:has_ghe_options == 0
    return
  endif

  if a:url =~# g:mdlink_vim['ghe_url']
    let s:is_ghe = 1
  endif
endfunction

function! s:get_github_api_url(url)
  let apiurl = substitute(a:url, s:github_url, s:github_api_url, 'g')
  if s:has_ghe_options
    let apiurl = substitute(apiurl, g:mdlink_vim['ghe_url'], g:mdlink_vim['ghe_api_url'], 'g')
  endif
  let apiurl = substitute(apiurl, '/pull/', '/pulls/', 'g')
  return apiurl
endfunction

function! s:get_auth_header()
  if s:is_github
    return printf("token %s", g:mdlink_vim['github_token'])
  elseif s:is_ghe && s:has_ghe_options
    return printf("token %s", g:mdlink_vim['ghe_token'])
  else
    return printf("")
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
