"""""""""""""""""
" Default options
"""""""""""""""""

let s:tokens = {
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

call extend(s:tokens, get(g:, 'simlight_tokens', {}))

let s:ft_rules = {
\    'c':          ['BeforeLParen'],
\    'cpp':        ['BeforeLParen', 'BeforeDoubleColon'],
\    'cs':         ['BeforeLParen'],
\    'd':          ['BeforeLParen'],
\    'javascript': ['BeforeLParen'],
\    'java':       ['BeforeLParen'],
\    'lua':        ['BeforeLParen'],
\    'matlab':     ['BeforeLParen'],
\    'objc':       ['BeforeLParen'],
\    'perl':       ['BeforeLParen'],
\    'python':     ['BeforeLParen'],
\    'r':          ['BeforeLParen'],
\    'ruby':       ['BeforeLParen'],
\    'vim':        ['BeforeLParen'],
\}

call extend(s:ft_rules, get(g:, 'simlight_ft_rules', {}))

let s:contained = {
\   'd':      ['paramlist'],
\   'java':   ['javaParenT', 'javaParenT1', 'javaParentT2'],
\   'objc':   ['objcBlocks'],
\   'python': ['pythonFunction'],
\   'vim':    ['vimFuncBody', 'vimFunction', 'vimFuncName', 'vimUserFunc', 'vimExecute'],
\}

call extend(s:contained, get(g:, 'simlight_contained', {}))

""""""""""""""""""""""""
" Simple syntax matching
""""""""""""""""""""""""

function! s:highlight(rules, contained)

    let dict = {
    \   'b': ['\w\+\ze', ''],
    \   'B': ['\w\+\ze', ''],
    \   'a': ['', '\zs\w\+'],
    \   'A': ['', '\zs\w\+'],
    \}

    for rule in a:rules

        let str = matchlist(rule, '\v\c^(Before|After)(.*)')
        if !empty(str)
            let pat = dict[str[1][0]]

            let cmd  = 'syntax match ' . rule . ' '
            let cmd .=     '"\V' . pat[0] . s:tokens[str[2]] . pat[1] . '" '
            let cmd .= a:contained

            execute cmd
        endif
    endfor
endf

function! s:simlight()

    augroup simlight
    autocmd!

    for rule in items(s:ft_rules)

        let contained = [''] + get(s:contained, rule[0], [])

        let cmd  = 'autocmd FileType,ColorScheme ' . rule[0] . ' '
        let cmd .=     'call s:highlight('
        let cmd .=         '["' . join(rule[1], '", "') . '"], '
        let cmd .=         '"' . join(contained, ' containedin=') . '"'
        let cmd .=     ')'

        execute cmd
    endfor

    augroup END
endf

call s:simlight()
