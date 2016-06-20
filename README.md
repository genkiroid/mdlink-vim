# mdlink-vim

URL to Markdown link with title. Support issue and p/r title on Github/GHE private repo.

## Install

Checkout into your plugin directory, or Use plugin manager.

## Requirements

 - [mattn/webapi-vim](https://github.com/mattn/webapi-vim)
 - [kana/vim-textobj-user](https://github.com/kana/vim-textobj-user)
 - [mattn/vim-textobj-url](https://github.com/mattn/vim-textobj-url)

## Settings

 1. Create $HOME/.mdlink-vim file like the following. And input your personal token.
  ```
let g:mdlink_vim = {
  \ 'github_token':   'your personal token'
\}
  ```

 1. If using GHE, add optional settings.
  ```
let g:mdlink_vim = {
  \ 'github_token':   'your personal token',
  \ 'ghe_url':        'https://ghe.domain.name/',
  \ 'ghe_api_url':    'https://ghe.domain.name/api/v3/repos/',
  \ 'ghe_token':      'your personal token'
\}
  ```

## Usage

### MarkdownLink

 1. Put the cursor on the row existing URL. Or select multi rows by visual mode.
 1. Enter command `:MarkdownLink`.

### MarkdownLinkOnlyOnCursor

 1. Put the cursor on the URL.
 1. Enter command `:MarkdownLinkOnlyOnCursor`.

### Map example

```
nnoremap <silent> ml :MarkdownLink<CR>
vnoremap <silent> ml :MarkdownLink<CR>
nnoremap <silent> mo :MarkdownLinkOnlyOnCursor<CR>
```

## License

MIT

## Authors

genkiroid

