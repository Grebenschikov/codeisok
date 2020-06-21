From: {{ commit.GetAuthor() }}
Date: {{ commit.GetAuthorEpoch()|date("D, d M Y H:i:s O") }}
Subject: {{ commit.GetTitle() }}
{% set tag = commit.GetContainingTag() %}
{% if tag %}
X-Git-Tag: {{ tag.GetName() }}
{% endif %}
X-Git-Url: {{ scripturl }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ commit.GetHash() }}
---
{% for line in commit.GetComment() %}
{{ line }}
{% endfor %}
---


{% for filediff in commit_tree_diff %}
{{ filediff.GetDiff('', true, false, false) }}
{% endfor %}
