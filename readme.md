# Offline Neovim setup

## Install

Run the install script:

To install into /opt/nvim/<release version>:
(see install.sh for other options)

  ```
  ./install.sh
  ```

## Install the neovim python package

  ```
  sudo python3 -m pip install pynvim
  ```

## Build the lua language server

  ```
  cd lsp-deps/lua-language-server
  cd 3rd/luamake
  compile/install.sh
  cd ../../
  ./3rd/luamake/luamake rebuild
  ```

Create a symlink to the lua language server in ~/.local/:

  ```
  cd .local/
  ln -s /path/to/lsp-deps/lua-language-server lua-language-server
  ```

## Install the python language server package

  ```
  sudo python3 -m pip install python-language-server[all]
  ```

## Directory structure

Example: `$VIMUSERLOCALFILES = ~/vimlocal`

The following directory structure is used:

```
$VIMUSERLOCALFILES/
├── vimrc-vars.vim                # Enable/Disable bundle plugins (pathogen)
├── vimrc-after.vim               # User vimrc
├── plugins.vim                   # List of vim-plug plugins
├── lua                           # user lua modules
│   └── user                      # user namespace for lua inits
│       ├── init.lua              # user init for neovim
│       ├── lsp_config.lua        # user config for lsp's and completion
│       └── telescope             # user plugin-specific inits
│           ├── init.lua
│           └── mappings.lua
├── plugged                       # output dir for vim-plug
│   ├── plugin
│   ├── ...
│   ├── plugin
├── UltiSnips
│   └── custom snippets
```

### Initialization with Neovim

Initialization order:

```
~/.vim/vimrc
 |--> $VIMUSERLOCALFILES/vimrc-vars.vim
     |--> $VIMUSERLOCALFILES/vimrc-after.vim
          |--> plugins.vim
          |
          ... (vim initialization completes)
          |
          |--> (autocmd VimEnter *) NvimStartup()
               |--> PlugInstall (if necessary)
               |--> user/init.lua
                    |--> user/lsp_config.lua
                    |--> user/telescope/init.lua
                    |--> ... (other inits)
```
