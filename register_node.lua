--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER NODE

]]--


--
-- Level Nodes
--

for level=1,4 do
	minetest.register_node("skyblock:level_"..level, {
		description = "Level "..level,
		tiles = {"default_nc_rb.png"},
		is_ground_content = true,
		groups = {crumbly=2,cracky=2},
		on_punch = function(pos, node, puncher)
			achievements.level_on_punch(level, pos, node, puncher)
		end,
		on_dig = function(pos, node, digger)
			achievements.level_on_dig(level, pos, node, digger)
		end,
	})
end


--
-- Override Default Nodes
--

-- stone should give a random drop
minetest.register_node(":default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	is_ground_content = true,
	groups = {cracky=3},
	drop = {
		max_items = 1,
		items = {
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

-- leaves should be climbable
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
			--{items = {"default:nyancat"}, rarity = 1000},
			{items = {"default:leaves"}}
		}
	},
	climbable = true,
	sounds = default.node_sound_leaves_defaults(),
	walkable = false,
})

-- sapling generates a tree on place
minetest.register_node(":default:sapling", {
	description = "Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_sapling.png"},
	inventory_image = "default_sapling.png",
	wield_image = "default_sapling.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy=2,dig_immediate=3,flammable=2},
	sounds = default.node_sound_defaults(),
	after_place_node = skyblock.generate_tree,
})

-- sandstone should drop 4 sand
minetest.register_node(":default:sandstone", {
	description = "Sandstone",
	tiles = {"default_sandstone.png"},
	is_ground_content = true,
	groups = {crumbly=2,cracky=2},
	drop = 'default:sandstone',
	sounds = default.node_sound_stone_defaults(),
})

-- handle bucket usage
minetest.register_craftitem(":bucket:bucket_empty", {
	description = "Emtpy bucket",
	inventory_image = "bucket.png",
	stack_max = 1,
	liquids_pointable = true,
	on_use = skyblock.bucket_on_use,
})

-- prevent lava bucket grief
minetest.register_craftitem(":bucket:bucket_lava", {
	description = "Emtpy bucket",
	inventory_image = "bucket_lava.png",
	stack_max = 1,
	liquids_pointable = true,
	on_use = skyblock.bucket_lava_on_use,
})


