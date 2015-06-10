--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 1 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 1
levels[level] = {}


-- get pos
levels[level].get_pos = function(player_name)
	skyblock.log("level["..level.."].get_pos() for "..player_name)
	return skyblock.has_spawn(player_name)
end


-- make start blocks
levels[level].make_start_blocks = function(pos, player_name)
	skyblock.log("level["..level.."].make_start_blocks() for "..player_name)

	-- level 0 - spawn
	minetest.env:add_node(pos, {name="skyblock:level_1"})
	achievements.update(level,player_name)
	
	-- level 0 - dirt
	for x=-1,1 do
		for z=-1,1 do
			if x~=0 or z~=0 then
				minetest.env:add_node({x=pos.x+x,y=pos.y,z=pos.z+z}, {name="default:dirt"})
			end
		end
	end

	-- level -1 and -2 dirt
	for x=-1,1 do
		for z=-1,1 do
			minetest.env:add_node({x=pos.x+x,y=pos.y-1,z=pos.z+z}, {name="default:dirt"})
			minetest.env:add_node({x=pos.x+x,y=pos.y-2,z=pos.z+z}, {name="default:dirt"})
		end
	end

	-- level -2 -- ocean
	if skyblock.MODE == "water" or skyblock.MODE == "lava"  then
		local node_name = "default:water_source"
		if skyblock.MODE == "lava" then
			node_name = "default:lava_source"
		end
		minetest.env:add_node({x=pos.x-5,y=pos.y-2,z=pos.z-5}, {name=node_name})
		minetest.env:add_node({x=pos.x-5,y=pos.y-2,z=pos.z+5}, {name=node_name})
		minetest.env:add_node({x=pos.x+5,y=pos.y-2,z=pos.z-5}, {name=node_name})
		minetest.env:add_node({x=pos.x+5,y=pos.y-2,z=pos.z+5}, {name=node_name})
	end

end


-- make start blocks
levels[level].make_start_blocks_on_generated = function(pos, data, a)

	data[ a:index( pos.x, pos.y, pos.z )] = minetest.get_content_id( 'skyblock:level_1' );
	-- call on_construct so that the node gets initialized
	minetest.registered_nodes[ 'skyblock:level_1' ].on_construct( pos );
	
	local id_dirt = minetest.get_content_id( 'default:dirt' );
	-- level 0 - dirt
	for x=-1,1 do
		for z=-1,1 do
			if x~=0 or z~=0 then
				data[ a:index( pos.x+x,pos.y,pos.z+z )] = id_dirt;
			end
		end
	end

	-- level -1 and -2 dirt
	for x=-1,1 do
		for z=-1,1 do
			data[ a:index( pos.x+x,pos.y-1,pos.z+z )] = id_dirt;
			data[ a:index( pos.x+x,pos.y-2,pos.z+z )] = id_dirt;
		end
	end
end


