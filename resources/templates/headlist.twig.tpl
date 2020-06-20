<table class="git-table">
    {% for head in headlist %}
        {% set headcommit = head.GetCommit() %}
        <tr>
            <td width="15%"><em>{{ headcommit.GetAge()|agestring }}</em></td>
            <td>
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=shortlog&amp;h=refs/heads/{{ head.GetName() }}" class="list"><strong>{{ head.GetName() }}</strong></a>

                <div class="actions">
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=shortlog&amp;h=refs/heads/{{ head.GetName() }}">{% t %}shortlog{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=branchlog&amp;h={{ head.GetName() }}">{% t %}branchlog{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=log&amp;h=refs/heads/{{ head.GetName() }}">{% t %}log{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;hb={{ headcommit.GetHash() }}">{% t %}Tree{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=branchdiff&amp;branch={{ head.GetName() }}">{% t %}branchdiff{% endt %}</a>
                </div>
            </td>
       </tr>
   {% endfor %}
   {% if hasmoreheads %}
        <tr>
            <td colspan="3"><a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=heads">Show More</a></td>
        </tr>
   {% endif %}
 </table>