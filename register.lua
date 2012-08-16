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
		end
		
	end
end)


--
-- NODE ENTRIES
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
			{items = {'default:mese'}, rarity = 500},
			{items = {'default:iron_lump'}, rarity = 200},
			{items = {'default:coal_lump'}, rarity = 100},
			{items = {'default:gravel'}, rarity = 50},
			{items = {'default:sand'}, rarity = 9},
			{items = {'default:dirt'}, rarity = 4},
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

-- indestructable spawn block
minetest.register_node("skyblock:spawn", {
	description = "spawnblock",
	tiles = {"default_nc_rb.png"},
	is_ground_content = true,
})


--
-- ABM ENTRIES
--

-- sapling grows to tree
minetest.register_abm({
	nodenames = "default:sapling",
	interval = 60,
	chance = 15,
	action = function(pos)
   		if minetest.env:get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
   			skyblock.generate_tree(pos)
   		end
    end
})

-- dirt turns to dirt_with_grass if below air
minetest.register_abm({
	nodenames = {"default:dirt"},
	interval = 3600,
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
	interval = 3600,
	chance = 100,
	action = function(pos)
   		if minetest.env:get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name ~= "air" then
			minetest.env:add_node(pos, {name="default:dirt"})
   		end
    end
})

-- lava_flowing next to water_source or water_flowing will turn to stone
minetest.register_abm({
	nodenames = {"default:lava_flowing"},
	neighbors = {"default:water_source", "default:water_flowing"},
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