# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: nl.pm 117483 2010-01-07 08:27:20Z ytakayama $

package MT::Commercial::L10N::nl;

use strict;
use base 'MT::Commercial::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## addons/Commercial.pack/config.yaml
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Professioneel ontworpen, goed gestructureerd en makkelijk aan te passen website.  U kunt de standaardpagina\'s, voettekst en navigatie makkelijk personaliseren.',
	'_PWT_ABOUT_BODY' => '
<p><strong>Vervang deze voorbeeldtekst door uw eigen inhoud.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies.</p>
<!-- remove this link after editing -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + \'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return false">Bewerken</a>
</p>
',
	'_PWT_CONTACT_BODY' => '
<p><strong>Vervang deze voorbeeldtekst door uw eigen inhoud.</strong></p>

<p>We horen graag van u! Stuur ons mail via email (at) domeinnaam.com</p>

<!-- remove this link after editing -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + \'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return false">Bewerken</a>
</p>
',
	'Welcome to our new website!' => 'Welkom op onze nieuwe website!',
	'_PWT_HOME_BODY' => '
<p><strong>Vervang deze voorbeeldtekst door uw eigen inhoud.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Aliquam erat volutpat. Ut placerat porta nibh. Donec vitae nulla. Pellentesque nisi leo, pretium a, gravida quis, sollicitudin non, eros. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies. Aliquam sagittis volutpat metus.</p>

<p>Sed enim. Integer hendrerit, arcu ac pretium nonummy, velit turpis faucibus risus, pulvinar egestas enim elit sed ante. Curabitur orci diam, placerat a, faucibus id, condimentum vitae, magna. Etiam enim massa, convallis quis, rutrum vitae, porta quis, turpis.</p>
<!-- remove this link after editing -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + \'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return false">Bewerken</a>
</p>
',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Maak een blog aan als deel van een websitestructuur.  Dit werkt het beste met het Professional Website thema...',
	'Photo' => 'Foto',
	'Embed' => 'Embed',
	'Custom Fields' => 'Extra velden',
	'Updating Universal Template Set to Professional Website set...' => 'Universele sjabloonset bij aan het werken tot Professionele Website sjabloonset...',
	'Professional Styles' => 'Professionele stijlen',
	'A collection of styles compatible with Professional themes.' => 'Een verzameling stijlen compatibel met Professionele thema\'s',
	'Professional Website' => 'Professionele Website',
	'Blog Index' => 'Blog index',
	'Header' => 'Hoofding',
	'Footer' => 'Voettekst',
	'Entry Metadata' => 'Metadata bericht',
	'Page Detail' => 'Pagina detail',
	'Powered By (Footer)' => 'Aangedreven door (voettekst)',
	'Recent Entries Expanded' => 'Recent aangepaste berichten',
	'Footer Links' => 'Links in voettekst',
	'Main Sidebar' => 'Primaire zijkolom',
	'Blog Activity' => 'Blogactiviteit',
	'Professional Blog' => 'Professionele blog',
	'Entry Detail' => 'Berichtdetails',
	'Blog Archives' => 'Blogarchieven',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Toon',
	'Date & Time' => 'Datum en tijd',
	'Date Only' => 'Enkel datum',
	'Time Only' => 'Enkel tijd',
	'Please enter all allowable options for this field as a comma delimited list' => 'Gelieve alle toegestane waarden voor dit veld in te vullen als een lijst gescheiden door komma\'s',
	'[_1] Fields' => 'Velden bij [_1]',
	'Edit Field' => 'Veld bewerken',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; datums moeten in het formaat YYYY-MM-DD HH:MM:SS staan.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Ongeldige datum \'[_1]\'; datums moeten echte datums zijn.',
	'Please enter valid URL for the URL field: [_1]' => 'Gelieve een geldige URL in te vullen in het URL veld: [_1]',
	'Please enter some value for required \'[_1]\' field.' => 'Gelieve een waarde in te vullen voor het verplichte \'[_1]\' veld.',
	'Please ensure all required fields have been filled in.' => 'Kijk na of alle verplichte velden ingevuld zijn.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'Sjabloontag \'[_1]\' is een ongeldige tagnaam.',
	'The template tag \'[_1]\' is already in use.' => 'De sjabloontag \'[_1]\' is al in gebruik.',
	'The basename \'[_1]\' is already in use.' => 'De basisnaam \'[_1]\' is al in gebruik',
	'You must select other type if object is the comment.' => 'U moet een ander type selecteren als het object de reactie is.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Pas de formulieren en velden aan voor berichten, pagina\'s, mappen, categoriën en gebruikers aan en sla exact die informatie op die u nodig heeft.',
	' ' => ' ',
	'Single-Line Text' => 'Een regel tekst',
	'Multi-Line Text' => 'Meerdere regels tekst',
	'Checkbox' => 'Checkbox',
	'Date and Time' => 'Datum en tijd',
	'Drop Down Menu' => 'Uitklapmenu',
	'Radio Buttons' => 'Radiobuttons',
	'Embed Object' => 'Embedded object',
	'Post Type' => 'Type bericht',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Custom Fields data opgeslagen in MT::PluginData aan het terugzetten...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Mediabestand-associaties aan het terugzetten die werden gevonden in gepersonaliseerde velden ( [_1] ) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'URL van de mediabestand aan het terugzetten geassocieerd via gepersonaliseerde velden ( [_1] )',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Veld',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Bent u zeker dat u een \'[_1]\' tag gebruikte in de juiste context?  We vonden geen [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'U gebruikte een \'[_1]\' tag buiten de correcte context;',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => '[_1] gepersonaliseerde velden',
	'a field on this blog' => 'een veld op deze weblog',
	'a field on system wide' => 'een veld op systeemniveau',
	'Conflict of [_1] "[_2]" with [_3]' => 'Conflict van [_1] "[_2]" met [_3]',
	'Template Tag' => 'Sjabloontag',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Metadata opslag voor pagina\'s word verplaatst...',

