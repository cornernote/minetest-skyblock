--[[

SkyBlock for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER CRAFT

]]--


-- tool repair buff (20% bonus)
minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.20,
})

-- desert_stone
minetest.register_craft({
	output = "default:desert_stone",
	recipe = {
		{"default:desert_sand", "default:desert_sand"},
		{"default:desert_sand", "default:desert_sand"},
	}
})

-- mossycobble
minetest.register_craft({
	output = "default:mossycobble",
	recipe = {
		{"default:junglegrass"},
		{"default:cobble"},
	}
})

-- stone_with_coal
minetest.register_craft({
	output = "default:stone_with_coal 2",
	recipe = {
		{"default:coal_lump"},
		{"default:stone"},
	}
})

-- stone_with_iron
minetest.register_craft({
	output = "default:stone_with_iron 2",
	recipe = {
		{"default:iron_lump"},
		{"default:stone"},
	}
})

-- stone_with_copper
minetest.register_craft({
	output = "default:stone_with_copper 2",
	recipe = {
		{"default:copper_ingot"},
		{"default:stone"},
	}
})

-- stone_with_diamond
minetest.register_craft({
	output = "default:stone_with_diamond 2",
	recipe = {
		{"default:diamond"},
		{"default:stone"},
	}
})

-- stone_with_gold
minetest.register_craft({
	output = "default:stone_with_gold 2",
	recipe = {
		{"default:gold_ingot"},
		{"default:stone"},
	}
})

-- stone_with_mese
minetest.register_craft({
	output = "default:stone_with_mese 2",
	recipe = {
		{"default:mese_crystal"},
		{"default:stone"},
	}
})

-- gravel
minetest.register_craft({
	output = "default:gravel 4",
	recipe = {
		{"default:cobble"},
	}
})

-- dirt
minetest.register_craft({
	output = "default:dirt 2",
	recipe = {
		{"default:gravel"},
	}
})

-- clay_lump
minetest.register_craft({
	output = "default:clay_lump 4",
	recipe = {
		{"default:dirt"},
	}
})

-- dirt_with_grass
minetest.register_craft({
	output = "default:dirt_with_grass",
	recipe = {
		{"default:junglegrass"},
		{"default:dirt"},
	}
})

-- locked_chest from chest
minetest.register_craft({
	output = "default:chest_locked",
	recipe = {
		{"default:steel_ingot"},
		{"default:chest"},
	}
})

-- sapling from leaves and sticks
minetest.register_craft({
	output = "default:sapling",
	recipe = {
		{"default:leaves", "default:leaves", "default:leaves"},
		{"default:leaves", "default:leaves", "default:leaves"},
		{"", "default:stick", ""},
	}
})

-- recycle desert_sand from desert_stone
minetest.register_craft({
	output = "default:desert_sand 4",
	recipe = {
		{"default:desert_stone"},
	}
})

-- jungletree turns to wood
minetest.register_craft({
	output = "default:wood 4",
	recipe = {
		{"default:jungletree"},
	}
})


