--[[

SkyBlock for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

API FUNCTIONS

]]--



-- local variables
local last_start_id = 0
local start_positions = {}
local spawned_players = {}
local spawnpos = {}

--
-- PUBLIC FUNCTIONS
--


-- log
skyblock.log = function(message)
	if not skyblock.DEBUG then
		return
	end
	minetest.log("action", "[SkyBlock] "..message)
end


-- give inventory
skyblock.give_inventory = function(player)
	skyblock.log("give_inventory() to "..player:get_player_name())
	player:get_inventory():add_item('main', 'default:stick')
	player:get_inventory():add_item('main', 'default:leaves 6')
end


-- check inventory (needs to match the given items above)
skyblock.check_inventory = function(player)
	skyblock.log("check_inventory() for "..player:get_player_name())
	local inv = player:get_inventory()
	local stack
	if inv==nil then return false end
	
	stack = inv:get_stack('main', 1)
	if stack:get_name() ~= 'default:stick' or stack:get_count() ~= 1 then
		return false
	end
	stack = inv:get_stack('main', 2)
	if stack:get_name() ~= 'default:leaves' or stack:get_count() ~= 6 then
		return false
	end
	for i=3,inv:get_size("main") do
		stack = inv:get_stack('main', i)
		if stack:get_name() ~= "" then
			return false
		end
	end
	for i=1,inv:get_size("craft") do
		stack = inv:get_stack('craft', i)
		if stack:get_name() ~= "" then
			return false
		end
	end
	
	return true
end


-- empty inventory
skyblock.empty_inventory = function(player)
	skyblock.log("empty_inventory() from "..player:get_player_name())
	local inv = player:get_inventory()
	if not inv:is_empty("main") then
		for i=1,inv:get_size("main") do
			inv:set_stack("main", i, nil)
		end
	end
	if not inv:is_empty("craft") then
		for i=1,inv:get_size("craft") do
			inv:set_stack("craft", i, nil)
		end
	end
end


-- check if a player has a spawn position assigned, if so return it
skyblock.has_spawn = function(player_name)
	local spawn = spawnpos[player_name]
	skyblock.log("has_spawn() for "..player_name.." is "..dump(spawn))
	if spawn then
		return spawn
	end
end


-- get players spawn position
skyblock.get_spawn = function(player_name)
	local spawn = spawnpos[player_name]
	if spawn and minetest.env:get_node(spawn).name == "skyblock:level_1" then
		skyblock.log("get_spawn() for "..player_name.." is "..dump(spawn))
		return spawn
	end
	skyblock.log("get_spawn() for "..player_name.." is unknown")
end


-- set players spawn position
skyblock.set_spawn = function(player_name, pos)
	skyblock.log("set_spawn() for "..player_name.." at "..dump(pos))
	spawnpos[player_name] = pos
	-- save the spawn data from the table to the file
	local output = io.open(skyblock.FILENAME..".spawn", "w")
	for i, v in pairs(spawnpos) do
		if v ~= nil then
			output:write(v.x.." "..v.y.." "..v.z.." "..i.."\n")
		end
	end
	io.close(output)
end


-- get next spawn position
skyblock.get_next_spawn = function()
	skyblock.log("get_next_spawn()")
	last_start_id = last_start_id+1
	local output = io.open(skyblock.FILENAME..".last_start_id", "w")
	output:write(last_start_id)
	io.close(output)
	local spawn = start_positions[last_start_id]
	if spawn == nil then
		print("MAJOR ERROR - no spawn position at id="..last_start_id)
	end
	return spawn
end


-- handle player spawn setup
skyblock.spawn_player = function(player)
	local player_name = player:get_player_name()
	skyblock.log("spawn_player() "..player_name)
	
	-- find the player spawn point
	local spawn = skyblock.has_spawn(player_name)
	if spawn == nil then
		spawn = skyblock.get_next_spawn()
		skyblock.set_spawn(player_name,spawn)
	end
	
	-- already has a spawn, teleport and return true 
	if minetest.env:get_node(spawn).name == "skyblock:level_1" then
		player:setpos({x=spawn.x,y=spawn.y+skyblock.SPAWN_HEIGHT,z=spawn.z})
		player:set_hp(20)
		return true
	end

	-- add the start block and teleport the player
	skyblock.make_spawn_blocks(spawn,player_name)
	player:setpos({x=spawn.x,y=spawn.y+skyblock.SPAWN_HEIGHT,z=spawn.z})
	player:set_hp(20)
end


