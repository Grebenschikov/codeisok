{% include 'header.twig.tpl' %}

 <div class="page_nav">
   {% include 'nav.twig.tpl' with {'logcommit': commit, 'treecommit': commit, 'current': 'commit'} %}
 </div>

{% if commit.GetParent() %}
 	{% include 'title.twig.tpl' with {'titlecommit': commit, 'target': 'commitdiff', 'hasPageSearch': true} %}
{% else %}
	{% include 'title.twig.tpl' with {'titlecommit': commit, 'titletree': tree, 'target': 'tree', 'hasPageSearch': true} %}
{% endif %}

{# Commit data #}
<table class="git-table">
    <tr>
        <td>{% t %}Author{% endt %}</td>
        <td>{{ commit.GetAuthorName() }}</td>
    </tr>

    <tr>
        <td></td>
        <td> {{ commit.GetAuthorEpoch()|date("D, d M Y H:i:s O") }}
        {% set hourlocal = commit.GetAuthorLocalEpoch()|date("H") %}
        {% if hourlocal < 6 %}
            (<span class="latenight">{{ commit.GetAuthorLocalEpoch()|date("H:i") }}</span> {{ commit.GetAuthorTimezone() }})</td>
        {% else %}
            ({{ commit.GetAuthorLocalEpoch()|date("H:i") }} {{ commit.GetAuthorTimezone() }})</td>
        {% endif %}
    </tr>

    <tr>
        <td>{% t %}Committer{% endt %}</td>
        <td>{{ commit.GetCommitterName() }}</td>
    </tr>

    <tr>
        <td></td>
        <td>{{ commit.GetCommitterEpoch()|date("D, d M Y H:i:s O") }} ({{ commit.GetCommitterLocalEpoch()|date("H:i") }} {{ commit.GetCommitterTimezone() }})</td>
    </tr>

    <tr>
        <td>{% t %}Commit{% endt %}</td>
        <td>{{ commit.GetHash() }}</td>
    </tr>

    <tr>
        <td>{% t %}Tree{% endt %}</td>
        <td>
            <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ tree.GetHash() }}&amp;hb={{ commit.GetHash() }}" class="list">{{ tree.GetHash() }}</a>
            <div class="actions">
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ tree.GetHash() }}&amp;hb={{ commit.GetHash() }}">{% t %}Tree{% endt %}</a>
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=snapshot&amp;h={{ commit.GetHash() }}" class="snapshotTip">{% t %}Snapshot{% endt %}</a>
            </div>
        </td>
    </tr>

    {% set lastPar = null %}
    {% for par in commit.GetParents() %}
        <tr>
            <td>{% t %}Parent{% endt %}</td>
            <td>
            <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ par.GetHash() }}" class="list">{{ par.GetHash() }}</a>
            <div class="actions">
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commit&amp;h={{ par.GetHash() }}">{% t %}Commit{% endt %}</a>
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=commitdiff&amp;h={{ commit.GetHash() }}&amp;hp={{ par.GetHash() }}">{% t %}Commitdiff{% endt %}</a>
            </div>
            </td>
        </tr>
        {% set lastPar = par %}
    {% endfor %}
    {% set par = lastPar %}
</table>

<div class="title">
    {% set bugpattern = project.GetBugPattern() %}
    {% set bugurl = project.GetBugUrl() %}

    <strong>
        {% for line in commit.GetComment() %}
            {{ line|escape|buglink(bugpattern, bugurl) }}<br />
        {% endfor %}

        {% if treediff.Count() > 10 %}
            {% t count=treediff.Count() param1=treediff.Count() plural="%1 files changed:" %}%1 file changed:{% endt %}
        {% endif %}
    </strong>
</div>

