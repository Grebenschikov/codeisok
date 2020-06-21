{% include 'header.twig.tpl' %}

<input type="hidden" id="review_hash_head" value="{{ commit.GetHash() }}" />
<input type="hidden" id="review_hash_base" value="" />


 <div class="page_nav">
    {% if commit %}
        {% set tree = commit.GetTree() %}
    {% endif %}

    {% include 'nav.twig.tpl' with {'current': 'commitdiff', 'logcommit': commit, 'treecommit': commit} %}

     <div class="diff-controls">
         <div class="diff-controls__options">
             <div class="diff-controls__item">
                 <div class="diff_modes">
                     <a class="{% if unified %}is-active{% endif %}" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ commit.GetHash() }}{% if hashparent %}&amp;hp={{ hashparent }}{% endif %}&amp;{% if review %}review={{ review }}{% endif %}&amp;o=unified">{% t %}unified{% endt %}</a>
                     <a class="{% if sidebyside %}is-active{% endif %}" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ commit.GetHash() }}{% if hashparent %}&amp;hp={{ hashparent }}{% endif %}&amp;{% if review %}review={{ review }}{% endif %}&amp;o=sidebyside">{% t %}side by side{% endt %}</a>
                     <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff_plain&amp;h={{ commit.GetHash() }}{% if hashparent %}&amp;hp={{ hashparent }}{% endif %}">{% t %}plain{% endt %}</a>
                 </div>
             </div>

             <div class="diff-controls__item">
                 <a class="checkbox-link js-toggle-treediff"
                    href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ commit.GetHash() }}{% if hashparent %}&amp;hp={{ hashparent }}{% endif %}&amp;{% if review %}review={{ review }}{% endif %}&amp;treediff={% if treediff %}0{% else %}1{% endif %}">
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
         </div>
         <div class="diff-controls__options page-search-container"></div>
     </div>
 </div>

 {% include 'title.twig.tpl' with {'titlecommit': commit, 'compact': true} %}

 <div class="page_body">

   <div class="diff_summary">
    {#
        UNIFIED
    #}
    {% if unified %}
        {% if treediff %}
            {% include 'unified_treediff.twig.tpl' with {'diff_source': commit_tree_diff} %}
        {% else %}
            {% include 'extensions_filter.twig.tpl' with {'stasuses': statuses, 'extensions': extensions, 'folders': folders} %}

            <table class="diff-file-list">
                {% for filediff in commit_tree_diff %}
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

            {% include 'unified_diff_contents.twig.tpl' with {'diff_source': commit_tree_diff} %}
        {% endif %}
    {% else %}
       {# SIDE BY SIDE #}
        <script type="text/javascript" src="/lib/mergely/codemirror.min.js?v={{ libVersion }}"></script>
        <link type="text/css" rel="stylesheet" href="/lib/mergely/codemirror.css?v={{ libVersion }}" />
        <script type="text/javascript" src="/lib/mergely/mergely.js?v={{ libVersion }}"></script>
        <link type="text/css" rel="stylesheet" href="/lib/mergely/mergely.css?v={{ libVersion }}" />

        <div class="commitDiffSBS">
            {% if treediff %}
                {% include 'sbs_treediff.twig.tpl' with {'diff_source': commit_tree_diff, 'cssversion': cssversion} %}
            {% else %}
                {% include 'sbs_non_treediff.twig.tpl' with {'diff_source': commit_tree_diff} %}
            {% endif %}
        </div>
        <div class="SBSFooter">
        </div>
    {% endif %}
   </div>

   {% if sexy %}
       {% include "sexy_highlighter.twig.tpl" %}
   {% endif %}

 </div>

 {% include 'footer.twig.tpl' %}