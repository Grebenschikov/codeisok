{% include 'header.twig.tpl' %}

{% include 'nav.twig.tpl' with {'logcommit': commit, 'treecommit': commit} %}

<div class="title compact stretch-evenly">
    {% if page > 0 %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=search&amp;h={{ commit.GetHash() }}&amp;s={{ search }}&amp;st={{ searchtype }}">{% t %}First{% endt %}</a>
    {% endif %}
    {% if page > 0 %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=search&amp;h={{ commit.GetHash() }}&amp;s={{ search }}&amp;st={{ searchtype }}{% if page > 1 %}&amp;pg={{ page - 1 }}{% endif %}" accesskey="p" title="Alt-p">{% t %}Prev{% endt %}</a>
    {% endif %}
    {% if hasmore %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=search&amp;h={{ commit.GetHash() }}&amp;s={{ search }}&amp;st={{ searchtype }}&amp;pg={{ page + 1 }}" accesskey="n" title="Alt-n">{% t %}Next{% endt %}</a>
    {% endif %}
    <div class="page-search-container"></div>
</div>

{% include 'title.twig.tpl' with {'titlecommit': commit} %}

<table class="git-table">
    {# Print each match #}
    {% for result in results %}
        <tr>
            <td title="{% if result.GetAge() > 60*60*24*7*2 %}{{ result.GetAge()|agestring }}{% else %}{{ result.GetCommitterEpoch()|date("Y-m-d") }}{% endif %}"><em>{% if result.GetAge() > 60*60*24*7*2 %}{{ result.GetCommitterEpoch()|date("Y-m-d") }}{% else %}{{ result.GetAge()|agestring }}{% endif %}</em></td>
            <td>
                <em>
                    {% if searchtype == 'author' %}
                        {{ result.GetAuthorName()|highlight(search) }}
                    {% elseif searchtype == 'committer' %}
                        {{ result.GetCommitterName()|highlight(search) }}
                    {% else %}
                        {{ result.GetAuthorName() }}
                    {% endif %}
                </em>
            </td>
            <td>
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ result.GetHash() }}" class="list commitTip" {% if result.GetTitle()|length > 50 %}title="{{ result.GetTitle() }}"{% endif %}><strong>{{ result.GetTitle(50) }}</strong>
                {% if searchtype == 'commit' %}
                    {% for line in result.SearchComment(search) %}
                        <br />{{ line|highlight(search, 50) }}
                    {% endfor %}
                {% endif %}

                {% set resulttree = result.GetTree() %}
                <div class="actions">
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ result.GetHash() }}">{% t %}Commit{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ result.GetHash() }}">{% t %}Commitdiff{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ resulttree.GetHash() }}&amp;hb={{ result.GetHash() }}">{% t %}Tree{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=snapshot&amp;h={{ result.GetHash() }}" class="snapshotTip">{% t %}Snapshot{% endt %}</a>
                </div>
            </td>
        </tr>
    {% endfor %}

  {% if hasmore %}
    <tr>
      <td colspan="4"><a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=search&amp;h={{ commit.GetHash() }}&amp;s={{ search }}&amp;st={{ searchtype }}&amp;pg={{ page + 1 }}" title="Alt-n">{% t %}next{% endt %}</a></td>
    </tr>
  {% endif %}
</table>

{% include 'footer.twig.tpl' %}

