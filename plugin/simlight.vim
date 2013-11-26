"""""""""""""""""
" Default options
"""""""""""""""""


let s:prefix_rules = {
\    'Member': '.',
\    'PointerMember': '->',
\}


if exists('g:simlight_prefix_rules')
    call extend(s:prefix_rules, g:simlight_prefix_rules)
endif


let s:postfix_rules = {
\    'Function': '(',
\    'Namespace': '::',
\    'Array': '[',
\}


if exists('g:simlight_postfix_rules')
    call extend(s:postfix_rules, g:simlight_postfix_rules)
endif


let s:highlight_groups = {
\    'Function':     ['SLFunction', 'CTagsFunction', 'Function'],
\    'Namespace':    ['SLNamespace', 'CTagsNamespace', 'Namespace', 'CTagsClass', 'Class', 'Type', 'Namespace'],
\    'Array':        ['SLArray', 'Identifier'],
\    'Member':       ['SLMember', 'CTagsMember', 'Identifier'],
\    'PoiterMember': ['SLPointerMember', 'SLMember', 'CTagsMember', 'Identifier'],
\}


if exists('g:simlight_highlight_groups')
    for item in items(g:simlight_highlight_groups)
        if has_key(s:highlight_groups, item[0])
            let item[1] += s:highlight_groups[item[0]]
        endif
        let s:highlight_groups[item[0]] = item[1]
    endfor
endif


let s:file_rules = {
\    'c':          ['Function'],
\    'cpp':        ['Function', 'Namespace'],
\    'javascript': ['Function'],
\    'csharp':     ['Function'],
\    'java':       ['Function'],
\    'python':     ['Function'],
\    'matlab':     ['Function'],
\    'php':        ['Function'],
\    'vim':        ['Function'],
\}


if exists('g:simlight_file_rules')
    call extend(s:file_rules, g:simlight_file_rules)
endif


let s:file_contained_in = {
\   'java':   ['javaParenT', 'javaParenT1', 'javaParentT2'],
\   'python': ['pythonFunction'],
\   'vim':    ['vimFuncBody', 'vimFunction', 'vimFuncName', 'vimUserFunc', 'vimExecute'],
\}


if exists('g:simlight_file_contained_in')
    call extend(s:file_contained_in, g:simlight_file_contained_in)
endif
call map(s:file_contained_in, 'insert(v:val, "")')


""""""""""""""""""""""""
" Simple syntax matching
""""""""""""""""""""""""


" Based on http://stackoverflow.com/a/773392/530680
function! s:matchPrefix(name, prefix, contained_in)
    execute 'syntax match SL'.a:name.' "'.a:prefix.'\zs\w\+"'.a:contained_in
endfunction


function! s:matchPostfix(name, postfix, contained_in)
    execute 'syntax match SL'.a:name.' "\w\+\ze'.a:postfix.'"'.a:contained_in
endfunction


"""""""""""""""""""""
" Syntax highlighting
"""""""""""""""""""""


" See: https://groups.google.com/d/msg/vim_use/8r5_jx_tnnM/LzM29RQT-88J
function! s:hlexists(hlgroup)
    if !hlexists(a:hlgroup)
        return 0
    endif
    redir => hlstatus
        execute "silent highlight" a:hlgroup
    redir END
    return (hlstatus !~ "cleared")
endfunction


function! s:highlightMatch(match, hlgroups)
    for hlgroup in a:hlgroups
        if s:hlexists(hlgroup)
            execute 'highlight default link SL'.a:match.' '.hlgroup
            return
        endif
    endfor
endfunction


function! s:highlight(rules, contained_in)
    for rule in a:rules
        if has_key(s:prefix_rules, rule)
            call s:matchPrefix(rule, s:prefix_rules[rule], a:contained_in)
        elseif has_key(s:postfix_rules, rule)
            call s:matchPostfix(rule, s:postfix_rules[rule], a:contained_in)
        else
            continue
        endif
        if has_key(s:highlight_groups, rule)
            call s:highlightMatch(rule, s:highlight_groups[rule])
        endif
    endfor
endfunction


""""""""""""""
" Autocommands
""""""""""""""


function! s:simlight()
    for rule in items(s:file_rules)
        let contained_in = ''
        if has_key(s:file_contained_in, rule[0])
            let contained_in = join(s:file_contained_in[rule[0]], ' containedin=')
        endif
        execute 'autocmd Syntax '.rule[0].' call s:highlight(["'.join(rule[1], '","').'"], "'.contained_in.'")'
    endfor
endfunction


autocmd VimEnter,ColorScheme * call s:simlight()

