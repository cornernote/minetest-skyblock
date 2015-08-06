---
layout: default
header_include: index
---

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

