--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 2 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = X -- not a real level, just ideas and leftover code
skyblock.levels[level] = {}


-- get pos
skyblock.levels[level].get_pos = function(player_name)
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+15,z=pos.z}
end


-- make start blocks
skyblock.levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = skyblock.levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 3
	local hollow = 1
	skyblock.levels({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)
	minetest.env:add_node({x=pos.x,y=pos.y-1,z=pos.z}, {name='default:water_source'})

	-- level 2
	minetest.env:add_node(pos, {name='skyblock:level_2'})
	skyblock.feats.update(level,player_name)

end


-- update feats
skyblock.levels[level].get_info = function(player_name,pos)
	local formspec = ''
	local total = 10
	local count = 0

	
		--..skyblock.levels.get_goal_formspec(info,10,'dig_stone_with_copper',4,'dig 4 Copper Lumps','default:copper_lump')
		--..skyblock.levels.get_goal_formspec(info,2,'collect_water',1,'collect the Water')
		--..skyblock.levels.get_goal_formspec(info,7,'place_brick',50,'build a structure using 50 Brick','default:brick')
		--..skyblock.levels.get_goal_formspec(info,10,'place_dirt',80,'extend your Island with 80 Dirt','default:dirt')
		--..skyblock.levels.get_goal_formspec(info,10,'place_torch',8,'place 8 Torches','default:torch')

		
		-- rewards = 		skyblock.feats.give_reward(level,player_name,'stairs:stair_brick 3')

		
	formspec = formspec
		..'size[15,10;]'
		..'label[0,0;LEVEL '..level..' FOR: '.. player_name ..']'
		..'label[13.4,0; rewards]'
		..'list[current_name;rewards;13,0.5;2,2;]'
		..'list[current_player;main;0,6;8,4;]'

		..'label[0,1; --== A View From Above ==--]'
		..'label[0,1.5; Wow, look at that view... of... nothing.]'
		..'label[0,2.0; You should get to work extending this]'
		..'label[0,2.5; island.  Perhaps you could build some]'
		..'label[0,3.0; structures too?]'
		
		..'label[0,4; --== About The Level '..level..' Block ==--]'
		..'label[0,4.5; * SHORT LEFT CLICK]'
		..'label[0.4,5; = PUNCH to refresh feats]'

	-- place water infinite
	formspec = formspec..'label[8,0; 1) create an Infinite Water Source]'
	if skyblock.feats.get(level,player_name,'place_water_infinite') >= 1 then
		formspec = formspec .. 'label[8.3,0.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,0.4; not done]'
	end

	-- place 200 dirt
	formspec = formspec..'label[8,1; 2) extend your Island with 200 Dirt]'
	if skyblock.feats.get(level,player_name,'place_dirt') >= 200 then
		formspec = formspec .. 'label[8.3,1.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,1.4; not done]'
	end

	-- place trapdoor
	
	-- place 20 ladders

	-- place 20 wood fences
	
	-- dig 4 iron lumps
	formspec = formspec..'label[8,8; 9) dig 4 Iron Lumps]'
	if skyblock.feats.get(level,player_name,'dig_stone_with_iron') >= 2 then
		formspec = formspec .. 'label[8.3,8.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,8.4; not done]'
	end
	
	-- place locked chest

	-- dig 4 copper lumps
	formspec = formspec..'label[8,9; 10) dig 4 Copper Lumps]'
	if skyblock.feats.get(level,player_name,'dig_stone_with_copper') >= 2 then
		formspec = formspec .. 'label[8.3,9.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,9.4; not done]'
	end

	-- TODO (below)
	
	-- place 50 wood
	formspec = formspec..'label[8,1; 2) build a structure using 200 Wood]'
	if skyblock.feats.get(level,player_name,'place_wood') >= 200 then
		formspec = formspec .. 'label[8.3,1.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,1.4; not done]'
	end

	-- place 50 brick
	formspec = formspec..'label[8,2; 3) build a structure using 200 Brick]'
	if skyblock.feats.get(level,player_name,'place_brick') >= 200 then
		formspec = formspec .. 'label[8.3,2.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,2.4; not done]'
	end

	-- place 12 glass
	formspec = formspec..'label[8,3; 4) add at least 200 Glass windows]'
	if skyblock.feats.get(level,player_name,'place_glass') >= 200 then
		formspec = formspec .. 'label[8.3,3.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,3.4; not done]'
	end

	-- place 40 sand
	formspec = formspec..'label[8,4; 5) make a desert with 200 Sand]'
	if skyblock.feats.get(level,player_name,'place_sand') >= 200 then
		formspec = formspec .. 'label[8.3,4.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,4.4; not done]'
	end

	-- place 30 desert_sand
	formspec = formspec..'label[8,5; 6) also include 200 Desert Sand]'
	if skyblock.feats.get(level,player_name,'place_desert_sand') >= 200 then
		formspec = formspec .. 'label[8.3,5.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,5.4; not done]'
	end

	-- place 50 stone
	formspec = formspec..'label[8,6; 7) build a tower with 200 Stone]'
	if skyblock.feats.get(level,player_name,'place_stone') >= 200 then
		formspec = formspec .. 'label[8.3,6.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,6.4; not done]'
	end

	-- place 40 cobble
	formspec = formspec..'label[8,7; 8) make a path with 200 Cobblestone]'
	if skyblock.feats.get(level,player_name,'place_cobble') >= 200 then
		formspec = formspec .. 'label[8.3,7.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,7.4; not done]'
	end

	-- place 30 mossycobble
	formspec = formspec..'label[8,8; 9) also use 200 Mossy Cobblestone]'
	if skyblock.feats.get(level,player_name,'place_mossycobble') >= 200 then
		formspec = formspec .. 'label[8.3,8.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,8.4; not done]'
	end

	-- place 20 steelblock
	formspec = formspec..'label[8,9; 10) decorate your area with 75 Steel Blocks]'
	if skyblock.feats.get(level,player_name,'place_steelblock') >= 75 then
		formspec = formspec .. 'label[8.3,9.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,9.4; not done]'
	end

	-- next level
	if count==total and skyblock.feats.get(0,player_name,'level')==level then
		skyblock.levels[level+1].make_start_blocks(player_name)
		skyblock.feats.add(0,player_name,'level')
	end
	if  skyblock.feats.get(0,player_name,'level') > level then
		local pos = skyblock.levels[level+1].get_pos(player_name)
		if pos and minetest.env:get_node(pos).name ~= 'skyblock:level_3' then
			skyblock.levels[level+1].make_start_blocks(player_name)
		end
	end

	local infotext = 'LEVEL '..level..' for '.. player_name ..': '.. count ..' of '..total
	return formspec, infotext
end


-- reward_feat
skyblock.levels[level].reward_feat = function(player_name,feat)
	local feat_count = skyblock.feats.get(level,player_name,feat)

	
	-- place_brick
	if feat == 'place_brick' and feat_count == 50 then
		skyblock.feats.give_reward(level,player_name,'default:sandstonebrick 50')
		-- put water above spawn
		--local pos = skyblock.levels[1].get_pos(player_name)
		--minetest.env:add_node({x=pos.x,y=pos.y+1,z=pos.z}, {name='default:water_source'})
		return true
	end
	
	
	-- dig_stone_with_copper x8
	if feat == 'dig_stone_with_copper' and feat_count == 4 then
		skyblock.feats.give_reward(level,player_name,'default:gold_lump')
		return true
	end

	
	
	-- dig_stone
	if oldnode.name == 'default:stone' then
		skyblock.feats.add(level,player_name,'dig_stone')
		return
	end
	
	-- dig_stone_with_coal
	if oldnode.name == 'default:stone_with_coal' then
		skyblock.feats.add(level,player_name,'dig_stone_with_coal')
		return
	end
	

	-- place_water_infinite
	if feat == 'place_water_infinite' and feat_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:lava_source')
		return true
	end

	-- dig_stone_with_iron x2
	if feat == 'dig_stone_with_iron' and feat_count == 2 then
		skyblock.feats.give_reward(level,player_name,'default:copper_lump')
		return true
	end

	-- dig_stone_with_copper x2
	if feat == 'dig_stone_with_copper' and feat_count == 2 then
		skyblock.feats.give_reward(level,player_name,'default:gold_lump')
		return true
	end

	
	-- TODO (below)
	
	-- place_dirt
	if feat == 'place_dirt' and feat_count == 200 then
		skyblock.feats.give_reward(level,player_name,'default:wood '..math.random(50,99))
		return true
	end
	
	-- place_wood
	if feat == 'place_wood' and feat_count == 200 then
		skyblock.feats.give_reward(level,player_name,'default:brick '..math.random(50,99))
		return true
	end
	
	-- place_brick
	if feat == 'place_brick' and feat_count == 200 then
		skyblock.feats.give_reward(level,player_name,'default:glass '..math.random(50,99))
		return true
	end
	
	-- place_glass
	if feat == 'place_glass' and feat_count == 200 then
	skyblock.feats.give_reward(level,player_name,'default:sand '..math.random(50,99))
		return true
	end
	
	-- place_sand
	if feat == 'place_sand' and feat_count == 200 then
		skyblock.feats.give_reward(level,player_name,'default:desert_sand '..math.random(50,99))
		return true
	end
	
	-- place_desert_sand
	if feat == 'place_desert_sand' and feat_count == 200 then
		skyblock.feats.give_reward(level,player_name,'default:stone '..math.random(50,99))
		return true
	end
	
	-- place_stone
	if feat == 'place_stone' and feat_count == 200 then
		skyblock.feats.give_reward(level,player_name,'default:cobble '..math.random(50,99))
		return true
	end
	
	-- place_cobble
	if feat == 'place_cobble' and feat_count == 200 then
		skyblock.feats.give_reward(level,player_name,'default:mossycobble '..math.random(50,99))
		return true
	end
	
	-- place_mossycobble
	if feat == 'place_mossycobble' and feat_count == 200 then
		skyblock.feats.give_reward(level,player_name,'default:steelblock '..math.random(50,69))
		return true
	end
	
	-- place_steelblock
	if feat == 'place_steelblock' and feat_count == 75 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(5,15))
		return true
	end

