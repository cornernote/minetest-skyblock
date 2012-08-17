--[[

SkyBlock Registry
Copyright (C) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>

]]--


--
-- ALIAS ENTRIES
--

minetest.register_alias("mapgen_air", "air")
minetest.register_alias("mapgen_stone", "air")
minetest.register_alias("mapgen_tree", "air")
minetest.register_alias("mapgen_leaves", "air")
minetest.register_alias("mapgen_apple", "air")
minetest.register_alias("mapgen_water_source", "air")
minetest.register_alias("mapgen_dirt", "air")
minetest.register_alias("mapgen_sand", "air")
minetest.register_alias("mapgen_gravel", "air")
minetest.register_alias("mapgen_clay", "air")
minetest.register_alias("mapgen_lava_source", "air")
minetest.register_alias("mapgen_cobble", "air")
minetest.register_alias("mapgen_mossycobble", "air")
minetest.register_alias("mapgen_dirt_with_grass", "air")
minetest.register_alias("mapgen_junglegrass", "air")
minetest.register_alias("mapgen_stone_with_coal", "air")
minetest.register_alias("mapgen_stone_with_iron", "air")
minetest.register_alias("mapgen_mese", "air")
minetest.register_alias("mapgen_desert_sand", "air")
minetest.register_alias("mapgen_desert_stone", "air")


--
-- CRAFT ENTRIES
--

-- clay
minetest.register_craft({
	output = 'default:clay',
	recipe = {
		{'default:dirt', 'default:dirt'},
		{'default:dirt', 'default:dirt'},
	}
})

-- desert_stone
minetest.register_craft({
	output = 'default:desert_stone',
	recipe = {
		{'default:desert_sand', 'default:desert_sand'},
		{'default:desert_sand', 'default:desert_sand'},
	}
})

-- mossycobble
minetest.register_craft({
	type = "cooking",
	output = "default:mossycobble",
	recipe = "default:stone",
})

-- stone_with_coal
minetest.register_craft({
	output = 'default:stone_with_coal',
	recipe = {
		{'default:coal_lump'},
		{'default:stone'},
	}
})

-- stone_with_iron
minetest.register_craft({
	output = 'default:stone_with_iron',
	recipe = {
		{'default:iron_lump'},
		{'default:stone'},
	}
})

-- gravel
minetest.register_craft({
	type = "cooking",
	output = "default:gravel",
	recipe = "default:mossycobble",
})

-- scorched_stuff
minetest.register_craft({
	type = "cooking",
	output = "default:scorched_stuff",
	recipe = "default:gravel",
})


--
-- PLAYER ENTRIES
--

-- respawn to player spawn position
minetest.register_on_respawnplayer(function(player)
	player:setpos(skyblock.get_spawn(player:get_player_name()))
	return true
end)

-- fall below the bottom and lose all items then die and go back spawn
local spawned_players = {}
minetest.register_globalstep(function(dtime)
	for k,player in ipairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		
		-- player has not spawned yet
		if spawned_players[player:get_player_name()] == nil then
			-- handle new player spawn setup
			if skyblock.spawn_new_player(player) then
				spawned_players[player:get_player_name()] = true
			end

		-- player is spawned
		else
			-- hit the bottom, kill them
			if pos.y < skyblock.WORLD_BOTTOM then
				skyblock.respawn_player(player)
			end
			-- walking on dirt_with_grass, change to dirt_with_grass_footsteps
			local np = {x=pos.x,y=pos.y-1,z=pos.z}
			if (minetest.env:get_node(np).name == "default:dirt_with_grass") then
				minetest.env:add_node(np, {name="default:dirt_with_grass_footsteps"})
			end
		end
		
	end
end)


--
-- NODE ENTRIES
--

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
			{items = {'default:nyancat'}, rarity = 1000},
			{items = {'default:mese'}, rarity = 250},
			{items = {'default:iron_lump'}, rarity = 100},
			{items = {'default:coal_lump'}, rarity = 20},
			{items = {'default:desert_sand'}, rarity = 16},
			{items = {'default:sand'}, rarity = 8},
			{items = {'default:dirt'}, rarity = 3},
			{items = {'default:cobble'}}
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
			{
				items = {'default:sapling'},
				rarity = 15,
			},
			{
				items = {'default:stick'},
				rarity = 10,
			},
			{
				items = {'default:leaves'},
			}
		}
	},
	climbable = true,
	sounds = default.node_sound_leaves_defaults(),
	walkable = false,
})


