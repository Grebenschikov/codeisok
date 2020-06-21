<link rel="stylesheet" href="/css/treediff.css?v={{ cssversion }}" type="text/css" />

<script>
window.sbsTreeDiff = true;

var _file_list = [
    {% set lastFileDiff = null %}
    {% for filediff in diff_source %}
        {
            path: '{{ filediff.getToFile() }}',
            status: '{{ filediff.getStatus()|lower }}',
            fileType: '{{ filediff.getToFileExtension() }}',
            data: {
                fromhash: "{{ filediff.GetFromHash() }}",
                fromfile: "{{ filediff.GetFromFile() }}",
                tohash: "{{ filediff.GetToHash() }}",
                tofile: "{{ filediff.GetToFile() }}"
            }
        },
        {% set lastFileDiff = filediff %}
    {% endfor %}
];
</script>

<div class="two-panes SBSTOC is-loading">
    <div class="js-left-pane left-pane">
        <ul class="file-list">
        </ul>
    </div>

    <div class="js-pane-dragger pane-dragger"></div>

    <div id="compare" class="right-pane SBSComparison SBSContent">
        {% include 'filediffsidebyside.twig.tpl' with {'diffsplit': lastFileDiff.GetDiffSplit(), 'noCompareBlock': true} %}
    </div>
</div>