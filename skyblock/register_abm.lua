--[[

SkyBlock for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER ABM

]]--


-- flora and dry_shrub spawns on sand, desert_sand and dirt_with_grass
minetest.register_abm({
	nodenames = {"default:sand", "default:desert_sand", "default:dirt_with_grass"},
	interval = 300,
	chance = 100,
	action = function(pos, node)
		skyblock.log("consider spawn flora or dry_shrub at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
		pos.y = pos.y+1

		local light = minetest.get_node_light(pos)
		if not light or light < 13 then
			return
		end

		-- check for nearby
		if minetest.env:find_node_near(pos, 2, {"group:flora"}) ~= nil then
			return
		end

		if minetest.env:get_node(pos).name == "air" then
			local rand = math.random(1,9);
			local node
			if rand==1 then
				node = "default:dry_shrub"
			elseif rand==2 then
				node = "default:junglegrass"
			elseif rand==3 then
				node = "default:grass_1"
			elseif rand==4 then
				node = "flowers:dandelion_white"
			elseif rand==5 then
				node = "flowers:dandelion_yellow"
			elseif rand==6 then
				node = "flowers:geranium"
			elseif rand==7 then
				node = "flowers:rose"
			elseif rand==8 then
				node = "flowers:tulip"
			elseif rand==9 then
				node = "flowers:viola"
			end
			skyblock.log("spawn "..node.." at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
			minetest.env:set_node(pos, {name=node})
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
		skyblock.log("consider spawn papyrus at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
		-- check for space
		for i=1,2 do
			if minetest.env:get_node({x = pos.x, y = pos.y + i, z = pos.z}).name ~= "air" then
				return
			end
		end
		-- spawn
		skyblock.log("spawn papyrus at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
		minetest.env:set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name="default:papyrus"})
	end
})

-- cactus spawns on sand and desert_sand
minetest.register_abm({
	nodenames = {"default:sand", "default:desert_sand"},
	interval = 300,
	chance = 150,
	action = function(pos, node)
		skyblock.log("consider spawn cactus at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
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
		skyblock.log("spawn cactus at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
		minetest.env:set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name="default:cactus"})
	end
})

-- dirt turns to dirt_with_grass if light
minetest.register_abm({
	nodenames = {"default:dirt"},
	neighbors = {"air"},
	interval = 50,
	chance = 100,
	action = function(pos)
		skyblock.log("consider grow dirt_with_grass at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
		local light = minetest.get_node_light(pos)
		if light >= 13 then
			return
		end
		skyblock.log("grow dirt_with_grass at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
		minetest.env:add_node(pos, {name="default:dirt_with_grass"})
	end
})

-- dirt_with_grass turns to dirt if no light
minetest.register_abm({
	nodenames = {"default:dirt_with_grass"},
	interval = 50,
	chance = 300,
	action = function(pos)
		skyblock.log("consider kill dirt_with_grass at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
		local light = minetest.get_node_light(pos)
		if not light or light < 13 then
			return
		end
		skyblock.log("kill dirt_with_grass at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
		minetest.env:add_node(pos, {name="default:dirt"})
	end
})

-- dirt_with_grass_footsteps turns to dirt_with_grass
minetest.register_abm({
	nodenames = {"default:dirt_with_grass_footsteps"},
	interval = 5,
	chance = 10,
	action = function(pos)
		skyblock.log("consider grow dirt or dirt_with_grass at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
   		if minetest.env:get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
			skyblock.log("grow dirt_with_grass at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
			minetest.env:add_node(pos, {name="default:dirt_with_grass"})
		else
			skyblock.log("grow dirt at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
			minetest.env:add_node(pos, {name="default:dirt"})
   		end
	end
})

-- water or lava at sealevel
if skyblock.MODE == "water" or skyblock.MODE == "lava"  then
	local node_name = "default:water_flowing"
	local node_replace = "default:water_source"
	if skyblock.MODE == "lava" then
		node_name = "default:lava_flowing"
		node_replace = "default:lava_source"
	end
	minetest.register_abm({
		nodenames = {node_name},
		neighbors = {"air"},
		interval = 2,
		chance = 10,
		action = function(pos, node)
			skyblock.log("consider create "..node_replace.." at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
			if pos.y <= 2 then
				skyblock.log("create "..node_replace.." at "..skyblock.dump_pos(pos).." on "..minetest.env:get_node(pos).name)
				minetest.env:set_node(pos, {name=node_replace})
			end
		end
	})
end

-- remove bones
minetest.register_abm({
	nodenames = {"bones:bones"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		minetest.env:remove_node(pos)
	end,
})