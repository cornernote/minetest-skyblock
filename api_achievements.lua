--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

ACHIEVEMENT FUNCTIONS

]]--


-- local variable to save players achievements
local players_achievements = table.load(skyblock.FILENAME..".achievements")
if players_achievements == nil then
	players_achievements = {}
end


-- debug
local dbg = function(message)
	if not skyblock.DEBUG then
		return
	end
	minetest.log("action", "[SB.Achievements] "..message)
end



--
-- PUBLIC FUNCTIONS
--


-- update achievements
achievements.init = function(pos)
	dbg("achievements.init() at "..dump(pos))
	local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", 
		"size[9,4;]"..
		"label[0,0;--== Achievements ==--]"..
		"label[0,2; -->> INITIAL REFRESH REQUIRED <<-- ]"..
		"label[0,3.30; * SHORT LEFT CLICK]"..
		"label[0,3.70; * LONG LEFT CLICK]"..
		"label[3,3.30; = PUNCH to refresh achievements]"..
		"label[3,3.70; = DIG to restart in a new spawn location]"..
		"")
	meta:set_string("infotext", "Achievements: RIGHT CLICK TO VIEW")
end


-- update achievements
achievements.update = function(pos)
	local meta = minetest.env:get_meta(pos)
	local player_name = meta:get_string("spawn_player")
	dbg("achievements.update() for "..player_name.." at "..dump(pos))
	local achievements_label = ""
	local total = 10
	local count = 0

	if skyblock.get_spawn(player_name) == nil then
		return
	end
	
	-- place_sapling and dig_tree
	if achievements.get(player_name,"place_sapling") >= 3 && achievements.get(player_name,"dig_tree") >= 4 then
		achievements_label = achievements_label .. "label[0,0.75; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,0.75; {NOT COMPLETE}]"
	end

	-- dig stone
	if achievements.get(player_name,"dig_stone") >= 1 then
		achievements_label = achievements_label .. "label[0,1.50; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,1.50; {NOT COMPLETE}]"
	end

	-- place 50 dirt
	if achievements.get(player_name,"place_dirt") >= 100 then
		achievements_label = achievements_label .. "label[0,2.25; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,2.25; {NOT COMPLETE}]"
	end

	-- place chest and furnace
	if achievements.get(player_name,"place_chest") >= 1 and achievements.get(player_name,"place_furnace") >= 1 then
		achievements_label = achievements_label .. "label[0,3.00; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,3.00; {NOT COMPLETE}]"
	end

	-- place 30 brick and 30 wood
	if achievements.get(player_name,"place_brick") >= 30 and achievements.get(player_name,"place_wood") >= 30 then
		achievements_label = achievements_label .. "label[0,3.75; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,3.75; {NOT COMPLETE}]"
	end

	-- place both water in diagonal
	if achievements.get(player_name,"place_water_infinite") >= 1 then
		achievements_label = achievements_label .. "label[0,4.50; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,4.50; {NOT COMPLETE}]"
	end

	-- place glass in brick
	if achievements.get(player_name,"place_glass_in_house") >= 2 then
		achievements_label = achievements_label .. "label[0,5.25; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,5.25; {NOT COMPLETE}]"
	end

	-- place water above y+?
	if achievements.get(player_name,"place_water_up") >= 1 then
		achievements_label = achievements_label .. "label[0,6.00; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,6.00; {NOT COMPLETE}]"
	end

	-- dig lava under spawn node
	if achievements.get(player_name,"collect_spawn_lava") >= 1 then
		achievements_label = achievements_label .. "label[0,6.75; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,6.75; {NOT COMPLETE}]"
	end

	-- dig stone with mese pickaxe
	if achievements.get(player_name,"dig_stone_with_mese_pickaxe") >= 1 then
		achievements_label = achievements_label .. "label[0,7.50; {COMPLETE!}]"
		count = count + 1
	else
		achievements_label = achievements_label .. "label[0,7.50; {NOT COMPLETE}]"
	end
	
	meta:set_string("formspec", 
		"size[9,9;]"..
		"label[0,0;ACHIEVEMENTS FOR: ".. player_name .."]"..
		achievements_label..
		"label[2.5,0.75; 1) create a Tree Farm]".. -- dig tree
		"label[2.5,1.50; 2) build a Stone Generator]".. -- dig stone
		"label[2.5,2.25; 3) extend your Island]".. -- place 50 dirt
		"label[2.5,3.00; 4) craft and place a Chest and Furnace]".. -- place chest and furnace
		"label[2.5,3.75; 5) build a House from Brick and Wood]".. -- place 30 brick + 30 wood
		"label[2.5,4.50; 6) create an Infinite Water Source]".. -- place both water in diagonal
		"label[2.5,5.25; 7) put Glass Windows in your House]".. -- place 2 glass between brick
		"label[2.5,6.00; 8) build a Water Feature]".. -- place water above y+7
		"label[2.5,6.75; 9) collect the Lava Source under your Spawn]".. -- dig under spawn node
		"label[2.5,7.50; 10) mine stone with a Mese Pickaxe]".. -- dig stone with tool

		"label[0,8.30; * SHORT LEFT CLICK]"..
		"label[0,8.70; * LONG LEFT CLICK]"..
		"label[3,8.30; = PUNCH to refresh achievements]"..
		"label[3,8.70; = DIG to restart in a new spawn location]"..
		"")
	meta:set_string("infotext", "Achievements for ".. player_name ..": ".. count .." of "..total)
