#!/bin/bash

set -e

# Function to install a package if not already installed
install_if_not_found() {
	if ! dpkg -s $1 &>/dev/null; then
		echo "$1 not found. Installing..."
		sudo apt-get install -y $1
	else
		echo "$1 already installed."
	fi
}

# Update package list and upgrade packages
echo "Updating and upgrading system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install essential packages
echo "Installing essential packages..."
install_if_not_found "nodejs"
install_if_not_found "npm"
install_if_not_found "luajit"
install_if_not_found "ripgrep"
install_if_not_found "libmagickwand-dev"
install_if_not_found "libgraphicsmagick1-dev"
install_if_not_found "luarocks"

# Install Python packages
echo "Installing Python packages..."
pip install pyperclip plotly kaleido nbformat pillow cairosvg jupyter-client pynvim jupytext jupyter matplotlib

# Install ImageMagick and Luarocks dependencies
echo "Installing ImageMagick and Luarocks dependencies..."
luarocks install magick --local --lua-version=5.1

# Determine the Luarocks installation path
LUAROCKS_PATH=$(luarocks path --lr-path)
LUAROCKS_CPATH=$(luarocks path --lr-cpath)

# Add Luarocks path to Neovim configuration
NVIM_CONFIG_PATH="$HOME/.config/nvim/init.lua"
if [ ! -f "$NVIM_CONFIG_PATH" ]; then
	echo "Creating Neovim configuration file..."
	mkdir -p $(dirname "$NVIM_CONFIG_PATH")
	touch "$NVIM_CONFIG_PATH"
fi

# echo "Updating Neovim configuration..."
#
# if ! grep -q "package.path" "$NVIM_CONFIG_PATH"; then
#   echo 'lua << EOF' >> "$NVIM_CONFIG_PATH"
#   echo "package.path = package.path .. ';${LUAROCKS_PATH//;/\\;}'" >> "$NVIM_CONFIG_PATH"
#   echo "package.cpath = package.cpath .. ';${LUAROCKS_CPATH//;/\\;}'" >> "$NVIM_CONFIG_PATH"
#   echo 'EOF' >> "$NVIM_CONFIG_PATH"
# else
#   echo "Luarocks paths already added to Neovim configuration."
# fi
#
# Clone the Neovim configuration repository
echo "Cloning Neovim configuration repository..."
git clone https://github.com/driessenslucas/nvim.git ~/.config/nvim

# Install Jupytext and other Python packages
echo "Installing additional Python packages..."
pip install pyperclip plotly kaleido nbformat pillow cairosvg jupyter-client pynvim jupytext jupyter matplotlib

# Finish setup
echo "Setup complete. Restart Neovim to apply changes."
