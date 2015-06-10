--[[

SkyBlock for MineTest

Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 4 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 4
levels[level] = {}


-- get pos
levels[level].get_pos = function(player_name)
	skyblock.log("level["..level.."].get_pos() for "..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+80,z=pos.z}
end


-- make start blocks
levels[level].make_start_blocks = function(player_name)
	skyblock.log("level["..level.."].make_start_blocks() for "..player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 10
	local hollow = 1
	skyblock.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,"default:dirt",hollow)

	-- level 4
	minetest.env:add_node(pos, {name="skyblock:level_4"})
	achievements.update(level,player_name)
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

		.."label[0,1; --== Strengthen Our World ==--]"
		.."label[0,1.5; You will find riches here.]"
		
		.."label[0,4; --== About The Level "..level.." Block ==--]"
		.."label[0,4.5; * SHORT LEFT CLICK]"
		.."label[0.4,5; = PUNCH to refresh achievements]"

	-- count has to be passed by reference
	local data = { level=level, count=0, player_name=player_name, total=10, infotext="" };
	formspec = formspec..
		skyblock.list_tasks(data, 1, "place_stonebrick",        40, "place 40 stone brick as a foundation for your next house",       "default:stonebrick" )..
		skyblock.list_tasks(data, 2, "place_copperblock",       20, "place 20 copper blocks",                                         "default:copperblock" )..
		skyblock.list_tasks(data, 3, "place_sandstonebrick",    40, "use 20 sandstone brick for your new building",                   "default:sandstonebrick" )..
		skyblock.list_tasks(data, 4, "place_bronzeblock",       10, "discover the bronzer age and place 10 bronze blocks",            "default:bronzeblock" )..
		skyblock.list_tasks(data, 5, "place_desertstonebrick",  40, "add 40 desert stone brick",                                      "default:desert_stonebrick" )..
		skyblock.list_tasks(data, 6, "place_goldblock",          6, "gold was found! Polish your house with 6 gold blocks",           "default:goldblock" )..
		skyblock.list_tasks(data, 7, "place_obsidianbrick",     40, "place 40 dark obsidian bricks to compensate for the shiny gold", "default:obsidianbrick" )..
		skyblock.list_tasks(data, 8, "place_coalblock",          8, "form a coal storage using 8 coalblocks",                         "default:coalblock" )..
		skyblock.list_tasks(data, 9, "place_diamondblock",       3, "decorate your house with 3 diamond blocks",                      "default:diamondblock" )..
		skyblock.list_tasks(data,10, "dig_stone",              500, "dig 500 Stone for your next project...",                         "default:cobble" );

	return formspec, data.infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	achievements.update(level,player_name)
	
	if achievement == "place_stonebrick" and achievement_count == 40 then
		achievements.give_reward(level,player_name,"default:copper_lump")
		achievements.give_reward(level,player_name,"default:copperblock "..math.random(10,15))
		return true
	end
	
	if achievement == "place_copperblock" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"default:sandstonebrick "..math.random(1, 20))
		return true
	end
	
	if achievement == "place_sandstonebrick" and achievement_count == 40 then
		achievements.give_reward(level,player_name,"default:bronzeblock "..math.random(5, 8))
		return true
	end
	
	if achievement == "place_bronzeblock" and achievement_count == 10 then
		achievements.give_reward(level,player_name,"default:desert_stonebrick "..math.random(1, 20))
		return true
	end
	
	if achievement == "place_desertstonebrick" and achievement_count == 40 then
		achievements.give_reward(level,player_name,"default:gold_lump")
		achievements.give_reward(level,player_name,"default:goldblock "..math.random(1,3))
		return true
	end
	
	if achievement == "place_goldblock" and achievement_count == 6 then
		achievements.give_reward(level,player_name,"default:obsidianbrick "..math.random(1, 20))
		return true
	end
	
	if achievement == "place_obsidianbrick" and achievement_count == 40 then
		achievements.give_reward(level,player_name,"default:coalblock "..math.random(3, 5))
		return true
	end
	
	if achievement == "place_coalblock" and achievement_count == 8 then
		achievements.give_reward(level,player_name,"default:diamond")
		return true
	end
	
	if achievement == "place_diamondblock" and achievement_count == 3 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5)) -- TODO: better reward?
		return true
	end
	
	if achievement == "dig_stone" and achievement_count == 500 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5)) -- TODO: better reward?
		return true
	end
	
end


-- track placing achievements
levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	if newnode.name == "default:stonebrick" then
		achievements.add(level,player_name,"place_stonebrick")
		return
	end

	if newnode.name == "default:copperblock" then
		achievements.add(level,player_name,"place_copperblock")
		return
	end

	if newnode.name == "default:sandstonebrick" then
		achievements.add(level,player_name,"place_sandstonebrick")
		return
	end

	if newnode.name == "default:bronzeblock" then
		achievements.add(level,player_name,"place_bronzeblock")
		return
	end

	if newnode.name == "default:desert_stonebrick" then
		achievements.add(level,player_name,"place_desertstonebrick")
		return
	end

	if newnode.name == "default:goldblock" then
		achievements.add(level,player_name,"place_goldblock")
		return
	end

	if newnode.name == "default:obsidianbrick" then
		achievements.add(level,player_name,"place_obsidianbrick")
		return
	end

	if newnode.name == "default:coalblock" then
		achievements.add(level,player_name,"place_coalblock")
		return
	end

	if newnode.name == "default:diamondblock" then
		achievements.add(level,player_name,"place_diamondblock")
		return
	end
end

-- track digging achievements
levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	
	-- dig_stone
	if oldnode.name == "default:stone" then
		achievements.add(level,player_name,"dig_stone")
		return
	end
	
end

-- not used
levels[level].bucket_on_use = function(player_name, pointed_thing) end
levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end
