# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: es.pm 117483 2010-01-07 08:27:20Z ytakayama $

package MT::Commercial::L10N::es;

use strict;
use base 'MT::Commercial::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## addons/Commercial.pack/config.yaml
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Sitio web con diseños profesionales, bien estructurados y fácilmente adaptables. Puede personalizar de forma sencilla las páginas predefinidas, los pies y la navegación.',
	'_PWT_ABOUT_BODY' => '_PWT_ABOUT_BODY',
	'_PWT_CONTACT_BODY' => '_PWT_CONTACT_BODY',
	'Welcome to our new website!' => '¡Bienvenido a nuestro nuevo sitio!',
	'_PWT_HOME_BODY' => '_PWT_HOME_BODY',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Crear un blog como parte de la estructura de un sitio web. Funciona mejor con el tema Sitio Web Profesional.', # Translate - New
	'Photo' => 'Foto',
	'Embed' => 'Embeber',
	'Custom Fields' => 'Campos personalizados',
	'Updating Universal Template Set to Professional Website set...' => 'Actualizar el conjuntto de plantillas Universal al conjunto Sitio Web Profesional...',
	'Professional Styles' => 'Estilos Profesionales', # Translate - New
	'A collection of styles compatible with Professional themes.' => 'Colección de estilos compatible con los temas Profesionales.', # Translate - New
	'Professional Website' => 'Web Profesional',
	'Blog Index' => 'Índice del blog',
	'Header' => 'Cabecera',
	'Footer' => 'Pie',
	'Entry Metadata' => 'Metadatos de la entrada',
	'Page Detail' => 'Detalle de la página',
	'Powered By (Footer)' => 'Powered By (Pie)',
	'Recent Entries Expanded' => 'Entradas recientes expandidas',
	'Footer Links' => 'Enlaces del pie',
	'Main Sidebar' => 'Barra lateral principal',
	'Blog Activity' => 'Actividad del blog',
	'Professional Blog' => 'Blog Profesional', # Translate - New
	'Entry Detail' => 'Detalle de la entrada',
	'Blog Archives' => 'Archivos del blog',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Mostrar',
	'Date & Time' => 'Fecha & Hora',
	'Date Only' => 'Fecha solo',
	'Time Only' => 'Hora solo',
	'Please enter all allowable options for this field as a comma delimited list' => 'Por favor, introduzca todas las opciones permitidas a este campo en forma de lista de elementos separados por comas',
	'[_1] Fields' => 'Campos de [_1]',
	'Edit Field' => 'Editar campo',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'; las fechas deben estar en el formato YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Fecha no válida \'[_1]\'; debe ser una fecha real.',
	'Please enter valid URL for the URL field: [_1]' => 'Por favor, introduzca una URL válida en el campo de la URL: [_1]',
	'Please enter some value for required \'[_1]\' field.' => 'Por favor, introduzca un valor en el campo obligatorio \'[_1]\'.',
	'Please ensure all required fields have been filled in.' => 'Por favor, asegúrese de que todos los campos se han introducido.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'La etiqueta de plantilla \'[_1]\' es un nombre de etiqueta inválido.',
	'The template tag \'[_1]\' is already in use.' => 'La etiqueta de plantilla \'[_1]\' ya está en uso.',
	'The basename \'[_1]\' is already in use.' => 'El nombre base \'[_1]\' ya está en uso.',
	'You must select other type if object is the comment.' => 'Debe seleccionar otro tipo si el objeto es un comentario.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personalice los formularios y campos de las entradas, páginas, carpetas, categorías y usuarios, guardando los datos exactos que necesite.',
	' ' => ' ',
	'Single-Line Text' => 'Texto - Una sola línea',
	'Multi-Line Text' => 'Texto multilínea',
	'Checkbox' => 'Casilla',
	'Date and Time' => 'Fecha y Hora',
	'Drop Down Menu' => 'Menú desplegable',
	'Radio Buttons' => 'Botones radiales',
	'Embed Object' => 'Embeber objeto',
	'Post Type' => 'Tipo de entrada',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Restaurando los datos de los campos personalizados guardados en MT::PluginData...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Restaurando las asociaciones de los ficheros multimedia de los campos personalizados ( [_1] ) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restaurando url de los ficheros multimedia asociados en los campos personalizados ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Campo',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => '¿Está seguro de que ha utilizado la etiqueta \'[_1]\' en el contexto adecuado? No se encontró el [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Ha utilizado una etiqueta \'[_1]\' fuera del contexto del contenido correcto;',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => '[_1] campos personalizados',
	'a field on this blog' => 'un campo en este blog', # Translate - New
	'a field on system wide' => 'un campo en todo el sistema', # Translate - New
	'Conflict of [_1] "[_2]" with [_3]' => 'Conflicto entre [_1] "[_2]" y [_3]', # Translate - New
	'Template Tag' => 'Etiqueta de plantilla',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Trasladando los metadatos de las páginas...',

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
	'Recently by <em>[_1]</em>' => 'Novedades por <em>[_1]</em>',

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/blog/entry.mtml

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml
	'Links' => 'Enlaces',

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
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] comentó en [_3]</a>: [_4]',

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
	'Entries ([_1]) Comments ([_2])' => 'Entradas ([_1]) Comentarios ([_2])',

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
	'on [_1]' => 'en [_1]', # Translate - New
	'By [_1] | Comments ([_2])' => 'Por [_1] | Comentarios ([_2]) ',

