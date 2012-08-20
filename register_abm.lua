--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER ABM

]]--


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
			if math.random(1,10) > 4 then
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