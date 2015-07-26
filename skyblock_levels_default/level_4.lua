--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 4 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 4
levels[level] = {}


-- get pos
levels[level].get_pos = function(player_name)
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+80,z=pos.z}
end


-- make start blocks
levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 10
	local hollow = 1
	skyblock.levels({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)

	-- level 4
	minetest.env:add_node(pos, {name='skyblock:level_4'})

end


-- get level information
levels[level].get_info = function(player_name)
	local info = { level=level, total=0, count=0, player_name=player_name, infotext='', formspec = '' };
	info.formspec = levels.get_inventory_formspec(level)
		..'label[0,0.5; THE END]'
		..'label[0,1.0; I hope you enjoyed your journey, and you]'
		..'label[0,1.5; are welcome to stay and keep building]'
		..'label[0,2.0; your new sky world.]'
	info.infotext = 'THE END! for '.. player_name ..' ... or is it ...'
	return info
end


-- not used
levels[level].reward_achievement = function(player_name,achievement) end
levels[level].on_placenode = function(pos, newnode, placer, oldnode) end
levels[level].on_dignode = function(pos, oldnode, digger) end
levels[level].bucket_on_use = function(player_name, pointed_thing) end
levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end