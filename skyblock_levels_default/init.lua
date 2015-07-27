--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL LOADER

]]--

dofile(minetest.get_modpath('skyblock_levels_default')..'/register_abm.lua')
dofile(minetest.get_modpath('skyblock_levels_default')..'/register_craft.lua')
dofile(minetest.get_modpath('skyblock_levels_default')..'/register_node.lua')
dofile(minetest.get_modpath('skyblock_levels_default')..'/register_misc.lua')


levels = {}
dofile(minetest.get_modpath('skyblock_levels_default')..'/api_levels.lua')
dofile(minetest.get_modpath('skyblock_levels_default')..'/level_1.lua')
dofile(minetest.get_modpath('skyblock_levels_default')..'/level_2.lua')
dofile(minetest.get_modpath('skyblock_levels_default')..'/level_3.lua')
dofile(minetest.get_modpath('skyblock_levels_default')..'/level_4.lua')