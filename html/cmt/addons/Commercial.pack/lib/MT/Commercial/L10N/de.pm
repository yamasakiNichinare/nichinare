# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: de.pm 117483 2010-01-07 08:27:20Z ytakayama $

package MT::Commercial::L10N::de;

use strict;
use base 'MT::Commercial::L10N::en_us';
use vars qw( %Lexicon );
%Lexicon = (
## addons/Commercial.pack/config.yaml
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Eine professionell gestaltete, übersichtlich strukturierte und leicht anpass- und erweiterbare Website. ',
	'_PWT_ABOUT_BODY' => '
<p><strong>Platzhalter - Geben Sie hier Ihren eigenen Text ein.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec
tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque
pellentesque nulla. Maecenas condimentum quam. Vestibulum pretium
fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae,
vulputate et, dignissim at, pede. Integer pellentesque orci at nibh.
Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a,
bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti
sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos.
Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo.
Duis vitae magna nec risus pulvinar ultricies.</p>
<!-- Entfernen Sie diesen Link nach der Bearbeitung -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl +
\'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return
false">Inhalt bearbeiten</a>
</p>
',
	'_PWT_CONTACT_BODY' => '
<p><strong>Platzhalter - Geben Sie hier Ihren eigenen Text ein.</strong></p>

<p>Wir freuen uns darauf, von Ihnen zu hören. Schicken Sie Ihre E-Mail bitte an email (at) domainname.de</p>

<!-- Entfernen Sie diesen Link nach der Bearbeitung  -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl +
\'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return
false">Inhalt bearbeiten</a>
</p>
',
	'Welcome to our new website!' => 'Willkommen auf unserer neuen Website!',
	'_PWT_HOME_BODY' => '
<p><strong>Platzhalter - Geben Sie hier Ihren eigenen Text ein.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec
tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque
pellentesque nulla. Maecenas condimentum quam. Aliquam erat volutpat. Ut
placerat porta nibh. Donec vitae nulla. Pellentesque nisi leo, pretium
a, gravida quis, sollicitudin non, eros. Vestibulum pretium fringilla
quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate
et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a,
bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti
sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos.
Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo.
Duis vitae magna nec risus pulvinar ultricies. Aliquam sagittis volutpat
metus.</p>

<p>Sed enim. Integer hendrerit, arcu ac pretium nonummy, velit turpis
faucibus risus, pulvinar egestas enim elit sed ante. Curabitur orci
diam, placerat a, faucibus id, condimentum vitae, magna. Etiam enim
massa, convallis quis, rutrum vitae, porta quis, turpis.</p>
<!-- Entfernen Sie diesen Link nach der Bearbeitung  -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl +
\'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return
false">Inhalt bearbeiten</a>
</p>
',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Legen Sie ein Blog als Teil einer umfangreicheren Website an. Das funktioniert besonders gut mit der Vorlage &#8222;Professionelle Website&#8220;.',
	'Photo' => 'Foto',
	'Embed' => 'Einbetten',
	'Custom Fields' => 'Eigene Felder',
	'Updating Universal Template Set to Professional Website set...' => 'Aktualisiere \'Universelle Vorlagengruppe\' in Vorlagengruppe \'Profesionelle Website\'',
	'Professional Styles' => 'Pro-Themen',
	'A collection of styles compatible with Professional themes.' => 'Mit Pro-Themen kompatible Designs',
	'Professional Website' => 'Professionelle Website',
	'Blog Index' => 'Blog-Index',
	'Header' => 'Kopf',
	'Footer' => 'Fußzeile',
	'Entry Metadata' => 'Eintrags-Metadaten',
	'Page Detail' => 'Seiteninformationen',
	'Powered By (Footer)' => 'Powered by (Fußzeile)',
	'Recent Entries Expanded' => 'Neueste Einträge (erweitert)',
	'Footer Links' => 'Fußzeilen-Links',
	'Main Sidebar' => 'Haupt-Seitenspalte',
	'Blog Activity' => 'Blog-Aktivität',
	'Professional Blog' => 'Professionelles Blog',
	'Entry Detail' => 'Eintragsdetails',
	'Blog Archives' => 'Blog-Archive',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Zeige',
	'Date & Time' => 'Datum- und Uhrzeit',
	'Date Only' => 'Nur Datum',
	'Time Only' => 'Nur Uhrzeit',
	'Please enter all allowable options for this field as a comma delimited list' => 'Bitte geben Sie alle für dieses Feld zulässigen Optionen als kommagetrennte Liste ein.',
	'[_1] Fields' => '[_1]-Felder',
	'Edit Field' => 'Feld bearbeiten',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ungültige Datumsangabe \'[_1]\' - Datumsangaben müssen das Format JJJJ-MM-TT HH:MM:SS haben.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Ungültige Datumsangabe \'[_1]\' - Datumsangaben sollten tatsächliche Daten sein',
	'Please enter valid URL for the URL field: [_1]' => 'Bitte geben Sie eine gültige Web-Adresse in das Feld [_1] ein.',
	'Please enter some value for required \'[_1]\' field.' => 'Bitte füllen Sie das erforderliche Feld \'[_1]\' aus.',
	'Please ensure all required fields have been filled in.' => 'Bitte füllen Sie alle erforderlichen Felder aus.',
	'The template tag \'[_1]\' is an invalid tag name.' => '\'[_1]\' ist ein ungültiger Befehlsname.',
	'The template tag \'[_1]\' is already in use.' => 'Vorlagenbefehl \'[_1]\' bereits vorhanden',
	'The basename \'[_1]\' is already in use.' => 'Basisname \'[_1]\' bereits vorhanden',
	'You must select other type if object is the comment.' => 'Wählen Sie einen anderen Typ, wenn sich das Feld auf Kommentare bezieht.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Speichern Sie genau die Informationen, die Sie möchten, indem Sie die Formulare und Felder von Einträgen, Seiten, Ordnern, Kategorien und Benutzerkonten frei anpassen.',
	' ' => ' ',
	'Single-Line Text' => 'Einzeiliger Text',
	'Multi-Line Text' => 'Mehrzeiliger Text',
	'Checkbox' => 'Auswahlkästchen',
	'Date and Time' => 'Datum und Uhrzeit',
	'Drop Down Menu' => 'Drop-Down-Menü',
	'Radio Buttons' => 'Auswahlknöpfe',
	'Embed Object' => 'Objekt einbetten',
	'Post Type' => 'Eintragsart',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Stelle eigene Felder aus MT::PluginData wieder her...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Stelle Assetverknüpfungen aus eigenen Feldern wieder her...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Stelle die Adressen der in eigenen Feldern verwendeten Assets wieder her...',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Feld',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Wird der \'[_1]\'-Befehl im richtigen Kontext verwendet? Kann [_2] nicht finden',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => '\'[_1]\'-Befehl außerhalb des passenden Kontexts verwendet.',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => '[_1] eigene Felder',
	'a field on this blog' => 'Ein Feld dieses Blogs',
	'a field on system wide' => 'Ein systemweites Feld',
	'Conflict of [_1] "[_2]" with [_3]' => ' [_1] "[_2]" steht in Konflikt mit [_3]',
	'Template Tag' => 'Vorlagenbefehl',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Verschiebe Metadatenspeicher für Seiten...',

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
	'Recently by <em>[_1]</em>' => 'Neues von <em>[_1]</em>',

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
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] meinte zu [_3]</a>: [_4]',

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
	'Entries ([_1]) Comments ([_2])' => 'Einträge ([_1]) Kommentare ([_2])',

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
	'on [_1]' => 'zu [_1]',
	'By [_1] | Comments ([_2])' => 'Von [_1] | Kommentare ([_2])',

