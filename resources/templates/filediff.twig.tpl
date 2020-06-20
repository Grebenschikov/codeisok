{% set decoration = filediff.GetDecorationData() %}
{% if filediff.getDiffTypeImage() %}
{{ diff }}
{% else %}
{% if filediff.getDiffTooLarge() and sexy %}
<p class="too_large_diff">
    <img src="/images/loader.gif" alt="Please wait" />
    <a data-brush="{{ decoration.highlighter_brush_name }}" href="?p={{ project.GetProject()|url_encode }}&a=blobdiff_plain&hp={{ filediff.getDiffTreeLine()|url_encode }}&h=&f={{ filediff.GetFromFile()|url_encode }}" class="show_suppressed_diff">Diff suppressed. Click to show.</a>
</p>
{% else %}
{% if sexy %}
<pre class="brush: {{ decoration.highlighter_brush_name }}" data-marks="{{ filediff.getInlineChanges() | raw }}">{% for diffline in diff %}{{ diffline|raw }}
{% endfor %}</pre>
{% else %}
<div class="pre">
{% for diffline in diff %}
{% if (diffline|first) == "+" %}
<span class="diffplus">{{ diffline }}</span>
{% elseif (diffline|first) == "-" %}
<span class="diffminus">{{ diffline }}</span>
{% elseif (diffline|first) == "@" %}
<span class="diffat">{{ diffline }}</span>
{% else %}
<span>{{ diffline }}</span>
{% endif %}
{% endfor %}
</div>
{% endif %}
{% endif %}
{% endif %}