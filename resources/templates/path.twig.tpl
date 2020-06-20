{% if pathobject %}
	<div class="title">
		{% set pathobjectcommit = pathobject.GetCommit() %}
		{% set pathobjecttree = pathobjectcommit.GetTree() %}
		<a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;hb={{ pathobjectcommit.GetHash() }}&amp;h={{ pathobjecttree.GetHash() }}"><strong>[{{ project.GetProject() }}]</strong></a> /
		{% for pathtreepiece in pathobject.GetPathTree() %}
			<a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;hb={{ pathobjectcommit.GetHash() }}&amp;h={{ pathtreepiece.GetHash() }}&amp;f={{ pathtreepiece.GetPath() }}"><strong>{{ pathtreepiece.GetName() }}</strong></a> /
		{% endfor %}
		{% if is_a(pathobject, '\\CodeIsOk\\Git\\Blob') %}
			{% if target == 'blobplain' %}
				<a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob_plain&amp;h={{ pathobject.GetHash() }}&amp;hb={{ pathobjectcommit.GetHash() }}&amp;f={{ pathobject.GetPath() }}"><strong>{{ pathobject.GetName() }}</strong></a>
			{% elseif target == 'blob' %}
				<a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ pathobject.GetHash() }}&amp;hb={{ pathobjectcommit.GetHash() }}&amp;f={{ pathobject.GetPath() }}"><strong>{{ pathobject.GetName() }}</strong></a>
			{% else %}
				<strong>{{ pathobject.GetName() }}</strong>
			{% endif %}
		{% elseif pathobject.GetName() %}
			{% if target == 'tree' %}
				<a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;hb={{ pathobjectcommit.GetHash() }}&amp;h={{ pathobject.GetHash() }}&amp;f={{ pathobject.GetPath() }}"><strong>{{ pathobject.GetName() }}</strong></a> /
			{% else %}
				<strong>{{ pathobject.GetName() }}</strong> /
			{% endif %}
		{% endif %}
	</div>
{% endif %}