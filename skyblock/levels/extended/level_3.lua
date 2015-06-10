--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 3 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 3
levels[level] = {}


-- get pos
levels[level].get_pos = function(player_name)
	skyblock.log("level["..level.."].get_pos() for "..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+40,z=pos.z}
end


-- make start blocks
levels[level].make_start_blocks = function(player_name)
	skyblock.log("level["..level.."].make_start_blocks() for "..player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 5
	local hollow = 1
	skyblock.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,"default:dirt",hollow)

	-- level 3
	minetest.env:add_node(pos, {name="skyblock:level_3"})
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
		skyblock.list_tasks(data, 1, "dig_papyrus",                  20, "dig 20 Papyrus",                            "default:papyrus" )..
		skyblock.list_tasks(data, 2, "place_papyrus",                20, "place 20 Papyrus in a nice garden",         "default:papyrus" )..
		skyblock.list_tasks(data, 3, "dig_cactus",                   15, "dig 15 Cactus",                             "default:cactus" )..
		skyblock.list_tasks(data, 4, "place_cactus",                 15, "place 15 Cactus in another garden",         "default:cactus" )..
		skyblock.list_tasks(data, 5, "place_fence",                  30, "place 30 fences around your gardens",       "default:fence_wood" )..
		skyblock.list_tasks(data, 6, "place_ladder",                 20, "add 20 ladders to your structures",         "default:ladder" )..
		skyblock.list_tasks(data, 7, "place_bookshelf",               5, "decorate your house with 5 Bookshelves",    "default:bookshelf" )..
		skyblock.list_tasks(data, 8, "place_sign_wall",              10, "place 10 Signs to help other travellers",   "default:sign_wall" )..
		skyblock.list_tasks(data, 9, "place_torch",                   2, "place 50 Torches to help you see at night", "default:torch" )..
		skyblock.list_tasks(data,10, "place_door",                    5, "add 5 Doors to your house",                 "doors:door_wood" );

	return formspec, data.infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	
	-- dig_papyrus
	if achievement == "dig_papyrus" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
		return true
	end
	
	-- place_papyrus
	if achievement == "place_papyrus" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
		return true
	end
	
	-- dig_cactus
	if achievement == "dig_cactus" and achievement_count == 15 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
		return true
	end
	
	-- place_cactus
	if achievement == "place_cactus" and achievement_count == 15 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
		return true
	end
	
	-- place_fence
	if achievement == "place_fence" and achievement_count == 30 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
		return true
	end
	
	-- place_ladder
	if achievement == "place_ladder" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
		return true
	end
	
	-- place_bookshelf
	if achievement == "place_bookshelf" and achievement_count == 5 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
		return true
	end
	
	-- place_sign_wall
	if achievement == "place_sign_wall" and achievement_count == 10 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
		return true
	end
	
	-- place_torch
	if achievement == "place_torch" and achievement_count == 50 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
		return true
	end
	
	if achievement == "place_door" and achievement_count == 5 then
		achievements.give_reward(level,player_name,"default:stonebrick "..math.random(1, 20))
		return true
	end
	
end


-- track placing achievements
levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_papyrus
	if newnode.name == "default:papyrus" then
		achievements.add(level,player_name,"place_papyrus")
		return
	end

	-- place_cactus
	if newnode.name == "default:cactus" then
		achievements.add(level,player_name,"place_cactus")
		return
	end

	-- place_fence
	if newnode.name == "default:fence_wood" or newnode.name == "default:fence" or newnode.name == "xfences:fence" then
		achievements.add(level,player_name,"place_fence")
		return
	end

	-- place_ladder
	if newnode.name == "default:ladder" then
		achievements.add(level,player_name,"place_ladder")
		return
	end

	-- place_bookshelf
	if newnode.name == "default:bookshelf" then
		achievements.add(level,player_name,"place_bookshelf")
		return
	end

	-- place_sign_wall
	if newnode.name == "default:sign_wall" then
		achievements.add(level,player_name,"place_sign_wall")
		return
	end

	-- place_torch
	if newnode.name == "default:torch" then
		achievements.add(level,player_name,"place_torch")
		return
	end

	if   newnode.name == "doors:door_wood"
	  or newnode.name == "doors:door_glass"
	  or newnode.name == "doors:door_steel"
	  or newnode.name == "doors:door_obsidian_glass" then
		achievements.add(level,player_name,"place_door")
		return
	end
end

-- track digging achievements
levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	
	-- dig_papyrus
	if oldnode.name == "default:papyrus" then
		achievements.add(level,player_name,"dig_papyrus")
		return
	end
	
	-- dig_cactus
	if oldnode.name == "default:cactus" then
		achievements.add(level,player_name,"dig_cactus")
		return
	end
end

-- not used
levels[level].bucket_on_use = function(player_name, pointed_thing) end
levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end
