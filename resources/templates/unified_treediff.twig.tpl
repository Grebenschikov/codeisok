<link rel="stylesheet" href="/css/treediff.css?v={{ cssversion }}" type="text/css" />

<script>
var _file_list = [
    {% for filediff in diff_source %}
        {
            path: '{{ filediff.getToFile() }}',
            status: '{{ filediff.getStatus() | lower }}',
            fileType: '{{ filediff.getToFileExtension() }}'
        },
    {% endfor %}
];
</script>

<div class="two-panes is-loading">
    {# This is rendered for non-JS support #}
    <div class="js-left-pane left-pane">

        {% include 'extensions_filter.twig.tpl' with {'stasuses': statuses, 'extensions': extensions, 'folders': folders} %}

        <ul class="file-list">
            {% for filediff in diff_source %}
                <li class="filetype-{{ filediff.getToFileExtension() }} status-{{ filediff.getStatus()|lower }} folder-{{ filediff.getToFileRootFolder()|lower }}">
                <a href="#{{ filediff.getToFile() }}">{{ filediff.getToFile() }}</a>
                <a name="files_index_{{ filediff.getToFile() }}"></a>
                </li>
            {% endfor %}
        </ul>
    </div>

    <div class="js-pane-dragger pane-dragger"></div>

    <div class="right-pane">
        {% include 'unified_diff_contents.twig.tpl' with {'diff_source': diff_source} %}
    </div>
</div>