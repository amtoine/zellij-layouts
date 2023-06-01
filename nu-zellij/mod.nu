def zellij-layouts-path [] {
    $env.ZELLIJ_HOME?
    | default "~/.config/zellij"
    | path join "layouts"
    | path expand
}

def list-layouts [path: path] {
    ls ($path | path join "**" "*.kdl")
    | get name
    | str replace $"($path)(char path_sep)" ""
    | str replace '.kdl$' ""
}

# open a layout from a fuzzy list of all available layouts
#
# the layouts are listed recursively from `ZELLIJ_HOME/layouts/`.
# the `default` layout is prepended to the list, to allow running `zellij` without any particular
# layout by pressing enter!
#
# Environment:
#     - ZELLIJ_HOME: the path to the `zellij` configuration folder (defaults to `~/.config/zellij/`)
export def "layout open" [
    --default-shell: string = "nu"  # the default shell to run `zellij` in
] {
    let zellij_layouts_path = (zellij-layouts-path)

    let layout = if ($zellij_layouts_path | path exists) {(
        "default" | append (list-layouts $zellij_layouts_path)
        | input list --fuzzy
            $"Please (ansi green_bold)choose a layout(ansi reset) to launch ('zellij' | nu-highlight) in:"
    )} else { "default" }

    if ($layout | is-empty) {
        error make --unspanned {
            msg: "no layout selected"
        }
    }

    let layout = if $layout == "default" { $layout } else {
        {
            parent: $zellij_layouts_path
            stem: $layout
            extension: "kdl"
        } | path join
    }

    zellij --layout $layout options --default-shell $default_shell
}


# preview a layout from its inline documentation
export def "layout preview" [] {
    let zellij_layouts_path = (zellij-layouts-path)

    if not ($zellij_layouts_path | path exists) {
        error make --unspanned {
            msg: $"no layout found in ($zellij_layouts_path)"
        }
    }

    let layout = (
        list-layouts $zellij_layouts_path
        | input list --fuzzy
            $"Please (ansi green_bold)choose a layout(ansi reset) to preview:"
    )

    if ($layout | is-empty) {
        error make --unspanned {
            msg: "no layout selected"
        }
    }

    {
        parent: $zellij_layouts_path
        stem: $layout
        extension: "kdl"
    } | path join
    | open --raw
    | lines
    | find --regex '^//'
    | str replace '^//\s*' ''
    | str join "\n"
}
