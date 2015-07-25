--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
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
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+40,z=pos.z}
end


-- make start blocks
levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 5
	local hollow = 1
	skyblock.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)

	-- level 3
	minetest.env:add_node(pos, {name='skyblock:level_3'})
	achievements.update(level,player_name)

end


-- update achievements
levels[level].update = function(player_name,pos)
	local formspec = ''
	local total = 10
	local count = 0

	formspec = achievements.get_items_formspec(level,nav)
		..'label[0,0.5; Does This Keep Going?]'
		..'label[0,1.0; If you are enjoying this world, then stray not]'
		..'label[0,1.5; from your mission traveller...]'
		..'label[0,2.0; ... for the end is near.]'

	-- dig 20 papyrus
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,1,'dig 20 Papyrus','dig_papyrus',20)
	formspec = formspec..goal_formspac
	count = count + success

	-- place 20 papyrus
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,2,'place 20 Papyrus in a nice garden','place_papyrus',20)
	formspec = formspec..goal_formspac
	count = count + success

	-- dig 15 cactus
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,3,'dig 15 Cactus','dig_cactus',15)
	formspec = formspec..goal_formspac
	count = count + success

	-- place 15 cactus
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,4,'place 15 Cactus in another gargen','place_cactus',15)
	formspec = formspec..goal_formspac
	count = count + success

	-- place 30 fences
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,5,'place 30 fences around your gardens','place_fence',30)
	formspec = formspec..goal_formspac
	count = count + success

	-- place 20 ladders
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,6,'add 20 ladders to your structures','place_ladder',20)
	formspec = formspec..goal_formspac
	count = count + success

	-- place 5 bookshelves
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,7,'decorate your house with 5 Bookshelves','place_bookshelf',5)
	formspec = formspec..goal_formspac
	count = count + success

	-- place 5 signs
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,8,'place 5 Signs to help other travellers','place_sign_wall',5)
	formspec = formspec..goal_formspac
	count = count + success

	-- place 50 torches
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,9,'place 50 Torches to help you see at night','place_torch',50)
	formspec = formspec..goal_formspac
	count = count + success

	-- dig 500 stone
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,10,'dig 500 Stone for your next project...','dig_stone',500)
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
		if pos and minetest.env:get_node(pos).name ~= 'skyblock:level_4' then
			levels[level+1].make_start_blocks(player_name)
		end
	end

	local infotext = 'LEVEL '..level..' for '.. player_name ..': '.. count ..' of '..total
	return formspec, infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	
	-- dig_papyrus
	if achievement == 'dig_papyrus' and achievement_count == 20 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_papyrus
	if achievement == 'place_papyrus' and achievement_count == 20 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- dig_cactus
	if achievement == 'dig_cactus' and achievement_count == 15 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_cactus
	if achievement == 'place_cactus' and achievement_count == 15 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_fence
	if achievement == 'place_fence' and achievement_count == 30 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_ladder
	if achievement == 'place_ladder' and achievement_count == 20 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_bookshelf
	if achievement == 'place_bookshelf' and achievement_count == 5 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_sign_wall
	if achievement == 'place_sign_wall' and achievement_count == 10 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_torch
	if achievement == 'place_torch' and achievement_count == 50 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- dig_stone
	if achievement == 'dig_stone' and achievement_count == 500 then
		achievements.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
end


-- track placing achievements
levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_papyrus
	if newnode.name == 'default:papyrus' then
		achievements.add(level,player_name,'place_papyrus')
		return
	end

	-- place_cactus
	if newnode.name == 'default:cactus' then
		achievements.add(level,player_name,'place_cactus')
		return
	end

	-- place_fence
        if newnode.name == 'default:fence_wood' or newnode.name == 'xfences:fence' then
		achievements.add(level,player_name,'place_fence')
		return
	end

	-- place_ladder
	if newnode.name == 'default:ladder' then
		achievements.add(level,player_name,'place_ladder')
		return
	end

	-- place_bookshelf
	if newnode.name == 'default:bookshelf' then
		achievements.add(level,player_name,'place_bookshelf')
		return
	end

	-- place_sign_wall
	if newnode.name == 'default:sign_wall' then
		achievements.add(level,player_name,'place_sign_wall')
		return
	end

	-- place_torch
	if newnode.name == 'default:torch' then
		achievements.add(level,player_name,'place_torch')
		return
	end

end

-- track digging achievements
levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	
	-- dig_papyrus
	if oldnode.name == 'default:papyrus' then
		achievements.add(level,player_name,'dig_papyrus')
		return
	end
	
	-- dig_cactus
	if oldnode.name == 'default:cactus' then
		achievements.add(level,player_name,'dig_cactus')
		return
	end
	
	-- dig_stone
	if oldnode.name == 'default:stone' then
		achievements.add(level,player_name,'dig_stone')
		return
	end
	
end

-- not used
levels[level].bucket_on_use = function(player_name, pointed_thing) end
levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end
