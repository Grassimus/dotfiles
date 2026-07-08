# dotfiles

Personal configuration for a [Hyprland](https://hypr.land) desktop on Arch Linux. It covers the compositor, a custom status bar / shell, the terminal,
the editor, and the file manager:

| Directory | What it configures |
| --------- | ------------------ |
| `hypr/`   | [Hyprland](https://hypr.land) compositor, configured with the native Lua config format (Hyprland ≥ 0.55), plus `hypridle` (idle daemon) and `hyprlock` (screen locker). |
| `ags/`    | [AGS](https://github.com/Aylur/ags) v3 / Astal desktop shell (bar, launcher, workspace overview, quick settings, notifications, OSD, power menu and settings panel), with dynamic theming via [matugen](https://github.com/InioX/matugen). |
| `kitty/`  | [kitty](https://sw.kovidgoyal.net/kitty/) terminal emulator. |
| `nvim/`   | [Neovim](https://neovim.io) config based on [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim) (a modular fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)), using the built-in `vim.pack` plugin manager. |
| `yazi/`   | [Yazi](https://github.com/sxyazi/yazi) terminal file manager (Tokyo Night flavor). |

## Provenance

- **`nvim/`** is a live git subtree of kickstart-modular and can still pull
  upstream updates. See its own `nvim/README.md` for the authoritative setup.
- **`ags/`** and **`hypr/`** started from [ags2-shell](https://github.com/TheWolfStreet/ags2-shell)
  and an [ML4W](https://github.com/mylinuxforwork/hyprland-starter)-style
  Hyprland base, but have since diverged far enough that they no longer track
  upstream, they are maintained directly in this repo. Attribution and license
  terms are kept in each directory.

## Installation

These are `~/.config` configs. Symlink (or copy) each directory into place, e.g.:

```sh
ln -s ~/dotfiles/hypr  ~/.config/hypr
ln -s ~/dotfiles/ags   ~/.config/ags
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/nvim  ~/.config/nvim
ln -s ~/dotfiles/yazi  ~/.config/yazi
```

Most components install their own runtime pieces:

- **kitty**, **Yazi** and **Neovim** each have their own upstream install
  guides, follow those to get the program itself.
- **Neovim** bootstraps all of its plugins on first launch via the built-in
  `vim.pack` manager, and builds the ones that need it automatically.
- **Yazi** installs its bundled Tokyo Night flavor through `ya` (see
  `yazi/package.toml`).

The dependency lists below are therefore only the things you have to install yourself, mainly for the Hyprland session and the AGS shell, which have no
installer of their own.

## Dependencies

Package names below follow Arch Linux; adjust for your distribution.

### Hyprland session (`hypr/`)

- `hyprland`: required for the native Lua config format used here
- `hypridle`: idle management (`hypr/hypridle.conf`)
- `hyprlock`: screen locker (`hypr/hyprlock.conf`)
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

### AGS shell (`ags/`)

- `aylurs-gtk-shell` / `ags` (v3): the shell runtime (see `ags/package.json`)
- `matugen`: dynamic color-scheme generation
- `wayshot` and `wf-recorder`: screenshot and screen recording
- `hyprpicker`: color picker
- `libheif` (`heif-dec`): HEIF wallpaper support
- `libnotify` (`notify-send`): notifications
- `bluez-utils` (`bluetoothctl`): Bluetooth device management
- `brightnessctl`: backlight control
- `pavucontrol`: *optional*, opened from the audio quick-setting
- `tmux`: *optional*, receives the generated accent color if present
- `asusctl`: *optional*, ASUS laptop controls (power profiles, etc.)

### Neovim (`nvim/`)

Plugins install themselves, but these system tools cannot and must be present:

- `neovim` **≥ 0.12**: required for the built-in `vim.pack` manager
- `git`: plugin installation
- `ripgrep` and `fd`: Telescope / picker search
- `unzip` and a clipboard tool (`wl-clipboard`)

See `nvim/README.md` for the full, authoritative list.

### Yazi (`yazi/`)

- `yazi`: the file manager (ships with `ya`, its package manager, used to
  install the bundled flavor)
- Recommended preview helpers: `ffmpegthumbnailer`, `unarchiver` (`unar`), `jq`,
  `poppler`, `fd`, `ripgrep`, `fzf`, `zoxide`, `imagemagick`

## License

Unless a subdirectory contains its own license file, the contents of this
repository are licensed under the MIT License (see [`LICENSE`](LICENSE)).
Subdirectories with their own license are governed by that license instead:

| Subdirectory | License |
| ------------ | ------- |
| `ags/` | **CC BY-NC 4.0** (Creative Commons Attribution-NonCommercial): see `ags/LICENSE`. Note this is a *non-commercial* license. |
| `hypr/` | **GPL-3.0**: see `hypr/LICENSE`. |
| `nvim/` | MIT: see `nvim/LICENSE.md`. |
| `yazi/flavors/tokyonight-night.yazi/` | MIT: bundled third-party flavor, see its `LICENSE`. |
