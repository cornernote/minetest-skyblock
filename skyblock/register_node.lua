--[[

SkyBlock for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER NODES

]]--


--
-- Override Default Nodes
--

local entity

-- stone
entity = skyblock.registered("node","default:stone")
entity.drop = {
	max_items = 1,
	items = {
		{items = {"default:desert_stone"}, rarity = 20},
		{items = {"default:sandstone"}, rarity = 10},
		{items = {"default:cobble"}}
	}
}
minetest.register_node(":default:stone", entity)

-- trees
entity = skyblock.registered("node","default:tree")
entity.groups = {tree=1,snappy=1,choppy=2,flammable=2}
minetest.register_node(":default:tree", entity)

-- leaves
entity = skyblock.registered("node","default:leaves")
entity.drop = "default:leaves"
entity.groups = {oddly_breakable_by_hand=1, snappy=3, leafdecay=3, flammable=2}
entity.climbable = true
minetest.register_node(":default:leaves", entity)

-- sapling
entity = skyblock.registered("node","default:sapling")
entity.after_place_node = skyblock.generate_tree
minetest.register_node(":default:sapling", entity)

-- sandstone
entity = skyblock.registered("node","default:sandstone")
entity.drop = "default:sandstone"
minetest.register_node(":default:sandstone", entity)

-- bucket_empty
entity = skyblock.registered("craftitem","bucket:bucket_empty")
entity.on_use = skyblock.bucket_on_use
minetest.register_craftitem(":bucket:bucket_empty", entity)

-- bucket_water
entity = skyblock.registered("craftitem","bucket:bucket_water")
entity.on_use = skyblock.bucket_water_on_use
minetest.register_craftitem(":bucket:bucket_water", entity)

-- bucket_lava
entity = skyblock.registered("craftitem","bucket:bucket_lava")
entity.on_use = skyblock.bucket_lava_on_use
minetest.register_craftitem(":bucket:bucket_lava", entity)
