--[[

SkyBlock for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER MISC

]]--

-- set mapgen to singlenode
minetest.register_on_mapgen_init(function(mgparams)
	minetest.set_mapgen_params({mgname="singlenode", water_level=-32000})
end)

-- handle new player
minetest.register_on_newplayer(function(player)
	skyblock.give_inventory(player)
	skyblock.spawn_player(player)
	-- move the player up high enough in order to avoid collusions with the ground
	local p = skyblock.get_spawn(player:get_player_name());
	if( p ) then
		player:setpos( {x=p.x, y=p.y+8, z=p.z} );
		achievements.update(1,player_name);
	end
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

-- track eating actions
minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	achievements.on_item_eat( hp_change, replace_with_item, itemstack, user, pointed_thing )
end)

-- register the game after the server starts
minetest.after(5, function()

	-- handle globalstep
	minetest.register_globalstep(function(dtime)
		return skyblock.globalstep(dtime)
	end)

end)



local id_liquid = minetest.get_content_id('air');
if(     skyblock.MODE == "water" ) then
	id_liquid = minetest.get_content_id('default:water_source');
elseif( skyblock.MODE == "lava" ) then
	id_liquid = minetest.get_content_id('default:lava_source');
--else
--	id_liquid = nil;
end
	

if( id_liquid ) then
	minetest.register_on_generated(function(minp, maxp, seed)
		-- do not handle mapchunks which are too heigh or too low
		if( minp.y > 0 or maxp.y < 0) then
			return;
		end

		local vm;
		local a;
		local data;
		local param2_data;
		-- get the voxelmanip object
		local emin;
		local emax;
		-- if no voxelmanip data was passed on, read the data here
		if( not( vm ) or not( a) or not( data ) or not( param2_data ) ) then
			vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
			if( not( vm )) then
				return;
			end
	
			a = VoxelArea:new{
				MinEdge={x=emin.x, y=emin.y, z=emin.z},
				MaxEdge={x=emax.x, y=emax.y, z=emax.z},
			}
	
			data = vm:get_data()
		end
	
		local y_start = math.max(skyblock.WORLD_BOTTOM,minp.y);
		local y_end   = math.min(2,maxp.y);
		for x=minp.x,maxp.x do
			for z=minp.z,maxp.z do
				for y=y_start, y_end do
					data[ a:index( x, y, z )] = id_liquid;
				end
			end
		end
		
		if( skyblock.WORLD_BOTTOM_MATERIAL and minetest.registered_nodes[ skyblock.WORLD_BOTTOM_MATERIAL ] 
		   and minp.y<=skyblock.WORLD_BOTTOM and maxp.y>=skyblock.WORLD_BOTTOM ) then
			local id_cloud = minetest.get_content_id( skyblock.WORLD_BOTTOM_MATERIAL);

			for x=minp.x,maxp.x do
				for z=minp.z,maxp.z do
					data[ a:index( x, skyblock.WORLD_BOTTOM, z )] = id_cloud;
				end
			end
		end

		local id_dirt = minetest.get_content_id( 'default:dirt' );
		local start_pos_list = skyblock.get_start_positions_in_mapchunk( minp, maxp );
		for _,v in ipairs( start_pos_list ) do
			data[ a:index( v.x, v.y, v.z ) ] = id_dirt;
			if( levels[1].make_start_blocks_on_generated ) then
				levels[1].make_start_blocks_on_generated(v, data, a);
			end
		end

		-- store the voxelmanip data
		vm:set_data(data)

		vm:calc_lighting( emin, emax);
	        vm:write_to_map(data);
	        vm:update_liquids();
	end) 
end
