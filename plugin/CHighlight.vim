
" Add bold to a highlight group
" See: http://stackoverflow.com/questions/1331213/how-to-modify-existing-highlight-group-in-vim
function! AddBoldToGroup(group)
    " Redirect the output of the "hi" command into a variable
    " and find the highlighting
    redir => GroupDetails
    exe "silent hi " . a:group
    redir END

    " Resolve linked groups to find the root highlighting scheme
    while GroupDetails =~ "links to"
        let index = stridx(GroupDetails, "links to") + len("links to")
        let LinkedGroup =  strpart(GroupDetails, index + 1)
        redir => GroupDetails
        exe "silent hi " . LinkedGroup
        redir END
    endwhile

    " Extract the highlighting details (the bit after "xxx")
    let MatchGroups = matchlist(GroupDetails, '\<xxx\>\s\+\(.*\)')
    let ExistingHighlight = MatchGroups[1]

    " Check whether there's an existing gui= block
    let MatchGroups = matchlist(ExistingHighlight, '^\(.\{-}\) gui=\([^ ]\+\)\( .\{-}\)\?$')
    if MatchGroups != []
        " If there is, check whether "bold" is already in it
        let StartHighlight = MatchGroups[1]
        let GuiHighlight = MatchGroups[2]
        let EndHighlight = MatchGroups[3]
        if GuiHighlight =~ '.*bold.*'
            " Already done
            return
        endif
        " Add "bold" to the gui block
        let GuiHighlight .= ',bold'
        let NewHighlight = StartHighlight . GuiHighlight . EndHighlight
    else
        " If there's no GUI block, just add one with bold in it
        let NewHighlight = ExistingHighlight . " gui=bold"
    endif

    " Create the highlighting group
    exe "hi " . a:group . " " NewHighlight
endfunction

" Check if highligt group exists
" See: http://vim.1045645.n5.nabble.com/Check-if-highlight-exists-and-not-quot-cleared-quot-td1185235.html
func s:HlExists(hl)

    if !hlexists(a:hl)
        return 0
    endif

    redir => hlstatus
    exe "silent hi" a:hl
    redir END

    return (hlstatus !~ "cleared")
endfunc

function! s:CSyntaxHighlight()

    hi def link cCustomFunc  Function

    if s:HlExists(Class)
        hi def link cCustomClass Class
    elseif s:HlExists(CTagsClass)
        hi def link cCustomClass CTagsClass
    elseif s:HlExists(CClass)
        hi def link cCustomClass CClass
    elseif s:HlExists(CTagsCClass)
        hi def link cCustomClass CTagsCClass
    elseif s:HlExists(Namespace)
        hi def link cCustomClass Namespace
    elseif s:HlExists(CTagsNamespace)
        hi def link cCustomClass CTagsNamespace
    else
        hi def link cCustomClass Function
    endif
endfunction

" Highlight Class and Function names
" See: http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim
function! s:CSyntaxMatch()

    syn match cCustomParen "("         contains=cParen,cCppParen
    syn match cCustomFunc  "\w\+\s*("  contains=cCustomParen
    syn match cCustomScope "::"
    syn match cCustomClass "\w\+\s*::" contains=cCustomScope

    s:CSyntaxHighlight()
endfunction

