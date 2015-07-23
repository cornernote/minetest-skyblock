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
entity.drop = {
	max_items = 1,
	items = {
		{items = {'default:pine_sapling'},rarity = 40},
		{items = {'default:junglesapling'},rarity = 30},
		{items = {'default:sapling'},rarity = 20},
		{items = {'default:leaves'}}
	}
}
entity.climbable = true
entity.walkable = false
minetest.register_node(':default:leaves', entity)

-- jungleleaves
entity = skyblock.registered('node','default:jungleleaves')
entity.drop = {
	max_items = 1,
	items = {
		{items = {'default:sapling'},rarity = 40},
		{items = {'default:pine_sapling'},rarity = 30},
		{items = {'default:junglesapling'},rarity = 20},
		{items = {'default:jungleleaves'}}
	}
}
entity.climbable = true
entity.walkable = false
minetest.register_node(':default:jungleleaves', entity)

-- pine_needles
entity = skyblock.registered('node','default:pine_needles')
entity.drop = {
	max_items = 1,
	items = {
		{items = {'default:junglesapling'},rarity = 40},
		{items = {'default:sapling'},rarity = 30},
		{items = {'default:pine_sapling'},rarity = 20},
		{items = {'default:pine_needles'}}
	}
}
entity.climbable = true
entity.walkable = false
minetest.register_node(':default:pine_needles', entity)

-- sapling
entity = skyblock.registered('node','default:sapling')
entity.after_place_node = skyblock.generate_tree
minetest.register_node(':default:sapling', entity)

-- sandstone
entity = skyblock.registered('node','default:sandstone')
entity.drop = 'default:sandstone'
minetest.register_node(':default:sandstone', entity)

-- bucket_empty
entity = skyblock.registered('craftitem','bucket:bucket_empty')
entity.on_use = skyblock.bucket_on_use
minetest.register_craftitem(':bucket:bucket_empty', entity)

-- bucket_water
entity = skyblock.registered('craftitem','bucket:bucket_water')
entity.on_use = skyblock.bucket_water_on_use
minetest.register_craftitem(':bucket:bucket_water', entity)

-- bucket_lava
entity = skyblock.registered('craftitem','bucket:bucket_lava')
entity.on_use = skyblock.bucket_lava_on_use
minetest.register_craftitem(':bucket:bucket_lava', entity)
