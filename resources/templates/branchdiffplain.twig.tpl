{% for filediff in branchdiff %}
    {{ filediff.GetDiff('', true, false, false) }}
{% endfor %}
