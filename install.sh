#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          DOTFILES INSTALL SCRIPT                             ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Uso: ./install.sh
#
# Este script crea symlinks de los dotfiles a tu directorio home.
# Hace backup de archivos existentes antes de reemplazarlos.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Instalando dotfiles...                          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Función para crear symlink con backup
link_file() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        # Hacer backup si existe
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}  Backup: $dest → $BACKUP_DIR/${NC}"
        mv "$dest" "$BACKUP_DIR/"
    fi
    
    ln -sf "$src" "$dest"
    echo -e "${GREEN}  ✓ Linked: $dest${NC}"
}

echo "📁 Directorio de dotfiles: $DOTFILES_DIR"
echo ""

# === BASH ===
echo -e "${GREEN}[BASH]${NC}"
link_file "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
link_file "$DOTFILES_DIR/bash/.bash_aliases" "$HOME/.bash_aliases"
link_file "$DOTFILES_DIR/bash/.inputrc" "$HOME/.inputrc"
echo ""

# === GIT ===
echo -e "${GREEN}[GIT]${NC}"
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
echo ""

# === VIM ===
echo -e "${GREEN}[VIM]${NC}"
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
echo ""

# === Crear archivo local (no versionado) ===
if [ ! -f "$HOME/.bashrc.local" ]; then
    echo -e "${GREEN}[LOCAL]${NC}"
    cat > "$HOME/.bashrc.local" << 'EOF'
# ┌──────────────────────────────────────────────────────────────────────────────┐
# │                    CONFIGURACIÓN LOCAL (no versionada)                       │
# │  Pon aquí configuración específica de esta máquina:                          │
# │  - PATH de trabajo                                                           │
# │  - Variables de entorno                                                      │
# │  - Aliases específicos                                                       │
# └──────────────────────────────────────────────────────────────────────────────┘

# Ejemplo:
# export PATH=$PATH:/ruta/a/herramientas
# alias proyecto='cd ~/mi-proyecto'
EOF
    echo -e "${GREEN}  ✓ Creado: ~/.bashrc.local (para config local)${NC}"
    echo ""
fi

# === Configurar git user si no está ===
if grep -q "tu_email@ejemplo.com" "$HOME/.gitconfig" 2>/dev/null; then
    echo -e "${YELLOW}[GIT CONFIG]${NC}"
    echo -e "${YELLOW}  ⚠ Recuerda configurar tu usuario de git:${NC}"
    echo -e "     git config --global user.name \"Tu Nombre\""
    echo -e "     git config --global user.email \"tu@email.com\""
    echo ""
fi

# === Resumen ===
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✓ Instalación completada!                       ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}📦 Backups guardados en: $BACKUP_DIR${NC}"
fi

echo ""
echo "Ejecuta 'source ~/.bashrc' o abre una nueva terminal para aplicar cambios."
