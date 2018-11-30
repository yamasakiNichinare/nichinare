package CategoryImExporter::CMS;

use strict;
use warnings;
use MT;
use MT::Permission;
use MT::Category;
use MT::I18N;
use base qw( MT::App );
use File::Basename;
use Text::CSV_PP;
use Data::Dumper;

# CAN'T work without CustomField
eval {
    require CustomFields::Util;
    require CustomFields::Field;
};

my $cf_enable = $@ ? 0 : 1;
my $plugin = MT->component( 'CategoryImExporter' );

###
sub condition {
    my $app = MT->app
        or return 0;
    my $blog = $app->blog
        or return 0;
    my $user = $app->user
        or return 0;
    return 1 if $user->is_superuser;
    my $perms = MT::Permission->load ({ blog_id => $blog->id, author_id => $user->id })
        or return 0;
    $perms->permissions =~ /'(?:administer(?:_(?:website|blog))?|edit_categories|manage_pages)'/;
}



### Method - category_im_exporter
sub category_im_exporter { my ($app) = @_; $app->param ('_type', 'category'); return _im_exporter ($app); }

### Method - folder_im_exporter
sub folder_im_exporter { my ($app) = @_; $app->param ('_type', 'folder'); return _im_exporter ($app); }

sub _im_exporter {
    my ($app) = @_;

    return $app->return_to_dashboard (permission => 1)
        unless condition();

    my %param;
    if ($app->param ('do') && $app->param ('do') eq 'export') {
        return _export ($app, \%param);
    }
    if ($app->param ('do') && $app->param ('do') eq 'import') {
        _import ($app, \%param);
    }
    $param{_type} = $app->param('_type') || 'category';
    $param{blog_id} = $app->blog->id;

    return $app->error($app->translate('Invalid request'))
       if !$app->blog->is_blog && $param{_type} eq 'category';

    return $plugin->load_tmpl ('im_exporter.tmpl', \%param);
}



### Exporting
my (@label, @cf_label, $max_indent);

sub _export {
    my ($app) = @_;

    my $blog_id = $app->blog->id;
    my $_type = $app->param('_type') || 'category';

    # Retrieve the max depth of category
    $max_indent = _export_category ($app, $blog_id, $_type, undef, 1, 1);

    # HTTP Header
    $app->{no_print_body} = 1;
    printf "Content-type: text/csv; charset=Shift_JIS\n";
    printf "Content-disposition: attachement; filename=blog%d_%s_setting.csv\n", $blog_id, $_type;
    printf "\n";

    # Category label enumeration
    @label = ( 'id', ('') x $max_indent, ('') );
    $label[1 + $max_indent * 0] = 'basename';
    $label[1 + $max_indent * 1] = 'label';
    map { push @label, $_ } grep { !/^(id|basename|label|parent)$/i } sort @{MT::Category->column_names};

    # CustomField enumeration
    if ($cf_enable) {
        my %tmp;
        map {
            push @cf_label, $_->basename if !$tmp{$_->basename}++;
        } CustomFields::Field->load ({ blog_id => 0, obj_type => $_type });
        map {
            push @cf_label, $_->basename if !$tmp{$_->basename}++;
        } CustomFields::Field->load ({ blog_id => $blog_id, obj_type => $_type });
        push @label, @cf_label;
    }

    # Go ahead
    print join (',', map { qq/"$_"/ } @label). "\n";
    _export_category ($app, $blog_id, $_type, undef, 0); # recursively enumeration
}

