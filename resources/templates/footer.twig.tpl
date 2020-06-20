    <div class="page_footer">
        {% if project %}
            <div class="page_footer_text">{{ project.GetDescription() }}</div>
            <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=rss" class="rss_logo">{% t %}RSS{% endt %}</a>
            <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=atom" class="rss_logo">{% t %}Atom{% endt %}</a>
        {% else %}
            <a href="{{ SCRIPT_NAME }}?a=opml" class="rss_logo">{% t %}OPML{% endt %}</a>
            <a href="{{ SCRIPT_NAME }}?a=project_index" class="rss_logo">{% t %}TXT{% endt %}</a>
        {% endif %}

        {% if supportedlocales %}
            <div class="lang_select">
                <form action="{{ SCRIPT_NAME }}" method="get" id="frmLangSelect">
                    <div>
                        {% for var, val in requestvars %}
                            {% if var != "l" %}
                                <input type="hidden" name="{{ var|escape }}" value="{{ val|escape }}" />
                            {% endif %}
                        {% endfor %}
                        <label for="selLang">{% t %}language:{% endt %}</label>
                        <select name="l" id="selLang">
                            {% for locale, language in supportedlocales %}
                                <option {% if locale == currentlocale %}selected="selected"{% endif %} value="{{ locale }}">{% if language %}{{ language }} ({{ locale }}){% else %}{{ locale }}{% endif %}</option>
                            {% endfor %}
                        </select>
                        <input type="submit" value="{% t %}set{% endt %}" id="btnLangSet" />
                    </div>
                </form>
            </div>
        {% endif %}
    </div>
  </body>
</html>