--
-- ABM ENTRIES
--

-- sapling grows to tree
minetest.register_abm({
	nodenames = "default:sapling",
	interval = 30,
	chance = 5,
	action = function(pos)
		skyblock.generate_tree(pos)
    end
})

-- junglegrass/dry_shrub spawns on sand, desert_sand and dirt_with_grass
minetest.register_abm({
	nodenames = {"default:sand", "default:desert_sand", "default:dirt_with_grass"},
	interval = 150,
	chance = 10,
	action = function(pos, node)
		pos.y = pos.y+1
		if minetest.env:get_node(pos).name == "air" and minetest.env:find_node_near(pos, 4, {"default:dry_shrub","default:junglegrass"})==nil then
			if math.random(0,3) then
				minetest.env:set_node(pos, {name="default:dry_shrub"})
			else
				minetest.env:set_node(pos, {name="default:junglegrass"})
			end
		end
	end
})

-- cactus spawns on sand and desert_sand
minetest.register_abm({
	nodenames = {"default:sand", "default:desert_sand"},
	interval = 300,
	chance = 150,
	action = function(pos, node)
		for y=0,math.random(1,4) do
			pos.y = pos.y+1
			if minetest.env:get_node(pos).name == "air" and minetest.env:find_node_near(pos, 6, {"default:cactus"})==nil then
				minetest.env:set_node(pos, {name="default:cactus"})
			end
		end
	end
})

-- papyrus spawns on dirt and dirt_with_grass if next to water
minetest.register_abm({
	nodenames = {"default:dirt", "default:dirt_with_grass"},
	neighbors = {"default:water_source", "default:water_flowing"},
	interval = 300,
	chance = 50,
	action = function(pos, node)
		for y=0,math.random(1,4) do
			pos.y = pos.y+1
			if minetest.env:get_node(pos).name == "air" then
				minetest.env:set_node(pos, {name="default:papyrus"})
			end
		end
	end
})

-- dirt turns to dirt_with_grass if below air
minetest.register_abm({
	nodenames = {"default:dirt"},
	neighbors = {"default:air"},
	interval = 50,
	chance = 100,
	action = function(pos)
   		if minetest.env:get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
			minetest.env:add_node(pos, {name="default:dirt_with_grass"})
   		end
    end
})

-- dirt_with_grass turns to dirt if not below air
minetest.register_abm({
	nodenames = {"default:dirt_with_grass"},
	interval = 50,
	chance = 300,
	action = function(pos)
   		if minetest.env:get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
			minetest.env:add_node(pos, {name="default:dirt"})
   		end
    end
})

-- dirt_with_grass_footsteps turns to dirt_with_grass
minetest.register_abm({
	nodenames = {"default:dirt_with_grass_footsteps"},
	interval = 5,
	chance = 10,
	action = function(pos)
   		if minetest.env:get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
			minetest.env:add_node(pos, {name="default:dirt_with_grass"})
		else
			minetest.env:add_node(pos, {name="default:dirt"})
   		end
    end
})

-- lava_flowing next to water_source will turn to stone
minetest.register_abm({
	nodenames = {"default:lava_flowing"},
	neighbors = {"default:water_source"},
	interval = 2,
	chance = 1,
	action = function(pos)
		minetest.env:add_node(pos, {name="default:stone"})
	end,
})

-- lava_source next to water_flowing will turn the water_flowing to stone
-- lava_source next to water_source will turn the lava_source to stone
minetest.register_abm({
	nodenames = {"default:lava_source"},
	neighbors = {"default:water_source", "default:water_flowing"},
	interval = 2,
	chance = 1,
	action = function(pos)
		local waterpos = minetest.env:find_node_near(pos,1,{"default:water_flowing"})
		if waterpos==nil then
			minetest.env:add_node(pos, {name="default:stone"})
		else
			while waterpos ~=nil do
				minetest.env:add_node(waterpos, {name="default:stone"})
				waterpos = minetest.env:find_node_near(pos,1,{"default:water_flowing"})
			end
		end
	end,
})