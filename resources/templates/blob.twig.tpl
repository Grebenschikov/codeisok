{% include 'header.twig.tpl' %}
<input type="hidden" id="review_hash_head" value="{{ blob.GetHash() }}" />
<input type="hidden" id="review_hash_base" value="blob" />
<input type="hidden" id="review_file" value="{{ blob.getPath() }}" />

<div class="page_nav">
   {% include 'nav.twig.tpl' with {'treecommit': commit} %}
</div>

<div class="title compact stretch-evenly">
    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob_plain&amp;h={{ blob.GetHash() }}&amp;f={{ blob.GetPath() }}">{% t %}Plain{% endt %}</a>
    {% if (commit.GetHash() != head.GetHash()) and (head.PathToHash(blob.GetPath())) %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;hb=HEAD&amp;f={{ blob.GetPath() }}">{% t %}HEAD{% endt %}</a>
    {% endif %}
    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=history&amp;h={{ commit.GetHash() }}&amp;f={{ blob.GetPath() }}">{% t %}History{% endt %}</a>
    {% if not(datatag) %}
        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blame&amp;h={{ blob.GetHash() }}&amp;f={{ blob.GetPath() }}&amp;hb={{ commit.GetHash() }}" id="blameLink">
            {% t %}Blame{% endt %}
        </a>
    {% endif %}

    <div class="page-search-container"></div>
</div>

{% include 'title.twig.tpl' with {'titlecommit': commit} %}
{% include 'path.twig.tpl' with {'pathobject': blob, 'target': 'blobplain'} %}

 <div class="page_body">
   {% if datatag %}
     {# We're trying to display an image #}
     <div>
       <img src="data:{{ mime }};base64,{{ data }}" />
     </div>
   {% elseif sexy %}
       <table class="code" id="blobData">
       <tbody>
       <tr class="li1">
       <td class="de1">
           <pre class="brush: {{ highlighter_brush_name }}">
 {{ blobstr|escape }}
           </pre>
       </td>
       </tr>
       </tbody>
       </table>
        {% include "sexy_highlighter.twig.tpl" %}
   {% elseif php %}
<table class="code" id="blobData">
<tbody>
<tr class="li1">
<td class="de1">
{{ blobstr }}
</td>
</tr>
</tbody>
</table>
   {% else %}
     {# Just plain display #}
    <table class="code" id="blobData">
    <tbody>
    <tr class="li1">
    <td class="ln">
<pre class="de1">
{% for line in bloblines %}
<a id="l{{ loop.index }}" href="#1{{ loop.index }}" class="linenr">{{ loop.index }}</a>
{% endfor %}
</pre></td>
<td class="de1">
<pre class="de1">
{% for line in bloblines %}
    {{ line|escape }}
{% endfor %}
</pre>
</td>
</tr>
</tbody>
</table>
    {% endif %}
 </div>

{% include 'footer.twig.tpl' %}