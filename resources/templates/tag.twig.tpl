{% include 'header.twig.tpl' %}

 <div class="page_nav">
   {% include 'nav.twig.tpl' with {'commit': head, 'treecommit': head} %}
 </div>
 {% set object = tag.GetObject() %}
 {% set objtype = tag.GetType() %}
 <div class="title">
   <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ object.GetHash() }}" class="title">{{ tag.GetName() }}</a>
 </div>
 <div class="title_text">
   <table cellspacing="0">
     <tr>
       <td>{% t %}object{% endt %}</td>
       {% if objtype == 'commit' %}
         <td class="monospace"><a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ object.GetHash() }}" class="list">{{ object.GetHash() }}</a></td>
         <td class="link"><a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ object.GetHash() }}">{% t %}Commit{% endt %}</a></td>
       {% elseif objtype == 'tag' %}
         <td class="monospace"><a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tag&amp;h={{ object.GetName() }}" class="list">{{ object.GetHash() }}</a></td>
         <td class="link"><a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tag&amp;h={{ object.GetName() }}">{% t %}tag{% endt %}</a></td>
       {% endif %}
     </tr>
     {% if tag.GetTagger() %}
       <tr>
         <td>{% t %}author{% endt %}</td>
	 <td>{{ tag.GetTagger() }}</td>
       </tr>
       <tr>
         <td></td>
	 <td> {{ tag.GetTaggerEpoch()|date("D, d M Y H:i:s O") }}
	 {% set hourlocal = tag.GetTaggerLocalEpoch()|date("H") %}
	 {% if hourlocal < 6 %}
	 (<span class="latenight">{{ tag.GetTaggerLocalEpoch()|date("H:i") }}</span> {{ tag.GetTaggerTimezone() }})
	 {% else %}
	 ({{ tag.GetTaggerLocalEpoch()|date("H:i") }} {{ tag.GetTaggerTimezone() }})
	 {% endif %}
         </td>
       </tr>
     {% endif %}
   </table>
 </div>
 <div class="page_body">
   {% set bugpattern = project.GetBugPattern() %}
   {% set bugurl = project.GetBugUrl() %}
   {% for line in tag.GetComment() %}
     {{ line|escape|buglink(bugpattern,bugurl) }}<br />
   {% endfor %}
 </div>

{% include 'footer.twig.tpl' %}