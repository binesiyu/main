#!/bin/bash

cp ./dist/ctags_lang ~/.ctags
cp .vimrc ~/.vimrc
rm -rf ~/.vim
cp -r vimfiles ~/.vim
