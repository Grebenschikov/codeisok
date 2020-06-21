<script src="/js/sbs_review.js?v={{ jsversion }}"></script>

{% if not(noCompareBlock is defined) or not(noCompareBlock) %}
    <div id="compare" class="SBSComparison"></div>
{% endif %}

 <script>
 var id = '';
 var cm_mode = 'clike';
 var compare = $('#compare');
 var review;
 var reviewCache = new Object();

 $(document).delegate('.SBSTOC a', 'click', function (e) {
    e.preventDefault();

    const link = $(this);
    const data = link.data();

    if (!data.fromhash) {
        return;
    }

    loadSBS(data.fromhash, data.fromfile, data.tohash, data.tofile, function () {
        $('.SBSTOC').removeClass('is-loading');
    });

    // to account for both treediff and non-treediff modes
    $('.SBSTOC a, .SBSTOC li').removeClass('is-active');

    link.addClass('is-active is-visited');
    link.parent('li').addClass('is-active is-visited');
 });

 function loadSBS(fromHash, fromFile, toHash, toFile, callback) {
    var review_file = $('#review_file');
    if (!review_file.length) {
        $('.page_body').prepend($('<input type="hidden" id="review_file" value="' + toFile + '">'));
    } else {
        review_file.val(toFile);
    }

    if (review != undefined) {
        review.pause();
    }

    var reviewKey = fromHash + fromFile + toHash + toFile;
    if (reviewCache[reviewKey] != undefined) {
        review = reviewCache[reviewKey];
    } else {
        review = new SideBySideReview();
        reviewCache[reviewKey] = review;
    }

    $('.SBSTOC').addClass('is-loading');

    var modes = {'lhs':{"file":fromFile, "hash":fromHash}, 'rhs':{"file":toFile, "hash":toHash}};
    function request(mode) {
        $.ajax({
            type: 'GET', async: true, dataType: 'text',
            url: '{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&a=blob_plain&h=' + modes[mode].hash + '&f=' + modes[mode].file,
            success: function (response, textStatus, request) {
                content_type = request.getResponseHeader('Content-Type');
                if (content_type.indexOf("text") === -1 && content_type.indexOf("xml") === -1) {
                    response = "Binary data...";
                }
                cm_mode = request.getResponseHeader('Cm-mode');
                compare.mergely(mode, response);
                var resp_length = 0;
                if (response) {
                    resp_length = response.split("\n").length;
                }
                $('.page_body').prepend($('<input type="hidden" id="' + mode + '_length" value="' + resp_length + '">'));
                compare.mergely('cm', mode).setOption('mode', cm_mode);
                hideLoader(callback);
            }
        });
    }
    for (mode in modes) {
        request(mode);
    }

    var oneSideLoaded = false;
    function hideLoader(callback) {
        if (oneSideLoaded) {
            review.setCompareElement(compare);

            var backup_function = compare.mergely('options').updated;
            compare.mergely('options').updated = function () {
                compare.mergely('options').updated = backup_function;
                review.restore();
                compare.mergely('resize');
                callback();
            };

            compare.mergely('update');
        }

        oneSideLoaded = true;
    }
 }

 $(document).ready(function () {
    const bodyStyle = getComputedStyle(document.body);
    const editorHeight = `${document.body.offsetHeight - compare.offset().top - parseInt(bodyStyle.paddingBottom) - 20}px`;

    if (window.sbsTreeDiff) {
        $('.SBSTOC').height(editorHeight);
        $('.js-left-pane').height(editorHeight);
    }

    compare.mergely({
        cmsettings: { readOnly: 'nocursor', lineNumbers: true, viewportMargin: Infinity },
        editor_width: '40%',
        editor_height: window.sbsTreeDiff ? editorHeight : `${window.innerHeight - 150}px`,
        {% if ignorewhitespace %}
            ignorews: true
        {% endif %}
    });
 });

 $(function(){
    $('.SBSTOC a:first').click();
 });

 </script>