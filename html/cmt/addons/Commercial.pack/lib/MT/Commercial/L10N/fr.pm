# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: fr.pm 117483 2010-01-07 08:27:20Z ytakayama $

package MT::Commercial::L10N::fr;

use strict;
use base 'MT::Commercial::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## addons/Commercial.pack/config.yaml
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Conçu pour les professionnels, bien structué et facilement adaptable, vous pouvez personnaliser les pages par défaut, le pied de page et la navigation facilement.',
	'_PWT_ABOUT_BODY' => '_PWT_ABOUT_BODY',
	'_PWT_CONTACT_BODY' => '_PWT_CONTACT_BODY',
	'Welcome to our new website!' => 'Bienvenue sur notre nouveau site !',
	'_PWT_HOME_BODY' => '_PWT_HOME_BODY',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Créer un blog en tant que partie d\'un site web. Cela fonctionne mieux avec un thème de sites web profeesionnels.',
	'Photo' => 'Photo',
	'Embed' => 'Embarqué',
	'Custom Fields' => 'Champs personnalisés',
	'Updating Universal Template Set to Professional Website set...' => 'Mise à jour du jeu de gabarits universel vers sites web professionnels...',
	'Professional Styles' => 'Styles professionnels',
	'A collection of styles compatible with Professional themes.' => 'Une collection de styles compatible avec des thèmes professionnels',
	'Professional Website' => 'Sites web professionnels',
	'Blog Index' => 'Index du Blog',
	'Header' => 'Entête',
	'Footer' => 'Pied',
	'Entry Metadata' => 'Metadonnées de la note',
	'Page Detail' => 'Détails de la page',
	'Powered By (Footer)' => 'Powered By (Pied de Page)',
	'Recent Entries Expanded' => 'Entrées étendues récentes',
	'Footer Links' => 'Liens de Pied de Page',
	'Main Sidebar' => 'Colonne latérale principale',
	'Blog Activity' => 'Activité du blog',
	'Professional Blog' => 'Blog professionel',
	'Entry Detail' => 'Détails de la note',
	'Blog Archives' => 'Archives du blog',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Afficher',
	'Date & Time' => 'Date & heure',
	'Date Only' => 'Date seulement',
	'Time Only' => 'Heure seulement',
	'Please enter all allowable options for this field as a comma delimited list' => 'Merci de saisir toutes les options autorisées pour ce champ dans une liste délimitée par des virgules',
	'[_1] Fields' => '[_1] champs',
	'Edit Field' => 'Modifier le champ',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent être dans le format YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Date invalide \'[_1]\'; les dates doivent être de vraies dates.',
	'Please enter valid URL for the URL field: [_1]' => 'Merci de saisir une URL correcte pour le champ URL : [_1]',
	'Please enter some value for required \'[_1]\' field.' => 'Merci de saisir une valeur pour le champ obligatoire \'[_1]\'.',
	'Please ensure all required fields have been filled in.' => 'Merci de vérifier que tous les champs obligatoires ont été remplis.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'Le tag de gabarit \'[_1]\' est un nom de tag invalide',
	'The template tag \'[_1]\' is already in use.' => 'Le tag de gabarit \'[_1]\' est déjà utilisé.',
	'The basename \'[_1]\' is already in use.' => 'Le nom de base \'[_1]\' est déjà utilisé.',
	'You must select other type if object is the comment.' => 'Vous devez sélectionner d\'autre types si l\'objet est dans les commentaires.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personnalisez les champs des notes, pages, répertoires, catégories et auteurs pour stocker toutes les informations dont vous avez besoin.',
	' ' => ' ',
	'Single-Line Text' => 'Texte sur une ligne',
	'Multi-Line Text' => 'Texte multi-lignes',
	'Checkbox' => 'Case à cocher',
	'Date and Time' => 'Date et heure',
	'Drop Down Menu' => 'Menu déroulant',
	'Radio Buttons' => 'Boutons radio',
	'Embed Object' => 'Élément externe',
	'Post Type' => 'Type de note',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Restauration des données des champs personnalisés stockées dans MT:PluginData...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Restauration des associations d\'éléments trouvés dans les champs personnalisés ([_1]) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restauration des URLs des éléments associés dans les champs personnalisés ([_1]) ...',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Champ',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Etes-vous sûr d\'avoir utilisé un tag \'[_1]\' dans le contexte approprié ? Impossible de trouver le [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Vous avez utilisé un tag \'[_1]\' en dehors du contexte du contenu correct; ',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => 'Champs personnalisés [_1]',
	'a field on this blog' => 'un champ sur ce blog',
	'a field on system wide' => 'un champ sur tout le système',
	'Conflict of [_1] "[_2]" with [_3]' => 'Conflit de [_1] "[_2]" avec [_3]',
	'Template Tag' => 'Tag du gabarit',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Déplacement de l\'emplacement des métadonnées des pages en cours ...',

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
	'Recently by <em>[_1]</em>' => 'Récemment par <em>[_1]</em>',

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/blog/entry.mtml

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml
	'Links' => 'Liens',

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
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] a commenté sur [_3]</a> : [_4]',

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
	'Entries ([_1]) Comments ([_2])' => 'Notes ([_1]) Commentaires ([_2])',

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
	'on [_1]' => 'sur [_1]',
	'By [_1] | Comments ([_2])' => 'Par [_1] | Commentaires ([_1])',