end


-- get achievement
achievements.get = function(player_name,achievement)
	if players_achievements[player_name] == nil then
		players_achievements[player_name] = {}
	end
	if players_achievements[player_name][achievement] == nil then
		players_achievements[player_name][achievement] = 0
	end
	dbg("achievements.get() for "..player_name.." achievement "..achievement.." is "..players_achievements[player_name][achievement])
	return players_achievements[player_name][achievement]
end


-- set achievement
achievements.add = function(player_name,achievement)
	dbg("achievements.add() for "..player_name.." achievement "..achievement)
	local update = false
	local player_achievement = achievements.get(player_name,achievement)
	players_achievements[player_name][achievement] = player_achievement + 1
	
	-- dig_stone
	if achievement == "dig_stone" and players_achievements[player_name][achievement] == 1 then
		update = true
	end
	
	-- place_sapling
	if achievement == "place_sapling" and players_achievements[player_name][achievement] == 3 then
		update = true
	end
	
	-- dig_tree
	if achievement == "dig_tree" and players_achievements[player_name][achievement] == 4 then
		update = true
	end
	
	-- place_chest
	if achievement == "place_chest" and players_achievements[player_name][achievement] == 1 then
		update = true
	end

	-- place_furnace
	if achievement == "place_furnace" and players_achievements[player_name][achievement] == 1 then
		update = true
	end

	-- place_dirt
	if achievement == "place_dirt" and players_achievements[player_name][achievement] == 100 then
		update = true
	end

	-- place_wood
	if achievement == "place_wood" and players_achievements[player_name][achievement] == 30 then
		update = true
	end

	-- place_brick
	if achievement == "place_brick" and players_achievements[player_name][achievement] == 30 then
		update = true
	end
	
	-- place_glass_in_house
	if achievement == "place_glass_in_house" and players_achievements[player_name][achievement] == 2 then
		update = true
	end
	
	-- dig_stone_with_mese_pickaxe
	if achievement == "dig_stone_with_mese_pickaxe" and players_achievements[player_name][achievement] == 1 then
		update = true
	end
	
	-- place_water_up
	if achievement == "place_water_up" and players_achievements[player_name][achievement] == 1 then
		update = true
	end
	
	-- collect_spawn_lava
	if achievement == "collect_spawn_lava" and players_achievements[player_name][achievement] == 1 then
		update = true
	end

	-- update
	if update then
		achievements.update(skyblock.has_spawn(player_name))
		minetest.chat_send_player(player_name, "You earned the achievement '"..achievement.."'")
		minetest.chat_send_all(player_name.." was awarded the achievement '"..achievement.."'")
	end
	
	table.save(players_achievements, skyblock.FILENAME..".achievements")
