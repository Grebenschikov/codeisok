{% for DIFF_OBJ in DIFF_OBJS %}
    {% for HEAD in DIFF_OBJ.HEADER %}
        <div style="color:#006699;white-space:pre;font-weight:700;">{{ HEAD.header }}</div>
    {% endfor %}

    {% for TC in DIFF_OBJ.TOP_COMMENT %}
        <div style="color:blue;background:#EEEEEE;">
        <span style="color:#777777;font-size:11px;margin-left:20px;text-decoration:underline;">{{ TC.date }} {{ TC.author }}:</span>
        {{ TC.comment }}
        </div>
    {% endfor %}

    {% for L in DIFF_OBJ.LINE %}
        {% if L.SEPARATOR is defined %}
            {% for S in L.SEPARATOR %}
            <hr/>
            {% endfor %}
        {% endif %}
        <div style="color: {{ L.color }};white-space:pre;">{{ L.line_numbers }}{{ L.line }}</div>
        {% for C in L.COMMENT %}
            <div style="color:blue;background:#EEEEEE;">
                <span style="color:#777777;font-size:11px;margin-left:20px;text-decoration:underline;">{{ C.date }} {{ C.author }}:</span>
                {{ C.comment }}
            </div>
        {% endfor %}
    {% endfor %}
{% endfor %}
