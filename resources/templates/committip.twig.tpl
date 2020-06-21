<div>
{% t %}author{% endt %}: {{ commit.GetAuthor() }} ({{ commit.GetAuthorEpoch()|date("Y-m-d H:i:s") }})
<br />
{% t %}committer{% endt %}: {{ commit.GetCommitter() }} ({{ commit.GetCommitterEpoch()|date("Y-m-d H:i:s") }})
<br /><br />
{% for line in commit.GetComment() %}
    {{ line|escape }}<br />
{% endfor %}
</div>
