{% include 'header.twig.tpl' %}

 <div class="page_nav">
   {% include 'nav.twig.tpl' with {'treecommit': commit} %}
   <br />
   <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob_plain&amp;h={{ blob.GetHash() }}&amp;f={{ blob.GetPath() }}">{% t %}plain{% endt %}</a> |
   {% if commit.GetHash() != head.GetHash() %}
     <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blame&amp;hb=HEAD&amp;f={{ blob.GetPath() }}">{% t %}HEAD{% endt %}</a>
   {% else %}
     {% t %}HEAD{% endt %}
   {% endif %}
    | blame
   <br />
 </div>

{% include 'title.twig.tpl' with {'titlecommit': commit} %}

{% include 'path.twig.tpl' with {'pathobject': blob, 'target': 'blob'} %}

 <div class="page_body">
 	<table class="code">
    {% set cycle = 0 %}
	{% for blobline in blob.GetData(true) %}
	  {% set blamecommit = blame[loop.index] is defined ? blame[loop.index] : null %}
	  {% if blamecommit %}
          {% set cycle = cycle + 1 %}
	  {% endif %}
	  <tr class="{{ ['light', 'dark'][cycle % 2] }}">
	    <td class="date">
	      {% if blamecommit %}
	        <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ blamecommit.GetHash() }}" title="{{ blamecommit.GetTitle() }}" class="commitTip">{{ blamecommit.GetAuthorEpoch()|date("Y-m-d H:i:s") }}</a>
	      {% endif %}
	    </td>
	    <td class="author">
	      {% if blamecommit %}
	        {{ blamecommit.GetAuthor() }}
	      {% endif %}
	    </td>
	    <td class="num"><a id="l{{ loop.index }}" href="#l{{ loop.index }}" class="linenr">{{ loop.index }}</a></td>
	    <td class="codeline">{{ blobline|escape }}</td>
	  </tr>
	{% endfor %}
	</table>
 </div>

{% include 'footer.twig.tpl' %}