-- on_respawn
skyblock.spawn_diggers = {}
skyblock.on_respawnplayer = function(player)
	local player_name = player:get_player_name()
	local spawn = skyblock.get_spawn(player_name)
	skyblock.log("on_respawnplayer() for "..player_name)

	-- empty inventory
	skyblock.empty_inventory(player)
	
	-- reset achievements
	if achievements ~= nil then
		achievements.reset(player_name)
	end
	
	-- give them a new position
	if skyblock.spawn_diggers[player_name] ~= nil then
		skyblock.spawn_diggers[player_name] = nil
		
		-- give inventory
		skyblock.give_inventory(player)

		if skyblock.DIG_NEW_SPAWN then
			-- unset old spawn position
			spawned_players[player_name] = nil
			skyblock.set_spawn(player_name, nil)
			skyblock.set_spawn(player_name.."_DEAD", spawn)
		else
			-- rebuild spawn blocks
			skyblock.make_spawn_blocks(spawn,player_name)
		end
		
	end
	
	-- respawn player
	skyblock.spawn_player(player)
	return true
end


-- globalstep for positioning
local spawn_timer = 0
skyblock.globalstep = function(dtime)
	spawn_timer = spawn_timer + dtime
	for k,player in ipairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		
		-- player has not spawned yet
		if spawned_players[player_name] == nil then

			-- handle new player spawn setup (no more than once per interval)
			if spawn_timer > skyblock.SPAWN_THROTLE then
				skyblock.log("globalstep() new spawn for "..player_name.." (not spawned)")
				if skyblock.get_spawn(player:get_player_name()) or skyblock.spawn_player(player) then
					spawned_players[player:get_player_name()] = true
				end
			end

		-- player is spawned
		else
			local pos = player:getpos()

			-- only check once per throttle time
			if spawn_timer > skyblock.SPAWN_THROTLE then
			
				-- hit the bottom
				if pos.y < skyblock.WORLD_BOTTOM then
					if skyblock.check_inventory(player) then
						-- respawn them
						skyblock.log("globalstep() "..player_name.." has fallen too far, but dont kill them... yet =)")
						local spawn = skyblock.has_spawn(player:get_player_name())
						if spawn then
							skyblock.make_spawn_blocks(spawn,player:get_player_name())
							skyblock.spawn_player(player)
						end
					else
						-- kill them
						skyblock.log("globalstep() "..player_name.." has fallen too far at "..dump(pos).."... kill them now")
						player:set_hp(0)
					end
				end
				
			end
			
			-- walking on dirt_with_grass, change to dirt_with_grass_footsteps
			local np = {x=pos.x,y=pos.y-1,z=pos.z}
			if (minetest.env:get_node(np).name == "default:dirt_with_grass") then
				minetest.env:add_node(np, {name="default:dirt_with_grass_footsteps"})
			end
			
		end
		
	end
	
	-- reset the spawn_timer
	if spawn_timer > skyblock.SPAWN_THROTLE then	
		spawn_timer = 0
	end
end


-- prevent lava bucket too far from spawn
skyblock.bucket_lava_on_use = function(itemstack, user, pointed_thing)
	-- Must be pointing to node
	if pointed_thing.type ~= "node" then
		return
	end
	-- Check if pointing to a liquid
	n = minetest.env:get_node(pointed_thing.under)
	if bucket.liquids[n.name] == nil then
		-- Not a liquid

		-- begin anti-grief change
		local player_name = user:get_player_name()
		local spawn = skyblock.has_spawn(player_name)
		local range = skyblock.START_GAP/3 -- how far from spawn you can use lava
		local pos = pointed_thing.under
		if spawn==nil or (pos.x-spawn.x > range or pos.x-spawn.x < range*-1) or (pos.z-spawn.z > range or pos.z-spawn.z < range*-1) then
			--if (pos.y-spawn.y > range/2 or pos.y-spawn.y < range*-1/2) then
				minetest.chat_send_player(player_name, "Cannot use bucket so far from your home.")
				return
			--end
		end
		-- end anti-grief change

		minetest.env:add_node(pointed_thing.above, {name="default:lava_source"})
	elseif n.name ~= "default:lava_source" then
		-- It's a liquid
		minetest.env:add_node(pointed_thing.under, {name="default:lava_source"})
	end

	-- begin track bucket achievements
	achievements.bucket_lava_on_use(itemstack, user, pointed_thing)
	-- end track bucket achievements

	return {name="bucket:bucket_empty"}
end


