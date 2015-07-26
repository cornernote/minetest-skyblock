--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER NODES

]]--


--
-- Override Default Nodes
--

local entity

-- skyblock
minetest.register_node('skyblock:quest', {
	description = 'Skyblock',
	tiles = {'skyblock_quest.png'},
	is_ground_content = true,
	paramtype = 'light',
	light_propagates = true,
	sunlight_propagates = true,
	light_source = 15,		
	groups = {crumbly=2,cracky=2}
})

-- stone
entity = skyblock.registered('node','default:stone')
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
entity = skyblock.registered('node','default:tree')
entity.groups.oddly_breakable_by_hand = 0
minetest.register_node(':default:tree', entity)

-- jungletree
entity = skyblock.registered('node','default:jungletree')
entity.groups.oddly_breakable_by_hand = 0
minetest.register_node(':default:jungletree', entity)

-- pinetree
entity = skyblock.registered('node','default:pinetree')
entity.groups.oddly_breakable_by_hand = 0
minetest.register_node(':default:pinetree', entity)

-- leaves
entity = skyblock.registered('node','default:leaves')
entity.drop = 'default:leaves'
entity.climbable = true
entity.walkable = false
minetest.register_node(':default:leaves', entity)

-- jungleleaves
entity = skyblock.registered('node','default:jungleleaves')
entity.drop = 'default:jungleleaves'
entity.climbable = true
entity.walkable = false
minetest.register_node(':default:jungleleaves', entity)

-- pine_needles
entity = skyblock.registered('node','default:pine_needles')
entity.drop = 'default:pine_needles'
entity.climbable = true
entity.walkable = false
minetest.register_node(':default:pine_needles', entity)

-- sandstone
entity = skyblock.registered('node','default:sandstone')
entity.drop = 'default:sandstone'
minetest.register_node(':default:sandstone', entity)

