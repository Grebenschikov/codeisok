<table cellspacing="0" class="git-table shortlog">
{% for rev in revlist %}
    <tr {% if mark is defined and mark and mark.GetHash() == rev.GetHash() %}class="selected"{% endif %}>
        <td width="15%" title="{% if rev.GetAge() > 60*60*24*7*2 %}{{ rev.GetAge()|agestring }}{% else %}{{ rev.GetCommitterEpoch()|date("Y-m-d H:i:s") }}{% endif %}">
            {% if rev.GetAge() > 60*60*24*7*2 %}{{ rev.GetCommitterEpoch()|date("Y-m-d") }}{% else %}{{ rev.GetAge()|agestring }}{% endif %}
        </td>

        <td width="10%">
            {{ rev.GetAuthorName() }}
        </td>

        <td>
            <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ rev.GetHash() }}" class="list commitTip" {% if rev.GetTitle()|length > 150 %}title="{{ rev.GetTitle()|escape }}"{% endif %}>
                {{ rev.GetTitle(150)|escape }}
            </a>

            {% include 'refbadges.twig.tpl' with {'commit': rev} %}

            <div class="actions">
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ rev.GetHash() }}&amp;retbranch={{ branch_name }}">{% t %}Commit{% endt %}</a>
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ rev.GetHash() }}&amp;retbranch={{ branch_name }}">{% t %}Commitdiff{% endt %}</a>
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ rev.GetHash() }}&amp;hb={{ rev.GetHash() }}">{% t %}Tree{% endt %}</a>
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=snapshot&amp;h={{ rev.GetHash() }}" class="snapshotTip">{% t %}Snapshot{% endt %}</a>
                {% if source == 'shortlog' or source == 'branchlog' %}
                    {% if mark is defined and mark %}
                        {% if mark.GetHash() == rev.GetHash() %}
                            <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a={{ source }}&amp;h={{ commit.GetHash() }}&amp;pg={{ page }}">{% t %}Deselect{% endt %}</a>
                        {% else %}
                            {% if mark.GetCommitterEpoch() > rev.GetCommitterEpoch() %}
                                {% set markbase = mark %}
                                {% set markparent = rev %}
                            {% else %}
                                {% set markbase = rev %}
                                {% set markparent = mark %}
                            {% endif %}
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ markbase.GetHash() }}&amp;hp={{ markparent.GetHash() }}">{% t %}Diff with selected{% endt %}</a>
                        {% endif %}
                    {% else %}
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a={{ source }}&amp;h={{ commit.GetHash() }}&amp;pg={{ page }}&amp;m={{ rev.GetHash() }}">{% t %}Select for diff{% endt %}</a>
                    {% endif %}
                {% endif %}
            </div>
        </td>
    </tr>
{% else %}
    <tr><td><em>{% t %}No commits{% endt %}</em></td></tr>
{% endfor %}

{% if hasmorerevs %}
    <tr>
        {% if source == 'summary' %}
            <td colspan="3"><a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=shortlog">Show More</a></td>
        {% elseif source == 'shortlog' %}
            <td colspan="3"><a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=shortlog&amp;h={{ commit.GetHash() }}&amp;pg={{ page+1 }}{% if not(mark is empty) %}&amp;m={{ mark.GetHash() }}{% endif %}" title="Alt-n">{% t %}Next{% endt %}</a></td>
        {% elseif source == 'branchlog' %}
            <td colspan="3"><a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=branchlog&amp;h={{ commit.GetHash() }}&amp;pg={{ page+1 }}{% if not(mark is empty) %}&amp;m={{ mark.GetHash() }}{% endif %}" title="Alt-n">{% t %}Next{% endt %}</a></td>
        {% endif %}
    </tr>
{% endif %}
</table>