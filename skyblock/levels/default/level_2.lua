--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
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
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+15,z=pos.z}
end


-- make start blocks
levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 3
	local hollow = 1
	skyblock.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)

	-- level 2
	minetest.env:add_node(pos, {name='skyblock:level_2'})
	achievements.update(level,player_name)

end


-- update achievements
levels[level].update = function(player_name,nav)
	local formspec = ''
	local total = 10
	local count = 0

	formspec = achievements.get_items_formspec(level,nav)
		..'label[0,0.5; Come Up Here!]'
		..'label[0,1; Wow, look at that view... of... nothing...]'
		..'label[0,1.5; You should get to work extending this island.]'
		..'label[0,2; Perhaps you could build some structures too?]'

	-- place_dirt
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,1,'extend your Island with 100 Dirt','place_dirt',100)
	formspec = formspec..goal_formspac
	count = count + success

	-- collect_water
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,2,'collect the Water under Level 2','collect_water',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_wood
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,3,'build a structure using 50 Wood','place_wood',50)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_brick
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,4,'build a structure using 50 Brick','place_brick',50)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_trapdoor
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,5,'place a Trapdoor','place_trapdoor',1)
	formspec = formspec..goal_formspac
	count = count + success
	
	-- place_ladder
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,6,'place 10 Ladders','place_ladder',10)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_fence_wood
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,7,'place 20 Wood Fences','place_fence_wood',20)
	formspec = formspec..goal_formspac
	count = count + success
	
	-- dig_stone_with_iron
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,8,'dig 8 Iron Lumps','dig_stone_with_iron',4)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_chest_locked
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,9,'craft and place a Locked Chest','place_chest_locked',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- dig_stone_with_copper
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,10,'dig 4 Copper Lumps','dig_stone_with_copper',4)
	formspec = formspec..goal_formspac
	count = count + success

	-- next level
	if count==total and achievements.get(0,player_name,'level')==level then
		levels[level+1].make_start_blocks(player_name)
		achievements.add(0,player_name,'level')
		formspec = levels[level+1].update(player_name,nav)
	end
	if  achievements.get(0,player_name,'level') > level then
		local pos = levels[level+1].get_pos(player_name)
		if pos and minetest.env:get_node(pos).name ~= 'skyblock:level_3' then
			levels[level+1].make_start_blocks(player_name)
		end
	end

	local infotext = 'LEVEL '..level..' for '.. player_name ..': '.. count ..' of '..total
	return formspec, infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	
	-- place_dirt
	if achievement == 'place_dirt' and achievement_count == 100 then
		achievements.give_reward(level,player_name,'bucket:bucket_empty')
		-- put water above spawn
		local pos = levels[1].get_pos(player_name)
		minetest.env:add_node({x=pos.x,y=pos.y+1,z=pos.z}, {name='default:water_source'})
		return true
	end
	
	-- collect_water x1
	if achievement == 'collect_water' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:jungleleaves 6')
		return true
	end

	-- place_water_infinite
	--[[
	if achievement == 'place_water_infinite' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:cobble 50')
		return true
	end
	]]--

	-- place_wood
	if achievement == 'place_wood' and achievement_count == 50 then
		achievements.give_reward(level,player_name,'default:brick 50')
		return true
	end

	-- place_brick
	if achievement == 'place_brick' and achievement_count == 50 then
		achievements.give_reward(level,player_name,'default:sandstonebrick 50')
		return true
	end
	
	-- place_trapdoor
	if achievement == 'place_trapdoor' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:desert_stonebrick 50')
		return true
	end

	-- place_ladder
	if achievement == 'place_ladder' and achievement_count == 10 then
		achievements.give_reward(level,player_name,'default:desert_cobble 50')
		return true
	end

	-- place_fence_wood
	if achievement == 'place_fence_wood' and achievement_count == 20 then
		achievements.give_reward(level,player_name,'default:iron_lump')
		achievements.give_reward(level,player_name,'default:cobble 50')
		return true
	end
	
	-- dig_stone_with_iron x8
	if achievement == 'dig_stone_with_iron' and achievement_count == 4 then
		achievements.give_reward(level,player_name,'default:pine_needles 6')
		return true
	end

	-- place_chest_locked
	if achievement == 'place_chest_locked' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:copper_lump')
		return true
	end

	-- dig_stone_with_copper x8
	if achievement == 'dig_stone_with_copper' and achievement_count == 4 then
		achievements.give_reward(level,player_name,'default:gold_lump')
		return true
	end
	
end


-- track digging achievements
levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()

	-- dig_stone_with_iron
	if oldnode.name == 'default:stone_with_iron' then
		achievements.add(level,player_name,'dig_stone_with_iron')
		return
	end
	
	-- dig_stone_with_copper
	if oldnode.name == 'default:stone_with_copper' then
		achievements.add(level,player_name,'dig_stone_with_copper')
		return
	end

end


-- track placing achievements
levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_dirt
	if newnode.name == 'default:dirt' then
		achievements.add(level,player_name,'place_dirt')
		return
	end

	-- place_brick
	if newnode.name == 'default:brick' then
		achievements.add(level,player_name,'place_brick')
		return
	end

	-- place_wood
	if newnode.name == 'default:wood' or newnode.name == 'default:junglewood' or newnode.name == 'default:pinewood' then
		achievements.add(level,player_name,'place_wood')
		return
	end

	-- place_trapdoor
	if newnode.name == 'doors:trapdoor' then
		achievements.add(level,player_name,'place_trapdoor')
		return
	end

	-- place_ladder
	if newnode.name == 'default:ladder' then
		achievements.add(level,player_name,'place_ladder')
		return
	end

	-- place_fence_wood
	if newnode.name == 'default:fence_wood' then
		achievements.add(level,player_name,'place_fence_wood')
		return
	end

	-- place_chest_locked
	if newnode.name == 'default:chest_locked' then
		achievements.add(level,player_name,'place_chest_locked')
		return
	end

end


-- track bucket achievements
levels[level].bucket_on_use = function(player_name, pointed_thing)

	-- collect_water
	local n = minetest.env:get_node(pointed_thing.under)
	skyblock.log('levels[2].bucket_water_on_use() for '..player_name..' pointed at '..n.name)
	if n.name == 'default:water_source' then
		achievements.add(level,player_name,'collect_water')
	end

end


-- track bucket water achievements
levels[level].bucket_water_on_use = function(player_name, pointed_thing) 

	-- place_water_infinite
	--[[
	local pos = pointed_thing.under
	if minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z-1}).name=='default:water_source' 
	or minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z+1}).name=='default:water_source'
	or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z-1}).name=='default:water_source'
	or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z+1}).name=='default:water_source' then
		achievements.add(level,player_name,'place_water_infinite')
		return
	end
	]]--

end


-- track bucket lava achievements
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end