--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

MAIN LOADER

]]--

-- expose functions to other modules
skyblock = {}
achievements = {}

-- load config
dofile(minetest.get_modpath("skyblock").."/config.lua")

-- load apis
dofile(minetest.get_modpath("skyblock").."/api_table_save.lua")
dofile(minetest.get_modpath("skyblock").."/api_skyblock.lua")
dofile(minetest.get_modpath("skyblock").."/api_achievements.lua")

-- register entities
dofile(minetest.get_modpath("skyblock").."/register_alias.lua")
dofile(minetest.get_modpath("skyblock").."/register_node.lua")
dofile(minetest.get_modpath("skyblock").."/register_craft.lua")
dofile(minetest.get_modpath("skyblock").."/register_abm.lua")
dofile(minetest.get_modpath("skyblock").."/register_misc.lua")

-- log that we started
minetest.log("action", "[MOD]"..minetest.get_current_modname().." -- loaded from "..minetest.get_modpath(minetest.get_current_modname()))