package MT::Plugin::SKR::CustomizeLabels::Lexicon;
#           Copyright (c) 2008 SKYARC System Co.,Ltd.
#           @see http://www.skyarc.co.jp/
use strict;
use warnings;
use MT 4;
use Data::Dumper;
use vars qw( $PLUGIN_NAME $VERSION );
$PLUGIN_NAME = (split /::/, __PACKAGE__)[-1];
$VERSION = '1.0';

### Registration of the MT::Plugin
use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
    id      => $PLUGIN_NAME,
    key     => $PLUGIN_NAME,
    name    => $PLUGIN_NAME,
    version => $VERSION,
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    description => <<HTMLHEREDOC,
<__trans phrase="Allow you to replace any strings in the admin screens">
HTMLHEREDOC
    l10n_class => 'SkrLexicon::L10N',
    config_template => 'config.tmpl',
    settings => new MT::PluginSettings([
        [ 'replaces_entry', { Default => undef }],
        [ 'replaces_page', { Default => undef }],
        [ 'replaces_asset', { Default => undef }],
        [ 'replaces_comment', { Default => undef }],
        [ 'replaces', { Default => undef }],
    ]),
    registry => {
		tags => {
			function => {
				org_trans => \&_org_trans_hdlr,
			},
		},
        callbacks => {
            'pre_run' => \&_cb_pre_run,
            'sitemap_action_menu' => { 
                handler => \&_sitemap_action_menu,
                priority => 11,
            },
            'Sitemap::template_filter' => sub { 
                  my ( $cb, $app, $blog_id, $scope, $tmpl ) = @_;
                  &_sitemap_action_menu( $cb, $app, $scope, '', '', '', $blog_id, $tmpl );
                  &_replace_lexicon( $app, $app->param('blog_id') || 0 );
                  return 1;
            },
        },
    },
});
MT->add_plugin( $plugin );

sub instance { $plugin; }

use MT::L10N::ja;

## original l10n
my $l10n_backup = {};
my $plugin_l10n_backup = {};

# translate  phrases using original lexicon (for tag)
sub _org_trans_hdlr {
    my ($ctx, $args, $cond) = @_;

	my $phrase = $args->{phrase}
		or return "";
#	my $trans_args = $args->{args};

	# retrieve original lexicon.
	_org_trans($phrase);
}

# translate  phrases using original lexicon.
sub _org_trans {
	my ($phrase) = @_;

	my $plugin = instance();
#	my $plugin_lexicons = $plugin->{plugin_l10n_backup}
	my $plugin_lexicons = $plugin_l10n_backup
		or $plugin->translate($phrase);

	# when there is no original lexicon, use MT translate.

#	MT->log('ref ($plugin_lexicons) :' . ref ($plugin_lexicons) );
#	MT->log('scalar(%$plugin_lexicons) :' . scalar(%$plugin_lexicons));

	unless ( (ref ($plugin_lexicons) eq 'HASH') && scalar(%$plugin_lexicons) ) {
		return $plugin->translate($phrase);
	}

#	MT->log("plugin->{plugin_sig} : " . $plugin->{plugin_sig});

	my $my_lexicon = $plugin_lexicons->{$plugin->{plugin_sig}}
		or $plugin->translate($phrase);

	$my_lexicon->{$phrase} || $l10n_backup->{$phrase} || "";
}

sub _cb_pre_run {
    my ($cb, $app) = @_;
    &_replace_lexicon( $app , $app->param('blog_id') || 0 );
    return 1;
}

sub _sitemap_action_menu {
   my ( $cb , $app, $class, undef, undef, undef, $blog_id, $tmpl ) = @_;

   my $sitemap = MT->component('Sitemap') or return 1;

   my $app_blog_id = $app->param('blog_id') || 0;
   $blog_id = $blog_id || 0;
   &_replace_lexicon( $app , $blog_id );
   $$tmpl = $sitemap->translate_templatized( $$tmpl ); 
   return 1;

}

sub _replaces_config {
	my ($blog_id) = @_;

   ## system scope
    my $config = _build_replacing_template( 'system') || "";

    if ( $blog_id ) {
        my $blog = $blog_id
              ? MT::Blog->load( $blog_id )
              : undef;
        if ( $blog ) {
            my $r = _build_replacing_template( "blog:" . ( $blog->is_blog ? $blog->website->id : $blog->id ) );
            $config .= sprintf ( "\n%s" , $r ) if $r;
            if ( $blog->is_blog ) {
                 $r = _build_replacing_template( "blog:" . $blog->id );
                 $config .= sprintf ( "\n%s" , $r ) if $r;
            }
        }
    }
#	MT->log('$config 2: ' . $config);

	$config;
}

