--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER MISC

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

-- track node digging
minetest.register_on_dignode(function(pos, oldnode, digger)
	achievements.on_dignode(pos, oldnode, digger)
end)

-- track node placing
minetest.register_on_placenode(function(pos, newnode, placer, oldnode)
	achievements.on_placenode(pos, newnode, placer, oldnode)
end)

-- track eating
minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	achievements.on_item_eat(hp_change, replace_with_item, itemstack, user, pointed_thing)
end)

-- register the game after the server starts
minetest.after(5, function()

	-- handle globalstep
	minetest.register_globalstep(function(dtime)
		return skyblock.globalstep(dtime)
	end)

end)