-- handle bucket_water usage
skyblock.bucket_water_on_use = function(itemstack, user, pointed_thing)
	-- Must be pointing to node
	if pointed_thing.type ~= "node" then
		return
	end
	-- Check if pointing to a liquid
	n = minetest.env:get_node(pointed_thing.under)
	if bucket.liquids[n.name] == nil then
		-- Not a liquid

		-- begin anti-grief change
		local player_name = user:get_player_name()
		local spawn = skyblock.has_spawn(player_name)
		local range = skyblock.START_GAP/3 -- how far from spawn you can use water
		local pos = pointed_thing.under
		if spawn==nil or (pos.x-spawn.x > range or pos.x-spawn.x < range*-1) or (pos.y-spawn.y > range/2 or pos.y-spawn.y < range*-1/2) or (pos.z-spawn.z > range or pos.z-spawn.z < range*-1) then
			minetest.chat_send_player(player_name, "Cannot use bucket so far from your home.")
			return
		end
		-- end anti-grief change

		minetest.env:add_node(pointed_thing.above, {name="default:water_source"})
	elseif n.name ~= "default:water_source" then
		-- It's a liquid
		minetest.env:add_node(pointed_thing.under, {name="default:water_source"})
	end

	-- begin track bucket achievements
	achievements.bucket_water_on_use(itemstack, user, pointed_thing)
	-- end track bucket achievements

	return {name="bucket:bucket_empty"}
end


-- handle bucket usage
skyblock.bucket_on_use = function(itemstack, user, pointed_thing)
	-- Must be pointing to node
	if pointed_thing.type ~= "node" then
		return
	end
	-- Check if pointing to a liquid source
	n = minetest.env:get_node(pointed_thing.under)
	liquiddef = bucket.liquids[n.name]
	if liquiddef ~= nil and liquiddef.source == n.name and liquiddef.itemname ~= nil then
		
		-- begin track bucket achievements
		achievements.bucket_on_use(itemstack, user, pointed_thing)
		-- end track bucket achievements
	
		minetest.env:add_node(pointed_thing.under, {name="air"})
		return {name=liquiddef.itemname}
	end
end


-- build spawn block
skyblock.make_spawn_blocks = function(pos, player_name)
	skyblock.log("make_spawn_blocks() at "..dump(pos).." for "..player_name)
	levels[1].make_start_blocks(pos, player_name)
end


-- make a tree (based on rubber tree in farming by PilzAdam)
skyblock.generate_tree = function(pos)
	skyblock.log("generate_tree() at "..dump(pos))
	
	-- check if we have space to make a tree
	for dy=1,4 do
		pos.y = pos.y+dy
		if minetest.env:get_node(pos).name ~= "air" then
			return
		end
		pos.y = pos.y-dy
	end
	
	local node = {name = ""}

	-- check if we should make an apple tree
	local is_apple_tree, is_jungle_tree, is_pine_tree = false, false, false
	if math.random(0, 8) == 0 then
		is_apple_tree = true
	else
		if math.random(0, 8) <  7 then
			if( not( minetest.registered_nodes['default:pinetree']) or math.random(1,2)==1 ) then
				is_jungle_tree = true
			else
				is_pine_tree = true
			end
		end
	end
	
	-- add the tree
	if is_jungle_tree then
		node.name = "default:jungletree"
	elseif is_pine_tree then
		node.name = "default:pinetree"
	else
		node.name = "default:tree"
	end
	for dy=0,4 do
		pos.y = pos.y+dy
		minetest.env:set_node(pos, node)
		pos.y = pos.y-dy
	end

	-- add leaves all around the tree
	pos.y = pos.y+3
	for dx=-2,2 do
		for dz=-2,2 do
			for dy=0,3 do
				pos.x = pos.x+dx
				pos.y = pos.y+dy
				pos.z = pos.z+dz

				-- check if we should add leaves or an apple
				if is_apple_tree and math.random(0, 6) == 0 then
					node.name = "default:apple"
				else
					node.name = "default:leaves"
				end
				
				-- add the leaves
				if dx == 0 and dz == 0 and dy==3 then
					if minetest.env:get_node(pos).name == "air" and math.random(1, 5) <= 4 then
						minetest.env:set_node(pos, node)
					end
				elseif dx == 0 and dz == 0 and dy==4 then
					if minetest.env:get_node(pos).name == "air" and math.random(1, 5) <= 4 then
						minetest.env:set_node(pos, node)
					end
				elseif math.abs(dx) ~= 2 and math.abs(dz) ~= 2 then
					if minetest.env:get_node(pos).name == "air" then
						minetest.env:set_node(pos, node)
					end
				else
					if math.abs(dx) ~= 2 or math.abs(dz) ~= 2 then
						if minetest.env:get_node(pos).name == "air" and math.random(1, 5) <= 4 then
							minetest.env:set_node(pos, node)
						end
					end
				end

				pos.x = pos.x-dx
				pos.y = pos.y-dy
				pos.z = pos.z-dz
			end
		end
	end
