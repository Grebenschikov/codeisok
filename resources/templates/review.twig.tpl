{% include "header.twig.tpl" %}

<div class="page_nav">
    {% include 'nav.twig.tpl' with {'commit': head, 'current': 'review'} %}
</div>


<table class="git-table">
    <thead>
        <tr class="list_header">
            <th>Review</th>
            <th>Ticket / Review Name</th>
            <th>Comments count</th>
            <th>Type</th>
            <th>Link</th>
        </tr>
    </thead>
    <tbody>
        {% for snapshot in snapshots %}
            <tr>
                <td>
                    {{ snapshot.review_id }}
                </td>
                <td>
                    {% if snapshot.ticket_url %}
                        <a href="{{ snapshot.ticket_url }}">{{ snapshot.ticket }}</a>
                    {% else %}
                        {{ snapshot.ticket }}
                    {% endif %}
                </td>
                <td>
                    {{ snapshot.count }}
                </td>
                <td>
                    {{ snapshot.review_type }}
                </td>
                <td style="font-family: Menlo, Monaco, 'Courier New', monospace;">
                    <a href="{{ snapshot.url }}">{{ snapshot.title }}</a>
                </td>
            </tr>
        {% endfor %}
        <tr>
            <td colspan='5'>
            {% if to_start_link %}
                <a class="simple-button" href="{{ to_start_link }}">&larr; to start</a>
            {% endif %}
            {% if more_link %}
                <a class="simple-button" href="{{ more_link }}">more &rarr;</a>
            {% endif %}
            </td>
        </tr>
    </tbody>
</table>

{% include "footer.twig.tpl" %}