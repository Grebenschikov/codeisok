{% include 'header.twig.tpl' %}

{% include 'nav.twig.tpl' with {'logcommit': commit, 'treecommit': commit, 'current': ''} %}

<div class="title compact stretch-evenly">
    {% if page > 0 %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=search&amp;h={{ commit.GetHash() }}&amp;s={{ search }}&amp;st={{ searchtype }}">{% t %}First{% endt %}</a>
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=search&amp;h={{ commit.GetHash() }}&amp;s={{ search }}&amp;st={{ searchtype }}{% if page > 1 %}&amp;pg={{ page - 1 }}{% endif %}" accesskey="p" title="Alt-p">{% t %}Prev{% endt %}</a>
    {% endif %}
    {% if hasmore %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=search&amp;h={{ commit.GetHash() }}&amp;s={{ search }}&amp;st={{ searchtype }}&amp;pg={{ page + 1 }}" accesskey="n" title="Alt-n">{% t %}Next{% endt %}</a>
    {% endif %}
    <div class="page-search-container"></div>
</div>

<div class="title">
  <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ commit.GetHash() }}" class="title">{{ commit.GetTitle() }}</a>
</div>

<table class="git-table">
    {# Print each match #}
    {% for path, result in results %}
        <tr>
            {% set resultobject = result.object %}
            {% if is_a(resultobject, '\\CodeIsOk\\Git\\Tree') %}
	            <td>
		            <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ resultobject.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ path }}" class="list"><strong>{{ path }}</strong></a>
                    <div class="actions">
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ resultobject.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ path }}">{% t %}Tree{% endt %}</a>
                    </div>
	            </td>
            {% else %}
	            <td>
		            <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ result.object.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ path }}" class="list"><strong>{{ path|highlight(search) }}</strong></a>
		            {% for lineno, line in result.lines %}
		                {% if loop.first %}<br />{% endif %}<span class="matchline">{{ lineno }}. {{ line|highlight(search, 100, true) }}</span><br />
		            {% endfor %}

                    <div class="actions">
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ resultobject.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ path }}">{% t %}Blob{% endt %}</a>
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=history&amp;h={{ commit.GetHash() }}&amp;f={{ path }}">{% t %}History{% endt %}</a>
                    </div>
	            </td>
            {% endif %}
        </tr>
  {% endfor %}

  {% if hasmore %}
    <tr>
        <td><a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=search&amp;h={{ commit.GetHash() }}&amp;s={{ search }}&amp;st={{ searchtype }}&amp;pg={{ page + 1 }}" title="Alt-n">{% t %}Next{% endt %}</a></td>
    </tr>
  {% endif %}
</table>

{% include 'footer.twig.tpl' %}

