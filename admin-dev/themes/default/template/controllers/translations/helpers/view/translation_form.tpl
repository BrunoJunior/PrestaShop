{**
 * 2007-2019 PrestaShop SA and Contributors
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/OSL-3.0
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to https://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2019 PrestaShop SA and Contributors
 * @license   https://opensource.org/licenses/OSL-3.0 Open Software License (OSL 3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}

{extends file="helpers/view/view.tpl"}

{block name="override_tpl"}
	{if $mod_security_warning}
	<div class="alert alert-warning">
		{l s='Apache mod_security is activated on your server. This could result in some Bad Request errors' d='Admin.International.Notification'}
	</div>
	{/if}
	{if !empty($limit_warning)}
	<div class="alert alert-warning">
		{if $limit_warning['error_type'] == 'suhosin'}
			{l s='Warning! Your hosting provider is using the Suhosin patch for PHP, which limits the maximum number of fields allowed in a form:' d='Admin.International.Notification'}

			{l s='%limit% for suhosin.post.max_vars.' sprintf=['%limit%' => '<b>'|cat:$limit_warning['post.max_vars'|cat:'</b>'] d='Admin.International.Notification'}<br/>
      {l s='%limit% for suhosin.request.max_vars.' sprintf=['%limit%' => '<b>'|cat:$limit_warning['request.max_vars'|cat:'</b>'] d='Admin.International.Notification'}<br/>
      {l s='Please ask your hosting provider to increase the Suhosin limit to' d='Admin.International.Notification'}
		{else}
			{l s='Warning! Your PHP configuration limits the maximum number of fields allowed in a form:' d='Admin.International.Notification'}
			<b>{$limit_warning['max_input_vars']}</b> {l s='for max_input_vars.' d='Admin.International.Notification'}<br/>
			{l s='Please ask your hosting provider to increase this limit to' d='Admin.International.Notification'}
		{/if}
		{l s='%s at least, or you will have to edit the translation files.' sprintf=[$limit_warning['needed_limit']] d='Admin.International.Notification'}
	</div>
	{else}

		<div class="alert alert-info">
			<p>
				{l s='Click on the title of a section to open its fieldsets.' d='Admin.International.Help'}
			</p>
		</div>
		<div class="panel">
			<p>{l s='Expressions to translate:' d='Admin.International.Feature'} <span class="badge">{l s='%d' sprintf=[$count]}</span></p>
			<p>{l s='Total missing expressions:' d='Admin.International.Feature'} <span class="badge">{l s='%d' sprintf=[$missing_translations|array_sum]}</p>
		</div>

		<form method="post" id="{$table}_form" action="{$url_submit|escape:'html':'UTF-8'}" class="form-horizontal">
			<div class="panel">
				<input type="hidden" name="lang" value="{$lang}" />
				<input type="hidden" name="type" value="{$type}" />
				<input type="hidden" name="theme" value="{$theme}" />

				<script type="text/javascript">
					$(document).ready(function(){
						$('a.useSpecialSyntax').click(function(){
							var syntax = $(this).find('img').attr('alt');
							$('#BoxUseSpecialSyntax .syntax span').html(syntax+".");
						});

						$("a.sidetoggle").click(function(){
							$('#'+$(this).attr('data-slidetoggle')).slideToggle();
							return false;
						});
					});
				</script>

				<div id="BoxUseSpecialSyntax">
					<div class="alert alert-warning">
						<p>
							{l s='Some of these expressions use this special syntax: %s.' sprintf=['%d'] d='Admin.International.Help'}
							<br />
							{l s='You MUST use this syntax in your translations. Here are several examples:'}
						</p>
						<ul>
              <li>"{l s='There are [1]%replace%[/1] products' html=true sprintf=['%replace%' => '%d', '[1]' => '<strong>', '[/1]' => '</strong>'] d='Admin.International.Help'}": {l s='"%s" will be replaced by a number.' sprintf=['%d'] d='Admin.International.Help'}</li>
              <li>"{l s='List of pages in [1]%replace%[/1]' html=true sprintf=['%replace%' => '%s', '[1]' => '<strong>', '[/1]' => '</strong>'] d='Admin.International.Help'}": {l s='"%s" will be replaced by a string.' sprintf=['%s'] d='Admin.International.Help'}</li>
              <li>"{l s='Feature: [1]%1%[/1] ([1]%2%[/1] values)' html=true sprintf=['%1%' => '%1$s', '%2%' => '%2$d', '[1]' => '<strong>', '[/1]' => '</strong>'] d='Admin.International.Help'}": {l s='The numbers enable you to reorder the variables when necessary.' d='Admin.International.Help'}</li>
						</ul>
					</div>
				</div>
				<div class="panel-footer">
					<a name="submitTranslations{$type|ucfirst}" href="{$cancel_url|escape:'html':'UTF-8'}" class="btn btn-default"><i class="process-icon-cancel"></i> {l s='Cancel' d='Admin.Actions'}</a>
					{$toggle_button}
					<button type="submit" id="{$table}_form_submit_btn" name="submitTranslations{$type|ucfirst}" class="btn btn-default pull-right"><i class="process-icon-save"></i> {l s='Save' d='Admin.Actions'}</button>
					<button type="submit" id="{$table}_form_submit_btn" name="submitTranslations{$type|ucfirst}AndStay" class="btn btn-default pull-right"><i class="process-icon-save"></i> {l s='Save and stay' d='Admin.Actions'}</button>
				</div>
			</div>
			{foreach $tabsArray as $k => $newLang}
				{if !empty($newLang)}
					<div class="panel">
						<h3>
							<a href="#" class="sidetoggle" data-slidetoggle="{$k}-tpl">
								<i class="icon-caret-down"></i>
								{$k}
							</a>
							- {$newLang|count} {l s='expressions' d='Admin.International.Feature'}
							{if isset($missing_translations[$k])} <span class="label label-danger">{$missing_translations[$k]} {l s='missing' d='Admin.International.Feature'}</span>{/if}
						</h3>
						<div name="{$type}_div" id="{$k}-tpl" style="display:{if isset($missing_translations[$k])}block{else}none{/if}">
							<table class="table">
								{counter start=0 assign=irow}
								{foreach $newLang as $key => $value}{counter}
									<tr>
										<td width="40%">{$key|stripslashes}</td>
										<td width="2%">=</td>
										<td width="40%"> {*todo : md5 is already calculated in AdminTranslationsController*}
											{if $key|strlen < $textarea_sized}
												<input type="text" style="width: 450px{if empty($value.trad)};background:#FBB{/if}"
													name="{if in_array($type, array('front', 'fields'))}{$k}_{$key|md5}{else}{$k}{$key|md5}{/if}"
													value="{$value.trad|regex_replace:'/"/':'&quot;'|stripslashes}"' />
											{else}
												<textarea rows="{($key|strlen / $textarea_sized)|intval}" style="width: 450px{if empty($value.trad)};background:#FBB{/if}"
												name="{if in_array($type, array('front', 'fields'))}{$k}_{$key|md5}{else}{$k}{$key|md5}{/if}"
												>{$value.trad|regex_replace:'/"/':'&quot;'|stripslashes}</textarea>
											{/if}
										</td>
										<td width="18%">
											{if isset($value.use_sprintf) && $value.use_sprintf}
												<a class="useSpecialSyntax" title="{l s='This expression uses a special syntax:' d='Admin.International.Notification'} {$value.use_sprintf}">
													<img src="{$smarty.const._PS_IMG_}admin/error.png" alt="{$value.use_sprintf}" />
												</a>
											{/if}
										</td>
									</tr>
								{/foreach}
							</table>
							<div class="panel-footer">
							<a name="submitTranslations{$type|ucfirst}" href="{$cancel_url|escape:'html':'UTF-8'}" class="btn btn-default"><i class="process-icon-cancel"></i> {l s='Cancel' d='Admin.Actions'}</a>
							<button type="submit" id="{$table}_form_submit_btn" name="submitTranslations{$type|ucfirst}" class="btn btn-default pull-right"><i class="process-icon-save"></i> {l s='Save' d='Admin.Actions'}</button>
							<button type="submit" id="{$table}_form_submit_btn" name="submitTranslations{$type|ucfirst}AndStay" class="btn btn-default pull-right"><i class="process-icon-save"></i> {l s='Save and stay' d='Admin.Actions'}</button>
						</div>
						</div>

					</div>
				{/if}
			{/foreach}
		</form>
	{/if}

{/block}
