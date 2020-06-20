{% if extensions %}
    <div class="file_filter">
        {% for st in statuses %}
            <span class="status selected" data-status="{{ st|lower }}">{{ st }}</span>
        {% endfor %}
        {% for ext in extensions %}
            <span class="extension selected" data-extension="{{ ext }}">{{ ext }}</span>
        {% endfor %}
        {% for folder in folders %}
            <span class="folder selected" data-folder="{{ folder|lower }}">{{ folder }}</span>
        {% endfor %}
        <span class="hint">(+Shift for single select)</span>
    </div>
{% endif %}