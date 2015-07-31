---
layout: default
title: Screenshots
heading: Screenshots
permalink: /screenshots/
---

<div class="row thumbnails">
    {% for screenshot in site.data.screenshots %}
    <div class="col-md-3">
        <h5>{{screenshot.name}}</h5>
        <div class="thumbnail">
            <a href="{{screenshot.url}}" class="fancybox" rel="screenshots"><img src="{{screenshot.url}}" alt="{{screenshot.name}}"></a>
        </div>
    </div>
    {% endfor %}
</div>

## Add your Screenshots

Got some awesome screenshots you want to share?

[submit screenshots on this page](https://github.com/cornernote/minetest-skyblock/issues/2)
