{% include 'header.twig.tpl' %}

{% include 'nav.twig.tpl' with {'current': 'tree', 'logcommit': commit} %}

{% include 'title.twig.tpl' with {'titlecommit': commit, 'hasPageSearch': true} %}

{% include 'path.twig.tpl' with {'pathobject': tree, 'target': 'tree'} %}

<div class="page_body">
    <table cellspacing="0" class="git-table treeTable">
        {% include 'treelist.twig.tpl' %}
    </table>
</div>

{% include 'footer.twig.tpl' %}