end


-- reset
achievements.reset = function(player_name)
	dbg("achievements.reset() for "..player_name)
	players_achievements[player_name] = {}
	table.save(players_achievements, skyblock.FILENAME..".achievements")
	achievements.update(skyblock.has_spawn(player_name))
end


-- track digging achievements
achievements.on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	local spawn
	local tool
	
	-- dig_stone
	if oldnode.name == "default:stone" then
		-- with mese pickaxe
		if digger:get_wielded_item():get_name() == "default:pick_mese" then
			achievements.add(player_name,"dig_stone_with_mese_pickaxe")
			return
		end
		achievements.add(player_name,"dig_stone")
		return
	end

	-- dig_tree
	if oldnode.name == "default:tree" then
		achievements.add(player_name,"dig_tree")
		return
	end
end


-- track placing achievements
achievements.on_placenode = function(pos, newnode, placer)
	local player_name = placer:get_player_name()
	local spawn

	-- place_sapling
	if newnode.name == "default:sapling" then
		achievements.add(player_name,"place_sapling")
		return
	end

	-- place_dirt
	if newnode.name == "default:dirt" then
		achievements.add(player_name,"place_dirt")
		return
	end

	-- place_chest
	if newnode.name == "default:chest" then
		achievements.add(player_name,"place_chest")
		return
	end

	-- place_furnace
	if newnode.name == "default:furnace" then
		achievements.add(player_name,"place_furnace")
		return
	end

	-- place_wood
	if newnode.name == "default:wood" then
		achievements.add(player_name,"place_wood")
		return
	end

	-- place_brick
	if newnode.name == "default:brick" then
		achievements.add(player_name,"place_brick")
		return
	end

	-- place glass in house
	if newnode.name == "default:glass" and (minetest.env:find_node_near(pos,1,"default:brick")~=nil or minetest.env:find_node_near(pos,1,"default:wood")~=nil) then
		achievements.add(player_name,"place_glass_in_house")
		return
	end

	-- place_water_up / place_water_infinite
	if newnode.name == "default:water_source" then
		-- place_water_up
		if pos.y>=7 then
			achievements.add(player_name,"place_water_up")
			return
		end
		-- place_water_infinite
		if minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z-1}).name=="default:water_source" then
			achievements.add(player_name,"place_water_infinite")
			return
		end
		if minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z+1}).name=="default:water_source" then
			achievements.add(player_name,"place_water_infinite")
			return
		end
		if minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z-1}).name=="default:water_source" then
			achievements.add(player_name,"place_water_infinite")
			return
		end
		if minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z+1}).name=="default:water_source" then
			achievements.add(player_name,"place_water_infinite")
			return
		end
		return
	end

end


-- track bucket achievements
achievements.bucket_on_use = function(itemstack, user, pointed_thing)
	-- Must be pointing to node
	if pointed_thing.type ~= "node" then
		return
	end
	-- Check if pointing to a liquid source
	n = minetest.env:get_node(pointed_thing.under)
	liquiddef = bucket.liquids[n.name]
	if liquiddef ~= nil and liquiddef.source == n.name and liquiddef.itemname ~= nil then
		
		-- begin change for achievements
		if n.name == "default:lava_source" then
			local player_name = user:get_player_name()
			local spawn = skyblock.has_spawn(player_name)
			if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
				achievements.add(player_name,"collect_spawn_lava")
			end
		end
		-- end change for achievements
	
		minetest.env:add_node(pointed_thing.under, {name="air"})
		return {name=liquiddef.itemname}
	end
end
