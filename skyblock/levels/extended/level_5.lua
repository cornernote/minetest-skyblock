--[[

SkyBlock for MineTest

Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 5 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 5
levels[level] = {}


-- get pos
levels[level].get_pos = function(player_name)
	skyblock.log("level["..level.."].get_pos() for "..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+140,z=pos.z}
end


-- make start blocks
levels[level].make_start_blocks = function(player_name)
	skyblock.log("level["..level.."].make_start_blocks() for "..player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 15
	local hollow = 1
	skyblock.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,"default:dirt",hollow)

	-- level 5
	minetest.env:add_node(pos, {name="skyblock:level_5"})
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

		.."label[0,1; --== Go Farming ==--]"
		.."label[0,1.5; Gardens are fine, but you]"
		.."label[0,2.0; need to eat something.]"
--		.."label[0,2.5; is near.]"
		
		.."label[0,4; --== About The Level "..level.." Block ==--]"
		.."label[0,4.5; * SHORT LEFT CLICK]"
		.."label[0.4,5; = PUNCH to refresh achievements]"


	formspec = formspec.."label[8,0; 1) craft a hoe and turn 20 dirt into soil]"
	if achievements.get(level,player_name,"create_soil") >= 20 then
		formspec = formspec .. "label[8.3,0.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,0.4; not done]"
	end

	-- place 20 papyrus
	formspec = formspec.."label[8,1; 2) place 3 wheat seeds on your new field]"
	if achievements.get(level,player_name,"place_wheatseeds") >= 3 then
		formspec = formspec .. "label[8.3,1.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,1.4; not done]"
	end

	-- dig 15 cactus
	formspec = formspec.."label[8,2; 3) harvest wheat from 20 full-grown plants]"
	if achievements.get(level,player_name,"dig_wheat") >= 20 then
		formspec = formspec .. "label[8.3,2.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,2.4; not done]"
	end

	-- place 15 cactus
	formspec = formspec.."label[8,3; 4) place 9 mese lamps in order to let your plants grow at night]"
	if achievements.get(level,player_name,"place_meselamp") >= 3 then
		formspec = formspec .. "label[8.3,3.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,3.4; not done]"
	end

	-- place 30 fences
	formspec = formspec.."label[8,4; 5) bake a bread and eat it]"
	if achievements.get(level,player_name,"eat_bread") >= 1 then
		formspec = formspec .. "label[8.3,4.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,4.4; not done]"
	end

	-- place 20 ladders
	formspec = formspec.."label[8,5; 6) use 20 straws for a roof]"
	if achievements.get(level,player_name,"place_straw") >= 20 then
		formspec = formspec .. "label[8.3,5.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,5.4; not done]"
	end

	-- place 5 bookshelves
	formspec = formspec.."label[8,6; 7) place 3 cotton seeds]"
	if achievements.get(level,player_name,"place_cottonseeds") >= 3 then
		formspec = formspec .. "label[8.3,6.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,6.4; not done]"
	end

	-- place 10 signs
	formspec = formspec.."label[8,7; 8) harvest cotton from 30 full-grown plants]"
	if achievements.get(level,player_name,"dig_cotton") >= 30 then
		formspec = formspec .. "label[8.3,7.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,7.4; not done]"
	end

	-- place 50 torches
	formspec = formspec.."label[8,8; 9) create a tapestry for your house out of 20 fine white wool]"
	if achievements.get(level,player_name,"place_wool") >= 20 then
		formspec = formspec .. "label[8.3,8.4; COMPLETE!]"
		count = count + 1
	else
		formspec = formspec .. "label[8.3,8.4; not done]"
	end

	-- dig 500 stone
	formspec = formspec.."label[8,9; 10) you deserve sleep now. Craft a bed!]"
	if achievements.get(level,player_name,"place_bed") >= 1 then
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
		if pos and minetest.env:get_node(pos).name ~= "skyblock:level_6" then
			levels[level+1].make_start_blocks(player_name)
		end
	end

	local infotext = "LEVEL "..level.." for ".. player_name ..": ".. count .." of "..total
	return formspec, infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	achievements.update(level,player_name)
	
	if achievement == "create_soil" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"farming:seed_wheat 3")
		return true
	end
	
	if achievement == "place_wheatseeds" and achievement_count == 3 then
		achievements.give_reward(level,player_name,"farming:seed_wheat 3")
		return true
	end
	
	if achievement == "dig_wheat" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"default:mese 3")
		return true
	end
	
	if achievement == "place_meselamp" and achievement_count == 9 then
		achievements.give_reward(level,player_name,"default:mese "..math.random(1,3))
		return true
	end
	
	if achievement == "eat_bread" and achievement_count == 1 then
		achievements.give_reward(level,player_name,"farming:straw "..math.random(5,10))
		return true
	end
	
	if achievement == "place_straw" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"farming:seed_cotton 3")
		return true
	end
	
	if achievement == "place_cottonseeds" and achievement_count == 3 then
		achievements.give_reward(level,player_name,"farming:seed_cotton 3")
		return true
	end
	
	if achievement == "dig_cotton" and achievement_count == 30 then
		achievements.give_reward(level,player_name,"wool:white "..math.random(1,10))
		return true
	end
	
	if achievement == "place_wool" and achievement_count == 20 then
		achievements.give_reward(level,player_name,"wool:red 2")
		return true
	end
	
	if achievement == "place_bed" and achievement_count == 1 then
		achievements.give_reward(level,player_name,"wool:white "..math.random(10, 20)) -- TODO: better reward?
		return true
	end
	
end


-- track placing achievements
levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	if newnode.name == "farming:seed_wheat" then
		achievements.add(level,player_name,"place_wheatseeds")
		return
	end

	if newnode.name == "default:meselamp" then
		achievements.add(level,player_name,"place_meselamp")
		return
	end

	if newnode.name == "farming:straw" then
		achievements.add(level,player_name,"place_straw")
		return
	end

	if newnode.name == "farming:seed_cotton" then
		achievements.add(level,player_name,"place_cottonseeds")
		return
	end

	if newnode.name == "wool:white" then
		achievements.add(level,player_name,"place_wool")
		return
	end

	if newnode.name == "beds:bed_bottom" or newnode.name == "beds:fancy_bed_bottom" then
		achievements.add(level,player_name,"place_bed")
		return
	end
end

-- track digging achievements
levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	
	if oldnode.name == "farming:wheat_8" then
		achievements.add(level,player_name,"dig_wheat")
		return
	end
	
	if oldnode.name == "farming:cotton_8" then
		achievements.add(level,player_name,"dig_cotton")
		return
	end
end

-- not used
levels[level].bucket_on_use = function(player_name, pointed_thing) end
levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end


local old_hoe_on_use = farming.hoe_on_use;
farming.hoe_on_use = function(itemstack, user, pointed_thing, uses)
	local res = old_hoe_on_use( itemstack, user, pointed_thing, uses );
	local player_name = user:get_player_name();
	if( res and player_name) then
		achievements.add(level,player_name,"create_soil")
	end
	return res;
end

levels[level].on_item_eat = function(player_name, itemstack)
	if( itemstack and itemstack:get_name() and itemstack:get_name()=='farming:bread' ) then
		achievements.add(level,player_name,"eat_bread")
	end
end
