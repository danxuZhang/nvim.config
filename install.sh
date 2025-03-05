#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined vars, and pipe failures

# Default configurations (can be overridden via environment variables)
: "${NVIM_VERSION:=0.10.4}"
: "${NODE_VERSION:=22.11.0}"
: "${INSTALL_ROOT:=$HOME/apps}"
: "${MODULES_ROOT:=$HOME/apps/modulefiles}"

# Derived paths
INSTALL_PREFIX="${INSTALL_ROOT}/neovim/${NVIM_VERSION}"
MODULE_PATH="${MODULES_ROOT}/neovim"

# Download URLs
NVIM_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
NODE_URL="https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz"

# Temporary directory for downloads
TEMP_DIR="$(mktemp -d -t nvim-install.XXXXXX)"
trap 'rm -rf "${TEMP_DIR}"' EXIT  # Cleanup on script exit

# Functions
log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }
error() { log "ERROR: $*" >&2; exit 1; }

# Check for existing installation
if [ -d "${INSTALL_PREFIX}" ]; then error "Installation directory ${INSTALL_PREFIX} already exists"
fi

# Download and extract archives
log "Downloading and extracting Neovim ${NVIM_VERSION}..."
cd "${TEMP_DIR}"
wget -q -O nvim.tar.gz "${NVIM_URL}" || error "Failed to download Neovim"
mkdir -p nvim && tar xf nvim.tar.gz --strip-components=1 -C nvim

log "Downloading and extracting Node.js ${NODE_VERSION}..."
wget -q -O node.tar.xz "${NODE_URL}" || error "Failed to download Node.js"
mkdir -p node && tar xf node.tar.xz --strip-components=1 -C node

# Create installation directories
mkdir -p "${INSTALL_PREFIX}"/{bin,lib,share,include}

# Install files
log "Installing to ${INSTALL_PREFIX}..."
for dir in bin lib share include; do
    if [ -d "node/${dir}" ]; then
        cp -r "node/${dir}"/* "${INSTALL_PREFIX}/${dir}/" 2>/dev/null || true
    fi
    if [ -d "nvim/${dir}" ]; then
        cp -r "nvim/${dir}"/* "${INSTALL_PREFIX}/${dir}/" 2>/dev/null || true
    fi
done

# Set permissions
chmod -R u+w,go+r-w "${INSTALL_PREFIX}"
find "${INSTALL_PREFIX}/bin" -type f -exec chmod +x {} +

# Create modulefile
log "Creating LMOD modulefile..."
mkdir -p "${MODULE_PATH}"
cat > "${MODULE_PATH}/${NVIM_VERSION}.lua" << 'EOL'
help([[
Neovim %%VERSION%% with Node.js
]])

local version = "%%VERSION%%"
local base = "%%PREFIX%%"

whatis([[Name: Neovim]])
whatis([[Version: ]] .. version)
whatis([[Description: Hyperextensible Vim-based text editor with Node.js]])

prepend_path("PATH", pathJoin(base, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("MANPATH", pathJoin(base, "share/man"))

setenv("NVIM_VERSION", version)
EOL

# Update modulefile placeholders
sed -i "s|%%VERSION%%|${NVIM_VERSION}|g" "${MODULE_PATH}/${NVIM_VERSION}.lua"
sed -i "s|%%PREFIX%%|${INSTALL_PREFIX}|g" "${MODULE_PATH}/${NVIM_VERSION}.lua"

log "Installation complete!"
log "To use: module use ${MODULES_ROOT}; module load neovim/${NVIM_VERSION}"

