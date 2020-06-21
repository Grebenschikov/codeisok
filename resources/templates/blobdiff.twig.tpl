{% include 'header.twig.tpl' %}

{% include 'nav.twig.tpl' with {'treecommit': commit} %}

<div class="diff-controls">
    <div class="diff-controls__options">
        <div class="diff-controls__item">
            <div class="diff_modes">
                <a class="{% if unified %}is-active{% endif %}" class="" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blobdiff&amp;h={{ blob.GetHash() }}&amp;hp={{ blobparent.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ file }}&amp;o=unified">{% t %}Unified{% endt %}</a>
                <a class="{% if sidebyside %}is-active{% endif %}" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blobdiff&amp;h={{ blob.GetHash() }}&amp;hp={{ blobparent.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ file }}&amp;o=sidebyside">{% t %}Side by side{% endt %}</a>
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blobdiff_plain&amp;h={{ blob.GetHash() }}&amp;hp={{ blobparent.GetHash() }}&amp;f={{ file }}">{% t %}Plain{% endt %}</a>
            </div>
        </div>
    </div>
    <div class="diff-controls__options page-search-container"></div>
</div>

{% include 'title.twig.tpl' with {'titlecommit': commit} %}

{% include 'path.twig.tpl' with {'pathobject': blobparent, 'target': 'blob'} %}

<div class="page_body">
    <div class="diff_info">
        {# Display the from -> to diff header #}
        {% t %}Blob{% endt %}: <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ blobparent.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ file }}">{% if file %}a/{{ file }}{% else %}{{ blobparent.GetHash() }}{% endif %}</a>
        &gt;
        {% t %}Blob{% endt %}: <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ blob.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ file }}">{% if file %}b/{{ file }}{% else %}{{ blob.GetHash() }}{% endif %}</a>
    </div>

    {% if sidebyside %}
        {# Display the sidebysidediff #}
        <script type="text/javascript" src="/lib/mergely/codemirror.min.js?v={{ libVersion }}"></script>
        <link type="text/css" rel="stylesheet" href="/lib/mergely/codemirror.css?v={{ libVersion }}" />
        <script type="text/javascript" src="/lib/mergely/mergely.js?v={{ libVersion }}"></script>
        <link type="text/css" rel="stylesheet" href="/lib/mergely/mergely.css?v={{ libVersion }}" />

        <div class="file-list">
            <a href="#{{ filediff.GetFromHash() }}_{{ filediff.GetToHash() }}"
                data-fromHash = "{{ filediff.GetFromHash() }}"
                data-fromFile = "{{ filediff.GetFromFile() }}"
                data-toHash = "{{ filediff.GetToHash() }}"
                data-toFile = "{{ filediff.GetToFile() }}"
                class="SBSTOCItem">
                {% if filediff.GetStatus() == 'A' %}
                    {% if filediff.GetToFile() %}{{ filediff.GetToFile() }}{% else %}{{ filediff.GetToHash() }}{% endif %} {% t %}(new){% endt %}
                {% elseif filediff.GetStatus() == 'D' %}
                    {% if filediff.GetFromFile() %}{{ filediff.GetFromFile() }}{% else %}{{ filediff.GetToFile() }}{% endif %} {% t %}(deleted){% endt %}
                {% elseif (filediff.GetStatus() == 'M') or (filediff.GetStatus() == 'R') %}
                    {% if filediff.GetFromFile() %}
                        {% set fromfilename = filediff.GetFromFile() %}
                    {% else %}
                        {% set fromfilename = filediff.GetFromHash() %}
                    {% endif %}
                    {% if filediff.GetToFile() %}
                        {% set tofilename = filediff.GetToFile() %}
                    {% else %}
                        {% set tofilename = filediff.GetToHash() %}
                    {% endif %}
                    {{ fromfilename }}{% if fromfilename != tofilename %} -&gt; {{ tofilename }}{% endif %}
                {% endif %}
            </a>
        </div>

        {% include 'filediffsidebyside.twig.tpl' with {'diffsplit': filediff.GetDiffSplit()} %}
    {% else %}
        {# Display the diff #}
        {% include 'filediff.twig.tpl' with {'diff': filediff.GetDiff(file, false, true)} %}
    {% endif %}
</div>

{% include 'footer.twig.tpl' %}