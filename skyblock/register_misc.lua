--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

-- set mapgen to singlenode
minetest.register_on_mapgen_init(function(mgparams)
	minetest.set_mapgen_params({mgname='singlenode', water_level=-32000})
end)

-- spawn player
minetest.register_on_respawnplayer(function(player)
	skyblock.spawn_player(player)
	return true
end)

-- register the game after the server starts
minetest.after(5, function()
	local spawn_timer = 0
	local spawn_throttle = 2

	-- handle globalstep
	minetest.register_globalstep(function(dtime)
	
		spawn_timer = spawn_timer + dtime
		for k,player in ipairs(minetest.get_connected_players()) do
			local player_name = player:get_player_name()
			
			-- player has not spawned yet
			if spawned_players[player_name] == nil then

				-- handle new player spawn setup (no more than once per interval)
				if spawn_timer > spawn_throttle then
					skyblock.log('globalstep() new spawn for '..player_name..' (not spawned)')
					if skyblock.get_spawn(player:get_player_name()) or skyblock.spawn_player(player) then
						spawned_players[player:get_player_name()] = true
					end
				end

			-- player is spawned
			else
				local pos = player:getpos()

				-- only check once per throttle time
				if spawn_timer > spawn_throttle then

					-- hit the bottom
					if pos.y < skyblock.world_bottom then
						local spawn = skyblock.get_spawn(player_name)
						if minetest.env:get_node(spawn).name ~= "skyblock:quest" and skyblock.levels.check_inventory(player) then
							-- no spawn block and empty inventory, respawn them
							skyblock.log("globalstep() "..player_name.." has fallen too far, but dont kill them... yet =)")
							skyblock.make_spawn_blocks(spawn,player:get_player_name())
							skyblock.spawn_player(player)
						else
							-- kill them
							skyblock.log('globalstep() '..player_name..' has fallen too far at '..skyblock.dump_pos(pos)..'... kill them now')
							player:set_hp(0)
						end
						
					end
				end
				
				-- walking on dirt_with_grass, change to dirt_with_grass_footsteps
				local np = {x=pos.x,y=pos.y-1,z=pos.z}
				if (minetest.env:get_node(np).name == 'default:dirt_with_grass') then
					minetest.env:add_node(np, {name='default:dirt_with_grass_footsteps'})
				end
				
			end
			
		end
		
		-- reset the spawn_timer
		if spawn_timer > spawn_throttle then	
			spawn_timer = 0
		end	
	
	end)

end)
