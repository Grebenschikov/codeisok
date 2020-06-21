{% include 'header.twig.tpl' %}

<div class="title">
   <strong>Create new repository</strong>
</div>
<div id="gitosisrepository">
    <form action="" method="post" id="createform">
        <ul>
            {% for form_error in form_errors %}
                <li>{{ form_error }}</li>
            {% endfor %}
        </ul>
        <table class='git-table'>
            <tbody>
            <tr>
                <td class="bold">Project *</td>
                <td><input type="text" name="project" class="text-input" placeholder="project.git" value="{{ edit_project.project is defined ? edit_project.project|escape }}" {% if edit_project.id is defined and edit_project.id %}readonly=""{% endif %} /></td>
            </tr>
            <tr>
                <td class="bold">Description</td>
                <td><input type="text" name="description" class="text-input" placeholder="Some meaningful text" value="{{ edit_project.description is defined ? edit_project.description|escape }}" /></td>
            </tr>
            <tr>
                <td class="bold">Category</td>
                <td><input type="text" name="category" class="text-input" placeholder="PHP" value="{{ edit_project.category is defined ? edit_project.category|escape }}" /></td>
            </tr>
            <tr>
                <td class="bold">Notify email</td>
                <td><input type="text" name="notify_email" class="text-input" placeholder="your-team-email" value="{{ edit_project.notify_email is defined ? edit_project.notify_email|escape }}" /></td>
            </tr>
            <tr>
                <td class="bold">Restricted access</td>
                <td>
                    {% for restricted_mode in restricted %}
                        <label><input type="radio" {% if (loop.first and edit_project is empty) or (edit_project is defined and restricted_mode == edit_project.restricted) %}checked=""{% endif %} name="restricted" value="{{ restricted_mode }}"> {{ restricted_mode }}</label>
                    {% endfor %}
                    <sup>Restricted access is a special mark for repositories with strict controlled access</sup>
                </td>
            </tr>
            <tr>
                <td class="bold">Display</td>
                <td>
                    {% for display in displays %}
                        <label><input type="radio" {% if (loop.first and edit_project is empty) or (edit_project and display == edit_project.display) %}checked=""{% endif %} name="display" value="{{ display }}"> {{ display }}</label>
                        {% if display == 'Yes' %}<sup>Web server user must have access for repository directory</sup>{% endif %}
                    {% endfor %}
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <i>Your project will be created in one minute after form submission.
                    It's not allowed to change project's name upon creation.</i>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <a class="simple-button" href="#" onclick="document.getElementById('createform').submit();">Save repository</a>
                    <a class="simple-button" href="/">Cancel</a>
                </td>
            </tr>
            </tbody>
        </table>
    </form>
</div>

{% include 'footer.twig.tpl' %}