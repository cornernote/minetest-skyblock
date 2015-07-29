--
-- level shapes
--

skyblock.worldedit = {}


-- hollow sphere (based on sphere in multinode by mauvebic)
skyblock.worldedit.sphere =  function(pos,radius,nodename,hollow)
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




-- @see https://github.com/Uberi/Minetest-WorldEdit/blob/master/worldedit/common.lua
-- @see https://github.com/Uberi/Minetest-WorldEdit/blob/master/LICENSE.txt
local mh = {}
skyblock.worldedit.manip_helpers = mh


--- Generates an empty VoxelManip data table for an area.
-- @return The empty data table.
function mh.get_empty_data(area)
	-- Fill emerged area with ignore so that blocks in the area that are
	-- only partially modified aren't overwriten.
	local data = {}
	local c_ignore = minetest.get_content_id("ignore")
	for i = 1, skyblock.worldedit.volume(area.MinEdge, area.MaxEdge) do
		data[i] = c_ignore
	end
	return data
end


function mh.init(pos1, pos2)
	local manip = minetest.get_voxel_manip()
	local emerged_pos1, emerged_pos2 = manip:read_from_map(pos1, pos2)
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
	return manip, area
end


function mh.init_radius(pos, radius)
	local pos1 = vector.subtract(pos, radius)
	local pos2 = vector.add(pos, radius)
	return mh.init(pos1, pos2)
end


function mh.init_axis_radius(base_pos, axis, radius)
	return mh.init_axis_radius_length(base_pos, axis, radius, radius)
end


function mh.init_axis_radius_length(base_pos, axis, radius, length)
	local other1, other2 = skyblock.worldedit.get_axis_others(axis)
	local pos1 = {
		[axis]   = base_pos[axis],
		[other1] = base_pos[other1] - radius,
		[other2] = base_pos[other2] - radius
	}
	local pos2 = {
		[axis]   = base_pos[axis] + length,
		[other1] = base_pos[other1] + radius,
		[other2] = base_pos[other2] + radius
	}
	return mh.init(pos1, pos2)
end


function mh.finish(manip, data)
	-- Update map
	manip:set_data(data)
	manip:write_to_map()
	manip:update_map()
end

--- Copies and modifies positions `pos1` and `pos2` so that each component of
-- `pos1` is less than or equal to the corresponding component of `pos2`.
-- Returns the new positions.
function skyblock.worldedit.sort_pos(pos1, pos2)
	pos1 = {x=pos1.x, y=pos1.y, z=pos1.z}
	pos2 = {x=pos2.x, y=pos2.y, z=pos2.z}
	if pos1.x > pos2.x then
		pos2.x, pos1.x = pos1.x, pos2.x
	end
	if pos1.y > pos2.y then
		pos2.y, pos1.y = pos1.y, pos2.y
	end
	if pos1.z > pos2.z then
		pos2.z, pos1.z = pos1.z, pos2.z
	end
	return pos1, pos2
end


--- Determines the volume of the region defined by positions `pos1` and `pos2`.
-- @return The volume.
function skyblock.worldedit.volume(pos1, pos2)
	local pos1, pos2 = skyblock.worldedit.sort_pos(pos1, pos2)
	return (pos2.x - pos1.x + 1) *
		(pos2.y - pos1.y + 1) *
		(pos2.z - pos1.z + 1)
end

--- Gets other axes given an axis.
-- @raise Axis must be x, y, or z!
function skyblock.worldedit.get_axis_others(axis)
	if axis == "x" then
		return "y", "z"
	elseif axis == "y" then
		return "x", "z"
	elseif axis == "z" then
		return "x", "y"
	else
		error("Axis must be x, y, or z!")
	end
end


--- Adds a pyramid.
-- @see https://github.com/Uberi/Minetest-WorldEdit/blob/master/worldedit/primitives.lua
-- @see https://github.com/Uberi/Minetest-WorldEdit/blob/master/LICENSE.txt
-- @param pos Position to center base of pyramid at.
-- @param axis Axis ("x", "y", or "z")
-- @param height Pyramid height.
-- @param node_name Name of node to make pyramid of.
-- @return The number of nodes added.
skyblock.worldedit.pyramid = function(pos, axis, height, node_name)
	local other1, other2 = skyblock.worldedit.get_axis_others(axis)

	-- Set up voxel manipulator
	local manip, area = mh.init_axis_radius(pos, axis,
			height >= 0 and height or -height)
	local data = mh.get_empty_data(area)

	-- Handle inverted pyramids
	local start_axis, end_axis, step
	if height > 0 then
		height = height - 1
		step = 1
	else
		height = height + 1
		step = -1
	end

	-- Add pyramid
	local node_id = minetest.get_content_id(node_name)
	local stride = {x=1, y=area.ystride, z=area.zstride}
	local offset = {
		x = pos.x - area.MinEdge.x,
		y = pos.y - area.MinEdge.y,
		z = pos.z - area.MinEdge.z,
	}
	local size = height * step
	local count = 0
	-- For each level of the pyramid
	for index1 = 0, height, step do
		-- Offset contributed by axis plus 1 to make it 1-indexed
		local new_index1 = (index1 + offset[axis]) * stride[axis] + 1
		for index2 = -size, size do
			local new_index2 = new_index1 + (index2 + offset[other1]) * stride[other1]
			for index3 = -size, size do
				local i = new_index2 + (index3 + offset[other2]) * stride[other2]
				data[i] = node_id
			end
		end
		count = count + (size * 2 + 1) ^ 2
		size = size - 1
	end

	mh.finish(manip, data)

	return count
end


