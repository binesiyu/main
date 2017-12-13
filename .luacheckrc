-- -*- mode: lua; -*-

std = 'lua51c'
--global = false
allow_defined_top = true
globals = {'cc', 'ccui', 'ccs' 
            ,'dump', 'transition', 'class'
            ,'gModuleMgr','worldMapDefine','gMapMoveLineModel'
            ,'i18n'
            ,'SoraDGetChildByName','SoraDCreateBasePanel','SoraDAddMessage'
            ,'include','handler'
        }
exclude_files = {'src/cocos/**.lua'}
self = false

ignore = {
  '212', -- unused argument
  '612', -- trailing whitespace
  '631', -- line is too long
}

files['.luacheckrc'].global = false
