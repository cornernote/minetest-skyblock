--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER NODE

]]--


-- indestructable spawn block
if skyblock.NEW_SPAWN_ON_DEATH == 1 then
	-- not diggable
	minetest.register_node("skyblock:spawn", {
		description = "spawnblock",
		tiles = {"default_nc_rb.png"},
		is_ground_content = true,
		on_construct = achievements.init,
		on_punch = achievements.update,
	})
else
	-- respawn on dig
	minetest.register_node("skyblock:spawn", {
		description = "spawnblock",
		tiles = {"default_nc_rb.png"},
		is_ground_content = true,
		on_construct = achievements.init,
		on_punch = achievements.update,
		groups = {crumbly=2,cracky=2},
		on_dig = skyblock.on_dig_spawn,
	})
end

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

-- sandstone should drop 4 sand
minetest.register_node(":default:sandstone", {
	description = "Sandstone",
	tiles = {"default_sandstone.png"},
	is_ground_content = true,
	groups = {crumbly=2,cracky=2},
	drop = 'default:sandstone',
	sounds = default.node_sound_stone_defaults(),
})

-- track bucket achievements
minetest.register_craftitem(":bucket:bucket_empty", {
	description = "Emtpy bucket",
	inventory_image = "bucket.png",
	stack_max = 1,
	liquids_pointable = true,
	on_use = achievements.bucket_on_use,
})

-- prevent lava bucket grief
minetest.register_craftitem(":bucket:bucket_lava", {
	description = "Emtpy bucket",
	inventory_image = "bucket_lava.png",
	stack_max = 1,
	liquids_pointable = true,
	on_use = skyblock.bucket_lava_on_use,
})