sub _export_category {
    my ($app, $blog_id, $_type, $category, $indent, $no_print) = @_;

    my $have_cat = 0;
    my $ret_depth = $indent;
    my $iter = MT::Category->load_iter ({
        blog_id => $blog_id, class => $_type, parent => $category ? $category->id : 0,
    }, {
        MT::Category->can('order_number')
            ? (sort => 'order_number')
            : (sort => 'label'),
        direction => 'ascend',
    });
    while (my $cat = $iter->()) {
        unless ($no_print) {
            my @data = ( $cat->id, ('') x $max_indent, ('') );
            $data[1 + $max_indent * 0 + $indent] = $cat->basename;
            $data[1 + $max_indent * 1          ] = $cat->label;
            map { push @data, export_filter($cat->$_ , $_) } grep { !/^(id|basename|label|parent)$/i } sort @{MT::Category->column_names};

            # CustomField enumeration
            if ($cf_enable) {
                my $meta = CustomFields::Util::get_meta ($cat);
                map { push @data, export_filter($meta->{$_} , $_ ) } @cf_label;
            }

            my $out = join (',', map { qq/"$_"/ } @data). "\n";
            $out = MT::I18N::utf8_off ($out) if 5 <= MT->VERSION;
            print MT::I18N::encode_text ($out, $app->charset, 'sjis');
        }

        my $sub_ret = _export_category ($app, $blog_id, $_type, $cat, $indent + 1, $no_print); # recursively enumeration
        $ret_depth = $ret_depth < $sub_ret ? $sub_ret : $ret_depth;
        $have_cat = 1;
    }
    return $have_cat ? $ret_depth : 0;
}
sub export_filter {
    my ($data , $name ) = @_; 

    ## date type
    return sprintf "%04d-%02d-%02d %02d:%02d:%02d" , $data=~ /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/
       if $name =~ /modified_on|created_on/i;

    ## numeric array
    return sprintf "[%s]" , $data
        if $data =~ m/^[0-9,]+$/ && $data =~ m/,/;

    return $data;
}

