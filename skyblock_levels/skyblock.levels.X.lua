--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--


--[[

not a real level, just ideas and leftover code
	
feats:
* place_cactus
* place_papyrus
* dig_flower
* place_bookshelf
* collect_water
* place_water_infinite
* place_sand
* place_desert_sand
* place_stone
* place_cobble
* place_mossycobble
* place_steelblock
* dig_stone_with_copper
* dig_stone
* place_glass

rewards:
* default:diamond
* default:water_source
* default:lava_source


--]]	

local feats = {
	{
		feat = 'collect_water', 
		count = 1, 
		reward = 'default:stick',
		bucket = {'default:water_source'},
	},
}

-- track bucket feats
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing)

	-- collect_water
	local n = minetest.env:get_node(pointed_thing.under)
	skyblock.log('skyblock.levels[2].bucket_water_on_use() for '..player_name..' pointed at '..n.name)
	if n.name == 'default:water_source' then
		skyblock.feats.add(level,player_name,'collect_water')
	end

	-- collect_spawn_water
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == 'default:water_source' then
		local spawn = skyblock.get_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			skyblock.feats.add(level,player_name,'collect_spawn_water')
			end
	end

end

-- track bucket water feats
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) 

	-- place_water_infinite
	local pos = pointed_thing.under
	if minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z-1}).name=='default:water_source' 
	or minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z+1}).name=='default:water_source'
	or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z-1}).name=='default:water_source'
	or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z+1}).name=='default:water_source' then
		skyblock.feats.add(level,player_name,'place_water_infinite')
		return
	end

end

