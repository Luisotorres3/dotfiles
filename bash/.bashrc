#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                                   BASHRC                                     ║
# ║                         Última actualización: 2026-01-29                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                           1. CONFIGURACIÓN BÁSICA                            │
# └──────────────────────────────────────────────────────────────────────────────┘

# Si no es una sesión interactiva, no hacer nada
case $- in
    *i*) ;;
      *) return;;
esac

# Detectar chroot (usado en el prompt si aplica)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                              2. HISTORIAL                                    │
# │  - 50000 comandos en memoria, 100000 en archivo                              │
# │  - Elimina duplicados automáticamente                                        │
# │  - Muestra timestamp con 'history'                                           │
# │  - Ignora comandos triviales (ls, cd, etc.)                                  │
# └──────────────────────────────────────────────────────────────────────────────┘

HISTSIZE=50000                              # Comandos en memoria
HISTFILESIZE=100000                         # Comandos en archivo ~/.bash_history
HISTCONTROL=ignoreboth:erasedups            # Ignorar duplicados y comandos con espacio
HISTTIMEFORMAT="%F %T  "                    # Formato: 2026-01-29 14:30:00
HISTIGNORE="ls:ll:la:cd:pwd:exit:clear:history:c"  # No guardar estos comandos

shopt -s histappend                         # Añadir al historial, no sobrescribir

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                         3. OPCIONES DE SHELL (shopt)                         │
# │  Comportamiento mejorado de bash                                             │
# └──────────────────────────────────────────────────────────────────────────────┘

shopt -s checkwinsize   # Actualizar LINES y COLUMNS después de cada comando
shopt -s globstar       # ** busca recursivamente (ej: ls **/*.cpp)
shopt -s cdspell        # Corregir typos en cd (ej: cd /hoem → /home)
shopt -s dirspell       # Corregir typos en autocompletado de directorios
shopt -s direxpand      # Expandir variables en TAB
shopt -s checkjobs      # Avisar si hay trabajos en segundo plano al salir
shopt -s autocd         # Escribir solo el directorio hace cd automático

set -o ignoreeof        # Ctrl+D requiere 2 pulsaciones para salir (evita cierre accidental)

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                              4. COLORES Y LS                                 │
# └──────────────────────────────────────────────────────────────────────────────┘

# Habilitar colores en ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Soporte para archivos no-texto en less
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                         5. PROMPT CON GIT                                    │
# │                                                                              │
# │  Formato: ~/ruta (rama ✗●↑↓)$                                                │
# │                                                                              │
# │  Símbolos:                                                                   │
# │    ✗  = Cambios sin añadir (unstaged)                                        │
# │    ●  = Cambios staged (listos para commit)                                  │
# │    ↑N = N commits por subir (push)                                           │
# │    ↓N = N commits por bajar (pull)                                           │
# │    ✓  = Todo limpio                                                          │
# │  [N]  = Código de error del último comando (solo si falló)                   │
# └──────────────────────────────────────────────────────────────────────────────┘

# Función: obtener información de git para el prompt
__git_prompt() {
    local branch=""
    
    # Obtener rama actual (o tag, o commit corto)
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || \
             git describe --tags --exact-match 2>/dev/null || \
             git rev-parse --short HEAD 2>/dev/null)
    
    # Si no estamos en un repo git, no mostrar nada
    [ -z "$branch" ] && return
    
    local icons=""
    local git_status=$(git status --porcelain 2>/dev/null)
    
    # Cambios unstaged (modificados, eliminados, sin trackear)
    echo "$git_status" | grep -q '^ M\|^??\|^ D' && icons+="✗"
    
    # Cambios staged (listos para commit)
    echo "$git_status" | grep -q '^M\|^A\|^D\|^R' && icons+="●"
    
    # Commits por push
    local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    [ -n "$ahead" ] && [ "$ahead" -gt 0 ] && icons+="↑$ahead"
    
    # Commits por pull
    local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)
    [ -n "$behind" ] && [ "$behind" -gt 0 ] && icons+="↓$behind"
    
    # Si todo está limpio
    [ -z "$icons" ] && icons="✓"
    
    # Mostrar: (rama iconos) en amarillo
    printf " \e[33m(%s %s)\e[0m" "$branch" "$icons"
}

