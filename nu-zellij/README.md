# A library to wrap the Zellij terminal multiplexer in Nushell.

## :gear: installation
for now, the only way to install this is manually
- `git clone https://github.com/amtoine/zellij-layouts /path/to/zellij-layouts`
- use the [`nu-git-manager` package](https://github.com/amtoine/nu-git-manager)

## :exclamation: some (not so) advanced ideas

in my `config.nu` i use the following keybinding to open Zellij inside a layout:
```nu
{
    name: run_zellij
    modifier: control
    keycode: char_z
    mode: [emacs, vi_insert, vi_normal]
    event: {
        send: executehostcommand
        cmd: "nu-zellij open layout --default-shell nu"
    }
}
```

> **Note**  
> the module needs to be loaded with `use nu-zellij`

in my `config.nu`, anywhere, it does not really matter because the keybinding will run
once Nushell has started, i have
```nu
use /path/to/zellij-layouts/nu-zellij
$env.ZELLIJ_HOME = /path/to/zellij-layouts
```