### Importing
sub _import {
    my ($app, $param) = @_;

    my $blog_id = $app->blog->id;
    my $_type = $app->param('_type') || 'category';

    # Check - File
    my $fh = $app->{query}->upload ('file');
    if (!$fh) {
        $param->{ERROR_MSG} = $plugin->translate ('File upload error');
        return; # error
    }
    # Check - File Type
    my $suffix = _get_suffix ($fh);
    if ($suffix !~ m/(?:csv)$/i) {
        $param->{ERROR_MSG} = $plugin->translate ('CSV file type error: [_1]', $suffix);
        return; # error
    }

    # CustomField enumeration
    my %cf_basename;
    if ($cf_enable) {
        map {
            push @cf_label, $_->basename if !$cf_basename{$_->basename}++;
        } CustomFields::Field->load ({ blog_id => 0, obj_type => $_type });
        map {
            push @cf_label, $_->basename if !$cf_basename{$_->basename}++;
        } CustomFields::Field->load ({ blog_id => $blog_id, obj_type => $_type });
    }

    my $overwrite = $app->param('overwrite');
    my $line = 1;
    my ($_id, $_basename, $_label, $_others);       # memo of columns
    my ($create, $update, $skip, $error ,$warning); # memo of results
    my @categories;

    my $line_number = 0;
    my $csvparser = Text::CSV_PP->new ({ binary => 1 });
    foreach (<$fh>) {
        $line_number++;

        my @columns;
        unless( $csvparser->parse ($_) && (@columns = $csvparser->fields) ){
            error_log(
                $app , 
                $plugin->translate( 'Failed to parse csv. line:[_1]' , $line_number  ),
                $blog_id,
            );
            $error++;
            next;
        }

        # Labels
        if ($line++ == 1) {
            foreach (0..$#columns) {
                $_basename && $_label && !$_others && $columns[$_] ne ''
                    ? ($_others = $_) : undef;
                $columns[$_] eq 'id'
                    ? ($_id = $_) : undef;
                $columns[$_] eq 'basename'
                    ? ($_basename = $_) : undef;
                $columns[$_] eq 'label'
                    ? ($_label = $_) : undef;
                push @label, $columns[$_];
            }
            if (!defined $_id || !defined $_basename) {
                error_log(
                   $app , 
                   $plugin->translate( 'Culumns [_1] and [_2] are required.' , 'id' , 'basename'  ),
                   $blog_id,
                );
                return;
            }
        }
        # Data
        else {
            my $category;
            # Object creating/Loading
            if ($columns[$_id]) {
                if ($category = MT::Category->load ({ id => $columns[$_id] })) {
                    if ($overwrite) {
                        $update++;
                        if( $category->blog_id != $blog_id ){
                            error_log(
                                $app,
                                $plugin->translate('ID([_1]) can not be used. Are already available on other blogs or websites. line: [_2]', $category->id , $line_number ),
                                $blog_id,
                            );
                            $error++;
                            next;
                        }
                    }
                    else {
                        $skip++;
                        next;
                    }
                }
            }
            if (!$category) {
                ## カスタムフィールドの値を新規で登録するには
                ## 直接対象のオブジェクトを作成してはならない。
                my $class = $app->model($_type);
                $category = $class->new;
                $category->id ($columns[$_id]) if $columns[$_id];
                $create++;
            }
            $category->blog_id ($blog_id);
            $category->class ($_type);

            # basename
            $category->parent (0);
            foreach ($_basename..$_others ) {
                if (defined $columns[$_] && $columns[$_] ne '' && ( $label[$_] eq 'basename' || !$label[$_] ) ) {
                    $columns[$_] =~ s![\\/]!!g;
                    $category->basename ($columns[$_]);
                    # sub categories
                    $categories[$_] = $category;
                    $category->parent ($categories[$_ - 1]->id)
                        if $_basename < $_ && defined $categories[$_ - 1];
                    last;
                }
            }
            unless ( $category->basename eq '0' || $category->basename ) {
                error_log(
                    $app,
                    $plugin->translate('Column ([_1]) You must enter a value. This column is required. line:[_2]' , 'basename' , $line_number ),
                    $blog_id,
                );
                $error++;
                next;
            }

            # category_label
            $category->label ($category->basename);
            if (defined $_label) {
                foreach ($_label..$#columns) {
                    if (defined $columns[$_] && $columns[$_] ne '' && ( $label[$_] eq "label" || !$label[$_] ) ) {
                        if (5 <= MT->VERSION) {
                            $category->label (Encode::decode ('sjis', $columns[$_]));
                        } else {
                            $category->label (MT::I18N::encode_text ($columns[$_], 'sjis', $app->charset));
                        }
                        last;
                    }
                }
            }
            my $default_columns = $category->properties->{'defaults'};
            foreach ($_others..$#label) {

                my $column_name = $label[$_] or next;
                next if $column_name =~ m/^class|blog_id$/;

                my $data = $columns[$_]
                      ? $columns[$_]
                      : $default_columns->{$column_name} || undef;

                if ($category->can($column_name)) {

                    $data = import_filter( $data  , $column_name );

                    if( $column_name =~ m/modified_on|created_on/ ){
                         $data ||= undef;
                         unless( !$data || $data =~ m/^\d{14}$/ ) {
                             $data = $default_columns->{$column_name}  || undef;
                             warning_log(
                                 $app,
                                 $plugin->translate('Datetime column ([_1]) improper values, we substitute a default value. line: [_2]', $column_name , $line_number ),
                                 $blog_id,
                             );
                             $warning++;
                         }
                    }

                    if (5 <= MT->VERSION) {
                        $category->$column_name (Encode::decode ('sjis', $data));
                    } else {
                        $category->$column_name (MT::I18N::encode_text ($data, 'sjis', $app->charset));
                    }
                }
            }

            unless( $category->save ){
                error_log(
                   $app,
                   $plugin->translate('Failed to save. line: [_1] [_2]' , $line_number , $category->errstr ),
                   $blog_id,
                );
                $error++;
            }

            # CustomField registration
            if ($cf_enable && $category->has_meta ) {
                 my ( $field , $meta );
                 $meta = CustomFields::Util::get_meta ( $category ) || {};
                 foreach ($_label..$#columns) {

                        my $column_name = $label[$_] or next;
                        next unless exists $cf_basename{$column_name};
                        $field = CustomFields::Field->load( {
                             blog_id => [ $blog_id , 0 ],
                             basename => $column_name,
                        }) or next;

                        my $data = import_filter( $columns[$_] , $column_name ); 
                        if ( $field->type eq 'datetime' ) {
                            $data ||= undef;
                            unless ( !$data || $data =~ /^\d{14}$/ ) {
                               $data = $field->default || undef;
                               warning_log(
                                  $app,
                                  $plugin->translate('Datetime column ([_1]) improper values, we substitute a default value. line: [_2]', $column_name , $line_number ),
                                  $blog_id,
                               );
                               $warning++;
                            }
                        }elsif ( $field->type eq 'checkbox' ) {
                            $data ||= $field->default if $data ne '0';
                        }else{
                            $data ||= $field->default || '';
                        }
                        if (5 <= MT->VERSION) {
                            $meta->{$column_name} = Encode::decode ('sjis', $data);
                        } else {
                            $meta->{$column_name} = MT::I18N::encode_text ($data, 'sjis', $app->charset);
                        }
                 }
                 CustomFields::Util::save_meta( $category, $meta ) if %$meta;
            }
        } # else
    }

    my $msg = $plugin->translate ('CSV file has been proceeded.');
    $msg .= '<br />'. $plugin->translate ('Lines: Total [_1] lines', $line - 2);
    $msg .= '<br />'. $plugin->translate ('Newly created: [_1] items', $create) if $create;
    $msg .= '<br />'. $plugin->translate ('Updated: [_1] items', $update) if $update;
    $msg .= '<br />'. $plugin->translate ('Skipped: [_1] items', $skip) if $skip;
    $msg .= '<br />'. $plugin->translate ('Errored: [_1] items', $error) if $error;
    $msg .= '<br />'. $plugin->translate ('Warned : [_1] items', $warning ) if $warning;
    $param->{MSG} = $msg;

    return 1; # success
}

