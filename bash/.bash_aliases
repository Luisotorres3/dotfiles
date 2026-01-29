# ============== BASH ALIASES ==============
# Archivo generado para organizar aliases
# Se carga automáticamente desde ~/.bashrc

# === NAVEGACIÓN RÁPIDA ===
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'  # volver al directorio anterior

# === LS MEJORADO ===
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias lt='ls -lhtr --color=auto'        # ordenados por fecha (más reciente al final)
alias lsize='ls -lhS --color=auto'      # ordenados por tamaño

# === GIT SHORTCUTS ===
alias gs='git status'
alias gss='git status -s'               # status corto
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull'
alias gf='git fetch --all --prune'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --decorate -20'
alias gloga='git log --oneline --graph --decorate --all -30'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gm='git merge'
alias grb='git rebase'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'

# === DOCKER ===
alias d='docker'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimg='docker images'
alias dexec='docker exec -it'
alias dlogs='docker logs -f'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias dprune='docker system prune -af'

# === DOCKER COMPOSE ===
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# === UTILIDADES DEL SISTEMA ===
alias ports='netstat -tulanp 2>/dev/null || ss -tulanp'
alias meminfo='free -h'
alias cpuinfo='lscpu'
alias diskinfo='df -h'
alias topcpu='ps aux --sort=-%cpu | head -10'
alias topmem='ps aux --sort=-%mem | head -10'

# === MEJORAS DE COMANDOS BÁSICOS ===
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'
alias mkdir='mkdir -pv'
alias wget='wget -c'  # continuar descargas

# === SEGURIDAD (confirmación antes de sobrescribir) ===
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# === BÚSQUEDA ===
alias ff='find . -type f -name'         # ff "*.txt"
alias fd='find . -type d -name'         # fd "config"

# === ATAJOS ÚTILES ===
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'     # mostrar PATH línea por línea
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'                   # número de semana

# === EDITORES ===
alias v='vim'
alias vi='vim'
alias code='code .'

# === RED ===
alias myip='curl -s ifconfig.me'
alias localip='hostname -I | awk "{print \$1}"'
alias ping='ping -c 5'

# === WSL / WINDOWS (solo si estás en WSL) ===
alias open='explorer.exe .'              # Abrir carpeta actual en Explorer
alias wopen='explorer.exe'               # Abrir archivo con app de Windows
alias clip='clip.exe'                    # Copiar al portapapeles de Windows
