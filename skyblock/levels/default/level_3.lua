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
	local total = 10
	local count = 0

	formspec = formspec
		.."size[15,10;]"
		.."label[0,0;LEVEL "..level.." FOR: ".. player_name .."]"
		.."label[13.4,0; rewards]"
		.."list[current_name;rewards;13,0.5;2,2;]"
		.."list[current_player;main;0,6;8,4;]"

		.."label[0,1; --== Does This Keep Going? ==--]"
		.."label[0,1.5; If you like this planet, then stray not]"
		.."label[0,2.0; from your mission traveller, for the end]"
		.."label[0,2.5; is near.]"
		
		.."label[0,4; --== About The Level "..level.." Block ==--]"
		.."label[0,4.5; * SHORT LEFT CLICK]"
		.."label[0.4,5; = PUNCH to refresh achievements]"

	-- dig 20 papyrus
	formspec = formspec.."label[8,0; 1) dig 20 Papyrus]"
	if achievements.get(level,player_name,"dig_papyrus") >= 20 then
		formspec = formspec .. "label[8.3,0.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,0.4; not done]"
	end

	-- place 20 papyrus
	formspec = formspec.."label[8,1; 2) place 20 Papyrus in a nice garden]"
	if achievements.get(level,player_name,"place_papyrus") >= 20 then
		formspec = formspec .. "label[8.3,1.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,1.4; not done]"
	end

	-- dig 15 cactus
	formspec = formspec.."label[8,2; 3) dig 15 Cactus]"
	if achievements.get(level,player_name,"dig_cactus") >= 15 then
		formspec = formspec .. "label[8.3,2.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,2.4; not done]"
	end

	-- place 15 cactus
	formspec = formspec.."label[8,3; 4) place 15 Cactus in another gargen]"
	if achievements.get(level,player_name,"place_cactus") >= 15 then
		formspec = formspec .. "label[8.3,3.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,3.4; not done]"
	end

	-- place 30 fences
	formspec = formspec.."label[8,4; 5) place 30 fences around your gardens]"
	if achievements.get(level,player_name,"place_fence") >= 30 then
		formspec = formspec .. "label[8.3,4.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,4.4; not done]"
	end

	-- place 20 ladders
	formspec = formspec.."label[8,5; 6) add 20 ladders to your structures]"
	if achievements.get(level,player_name,"place_ladder") >= 20 then
		formspec = formspec .. "label[8.3,5.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,5.4; not done]"
	end

	-- place 5 bookshelves
	formspec = formspec.."label[8,6; 7) decorate your house with 5 Bookshelves]"
	if achievements.get(level,player_name,"place_bookshelf") >= 5 then
		formspec = formspec .. "label[8.3,6.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,6.4; not done]"
	end

	-- place 10 signs
	formspec = formspec.."label[8,7; 8) place 10 Signs to help other travellers]"
	if achievements.get(level,player_name,"place_sign_wall") >= 10 then
		formspec = formspec .. "label[8.3,7.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,7.4; not done]"
	end

	-- place 50 torches
	formspec = formspec.."label[8,8; 9) place 50 Torches to help you see at night]"
	if achievements.get(level,player_name,"place_torch") >= 50 then
		formspec = formspec .. "label[8.3,8.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,8.4; not done]"
	end

	-- dig 500 stone
	formspec = formspec.."label[8,9; 10) dig 500 Stone for your next project...]"
	if achievements.get(level,player_name,"dig_stone") >= 500 then
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
		if pos and minetest.env:get_node(pos).name ~= "skyblock:level_4" then
			levels[level+1].make_start_blocks(player_name)
		end
	end

	local infotext = "LEVEL "..level.." for ".. player_name ..": ".. count .." of "..total
	return formspec, infotext
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
	
	-- dig_stone
	if achievement == "dig_stone" and achievement_count == 500 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1, 5))
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
        if newnode.name == "default:fence_wood" or newnode.name == "xfences:fence" then
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