## addons/Commercial.pack/templates/professional/website/search.mtml

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Seleccionar [_1]',
	'Remove [_1]' => 'Borrar [_1]',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Mostrar estos campos',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Se han cuargado los datos en los campos personalizados.',
	'Save changes to blog (s)' => 'Guardar los cambios en el blog (s)',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'No se han encontrado campos personalizados. <a href="[_1]">Cree un campo</a> ahora.',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Editar campo personalizado',
	'Create Custom Field' => 'Crear campo personalizado',
	'The selected fields(s) has been deleted from the database.' => 'Los campos seleccionados han sido borrados de la base de datos.',
	'You must enter information into the required fields highlighted below before the Custom Field can be created.' => 'Antes de que pueda crear el campo personalizado debe introducir la información en los campos obligatorios resaltados abajo.',
	'System Object' => 'Objeto del sistema',
	'Choose the system object where this Custom Field should appear.' => 'Seleccione el objeto del sistema donde aparecerá el campo personalizado.',
	'Select...' => 'Seleccionar...',
	'Required?' => '¿Obligatorio?',
	'Is data entry required in this Custom Field?' => '¿Se necesita la introducción de datos en este campo personalizado?',
	'Must the user enter data into this Custom Field before the object may be saved?' => '¿El usuario debe introducir datos en este campo personalizado antes de que el objeto se guarde?',
	'Default' => 'Predefinido',
	'You must save this Custom Field before setting a default value.' => 'Debe guardar este campo personalizado antes de indicar un valor predefinido.',
	'_CF_BASENAME' => 'Nombre base',
	'The basename must be unique within this installation of Movable Type.' => 'El nombre base debe ser único en esta instalación de Movable Type.',
	'Warning: Changing this field\'s basename may require changes to existing templates.' => 'Atención: Si cambia el nombre base de este campo, quizás se necesiten cambios en las plantillas existentes.',
	'Example Template Code' => 'Código de ejemplo',
	'Show In These [_1]' => 'Mostrar en estos [_1]',
	'Save this field (s)' => 'Guardar este campo (s)',
	'field' => 'campo',
	'fields' => 'campos',
	'Delete this field (x)' => 'Borrar este campo (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objeto',

## addons/Commercial.pack/tmpl/list_field.tmpl
	'Manage Custom Fields' => 'Administrar campos personalizados',
	'New [_1] Field' => 'Nuevo campo - [_1]',
	'Delete selected fields (x)' => 'Borrar campos seleccionados (x)',
	'No fields could be found.' => 'No se encontraron campos.',
	'Display on' => 'Mostrar en',
	'System-Wide' => 'Todo el sistema',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'abrir',
	'click-down and drag to move this field' => 'haga clic y arrastre el campo para moverlo',
	'click to %toggle% this box' => 'haga clic para %toggle% esta casilla',
	'use the arrow keys to move this box' => 'use las flechas para mover esta caja',
	', or press the enter key to %toggle% it' => ', o presione la tecla enter para %toggle%',
);

1;

