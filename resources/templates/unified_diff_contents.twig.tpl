{% for filediff in diff_source %}
    {% set diff = filediff.GetDiff('', true, true) %}
    <div class="filetype-{{ filediff.getToFileExtension() }} status-{{ filediff.getStatus()|lower }} folder-{{ filediff.getToFileRootFolder()|lower }} diffBlob{% if filediff.getDiffTooLarge() %} suppressed{% endif %}" id="{{ filediff.GetFromHash() }}_{{ filediff.GetToHash() }}">
        <a class="anchor" name="{{ filediff.getToFile() }}"></a>
        <div class="diff_info">
            {% if (filediff.GetStatus() == 'D') or (filediff.GetStatus() == 'M') or (filediff.GetStatus() == 'R') %}
                {% set localfromtype = filediff.GetFromFileType(1) %}
                {{ localfromtype }}: <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ filediff.GetFromHash() }}&amp;hb={{ commit.GetHash() }}{% if filediff.GetFromFile() %}&amp;f={{ filediff.GetFromFile() }}{% endif %}">{% if filediff.GetFromFile() %}a/{{ filediff.GetFromFile() }}{% else %}{{ filediff.GetFromHash() }}{% endif %}</a>
                {% if filediff.GetStatus() == 'D' %}
                    {% t %}(deleted){% endt %}
                {% endif %}
            {% endif %}

            {% if filediff.GetStatus() == 'M' or filediff.GetStatus() == 'R' %}
                &gt;
            {% endif %}

            {% if (filediff.GetStatus() == 'A') or (filediff.GetStatus() == 'M') or (filediff.GetStatus() == 'R') %}
                {% set localtotype = filediff.GetToFileType(1) %}
                {{ localtotype }}: <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ filediff.GetToHash() }}&amp;hb={{ commit.GetHash() }}{% if filediff.GetToFile() %}&amp;f={{ filediff.getToFile() }}{% endif %}">{% if filediff.GetToFile() %}b/{{ filediff.getToFile() }}{% else %}{{ filediff.GetToHash() }}{% endif %}</a>

                {% if filediff.GetStatus() == 'A' %}
                    {% t %}(new){% endt %}
                {% endif %}
            {% endif %}
        </div>
        {% include 'filediff.twig.tpl' with {'diff': diff } %}
    </div>
{% endfor %}
