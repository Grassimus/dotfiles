# dotfiles

Personal configuration for a [Hyprland](https://hypr.land) desktop on Arch Linux. It covers the compositor, a custom status bar / shell, the terminal,
the editor, and the file manager:

| Directory | What it configures |
| --------- | ------------------ |
| `hypr/`   | [Hyprland](https://hypr.land) compositor, configured with the native Lua config format (Hyprland ≥ 0.55), plus `hypridle` (idle daemon) and `hyprlock` (screen locker). |
| `kitty/`  | [kitty](https://sw.kovidgoyal.net/kitty/) terminal emulator. |
| `nvim/`   | [Neovim](https://neovim.io) config based on [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim) (a modular fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)), using the built-in `vim.pack` plugin manager. |
| `yazi/`   | [Yazi](https://github.com/sxyazi/yazi) terminal file manager. |
| `dms/`   | [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) (DMS), the Quickshell-based bar and shell. |

## Provenance

- **`nvim/`** started from [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim) (a modular fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)), and is now maintained directly here rather than tracking upstream. MIT attribution is kept in `nvim/LICENSE.md`.
- **`hypr/`** started from and an [ML4W](https://github.com/mylinuxforwork/hyprland-starter)-style
  Hyprland base and has since diverged. License terms are in `hypr/LICENSE`.


## Installation

These are `~/.config` configs. Symlink (or copy) each directory into place, e.g.:

```sh
ln -s ~/dotfiles/hypr  ~/.config/hypr
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/nvim  ~/.config/nvim
ln -s ~/dotfiles/yazi  ~/.config/yazi
ln -s ~/dotfiles/dms/settings.json   ~/.config/DankMaterialShell/settings.json
```

Most components install their own runtime pieces:

- **kitty**, **Yazi** and **Neovim** each have their own upstream install
  guides, follow those to get the program itself.
- **Neovim** bootstraps all of its plugins on first launch via the built-in
  `vim.pack` manager, and builds the ones that need it automatically.

The dependency lists below are therefore only the things you have to install
yourself, mainly for the Hyprland session, which has no installer of its own.

## Dependencies

Package names below follow Arch Linux; adjust for your distribution.

### Hyprland session (`hypr/`)

- `hyprland`: required for the native Lua config format used here
- `hypridle`: idle management (`hypr/hypridle.conf`)
- `hyprlock`: screen locker (`hypr/hyprlock.conf`)
- `dms-shell`: DankMaterialShell, started on login (see below)
- `awww`: wallpaper daemon (`awww-daemon`, started on login)
- `xorg-xrdb`: merges `~/.Xresources` on startup

### Keybind / utility programs

Referenced from `hypr/conf/binds.lua` and `autostart.lua`:

- `kitty`: terminal (also configured here)
- `thunar`: graphical file manager
- `brave`: web browser
- `grim` + `slurp`: region screenshots
- `wl-clipboard` (`wl-copy`): Wayland clipboard
- `wireplumber` / `pipewire` (`wpctl`): audio volume & mute
- `brightnessctl`: backlight control (also used by `hypridle`)
- `networkmanager` (`nmcli`): Wi-Fi toggle
- `wtype`: sends the `F5` refresh key (`XF86Refresh` bind)


### DankMaterialShell (`dms/`)

```sh
sudo pacman -S dms-shell matugen cava qt6-multimedia
```

`matugen` is optional upstream but required here, since this config gets its
colors from it. `cava` (visualizer) and `qt6-multimedia` (sound feedback) are
optional. `quickshell` and `dgop` come in as dependencies of `dms-shell`.

Optionally, for the login screen:

```sh
paru -S greetd-dms-greeter-bin
dms-greeter install
```

`dms run` is started from `hypr/conf/autostart.lua`, and `SUPER + space` is
rebound to its launcher in `hypr/dms/binds-user.lua`.

DMS drives the color scheme for the rest of the setup: its matugen templates
generate `kitty/dank-theme.conf`, `hypr/dms/*.lua` and `nvim/colors/dms.lua`
(gitignored) from the wallpaper. **Those files are overwritten in place**, so
expect the repo to go dirty whenever the wallpaper or theme changes. Which
templates run is part of `dms/settings.json`.

Because of this, kitty's own theme (`kitty/current-theme.conf`) is disabled.
Yazi follows the terminal palette, with a few color remapping tweaks in
`yazi/theme.toml`.

### Neovim (`nvim/`)

Plugins install themselves, but these system tools cannot and must be present:

- `neovim` **≥ 0.12**: required for the built-in `vim.pack` manager
- `git`: plugin installation
- `ripgrep` and `fd`: Telescope / picker search
- `unzip` and a clipboard tool (`wl-clipboard`)

See `nvim/README.md` for the full, authoritative list.

### Yazi (`yazi/`)

- `yazi`: the file manager
- Recommended preview helpers: `ffmpegthumbnailer`, `unarchiver` (`unar`), `jq`,
  `poppler`, `fd`, `ripgrep`, `fzf`, `zoxide`, `imagemagick`

## License

Unless a subdirectory contains its own license file, the contents of this
repository are licensed under the MIT License (see [`LICENSE`](LICENSE)).
Subdirectories with their own license are governed by that license instead:

| Subdirectory | License |
| ------------ | ------- |
| `hypr/` | **GPL-3.0**: see `hypr/LICENSE`. |
| `nvim/` | MIT: see `nvim/LICENSE.md`. |
