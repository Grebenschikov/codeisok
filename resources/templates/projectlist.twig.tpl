{% include 'header.twig.tpl' %}

<div class="projectSearch">
    <form method="post" action="index.php" id="projectSearchForm"
            enctype="application/x-www-form-urlencoded">

        <span class="project-filter-container">
            <input type="text"
                id="projectSearchForm"
                name="s"
                {% if searchmode == 1 %}disabled="disabled"{% endif %}
                class="text-input projectSearchBox" {% if search %}value="{{ search|escape }}"{% endif %}
                placeholder="{% t %}Filter projects{% endt %}" />

            {% if javascript %}
                <img src="/images/loader.gif" class="searchSpinner" style="display: none;"/>
            {% endif %}

            <a href="index.php?a" class="clearSearch"
                {% if not(search) %}style="display: none;"{% endif %}>x
            </a>
        </span>

        <span class="project-search-container">
            <input type="text"
                name="t"
                placeholder="Search text in project heads"
                value="{{ text }}"
                class="text-input"
                onkeydown="keydownSearchField(this);"></input>

            <input class="search" type="button" onclick="submitSearchForm(this);" value="Go" />
        </span>

        <span class="error-text" id="error"></span>

        {% if searchmode == 1 %}
            <a href="index.php">Cancel</a>
        {% endif %}
    </form>

    {% if allow_create_projects %}
        <a class="simple-button create-project" href="/?a=project_create">New repo</a>
    {% endif %}
</div>

<table cellspacing="0" class="git-table git-table-expanded project-list">
  {% for proj in projectlist %}
    {% if loop.first %}
      <tr class="projectHeader list_header">
        <th class="project-select"><input class="checkbox-input" type='checkbox' id='selectall' onclick='toggleCheckBoxes(this);'/></th>

        {% if order == "project" %}
            <th class="project-name">{% t %}Project{% endt %} ▼</th>
        {% else %}
            <th class="project-name"><a class="header" href="{{ SCRIPT_NAME }}?o=project">{% t %}Project{% endt %}</a></th>
        {% endif %}

        {% if order == "descr" %}
            <th class="project-desc">{% t %}Description{% endt %} ▼</th>
        {% else %}
            <th class="project-desc"><a class="header" href="{{ SCRIPT_NAME }}?o=descr">{% t %}Description{% endt %}</a></th>
        {% endif %}

        {% if order == "owner" %}
            <th class="project-owner">{% t %}Owner{% endt %} ▼</th>
        {% else %}
            <th class="project-owner"><a class="header" href="{{ SCRIPT_NAME }}?o=owner">{% t %}Owner{% endt %}</a></th>
        {% endif %}

        {% if order == "age" %}
            <th class="project-age">{% t %}Last change{% endt %} ▼</th>
        {% else %}
            <th class="project-age"><a class="header" href="{{ SCRIPT_NAME }}?o=age">{% t %}Last change{% endt %}</a></th>
        {% endif %}
      </tr>
    {% endif %}

    {% if currentcategory != proj.GetCategory() %}
        {% set currentcategory = proj.GetCategory() %}
        {% if currentcategory != '' %}
            <tr class="light categoryRow list_header">
                <th class="categoryName" colspan="6">
                    <span class="expander-folder expanded"></span>
                    {{ currentcategory }}
                </th>
            </tr>
        {% endif %}
    {% endif %}

    <tr class="projectRow">
        {% set currentproject = proj.GetProject() %}
        <td><input class="checkbox-input projects_checkbox" type='checkbox' name='projects[{{ currentproject }}]' value='1' {% if projects[currentproject] is defined %}checked="checked"{% endif %}></td>

        <td class="projectName">
            <a href="{{ SCRIPT_NAME }}?p={{ currentproject|url_encode }}&amp;a=summary" class="list {% if currentcategory != '' %}indent{% endif %}">{{ currentproject }}</a>
        </td>

        <td class="projectDescription">
            <a href="{{ SCRIPT_NAME }}?p={{ currentproject|url_encode }}&amp;a=summary" class="list">{{ proj.GetDescription() }}</a>
        </td>

        <td class="projectOwner"><em>{{ proj.GetOwner()|escape }}</em>
            {% if proj.GetNotifyEmail() %}
                <i>({{ proj.GetNotifyEmail()|escape }})</i>
            {% endif %}
        </td>

        {% set projecthead = proj.GetHeadCommit() %}
        <td class="projectAge">
            {% if projecthead %}
                {% if proj.GetAge() < 7200 %}   {# 60*60*2, or 2 hours #}
                    <span class="agehighlight"><strong><em>{{ proj.GetAge()|agestring }}</em></strong></span>
                {% elseif  proj.GetAge() < 172800 %}   {# 60*60*24*2, or 2 days #}
                    <span class="agehighlight"><em>{{ proj.GetAge()|agestring }}</em></span>
                {% else %}
                    <em>{{ proj.GetAge()|agestring }}</em>
                {% endif %}
	        {% else %}
	            <em class="empty">{% t %}No commits{% endt %}</em>
	        {% endif %}

            <div class="actions">
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ currentproject|url_encode }}&amp;a=summary">{% t %}Summary{% endt %}</a>
	            {% if projecthead %}
	                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ currentproject|url_encode }}&amp;a=shortlog">{% t %}Short Log{% endt %}</a>
	                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ currentproject|url_encode }}&amp;a=log">{% t %}Log{% endt %}</a>
	                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ currentproject|url_encode }}&amp;a=tree">{% t %}Tree{% endt %}</a>
	            {% endif %}
            </div>
        </td>
    </tr>

    {% if searchmode == 1 and projects[currentproject] is defined %}
        <tr class="{{ ['light', 'dark'][loop.index % 2] }}">
            <td colspan="6" class="code-search-results" id="searchresults[{{ currentproject }}]">
                <img src="/images/loader.gif" class="searchSpinner" onload='getSearchResults("{{ text|url_encode }}", "{{ currentproject }}", this);'/> Loading...
            </td>
        </tr>
    {% endif %}

    {% else %}
        {% if search %}
            <div class="message">{% t param1=search %}No matches found for "%1"{% endt %}</div>
        {% else %}
            <div class="message">{% t %}No projects found{% endt %}</div>
        {% endif %}
    {% endfor %}
</table>

{% include 'footer.twig.tpl' %}