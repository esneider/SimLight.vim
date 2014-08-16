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
\   'vim':        ['vimFunction', 'vimFuncName', 'vimUserFunc', 'vimExecute'],
\}

call extend(s:contained, get(g:, 'simlight_contained', {}))

""""""""""""""""""""""""
" Simple syntax matching
""""""""""""""""""""""""

let s:marker_context = {
\   'after':  ['', '\zs\w\+'],
\   'before': ['\w\+\ze', ''],
\}

function! s:simlight()

    if !has_key(s:ft_rules, &filetype)
        return
    endif

    " We might be inside another highlight group, so add the necessary flags
    let contained = [''] + get(s:contained, &filetype, [])
    let flags = join(contained, ' containedin=')

    " Cycle all the rules for this &filetype
    let rules = get(s:ft_rules, &filetype, {})

    for [pattern, hi_group] in items(rules)

        let tokens = matchlist(pattern, '\v\c^(After|Before)(.*)')
        let marker = get(s:markers, get(tokens, 2, ''), '')

        if empty(marker)
            continue
        endif

        let rule_name = &filetype . pattern

        " The match string is the marker inside its corresponding context
        let match = '\V' . join(s:marker_context[tolower(tokens[1])], marker)

        execute 'syntax match ' . rule_name . ' "' . match . '" ' . flags
        execute 'highlight default link ' . rule_name . ' ' . hi_group
    endfor
endf

augroup simlight
    autocmd!
    autocmd FileType * call s:simlight()
augroup END
