--[[
	
Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

skyblock.home = {}

-- filename
skyblock.home.filename = skyblock.FILENAME..'/skyblock.home'

-- load_home
local homepos = {}
local load_home = function()
    local input = io.open(skyblock.home.filename..".home", "r")
    if input then
        while true do
            local x = input:read("*n")
            if x == nil then
                break
            end
            local y = input:read("*n")
            local z = input:read("*n")
            local name = input:read("*l")
            homepos[name:sub(2)] = {x = x, y = y, z = z}
        end
        io.close(input)
    else
        homepos = {}
    end
end
load_home() -- run it now

-- set_home
skyblock.home.set_home = function(player, pos)
	homepos[player:get_player_name()] = pos
	-- save the home data from the table to the file
	local output = io.open(skyblock.home.filename..".home", "w")
	for k, v in pairs(homepos) do
		if v ~= nil then
			output:write(math.floor(v.x).." "..math.floor(v.y).." "..math.floor(v.z).." "..k.."\n")
		end
	end
	minetest.chat_send_player(player:get_player_name(), 'Your home has been set.')
	io.close(output)
end

-- go_home 
skyblock.home.go_home = function(player)
	local pos = homepos[player:get_player_name()]
	if pos~=nil then
		player:setpos(pos)
	end
end

-- on_receive_fields
skyblock.home.on_receive_fields = function(player, formname, fields)
	if fields.skyblock_home_set then
		skyblock.home.set_home(player, player:getpos())
	end
	if fields.skyblock_home_go then
		skyblock.home.go_home(player)
	end
end
minetest.register_on_player_receive_fields(skyblock.home.on_receive_fields)