## addons/Commercial.pack/templates/professional/blog/about_this_page.mtml

## addons/Commercial.pack/templates/professional/blog/archive_index.mtml

## addons/Commercial.pack/templates/professional/blog/archive_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/author_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/calendar.mtml

## addons/Commercial.pack/templates/professional/blog/categories.mtml

## addons/Commercial.pack/templates/professional/blog/category_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/comment_detail.mtml

## addons/Commercial.pack/templates/professional/blog/comment_form.mtml

## addons/Commercial.pack/templates/professional/blog/comment_listing.mtml

## addons/Commercial.pack/templates/professional/blog/comment_preview.mtml

## addons/Commercial.pack/templates/professional/blog/comment_response.mtml

## addons/Commercial.pack/templates/professional/blog/comments.mtml

## addons/Commercial.pack/templates/professional/blog/creative_commons.mtml

## addons/Commercial.pack/templates/professional/blog/current_author_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/current_category_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_author_archives.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_category_archives.mtml

## addons/Commercial.pack/templates/professional/blog/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/blog/entry_detail.mtml

## addons/Commercial.pack/templates/professional/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Recent door <em>[_1]</em>',

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/blog/entry.mtml

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml
	'Links' => 'Links',

## addons/Commercial.pack/templates/professional/blog/footer.mtml

## addons/Commercial.pack/templates/professional/blog/header.mtml

## addons/Commercial.pack/templates/professional/blog/javascript.mtml

## addons/Commercial.pack/templates/professional/blog/main_index.mtml

## addons/Commercial.pack/templates/professional/blog/main_index_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_dropdown.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/navigation.mtml

## addons/Commercial.pack/templates/professional/blog/openid.mtml

## addons/Commercial.pack/templates/professional/blog/page.mtml

## addons/Commercial.pack/templates/professional/blog/pages_list.mtml

## addons/Commercial.pack/templates/professional/blog/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/blog/recent_assets.mtml

## addons/Commercial.pack/templates/professional/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] reageerde op [_3]</a>: [_4]',

## addons/Commercial.pack/templates/professional/blog/recent_entries.mtml

## addons/Commercial.pack/templates/professional/blog/search.mtml

## addons/Commercial.pack/templates/professional/blog/search_results.mtml

## addons/Commercial.pack/templates/professional/blog/sidebar.mtml

## addons/Commercial.pack/templates/professional/blog/signin.mtml

## addons/Commercial.pack/templates/professional/blog/syndication.mtml

## addons/Commercial.pack/templates/professional/blog/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/blog/tags.mtml

## addons/Commercial.pack/templates/professional/blog/trackbacks.mtml

## addons/Commercial.pack/templates/professional/website/blog_index.mtml

## addons/Commercial.pack/templates/professional/website/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => 'Berichten ([_1]) Reacties ([_2])',

## addons/Commercial.pack/templates/professional/website/comment_detail.mtml

## addons/Commercial.pack/templates/professional/website/comment_form.mtml

## addons/Commercial.pack/templates/professional/website/comment_listing.mtml

