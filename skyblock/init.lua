--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

MAIN LOADER

]]--

local modpath = minetest.get_modpath('skyblock')

-- load apis
dofile(modpath..'/skyblock.lua')
dofile(modpath..'/skyblock.table.lua')

-- register entities
dofile(modpath..'/register_node.lua')
dofile(modpath..'/register_misc.lua')

-- log that we started
minetest.log('action', '[MOD]'..minetest.get_current_modname()..' -- loaded from '..minetest.get_modpath(minetest.get_current_modname()))