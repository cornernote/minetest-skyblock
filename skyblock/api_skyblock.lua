--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
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
	minetest.log('action', '[skyblock] '..message)
end

-- dump_pos
skyblock.dump_pos = function(pos)
	if pos==nil then return 'nil' end
	return '{x='..pos.x..',y='..pos.x..',z='..pos.z..'}'
end

-- check if a player has a spawn position assigned, if so return it
skyblock.has_spawn = function(player_name)
	local spawn = spawnpos[player_name]
	skyblock.log('has_spawn() for '..player_name..' is '..skyblock.dump_pos(spawn))
	if spawn then
		return spawn
	end
end

-- get players spawn position
skyblock.get_spawn = function(player_name)
	local spawn = spawnpos[player_name]
	if spawn then
		skyblock.log('get_spawn() for '..player_name..' is '..skyblock.dump_pos(spawn))
		return spawn
	end
	skyblock.log('get_spawn() for '..player_name..' is unknown')
end

-- set players spawn position
skyblock.set_spawn = function(player_name, pos)
	skyblock.log('set_spawn() for '..player_name..' at '..skyblock.dump_pos(pos))
	spawnpos[player_name] = pos
	-- save the spawn data from the table to the file
	local output = io.open(skyblock.FILENAME..'.spawn', 'w')
	for i, v in pairs(spawnpos) do
		if v ~= nil then
			output:write(v.x..' '..v.y..' '..v.z..' '..i..'\n')
		end
	end
	io.close(output)
end

-- get next spawn position
skyblock.get_next_spawn = function()
	skyblock.log('get_next_spawn()')
	last_start_id = last_start_id+1
	local output = io.open(skyblock.FILENAME..'.last_start_id', 'w')
	output:write(last_start_id)
	io.close(output)
	local spawn = start_positions[last_start_id]
	if spawn == nil then
		print('MAJOR ERROR - no spawn position at id='..last_start_id)
	end
	return spawn
end

-- handle player spawn setup
skyblock.spawn_player = function(player)
	local player_name = player:get_player_name()
	skyblock.log('spawn_player() '..player_name)
	
	-- find the player spawn point
	local spawn = skyblock.has_spawn(player_name)
	if spawn == nil then
		spawn = skyblock.get_next_spawn()
		skyblock.set_spawn(player_name,spawn)
	end
	
	-- already has a spawn, teleport and return true 
	if minetest.env:get_node(spawn).name == 'skyblock:quest' then
		player:setpos({x=spawn.x,y=spawn.y+skyblock.SPAWN_HEIGHT,z=spawn.z})
		player:set_hp(20)
		return true
	end

	-- add the start block and teleport the player
	skyblock.make_spawn_blocks(spawn,player_name)
	player:setpos({x=spawn.x,y=spawn.y+skyblock.SPAWN_HEIGHT,z=spawn.z})
	player:set_hp(20)
end

-- globalstep
local spawn_timer = 0
skyblock.globalstep = function(dtime)
	spawn_timer = spawn_timer + dtime
	for k,player in ipairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		
		-- player has not spawned yet
		if spawned_players[player_name] == nil then

			-- handle new player spawn setup (no more than once per interval)
			if spawn_timer > skyblock.SPAWN_THROTLE then
				skyblock.log('globalstep() new spawn for '..player_name..' (not spawned)')
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
					local spawn = skyblock.get_spawn(player_name)
					if minetest.env:get_node(spawn).name ~= "skyblock:quest" then
						-- no spawn block, respawn them
						skyblock.log("globalstep() "..player_name.." has fallen too far, but dont kill them... yet =)")
						local spawn = skyblock.has_spawn(player:get_player_name())
						if spawn then
							skyblock.make_spawn_blocks(spawn,player:get_player_name())
							skyblock.spawn_player(player)
						end
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
	if spawn_timer > skyblock.SPAWN_THROTLE then	
		spawn_timer = 0
	end
end


-- build spawn block
skyblock.make_spawn_blocks = function(pos, player_name)
	for x=-1,1 do
		for z=-1,1 do
			minetest.env:add_node({x=pos.x+x,y=pos.y,z=pos.z+z}, {name='default:dirt'})
			minetest.env:add_node({x=pos.x+x,y=pos.y-1,z=pos.z+z}, {name='default:dirt'})
			minetest.env:add_node({x=pos.x+x,y=pos.y-2,z=pos.z+z}, {name='default:dirt'})
		end
	end
	minetest.env:add_node(pos, {name='skyblock:quest'})
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
local function ripairs(t)
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
    local input = io.open(skyblock.FILENAME..'.spawn', 'r')
    if input then
        while true do
            local x = input:read('*n')
            if x == nil then
                break
            end
            local y = input:read('*n')
            local z = input:read('*n')
            local name = input:read('*l')
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
	skyblock.log('BEGIN load_start_positions()')
    local input = io.open(skyblock.FILENAME..'.start_positions', 'r')

	-- create start_positions file if needed
    if not input then
		skyblock.log('generate start positions')
		local output = io.open(skyblock.FILENAME..'.start_positions', 'w')
		local pos
		for i,v in ripairs(spiralt(skyblock.WORLD_WIDTH)) do -- get positions using spiral
			pos = {x=v.x*skyblock.START_GAP, y=skyblock.START_HEIGHT, z=v.z*skyblock.START_GAP}
			output:write(pos.x..' '..pos.y..' '..pos.z..'\n')
		end
		io.close(output)
		input = io.open(skyblock.FILENAME..'.start_positions', 'r')
	end
	
	-- read start positions
	skyblock.log('read start positions')
	while true do
		local x = input:read('*n')
		if x == nil then
			break
		end
		local y = input:read('*n')
		local z = input:read('*n')
		table.insert(start_positions,{x = x, y = y, z = z})
	end
	io.close(input)
	
	skyblock.log('END load_start_positions()')
end
load_start_positions() -- run it now


-- load the last start position from disk
local load_last_start_id = function()
	local input = io.open(skyblock.FILENAME..'.last_start_id', 'r')
	
	-- create last_start_id file if needed
    if not input then
		local output = io.open(skyblock.FILENAME..'.last_start_id', 'w')
		output:write(last_start_id)
		io.close(output)
		input = io.open(skyblock.FILENAME..'.last_start_id', 'r')
	end
	
	-- read last start id
	last_start_id = input:read('*n')
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
	if case == 'item' then list = minetest.registered_items end
	if case == 'node' then list = minetest.registered_nodes end
	if case == 'craftitem' then list = minetest.registered_craftitems end
	if case == 'tool' then list = minetest.registered_tools end
	if case == 'entity' then list = minetest.registered_entities end
	if list then
		for k,v in pairs(list[name]) do
			params[k] = v
		end
	end
	return params
end

