--[[

SkyBlock for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

MAIN LOADER

]]--

-- expose functions to other modules
skyblock = {}

-- load config
dofile(minetest.get_modpath("skyblock").."/config.lua")

if( skyblock.LEVEL=='extended' 
   and  (not( minetest.get_modpath('doors'))
      or not( minetest.get_modpath('wool'))
      or not( minetest.get_modpath('beds')))) then
	skyblock.LEVEL = 'default';
	print('[skyblock] switching back to LEVEL default due to missing mods');
end

-- load apis
dofile(minetest.get_modpath("skyblock").."/api_table_save.lua")
dofile(minetest.get_modpath("skyblock").."/api_achievements.lua")
dofile(minetest.get_modpath("skyblock").."/api_skyblock.lua")

-- small craft guide
dofile(minetest.get_modpath("skyblock").."/craft_guide_mini.lua")

-- load levels
dofile(minetest.get_modpath("skyblock").."/levels/"..skyblock.LEVEL.."/init.lua")

-- register entities
dofile(minetest.get_modpath("skyblock").."/register_node.lua")
dofile(minetest.get_modpath("skyblock").."/register_craft.lua")
dofile(minetest.get_modpath("skyblock").."/register_abm.lua")
dofile(minetest.get_modpath("skyblock").."/register_misc.lua")


-- log that we started
minetest.log("action", "[MOD]"..minetest.get_current_modname().." -- loaded from "..minetest.get_modpath(minetest.get_current_modname()))
