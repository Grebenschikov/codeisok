<div class="title">
    <strong>Users repositories access</strong>
    {% if scope == 'user' %}
        by user | <a href="/?a=gitosis&section=access&scope=repo">by repository</a>
    {% endif %}
    {% if scope == 'repo' %}
        <a href="/?a=gitosis&section=access&scope=user">by user</a> | by repository
    {% endif %}
</div>
<div id="gitosisaccess">
{% if scope == 'user' %}
    <table class="git-table">
        <tr class="list_header">
            <th>Username</th>
            <th>Project</th>
            <th>Mode</th>
            <th>Actions</th>
            <th></th>
        </tr>
        {% for user in users %}
        <form method="post" action="" id="form_user_{{ user.id }}">
            <input type="hidden" name="user_id" value="{{ user.id }}" />
            <tr class="['light', 'dark'][loop.index % 2]" id="{{ user.username }}">
                <td>
                    <p>{{ user.username }}</p>
                    {% if user.access_mode == 'everywhere' or user.access_mode == 'everywhere-ro' %}<small class="warning">only restricted repos shown</small>{% endif %}
                </td>
                <td>
                    <select name="projects_ids[]" multiple="" size="10" class='select-input'>
                    {% if user.access_mode == 'everywhere' or user.access_mode == 'everywhere-ro' %}
                        {% for project in restricted_projects %}
                            <option value="{{ project.id }}">{{ project.project }}</option>
                        {% endfor %}
                    {% else %}
                        {% for project in projects %}
                            <option value="{{ project.id }}">{{ project.project }}</option>
                        {% endfor %}
                    {% endif %}
                    </select>
                </td>
                <td nowrap>
                    <label><input type="radio" name="mode" value="writable" /> writable</label>
                    <label><input type="radio" name="mode" value="readonly" /> readonly</label>
                    <label><input type="radio" name="mode" value="" /> no</label>
                </td>
                <td>
                    <a class="simple-button" href="#" onclick="document.getElementById('form_user_{{ user.id }}').submit();">Grant access</a>
                </td>
                <td>
                {% for mode, projects_ids in access[user.id] %}
                    <ol>
                        <b>{{ mode }}</b>:
                        {% for project_id in projects_ids %}
                            <li>
                                <a href="/?p={{ projects[project_id].project }}&a=summary">{{ projects[project_id].project }}</a>
                            </li>
                        {% endfor %}
                    </ol>
                {% endfor %}
                </td>
            </tr>
        </form>
        {% endfor %}
    </table>
{% elseif scope == 'repo' %}
    <table class="git-table">
        <tr class="list_header">
            <th>Project</th>
            <th>User</th>
            <th>Mode</th>
            <th>Actions</th>
            <th></th>
        </tr>
        {% for project in projects %}
        <form method="post" action="" id="form_repo_{{ project.id }}">
            <input type="hidden" name="project_id" value="{{ project.id }}" />
            <tr class="{{ ['light', 'dark'][loop.index % 2] }}" id="{{ project.project }}">
                <td>
                    <p><a href="/?p={{ project.project }}&a=summary">{{ project.project }}</a></p>
                    {% if project.restricted == 'Yes' %}
                        <small class="warning">Restricted repo!</small>
                        {% if project.owner and project.owners %}
                            <br/><small class="warning">Owner(s):</small>
                            <ul class="owners-list">
                            {% for owner in project.owners %}
                                <li><a href="mailto:{{ owner }}">{{ owner }}</a></li>
                            {% endfor %}
                            </ul>
                        {% endif %}
                    {% endif %}
                </td>
                <td>
                    <select name="user_ids[]" multiple="" size="10" class="select-input">
                    {% for user in users %}
                        <option value="{{ user.id }}">{{ user.username }}</option>
                    {% endfor %}
                    </select>
                </td>
                <td nowrap>
                    <label><input type="radio" name="mode" value="writable" /> writable</label>
                    <label><input type="radio" name="mode" value="readonly" /> readonly</label>
                    <label><input type="radio" name="mode" value="" /> no</label>
                </td>
                <td>
                    <a class="simple-button" href="#" onclick="document.getElementById('form_repo_{{ project.id }}').submit();">Grant access</a>
                </td>
                <td>
                {% if access[project.id] is defined %}
                    {% for mode, user_ids in access[project.id] %}
                        <ol>
                            <b>{{ mode }}</b>:
                            {% for  user_id in user_ids %}
                                <li>
                                    {{ users[user_id].username }}
                                </li>
                            {% endfor %}
                        </ol>
                    {% endfor %}
                {% endif %}
                </td>
            </tr>
        </form>
        {% endfor %}
    </table>
{% endif %}
</div>
