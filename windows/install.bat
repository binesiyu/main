@echo off
set ORIGINAL_PATH=%cd%

echo Check and install dein.

rem if we don't have folder vimfiles, create it.
if not exist .\vimfiles\ (mkdir .\vimfiles\)
cd .\vimfiles\

rem if we don't have dein, create it.
if not exist .\dein\ (mkdir .\dein\)
cd .\dein\

rem download or update vundle in ./vimfiles/dein/
if not exist .\repos\github.com\Shougo\dein.vim\ (git clone https://github.com/gmarik/Vundle.vim .\repos\github.com\Shougo\dein.vim)

rem download and install bundles through Vundle in this repository
echo Update vim-plugins.
cd %ORIGINAL_PATH%
start /B /WAIT vim -u .vimrc.mini --cmd "set rtp=.\vimfiles,$VIMRUNTIME,.\vimfiles\after"  +PluginUpdate +qall

rem NOTE: Windows will stop batch after other process running
@echo on
