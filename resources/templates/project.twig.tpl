{% include 'header.twig.tpl' %}

<div class="page_nav">
    {% include 'nav.twig.tpl' with {'commit': head, 'current': 'summary'} %}
</div>

{% include 'title.twig.tpl' %}

<div class="stretch-evenly">
    <table class="project-brief" cellspacing="0">
        <tr><td>{% t %}Description{% endt %}</td><td>{{ project.GetDescription() }}</td></tr>
        <tr><td>{% t %}Owner{% endt %}</td><td>{{ project.GetOwner()|escape }}</td></tr>
        {% if head %}
        <tr><td>{% t %}Last change{% endt %}</td><td>{{ head.GetCommitterEpoch()|date("Y-m-d H:i:s") }}</td></tr>
        {% endif %}
        {% if project.GetCloneUrl() %}
            <tr><td>{% t %}clone url{% endt %}</td><td><a href="{{ project.GetCloneUrl() }}">{{ project.GetCloneUrl() }}</a></td></tr>
        {% endif %}
        {% if project.GetPushUrl() %}
            <tr><td>{% t %}Push url{% endt %}</td><td><a href="{{ project.GetPushUrl() }}">{{ project.GetPushUrl() }}</a></td></tr>
        {% endif %}
    </table>

    <div class="page-search-container"></div>
</div>

{% if not(head) %}
   {% include 'title.twig.tpl' with {'target': 'shortlog', 'disablelink': true} %}
{% else %}
   {% include 'title.twig.tpl' with {'target': 'shortlog'} %}
{% endif %}

{% include 'shortloglist.twig.tpl' with {'source': 'summary'} %}

{% if taglist %}
    {% include 'title.twig.tpl' with {'target': 'tags'} %}
    {% include 'taglist.twig.tpl' %}
{% endif %}

{% if headlist is defined and headlist %}
    {% include 'title.twig.tpl' with {'target': 'heads'} %}
    {% include 'headlist.twig.tpl' %}
{% endif %}

{% include 'footer.twig.tpl' %}
