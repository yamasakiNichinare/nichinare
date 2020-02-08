package ParentalInclude::Tags;

### Function Tag - ParentalInclude
sub ParentalInclude {
    my ($ctx, $args) = @_;

    return $ctx->error (MT->translate ('Unsupported type: [_1]', 'file'))
        if defined $args->{file};
    return $ctx->error (MT->translate ('Unsupported type: [_1]', 'name'))
        if defined $args->{name};

    my $type_name = defined $args->{widget}
        ? MT->translate ('widget')
        : defined $args->{identifier}
            ? MT->translate ('identifier')
            : MT->translate ('module');
    my $tmpl_name = $args->{module} || $args->{widget} || $args->{identifier}
        or return $ctx->error (MT->translate ('Invalid parameter'));

    # Catch the error message
    $ctx->error (MT->translate ("Can't find included template [_1] '[_2]'", MT->translate ($type_name), $tmpl_name ));
    my $error_message = $ctx->errstr;   # Keep the error message in a stock

    # Try usually except global template
    my $ret;
    $args->{global} = 0;
    $ctx->error (undef);                # Clear the error
    defined( $ret = $ctx->tag('include', $args, $cond)) # THX Amano@ToI
        and return $ret;
    $ctx->errstr eq $error_message
        or return $ret; # other error occured
    # continue when MT can't find the specified template

    # Try in parent blog/website except global template
    my $blog_id = $ctx->stash('blog')->parent_id || 0; # maybe global template
    $args->{blog_id} = $blog_id;
    $ctx->error (undef);                # Clear the error
    defined( $ret = $ctx->tag('include', $args, $cond))
        and return $ret;
    $ctx->errstr eq $error_message
        or return $ret; # other error occured
    # continue when MT can't find the specified template

    # Try in global template
    if ($blog_id) {
        $args->{blog_id} = 0; # global template
        $ctx->error (undef);            # Clear the error
        defined( $ret = $ctx->tag('include', $args, $cond))
            and return $ret;
    }

    $ret; # some errors
}

1;