<table class="git-table">
    {# Loop and show files changed #}
    {% for diffline in treediff %}
        <tr class="{{ ['light', 'dark'][loop.index % 2] }}">

        {% if diffline.GetStatus() == "A" %}
            <td>
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ diffline.GetToHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ diffline.GetFromFile() }}" class="list">
                    {{ diffline.GetFromFile() }}
                </a>
            </td>
            <td>
                <span class="newfile">
                    {% set localtotype = diffline.GetToFileType(1) %}
                    [
                    {% if diffline.ToFileIsRegular() %}
                    {% set tomode = diffline.GetToModeShort() %}
                    {% t param1=localtotype param2=tomode %}new %1 with mode %2{% endt %}
                    {% else %}
                    {% t param1=localtotype %}new %1{% endt %}
                    {% endif %}
                    ]
                </span>

                <div class="actions">
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ diffline.GetToHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ diffline.GetFromFile() }}">{% t %}Blob{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob_plain&amp;h={{ diffline.GetToHash() }}&amp;f={{ diffline.GetFromFile() }}">{% t %}Plain{% endt %}</a>
                </div>
            </td>

        {% elseif diffline.GetStatus() == "D" %}
            {% set parent = commit.GetParent() %}
            <td>
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ diffline.GetFromHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ diffline.GetFromFile() }}" class="list">
                    {{ diffline.GetFromFile() }}
                </a>
            </td>
            <td>
                <span class="deletedfile">
                    {% set localfromtype = diffline.GetFromFileType(1) %}
                    [ {% t param1=localfromtype %}deleted %1{% endt %} ]
                </span>

                <div class="actions">
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ diffline.GetFromHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ diffline.GetFromFile() }}">{% t %}Blob{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=history&amp;h={{ parent.GetHash() }}&amp;f={{ diffline.GetFromFile() }}">{% t %}History{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob_plain&amp;h={{ diffline.GetFromHash() }}&amp;f={{ diffline.GetFromFile() }}">{% t %}Plain{% endt %}</a>
                </div>
            </td>

        {% elseif diffline.GetStatus() == "M" or diffline.GetStatus() == "T" %}
            <td>
                {% if diffline.GetToHash() != diffline.GetFromHash() %}
                    <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blobdiff&amp;h={{ diffline.GetToHash() }}&amp;hp={{ diffline.GetFromHash() }}&amp;hb={{ par.GetHash() }}&amp;f={{ diffline.GetToFile() }}" class="list">
                        {{ diffline.GetToFile() }}
                    </a>
                {% else %}
                    <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ diffline.GetToHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ diffline.GetToFile() }}" class="list">
                        {{ diffline.GetToFile() }}
                    </a>
                {% endif %}
            </td>
            <td>
                {% if diffline.GetFromMode() != diffline.GetToMode() %}
                    <span class="changedfile">[
                        {% if diffline.FileTypeChanged() %}
                            {% set localfromtype = diffline.GetFromFileType(1) %}
                            {% set localtotype = diffline.GetToFileType(1) %}
                            {% if diffline.FileModeChanged() %}
                                {% if diffline.FromFileIsRegular() and diffline.ToFileIsRegular() %}
                                    {% set frommode = diffline.GetFromModeShort() %}
                                    {% set tomode = diffline.GetToModeShort() %}
                                    {% t param1=localfromtype param2=localtotype param3=frommode param4=tomode %}changed from %1 to %2 mode: %3 -> %4{% endt %}
                                {% elseif diffline.ToFileIsRegular() %}
                                    {% set tomode = diffline.GetToModeShort() %}
                                    {% t param1=localfromtype param2=localtotype param3=tomode %}changed from %1 to %2 mode: %3{% endt %}
                                {% else %}
                                    {% t param1=localfromtype param2=localtotype %}changed from %1 to %2{% endt %}
                                {% endif %}
                            {% else %}
                                {% t param1=localfromtype param2=localtotype %}changed from %1 to %2{% endt %}
                            {% endif %}
                        {% else %}
                            {% if diffline.FileModeChanged() %}
                                {% if diffline.FromFileIsRegular() and diffline.ToFileIsRegular() %}
                                    {% set frommode = diffline.GetFromModeShort() %}
                                    {% set tomode = diffline.GetToModeShort() %}
                                    {% t param1=frommode param2=tomode %}changed mode: %1 -> %2{% endt %}
                                {% elseif diffline.ToFileIsRegular() %}
                                    {% set tomode = diffline.GetToModeShort() %}
                                    {% t param1=tomode %}changed mode: %1{% endt %}
                                {% else %}
                                    {% t %}Changed{% endt %}
                                {% endif %}
                            {% else %}
                                {% t %}Changed{% endt %}
                            {% endif %}
                        {% endif %}
                    ]</span>
                {% endif %}

                <div class="actions">
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ diffline.GetToHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ diffline.GetToFile() }}">{% t %}Blob{% endt %}</a>
                    {% if diffline.GetToHash() != diffline.GetFromHash() %}
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blobdiff&amp;h={{ diffline.GetToHash() }}&amp;hp={{ diffline.GetFromHash() }}&amp;hb={{ par.GetHash() }}&amp;f={{ diffline.GetToFile() }}">{% t %}Diff{% endt %}</a>
                    {% endif %}
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=history&amp;h={{ commit.GetHash() }}&amp;f={{ diffline.GetFromFile() }}">{% t %}History{% endt %}</a>
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob_plain&amp;h={{ diffline.GetToHash() }}&amp;f={{ diffline.GetToFile() }}">{% t %}Plain{% endt %}</a>
                </div>
            </td>
        {% elseif diffline.GetStatus() == "R" %}
            <td>
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ diffline.GetToHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ diffline.GetToFile() }}" class="list">
                    {{ diffline.GetToFile() }}
                </a>
            </td>
            <td>
                <span class="movedfile">
                    {% set fromfilelink %}
                        <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ diffline.GetFromHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ diffline.GetFromFile() }}" class="list">{{ diffline.GetFromFile() }}</a>
                    {% endset %}
                    [
                        {% set similarity = diffline.GetSimilarity() %}
                        {% if diffline.GetFromMode() != diffline.GetToMode() %}
                            {% set tomode = diffline.GetToModeShort() %}
                            {% t escape=false param1=fromfilelink param2=similarity param3=tomode %}moved from %1 with %2%% similarity, mode: %3{% endt %}
                        {% else %}
                            {% t escape=false param1=fromfilelink param2=similarity %}moved from %1 with %2%% similarity{% endt %}
                        {% endif %}
                    ]
                </span>

                <div class="actions">
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ diffline.GetToHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ diffline.GetToFile() }}">{% t %}Blob{% endt %}</a>
                    {% if diffline.GetToHash() != diffline.GetFromHash() %}
                        <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blobdiff&amp;h={{ diffline.GetToHash() }}&amp;hp={{ diffline.GetFromHash() }}&amp;hb={{ par.GetHash() }}&amp;f={{ diffline.GetToFile() }}">{% t %}Diff{% endt %}</a>
                    {% endif %}
                    <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob_plain&amp;h={{ diffline.GetToHash() }}&amp;f={{ diffline.GetToFile() }}">{% t %}Plain{% endt %}</a>
                </div>
            </td>
        {% endif %}

        </tr>
    {% endfor %}
</table>

{% include 'footer.twig.tpl' %}