## addons/Commercial.pack/templates/professional/website/search.mtml

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => '[_1] wählen',
	'Remove [_1]' => '[_1] löschen',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Diese Felder anzeigen',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Daten in eigenen Feldern gespeichert.',
	'Save changes to blog (s)' => 'Änderungen des Blogs speichern (s)',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'Keine eigenen Felder gefunden. Jetzt ein <a href="[_1]">Feld anlegen</a>.',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Eigenes Feld bearbeiten',
	'Create Custom Field' => 'Eigenes Feld anlegen',
	'The selected fields(s) has been deleted from the database.' => 'Gewählten Felder aus Datenbank gelöscht.',
	'You must enter information into the required fields highlighted below before the Custom Field can be created.' => 'Bitte füllen Sie alle hervorgehobenen Felder aus.',
	'System Object' => 'Systemobjekt',
	'Choose the system object where this Custom Field should appear.' => 'Wählen Sie das Systemobjekt, auf das sich dieses Feld beziehen soll.',
	'Select...' => 'Wählen...',
	'Required?' => 'Erforderlich?',
	'Is data entry required in this Custom Field?' => 'Muss dieses Feld ausgefüllt werden?',
	'Must the user enter data into this Custom Field before the object may be saved?' => 'Sollen Benutzer dieses Feld ausfüllen müssen, bevor sie das Objekt speichern können?',
	'Default' => 'Standardwert',
	'You must save this Custom Field before setting a default value.' => 'Speichern Sie das Feld, um den Standardwert festlegen zu können.',
	'_CF_BASENAME' => 'Basisname',
	'The basename must be unique within this installation of Movable Type.' => 'Der Basisname des Felds muss systemweit eindeutig sein.',
	'Warning: Changing this field\'s basename may require changes to existing templates.' => 'Hinweis: Eine Änderung des Basisnamens eines Feldes kann die Bearbeitung vorhandener Vorlagen notwendig machen.',
	'Example Template Code' => 'Beispiel-Vorlagencode',
	'Show In These [_1]' => 'In diesen [_1] anzeigen',
	'Save this field (s)' => 'Dieses Feld speichern (s)',
	'field' => 'Feld',
	'fields' => 'Felder',
	'Delete this field (x)' => 'Dieses Feld löschen (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objekt',

## addons/Commercial.pack/tmpl/list_field.tmpl
	'Manage Custom Fields' => 'Felder verwalten',
	'New [_1] Field' => 'Neues [_1] Feld',
	'Delete selected fields (x)' => 'Gewählte Felder löschen (x)',
	'No fields could be found.' => 'Keine Felder gefunden.',
	'Display on' => 'Anzeigen in',
	'System-Wide' => 'Systemweit',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'öffnen',
	'click-down and drag to move this field' => 'bei gedrückter Maustaste ziehen, um das Feld zu verschieben',
	'click to %toggle% this box' => 'klicken um das Feld an- oder abzuwählen',
	'use the arrow keys to move this box' => 'mit den Pfeiltasten verschieben',
	', or press the enter key to %toggle% it' => 'oder Enter drücken zum An- oder Abwählen',
);

1;

