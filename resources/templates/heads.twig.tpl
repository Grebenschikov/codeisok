{% include 'header.twig.tpl' %}

<div class="page_nav">
  {% include 'nav.twig.tpl' with {'commit': head, 'treecommit': head} %}
</div>

{% include 'title.twig.tpl' with {'target': 'summary'} %}

{% include 'headlist.twig.tpl' %}

{% include 'footer.twig.tpl' %}
