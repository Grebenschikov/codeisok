{% include 'header.twig.tpl' %}

{% include 'nav.twig.tpl' with {'current': 'log', 'logcommit': commit, 'treecommit': commit, 'logmark': mark} %}

<div class="title compact stretch-evenly">
    {% if (commit and head) and ((commit.GetHash() != head.GetHash()) or (page > 0)) %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=log{% if mark %}&amp;m={{ mark.GetHash() }}{% endif %}">{% t %}HEAD{% endt %}</a>
    {% endif %}

    {% if page > 0 %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=log&amp;h={{ commit.GetHash() }}&amp;pg={{ page - 1 }}{% if mark %}&amp;m={{ mark.GetHash() }}{% endif %}" accesskey="p" title="Alt-p">{% t %}Prev{% endt %}</a>
    {% endif %}

    {% if hasmorerevs %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=log&amp;h={{ commit.GetHash() }}&amp;pg={{ page + 1 }}{% if mark %}&amp;m={{ mark.GetHash() }}{% endif %}" accesskey="n" title="Alt-n">{% t %}Next{% endt %}</a>
    {% endif %}

    <div class="page-search-container"></div>
</div>

{% if mark %}
    <div class="title compact">
        {% t %}Selected for diff: {% endt %}
        <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ mark.GetHash() }}" class="list commitTip" {% if mark.GetTitle()|length > 100 %}title="{{ mark.GetTitle() }}"{% endif %}><strong>{{ mark.GetTitle(100) }}</strong></a>
        &nbsp;&nbsp;&nbsp;
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=log&amp;h={{ commit.GetHash() }}&amp;pg={{ page }}">{% t %}Deselect{% endt %}</a>
    </div>
{% endif %}

<table class="git-table">
    {% for rev in revlist %}
        <tr class="commit-head {% if mark and mark.GetHash() == rev.GetHash() %}selected{% endif %}">
            <td width="10%">{{ rev.GetAge()|agestring }}</td>
            <td width="10%">{{ rev.GetAuthorName() }}</td>
            <td>
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ rev.GetHash() }}">{{ rev.GetTitle() }}</a>
                {% include 'refbadges.twig.tpl' with {'commit': rev} %}
                {% if ticket and loop.first %}
                    <div class="title-right"><a href="{{ ticket_href }}">{{ ticket }}</a></div>
                {% endif %}

                <div class="actions">
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ rev.GetHash() }}">{% t %}Commit{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ rev.GetHash() }}">{% t %}Commitdiff{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ rev.GetHash() }}&amp;hb={{ rev.GetHash() }}">{% t %}Tree{% endt %}</a>

                    {% if mark %}
                        {% if mark.GetHash() == rev.GetHash() %}
                            <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=log&amp;h={{ commit.GetHash() }}&amp;pg={{ page }}">{% t %}Deselect{% endt %}</a>
                        {% else %}
                            {% if mark.GetCommitterEpoch() > rev.GetCommitterEpoch() %}
                                {% set markbase = mark %}
                                {% set markparent = rev %}
                            {% else %}
                                {% set markbase = rev %}
                                {% set markparent = mark %}
                            {% endif %}
                            <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ markbase.GetHash() }}&amp;hp={{ markparent.GetHash() }}">{% t %}Diff with selected{% endt %}</a>
                        {% endif %}
                    {% else %}
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=log&amp;h={{ commit.GetHash() }}&amp;pg={{ page }}&amp;m={{ rev.GetHash() }}">{% t %}Select for diff{% endt %}</a>
                    {% endif %}
                </div>
            </td>
        </tr>

        <tr class="commit-body">
            <td width="10%"></td>
            <td width="10%"></td>
            <td>
                {% set bugpattern = project.GetBugPattern() %}
                {% set bugurl = project.GetBugUrl() %}

                {% for line in rev.GetComment() %}
                    <div>{{ line|escape|buglink(bugpattern,bugurl)|striptags }}</div>
                {% endfor %}
            </td>
        </tr>

    {% else %}
        <tr>
            <td>
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=summary" class="title">&nbsp</a>
            </td>
            <td>
                {% if commit %}
                    {% set commitage = commit.GetAge()|agestring %}
                    {% t param1=commitage %}Last change %1{% endt %}
                {% else %}
                    <em>{% t %}No commits{% endt %}</em>
                {% endif %}
            </td>
        </tr>
    {% endfor %}
</table>

{% include 'footer.twig.tpl' %}
