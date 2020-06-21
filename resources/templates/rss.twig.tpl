<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/">
  <channel>
    <title>{{ project.GetProject() }}</title>
    <link>{{ scripturl }}?p={{ project.GetProject()|url_encode }}&amp;a=summary</link>
    <description>{{ project.GetProject() }} log</description>
    <language>en</language>

    {% for logitem in log %}
      <item>
        <title>{{ logitem.GetCommitterEpoch()|date("d M H:i") }} - {{ logitem.GetTitle()|escape }}</title>
        <author>{{ logitem.GetAuthor()|escape }}</author>
        <pubDate>{{ logitem.GetCommitterEpoch()|date("D, d M Y H:i:s O") }}</pubDate>
        <guid isPermaLink="true">{{ scripturl }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ logitem.GetHash() }}</guid>
        <link>{{ scripturl }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ logitem.GetHash() }}</link>
        <description>{{ logitem.GetTitle()|escape }}</description>
        <content:encoded>
          <![CDATA[
          {% for line in logitem.GetComment() %}
            {{ line }}<br />
          {% endfor %}
          {% for diffline in logitem.DiffToParent() %}
            {{ diffline.GetToFile() }}<br />
          {% endfor %}
          ]]>
        </content:encoded>
      </item>
    {% endfor %}
  </channel>
</rss>
