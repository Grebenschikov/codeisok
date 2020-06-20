{% if titlecommit or target == 'shortlog' or target == 'tags' or target == 'heads' or ticket or (not(reviews is empty) and (reviews|length) > 0) or ((hasPageSearch is defined) and hasPageSearch) %}
    <div class="title stretch-evenly {% if (compact is defined) and compact %}compact{% endif %}">
        <div>
            {% if titlecommit %}
                {% if target == 'commitdiff' %}
                    <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ titlecommit.GetHash() }}" class="title">{{ titlecommit.GetTitle()|escape }}</a>
                {% elseif target == 'tree' %}
                    <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ titletree.GetHash() }}&amp;hb={{ titlecommit.GetHash() }}" class="title">{{ titlecommit.GetTitle()|escape }}</a>
                {% else %}
                    <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ titlecommit.GetHash() }}" class="title">{{ titlecommit.GetTitle()|escape }}</a>
                {% endif %}

                <div>
                    {% for key, line in titlecommit.GetComment() %}
                        {# First line is always the original commit title which we render above #}
                        {% if key is not same as(0) and line|trim != "" %}
                            {{ line|escape }}<br />
                        {% endif %}
                    {% endfor %}
                </div>

                {% include 'refbadges.twig.tpl' with {'commit': titlecommit} %}
            {% else %}
                {% if target == 'shortlog' %}
                    {% if disablelink %}
                        {% t %}Shortlog{% endt %}
                    {% else %}
                        <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=shortlog" class="title">{% t %}Short Log{% endt %}</a>
                    {% endif %}
                {% elseif target == 'tags' %}
                    {% if disablelink %}
                        {% t %}Tags{% endt %}
                    {% else %}
                        <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tags" class="title">{% t %}Tags{% endt %}</a>
                    {% endif %}
                {% elseif target == 'heads' %}
                    {% if disablelink %}
                        {% t %}Heads{% endt %}
                    {% else %}
                        <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=heads" class="title">{% t %}Heads{% endt %}</a>
                    {% endif %}
                {% endif %}
            {% endif %}
        </div>

        <div class="title-right">
            {% if ticket %}
                <span class="ticket-label">Issue: </span>#<a href="{{ ticket_href }}" class="ticket">{{ ticket }}</a>
            {% endif %}
            {% for review in reviews %}
                <a href="{{ review.link }}">Review {{ review.review_id }}</a>,
                {% if review.diff_link %}<span> (<a href="{{ review.diff_link }}">show diff</a>)</span>{% endif %}
            {% endfor %}
        </div>

        {% if (hasPageSearch is defined) and hasPageSearch %}
            <div class="page-search-container"></div>
        {% endif %}
    </div>
{% endif %}
