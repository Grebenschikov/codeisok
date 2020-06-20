{*
 *  blob.tpl
 *  gitphp: A PHP git repository browser
 *  Component: Blob view template
 *
 *  Copyright (C) 2009 Christopher Han <xiphux@gmail.com>
 *}
{include file='header.twig.tpl'}
<input type="hidden" id="review_hash_head" value="{$blob->GetHash()}" />
<input type="hidden" id="review_hash_base" value="blob" />
<input type="hidden" id="review_file" value="{$blob->getPath()}" />

<div class="page_nav">
   {include file='nav.twig.tpl' treecommit=$commit}
</div>

<div class="title compact stretch-evenly">
    <a class="simple-button" href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&amp;a=blob_plain&amp;h={$blob->GetHash()}&amp;f={$blob->GetPath()}">{t}Plain{/t}</a>
    {if ($commit->GetHash() != $head->GetHash()) && ($head->PathToHash($blob->GetPath()))}
        <a class="simple-button" href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&amp;a=blob&amp;hb=HEAD&amp;f={$blob->GetPath()}">{t}HEAD{/t}</a>
    {/if}
    <a class="simple-button" href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&amp;a=history&amp;h={$commit->GetHash()}&amp;f={$blob->GetPath()}">{t}History{/t}</a>
    {if !$datatag}
        <a class="simple-button" href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&amp;a=blame&amp;h={$blob->GetHash()}&amp;f={$blob->GetPath()}&amp;hb={$commit->GetHash()}" id="blameLink">
            {t}Blame{/t}
        </a>
    {/if}

    <div class="page-search-container"></div>
</div>

 {include file='title.twig.tpl' titlecommit=$commit}

{include file='path.twig.tpl' pathobject=$blob target='blobplain'}

 <div class="page_body">
   {if $datatag}
     {* We're trying to display an image *}
     <div>
       <img src="data:{$mime};base64,{$data}" />
     </div>
   {elseif $sexy}
       <table class="code" id="blobData">
       <tbody>
       <tr class="li1">
       <td class="de1">
           <pre class="brush: {$highlighter_brush_name}">
 {$blobstr|escape}
           </pre>
       </td>
       </tr>
       </tbody>
       </table>
        {include file="sexy_highlighter.twig.tpl"}
   {elseif $php}
<table class="code" id="blobData">
<tbody>
<tr class="li1">
<td class="de1">
{$blobstr}
</td>
</tr>
</tbody>
</table>
   {else}
     {* Just plain display *}
    <table class="code" id="blobData">
    <tbody>
    <tr class="li1">
    <td class="ln">
<pre class="de1">
{foreach from=$bloblines item=line name=bloblines}
<a id="l{$smarty.foreach.bloblines.iteration}" href="#1{$smarty.foreach.bloblines.iteration}" class="linenr">{$smarty.foreach.bloblines.iteration}</a>
{/foreach}
</pre></td>
<td class="de1">
<pre class="de1">
{foreach from=$bloblines item=line name=bloblines}
{$line|escape}
{/foreach}
</pre>
</td>
</tr>
</tbody>
</table>
    {/if}
 </div>

 {include file='footer.twig.tpl'}
