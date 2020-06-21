{% include 'header.twig.tpl' %}

<div class="message {% if error %}error{% endif %}">{{ message }}</div>

{% include 'footer.twig.tpl' %}