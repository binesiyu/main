-- -*- mode: lua; -*-

std = 'lua51c'
--global = false
allow_defined_top = true
globals = {'string','table','math'
            ,'cc', 'ccui', 'ccs','tolua','cca'
            ,'dump', 'transition', 'class','display'
            ,'gModuleMgr','worldMapDefine','gMapMoveLineModel'
            ,'i18n'
            ,'SoraDGetChildByName','SoraDCreateBasePanel','SoraDAddMessage','SoraDFIsRA'
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
