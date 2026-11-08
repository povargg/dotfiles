<div align="center">

# Linux Dotfiles

**POVVIM for coding. A custom rmpc setup for music.**

[English](README.md) · [Deutsch](docs/README.de.md) · [Русский](docs/README.ru.md)

[Neovim](#neovim) · [rmpc](#rmpc) · [Repository layout](#repository-layout) · [Credits](#credits)

</div>

My Linux configuration for working in the terminal and listening to a local music library. POVVIM builds on LazyVim. I designed the rmpc layout and theme myself, with Japanese labels, a queue next to the cover art and a separate visualizer view.

## Neovim

![POVVIM in Kitty with an ASCII dashboard and the Aardvark Ink palette](assets/screenshots/nvim.webp)

### What’s included

| Area | Configuration |
| --- | --- |
| Look and startup | A custom **POVVIM** ASCII header in the Snacks dashboard, with shortcuts for files, projects, recent files and session restore. The Aardvark Ink palette is already embedded in `init.lua`. |
| Editing and search | LazyVim provides LSP integration, Treesitter, Blink completion, formatting infrastructure and the file and text pickers. No language-specific LazyVim extras are preselected. |
| Web preview | Live Preview opens HTML, Markdown, AsciiDoc or SVG in a browser and updates while you edit. Colorizer highlights color codes in the buffer. |
| Git | Neogit is bound to `<leader>gg`, with CodeDiff, Telescope and Baleia included as dependencies. |
| Code and tasks | TreeSJ joins and splits syntax-aware blocks. Compiler and a pinned Overseer revision provide the build/run menu and a results pane. Install the compiler or runtime required by your project separately. |
| Comments | Comment.nvim toggles comments, Todo Comments highlights annotations such as `TODO:` and `FIXME:`, and Comment Divider inserts section separators. |

### Install on Linux

Use Neovim **0.11.2 or newer** with LuaJIT, Git, curl, ripgrep (`rg`), `fd`, `fzf`, the Treesitter CLI and a C compiler. A true-color terminal and a Nerd Font help reproduce the look. Package names below are for Arch Linux. Run the shell blocks in Bash, including if your login shell is fish.

```bash
sudo pacman -S --needed neovim git curl ripgrep fd fzf tree-sitter-cli base-devel unzip
git clone https://github.com/povargg/dotfiles.git
cd dotfiles
```

From the repository root, install into a separate `povvim` profile. Neovim keeps that profile’s plugins, state and cache separate. To make the setup your default, back up your current `nvim` config and move the existing `nvim` data, state and cache directories aside first. Then change `profile=povvim` to `profile=nvim` and launch with `nvim` afterward.

```bash
profile=povvim
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
target="$config_home/$profile"

mkdir -p "$config_home"
if [ -e "$target" ] || [ -L "$target" ]; then
    printf 'Back up the existing config first: %s\n' "$target" >&2
else
    cp -a nvim "$target" && NVIM_APPNAME="$profile" nvim
fi
```

On first launch, lazy.nvim downloads the plugins. Run `:LazyHealth` to check dependencies, `:Lazy restore` to restore the versions recorded in `lazy-lock.json`, and `:LazyExtras` to add language tooling as needed. For later launches of the isolated profile, use `NVIM_APPNAME=povvim nvim` in Bash or `env NVIM_APPNAME=povvim nvim` in fish. [LazyVim installation guide](https://www.lazyvim.org/installation)

### Useful commands

| Key or command | Action |
| --- | --- |
| `<Space>gg` or `:Neogit` | Open the Git interface. |
| `:LivePreview start` | Preview the current supported file in a browser. |
| `<Space>m`, `<Space>j`, `<Space>s` | Toggle, join or split the block under the cursor. |
| `:CompilerOpen`, `:CompilerToggleResults`, `:CompilerRedo` | Pick a build or run task, toggle results or rerun the last task. |
| `gcc`, `gc` in Visual mode | Toggle a line comment or comment the selected lines. |
| `:TodoQuickFix`, `:CommentDivider` | List TODO-style annotations or insert a comment divider. |
| `<Space>uR` or `:RecolOpen` | Pick a different palette. The optional `recol` executable must be on `PATH`. |
| `:RecolReload` | Reapply the theme block from this profile’s `init.lua`. |

The embedded palette works immediately. The Recol picker writes between the `recol:start` and `recol:end` markers and the keymap reloads those highlights on selection. The active setup lives in [`nvim/`](nvim/). Older dashboard and color experiments live outside the active plugin directory in [`nvim/experiments/`](nvim/experiments/). [Recol](https://github.com/nlkli/recol)

## rmpc

![Custom rmpc queue with Japanese labels and album art, next to a standalone CAVA spectrum](assets/screenshots/rmpc-cava.webp)

### Layout and controls

- **Home · 家庭** gives the queue 70% of the width, with album art and lyrics on the right. A custom header shows playback state, bitrate, volume, queue length and playback modes. The queue has a rating column backed by MPD stickers, plus artist, title, album and duration.
- **Showcase · 見せる** places the queue, lyrics and cover art above an integrated CAVA spectrum. The screenshot shows the separate CAVA terminal on the left.
- **Library views** include directories, playlists, artists, albums, album artists, genres and a case-insensitive tag search. The theme uses a dark background, warm borders and a pink progress bar.

| Keys | Action |
| --- | --- |
| `Tab` / `Shift+Tab` | Cycle through the tabs. |
| `1` to `7` | Jump to queue, directories, artists, album artists, albums, playlists or search. |
| `j` / `k`, `h` / `l` | Move through lists and browser panes. |
| `p`, `<` / `>`, `b` / `f` | Play or pause, switch tracks, or seek. |
| `,` / `.`, `/` | Change volume or enter the filter. |
| `Enter`, `C`, `~` | Play the selected queue track, jump to the current track, or show help. |

### Install on Linux

This configuration uses **rmpc 0.11.0** and a recent MPD installation. Kitty supports the cover-art protocol. For the glyphs shown here, use a Nerd Font and a Japanese-capable fallback such as Noto Sans CJK.

```bash
sudo pacman -S --needed rmpc mpd mpc
```

From the cloned repository, back up any existing rmpc files and copy the config and the theme together. The copy commands prompt before overwriting a file.

```bash
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config_home/rmpc/themes"
cp -i rmpc/config.ron "$config_home/rmpc/config.ron"
cp -i rmpc/themes/theme.ron "$config_home/rmpc/themes/theme.ron"
```

If MPD is already configured, use your existing server and match its address in `config.ron`. For a fresh local setup on a PipeWire desktop, install the example below. It uses `~/Music` and listens on `127.0.0.1:6600`. Put some music in that directory or edit `music_directory` to match your library before starting MPD.

```bash
mkdir -p "$config_home/mpd/playlists" "$HOME/Music"
cp -i mpd/mpd.conf "$config_home/mpd/mpd.conf"
systemctl --user enable --now mpd.service
mpc -h 127.0.0.1 -p 6600 update
rmpc
```

If MPD was running before you edited its config, restart it with `systemctl --user restart mpd.service` before running `mpc update`. Use an output supported by your installation if you run a different audio stack. [MPD user manual](https://mpd.readthedocs.io/en/stable/user.html) · [rmpc installation guide](https://rmpc.mierak.dev/installation/)

<details>
<summary>Cover art, lyrics and the optional CAVA pane</summary>

- **Cover art:** Leave `album_art.method` on `Auto` and use a graphics-capable terminal like Kitty. Cover art comes from MPD’s music library.
- **Lyrics:** The layout has a lyrics pane. Set `lyrics_dir` in `config.ron` to the location of your `.lrc` files.
- **Integrated spectrum:** Install `cava`, uncomment the optional FIFO output in `mpd.conf` and restart MPD. rmpc reads `/tmp/mpd.fifo` at 44.1 kHz, 16-bit stereo. Keep the PipeWire output enabled for sound.
- **Standalone spectrum:** Copy the [`cava/`](cava/) configuration into your CAVA config directory and launch `cava` in a separate terminal. It uses terminal bars, auto-detected audio input and a blue-to-rose gradient. To match the screenshot, save the original Amekoji palette as `themes/amekoji` in the CAVA config directory and set `theme = 'amekoji'` under `[color]`. [Amekoji palette](https://github.com/atif-1402/omarchy-amekoji-theme/blob/main/cava_theme)

[rmpc configuration](https://rmpc.mierak.dev/configuration/) · [rmpc and CAVA setup](https://rmpc.mierak.dev/configuration/cava/)

</details>

## Repository layout

Default Linux paths are shown below. Use your `XDG_CONFIG_HOME` in place of `~/.config` if set.

| Path | What it contains | Config destination |
| --- | --- | --- |
| [`nvim/`](nvim/) | POVVIM, LazyVim specs, lockfile and archived experiments. | `~/.config/povvim/` or `~/.config/nvim/` |
| [`rmpc/`](rmpc/) | Original Japanese-labeled client layout and matching RON theme. | `~/.config/rmpc/` |
| [`mpd/`](mpd/) | Local PipeWire setup with an optional FIFO for rmpc. | `~/.config/mpd/mpd.conf` |
| [`cava/`](cava/) | Terminal spectrum settings, gradient presets and upstream GLSL shaders. | `~/.config/cava/` |
| [`kitty/`](kitty/) | end-4 based terminal config with ProFont IIx Nerd Font Mono at 14 pt, scrollback search and zoom shortcuts. The QuickShell include supplies desktop-matched colors when available. | `~/.config/kitty/` |
| [`fish/`](fish/) | end-4 interactive shell setup with Starship, QuickShell colors and aliases. Includes a separate optional tty1 Hyprland helper. | `~/.config/fish/` |
| [`starship.toml`](starship.toml) | end-4 two-line prompt with command duration, directory and Git branch. | `~/.config/starship.toml` |

## Credits

POVVIM is based on LazyVim and its starter. Aardvark Ink is supplied by Recol. I designed the rmpc layout and theme using mierak’s rmpc client. Kitty, fish and Starship use end-4’s configuration as their base. The standalone CAVA configuration combines local settings with upstream examples, themes and shaders. Source and license details are collected in [Third-party credits](THIRD_PARTY.md).
