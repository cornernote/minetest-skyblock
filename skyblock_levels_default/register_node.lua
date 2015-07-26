--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL LOADER

]]--


-- quest node
local spawn_diggers = {}
local entity = skyblock.registered('node','skyblock:quest')
entity.on_punch = function(pos, node, puncher)
	if not puncher then return end -- needed to prevent server crash when player leaves
	achievements.update(puncher:get_player_name())
end
entity.on_dig = function(pos, node, digger)
	if not digger then return end -- needed to prevent server crash when player leaves
	local player_name = digger:get_player_name()
	local spawn = skyblock.get_spawn(player_name)
	--levels.spawn_diggers[player_name] = true
	digger:set_hp(0)
end
entity.on_receive_fields = function(pos, formname, fields, sender)
	if fields.quit then
		return
	end
	-- if an item was clicked show skyblock_craft_guide
	for k,v in pairs( fields ) do
		if string.match(k, ":") then
			skyblock_craft_guide.inspect_show_crafting(player:get_player_name(), k, fields)
			return;
		end
	end
end
minetest.register_node(':skyblock:quest', entity)


-- instant grow sapling if there is room
local entity = skyblock.registered('node','default:sapling')
entity.after_place_node = function(pos)
	skyblock.log('generate_tree() at '..skyblock.dump_pos(pos))
	
	-- check if we have space to make a tree
	for dy=1,4 do
		pos.y = pos.y+dy
		if minetest.env:get_node(pos).name ~= 'air' then
			return
		end
		pos.y = pos.y-dy
	end
	
	local node = {name = ''}

	-- add the tree
	default.grow_tree(pos, math.random(1, 4) == 1)
end
minetest.register_node(':default:sapling', entity)