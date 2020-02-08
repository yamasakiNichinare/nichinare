package ReferredAsset::CMS;

use strict;
use MT::ObjectAsset;
use MT::Entry;

sub MYNAME { my ($myname) = __PACKAGE__ =~ /(\w+)::/; $myname; }

sub instance { MT->component (&MYNAME); }



### Callbacks - Manage Assets
sub template_source_asset_table {
    my ($cb, $app, $tmpl) = @_;

    # list_entry/list_page
    my $old = quotemeta (<<'HTMLHEREDOC');
                    <a href="<$mt:var name="script_url"$>?__mode=view&amp;_type=<mt:var name="object_type">&amp;id=<$mt:var name="id"$>&amp;blog_id=<$mt:var name="blog_id"$>" title="<$mt:var name="file_name"$>"><$mt:var name="label" escape="html"$></a>
HTMLHEREDOC
    my $new = &instance->translate_templatized (<<'HTMLHEREDOC');
<mt:if name="referred">
  <img src="<$mt:var name="static_uri"$>images/status_icons/role-active.gif" alt="<__trans phrase="Referred from some items">" title="<__trans phrase="Referred from some items">" style="background: none;" />
<mt:else>
  <img src="<$mt:var name="static_uri"$>images/status_icons/role-inactive.gif" alt="<__trans phrase="No referred from any items">" title="<__trans phrase="No referred from any items">" style="background: none;" />
</mt:if>
HTMLHEREDOC
    $$tmpl =~ s/($old)/$new$1/;
}

sub template_param_list_asset {
    my ($cb, $app, $param) = @_;

    for (@{$param->{object_loop}}) {
        $_->{referred} = defined _get_referred ($_->{id});
    }
}

### Callbacks - Edit Asset
sub template_source_edit_asset {
    my ($cb, $app, $tmpl) = @_;

    # list_entry/list_page
    my $old = quotemeta (<<'HTMLHEREDOC');
            </mtapp:setting>
        </mt:unless>
HTMLHEREDOC
    my $new = &instance->translate_templatized (<<'HTMLHEREDOC');
<mtapp:setting
    id="referred"
    label_class="text-top"
    label="<__trans phrase="Referred from">">
<mt:if name="referred">
<ul><mt:loop name="referred">
  <mt:if name="object_ds" eq="entry">
    <li><img src="<mt:var static_uri>images/nav_icons/color/entry.gif" alt="<__trans phrase="Entries">" title="<__trans phrase="Entries">" />
      <a href="<mt:var script_uri>?__mode=view&amp;_type=entry&amp;id=<mt:var object_id>&amp;blog_id=<mt:var blog_id>"><mt:var name="title" escape="html"></a></li>
  <mt:else eq="page">
    <li><img src="<mt:var static_uri>images/nav_icons/color/page.gif" alt="<__trans phrase="Pages">" title="<__trans phrase="Pages">" />
      <a href="<mt:var script_uri>?__mode=view&amp;_type=page&amp;id=<mt:var object_id>&amp;blog_id=<mt:var blog_id>"><mt:var name="title" escape="html"></a></li>
  </mt:if>
</mt:loop></ul>
<mt:else>
<__trans phrase="No referred from any items">
</mt:if>
</mtapp:setting>
HTMLHEREDOC
    $$tmpl =~ s/($old)/$new$1/;
}

sub template_param_edit_asset {
    my ($cb, $app, $param) = @_;

    my @referred;
    for (_get_referred ($param->{id})) {
        my $hash = {
            blog_id => $_->blog_id,
            object_id => $_->object_id,
            object_ds => $_->object_ds,
            embedded => $_->embedded,
        };
        if ($_->object_ds eq 'entry') {
            my $entry = MT::Entry->load({ id => $_->object_id })
                or next; # never reach here
            $hash->{title} = $entry->title || '...';
            $hash->{object_ds} = $entry->class;
        }
        push @referred, $hash;
    }
    $param->{referred} = \@referred if @referred;
}

### Commons
sub _get_referred {
    my ($asset_id) = @_; MT::ObjectAsset->load ({ asset_id => $asset_id });
}

1;