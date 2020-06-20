{*
 *  project.tpl
 *  gitphp: A PHP git repository browser
 *  Component: Project summary template
 *
 *  Copyright (C) 2009 Christopher Han <xiphux@gmail.com>
 *}
{include file='header.twig.tpl'}

<div class="page_nav">
    {include file='nav.twig.tpl' commit=$head current='summary'}
</div>

{include file='title.twig.tpl'}

{* Project brief *}
<div class="stretch-evenly">
    <table class="project-brief" cellspacing="0">
        <tr><td>{t}Description{/t}</td><td>{$project->GetDescription()}</td></tr>
        <tr><td>{t}Owner{/t}</td><td>{$project->GetOwner()|escape:'html'}</td></tr>
        {if $head}
        <tr><td>{t}Last change{/t}</td><td>{$head->GetCommitterEpoch()|date_format:"%a, %d %b %Y %H:%M:%S %z"}</td></tr>
        {/if}
        {if $project->GetCloneUrl()}
            <tr><td>{t}clone url{/t}</td><td><a href="{$project->GetCloneUrl()}">{$project->GetCloneUrl()}</a></td></tr>
        {/if}
        {if $project->GetPushUrl()}
            <tr><td>{t}Push url{/t}</td><td><a href="{$project->GetPushUrl()}">{$project->GetPushUrl()}</a></td></tr>
        {/if}
    </table>

    <div class="page-search-container"></div>
</div>

{if !$head}
   {include file='title.twig.tpl' target='shortlog' disablelink=true}
{else}
   {include file='title.twig.tpl' target='shortlog'}
{/if}

{include file='shortloglist.tpl' source='summary'}

{if $taglist}
    {include file='title.twig.tpl' target='tags'}
    {include file='taglist.twig.tpl'}
{/if}

{if $headlist}
    {include file='title.twig.tpl' target='heads'}
    {include file='headlist.twig.tpl'}
{/if}

{include file='footer.twig.tpl'}
