unused_args = false
allow_defined_top = true
max_line_length = 999

globals = {
    "skyblock", "minetest",
}

read_globals = {
    string = {fields = {"split", "trim"}},
    table = {fields = {"copy", "getn"}},

    "VoxelArea", "unified_inventory",
    "core", "ItemStack", "default",

    "bucket",
}

files["skyblock/register_misc.lua"].ignore = { "vm", "area", "data" }
files["skyblock/skyblock.lua"].ignore = { "filename", "t" }
