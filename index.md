---
layout: default
header_include: index
---

## Levels and Quests

Skyblock is a Minetest game where the world is mostly empty at first except for a small island starting in the sky.

You start out standing on the island. Your rank is Level One. There are 10 quests, or missions, to complete. When a quest is achieved, you get a reward. When all 10 quests are achieved, you are promoted to Level 2 and given new quests with new rewards.

Finish the Level 2 quests, and there is a Level 3. Finish Level 3 and you have completed the world and graduate as a Skyblock Master, and will be granted `FLY` and `FAST` privileges.

This is a Minetest "mod". It works both in single player and in server mode. In server mode, each player is assigned to their own starting island.


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

