--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 2 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 2
levels[level] = {}


-- get pos
levels[level].get_pos = function(player_name)
	skyblock.log("level["..level.."].get_pos() for "..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+15,z=pos.z}
end


-- make start blocks
levels[level].make_start_blocks = function(player_name)
	skyblock.log("level["..level.."].make_start_blocks() for "..player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 3
	local hollow = 1
	skyblock.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,"default:dirt",hollow)
	minetest.env:add_node({x=pos.x,y=pos.y-1,z=pos.z}, {name="default:lava_source"})

	-- level 2
	minetest.env:add_node(pos, {name="skyblock:level_2"})
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

		.."label[0,1; --== A View From Above ==--]"
		.."label[0,1.5; Wow, look at that view... of... nothing.]"
		.."label[0,2.0; You should get to work extending this]"
		.."label[0,2.5; island.  Perhaps you could build some]"
		.."label[0,3.0; structures too?]"
		
		.."label[0,4; --== About The Level "..level.." Block ==--]"
		.."label[0,4.5; * SHORT LEFT CLICK]"
		.."label[0.4,5; = PUNCH to refresh achievements]"

	-- count has to be passed by reference
	local data = { level=level, count=0, player_name=player_name, total=10, infotext="" };
	formspec = formspec..
		skyblock.list_tasks(data, 1, "place_dirt",                  200, "extend your Island with 200 Dirt",          "default:dirt" )..
		skyblock.list_tasks(data, 2, "place_wood",                  200, "build a structure using 200 Wood",          "default:wood" )..
		skyblock.list_tasks(data, 3, "place_brick",                 200, "build a structure using 200 Brick",         "default:brick" )..
		skyblock.list_tasks(data, 4, "place_glass",                 200, "add at least 200 Glass windows",            "default:glass" )..
		skyblock.list_tasks(data, 5, "place_sand",                  200, "make a desert with 200 Sand",               "default:sand" )..
		skyblock.list_tasks(data, 6, "place_desert_sand",           200, "also include 200 Desert Sand",              "default:desert_sand" )..
		skyblock.list_tasks(data, 7, "place_stone",                 200, "build a tower with 200 Stone",              "default:stone" )..
		skyblock.list_tasks(data, 8, "place_cobble",                200, "make a path with 200 Cobblestone",          "default:cobble" )..
		skyblock.list_tasks(data, 9, "place_mossycobble",           200, "also use 200 Mossy Cobblestone",            "default:mossycobble" )..
		skyblock.list_tasks(data,10, "place_steelblock",             75, "decorate your area with 75 Steel Blocks",   "default:steelblock" );

	return formspec, data.infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	
	-- place_dirt
	if achievement == "place_dirt" and achievement_count == 200 then
		achievements.give_reward(level,player_name,"default:wood "..math.random(50,99))
		return true
	end
	
	-- place_wood
	if achievement == "place_wood" and achievement_count == 200 then
		achievements.give_reward(level,player_name,"default:brick "..math.random(50,99))
		return true
	end
	
	-- place_brick
	if achievement == "place_brick" and achievement_count == 200 then
		achievements.give_reward(level,player_name,"default:glass "..math.random(50,99))
		return true
	end
	
	-- place_glass
	if achievement == "place_glass" and achievement_count == 200 then
	achievements.give_reward(level,player_name,"default:sand "..math.random(50,99))
		return true
	end
	
	-- place_sand
	if achievement == "place_sand" and achievement_count == 200 then
		achievements.give_reward(level,player_name,"default:desert_sand "..math.random(50,99))
		return true
	end
	
	-- place_desert_sand
	if achievement == "place_desert_sand" and achievement_count == 200 then
		achievements.give_reward(level,player_name,"default:stone "..math.random(50,99))
		return true
	end
	
	-- place_stone
	if achievement == "place_stone" and achievement_count == 200 then
		achievements.give_reward(level,player_name,"default:cobble "..math.random(50,99))
		return true
	end
	
	-- place_cobble
	if achievement == "place_cobble" and achievement_count == 200 then
		achievements.give_reward(level,player_name,"default:mossycobble "..math.random(90,99))
		return true
	end
	
	-- place_mossycobble
	if achievement == "place_mossycobble" and achievement_count == 200 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(50,69))
		return true
	end
	
	-- place_steelblock
	if achievement == "place_steelblock" and achievement_count == 75 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(5,15))
		return true
	end

end


-- track placing achievements
levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_dirt
	if newnode.name == "default:dirt" then
		achievements.add(level,player_name,"place_dirt")
		return
	end

	-- place_wood
	if newnode.name == "default:wood" 
	  or newnode.name == "default:junglewood" 
	  or newnode.name == "default:pinewood" then
		achievements.add(level,player_name,"place_wood")
		return
	end

	-- place_brick
	if newnode.name == "default:brick" then
		achievements.add(level,player_name,"place_brick")
		return
	end

	-- place_glass
	if newnode.name == "default:glass" then
		achievements.add(level,player_name,"place_glass")
		return
	end

	-- place_sand
	if newnode.name == "default:sand" then
		achievements.add(level,player_name,"place_sand")
		return
	end

	-- place_desert_sand
	if newnode.name == "default:desert_sand" then
		achievements.add(level,player_name,"place_desert_sand")
		return
	end

	-- place_stone
	if newnode.name == "default:stone" then
		achievements.add(level,player_name,"place_stone")
		return
	end

	-- place_cobble
	if newnode.name == "default:cobble" then
		achievements.add(level,player_name,"place_cobble")
		return
	end

	-- place_mossycobble
	if newnode.name == "default:mossycobble" then
		achievements.add(level,player_name,"place_mossycobble")
		return
	end

	-- place_steelblock
	if newnode.name == "default:steelblock" then
		achievements.add(level,player_name,"place_steelblock")
		return
	end

end

-- not used
levels[level].on_dignode = function(pos, oldnode, digger) end
levels[level].bucket_on_use = function(player_name, pointed_thing) end
levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end
