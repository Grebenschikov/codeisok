<div>
{% t %}tag{% endt %}: {{ tag.GetName() }}
<br />
{% for line in tag->GetComment() %}
<br />{{ line }}
{% endfor %}
</div>
