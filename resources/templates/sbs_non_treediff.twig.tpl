<div class="SBSTOC">
    <table class="diff-file-list">
        {% set lastFileDiff = null %}
        {% for filediff in diff_source %}
        <tr class="filetype-{{ filediff.getToFileExtension() }} status-{{ filediff.getStatus()|lower }} folder-{{ filediff.getToFileRootFolder()|lower }}">
            <td>
                <span>{{ filediff.getStatus() }}</span>
            </td>
            <td class="file-name">
                <a class="SBSTOCItem" href="#{{ filediff.GetFromHash() }}_{{ filediff.GetToHash() }}" data-fromFile="{{ filediff.GetFromFile() }}" data-toFile="{{ filediff.GetToFile() }}" data-fromHash="{{ filediff.GetFromHash() }}" data-toHash="{{ filediff.GetToHash() }}">{{ filediff.getToFile() }}</a>
            </td>
            <td class="review-comments" data-fromFile="{{ filediff.GetFromFile() }}" data-toFile="{{ filediff.GetToFile() }}"></td>
        </tr>
            {% set lastFileDiff = filediff %}
        {% endfor %}
    </table>
</div>

<div class="SBSContent">
    {% include 'filediffsidebyside.twig.tpl' with {'diffsplit': lastFileDiff.GetDiffSplit()} %}
</div>