----------------------------------
SKYBLOCK FOR MINETEST
----------------------------------

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
Home Page: https://sites.google.com/site/cornernote/minetest/sky-block

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


----------------------------------
DESCRIPTION
----------------------------------

Build a world starting from a small island in the sky. This Minetest mod is intended to be used as a minimal game that allows the player to craft and use all the default items in Minetest in a fun and challenging way.

* WARNING * - this mod will disable all map generation in any world the mod is active!

Because of this, some things have to be different:
- death results in losing all your items
- falling below skyblock.WORLD_BOTTOM results in death
- flowing lava and water collide to make stone
- crafts to allow access to all items
- prevent chopping down trees with bare hands
- abms to control spawning and growing nodes


----------------------------------
PLAYING INSTRUCTIONS
----------------------------------


-- Level Achievement Block --

Punch (short left click) to refresh your quests.

Dig (long left click) to respawn at a new location with new items.

Open (right click) to view current quests.


-- Death Hurts --

If you fall below skyblock.WORLD_BOTTOM you will restart at a new spawn point.


-- Stone Generator --

Create stone done by placing lava and water next to each other with air between.  Stone nodes will appear between them.


-- Infinite Water --

If you want to create more water simply place your 2 water sources so they touch diagonally.  Now when you take one with the bucket, it will be replaced.


-- Crafting --

To learn all of the crafts you can visit the SkyBlock GameWiki:
http://cornernote.net/minetest/skyblock/wiki/crafts.php



----------------------------------
LEVELS AND MISSIONS
----------------------------------

There are 3 levels included.  You can also make your own levels using the achievements api.

-- LEVEL 1 - Welcome Traveller
Complete the tasks to the right to receive great rewards!  If you wasted the required items you can dig this node to restart.
1) grow a Tree
2) dig a Tree
3) craft and place a Chest
4) collect the Lave Source under your Spawn
5) build a Stone Generator and dig 20 Cobble
6) craft and place a Furnace
7) dig 4 Coal Lumps
8) extend your Island with 100 Dirt
9) dig 100 Stone with a Mese Pickaxe
10) create an Infinite Water Source

-- LEVEL 2 - A View From Above
Wow, look at that view... of... nothing. You should get to work extending this island.  Perhaps you could build some structures too?
1) extend your Island with 200 Dirt
2) build a structure using 200 Wood
3) build a structure using 200 Brick
4) add at least 200 Glass windows
5) make a desert with 200 Sand
6) also include 200 Desert Sand
7) build a tower with 200 Stone
8) make a path with 200 Cobblestone
9) also use 200 Mossy Cobblestone
10) decorate your area with 75 Steel Blocks

-- LEVEL 3 - Does This Keep Going?
If you like this planet, then stray not from your mission traveller, for the end is near.
1) dig 20 Papyrus
2) place 20 Papyrus in a nice garden
3) dig 15 Cactus
4) place 15 Cactus in another gargen
5) place 30 fences around your gardens
6) add 20 ladders to your structures
7) decorate your house with 5 Bookshelves
8) place 10 Signs to help other travellers
9) place 50 Torches to help you see at night
10) dig 500 Stone for your next project...


----------------------------------
MULTIPLAYER SUPPORT
----------------------------------

Although the default settings will work, you may want to consider the starting positions.

Each player is given a unique spawn position in an outwards spriral.

If skyblock.WORLD_WIDTH=5 then players will be assigned in the following positions:
(looking down)

x+5|  21  22  23  24  25
   |
x+4|  20  07  08  09  10
   |
x+3|  19  06  01  02  11
   |
x+2|  18  05  04  03  12
   |                      <-- The distance between the players is 
x+1|  17  16  15  14  13      defined by skyblock.START_GAP.
   +--------------------
     z+1 z+2 z+3 z+4 z+5

Note:
Your world will be limited to skyblock.WORLD_WIDTH*skyblock.WORLD_WIDTH players.


----------------------------------
OTHER OPTIONS
----------------------------------

Have a peek inside the config.lua to see other things you can change.


----------------------------------
Credits
----------------------------------

PilzAdam - code to make a tree came from farming mod
RealBadAngel - help in IRC to make the spiral
mauvebic - code to make a sphere came from multinode mod

