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
	chance = 10,
	action = function(pos)
		skyblock.generate_tree(pos)
    end
})

-- junglegrass and dry_shrub spawns on sand, desert_sand and dirt_with_grass
minetest.register_abm({
	nodenames = {"default:sand", "default:desert_sand", "default:dirt_with_grass"},
	interval = 300,
	chance = 100,
	action = function(pos, node)
		pos.y = pos.y+1
		if minetest.env:get_node(pos).name == "air" and minetest.env:find_node_near(pos, 4, {"default:dry_shrub","default:junglegrass"})==nil then
			if math.random(1,5) > 2 then
				minetest.env:set_node(pos, {name="default:dry_shrub"})
			else
				minetest.env:set_node(pos, {name="default:junglegrass"})
			end
		end
	end
})

-- papyrus spawns on dirt_with_grass next to water_source
minetest.register_abm({
	nodenames = {"default:dirt_with_grass"},
	neighbors = {"default:water_source"},
	interval = 300,
	chance = 100,
	action = function(pos, node)
		-- check for space
		for i=1,2 do
			if minetest.env:get_node({x = pos.x, y = pos.y + i, z = pos.z}).name ~= "air" then
				return
			end
		end
		-- spawn
		minetest.env:set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name="default:papyrus"})
	end
})

-- papyrus grows upto 3 in height
minetest.register_abm({
	nodenames = {"default:papyrus"},
	interval = 100,
	chance = 50,
	action = function(pos, node)
		-- check for space
		for i=1,2 do
			if minetest.env:get_node({x = pos.x, y = pos.y + i, z = pos.z}).name ~= "air" then
				return
			end
		end
		-- check height
		if minetest.env:get_node({x = pos.x, y = pos.y - 3, z = pos.z}).name == "default:papyrus" then
			return
		end
		-- grow
		minetest.env:set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name="default:papyrus"})
	end
})

-- cactus spawns on sand and desert_sand
minetest.register_abm({
	nodenames = {"default:sand", "default:desert_sand"},
	interval = 300,
	chance = 150,
	action = function(pos, node)
		-- check for space
		for i=1,2 do
			if minetest.env:get_node({x = pos.x, y = pos.y + i, z = pos.z}).name ~= "air" then
				return
			end
		end
		-- check for nearby
		if minetest.env:find_node_near(pos, 6, {"default:cactus"}) ~= nil then
			return
		end
		-- spawn
		minetest.env:set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name="default:cactus"})
	end
})

-- cactus grows upto 4 in height
minetest.register_abm({
	nodenames = {"default:cactus"},
	interval = 200,
	chance = 50,
	action = function(pos, node)
		-- check for space
		for i=1,2 do
			if minetest.env:get_node({x = pos.x, y = pos.y + i, z = pos.z}).name ~= "air" then
				return
			end
		end
		-- check height
		if minetest.env:get_node({x = pos.x, y = pos.y - 4, z = pos.z}).name == "default:cactus" then
			return
		end
		-- grow
		minetest.env:set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name="default:cactus"})
	end
})

-- dirt turns to dirt_with_grass if below air
minetest.register_abm({
	nodenames = {"default:dirt"},
	neighbors = {"air"},
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


-- water at sealevel
if skyblock.SEA then
	minetest.register_abm({
		nodenames = {"default:water_flowing"},
		neighbors = {"air"},
		interval = 1,
		chance = 10,
		action = function(pos, node)
			if pos.y <= 2 then
				minetest.env:set_node(pos, {name="default:water_source"})
			end
		end
	})
end