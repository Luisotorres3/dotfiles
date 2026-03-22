# 🏠 Dotfiles

Mi configuración personal de terminal para Linux/WSL.

## ✨ Características

### Bash
- **Historial mejorado**: 50K comandos, timestamps, sin duplicados
- **Prompt con Git**: muestra rama y estado (✗●↑↓✓)
- **Autocompletado inteligente**: case-insensitive, búsqueda en historial
- **Funciones útiles**: `mkcd`, `extract`, `backup`, `fcd`, `gclone`
- **70+ aliases**: git, docker, navegación, utilidades

### Git
- Pull con rebase automático
- Aliases útiles: `git lg`, `git undo`, `git save`
- Diff con colores para líneas movidas
- Merge con diff3 (muestra versión original en conflictos)

### Vim
- Números de línea
- Búsqueda incremental e insensible a mayúsculas
- Colores de sintaxis
- Configuración para vimdiff

## 📦 Instalación

```bash
git clone https://github.com/TU_USUARIO/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

El script:
1. **Instala dependencias necesarias** (lsd, fzf, ripgrep, etc.)
2. Hace backup de tus archivos actuales
3. Crea symlinks a los dotfiles
4. Crea `~/.bashrc.local` para configuración específica de máquina

### 🔧 Dependencias

El script instala automáticamente las siguientes herramientas si no están presentes:

- **Requeridas**: curl, git, vim, less
- **Recomendadas**: lsd (ls moderno), fzf (búsqueda fuzzy), ripgrep (búsqueda rápida)
- **Opcionales**: unzip, p7zip, unrar (para función extract)

Si alguna herramienta no se puede instalar automáticamente, el script continúa pero mostrará una advertencia.

## 📁 Estructura

```
dotfiles/
├── bash/
│   ├── .bashrc          # Configuración principal de bash
│   ├── .bash_aliases    # Aliases organizados por categoría
│   └── .inputrc         # Atajos de teclado y autocompletado
├── git/
│   └── .gitconfig       # Configuración global de git
├── vim/
│   └── .vimrc           # Configuración de vim
├── install.sh           # Script de instalación
└── README.md
```

## ⚙️ Configuración local

Para configuración específica de cada máquina (PATH de trabajo, variables de entorno, etc.), edita `~/.bashrc.local`. Este archivo se carga automáticamente y **no está versionado**.

```bash
# ~/.bashrc.local ejemplo
export PATH=$PATH:/ruta/a/herramientas
alias proyecto='cd ~/mi-proyecto'
```

## ⌨️ Atajos útiles

### Teclado (inputrc)
| Atajo | Acción |
|-------|--------|
| `Ctrl+R` | Buscar en historial |
| `Ctrl+W` | Borrar palabra izquierda |
| `Alt+D` | Borrar palabra derecha |
| `Ctrl+←/→` | Moverse por palabras |
| `↑/↓` | Buscar historial con prefijo |

### Git aliases
| Alias | Comando |
|-------|---------|
| `git lg` | Log bonito con gráfico |
| `git undo` | Deshacer último commit |
| `git save "msg"` | Stash con mensaje |
| `git aliases` | Ver todos los aliases |

### Bash aliases
| Alias | Descripción |
|-------|-------------|
| `..`, `...` | Subir directorios |
| `gs`, `gp`, `gl` | Git status/push/pull |
| `dps`, `dimg` | Docker ps/images |
| `open` | Abrir en Explorer (WSL) |

## 🔧 Símbolos del prompt Git

```
~/proyecto (main ✗●↑2)$
              │  │││
              │  ││└─ 2 commits por push
              │  │└── cambios staged
              │  └─── cambios sin añadir
              └────── rama actual
```

## 📄 Licencia

MIT
