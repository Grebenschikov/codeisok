{% include 'header.twig.tpl' %}

{% if commit %}
    <input type="hidden" id="review_hash_head" value="{{ commit.GetHash() }}" />
    <input type="hidden" id="review_hash_base" value="{{ branchdiff.GetFromHash() }}" />
{% endif %}

<div class="page_nav">
    {% if commit %}
        {% set tree = commit.GetTree() %}
    {% endif %}

    {% include 'nav.twig.tpl' with {'current': 'branchdiff', 'logcommit': commit, 'treecommit': commit} %}

    <div class="diff-controls">
        <div class="diff-controls__options">
            <div class="diff-controls__item">
                <div class="diff_modes">
                    <a class="{% if unified %}is-active{% endif %}" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=branchdiff&amp;branch={{ branch }}{% if review %}&amp;review={{ review }}{% endif %}{% if base %}&amp;base={{ base }}{% endif %}&amp;o=unified">{% t %}Unified{% endt %}</a>
                    <a class="{% if sidebyside %}is-active{% endif %}" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=branchdiff&amp;branch={{ branch }}{% if review %}&amp;review={{ review }}{% endif %}{% if base %}&amp;base={{ base }}{% endif %}&amp;o=sidebyside">{% t %}Side by side{% endt %}</a>
                    <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=branchdiff_plain&amp;branch={{ branch }}">{% t %}plain{% endt %}</a>
                </div>
            </div>

            <div class="diff-controls__item">
                <a class="checkbox-link js-toggle-treediff"
                   href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=branchdiff&amp;branch={{ branch }}{% if review %}&amp;review={{ review }}{% endif %}{% if base %}&amp;base={{ base }}{% endif %}&amp;treediff={% if treediff %}0{% else %}1{% endif %}">
                    <span class="checkbox-link__control">
                        <input class="checkbox-input" type='checkbox' id='selectall' {% if treediff %}checked{% endif %} disabled/>
                    </span>
                    <span class="checkbox-link__label">{% t %}Treediff{% endt %}</span>
                </a>
            </div>

            {% if review and unified %}
            <div class="diff-controls__item">
                <a class="checkbox-link js-toggle-review-comments">
                    <span class="checkbox-link__control">
                        <input class="checkbox-input js-toggle-review-comments-input" type='checkbox'/>
                    </span>
                    <span class="checkbox-link__label">
                        Review Comments Only
                    </span>
                </a>
            </div>
            {% endif %}

            {% if branchdiff and branchdiff.hasHidden() %}
                <a class="diff-controls__item simple-button-highlighted" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=branchdiff&amp;branch={{ branch }}{% if review %}&amp;review={{ review }}{% endif %}{% if base %}&amp;base={{ base }}{% endif %}&amp;show_hidden=1">
                    Show hidden files
                </a>
            {% endif %}
        </div>
        <div class="diff-controls__options page-search-container"></div>
    </div>
 </div>

 {% include 'title.twig.tpl' with {'compact': true} %}

 <div class="page_body">

    {% if branchdiff %}
        {% if unified %}
            <div class="diff_summary">
                {% if treediff %}
                    {% include 'unified_treediff.twig.tpl' with {'diff_source': branchdiff} %}
                {% else %}
                    {% include 'extensions_filter.twig.tpl' with {'stasuses': statuses, 'extensions': extensions, 'folders': folders} %}

                    <table class="diff-file-list">
                        {% for filediff in branchdiff %}
                            <tr class="filetype-{{ filediff.GetToFileExtension() }} status-{{ filediff.GetStatus()|lower }} folder-{{ filediff.GetToFileRootFolder()|lower }}">
                                <td>
                                    <span>{{ filediff.GetStatus() }}</span>
                                </td>
                                <td class="file-name">
                                    <a href="#{{ filediff.GetToFile() }}">{{ filediff.GetToFile() }}</a>
                                </td>
                                <td name="files_index_{{ filediff.GetToFile() }}"></td>
                            </tr>
                        {% endfor %}
                    </table>

                    {% include 'unified_diff_contents.twig.tpl' with {'diff_source': branchdiff} %}
                {% endif %}
            </div>
        {% else %}
            <script type="text/javascript" src="/lib/mergely/codemirror.min.js?v={{ libVersion }}"></script>
            <link type="text/css" rel="stylesheet" href="/lib/mergely/codemirror.css?v={{ libVersion }}" />
            <script type="text/javascript" src="/lib/mergely/mergely.js?v={{ libVersion }}"></script>
            <link type="text/css" rel="stylesheet" href="/lib/mergely/mergely.css?v={{ libVersion }}" />

            <div class="commitDiffSBS">
                {% if treediff %}
                    {% include 'sbs_treediff.twig.tpl' with {'diff_source': branchdiff, 'cssversion': cssversion} %}
                {% else %}
                    {% include 'sbs_non_treediff.twig.tpl' with {'diff_source': branchdiff} %}
                {% endif %}
            </div>
            <div class="SBSFooter">
            </div>
        {% endif %}
    {% else %}
        <div style='color:red'>Branch is not found</div>
    {% endif %}

   {% if sexy %}
       {% include "sexy_highlighter.twig.tpl" %}
   {% endif %}

 </div>

 {% include 'footer.twig.tpl' %}

