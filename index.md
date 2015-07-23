---
layout: default
header_include: index
---

## Levels and Missions

There are 3 levels included.  You can also make your own levels using the achievements api.

<div class="row">
    <div class="col-md-6">
        <h3>Level 1</h3>
        <p>
        <strong>Welcome Traveller</strong><br/>
        <i>Complete the tasks to the right to receive great rewards!  If you wasted the required items you can dig this node to restart.</i>
        <p>

        <ol>
        <li>grow a Tree</li>
        <li>dig a Tree</li>
        <li>craft and place a Chest</li>
        <li>collect the Lave Source under your Spawn</li>
        <li>build a Stone Generator and dig 20 Cobble</li>
        <li>craft and place a Furnace</li>
        <li>dig 4 Coal Lumps</li>
        <li>extend your Island with 100 Dirt</li>
        <li>dig 100 Stone with a Mese Pickaxe</li>
        <li>create an Infinite Water Source</li>
        </ol>
    </div>
    <div class="col-md-6">
    <a href="https://cloud.githubusercontent.com/assets/51875/8765583/014410c8-2e13-11e5-8423-b44a778d16d2.png" class="fancybox" rel="levels"><img src="https://cloud.githubusercontent.com/assets/51875/8765583/014410c8-2e13-11e5-8423-b44a778d16d2.png" alt="Level 1" class="thumbnail"></a>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <h3>Level 2</h3>
        <p>
        <strong>A View From Above</strong><br/>
        <i>Wow, look at that view... of... nothing. You should get to work extending this island.  Perhaps you could build some structures too?</i>
        <p>

        <ol>
        <li>extend your Island with 200 Dirt</li>
        <li>build a structure using 200 Wood</li>
        <li>build a structure using 200 Brick</li>
        <li>add at least 200 Glass windows</li>
        <li>make a desert with 200 Sand</li>
        <li>also include 200 Desert Sand</li>
        <li>build a tower with 200 Stone</li>
        <li>make a path with 200 Cobblestone</li>
        <li>also use 200 Mossy Cobblestone</li>
        <li>decorate your area with 75 Steel Blocks</li>
        </ol>
    </div>
    <div class="col-md-6">
    <a href="https://cloud.githubusercontent.com/assets/51875/8765581/fa202e26-2e12-11e5-8935-2632e97ec2a3.png" class="fancybox" rel="levels"><img src="https://cloud.githubusercontent.com/assets/51875/8765581/fa202e26-2e12-11e5-8935-2632e97ec2a3.png" alt="Level 2" class="thumbnail"></a>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <h3>Level 3</h3>
        <p>
        <strong>Does This Keep Going?</strong><br/>
        <i>If you like this planet, then stray not from your mission traveller, for the end is near.</i>
        <p>

        <ol>
        <li>dig 20 Papyrus</li>
        <li>place 20 Papyrus in a nice garden</li>
        <li>dig 15 Cactus</li>
        <li>place 15 Cactus in another gargen</li>
        <li>place 30 fences around your gardens</li>
        <li>add 20 ladders to your structures</li>
        <li>decorate your house with 5 Bookshelves</li>
        <li>place 10 Signs to help other travellers</li>
        <li>place 50 Torches to help you see at night</li>
        <li>dig 500 Stone for your next project...</li>
        </ol>
    </div>
    <div class="col-md-6">
    <a href="https://cloud.githubusercontent.com/assets/51875/8765581/fa202e26-2e12-11e5-8935-2632e97ec2a3.png" class="fancybox" rel="levels"><img src="https://cloud.githubusercontent.com/assets/51875/8765581/fa202e26-2e12-11e5-8935-2632e97ec2a3.png" alt="Level 3" class="thumbnail"></a>
    </div>
</div>


## Screenshots

<div class="row thumbnails">
    {% for screenshot in site.data.screenshots limit:4 %}
    <div class="col-md-3">
        <h3>{{screenshot.name}}</h3>
        <div class="thumbnail">
            <a href="{{screenshot.url}}" class="fancybox" rel="screenshots"><img src="{{screenshot.url}}" alt="{{screenshot.name}}"></a>
        </div>
    </div>
    {% endfor %}
</div>

More images are available from the [Screenshots](https://cornernote.github.io/minetest-skyblock/screenshots/) page.

