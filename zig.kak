# zig.kak plugin
# author: lun-4
#
# based on the rust.zig builtin plugin

hook global BufCreate .*[.]zig %{
    set-option buffer filetype zig
}

hook global WinSetOption filetype=zig %[
    require-module zig
    hook window ModeChange pop:insert:.* -group zig-trim-indent zig-trim-indent
    hook window InsertChar \n -group zig-indent zig-indent-on-new-line
    hook window InsertChar \{ -group zig-indent zig-indent-on-opening-curly-brace
    hook window InsertChar [)}] -group zig-indent zig-indent-on-closing
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window zig-.+ }
]

hook -group zig-highlight global WinSetOption filetype=zig %{
    add-highlighter window/zig ref zig
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/zig }
}

provide-module zig %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/zig regions
add-highlighter shared/zig/code default-region group
add-highlighter shared/zig/string           region %{(?<!')"} (?<!\\)(\\\\)*"              fill string
add-highlighter shared/zig/raw_string       region -match-capture %{(?<!')r(#*)"} %{"(#*)} fill string
add-highlighter shared/zig/line_comment     region "//" "$"                                fill comment

add-highlighter shared/zig/code/byte_literal         regex "'\\\\?.'" 0:value
add-highlighter shared/zig/code/long_quoted          regex "('\w+)[^']" 1:meta
add-highlighter shared/zig/code/field_or_parameter   regex (_?\w+)(?::)(?!:) 1:variable
# add-highlighter shared/zig/code/namespace            regex [a-zA-Z](\w+)?(\h+)?(?=::) 0:module
# add-highlighter shared/zig/code/field                regex ((?<!\.\.)(?<=\.))_?[a-zA-Z]\w*\b 0:meta
# add-highlighter shared/zig/code/function_call        regex _?[a-zA-Z]\w*\s*(?=\() 0:function
add-highlighter shared/zig/code/user_defined_type    regex \b[A-Z]\w*\b 0:type
add-highlighter shared/zig/code/function_declaration regex (?:fn\h+)(_?\w+)(?:<[^>]+?>)?\( 1:function
add-highlighter shared/zig/code/variable_declaration regex (?:var|const)(_?\w+) 1:variable
# add-highlighter shared/zig/code/macro                regex \b[A-z0-9_]+! 0:meta


add-highlighter shared/zig/code/values regex \b(?:true|false|[0-9][_0-9]*(?:\.[0-9][_0-9]*|(?:\.[0-9][_0-9]*)?E[\+\-][_0-9]+)(?:f(?:32|64))?|(?:0x[_0-9a-fA-F]+|0o[_0-7]+|0b[_01]+|[0-9][_0-9]*)(?:(?:i|u|f)(?:8|16|32|64|128|size))?)\b 0:value
add-highlighter shared/zig/code/attributes regex \b(?:struct|enum|type|const)\b 0:attribute

add-highlighter shared/zig/code/keywords             regex \b(?:fn|return|if|else|while|for|break|continue|pub||async|await|export|extern|comptime)\b 0:keyword
add-highlighter shared/zig/code/builtin_types        regex \b(?:usize|isize|bool)\b 0:type
add-highlighter shared/zig/code/integer_types        regex \b(?:i|u)(\d+)\b 0:type
add-highlighter shared/zig/code/float_types          regex \b(?:f32|f64)\b 0:type
add-highlighter shared/zig/code/return               regex \breturn\b 0:meta

set-face global builtin_function cyan

add-highlighter shared/zig/code/builtin_functions regex @(import|breakpoint|returnAddress)\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @(memcpy|memset|sizeOf)\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @alignOf\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @memberCount\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @memberType\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @memberName\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @field\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @typeInfo\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @Type\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @hasField\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @TypeOf\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @addWithOverflow\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @subWithOverflow\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @mulWithOverflow\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @shlWithOverflow\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @cInclude\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @cDefine\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @cUndef\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @ctz\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @clz\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @popCount\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @byteSwap\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @bitReverse\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @import\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @cImport\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @errorName\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @typeName\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @embedFile\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @cmpxchgWeak\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @cmpxchgStrong\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @fence\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @truncate\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @intCast\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @floatCast\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @intToFloat\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @floatToInt\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @boolToInt\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @errorToInt\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @intToError\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @enumToInt\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @intToEnum\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @compileError\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @compileLog\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @IntType\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @Vector\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @shuffle\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @splat\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @setCold\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @setRuntimeSafety\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @setFloatMode\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @panic\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @ptrCast\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @bitCast\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @intToPtr\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @ptrToInt\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @tagName\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @TagType\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @fieldParentPtr\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @byteOffsetOf\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @bitOffsetOf\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @divExact\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @divTrunc\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @divFloor\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @rem\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @mod\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @sqrt\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @sin\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @cos\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @exp\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @exp2\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @log\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @log2\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @log10\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @fabs\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @floor\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @ceil\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @trunc\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @nearbyInt\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @round\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @mulAdd\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @newStackCall\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @asyncCall\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @typeId\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @shlExact\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @shrExact\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @setEvalBranchQuota\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @alignCast\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @OpaqueType\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @setAlignStack\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @ArgType\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @export\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @errorReturnTrace\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @atomicRmw\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @atomicLoad\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @atomicStore\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @errSetCast\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @sliceToBytes\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @bytesToSlice\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @This\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @hasDecl\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @unionInit\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @frame\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @Frame\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @frameAddress\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @frameSize\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @as\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @call\b 0:builtin_function
add-highlighter shared/zig/code/bulitin_functions regex @bitSizeOf\b 0:builtin_function

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden zig-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
}

define-command -hidden zig-indent-on-new-line %~
    evaluate-commands -draft -itersel %<
        # copy // comments prefix and following white spaces
        try %{ execute-keys -draft k <a-x> s ^\h*\K//[!/]?\h* <ret> y gh j P }
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon> K <a-&> }
        # filter previous line
        try %{ execute-keys -draft k : zig-trim-indent <ret> }
        # indent after lines ending with { or (
        try %[ execute-keys -draft k <a-x> <a-k> [{(]\h*$ <ret> j <a-gt> ]
        # indent after lines ending with [{(].+ and move first parameter to own line
        try %< execute-keys -draft [c[({],[)}] <ret> <a-k> \A[({][^\n]+\n[^\n]*\n?\z <ret> L i<ret><esc> <gt> <a-S> <a-&> >
    >
~

define-command -hidden zig-indent-on-opening-curly-brace %[
    evaluate-commands -draft -itersel %_
        # align indent with opening paren when { is entered on a new line after the closing paren
        try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
    _
]

define-command -hidden zig-indent-on-closing %[
    evaluate-commands -draft -itersel %_
        # align to opening curly brace or paren when alone on a line
        try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
    _
]

§
