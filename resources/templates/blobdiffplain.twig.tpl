{% set diff = filediff.GetDiff(file, false) %}
{% if escape %}
    {{ diff|escape }}
{% else %}
    {{ diff }}
{% endif %}
