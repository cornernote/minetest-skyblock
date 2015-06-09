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

local max_level = 5

levels = {}
for level=1,max_level do
	dofile(minetest.get_modpath("skyblock").."/levels/extended/level_"..tostring( level)..".lua")
end

--
-- Level Nodes
--

for level=1,max_level do
	minetest.register_node("skyblock:level_"..level, {
		description = "Level "..level,
		tiles = {"skyblock_"..level..".png"},
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