-- update achievements
levels[level].update = function(player_name,pos)
	local formspec = ""

	formspec = formspec
		.."size[16,10;]"
		.."label[0,0;LEVEL "..level.." FOR: ".. player_name .."]"
		.."label[5.9,3.0; rewards]"
		.."list[current_name;rewards;5.5,3.5;2,2;]"
		.."list[current_player;main;0,6;8,4;]"

		.."label[0,1; --== Welcome Traveller ==--]"
		.."label[0,1.5; Complete the tasks to the right to receive]"
		.."label[0,2.0; great rewards!  If you wasted the required]"
		.."label[0,2.5; items you can dig this node to restart.]"
		
		.."label[0,3; --== About The Level "..level.." Block ==--]"
		.."label[0,3.5; * SHORT LEFT CLICK]"
		.."label[0.4,4; = PUNCH - refresh achievements]"
		.."label[0,4.5; * LONG LEFT CLICK]"
		.."label[0.4,5; = DIG - restart in a new spawn location]"

	-- count has to be passed by reference
	local data = { level=level, count=0, player_name=player_name, total=10, infotext="" };
	formspec = formspec..
		skyblock.list_tasks(data, 1, "place_sapling",                 1, "grow a Tree",                               "default:sapling" )..
		skyblock.list_tasks(data, 2, "dig_tree",                      5, "dig a Tree",                                "default:axe_wood" )..
		skyblock.list_tasks(data, 3, "place_chest",                   1, "craft and place a Chest",                   "default:chest" )..
		skyblock.list_tasks(data, 4, "collect_spawn_lava",            1, "collect the Lava Source under your Spawn",  "default:fence_wood" )..
		skyblock.list_tasks(data, 5, "dig_stone",                    20, "build a Stone Generator and dig 20 Cobble", "default:pick_wood" )..
		skyblock.list_tasks(data, 6, "place_furnace",                 1, "craft and place a Furnace",                 "default:furnace" )..
		skyblock.list_tasks(data, 7, "dig_stone_with_coal",           2, "dig 2 Coal Lumps",                          "default:stone_with_coal" )..
		skyblock.list_tasks(data, 8, "place_dirt",                  100, "extend your Island with 100 Dirt",          "default:dirt" )..
		skyblock.list_tasks(data, 9, "dig_stone_with_mese_pickaxe", 100, "dig 100 Stone with a Mese Pickaxe",         "default:pick_mese" )..
		skyblock.list_tasks(data,10, "place_water_infinite",          1, "create an Infinite Water Source",           "bucket:bucket_empty" );

	return formspec, data.infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	
	-- place_sapling
	if achievement == "place_sapling" and achievement_count == 1 then
		achievements.give_reward(level,player_name,"default:tree")
		return true
	end
	
	-- dig_tree
	if achievement == "dig_tree" and achievement_count == 5 then
		achievements.give_reward(level,player_name,"default:mese")
		return true
	end
	
	-- place_chest
	if achievement == "place_chest" and achievement_count == 1 then
		achievements.give_reward(level,player_name,"bucket:bucket_empty")
		-- put lava under spawn
		local pos = skyblock.get_spawn(player_name)
		minetest.env:add_node({x=pos.x,y=pos.y-1,z=pos.z}, {name="default:lava_source"})
		return true
	end

	-- collect_spawn_lava
	if achievement == "collect_spawn_lava" and achievement_count == 1 then
		achievements.give_reward(level,player_name,"default:water_source")
		return true
	end

	-- dig_stone
	if achievement == "dig_stone" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"default:mese")
		return true
	end
	
	-- place_furnace
	if achievement == "place_furnace" and achievement_count == 1 then
		achievements.give_reward(level,player_name,"default:coal_lump")
		return true
	end

	-- dig_stone_with_coal
	if achievement == "dig_stone_with_coal" and achievement_count == 2 then
		achievements.give_reward(level,player_name,"default:iron_lump")
		return true
	end

	-- place_dirt
	if achievement == "place_dirt" and achievement_count == 100 then
		achievements.give_reward(level,player_name,"default:mese")
		return true
	end

	-- dig_stone_with_mese_pickaxe
	if achievement == "dig_stone_with_mese_pickaxe" and achievement_count == 100 then
		achievements.give_reward(level,player_name,"default:water_source")
		return true
	end

	-- place_water_infinite
	if achievement == "place_water_infinite" and achievement_count == 1 then
		--achievements.give_reward(level,player_name,"default:lava_source")
		return true
	end
	
end


-- track digging achievements
levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	
	-- dig_stone
	if oldnode.name == "default:stone" then
		-- with mese pickaxe
		if digger:get_wielded_item():get_name() == "default:pick_mese" then
			achievements.add(level,player_name,"dig_stone_with_mese_pickaxe")
			return
		end
		achievements.add(level,player_name,"dig_stone")
		return
	end
	
	-- dig_stone_with_coal
	if oldnode.name == "default:stone_with_coal" then
		achievements.add(level,player_name,"dig_stone_with_coal")
		return
	end
	
	-- dig_tree
	if oldnode.name == "default:tree" or oldnode.name == "default:jungletree" or oldnode.name == "default:pinetree" then
		achievements.add(level,player_name,"dig_tree")
		return
	end
	
end


-- track placing achievements
levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_sapling
	if newnode.name == "default:sapling" then
		achievements.add(level,player_name,"place_sapling")
		return
	end

	-- place_dirt
	if newnode.name == "default:dirt" then
		achievements.add(level,player_name,"place_dirt")
		return
	end

	-- place_chest
	if newnode.name == "default:chest" then
		achievements.add(level,player_name,"place_chest")
		return
	end

	-- place_furnace
	if newnode.name == "default:furnace" then
		achievements.add(level,player_name,"place_furnace")
		return
	end

	if newnode.name == "default:water_source"
	  and ( minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z-1}).name=="default:water_source" 
		or minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z+1}).name=="default:water_source"
		or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z-1}).name=="default:water_source"
		or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z+1}).name=="default:water_source") then
			achievements.add(level,player_name,"place_water_infinite")
		return
	end
end

-- track bucket achievements
levels[level].bucket_on_use = function(player_name, pointed_thing)

	-- collect_spawn_lava
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == "default:lava_source" then
		local spawn = skyblock.has_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			achievements.add(level,player_name,"collect_spawn_lava")
		end
	end

end

-- track bucket achievements
levels[level].bucket_water_on_use = function(player_name, pointed_thing)

	-- place_water_infinite
	local pos = pointed_thing.under
	if minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z-1}).name=="default:water_source" 
	or minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z+1}).name=="default:water_source"
	or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z-1}).name=="default:water_source"
	or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z+1}).name=="default:water_source" then
		achievements.add(level,player_name,"place_water_infinite")
		return
	end
	
end

-- track bucket achievements
levels[level].bucket_lava_on_use = function(player_name, pointed_thing)
end
