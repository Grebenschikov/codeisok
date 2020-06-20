<div id="create">
<div class="title">
    <strong>
    {% if edit_user is empty %}
        Create new user
    {% else %}
        Edit user
    {% endif %}
    </strong>
</div>
<div id="gitosisuser">
    <form action="" method="post" id="createform">
        <ul>
        {% for form_error in form_errors %}
            <li>{{ form_error }}</li>
        {% endfor %}
        </ul>
        <table class="git-admin-table">
            <tbody>
                <tr>
                    <td class="bold">Username: *</td>
                    <td><input type="text" name="username" class="text-input" value="{{ edit_user.username is defined ? edit_user.username|escape }}"
                               {% if edit_user.id is defined %}readonly=""{% endif %} /></td>
                </tr>
                <tr>
                    <td class="bold">Email:</td>
                    <td><input type="text" name="email" class="text-input" value="{{ edit_user.email is defined ? edit_user.email|escape }}"/></td>
                </tr>
                <tr>
                    <td class="bold">Public ssh key: *</td>
                    <td><textarea name="public_key" class="text-input">{{ edit_user.public_key is defined ? edit_user.public_key|escape }}</textarea></td>
                </tr>
                <tr>
                    <td class="bold">Access mode</td>
                    <td>
                        {% for access_mode in access_modes %}
                            <label><input type="radio" {% if ((loop.first and (edit_user is empty)) or not(edit_user is empty) and access_mode == edit_user.access_mode) %}checked=""{% endif %} name="access_mode" value="{{ access_mode }}"> {{ access_mode }}</label>
                        {% endfor %}
                    </td>
                </tr>
                <tr>
                    <td class="bold">Comment</td>
                    <td><textarea name="comment" class="text-input">{{ edit_user.comment is defined ? edit_user.comment|escape }}</textarea></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <a class="simple-button" href="#" onclick="document.getElementById('createform').submit();">Save</a>
                        <a class="simple-button" href="/?a=gitosis&section=users">Cancel</a>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</div>
</div>
<div class="title">
    <strong>Users</strong>
</div>
<table class="git-table">
    <tbody>
        <tr class="list_header">
            <th>Username</th>
            <th>Email</th>
            <th>Actions</th>
            <th>Comment</th>
            <th>Created</th>
            <th>Updated</th>
        </tr>
        {% for user in users %}
            <tr class="{{ ['light', 'dark'][loop.index % 2] }}">
                <td><a href="/?a=gitosis&section=access&user_id={{ user.id }}">{{ user.username|escape }}</a></td>
                <td>{{ user.email|escape }}</td>
                <td>
                    <a class="simple-button" href="/?a=gitosis&section=users&id={{ user.id }}">Edit</a>
                    <a class="simple-button" href="/?a=gitosis&section=users&id={{ user.id }}&delete=1"
                       onclick="return confirm('Are you really want deleting {{ user.username }}');">Delete</a>
                </td>
                <td>{{ user.comment|escape|nl2br }}</td>
                <td>{{ user.created }}</td>
                <td>{{ user.updated }}</td>
            </tr>
        {% endfor %}
    </tbody>
</table>
