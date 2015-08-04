--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

-- expose functions to other modules
skyblock = {}


--
-- CONFIG OPTIONS
--

-- Debug mode
skyblock.debug = minetest.setting_getbool('skyblock.debug')

-- How far apart to set players start positions
skyblock.start_gap = minetest.setting_get('skyblock.start_gap') or 32

-- The Y position the spawn nodes will appear
skyblock.start_height = minetest.setting_get('skyblock.start_height') or 4

-- How many players will be in 1 row
-- skyblock.world_width * skyblock.world_width = total players
skyblock.world_width = minetest.setting_get('skyblock.world_width') or 100

-- How far down (in nodes) before a player dies and is respawned
skyblock.world_bottom = minetest.setting_get('skyblock.world_bottom') or -8

-- File path and prefix for data files
skyblock.filename = minetest.get_worldpath()..'/'..(minetest.setting_get('skyblock.filename') or 'skyblock')

-- local variables
local last_start_id = 0
local start_positions = {}
local spawnpos = {}


--
-- PUBLIC FUNCTIONS
--

-- log
function skyblock.log(message)
	if not skyblock.debug then
		return
	end
	minetest.log('action', '[skyblock] '..message)
end

-- dump_pos
function skyblock.dump_pos(pos)
	if pos==nil then return 'nil' end
	return '{x='..pos.x..',y='..pos.x..',z='..pos.z..'}'
end

-- registered
function skyblock.registered(case,name)
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

-- get players spawn position
function skyblock.get_spawn(player_name)
	local spawn = spawnpos[player_name]
	if spawn then
		skyblock.log('get_spawn() for '..player_name..' is '..skyblock.dump_pos(spawn))
		return spawn
	end
	skyblock.log('get_spawn() for '..player_name..' is unknown')
end

-- set players spawn position
function skyblock.set_spawn(player_name, pos)
	skyblock.log('set_spawn() for '..player_name..' at '..skyblock.dump_pos(pos))
	spawnpos[player_name] = pos
	-- save the spawn data from the table to the file
	local output = io.open(skyblock.filename..'.spawn', 'w')
	for i, v in pairs(spawnpos) do
		if v ~= nil then
			output:write(v.x..' '..v.y..' '..v.z..' '..i..'\n')
		end
	end
	io.close(output)
end

-- get next spawn position
function skyblock.get_next_spawn()
	skyblock.log('get_next_spawn()')
	last_start_id = last_start_id+1
	local output = io.open(skyblock.filename..'.last_start_id', 'w')
	output:write(last_start_id)
	io.close(output)
	local spawn = start_positions[last_start_id]
	if spawn == nil then
		print('MAJOR ERROR - no spawn position at id='..last_start_id)
	end
	return spawn
end

-- handle player spawn setup
function skyblock.spawn_player(player)
	local player_name = player:get_player_name()
	skyblock.log('spawn_player() '..player_name)
	
	-- find the player spawn point
	local spawn = skyblock.get_spawn(player_name)
	if spawn == nil then
		spawn = skyblock.get_next_spawn()
		skyblock.set_spawn(player_name,spawn)
	end
	
	-- already has a spawn, teleport and return true 
	if minetest.env:get_node(spawn).name == 'skyblock:quest' then
		player:setpos({x=spawn.x,y=spawn.y+8,z=spawn.z})
		player:set_hp(20)
		return true
	end

	-- add the start block and teleport the player
	skyblock.make_spawn_blocks(spawn,player_name)
	player:setpos({x=spawn.x,y=spawn.y+8,z=spawn.z})
	player:set_hp(20)
end

-- build spawn block
function skyblock.make_spawn_blocks(pos, player_name)
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
local function load_spawn()
    local input = io.open(skyblock.filename..'.spawn', 'r')
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
local function load_start_positions()
	skyblock.log('BEGIN load_start_positions()')
    local input = io.open(skyblock.filename..'.start_positions', 'r')

	-- create start_positions file if needed
    if not input then
		skyblock.log('generate start positions')
		local output = io.open(skyblock.filename..'.start_positions', 'w')
		local pos
		for i,v in ripairs(spiralt(skyblock.world_width)) do -- get positions using spiral
			pos = {x=v.x*skyblock.start_gap, y=skyblock.start_height, z=v.z*skyblock.start_gap}
			output:write(pos.x..' '..pos.y..' '..pos.z..'\n')
		end
		io.close(output)
		input = io.open(skyblock.filename..'.start_positions', 'r')
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
local function load_last_start_id()
	local input = io.open(skyblock.filename..'.last_start_id', 'r')
	
	-- create last_start_id file if needed
    if not input then
		local output = io.open(skyblock.filename..'.last_start_id', 'w')
		output:write(last_start_id)
		io.close(output)
		input = io.open(skyblock.filename..'.last_start_id', 'r')
	end
	
	-- read last start id
	last_start_id = input:read('*n')
	if last_start_id == nil then
		last_start_id = 0
	end
	io.close(input)
	
end
load_last_start_id() -- run it now
