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
	skyblock.levels.give_initial_items(player)

	skyblock.spawn_player(player)
	--skyblock.levels[1].make_start_blocks(player_name)

	-- move the player up high enough in order to avoid collusions with the ground
	local pos = skyblock.get_spawn(player_name)
	if pos then
		skyblock.feats.update(player_name) -- setup the initial level, needed?
		player:setpos({x=pos.x, y=pos.y+8, z=pos.z});
	end
end)

-- handle respawn player
minetest.register_on_respawnplayer(function(player)
	local player_name = player:get_player_name()
	local spawn = skyblock.get_spawn(player_name)
	
	-- empty inventory
	skyblock.levels.empty_inventory(player)
	
	-- reset feats
	skyblock.feats.reset(player_name)
	
	-- give inventory
	skyblock.levels.give_initial_items(player)

	-- unset old spawn position
	if skyblock.levels.DIG_NEW_SPAWN then
		spawned_players[player_name] = nil
		skyblock.set_spawn(player_name, nil)
		skyblock.set_spawn(player_name..'_DEAD', spawn)
	end

	-- rebuild spawn blocks
	skyblock.make_spawn_blocks(spawn,player_name)
	--skyblock.levels[1].make_start_blocks(player_name)
	
	return true
end)

-- player has joined
minetest.register_on_joinplayer(function(player)
	-- add rewards to player inventory
	player:get_inventory():set_size('rewards', 4)
	-- set inventory formspec
	minetest.after(1,function()
		player:set_inventory_formspec(skyblock.levels.get_formspec(player:get_player_name()))
	end)
end)

-- on_receive_fields
skyblock.on_receive_fields = function(player, formname, fields)
	if fields.skyblock or fields.main then
		minetest.show_formspec(player:get_player_name(), "skyblock:main", player:get_inventory_formspec());
		return
	end
end
minetest.register_on_player_receive_fields(skyblock.on_receive_fields)