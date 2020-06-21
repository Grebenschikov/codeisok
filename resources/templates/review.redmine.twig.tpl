{% for DIFF_OBJ in DIFF_OBJS %}
{% for HEAD in DIFF_OBJ.HEADER %}
{{ HEAD.header }}
{% endfor %}
{% for TC in DIFF_OBJ.TOP_COMMENT %}
</pre>
>*{{ TC.date }} {{ TC.author }}:* _{{ TC.comment }}_
<pre>
{% endfor %}
{% for L in DIFF_OBJ.LINE %}
{% if L.SEPARATOR is defined %}
{% for S in L.SEPARATOR %}
</pre>
----
<pre>
{% endfor %}
{% endif %}
{{ L.line_numbers }}{{ L.line }}
{% for C in L.COMMENT %}
</pre>
>*{{ C.date }} {{ C.author }}:* _{{ C.comment }}_
<pre>
{% endfor %}
{% endfor %}
{% endfor %}
