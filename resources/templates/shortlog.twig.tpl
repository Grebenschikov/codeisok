{% include 'header.twig.tpl' %}

{% include 'nav.twig.tpl' with {'current': controller, 'logcommit': commit, 'treecommit': commit, 'logmark': mark} %}

<div class="title compact stretch-evenly">
    {% if (commit and head) and ((commit.GetHash() != head.GetHash()) or (page > 0)) %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a={{ controller }}{% if mark %}&amp;m={{ mark.GetHash() }}{% endif %}">{% t %}HEAD{% endt %}</a>
    {% endif %}

    {% if page > 0 %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a={{ controller }}&amp;h={{ commit.GetHash() }}&amp;pg={{ page - 1 }}{% if mark %}&amp;m={{ mark.GetHash() }}{% endif %}" accesskey="p" title="Alt-p">{% t %}Prev{% endt %}</a>
    {% endif %}

    {% if hasmorerevs %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a={{ controller }}&amp;h={{ commit.GetHash() }}&amp;pg={{ page + 1 }}{% if mark %}&amp;m={{ mark.GetHash() }}{% endif %}" accesskey="n" title="Alt-n">{% t %}Next{% endt %}</a>
    {% endif %}
    <div class="page-search-container"></div>
</div>

{% if mark %}
    <div class="title compact">
        {% t %}Selected for diff: {% endt %}
        <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ mark.GetHash() }}" class="list commitTip" {% if mark.GetTitle()|length > 100 %}title="{{ mark.GetTitle()|escape }}"{% endif %}><strong>{{ mark.GetTitle(100) }}</strong></a>
        &nbsp;&nbsp;&nbsp;
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a={{ controller }}&amp;h={{ commit.GetHash() }}&amp;pg={{ page }}">{% t %}Deselect{% endt %}</a>
    </div>
{% endif %}

{% include 'title.twig.tpl' with {'target': 'summary'} %}

{% include 'shortloglist.twig.tpl' with {'source': controller} %}

{% include 'footer.twig.tpl' %}

