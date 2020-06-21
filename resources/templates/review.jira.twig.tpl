{% for DIFF_OBJ in DIFF_OBJS %}
{% for HEAD in DIFF_OBJ.HEADER %}
{{ HEAD.header }}
{% endfor %}
{% TC in DIFF_OBJ.TOP_COMMENT %}
{code}{quote}{{ TC.date }} {{ TC.author }}: {{ TC.comment }}{quote}{code}
{% endfor %}
{% for L in DIFF_OBJ.LINE %}
{% if L.SEPARATOR is defined %}
{% for S in L.SEPARATOR %}
{code}
----
{code}
{% endfor %}
{% endif %}
{{ L.line_numbers }}{{ L.line }}
{% for C in L.COMMENT %}
{code}{quote}{{ C.date }} {{ C.author }}: {{ C.comment }}{quote}{code}
{% endfor %}
{% endfor %}
{% endfor %}
