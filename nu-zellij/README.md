# A library to wrap the Zellij terminal multiplexer in Nushell.

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