sub import_filter {
    my ( $data , $name ) = @_;
    if( $data =~ /,/ && $data =~ /^\[([0-9,]+)\]$/ ){
        $data = $1 if $1; 
    }
    
    ## Excelを代表する表計算ソフトでcsvを編集を行うと日付書式指定されたカラムは
    ## ソフトの標準書式によって上書きされてしまい、本来のYYYY/mm/dd hh:mm:ssの形式から外れます。
    ## また、データベースへ保存の際には/-: などの区切り記号を除外した14桁に調整する必要があります。
    ## MS-SQLでは、この書式の違いにより、キャストエラーになります。

    if( $data =~ m|^\d{4}[\-\/]\d?\d[\-\/]\d?\d\s\d?\d:\d?\d(:\d?\d)?$| ){
        if( $1 ){
           return sprintf "%04d%02d%02d%02d%02d%02d" ,
               $data =~ /^(\d{4})[\-\/](\d?\d)[\-\/](\d?\d)\s(\d?\d):(\d?\d):(\d?\d)$/; 
        }
        return sprintf "%04d%02d%02d%02d%02d00" ,
            $data =~ /^(\d{4})[\-\/](\d?\d)[\-\/](\d?\d)\s(\d?\d):(\d?\d)$/; 
    }
    return $data;
}

sub error_log {
    my ( $app , $msg , $blog_id , $level ) = @_;
    $level ||= MT::Log::ERROR();
    $app->log ({
       message => sprintf ( "%s - %s" , $plugin->name , $msg ),
       level => $level,
       blog => $blog_id,
   });
}

sub warning_log {
    error_log( $_[0] , $_[1] , $_[2] , MT::Log::WARNING() );
}



### アップロードされたファイルパスから拡張子部分を得る
sub _get_suffix {
    my ($org_path, @suffixlist) = @_;

    my ($name, $path, $suffix) = File::Basename::fileparse ($org_path, @suffixlist);

    return $suffix if @suffixlist;
    return (split (/\./, $name))[-1] if index ($name, '.', 0) != -1;
    return '';
}

1;