end


-- track digging feats
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)

	-- dig_stone_with_iron
	if oldnode.name == 'default:stone_with_iron' then
		skyblock.feats.add(level,player_name,'dig_stone_with_iron')
		return
	end
	
	-- dig_stone_with_copper
	if oldnode.name == 'default:stone_with_copper' then
		skyblock.feats.add(level,player_name,'dig_stone_with_copper')
		return
	end

end


-- track placing feats
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_dirt
	if newnode.name == 'default:dirt' then
		skyblock.feats.add(level,player_name,'place_dirt')
		return
	end

	-- place_wood
	if newnode.name == 'default:wood' then
		skyblock.feats.add(level,player_name,'place_wood')
		return
	end

	-- place_brick
	if newnode.name == 'default:brick' then
		skyblock.feats.add(level,player_name,'place_brick')
		return
	end

	-- place_glass
	if newnode.name == 'default:glass' then
		skyblock.feats.add(level,player_name,'place_glass')
		return
	end

	-- place_sand
	if newnode.name == 'default:sand' then
		skyblock.feats.add(level,player_name,'place_sand')
		return
	end

	-- place_desert_sand
	if newnode.name == 'default:desert_sand' then
		skyblock.feats.add(level,player_name,'place_desert_sand')
		return
	end

	-- place_stone
	if newnode.name == 'default:stone' then
		skyblock.feats.add(level,player_name,'place_stone')
		return
	end

	-- place_cobble
	if newnode.name == 'default:cobble' then
		skyblock.feats.add(level,player_name,'place_cobble')
		return
	end

	-- place_mossycobble
	if newnode.name == 'default:mossycobble' then
		skyblock.feats.add(level,player_name,'place_mossycobble')
		return
	end

	-- place_steelblock
	if newnode.name == 'default:steelblock' then
		skyblock.feats.add(level,player_name,'place_steelblock')
		return
	end

end

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
	local node = minetest.env:get_node(pointed_thing.under)
	
	for _,v in ipairs(feats) do
		if v.bucket then
			for _,vv in ipairs(v.bucket) do
				if node.name == vv then
					skyblock.feats.add(level,player_name,feat.name)
				end
			end
		end
	end

	-- collect_water
	local n = minetest.env:get_node(pointed_thing.under)
	skyblock.log('skyblock.levels[2].bucket_water_on_use() for '..player_name..' pointed at '..n.name)
	if n.name == 'default:water_source' then
		skyblock.feats.add(level,player_name,'collect_water')
	end

	-- collect_spawn_water
	--[[
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == 'default:water_source' then
		local spawn = skyblock.has_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			skyblock.feats.add(level,player_name,'collect_spawn_water')
			end
	end
	]]--

	-- collect_spawn_lava
	--[[
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == 'default:lava_source' then
		local spawn = skyblock.has_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			skyblock.feats.add(level,player_name,'collect_spawn_lava')
		end
	end
	]]--

end



-- track bucket water feats
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) 

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


-- track bucket lava feats
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end