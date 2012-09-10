--[[

SkyBlock for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER MISC

]]--


-- handle new player
minetest.register_on_newplayer(function(player)
	skyblock.give_inventory(player)
end)

-- handle respawn player
minetest.register_on_respawnplayer(function(player)
	return skyblock.on_respawnplayer(player)
end)

-- track global node digging
minetest.register_on_dignode(function(pos, oldnode, digger)
	achievements.on_dignode(pos, oldnode, digger)
end)

-- track global node placing
minetest.register_on_placenode(function(pos, newnode, placer, oldnode)
	achievements.on_placenode(pos, newnode, placer, oldnode)
end)

-- register the game after the server starts
minetest.after(5, function()

	-- handle globalstep
	minetest.register_globalstep(function(dtime)
		return skyblock.globalstep(dtime)
	end)

end)
