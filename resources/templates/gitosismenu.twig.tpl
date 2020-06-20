<div class="page_nav">
    <div class="title">
        {% for section in sections %}
            {% if not(loop.first) %} | {% endif %}
            {% if current_section == section %}
                {{ section|capitalize }}
            {% else %}
                <a href="/?a=gitosis&section={{ section }}">{{ section|capitalize }}</a>
            {% endif %}
        {% endfor %}
    </div>
</div>
