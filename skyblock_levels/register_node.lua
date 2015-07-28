--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--


-- quest node
local entity = skyblock.registered('node','skyblock:quest')
entity.on_punch = function(pos, node, puncher)
	if not puncher then return end -- needed to prevent server crash when player leaves
	--local level = skyblock.feats.get_level(puncher:get_player_name())
	skyblock.feats.update(puncher:get_player_name())
end
--entity.on_dig = function(pos, node, digger)
	--if not digger then return end -- needed to prevent server crash when player leaves
	--local player_name = digger:get_player_name()
	--local spawn = skyblock.get_spawn(player_name)
	--skyblock.levels.spawn_diggers[player_name] = true
	--digger:set_hp(0)
--end
entity.on_receive_fields = function(pos, formname, fields, sender)
	skyblock.bags.on_receive_fields(sender, formname, fields)
	skyblock.home.on_receive_fields(sender, formname, fields)
	skyblock.craft_guide.on_receive_fields(sender, formname, fields)
end
minetest.register_node(':skyblock:quest', entity)

-- stone
local entity = skyblock.registered('node','default:stone')
entity.drop = {
	max_items = 1,
	items = {
		{items = {'default:desert_stone'}, rarity = 20},
		{items = {'default:sandstone'}, rarity = 10},
		{items = {'default:cobble'}}
	}
}
minetest.register_node(':default:stone', entity)

-- tree
local entity = skyblock.registered('node','default:tree')
entity.groups.oddly_breakable_by_hand = 0
minetest.register_node(':default:tree', entity)

-- jungletree
local entity = skyblock.registered('node','default:jungletree')
entity.groups.oddly_breakable_by_hand = 0
minetest.register_node(':default:jungletree', entity)

-- pinetree
local entity = skyblock.registered('node','default:pinetree')
entity.groups.oddly_breakable_by_hand = 0
minetest.register_node(':default:pinetree', entity)

-- leaves
local entity = skyblock.registered('node','default:leaves')
--entity.drop = 'default:leaves'
entity.climbable = true
entity.walkable = false
minetest.register_node(':default:leaves', entity)

-- jungleleaves
local entity = skyblock.registered('node','default:jungleleaves')
--entity.drop = 'default:jungleleaves'
entity.climbable = true
entity.walkable = false
minetest.register_node(':default:jungleleaves', entity)

-- pine_needles
local entity = skyblock.registered('node','default:pine_needles')
--entity.drop = 'default:pine_needles'
entity.climbable = true
entity.walkable = false
minetest.register_node(':default:pine_needles', entity)

-- sandstone
local entity = skyblock.registered('node','default:sandstone')
entity.drop = 'default:sandstone'
minetest.register_node(':default:sandstone', entity)

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