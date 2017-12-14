-- -*- mode: lua; -*-

std = 'lua51c'
-- global = false
allow_defined_top = true
globals = {
        }
exclude_files = {'src/cocos/**.lua'}
self = false

ignore = {
  '212', -- unused argument
  '612', -- trailing whitespace
  '621', -- indent
  '631', -- line is too long
}

files['.luacheckrc'].global = false
