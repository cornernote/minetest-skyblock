--[[

SkyBlock for MineTest
Copyright (C) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>

MAIN LOADER

]]--

-- expose functions to other modules
skyblock = {}

-- load config and functions
dofile(minetest.get_modpath("skyblock").."/config.lua")
dofile(minetest.get_modpath("skyblock").."/api.lua")

-- register entities
dofile(minetest.get_modpath("skyblock").."/register_alias.lua")
dofile(minetest.get_modpath("skyblock").."/register_node.lua")
dofile(minetest.get_modpath("skyblock").."/register_craft.lua")
dofile(minetest.get_modpath("skyblock").."/register_abm.lua")
dofile(minetest.get_modpath("skyblock").."/register_misc.lua")