end


-- hollow sphere (based on sphere in multinode by mauvebic)
skyblock.make_sphere =  function(pos,radius,nodename,hollow)
	pos.x = math.floor(pos.x+0.5)
	pos.y = math.floor(pos.y+0.5)
	pos.z = math.floor(pos.z+0.5)
	for x=-radius,radius do
	for y=-radius,radius do
	for z=-radius,radius do
		if hollow ~= nil then
			if x*x+y*y+z*z >= (radius-hollow) * (radius-hollow) + (radius-hollow) and x*x+y*y+z*z <= radius * radius + radius then
				minetest.env:add_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name=nodename})
			end
		else
			if x*x+y*y+z*z <= radius * radius + radius then
				minetest.env:add_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name=nodename})
			end
		end
	end
	end
	end
end


--
-- LOCAL FUNCTIONS
--


-- spiral matrix
-- http://rosettacode.org/wiki/Spiral_matrix#Lua
av, sn = math.abs, function(s) return s~=0 and s/av(s) or 0 end
local function sindex(y, x) -- returns the value at (x, y) in a spiral that starts at 1 and goes outwards
	if y == -x and y >= x then return (2*y+1)^2 end
	local l = math.max(av(y), av(x))
	return (2*l-1)^2+4*l+2*l*sn(x+y)+sn(y^2-x^2)*(l-(av(y)==l and sn(y)*x or sn(x)*y)) -- OH GOD WHAT
end
local function spiralt(side)
	local ret, id, start, stop = {}, 0, math.floor((-side+1)/2), math.floor((side-1)/2)
	for i = 1, side do
		for j = 1, side do
			local id = side^2 - sindex(stop - i + 1,start + j - 1)
			ret[id] = {x=i,z=j}
		end
	end
	return ret
end


-- reverse ipairs
function ripairs(t)
	local function ripairs_it(t,i)
		i=i-1
		local v=t[i]
		if v==nil then return v end
		return i,v
	end
	return ripairs_it, t, #t+1
end

 

--
-- INIT FUNCTIONS
--


-- load the spawn data from disk
local load_spawn = function()
    local input = io.open(skyblock.FILENAME..".spawn", "r")
    if input then
        while true do
            local x = input:read("*n")
            if x == nil then
                break
            end
            local y = input:read("*n")
            local z = input:read("*n")
            local name = input:read("*l")
            spawnpos[name:sub(2)] = {x = x, y = y, z = z}
        end
        io.close(input)
    else
        spawnpos = {}
    end
end
load_spawn() -- run it now


-- load the start positions from disk
local load_start_positions = function()
    local input = io.open(skyblock.FILENAME..".start_positions", "r")

	-- create start_positions file if needed
    if not input then
		local output = io.open(skyblock.FILENAME..".start_positions", "w")
		local pos
		for i,v in ripairs(spiralt(skyblock.WORLD_WIDTH)) do -- get positions using spiral
			pos = {x=v.x*skyblock.START_GAP, y=skyblock.START_HEIGHT, z=v.z*skyblock.START_GAP}
			output:write(pos.x.." "..pos.y.." "..pos.z.."\n")
		end
		io.close(output)
		input = io.open(skyblock.FILENAME..".start_positions", "r")
	end
	
	-- read start positions
	while true do
		local x = input:read("*n")
		if x == nil then
			break
		end
		local y = input:read("*n")
		local z = input:read("*n")
		table.insert(start_positions,{x = x, y = y, z = z})
	end
	io.close(input)
	
end
load_start_positions() -- run it now


-- load the last start position from disk
local load_last_start_id = function()
	local input = io.open(skyblock.FILENAME..".last_start_id", "r")
	
	-- create last_start_id file if needed
    if not input then
		local output = io.open(skyblock.FILENAME..".last_start_id", "w")
		output:write(last_start_id)
		io.close(output)
		input = io.open(skyblock.FILENAME..".last_start_id", "r")
	end
	
	-- read last start id
	last_start_id = input:read("*n")
	if last_start_id == nil then
		last_start_id = 0
	end
	io.close(input)
	
end
load_last_start_id() -- run it now


-- registered
skyblock.registered = function(case,name)
	local params = {}
	local list
	if case == "item" then list = minetest.registered_items end
	if case == "node" then list = minetest.registered_nodes end
	if case == "craftitem" then list = minetest.registered_craftitems end
	if case == "tool" then list = minetest.registered_tools end
	if case == "entity" then list = minetest.registered_entities end
	if list then
		for k,v in pairs(list[name]) do
			params[k] = v
		end
	end
	return params
end

