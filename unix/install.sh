#!/bin/bash

export ORIGINAL_PATH=`pwd`

echo "Check and install dein."

# if we don't have folder vimfiles, create it.
if [ ! -d "./vimfiles/" ]; then
    mkdir ./vimfiles/
fi
cd ./vimfiles/

# if we don't have dein, create it.
if [ ! -d "./dein/" ]; then
    mkdir ./dein/
fi
cd ./dein/

# download or update vundle in ./vimfiles/dein/
if [ ! -d "./repos/github.com.Shougo/dein.vim/" ]; then
	mkdir -p ./repos/github.com/Shougo/dein.vim
    # TODO: please check if the dein is latest version
    git clone https://github.com/Shougo/dein.vim ./repos/github.com/Shougo/dein.vim
fi

# download and install bundles through Vundle in this repository
echo "Update vim-plugins."
cd ${ORIGINAL_PATH}
vim -u .vimrc.mini --cmd "set rtp=./vimfiles,\$VIMRUNTIME,./vimfiles/after"  +PluginUpdate +qall

# go back
cd ${ORIGINAL_PATH}

#
echo "|"
echo "exVim installed successfully!"
echo "|"
echo "You can run 'sh unix/gvim.sh' to preview exVim."
echo "You can also run 'sh unix/replace-my-vim.sh' to replace exVim with your Vim."
