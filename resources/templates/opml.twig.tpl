<?xml version="1.0" encoding="utf-8"?>
<opml version="1.0">
  <head>
    <title>{{ pagetitle }} OPML Export</title>
  </head>
  <body>
    <outline text="git Atom feeds">

      {% foreach proj in projectlist %}
      <outline type="rss" text="{{ proj.GetProject() }}" title="{{ proj.GetProject() }}" xmlUrl="{{ scripturl }}?p={{ proj.GetProject()|url_encode }}&amp;a=atom" htmlUrl="{{ scripturl }}?p={{ proj.GetProject()|url_encode }}&amp;a=summary" />
      {% endfor %}
    </outline>
  </body>
</opml>
