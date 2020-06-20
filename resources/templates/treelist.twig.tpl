{% for treeitem in tree.GetContents() %}
    {% if is_a(treeitem, '\\CodeIsOk\\Git\\Blob') %}
      <tr>
          <td class="list fileName">
              <span class="expander"></span>
              <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ treeitem.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ treeitem.GetPath() }}" class="list">{{ treeitem.GetName() }}</a>
          </td>
          <td class="filesize">
              {{ treeitem.GetSize() }}
          </td>
          <td class="link">
            <div class="actions">
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob&amp;h={{ treeitem.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ treeitem.GetPath() }}">{% t %}Blob{% endt %}</a>
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=history&amp;h={{ commit.GetHash() }}&amp;f={{ treeitem.GetPath() }}">{% t %}History{% endt %}</a>
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=blob_plain&amp;h={{ treeitem.GetHash() }}&amp;f={{ treeitem.GetPath() }}">{% t %}Plain{% endt %}</a>
            </div>
          </td>
      </tr>
    {% elseif is_a(treeitem, '\\CodeIsOk\\Git\\Tree') %}
      <tr>
          <td class="list folderName">
              <span class="expander" data-expand-url="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ treeitem.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ treeitem.GetPath() }}"></span>
              <a href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ treeitem.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ treeitem.GetPath() }}" class="treeLink">{{ treeitem.GetName() }}</a>
          </td>
          <td class="filesize">
          </td>
          <td class="link">
            <div class="actions">
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=tree&amp;h={{ treeitem.GetHash() }}&amp;hb={{ commit.GetHash() }}&amp;f={{ treeitem.GetPath() }}">{% t %}Tree{% endt %}</a>
                <a class="simple-button" href="{{ SCRIPT_NAME }}?p={{ project.GetProject()|url_encode }}&amp;a=snapshot&amp;h={{ commit.GetHash() }}&amp;f={{ treeitem.GetPath() }}" class="snapshotTip">{% t %}Snapshot{% endt %}</a>
            </div>
          </td>
      </tr>
    {% endif %}
{% endfor %}