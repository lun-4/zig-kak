# zig-kak

wip plugin providing zig support in kakoune

this only provides syntax highlighting and zig fmt.

## using zig fmt in kakoune

requires this plugin

```
hook global WinSetOption filetype=zig %{
    set-option window formatcmd 'zig fmt --color off --stdin'
    hook buffer BufWritePre .* %{format}
}
```
