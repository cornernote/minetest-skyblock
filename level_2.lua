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

	-- level 2
	minetest.env:add_node(pos, {name="skyblock:level_2"})
	achievements.update(level,player_name)

end


-- achievements label
levels[level].achievements = function(player_name,pos)
	local formspec = ""
	local total = 10
	local count = 0

	formspec = formspec
		.."size[15,10;]"
		.."label[0,0;LEVEL "..level.." FOR: ".. player_name .."]"
		.."label[13.4,0; rewards]"
		.."list[current_name;rewards;13,0.5;2,2;]"
		.."list[current_player;main;0,6;8,4;]"

		.."label[0,1; --== A View From Above ==--]"
		.."label[0,1.5; Wow, look at that view... of... nothing.]"
		.."label[0,2.0; You should get to work extending this]"
		.."label[0,2.5; island.  Perhaps you could build some]"
		.."label[0,3.0; structures too?]"
		
		.."label[0,4; --== About The Level "..level.." Block ==--]"
		.."label[0,4.5; * SHORT LEFT CLICK]"
		.."label[0.4,5; = PUNCH to refresh achievements]"

	-- place 200 dirt
	formspec = formspec.."label[8,0; 1) extend your Island with 200 Dirt]"
	if achievements.get(level,player_name,"place_dirt") >= 200 then
		formspec = formspec .. "label[8.3,0.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,0.4; not done]"
	end

	-- place 50 wood
	formspec = formspec.."label[8,1; 2) build a structure using 50 Wood]"
	if achievements.get(level,player_name,"place_wood") >= 50 then
		formspec = formspec .. "label[8.3,1.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,1.4; not done]"
	end

	-- place 50 brick
	formspec = formspec.."label[8,2; 3) build a structure using 50 Brick]"
	if achievements.get(level,player_name,"place_brick") >= 50 then
		formspec = formspec .. "label[8.3,2.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,2.4; not done]"
	end

	-- place 12 glass
	formspec = formspec.."label[8,3; 4) add at least 12 Glass windows]"
	if achievements.get(level,player_name,"place_glass") >= 12 then
		formspec = formspec .. "label[8.3,3.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,3.4; not done]"
	end

	-- place 40 sand
	formspec = formspec.."label[8,4; 5) make a desert with 40 Sand]"
	if achievements.get(level,player_name,"place_sand") >= 40 then
		formspec = formspec .. "label[8.3,4.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,4.4; not done]"
	end

	-- place 30 desert_sand
	formspec = formspec.."label[8,5; 6) also include 40 Desert Sand]"
	if achievements.get(level,player_name,"place_desert_sand") >= 50 then
		formspec = formspec .. "label[8.3,5.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,5.4; not done]"
	end

	-- place 50 stone
	formspec = formspec.."label[8,6; 7) build a tower with 50 Stone]"
	if achievements.get(level,player_name,"place_stone") >= 50 then
		formspec = formspec .. "label[8.3,6.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,6.4; not done]"
	end

	-- place 40 cobble
	formspec = formspec.."label[8,7; 8) make a path with 40 Cobblestone]"
	if achievements.get(level,player_name,"place_cobble") >= 50 then
		formspec = formspec .. "label[8.3,7.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,7.4; not done]"
	end

	-- place 30 mossycobble
	formspec = formspec.."label[8,8; 9) also use 30 Mossy Cobblestone]"
	if achievements.get(level,player_name,"place_mossycobble") >= 30 then
		formspec = formspec .. "label[8.3,8.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,8.4; not done]"
	end

	-- place 20 steelblock
	formspec = formspec.."label[8,9; 10) decorate your area with 20 Steel Blocks]"
	if achievements.get(level,player_name,"place_steelblock") >= 20 then
		formspec = formspec .. "label[8.3,9.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,9.4; not done]"
	end

	-- next level
	if count==total and achievements.get(0,player_name,"level")==level then
		levels[level+1].make_start_blocks(player_name)
		achievements.add(0,player_name,"level")
	end
	if  achievements.get(0,player_name,"level") > level then
		local pos = levels[level+1].get_pos(player_name)
		if pos and minetest.env:get_node(pos).name ~= "skyblock:level_3" then
			levels[level+1].make_start_blocks(player_name)
		end
	end

	local infotext = "LEVEL "..level.." for ".. player_name ..": ".. count .." of "..total
	return formspec, infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	
	-- place_dirt
	if achievement == "place_dirt" and achievement_count == 200 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
		return true
	end
	
	-- place_wood
	if achievement == "place_wood" and achievement_count == 50 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
		return true
	end
	
	-- place_brick
	if achievement == "place_brick" and achievement_count == 50 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
		return true
	end
	
	-- place_glass
	if achievement == "place_glass" and achievement_count == 12 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
		return true
	end
	
	-- place_sand
	if achievement == "place_sand" and achievement_count == 50 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
		return true
	end
	
	-- place_desert_sand
	if achievement == "place_desert_sand" and achievement_count == 40 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
		return true
	end
	
	-- place_stone
	if achievement == "place_stone" and achievement_count == 50 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
		return true
	end
	
	-- place_cobble
	if achievement == "place_cobble" and achievement_count == 40 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
		return true
	end
	
	-- place_mossycobble
	if achievement == "place_mossycobble" and achievement_count == 30 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
		return true
	end
	
	-- place_steelblock
	if achievement == "place_steelblock" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"default:steelblock "..math.random(1, 5))
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
	if newnode.name == "default:wood" then
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
