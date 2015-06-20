--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL LOADER

]]--


--
-- Level Files
--

levels = {}
dofile(minetest.get_modpath("skyblock").."/levels/default/level_1.lua")
dofile(minetest.get_modpath("skyblock").."/levels/default/level_2.lua")
dofile(minetest.get_modpath("skyblock").."/levels/default/level_3.lua")
dofile(minetest.get_modpath("skyblock").."/levels/default/level_4.lua")

--
-- Level Nodes
--

for level=1,4 do
	local texture = "skyblock_"..level..".png";
	if( level==4 ) then
		texture = "skyblock_finish.png";
	end
	minetest.register_node("skyblock:level_"..level, {
		description = "Level "..level,
		tiles = {texture},
		is_ground_content = true,
		paramtype = "light",
		light_propagates = true,
		sunlight_propagates = true,
		light_source = 15,		
		groups = {crumbly=2,cracky=2},
		on_punch = function(pos, node, puncher)
			achievements.level_on_punch(level, pos, node, puncher)
		end,
		on_dig = function(pos, node, digger)
			achievements.level_on_dig(level, pos, node, digger)
		end,
		on_construct = function(pos)
			minetest.env:get_meta(pos):get_inventory():set_size("rewards", 2*2)
		end,
	})
end


