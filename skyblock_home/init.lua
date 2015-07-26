--[[

Home GUI for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-home_gui
License: BSD-3-Clause https://raw.github.com/cornernote/minetest-home_gui/master/LICENSE

]]--

-- local api
local home_gui = {}

-- filename
home_gui.filename = minetest.get_worldpath()..'/skyblock.home'

-- load_home
local homepos = {}
local load_home = function()
    local input = io.open(home_gui.filename..".home", "r")
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
home_gui.set_home = function(player, pos)
	homepos[player:get_player_name()] = pos
	-- save the home data from the table to the file
	local output = io.open(home_gui.filename..".home", "w")
	for k, v in pairs(homepos) do
		if v ~= nil then
			output:write(math.floor(v.x).." "..math.floor(v.y).." "..math.floor(v.z).." "..k.."\n")
		end
	end
	io.close(output)
end

-- go_home 
home_gui.go_home = function(player)
	local pos = homepos[player:get_player_name()]
	if pos~=nil then
		player:setpos(pos)
	end
end

-- register_on_player_receive_fields
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.home_gui_set then
		home_gui.set_home(player, player:getpos())
	end
	if fields.home_gui_go then
		home_gui.go_home(player)
	end
end)

-- log that we started
minetest.log("action", "[MOD]"..minetest.get_current_modname().." -- loaded from "..minetest.get_modpath(minetest.get_current_modname()))
