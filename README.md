SimLight.vim
============

Vim plugin for simple, extensible highlighting (by regex matching) of functions,
namespaces, memers and such.


Options
-------
Options provided to fully configure and extend the plugin within its reach. For
a more sophisticated syntax highlighting scheme, you should consider a ctags
based plugin, such as
[vimscript #2646](http://www.vim.org/scripts/script.php?script_id=2646).

### The `g:simlight_prefix_rules` option

A dictionary with extra prefix rules. The prefix rule key should be its name,
and the value should be a string with the prefix (a vim regex, actually).

**Default:**
```
{
    'Member': '.',
    'PointerMember': '->',
}
```

### The `g:simlight_postfix_rules` option

This option behaves exactly like `g:simlight_prefix_rules` but matches postfixes
instead of prefixes.

**Default:**
```
{
    'Function': '(',
    'Namespace': '::',
    'Array': '[',
}
```

### The `g:simlight_highlight_groups` option

A dictionary with extra highlight groups for rules. An entry's key should be a rule name,
and its value a list of highlight groups.

**Notes:**
* For each rule, only the first existing group will be used.
* The provided groups will be checked before the default ones.

**Default:**
```
{
    'Function':     ['CTagsFunction', 'Function'],
    'Namespace':    ['CTagsNamespace', 'Namespace', 'CTagsClass', 'Class', 'Type'],
    'Array':        ['Identifier'],
    'Member':       ['CTagsMember', 'Identifier'],
    'PoiterMember': ['CTagsMember', 'Identifier'],
}
```

### The `g:simlight_file_rules` option

A dictionary with the rules for each file type. An entry's key should be a file type, and
its value a list of rule names to apply.

By using this option, you can add new file types, or override existing ones.

**Default:**
```
{
    'c':          ['Function', 'Namespace'],
    'cpp':        ['Function', 'Namespace'],
    'javascript': ['Function'],
    'csharp':     ['Function'],
    'java':       ['Function'],
    'python':     ['Function'],
    'octave':     ['Function'],
    'php':        ['Function'],
    'vim':        ['Function'],
}
```
