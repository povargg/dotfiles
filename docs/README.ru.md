# Конфигурации для Linux

[English](../README.md) · [Deutsch](README.de.md) · [Русский](README.ru.md)

## Neovim

POVVIM собран на базе LazyVim. У него свой стартовый экран и цветовая схема Aardvark Ink из Recol. С Git можно работать через Neogit, а для HTML и Markdown есть предпросмотр в браузере.

![Стартовый экран POVVIM](../assets/screenshots/nvim.webp)

### Установка в Linux

Понадобится Neovim **0.11.2 или новее** с LuaJIT, Git, curl, ripgrep (`rg`), `fd`, `fzf`, Treesitter CLI и компилятор C. Для оформления со скриншота пригодятся терминал с поддержкой True Color и Nerd Font. В примере указаны пакеты Arch Linux. Команды рассчитаны на Bash. Если вы используете fish, сначала запустите `bash`.

```bash
sudo pacman -S --needed neovim git curl ripgrep fd fzf tree-sitter-cli base-devel unzip
git clone https://github.com/povargg/dotfiles.git
cd dotfiles
```

Из корня репозитория установите конфигурацию в отдельный профиль `povvim`. У этого профиля свои плагины, состояние и кеш. Чтобы сделать настройки основными, сначала сохраните копию текущей конфигурации `nvim` и переместите её старые каталоги данных, состояния и кеша. Затем укажите `profile=nvim` в следующем блоке и в дальнейшем запускайте редактор командой `nvim`.

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

При первом запуске lazy.nvim загрузит плагины. `:LazyHealth` проверяет зависимости, `:Lazy restore` восстанавливает версии из `lazy-lock.json`, а `:LazyExtras` позволяет добавить поддержку нужных языков. Для следующих запусков отдельного профиля используйте `NVIM_APPNAME=povvim nvim` в Bash или `env NVIM_APPNAME=povvim nvim` в fish. [Руководство по установке LazyVim](https://www.lazyvim.org/installation)

## rmpc

Для rmpc сделана своя тема, а вкладки подписаны по-японски. На главном экране очередь показана рядом с обложкой альбома. Для визуализатора CAVA есть отдельная вкладка.

![rmpc и CAVA в отдельных окнах](../assets/screenshots/rmpc-cava.webp)

### Установка в Linux

Конфигурация рассчитана на **rmpc 0.11.0** и актуальную версию MPD. Kitty поддерживает отображение обложек. Для значков и японских символов используйте Nerd Font и дополнительный шрифт, например Noto Sans CJK.

```bash
sudo pacman -S --needed rmpc mpd mpc
```

Сохраните копии существующих файлов rmpc. Из корня клонированного репозитория скопируйте конфигурацию вместе с темой. Команда `cp -i` спросит перед перезаписью файла.

```bash
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config_home/rmpc/themes"
cp -i rmpc/config.ron "$config_home/rmpc/config.ron"
cp -i rmpc/themes/theme.ron "$config_home/rmpc/themes/theme.ron"
```

Если MPD уже настроен, укажите адрес вашего сервера в `config.ron`. Для новой локальной установки с PipeWire подойдёт пример ниже. Он использует каталог `~/Music` и адрес `127.0.0.1:6600`. Перед запуском MPD добавьте музыку в этот каталог или укажите другой путь в `music_directory`.

```bash
mkdir -p "$config_home/mpd/playlists" "$HOME/Music"
cp -i mpd/mpd.conf "$config_home/mpd/mpd.conf"
systemctl --user enable --now mpd.service
mpc -h 127.0.0.1 -p 6600 update
rmpc
```

Если MPD уже работал до изменения конфигурации, перед `mpc update` перезапустите службу командой `systemctl --user restart mpd.service`. При использовании другой звуковой системы выберите поддерживаемый вашей сборкой MPD выход. [Руководство MPD](https://mpd.readthedocs.io/en/stable/user.html) · [Установка rmpc](https://rmpc.mierak.dev/installation/)

<details>
<summary>Обложки, тексты песен и встроенный спектр CAVA</summary>

- **Обложки.** Оставьте `album_art.method` в режиме `Auto` и используйте терминал с поддержкой изображений, например Kitty. MPD берёт обложки из медиатеки.
- **Тексты.** Укажите каталог с файлами `.lrc` в поле `lyrics_dir` файла `config.ron`.
- **Встроенный спектр.** Установите `cava`, раскомментируйте выход FIFO в `mpd.conf` и перезапустите MPD. rmpc читает `/tmp/mpd.fifo` в формате 44,1 кГц, 16 бит, стерео. Оставьте выход PipeWire включённым для воспроизведения звука.
- **Отдельный спектр.** Скопируйте [`cava/`](../cava/) в каталог конфигурации CAVA и запустите `cava` в отдельном терминале. В настройках включены терминальные столбики, автоматический выбор аудиовхода и сине-розовый градиент. Чтобы получить цвета со скриншота, сохраните палитру Amekoji в каталоге настроек CAVA под именем `themes/amekoji` и укажите `theme = 'amekoji'` в секции `[color]`. [Палитра Amekoji](https://github.com/atif-1402/omarchy-amekoji-theme/blob/main/cava_theme)

[Настройки rmpc](https://rmpc.mierak.dev/configuration/) · [Настройка CAVA для rmpc](https://rmpc.mierak.dev/configuration/cava/)

</details>

## Другие настройки

Настройки терминала основаны на конфигурации end-4. [Kitty](../kitty/) · [fish](../fish/) · [Starship](../starship.toml)

Для MPD есть пример конфигурации с PipeWire, а для CAVA — несколько цветовых схем. [MPD](../mpd/) · [CAVA](../cava/)

[Источники и лицензии](../THIRD_PARTY.md)
