/*
# Movable Type (r) (C) 2007-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# JavaScript helper for Custom Fields - Category combination
# $Id: customfield_header.js 117483 2010-01-07 08:27:20Z ytakayama $
*/
MT.App.FieldCatCombinator = new Class( Component, {
    initObject: function( element, template ) {
        app.categorySelector.list.addObserver( this );
    },
    destroyObject: function() {
        arguments.callee.applySuper( this, arguments );
    },
    listItemsSelected: function( list, ids ) {
// CustomFields by Category Selection
        var cats = MT.App.categoryList;
        var customFields = window.customFields;
        var changed = false;
        // assuming ids does not have multiple ids
        for ( var idx in cats ) {
            if ( !cats.hasOwnProperty( idx ) )
                continue;
            if ( cats[idx]['id'] != ids )
                continue;
            var fields = cats[idx]['fields'];
            for ( var jdx in fields ) {
                if ( !fields.hasOwnProperty( jdx ) )
                    continue;
                var inputID = 'custom-prefs-' + customFields[fields[jdx]];
                var input = getByID(inputID);
                var used = window.customFieldByCategory;
                if ( !used )
                    window.customFieldByCategory = new Object();
                var sum = used[inputID];
                if ( !sum )
                    sum = 0;
                window.customFieldByCategory[inputID] = sum + 1;
                if ( !input || input.checked )
                    continue;
                input.checked = true;
                changed = true;
            }
        }
        if ( changed )
            setCustomFields();
    },
    listItemsUnSelected: function( list, ids ) {
// CustomFields by Category Selection
        var cats = MT.App.categoryList;
        var customFields = window.customFields;
        var changed = false;
        // assuming ids does not have multiple ids
        for ( var idx in cats ) {
            if ( !cats.hasOwnProperty( idx ) )
                continue;
            if ( cats[idx]['id'] != ids )
                continue;
            var fields = cats[idx]['fields'];
            for ( var jdx in fields ) {
                if ( !fields.hasOwnProperty( jdx ) )
                    continue;
                var inputID = 'custom-prefs-' + customFields[fields[jdx]];
                var used = window.customFieldByCategory;
                if ( !used )
                    window.customFieldByCategory = new Object();
                var sum = used[inputID];
                if ( !sum )
                    sum = 1;
                window.customFieldByCategory[inputID] = --sum;
                if ( sum <= 0 ) {
                    var input = getByID(inputID);
                    if ( !input || !input.checked )
                        continue;
                    input.checked = false;
                    changed = true;
                }
            }
        }
        if ( changed )
            setCustomFields();
    }
} );
var _ld_timeout;
DOM.addEventListener( window, "load", function() {
    _ld_timeout = window.setInterval(function() {
        if (window.app) {
            var c = new window.app.constructor.FieldCatCombinator();
            window.clearInterval(_ld_timeout);
        }
    }, 100);
});