## addons/Commercial.pack/templates/professional/website/search.mtml

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Choisir [_1]',
	'Remove [_1]' => 'Supprimer [_1]',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Afficher ces champs',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Les données ont été enregistrées pour les champs personnalisés.',
	'Save changes to blog (s)' => 'Sauvegarder les modifications du blog (s)',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'Aucun champs personnalisé ne peut être trouvé. <a href="[_1]">Créer un champs</a> maintenant.',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Éditer le champs personnalisé',
	'Create Custom Field' => 'Créer une champ personnalisé',
	'The selected fields(s) has been deleted from the database.' => 'Les champs sélectionnés ont été effacés de la base de données.',
	'You must enter information into the required fields highlighted below before the Custom Field can be created.' => 'Vous devez entrer des informations dans le champs requis indiqué avant que le champs personnalisé soit créé.',
	'System Object' => 'Objet système',
	'Choose the system object where this Custom Field should appear.' => 'Sélectionnez l\'objet système dans lequel le champs devra apparaître.',
	'Select...' => 'Sélectionnez...',
	'Required?' => 'Obligatoire?',
	'Is data entry required in this Custom Field?' => 'Est-ce qu\'une donnée est requise dans ce champs personnalisé ?',
	'Must the user enter data into this Custom Field before the object may be saved?' => 'L\'utilisateur doit-il entrer quelque chose dans ce champs avant que l\'objet puisse être enregistré ?',
	'Default' => 'Défaut',
	'You must save this Custom Field before setting a default value.' => 'Vous devez sauvegarder ce champs personnalisé avant d\'indiquer une valeur par défaut.',
	'_CF_BASENAME' => 'Nom de base',
	'The basename must be unique within this installation of Movable Type.' => 'Le nom de base doit être unique dans toute cette installation Movable Type.',
	'Warning: Changing this field\'s basename may require changes to existing templates.' => 'Attention : le changement de ce nom de base peut nécessiter des changements additionnels dans vos gabarits existants.',
	'Example Template Code' => 'Code de gabarit exemple',
	'Show In These [_1]' => 'Afficher dans ces [_1]',
	'Save this field (s)' => 'Enregistrer ce champs (s)',
	'field' => 'champ',
	'fields' => 'Champs',
	'Delete this field (x)' => 'Supprimer ce champs (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objet',

## addons/Commercial.pack/tmpl/list_field.tmpl
	'Manage Custom Fields' => 'Gérer les champs personnalisés',
	'New [_1] Field' => 'Nouveau champ [_1]',
	'Delete selected fields (x)' => 'Effacer les champs sélectionnés (x)',
	'No fields could be found.' => 'Aucun champ n\'a été trouvé.',
	'Display on' => 'Affucher sur',
	'System-Wide' => 'sur tout le système',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'ouvrir',
	'click-down and drag to move this field' => 'gardez le clic maintenu et glissez le curseur pour déplacer ce champs',
	'click to %toggle% this box' => 'cliquez pour %toggle% cette boîte',
	'use the arrow keys to move this box' => 'utilisez les touches flêchées de votre clavier pour déplacer cette boîte',
	', or press the enter key to %toggle% it' => ', ou pressez la touche entrée pour la %toggle%',
);

1;

