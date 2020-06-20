<span class="refs">
    {% for commithead in commit.GetHeads() %}
        <span class="head">
            <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=shortlog&amp;h=refs/heads/{{ commithead.GetName() }}">{{ commithead.GetName() }}</a>
        </span>
    {% endfor %}
    {% set in_build_shown = false %}
    {% for committag in commit.GetTags()|reverse %}
        {% if committag.GetName()|slice(0,8) == "in-build" %}
            {% if in_build_shown %}
                {% set hide_tag = true %}
            {% else %}
                {% set hide_tag = false %}
            {% endif %}
            {% set in_build_shown = true %}
        {% else %}
            {% set hide_tag = false %}
        {% endif %}
        <span class="tag{% if hide_tag %} hidden{% endif %}">
            <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tag&amp;h={{ committag.GetName() }}" {% if not(committag.LightTag()) %}class="tagTip"{% endif %}>{{ committag.GetName() }}</a>
        </span>
        {% if loop.last and loop.length > 2 %}
            <span class="tag" onclick="$(this).siblings('.hidden').toggle();">..</span>
        {% endif %}
    {% endfor %}
    {% for review in commit.GetReviews() %}
        <span class="review">
            {% if review.hash_base %}
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=branchdiff&amp;branch={{ review.hash_head }}&amp;&amp;base={{ review.hash_base }}&amp;review={{ review.review_id }}">Review {{ review.review_id }}</a>
            {% else %}
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ review.hash_head }}&amp;review={{ review.review_id }}">Review {{ review.review_id }}</a>
            {% endif %}
        </span>
    {% endfor %}
</span>
