--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

ACHIEVEMENT FUNCTIONS

]]--


-- local variable to save players achievements
local players_achievements = table.load(skyblock.FILENAME..'.achievements')
if players_achievements == nil then
	players_achievements = {}
end


--
-- PUBLIC FUNCTIONS
--

achievements = {}


-- reset
achievements.reset = function(player_name)
	skyblock.log('achievements.reset() for '..player_name)
	players_achievements[player_name] = {}
	table.save(players_achievements, skyblock.FILENAME..'.achievements')
end

-- get_formspec
achievements.get_formspec = function(player_name,page)
	skyblock.log('achievements.get_formspec() for '..player_name)
	if page=="skyblock" then
		local level = achievements.get(0, player_name, 'level')
		return levels[level].update(player_name,true)
	end
end

-- get_goal_formspac
achievements.get_goal_formspac = function(player_name,level,i,name,achievement,required)
	local formspec = 'label[9,'..i..'; '..i..') '..name..']'
	if achievements.get(level,player_name,achievement) >= required then
		formspec = formspec .. 'label[9.3,'..i..'.4; COMPLETE!]'
		return formspec,1
	else
		formspec = formspec .. 'label[9.3,'..i..'.4; not done]'
		return formspec,0
	end
end

-- update achievements
achievements.update = function(level,player_name)
	local pos = levels[level].get_pos(player_name)
	skyblock.log('achievements.update() level '..level..' for '..player_name..' at '..skyblock.dump_pos(pos))
	if pos==nil then return pos end
	local meta = minetest.env:get_meta(pos)
	local formspec,infotext = levels[level].update(player_name)
	meta:set_string('formspec', formspec)
	meta:set_string('infotext', infotext)
end


-- get achievement
achievements.get = function(level,player_name,achievement)
	if players_achievements[player_name] == nil then
		players_achievements[player_name] = {}
	end
	if players_achievements[player_name][level] == nil then
		players_achievements[player_name][level] = {}
	end
	if players_achievements[player_name][level][achievement] == nil then
		players_achievements[player_name][level][achievement] = 0
		if achievement=='level' then
			players_achievements[player_name][level][achievement] = 1
		end
	end
	skyblock.log('achievements.get() for level '..level..' '..player_name..' achievement '..achievement..' is '..players_achievements[player_name][level][achievement])
	return players_achievements[player_name][level][achievement]
end


-- give reward
achievements.give_reward = function(level,player_name,item_name)
	local player = minetest.get_player_by_name(player_name)
	skyblock.log('achievements.give_reward() for '..player_name..' item '..item_name)
	minetest.get_player_by_name(player_name):get_inventory():add_item('rewards', item_name)
	inventory_plus.set_inventory_formspec(player, achievements.get_formspec(player_name,"skyblock"))
end


-- set achievement
achievements.add = function(level,player_name,achievement)
	skyblock.log('achievements.add() for level '..level..' player '..player_name..' achievement '..achievement)
	local player_achievement = achievements.get(level,player_name,achievement)
	players_achievements[player_name][level][achievement] = player_achievement + 1
	if level==0 or achievement=='level' then
		table.save(players_achievements, skyblock.FILENAME..'.achievements')
		return
	end
	local update = levels[level].reward_achievement(player_name,achievement)
	
	-- update
	if update then
		achievements.update(level,player_name)
		minetest.chat_send_player(player_name, 'You earned the achievement "'..achievement..'"')
		--minetest.chat_send_all(player_name..' was awarded the achievement "'..achievement..'"')
		minetest.log('action', player_name..' was awarded the achievement "'..achievement..'"')
	end
	
	table.save(players_achievements, skyblock.FILENAME..'.achievements')
end


-- track digging achievements
achievements.on_dignode = function(pos, oldnode, digger)
	if not digger then return end -- needed to prevent server crash when player leaves
	local player_name = digger:get_player_name()
	local level = achievements.get(0, player_name, 'level')
	skyblock.log('achievements.on_dignode() for '..player_name..' on level '..level..' at '..skyblock.dump_pos(pos))
	levels[level].on_dignode(pos, oldnode, digger)
end


-- track placing achievements
achievements.on_placenode = function(pos, newnode, placer, oldnode)
	if not placer then return end -- needed to prevent server crash when player leaves
	local player_name = placer:get_player_name()
	local level = achievements.get(0, player_name, 'level')
	skyblock.log('achievements.on_placenode() for '..player_name..' on level '..level..' at '..skyblock.dump_pos(pos))
	levels[level].on_placenode(pos, newnode, placer, oldnode)
end

-- bucket achievements
achievements.bucket_on_use = function(itemstack, user, pointed_thing)
	if not user then return end -- needed to prevent server crash when player leaves
	local player_name = user:get_player_name()
	local level = achievements.get(0, player_name, 'level')
	skyblock.log('achievements.bucket_on_use() for '..player_name..' on level '..level)
	levels[level].bucket_on_use(player_name, pointed_thing)
end

-- bucket achievements
achievements.bucket_water_on_use = function(itemstack, user, pointed_thing)
	if not user then return end -- needed to prevent server crash when player leaves
	local player_name = user:get_player_name()
	local level = achievements.get(0, player_name, 'level')
	skyblock.log('achievements.bucket_water_on_use() for '..player_name..' on level '..level)
	levels[level].bucket_water_on_use(player_name, pointed_thing)
end

-- bucket achievements
achievements.bucket_lava_on_use = function(itemstack, user, pointed_thing)
	if not user then return end -- needed to prevent server crash when player leaves
	local player_name = user:get_player_name()
	local level = achievements.get(0, player_name, 'level')
	skyblock.log('achievements.bucket_lava_on_use() for '..player_name..' on level '..level)
	levels[level].bucket_lava_on_use(player_name, pointed_thing)
end

-- handle digging the level block
achievements.level_on_dig = function(level, pos, node, digger)
	if not digger then return end -- needed to prevent server crash when player leaves
	if level ~= 1 then
		return
	end
	local player_name = digger:get_player_name()
	local spawn = skyblock.get_spawn(player_name)
	skyblock.log('achievements.level_on_dig() for '..player_name)

	-- setup trigger for new spawn
	skyblock.spawn_diggers[player_name] = true

	-- kill them
	digger:set_hp(0)
end

-- handle level block punch
achievements.level_on_punch = function(level, pos, node, puncher)
	if not puncher then return end -- needed to prevent server crash when player leaves
	local player_name = puncher:get_player_name()
	skyblock.log('achievements.level_on_punch() by '..player_name)
	achievements.update(level, player_name)
end
