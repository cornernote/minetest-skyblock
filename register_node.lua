--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER NODE

]]--


-- indestructable spawn block
minetest.register_node("skyblock:spawn", {
	description = "spawnblock",
	tiles = {"default_nc_rb.png"},
	is_ground_content = true,
})

-- stone should give a random drop
minetest.register_node(":default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	is_ground_content = true,
	groups = {cracky=3},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:mese"}, rarity = 150},
			{items = {"default:desert_stone"}, rarity = 20},
			{items = {"default:sandstone"}, rarity = 10},
			{items = {"default:cobble"}}
		}
	},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

-- trees should not be choppable by hand
minetest.register_node(":default:tree", {
	description = "Tree",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	is_ground_content = true,
	groups = {tree=1,snappy=1,choppy=2,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

-- leaves should be climbable and drop sticks
minetest.register_node(":default:leaves", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:nyancat"}, rarity = 500},
			{items = {"default:leaves"}}
		}
	},
	climbable = true,
	sounds = default.node_sound_leaves_defaults(),
	walkable = false,
})
