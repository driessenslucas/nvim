# Installing ImageMagick

## The magick luarock provides bindings to ImageMagick's MagickWand, so we need to install that package as well

```markdown
    Ubuntu: sudo apt install libmagickwand-dev
    MacOS: brew install imagemagick
        By default, brew installs into a weird location, so you have to add $(brew --prefix)/lib to DYLD_LIBRARY_PATH by adding something like export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH" to your shell profile (probably .zshrc or .bashrc)
    Fedora: sudo dnf install ImageMagick-devel
    Arch: sudo pacman -Syu imagemagick
```

```bash
    sudo apt install nodejs
    sudo apt install npm
    sudo apt-get install luajit
    sudo apt-get install ripgrep
    sudo apt-get install libmagickwand-dev
    sudo apt-get install libgraphicsmagick1-dev
    sudo apt-get install luarocks
    luarocks --local --lua-version=5.1 install magick
    pip install pyperclip plotly kaleido nbformat pillow cairosvg jupyter-client pynvim jupytext
```
