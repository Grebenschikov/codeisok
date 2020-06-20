 <table cellspacing="0" class="git-table tagTable">
    {% for tag in taglist %}
        <tr>
            {% set object = tag.GetObject() %}
            {% set tagcommit = tag.GetCommit() %}
            {% set objtype = tag.GetType() %}
            <td width="15%"><em>{{ tagcommit.GetAge()|agestring }}</em></td>

            <td>
                {% if objtype == 'commit' %}
                    <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ object.GetHash() }}" class="list"><strong>{{ tag.GetName() }}</strong></a>
                {% elseif objtype == 'tag' %}
                    <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tag&amp;h={{ tag.GetName() }}" class="list"><strong>{{ tag.GetName() }}</strong></a>
                {% endif %}
	        </td>

            <td>
	            {% set comment = tag.GetComment() %}
                {% if comment|length > 0 %}
                    <a class="list {% if not(tag.LightTag()) %}tagTip{% endif %}" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tag&amp;h={{ tag.GetName() }}">{{ comment[0] }}</a>
                {% endif %}

                <div class="actions">
                    {% if not(tag.LightTag()) %}
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tag&amp;h={{ tag.GetName() }}">{% t %}Tag{% endt %}</a>
                    {% endif %}
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ tagcommit.GetHash() }}">{% t %}Commit{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=shortlog&amp;h={{ tagcommit.GetHash() }}">{% t %}Short Log{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=log&amp;h={{ tagcommit.GetHash() }}">{% t %}Log{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=snapshot&amp;h={{ tagcommit.GetHash() }}" class="snapshotTip">{% t %}Snapshot{% endt %}</a>
                </div>
           </td>
       </tr>
    {% endfor %}

    {% if hasmoretags %}
        <tr>
            <td colspan="3"><a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tags">Show More</a></td>
        </tr>
    {% endif %}
</table>
