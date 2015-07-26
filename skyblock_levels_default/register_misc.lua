--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL LOADER

]]--


-- new player
minetest.register_on_newplayer(function(player)
	local player_name = player:get_player_name()
	levels.give_initial_items(player)

	skyblock.spawn_player(player)
	levels[1].make_start_blocks(player_name)

	-- move the player up high enough in order to avoid collusions with the ground
	local pos = skyblock.get_spawn(player_name)
	if pos then
		achievements.update(player_name)
		player:setpos({x=pos.x, y=pos.y+8, z=pos.z});
	end
end)

-- handle respawn player
minetest.register_on_respawnplayer(function(player)
	local player_name = player:get_player_name()
	local spawn = skyblock.get_spawn(player_name)
	
	-- empty inventory
	levels.empty_inventory(player)
	
	-- reset achievements
	achievements.reset(player_name)
	
	-- give inventory
	levels.give_initial_items(player)

	-- give them a new position
	if spawn_diggers[player_name] ~= nil then
		spawn_diggers[player_name] = nil
		
		if levels.DIG_NEW_SPAWN then
			-- unset old spawn position
			spawned_players[player_name] = nil
			skyblock.set_spawn(player_name, nil)
			skyblock.set_spawn(player_name..'_DEAD', spawn)
		else
			-- rebuild spawn blocks
			--skyblock.make_spawn_blocks(spawn,player_name)
			levels[1].make_start_blocks(player_name)
		end
		
	end
	
	return true
end)

-- player has joined
minetest.register_on_joinplayer(function(player)
	-- add rewards to player inventory
	player:get_inventory():set_size('rewards', 4)
	-- set inventory formspec
	minetest.after(1,function()
		player:set_inventory_formspec(levels.get_formspec(player:get_player_name()))
	end)
end)

-- player clicked an inventory button
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.quit then
		return
	end
	-- if an item was clicked show skyblock_craft_guide
	for k,v in pairs( fields ) do
		if string.match(k, ":") then
			skyblock_craft_guide.inspect_show_crafting(player:get_player_name(), k, fields)
			return;
		end
	end
end)


