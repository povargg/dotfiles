<div align="center">

# Linux-Dotfiles

**POVVIM zum Programmieren. Ein eigenes rmpc-Setup für Musik.**

[English](../README.md) · [Deutsch](README.de.md) · [Русский](README.ru.md)

[Neovim](#neovim) · [rmpc](#rmpc) · [Repo-Struktur](#repo-struktur) · [Quellen](#quellen)

</div>

Meine Linux-Konfiguration für die Arbeit im Terminal und meine lokale Musikbibliothek. POVVIM baut auf LazyVim auf. Das rmpc-Layout und das dazugehörige Theme habe ich selbst gestaltet, mit japanischen Beschriftungen, Warteschlange neben dem Cover und einer eigenen Ansicht für den Visualizer.

## Neovim

![POVVIM in Kitty mit einem ASCII-Dashboard und der Aardvark-Ink-Palette](../assets/screenshots/nvim.webp)

### Was steckt drin?

| Bereich | Konfiguration |
| --- | --- |
| Optik und Start | Eigenes **POVVIM**-ASCII-Logo im Snacks-Dashboard. Das Dashboard bietet Schnellzugriffe auf Dateien, Projekte, zuletzt geöffnete Dateien und die letzte Sitzung. Aardvark Ink ist in `init.lua` eingebettet. |
| Bearbeiten und Suchen | LazyVim liefert LSP-Integration, Treesitter, Blink-Autovervollständigung, Formatierung und Dateisuche. Sprachspezifische LazyVim-Extras lassen sich bei Bedarf hinzufügen. |
| Web-Vorschau | Live Preview zeigt HTML, Markdown, AsciiDoc und SVG im Browser an und aktualisiert die Vorschau beim Bearbeiten. Colorizer hebt Farbcodes im Editor hervor. |
| Git | `<leader>gg` öffnet Neogit. CodeDiff, Telescope und Baleia sind als Abhängigkeiten eingebunden. |
| Code und Aufgaben | TreeSJ teilt und verbindet Codeblöcke anhand ihrer Syntax. Compiler und eine festgelegte Overseer-Version stellen das Menü für Build- und Startaufgaben sowie die Ergebnisansicht bereit. Compiler oder Laufzeitumgebungen für das jeweilige Projekt installierst du separat. |
| Kommentare | Comment.nvim schaltet Kommentare um. Todo Comments hebt Markierungen wie `TODO:` und `FIXME:` hervor. Comment Divider fügt Trennzeilen ein. |

### Installation unter Linux

Vorausgesetzt sind Neovim **ab 0.11.2** mit LuaJIT, Git, curl, ripgrep (`rg`), `fd`, `fzf`, die Treesitter-CLI und ein C-Compiler. Für die Optik aus dem Screenshot eignen sich ein Terminal mit True Color und eine Nerd Font. Die Paketnamen im Beispiel gelten für Arch Linux. Führe die Befehle in Bash aus. Wenn du fish nutzt, starte dafür zuerst `bash`.

```bash
sudo pacman -S --needed neovim git curl ripgrep fd fzf tree-sitter-cli base-devel unzip
git clone https://github.com/povargg/dotfiles.git
cd dotfiles
```

Installiere das Setup aus dem Repo-Ordner als separates Profil `povvim`. Neovim verwaltet dessen Plugins, Zustand und Cache getrennt. Für eine Installation als Standardprofil sichere zuerst deine bisherige `nvim`-Konfiguration und verschiebe auch die bisherigen Daten-, Zustands- und Cache-Ordner von `nvim`. Setze anschließend `profile=nvim` im folgenden Block und starte den Editor künftig mit `nvim`.

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

Beim ersten Start lädt lazy.nvim die Plugins. Mit `:LazyHealth` prüfst du die Abhängigkeiten, mit `:Lazy restore` stellst du die Versionen aus `lazy-lock.json` wieder her und mit `:LazyExtras` kannst du Unterstützung für weitere Sprachen hinzufügen. Später startest du das separate Profil in Bash mit `NVIM_APPNAME=povvim nvim` oder in fish mit `env NVIM_APPNAME=povvim nvim`. [LazyVim-Installationsanleitung](https://www.lazyvim.org/installation)

### Wichtige Befehle

| Taste oder Befehl | Aktion |
| --- | --- |
| `<Space>gg` oder `:Neogit` | Git-Oberfläche öffnen. |
| `:LivePreview start` | Die aktuelle unterstützte Datei im Browser anzeigen. |
| `<Space>m`, `<Space>j`, `<Space>s` | Block unter dem Cursor umschalten, zusammenführen oder aufteilen. |
| `:CompilerOpen`, `:CompilerToggleResults`, `:CompilerRedo` | Build- oder Startaufgabe auswählen, Ergebnisse ein- oder ausblenden oder die letzte Aufgabe wiederholen. |
| `gcc`, `gc` im visuellen Modus | Zeilenkommentar oder Kommentare in der Auswahl umschalten. |
| `:TodoQuickFix`, `:CommentDivider` | Markierte Kommentare auflisten oder eine Trennzeile einfügen. |
| `<Space>uR` oder `:RecolOpen` | Andere Palette auswählen. Dafür muss das optionale Programm `recol` im `PATH` liegen. |
| `:RecolReload` | Den Theme-Block aus der `init.lua` dieses Profils erneut laden. |

Die mitgelieferte Farbpalette funktioniert direkt nach der Installation. Der Recol-Picker schreibt zwischen die Marker `recol:start` und `recol:end`. Die Tastenkombination lädt die Farben nach der Auswahl neu. Das aktive Setup liegt in [`nvim/`](../nvim/). Frühere Dashboard- und Farbvarianten liegen außerhalb des aktiven Plugin-Ordners in [`nvim/experiments/`](../nvim/experiments/). [Recol](https://github.com/nlkli/recol)

## rmpc

![rmpc mit japanischen Beschriftungen, Warteschlange und Cover, daneben ein CAVA-Spektrum im Terminal](../assets/screenshots/rmpc-cava.webp)

### Layout und Bedienung

- **Start · 家庭** gibt der Warteschlange 70 Prozent der Breite. Rechts stehen Cover und Liedtext. Die Kopfleiste zeigt Wiedergabestatus, Bitrate, Lautstärke, Länge der Warteschlange und Wiedergabemodi. In der Warteschlange stehen Bewertung aus MPD-Stickern, Interpret, Titel, Album und Dauer.
- **Visualizer · 見せる** zeigt Warteschlange, Liedtext und Cover über einem integrierten CAVA-Spektrum. Links im Screenshot läuft CAVA in einem eigenen Terminal.
- **Bibliothek** mit Ansichten für Ordner, Playlists, Interpreten, Alben, Albuminterpreten und Genres. Die Tag-Suche unterscheidet Groß- und Kleinschreibung nicht. Das Theme setzt auf einen dunklen Hintergrund, warme Rahmenfarben und eine rosa Fortschrittsleiste.

| Tasten | Aktion |
| --- | --- |
| `Tab` / `Shift+Tab` | Zwischen Tabs wechseln. |
| `1` bis `7` | Warteschlange, Ordner, Interpreten, Albuminterpreten, Alben, Playlists oder Suche öffnen. |
| `j` / `k`, `h` / `l` | In Listen und Browserbereichen navigieren. |
| `p`, `<` / `>`, `b` / `f` | Wiedergabe pausieren oder fortsetzen, Titel wechseln oder vor- und zurückspulen. |
| `,` / `.`, `/` | Lautstärke ändern oder den Filter öffnen. |
| `Enter`, `C`, `~` | Ausgewählten Titel spielen, zum aktuellen Titel springen oder Hilfe anzeigen. |

### Installation unter Linux

Das Setup verwendet **rmpc 0.11.0** und eine aktuelle MPD-Installation. Kitty unterstützt die Anzeige von Covern. Für die Symbole und japanische Schrift eignen sich eine Nerd Font und eine Zusatzschrift wie Noto Sans CJK.

```bash
sudo pacman -S --needed rmpc mpd mpc
```

Sichere aus dem geklonten Repo heraus zuerst vorhandene rmpc-Dateien und kopiere dann Konfiguration und Theme gemeinsam. `cp -i` fragt nach, bevor es eine Datei überschreibt.

```bash
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config_home/rmpc/themes"
cp -i rmpc/config.ron "$config_home/rmpc/config.ron"
cp -i rmpc/themes/theme.ron "$config_home/rmpc/themes/theme.ron"
```

Wenn MPD bereits eingerichtet ist, trage die Adresse deines Servers in `config.ron` ein. Für eine neue lokale Einrichtung mit PipeWire kannst du das folgende Beispiel übernehmen. Es nutzt `~/Music` und hört auf `127.0.0.1:6600`. Lege dort Musik ab oder passe `music_directory` an, bevor du MPD startest.

```bash
mkdir -p "$config_home/mpd/playlists" "$HOME/Music"
cp -i mpd/mpd.conf "$config_home/mpd/mpd.conf"
systemctl --user enable --now mpd.service
mpc -h 127.0.0.1 -p 6600 update
rmpc
```

Falls MPD vor dem Bearbeiten bereits lief, starte den Dienst vor `mpc update` mit `systemctl --user restart mpd.service` neu. Wenn du eine andere Audio-Umgebung nutzt, wähle eine von deinem MPD unterstützte Ausgabe. [MPD-Handbuch](https://mpd.readthedocs.io/en/stable/user.html) · [rmpc-Installationsanleitung](https://rmpc.mierak.dev/installation/)

<details>
<summary>Cover, Liedtexte und der optionale CAVA-Bereich</summary>

- **Cover:** Lass `album_art.method` auf `Auto` und nutze ein Terminal mit Grafikunterstützung wie Kitty. MPD liefert die Cover aus der Musikbibliothek.
- **Liedtexte:** Trage den Ordner mit deinen `.lrc`-Dateien als `lyrics_dir` in `config.ron` ein.
- **Integriertes Spektrum:** Installiere `cava`, aktiviere den auskommentierten FIFO-Ausgang in `mpd.conf` und starte MPD neu. rmpc liest `/tmp/mpd.fifo` mit 44,1 kHz, 16 Bit und Stereo. Lass den PipeWire-Ausgang für die Tonwiedergabe aktiv.
- **Separates Spektrum:** Kopiere [`cava/`](../cava/) in deinen CAVA-Konfigurationsordner und starte `cava` in einem eigenen Terminal. Die Konfiguration nutzt Terminalbalken, automatisch erkannte Audioeingabe und einen blau-rosa Verlauf. Für die Farben aus dem Screenshot speichere die Amekoji-Palette als `themes/amekoji` im CAVA-Konfigurationsordner und setze `theme = 'amekoji'` unter `[color]`. [Amekoji-Palette](https://github.com/atif-1402/omarchy-amekoji-theme/blob/main/cava_theme)

[rmpc-Konfiguration](https://rmpc.mierak.dev/configuration/) · [CAVA in rmpc einrichten](https://rmpc.mierak.dev/configuration/cava/)

</details>

## Repo-Struktur

Hier stehen die Linux-Standardpfade. Wenn `XDG_CONFIG_HOME` gesetzt ist, verwende diesen Pfad statt `~/.config`.

| Pfad | Inhalt | Ziel |
| --- | --- | --- |
| [`nvim/`](../nvim/) | POVVIM, LazyVim-Plugins, Lockfile und frühere Experimente. | `~/.config/povvim/` oder `~/.config/nvim/` |
| [`rmpc/`](../rmpc/) | Eigenes japanisch beschriftetes Layout und passendes RON-Theme. | `~/.config/rmpc/` |
| [`mpd/`](../mpd/) | Lokale MPD-Konfiguration mit PipeWire und optionalem FIFO für rmpc. | `~/.config/mpd/mpd.conf` |
| [`cava/`](../cava/) | Terminal-Spektrum, Farbverläufe und GLSL-Shader aus dem CAVA-Projekt. | `~/.config/cava/` |
| [`kitty/`](../kitty/) | end-4-Konfiguration mit ProFont IIx Nerd Font Mono in 14 pt, Suche im Terminalverlauf und Zoom-Tasten. QuickShell liefert die Desktop-Farben, wenn die generierte Datei vorhanden ist. | `~/.config/kitty/` |
| [`fish/`](../fish/) | Interaktive end-4-Konfiguration mit Starship, QuickShell-Farben und Aliasen. Ein optionales separates Skript kann Hyprland auf tty1 starten. | `~/.config/fish/` |
| [`starship.toml`](../starship.toml) | Zweizeiliger end-4-Prompt mit Befehlsdauer, Ordner und Git-Branch. | `~/.config/starship.toml` |

## Quellen

POVVIM basiert auf LazyVim und dessen Starter-Konfiguration. Aardvark Ink stammt aus Recol. Das rmpc-Layout und -Theme habe ich für den Client von mierak selbst gestaltet. Kitty, fish und Starship basieren auf end-4. Die separate CAVA-Konfiguration verbindet lokale Einstellungen mit Beispielen, Themes und Shadern aus dem CAVA-Projekt. [Quellen und Lizenzen](../THIRD_PARTY.md)
