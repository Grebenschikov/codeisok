{% include 'header.twig.tpl' %}

<div class="page_nav">
    {% include 'nav.twig.tpl' with {'treecommit': commit} %}
</div>

{% include 'title.twig.tpl' with {'titlecommit': commit} %}

{% include 'path.twig.tpl' with {'pathobject': blob, 'target': 'blob'} %}

<table class="git-table">
    {% for historyitem in blob.GetHistory() %}
        {% set historycommit = historyitem.GetCommit() %}
        <tr>
            <td width="10%" title="{% if historycommit.GetAge() > 60*60*24*7*2 %}{{ historycommit.GetAge()|agestring }}{% else %}{{ historycommit.GetCommitterEpoch()|date("Y-m-d") }}{% endif %}"><em>{% if historycommit.GetAge() > 60*60*24*7*2 %}{{ historycommit.GetCommitterEpoch()|date("Y-m-d") }}{% else %}{{ historycommit.GetAge()|agestring }}{% endif %}</em></td>
            <td width="10%"><em>{{ historycommit.GetAuthorName() }}</em></td>
            <td>
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ historycommit.GetHash() }}" class="list commitTip" {% if historycommit.GetTitle() | length > 100 %}title="{{ historycommit.GetTitle() }}"{% endif %}><strong>{{ historycommit.GetTitle(100) }}</strong></a>
                {% include 'refbadges.twig.tpl' with {'commit': historycommit} %}

                <div class="actions">
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ historycommit.GetHash() }}">{% t %}Commit{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ historycommit.GetHash() }}">{% t %}Commitdiff{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;hb={{ historycommit.GetHash() }}&amp;f={{ blob.GetPath() }}">{% t %}Blob{% endt %}</a>
                    {% if blob.GetHash() != historyitem.GetToHash() %}
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blobdiff&amp;h={{ blob.GetHash() }}&amp;hp={{ historyitem.GetToHash() }}&amp;hb={{ historycommit.GetHash() }}&amp;f={{ blob.GetPath() }}">{% t %}Diff to current{% endt %}</a>
                    {% endif %}
                </div>
            </td>
        </tr>
    {% endfor %}
</table>

{% include 'footer.twig.tpl' %}