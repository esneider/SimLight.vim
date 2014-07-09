"""""""""""""""""
" Default options
"""""""""""""""""

let s:markers = {
\   'Dot'        : '.',
\   'LRArrow'    : '->',
\   'LParen'     : '(',
\   'LBracket'   : '[',
\   'LBrace'     : '{',
\   'Dollar'     : '$',
\   'At'         : '@',
\   'DoubleColon': '::',
\   'Ampersand'  : '&',
\   'Hash'       : '#',
\}

call extend(s:markers, get(g:, 'simlight_markers', {}))

let s:ft_rules = {
\    'c':          {'BeforeLParen': 'Function'},
\    'cpp':        {'BeforeLParen': 'Function', 'BeforeDoubleColon': 'Namespace'},
\    'cs':         {'BeforeLParen': 'Function'},
\    'd':          {'BeforeLParen': 'Function'},
\    'javascript': {'BeforeLParen': 'Function'},
\    'java':       {'BeforeLParen': 'Function'},
\    'lua':        {'BeforeLParen': 'Function'},
\    'matlab':     {'BeforeLParen': 'Function'},
\    'objc':       {'BeforeLParen': 'Function'},
\    'perl':       {'BeforeLParen': 'Function'},
\    'python':     {'BeforeLParen': 'Function'},
\    'r':          {'BeforeLParen': 'Function'},
\    'ruby':       {'BeforeLParen': 'Function'},
\    'vim':        {'BeforeLParen': 'Function'},
\}

call extend(s:ft_rules, get(g:, 'simlight_ft_rules', {}))

let s:contained = {
\   'd':          ['paramlist'],
\   'java':       ['javaParenT', 'javaParenT1', 'javaParentT2'],
\   'javascript': ['jsFuncCall'],
\   'objc':       ['objcBlocks'],
\   'python':     ['pythonFunction'],
\   'vim':        ['vimFuncBody', 'vimFunction', 'vimFuncName', 'vimUserFunc', 'vimExecute'],
\}

call extend(s:contained, get(g:, 'simlight_contained', {}))

""""""""""""""""""""""""
" Simple syntax matching
""""""""""""""""""""""""

" We got clever here, and indexed the context by the first command letter:
" either a(fter) or b(efore).
let s:marker_context = {
\   'a': ['', '\zs\w\+'],
\   'A': ['', '\zs\w\+'],
\   'b': ['\w\+\ze', ''],
\   'B': ['\w\+\ze', ''],
\}

function! s:simlight()

    let file_type = expand('<amatch>')

    " We might be inside another highlight group, so add the necessary flags
    let contained = [''] + get(s:contained, file_type, [])
    let flags = join(contained, ' containedin=')

    " Cycle all the rules for this file_type
    let rules = get(s:ft_rules, file_type, {})

    for [pattern, hi_group] in items(rules)

        let tokens = matchlist(pattern, '\v\c^(After|Before)(.*)')
        let marker = get(s:markers, get(tokens, 2, ''), '')

        if empty(marker)
            continue
        endif

        let rule_name = file_type . pattern

        " The match string is the marker between its corresponding context
        let match = '\V' . join(s:marker_context[pattern[0]], marker)

        execute 'syntax match ' . rule_name . ' "' . match . '" ' . flags
        execute 'highlight default link ' . rule_name . ' ' . hi_group
    endfor
endf

"""""""""""""""""""
" FileType autocmds
"""""""""""""""""""

augroup simlight
autocmd!

for file_type in keys(s:ft_rules)
    execute 'autocmd FileType ' . file_type . ' call s:simlight()'
endfor

augroup END
