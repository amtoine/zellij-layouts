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
    let zellij_layouts_path = (
        $env.ZELLIJ_HOME?
        | default "~/.config/zellij"
        | path join "layouts"
        | path expand
    )

    let layout = if ($zellij_layouts_path | path exists) {(
        "default" | append (
            ls ($zellij_layouts_path | path join "**" "*.kdl")
            | get name
            | str replace $"($zellij_layouts_path)(char path_sep)" ""
            | str replace '.kdl$' ""
        )
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
