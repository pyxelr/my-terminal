# My Terminal

The applied terminal varies by the host OS:

- [🍎 iTerm2](#-iterm2)
  - [🎨 Appearance](#-appearance)
  - [👨‍💻 Zsh settings](#-zsh-settings)
    - [Plugins](#plugins)
    - [Shell aliases](#shell-aliases)
- [🖥 Windows Terminal](#-windows-terminal)
  - [🎨 Appearance](#-appearance-1)
  - [👨‍💻 Profiles](#-profiles)
    - [Command Prompt](#command-prompt)
    - [Git Bash](#git-bash)
    - [PowerShell 7](#powershell-7)
    - [WSL - Ubuntu 22.04 (LTS)](#wsl---ubuntu-2204-lts)
- [🤖 Termux](#-termux)
  - [🎨 Appearance](#-appearance-2)
  - [👨‍💻 Setup](#-setup)
- [🐧 Neovim](#-neovim)
  - [🎨 Appearance](#-appearance-3)
  - [👨‍💻 Setup](#-setup-1)

Additionally, I have included my NeoVim (text editor) config which is OS agnostic.

This repo only does not list my IDE (VS Code) settings, which you can find in [this blog post](https://pawelcislo.com/2021/11/14/my-vs-code-playground/).

## 🍎 iTerm2

[iTerm2](https://iterm2.com/) - my main terminal for macOS.

### 🎨 Appearance

<img src="screenshots/iterm2.png" alt="iTerm2" width="637"/>

- Theme: [Dracula PRO](https://draculatheme.com/pro)
- iTerm2 theme size: `Compact`
- Font: [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) 12

### 👨‍💻 Zsh settings

- Framework: [Oh My Zsh](https://ohmyz.sh/)
- Prompt: [Starship](https://starship.rs/)
  - If you have installed conda, I suggest to disable printing environment names, as they will be displayed already by Starship: `conda config --set changeps1 False`

#### Plugins

Oh My Zsh plugins:

- [aliases](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aliases)
- [colored-man-pages](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages)
- [common-aliases](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/common-aliases)
- [docker](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker)
- [dotenv](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dotenv)
- [git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)
- [globalias](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/globalias)
- [kubectl](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl)
- [pip](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/pip)
- [poetry](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/poetry)
- [python](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/python)
- [sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)
- [virtualenv](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/virtualenv)

External plugins:

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) ← fish-like autosuggestions for Zsh
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) ← fish shell like syntax highlighting for Zsh

#### Shell aliases

I recommend keeping aliases in the `~/.aliases` file, and then source this file in your respective profile file through `source ~/.aliases`. Keep in mind that a bunch of aliases is already configured through the aforementioned Oh My Zsh plugins, which you can quickly check using the [aliases](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aliases) plugin.

**general**:

- `alias aliases='code ~/.aliases'` ← quickly open `~/.aliases` in VS Code
- `alias lisl='exa -hla --icons'` ← better `ls` with [exa](https://github.com/ogham/exa)
- `alias list='exa -hlas time --icons'` ← better `ls` with [exa](https://github.com/ogham/exa) (ordered by time)
- `alias treee='br -c :pt'` ← better `tree` with [broot](https://github.com/Canop/broot)
- `alias path='echo -e ${PATH//:/\\n}'` ← show all directories in the PATH variable, one per line
- `alias ports='netstat -a | grep -i "listen"'` ← show all open ports and the processes using them
- `alias reload='source ~/.zshrc'` ← reload the configuration file for zsh
- `alias zshrc='code ~/.zshrc'` ← quickly open `~/.zshrc` in VS Code

**kubernetes**:

- `alias k8s-get-pods='kubectl get pods --all-namespaces'` ← get the list of all pods
- `alias k8s-get-services='kubectl get services --all-namespaces'` ← get the list of all services

**macOS**:
- `alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"` ←  find and delete all `.DS_Store` files in the current directory and all subdirectories

**functions**:

- check if a website is up or down:

  ```bash
  function website-status(){
    curl -s --head --request GET "$1" | grep "200 OK"
  }
  ```

- open finder in the current folder:

  ```bash
  function openfinder(){
      open -a Finder "$1";
  }
  ```

#### Shell tools

You can find a list of my recommended shell tools in my [other repo](https://github.com/pyxelr/recommendations-for-engineers#shell).

## 🖥 Windows Terminal

[Windows Terminal](https://github.com/microsoft/terminal) - my main terminal for Windows.

### 🎨 Appearance

![Windows Terminal](screenshots/windows-terminal.png)

- Theme: [Dracula PRO](https://draculatheme.com/pro) (with `"brightBlack": "#8F89B4"` as I have reasoned [here](https://github.com/dracula/dracula-theme/discussions/715))
- Background opacity: `80%`
- Font: [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) 11

### 👨‍💻 Profiles

#### Command Prompt

- Bash's editing: [Clink](https://github.com/chrisant996/clink)
- Prompt: [Starship](https://starship.rs/)
- Sudo for Windows: [gsudo](https://github.com/gerardog/gsudo)

#### Git Bash

Install Git Bash from [here](https://git-scm.com/downloads).

Add profile to Windows Terminal:

- Name: `Git Bash`
- Command line: `%PROGRAMFILES%/Git/bin/bash.exe -i -l`
- Starting directory: `%USERPROFILE%`
- Icon: `%PROGRAMFILES%/Git/mingw64/share/git/git-for-windows.ico`

Extras:

- Prompt: [Starship](https://starship.rs/)
- To be able to activate conda environments, you may also need to set a system variable: `PYTHONIOENCODING=utf8`

`.bash_profile`:

```sh
# Set Starship theme
eval "$(starship init bash)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval "$('/c/Users/pawel/miniconda3/Scripts/conda.exe' 'shell.bash' 'hook')"
# <<< conda initialize <<<
```

#### PowerShell 7

I am using [PowerShell 7](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2#installing-from-the-microsoft-store) in addition to the native Windows PowerShell 5.

Extras:

- Prompt: [Starship](https://starship.rs/)
- Sudo for Windows: [gsudo](https://github.com/gerardog/gsudo)

`$PROFILE`:

```powershell
# Set Starship
Invoke-Expression (&starship init powershell)

# Show navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
```

#### WSL - Ubuntu 22.04 (LTS)

Install Ubuntu:

1. Set a default version of WSL: `wsl --set-default-version 2`.
2. Install [Ubuntu 22.04 LTS](https://www.microsoft.com/store/productId/9PN20MSR04DW).

Setup the environment:

1. Start with `sudo apt update` and `sudo apt upgrade`.
2. Install [Zsh](https://www.zsh.org/), [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) and [Starship](https://github.com/starship/starship).
3. Copy the [👨‍💻 Zsh settings](#-zsh-settings).

Extras:

- Disable beep sound in Windows Terminal settings for the Ubuntu Profile (`Advanced` > `Bell notification style`)
- If you have installed conda, I suggest to disable printing environment names, as they will be displayed already by Starship: `conda config --set changeps1 False`.

## 🤖 Termux

[Termux](https://termux.com/) - my main terminal for Android installed from [F-Droid](https://f-droid.org/en/packages/com.termux/).

### 🎨 Appearance

![Termux](screenshots/termux.png)

UI modified with [Termux:Styling](https://github.com/termux/termux-styling) (obtained from F-Droid):

- Theme: `Dracula`
- Font: `FiraCode` (JetBrains Mono does not support icons of `exa --icons`)
- Keyboard: [Gboard](https://play.google.com/store/apps/details?id=com.google.android.inputmethod.latin&hl=en&gl=US)

### 👨‍💻 Setup

1. Install [F-Droid](https://f-droid.org/), and use it to install [Termux](https://f-droid.org/en/packages/com.termux/) with [Termux:Styling](https://github.com/termux/termux-styling).
2. Open up Termux and start with `apt update` and `apt upgrade`.
3. Install extra packages: `pkg install git`, `pkg install python` and `pkg install vim`.
4. Install [Zsh](https://www.zsh.org/) (`pkg install zsh`), [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) and [Starship](https://github.com/starship/starship) (`pkg install starship`).
5. Copy the [👨‍💻 Zsh settings](#-zsh-settings).
6. Optionally, install further tools such as [Tool-X](https://github.com/rajkumardusad/Tool-X).

## 🐧 Neovim

[Neovim](https://neovim.io/) - my main text editor used within the terminal of any OS.

### 🎨 Appearance

<img src="screenshots/neovim.png" alt="Neovim" width="1000"/>

- Neovim config: [NvChad](https://nvchad.github.io/)
- Theme: `chadracula`
- Font: [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) 12

### 👨‍💻 Setup

1. Make sure you have set up the local terminal of your OS (ideally as in this repo).
2. Follow the installation steps of [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) and [NvChad](https://nvchad.github.io/quickstart/install).
3. Post installation steps to set up the config files:

    ```bash
    cd ~/.config/nvim
    mkdir lua/custom
    cp examples/init.lua lua/custom/init.lua
    cp examples/chadrc.lua lua/custom/chadrc.lua
    ```

4. Edit `~/.config/nvim/lua/custom/chadrc.lua` (apply `chadracula` theme and enable dashboard):

    ```lua
    local M = {}

    M.ui = {
      theme = "chadracula",
    }

    M.plugins = {
      user = {
          ["goolord/alpha-nvim"] = {
            disable = false,
          },
      },
    }

    return M
    ```

5. Start Neovim with `nvim` and do `:PackerSync`. You can also display the file explorer with `CTRL` + `N`.
6. Optionally, apply Neovim in your IDE, such as in VS Code through the [VSCode Neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim) extension.
