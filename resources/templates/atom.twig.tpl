<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:lang="en">
  <title>{{ project.GetProject() }}</title>
  <subtitle type="text">{{ project.GetProject() }} log</subtitle>
  <link href="{{ scripturl }}?p={{ project.GetProject()|url_encode }}&amp;a=summary"/>
  <link rel="self" href="{{ scripturl }}?p={{ project.GetProject()|url_encode }}&amp;a=atom"/>
  <id>{{ scripturl }}?p={{ project.GetProject()|url_encode }}</id>
  {% if log %}
  <updated>{{ log[0].GetCommitterEpoch()|date("Y-m-d\\TH:i:s+00:00") }}</updated>
  {% endif %}

{% for logitem in log %}
  <entry>
    <id>{{ scripturl }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ logitem.GetHash() }}</id>
    <title>{{ logitem.GetTitle()|escape }}</title>
    <author>
      <name>{{ logitem.GetAuthorName()|escape }}</name>
    </author>
    <published>{{ logitem.GetCommitterEpoch()|date("Y-m-d\\TH:i:s+00:00") }}</published>
    <updated>{{ logitem.GetCommitterEpoch()|date("Y-m-d\\TH:i:s+00:00") }}</updated>
    <link rel="alternate" href="{{ scripturl }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ logitem.GetHash() }}"/>
    <summary>{{ logitem.GetTitle()|escape }}</summary>
    <content type="xhtml">
      <div xmlns="http://www.w3.org/1999/xhtml">
        <p>
        {% for line in logitem.GetComment() %}
          {{ line|escape }}<br />
        {% endfor %}
        </p>
        <ul>
        {% for diffline in logitem.DiffToParent() %}
          <li>{{ diffline.GetToFile()|escape }}</li>
        {% endfor %}
        </ul>
      </div>
    </content>
  </entry>
{% endfor %}

</feed>
