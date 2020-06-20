<div class="title">
    <strong>
    {% if edit_project is empty %}
        Create new repository
    {% else %}
        Edit repository
    {% endif %}
    </strong>
</div>
<div id="gitosisrepository">
    <form action="" method="post" id="createform">
        <ul>
        {% for form_error in form_errors %}
            <li>{{ form_error }}</li>
        {% endfor %}
        </ul>
        <table class="git-admin-table">
            <tbody>
            <tr>
                <td class="bold">Project: *</td>
                <td><input type="text" name="project" class="text-input" value="{{ edit_project.project is defined ? edit_project.project|escape }}" {% if edit_project.id is defined %}readonly=""{% endif %} /></td>
            </tr>
            <tr>
                <td class="bold">Description</td>
                <td><input type="text" name="description" class="text-input" value="{{ edit_project.description is defined ? edit_project.description|escape }}" /></td>
            </tr>
            <tr>
                <td class="bold">Category</td>
                <td><input type="text" name="category" class="text-input" value="{{ edit_project.category is defined ? edit_project.category|escape }}" /></td>
            </tr>
            <tr>
                <td class="bold">Notify email</td>
                <td><input type="text" name="notify_email" class="text-input" value="{{ edit_project.notify_email is defined ? edit_project.notify_email|escape }}" /></td>
            </tr>
            <tr>
                <td class="bold">Restricted access</td>
                <td>
                    {% for restricted_mode in restricted %}
                        <label><input type="radio" {% if ((loop.first and (edit_project is empty)) or (not(edit_project is empty) and restricted_mode == edit_project.restricted)) %}checked=""{% endif %} name="restricted" value="{{ restricted_mode }}"> {{ restricted_mode }}</label>
                    {% endfor %}
                </td>
            </tr>
            <tr>
                <td class="bold">Owner(s)</td>
                <td><input type="text" name="owner" class="text-input" value="{{ edit_project.owner is defined ? edit_project.owner|escape }}" /></td>
            </tr>
            <tr>
                <td class="bold">Display</td>
                <td>
                    {% for display in displays %}
                        <label><input type="radio" {% if ((loop.first and (edit_project is empty)) or (not(edit_project is empty) and display == edit_project.display)) %}checked=""{% endif %} name="display" value="{{ display }}"> {{ display }}</label>
                        {% if display == 'Yes' %}<sup>web server user must have access for repository directory</sup>{% endif %}
                    {% endfor %}
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <a class="simple-button" href="#" onclick="document.getElementById('createform').submit();">Save</a>
                    <a class="simple-button" href="/?a=gitosis&section=repositories">Cancel</a>
                </td>
            </tr>
            </tbody>
        </table>
    </form>
</div>
<div class="title">
    <strong>Repositories</strong>
</div>
<table class="git-table">
    <tbody>
    <tr class="list_header">
        <th>Project</th>
        <th>Actions</th>
        <th>Description</th>
        <th>Category</th>
        <th>Notify email</th>
        <th>Display</th>
        <th>Created</th>
        <th>Updated</th>
    </tr>
    {% for project in projects %}
    <tr class="{{ ['light', 'dark'][loop.index % 2] }}">
        <td>
            <a href="/?a=gitosis&section=access&scope=repo&project_id={{ project.id }}">{{ project.project|escape }}</a>
        </td>
        <td><a class="simple-button" href="/?a=gitosis&section=repositories&id={{ project.id }}">Edit</a></td>
        <td>{{ project.description|escape }}</td>
        <td>{{ project.category|escape }}</td>
        <td>{{ project.notify_email|escape }}</td>
        <td>{{ project.display }}</td>
        <td>{{ project.created }}</td>
        <td>{{ project.updated }}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>