# Función: construir el prompt PS1
__build_prompt() {
    local exit_code=$?
    local error_indicator=""
    
    # Si el comando anterior falló, mostrar código de error en rojo
    [ $exit_code -ne 0 ] && error_indicator="\[\e[31m\][$exit_code]\[\e[0m\] "
    
    # Construir PS1: [error] ruta (git)$
    PS1="${error_indicator}\[\e[32m\]\w\[\e[0m\]\$(__git_prompt)\$ "
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                     6. TÍTULO DE PESTAÑA DE TERMINAL                         │
# │  Muestra el comando actual mientras se ejecuta                               │
# └──────────────────────────────────────────────────────────────────────────────┘

ORIGINAL_TAB_TITLE="$(basename "$PWD")"  # Nombre de la carpeta actual

# Establecer título de pestaña
__set_tab_title() {
    echo -ne "\033]0;$1\007"
}

# Antes de ejecutar un comando: mostrar "comando - carpeta" en la pestaña
__before_command() {
    local cmd="$BASH_COMMAND"
    # Ignorar comandos internos (funciones que empiezan con __)
    [[ "$cmd" =~ ^__ ]] && return
    __set_tab_title "${cmd%% *} - $(basename "$PWD")"
}

# Después de ejecutar un comando: restaurar título a nombre de carpeta actual
__after_command() {
    __set_tab_title "$(basename "$PWD")"
}

# Enganchar funciones
trap '__before_command' DEBUG
PROMPT_COMMAND='__after_command; __build_prompt'

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                           7. ALIASES                                         │
# │  Archivo separado: ~/.bash_aliases (se carga automáticamente)                │
# └──────────────────────────────────────────────────────────────────────────────┘

# Aliases básicos (por compatibilidad)
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Notificación para comandos largos: sleep 10; alert
# Usa beep + mensaje en terminal (compatible con WSL)
alert() {
    local rc=$?
    local cmd=$(history | tail -n1 | sed 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')
    echo -ne "\a"
    if [ $rc -eq 0 ]; then
        echo "✅ Completado: $cmd"
    else
        echo "❌ Error ($rc): $cmd"
    fi
}

# Cargar aliases personalizados desde archivo separado
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                        8. FUNCIONES ÚTILES                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

# mkcd: crear directorio y entrar
# Uso: mkcd nuevo_directorio
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# extract: extraer cualquier archivo comprimido
# Uso: extract archivo.tar.gz
extract() {
    if [ ! -f "$1" ]; then
        echo "Error: '$1' no es un archivo válido"
        return 1
    fi
    
    case "$1" in
        *.tar.gz|*.tgz)     tar xzf "$1"    ;;
        *.tar.bz2|*.tbz2)   tar xjf "$1"    ;;
        *.tar.xz|*.txz)     tar xJf "$1"    ;;
        *.tar)              tar xf "$1"     ;;
        *.zip)              unzip "$1"      ;;
        *.gz)               gunzip "$1"     ;;
        *.bz2)              bunzip2 "$1"    ;;
        *.xz)               unxz "$1"       ;;
        *.rar)              unrar x "$1"    ;;
        *.7z)               7z x "$1"       ;;
        *.Z)                uncompress "$1" ;;
        *)                  echo "No sé cómo extraer '$1'"; return 1 ;;
    esac
}

# backup: crear copia de seguridad con timestamp
# Uso: backup archivo.txt → archivo.txt.bak.20260129_143000
backup() {
    if [ -f "$1" ]; then
        local backup_name="$1.bak.$(date +%Y%m%d_%H%M%S)"
        cp "$1" "$backup_name"
        echo "✓ Backup creado: $backup_name"
    else
        echo "Error: '$1' no existe"
        return 1
    fi
}

