--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER MISC

]]--


-- handle new player
minetest.register_on_newplayer(function(player)
	return skyblock.give_inventory(player)
end)

-- handle respawn player
minetest.register_on_respawnplayer(function(player)
	return skyblock.on_respawnplayer(player)
end)

-- handle map generation
minetest.register_on_generated(function(minp, maxp)
	skyblock.on_generated(minp, maxp)
end)

-- track global node digging
minetest.register_on_dignode(function(pos, oldnode, digger)
	skyblock.on_dignode(pos, oldnode, digger)
end)

-- track global node placing
minetest.register_on_placenode(function(pos, newnode, placer, oldnode)
	skyblock.on_placenode(pos, newnode, placer, oldnode)
end)

-- register the game after the server starts
minetest.after(10, function()

	-- handle globalstep
	minetest.register_globalstep(function(dtime)
		return skyblock.globalstep(dtime)
	end)

end)