## addons/Commercial.pack/templates/professional/website/comment_preview.mtml

## addons/Commercial.pack/templates/professional/website/comment_response.mtml

## addons/Commercial.pack/templates/professional/website/comments.mtml

## addons/Commercial.pack/templates/professional/website/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/website/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/website/entry_summary.mtml

## addons/Commercial.pack/templates/professional/website/footer_links.mtml

## addons/Commercial.pack/templates/professional/website/footer.mtml

## addons/Commercial.pack/templates/professional/website/header.mtml

## addons/Commercial.pack/templates/professional/website/javascript.mtml

## addons/Commercial.pack/templates/professional/website/main_index.mtml

## addons/Commercial.pack/templates/professional/website/navigation.mtml

## addons/Commercial.pack/templates/professional/website/openid.mtml

## addons/Commercial.pack/templates/professional/website/page.mtml

## addons/Commercial.pack/templates/professional/website/pages_list.mtml

## addons/Commercial.pack/templates/professional/website/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/website/recent_entries_expanded.mtml
	'on [_1]' => 'op [_1]',
	'By [_1] | Comments ([_2])' => 'Door [_1] | Reacties ([_2])',

## addons/Commercial.pack/templates/professional/website/search.mtml

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Kies [_1]',
	'Remove [_1]' => 'Verwijder [_1]',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Deze velden tonen',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Gegevens zijn opgeslagen in de gepersonaliseerde velden.',
	'Save changes to blog (s)' => 'Wijzigingen aan blog opslaan (s)',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'Geen gepersonaliseerde velden gevonden. Nu <a href="[_1]">een veld aanmaken</a>.',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Gepersonaliseerd veld bewerken',
	'Create Custom Field' => 'Gepersonaliseerd veld aanmeken',
	'The selected fields(s) has been deleted from the database.' => 'Geselecteerd(e) veld(en) verwijderd uit de database.',
	'You must enter information into the required fields highlighted below before the Custom Field can be created.' => 'U moet gegevens invullen inde vereiste velden die hieronder aangegeven zijn voor het gepersonaliseerde veld aangemaakt kan worden.',
	'System Object' => 'Systeemobject',
	'Choose the system object where this Custom Field should appear.' => 'Kies het systeemobject waarbij het gepersonaliseerde veld moet verschijnen.',
	'Select...' => 'Selecteer...',
	'Required?' => 'Verplicht?',
	'Is data entry required in this Custom Field?' => 'Moeten er gegevens ingevuld worden in dit gepersonaliseerde veld?',
	'Must the user enter data into this Custom Field before the object may be saved?' => 'Moet de gebruiker gegevens invullen in dit gepersonaliseerde veld voor het object opgeslagen kan worden?',
	'Default' => 'Standaard',
	'You must save this Custom Field before setting a default value.' => 'U moet het gepersonaliseerde veld opslaan voor u een standaardwaarde kunt instellen.',
	'_CF_BASENAME' => 'Basename',
	'The basename must be unique within this installation of Movable Type.' => 'De basisnaam moet uniek zijn binnen deze installatie van Movable Type.',
	'Warning: Changing this field\'s basename may require changes to existing templates.' => 'Waarschuwing: het aanpassen van de basisnaam van deze tag vereist mogelijk aanpassingen aan bestaande sjablonen.',
	'Example Template Code' => 'Voorbeeldsjablooncode',
	'Show In These [_1]' => 'Tonen in deze [_1]',
	'Save this field (s)' => 'Dit veld opslaan (s)',
	'field' => 'veld',
	'fields' => 'velden',
	'Delete this field (x)' => 'Dit veld verwijderen (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Object',

## addons/Commercial.pack/tmpl/list_field.tmpl
	'Manage Custom Fields' => 'Gepersonaliseerde velden beheren',
	'New [_1] Field' => 'Nieuw [_1] veld',
	'Delete selected fields (x)' => 'Geselecteerde velden verwijderen (x)',
	'No fields could be found.' => 'Er werden geen velden gevonden.',
	'Display on' => 'Tonen op',
	'System-Wide' => 'Over heel het systeem',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'open',
	'click-down and drag to move this field' => 'klik en sleep om dit veld te verplaatsen',
	'click to %toggle% this box' => 'klik om dit vakje te %schakelen%',
	'use the arrow keys to move this box' => 'gebruik de pijltjestoetsen om dit vakje te verplaatsen',
	', or press the enter key to %toggle% it' => ', of druk op de enter-toets om het te %schakelen%',

);

1;

