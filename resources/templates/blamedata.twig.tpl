{% set cycle = 0 %}
{% for blobline in blob.GetData(true) %}
  {% set blamecommit = blame[loop.index] is defined ? blame[loop.index] : null %}
  {% if blamecommit %}
    {% if opened %}</div>{% endif %}
    <div class="{{ ['light', 'dark'][cycle % 2] }}">
    {% set cycle = cycle + 1 %}
    {% set opened = true %}
    <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ blamecommit.GetHash() }}" title="{{ blamecommit.GetTitle() }}" class="commitTip">{{ blamecommit.GetAuthorEpoch()|date("Y-m-d H:i:s") }}</a>
    {{ blamecommit.GetAuthorName()|escape }}
  {% endif %}
  <br />
{% endfor %}
{% if opened %}</div>{% endif %}
