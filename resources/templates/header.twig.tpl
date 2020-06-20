<!DOCTYPE html>
<html dir="ltr">
  <head>
    <title>
        {{ project ? (project.GetProject() ~ (actionlocal ? '/' ~ actionlocal)) : 'codeisok' }}
    </title>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

    {% if project %}
        <link rel="alternate" title="{{ project.GetProject() }} log (Atom)" href="{{ SCRIPT_NAME }}?p={{ project.GetProject() | url_encode }}&amp;a=atom" type="application/atom+xml" />
        <link rel="alternate" title="{{ project.GetProject() }} log (RSS)" href="{{ SCRIPT_NAME}}?p={{ project.GetProject()|url_encode }}&amp;a=rss" type="application/rss+xml" />
    {% endif %}

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon.png" />

    {% if extracss %}
        <style type="text/css">
            {{ extracss }}
        </style>
    {% endif %}

    {% if extracss_files %}
        {% for css_file in extracss_files %}
            <link rel="stylesheet" href="/{{ css_file }}?v={{ cssversion }}" type="text/css" />
        {% endfor %}
    {% endif %}

    <link rel="stylesheet" href="/css/gitphp.css?v={{ cssversion }}" type="text/css" />
    <link rel="stylesheet" href="/css/{{ stylesheet }}?v={{ cssversion }}" type="text/css" />
    <link rel="stylesheet" href="/css/review.css?v={{ cssversion }}" type="text/css" />
    {% if javascript %}
        <script type="text/javascript">
            var GITPHP_RES_LOADING="{% t escape='js' %}Loading…{% endt %}";
            var GITPHP_RES_LOADING_BLAME_DATA="{% t escape='js' %}Loading blame data…{% endt %}";
            var GITPHP_RES_SNAPSHOT="{% t escape='js' %}snapshot{% endt %}";
            var GITPHP_RES_NO_MATCHES_FOUND='{% t escape=false %}No matches found for "%1"{% endt %}';
            var GITPHP_SNAPSHOT_FORMATS = {
                {% for format, extension in snapshotformats %}
                    "{{ format }}": "{{ extension }}"{{ not(loop.last) ? ',' }}
                {% endfor %}
            }
        </script>
        <link rel="stylesheet" href="/css/ext/jquery.qtip.css" type="text/css" />
        <script type="text/javascript" src="/js/ext/jquery-1.8.2.min.js"></script>
        <script type="text/javascript" src="/js/utils.js?v={{ jsversion }}"></script>
        <script type="text/javascript" src="/js/review.js?v={{ jsversion }}"></script>
        <script type="text/javascript" src="/js/suppresseddiff.js?v={{ jsversion }}"></script>
        <script type="text/javascript" src="/js/ext/jquery.qtip.min.js"></script>
        <script type="text/javascript" src="/js/ext/jquery.cookie.js"></script>
        <script type="text/javascript" src="/js/diff.js?v={{ jsversion }}"></script>
        <script type="text/javascript" src="/js/session_checker.js?v={{ jsversion }}"></script>
        <script type="text/javascript" src="/js/tooltips.min.js?v={{ jsversion }}"></script>
        <script type="text/javascript" src="/js/lang.min.js?v={{ jsversion }}"></script>
        {% for script in extrascripts %}
            <script type="text/javascript" src="/js/{{ script }}.js?v={{ jsversion }}"></script>
        {% endfor %}
    {% endif %}

    {% if extrajs_files %}
        {% for js_file in extrajs_files %}
            <script type="text/javascript" src="/{{ js_file }}?v={{ jsversion }}"></script>
        {% endfor %}
    {% endif %}

    {% if fixlineheight %}
        <link rel="stylesheet" href="/css/fix_lineheight.css?v={{ cssversion }}" type="text/css" />
    {% endif %}
  </head>
  <body>
    <div id="session_checker">
        <div id="session_checker_popup">
            Connectivity problem! Please <a href="{{ url_login }}" target="_blank">login</a>.
        </div>
    </div>

    {% if not(no_user_header) %}
    <div class="page_header {{ adminarea ? 'adminheader' }}">
        <a class="logo" href="index.php?a">codeisok</a>

        <div class="user_block">
            {% if Session.isAuthorized() %}
                {{ user_name }} ({% if is_gitosis_admin and not(adminarea) %}<a href="{{ url_gitosis }}">Admin</a>, {% endif %}<a href="{{ url_logout }}">Logout</a>)
            {% else %}
                <a href="{{ url_login }}">{{ user_name }}</a>
            {% endif %}
        </div>

        <span class="project-path">
            {% if adminarea %}
                <a href="/">⟵ projects list</a>
            {% endif %}

            {% if project %}
                <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=summary">{{ project.GetProject() }}</a>
                {% if actionlocal %}
                    / {{ actionlocal }}
                {% endif %}
            {% endif %}
        </span>
    </div>
    {% endif %}

    {% if project %}
        <div class="page-search">

            {% if action == 'commitdiff' or action == 'branchdiff' %}
                <div class="gear-icon js-show-extra-settings">
                    <div class="extra-settings">
                        {% if action == 'commitdiff' or action == 'branchdiff' %}
                            <div class="search-panel">Ignore format <input id="diff-ignore-format" class="checkbox-input" type="checkbox" {% if ignoreformat %}checked="checked"{% endif %}/></div>
                            <div class="search-panel">Ignore whitespace <input id="diff-ignore-whitespace" class="checkbox-input" type="checkbox" {% if ignorewhitespace %}checked="checked"{% endif %}/></div>
                            <div class="search-panel">Context <input class="text-input" type="text" size="2" id="diff-context" {% if diffcontext %}value="{{ diffcontext }}"{% endif %} /></div>
                        {% endif %}
                    </div>
                </div>
            {% endif %}

            {% if enablebase %}
                <form class="search-panel" action="{{ SCRIPT_NAME }}" method="get">
                    {% for var, val in requestvars %}
                        {% if var != "base" %}
                            <input type="hidden" name="{{ var|escape }}" value="{{ val|escape }}" />
                        {% endif %}
                    {% endfor %}
                    Compare with
                    <select class="select-input" {{ base_disabled ? 'disabled="disabled"' }} name='base' onchange='this.form.submit();'>
                        {% for branch in base_branches %}
                            <option {{ branch == base ? 'selected="selected"' }} value='{{ branch }}'>{{ branch }}</option>
                        {% endfor %}
                    </select>
                </form>
            {% endif %}

            {% if enablesearch %}
                <form class="search-panel" method="get" action="index.php" enctype="application/x-www-form-urlencoded">
                    <input type="hidden" name="p" value="{{ project.GetProject() }}" />
                    <input type="hidden" name="a" value="search" />
                    <input type ="hidden" name="h" value="{{ commit ? commit.GetHash() : 'HEAD' }}" />
                    <select class="select-input" name="st">
                        <option {% if searchtype == 'commit' %}selected="selected"{% endif %} value="commit">{% t %}Commit{% endt %}</option>
                        <option {% if searchtype == 'author' %}selected="selected"{% endif %} value="author">{% t %}Author{% endt %}</option>
                        <option {% if searchtype == 'committer' %}selected="selected"{% endif %} value="committer">{% t %}Committer{% endt %}</option>
                        {% if filesearch %}
                            <option {% if searchtype == 'file' %}selected="selected"{% endif %} value="file">{% t %}File{% endt %}</option>
                        {% endif %}
                    </select>
                    <input class="text-input" placeholder="Search" type="text" name="s" {% if search %}value="{{ search|escape }}"{% endif %} />
                </form>
            {% endif %}

        </div>
    {% endif %}

    <div id="notifications"></div>
