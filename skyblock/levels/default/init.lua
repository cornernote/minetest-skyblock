--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL LOADER

]]--

--
-- Level Files
--

levels = {}
dofile(minetest.get_modpath('skyblock')..'/levels/default/level_1.lua')
dofile(minetest.get_modpath('skyblock')..'/levels/default/level_2.lua')
dofile(minetest.get_modpath('skyblock')..'/levels/default/level_3.lua')
dofile(minetest.get_modpath('skyblock')..'/levels/default/level_4.lua')


-- add inventory_plus page when a player joins
minetest.register_on_joinplayer(function(player)
    inventory_plus.register_button(player,"skyblock","Missions")
end)
 
-- each time a player clicks an inventory button, this is called
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.skyblock then
		inventory_plus.set_inventory_formspec(player, achievements.get_formspec(player:get_player_name(),"skyblock"))
		return
	end
	if fields.restart then
		-- todo
		return
	end
end)

-- add rewards to player inventory
minetest.register_on_joinplayer(function(player)
	player:get_inventory():set_size('rewards', 4)
	inventory_plus.set_inventory_formspec(player, achievements.get_formspec(player:get_player_name(),"skyblock"))
end)


--
-- Level Nodes
--

for level=1,4 do
	minetest.register_node('skyblock:level_'..level, {
		description = 'Level '..level,
		tiles = {'skyblock_'..level..'.png'},
		is_ground_content = true,
		paramtype = 'light',
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
			minetest.env:get_meta(pos):get_inventory():set_size('rewards', 2*2)
		end,
	})
end