# keys of replace expressions.
my @EXPRESSION_KEYS = qw(entry page asset comment);
my $REPLACE_TERMS = {
	'ja' => {
		'entry' => ['ブログ記事', '記事'],
		'page' => ['ウェブページ'],
		'asset' => ['アイテム'],
		'comment' => ['コメント'],
	},
};

# build expression template for replacing lexicons.
sub _build_replacing_template {
	my ($scope) = @_;

	my @config;

	for my $key (@EXPRESSION_KEYS) {
		my $expression =  _build_expression($key, $scope)
			or next;
		push @config,  $expression;
	}

	push( @config, instance()->get_config_value('replaces', $scope) );

	join "\n", @config;
}

# build replace expression for each term.
sub _build_expression {
	my ($term, $scope) = @_;

	my $new_val = instance()->get_config_value("replaces_$term", $scope)
		or return "";

	my $old_term_ref = $REPLACE_TERMS->{ja}->{$term}
		or return "";

	my @expressions;
	for my $old_term (@$old_term_ref) {

		my $old_val = Encode::decode( 'UTF-8', $old_term || "")
			or next;

		push @expressions, "$old_val|$new_val";
	}

	join "\n", @expressions;
}

sub _make_replaceable_lexicon {
    my ( $app , $blog_id ) = @_;

    ## system scope
	my $config = _replaces_config($blog_id);

    return "" unless $config;

    my $replaces = {};
    foreach ( split /[\r\n]/, $config ) {
        next if /^#/;
        next if /^\s*$/;
        s/^\s+|\s+$//g;
        my ($from, $to) = split /\|/;
        next if $from =~/^\s*$/;
        $replaces->{$from} = $to;
    }
    return keys %$replaces ? $replaces : "";
}

sub _get_plugin_lexicon_class {
    my ( $plugin_sig ) = @_;

    no strict 'refs';
    my $obj = $MT::Plugins{$plugin_sig}{object} or return '';
    $obj->translate('');
    my $handles = MT->request('l10n_handle') or return '';
    my $class = ref( $handles->{$obj->id} );
    my $ref;
    eval { $ref = \%{$class.'::Lexicon'} };

    return $ref;
}

sub _replace_lexicon {
    my ( $app , $blog_id ) = @_;
    no strict "refs";

    my $replaces;
    my $froms;
    $replaces = &_make_replaceable_lexicon( $app , $blog_id ) || {};
    $froms = join '|', map { quotemeta } keys %$replaces;

    if ( keys %$l10n_backup ) {

        unless ( $froms ) {

             $MT::L10N::ja::Lexicon{$_} = $l10n_backup->{$_}
                    for keys %MT::L10N::ja::Lexicon;

             for my $sig ( keys %$plugin_l10n_backup ) {

                 my $ref = &_get_plugin_lexicon_class( $sig ) or next;
                 my $backup = $plugin_l10n_backup->{$sig};

                 $ref->{$_} = $backup->{$_}
                    for keys %$ref;

             }
             return;

        }

        for ( keys %MT::L10N::ja::Lexicon ) {

            my $to = $l10n_backup->{$_};
            $to =~ s/($froms)/$replaces->{$1}/g;
            $MT::L10N::ja::Lexicon{$_} = $to;
        }

        for my $sig ( keys %$plugin_l10n_backup ) {

            my $ref = &_get_plugin_lexicon_class( $sig ) or next;
            my $backup = $plugin_l10n_backup->{$sig};
            for ( keys %$ref ) {

                 my $to = $backup->{$_};
                 $to =~ s/($froms)/$replaces->{$1}/g;
                 $ref->{$_} = $to;

            }

        }

    } else {

        return unless $froms;

        for ( keys %MT::L10N::ja::Lexicon ) {

            my $to = ref ( $MT::L10N::ja::Lexicon{$_} ) eq 'SCALAR' 
                  ? ${$MT::L10N::ja::Lexicon{$_}}
                  : $MT::L10N::ja::Lexicon{$_};
            
            $l10n_backup->{$_} = $to;
            $to =~ s/($froms)/$replaces->{$1}/g;
            $MT::L10N::ja::Lexicon{$_} = $to; 
        }

        for my $sig ( keys %MT::Plugins ) {

            my $ref = &_get_plugin_lexicon_class( $sig ) or next;
            my $backup = {};
            for ( keys %$ref ) {

                my $to = ref ( $ref->{$_} ) eq 'SCALAR'
                     ? ${$ref->{$_}}
                     : $ref->{$_};

                $backup->{$_} = $to;
                $to =~  s/($froms)/$replaces->{$1}/g;
                $ref->{$_} = $to;

            }
            $plugin_l10n_backup->{$sig} = $backup;
        }
    }
}

1;
