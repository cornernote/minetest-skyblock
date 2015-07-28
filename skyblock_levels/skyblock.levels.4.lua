--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 4
skyblock.levels[level] = {}


-- get pos
skyblock.levels[level].get_pos = function(player_name)
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+80,z=pos.z}
end


-- make start blocks
skyblock.levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = skyblock.levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 10
	local hollow = 1
	skyblock.levels({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)

	-- level 4
	--minetest.env:add_node(pos, {name='skyblock:level_4'})

end


-- get level information
skyblock.levels[level].get_info = function(player_name)
	local info = { level=level, total=1, count=0, player_name=player_name, infotext='', formspec = '' };
	info.formspec = skyblock.levels.get_inventory_formspec(level,info.player_name)
		..'label[0,0.5; THE END]'
		..'label[0,1.0; I hope you enjoyed your journey, and you]'
		..'label[0,1.5; are welcome to stay and keep building]'
		..'label[0,2.0; your new sky world.]'
	info.infotext = 'THE END! for '.. player_name ..' ... or is it ...'
	return info
end


-- not used
skyblock.levels[level].reward_feat = function(player_name,feat) end
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode) end
skyblock.levels[level].on_dignode = function(pos, oldnode, digger) end
skyblock.levels[level].on_item_eat = function(player_name, itemstack) end
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing) end
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end