# fcd: buscar directorio interactivamente con fzf
# Uso: fcd [ruta_base]  (por defecto busca desde .)
fcd() {
    local dir
    dir=$(find "${1:-.}" -type d 2>/dev/null | fzf --height 40% --reverse --preview 'ls -la {}')
    if [ -n "$dir" ]; then
        cd "$dir" && pwd
    else
        return 1
    fi
}

# gclone: clonar repositorio y entrar automáticamente
# Uso: gclone https://github.com/user/repo.git
gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# search: buscar texto en archivos recursivamente con ripgrep
# Uso: search "texto" [directorio]
# Fallback a grep si rg no está disponible
search() {
    if command -v rg &>/dev/null; then
        rg --smart-case "$1" "${2:-.}"
    else
        grep -rn --color=auto "$1" "${2:-.}"
    fi
}

# weather: ver el tiempo actual
# Uso: weather [ciudad]
weather() {
    curl -s "wttr.in/${1:-Madrid}?format=3"
}

# cheat: ver cheatsheet de un comando
# Uso: cheat tar
cheat() {
    curl -s "cheat.sh/$1"
}

# grepo: abrir repositorio de GitHub del directorio actual
# Uso: grepo (desde dentro de un repo git)
grepo() {
    local url=$(git config --get remote.origin.url 2>/dev/null)
    
    if [ -z "$url" ]; then
        echo "❌ Error: No se encontró repositorio remoto"
        return 1
    fi
    
    # Convertir SSH a HTTPS si es necesario
    url=${url//git@github.com:/https:\/\/github.com\/}
    url=${url%.git}
    
    # Abrir en navegador (detectar sistema)
    if command -v wslpath &>/dev/null; then
        # WSL: usar cmd.exe /c start
        (cmd.exe /c start "" "$url" 2>/dev/null &) &>/dev/null
        echo "✓ Abriendo repositorio en navegador..."
    elif [ "$(uname)" = "Darwin" ]; then
        # macOS: usar open
        (/usr/bin/open "$url" 2>/dev/null &) &>/dev/null
        echo "✓ Abriendo repositorio en navegador..."
    elif command -v xdg-open &>/dev/null; then
        # Linux: usar xdg-open
        (nohup xdg-open "$url" >/dev/null 2>&1 &) &>/dev/null
        echo "✓ Abriendo repositorio en navegador..."
    else
        echo "⚠ No se encontró navegador"
        echo "📋 URL: $url"
        return 1
    fi
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                         9. AUTOCOMPLETADO                                    │
# └──────────────────────────────────────────────────────────────────────────────┘

# Cargar bash-completion si está disponible
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                    10. CONFIGURACIÓN LOCAL                                   │
# │  Cargar configuración específica de máquina si existe                        │
# └──────────────────────────────────────────────────────────────────────────────┘

# Archivo para configuración local (no versionado)
# Pon aquí PATH de trabajo, variables de entorno específicas, etc.
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

# Inicializar título de pestaña con nombre de carpeta actual
__set_tab_title "$(basename "$PWD")"

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                      11. HERRAMIENTAS ADICIONALES                            │
# └──────────────────────────────────────────────────────────────────────────────┘

# NVM (Node Version Manager) - descomentar si lo usas
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Less - mejor visualización
export LESS="-IR"

# fzf - key bindings y completion
source /usr/share/doc/fzf/examples/key-bindings.bash
source /usr/share/bash-completion/completions/fzf

# fzf - opciones por defecto con preview
export FZF_DEFAULT_OPTS="--height 40% --layout reverse --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}' --bind 'ctrl-y:execute-silent(echo {} | clip.exe)+abort'"
export FZF_DEFAULT_COMMAND='fdfind --type f'

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                              FIN DE .bashrc                                  │
# └──────────────────────────────────────────────────────────────────────────────┘
