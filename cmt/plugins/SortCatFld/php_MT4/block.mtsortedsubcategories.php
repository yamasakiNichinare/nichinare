<?php
function smarty_block_mtsortedsubcategories ($args, $content, &$ctx, &$repeat) {

    unset($ctx->mt->db->_cat_id_cache);

    $localvars = array('subCatTokens', 'subCatsSortOrder', 'subCatsSortMethod', '__categories', 'inside_mt_categories', '_subcats_counter', 'entries', 'subCatIsFirst', 'subCatIsLast', 'category','current_archive_type');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $token_fn = $args['token_fn'];

        $blog_id = $ctx->stash('blog_id');

        $class = 'category';
        if (isset($args['class'])) {
            $class = $args['class'];
        }

        # Do we want the current category?
        $include_current = $args['include_current'];

        $top = $args['top'];

        # Sorting information#   sort_order ::= 'ascend' | 'descend'
        #   sort_method ::= method name (e.g. package::method)
        #
        # sort_method takes precedence
        $sort_order = isset($args['sort_order']) ? $args['sort_order'] : 'ascend';
        $sort_method = $args['sort_method'];
        $sort_method = 'order_number';

        # Store the tokens for recursion
        $ctx->stash('subCatTokens', $token_fn);
        $ctx->stash('current_archive_type', 'Category');

        # If we find ourselves in a category context 
        if (!$top) {
            if ($args['category']) {
                require_once("MTUtil.php");
                $current_cat = cat_path_to_category($args['category'], $blog_id);
                if ( is_array( $current_cat ) )
                    $current_cat = $current_cat[0];
            }
            if ($current_cat == NULL) {
                $current_cat = $ctx->stash('category') or $ctx->stash('archive_category');
            }
        }
        if (!$top && !$args['top_level_categories'] && $current_cat) {
            if ($include_current) {
                # If we're to include it, just use it to seed the category list
                $cats = array($current_cat);
            } else {
                # Otherwise, use its children
                $cats = _fetch_categories(array('blog_id' => $blog_id, 'category_id' => $current_cat['category_id'], 'children' => 1, 'show_empty' => 1, 'sort_order' => $sort_order, 'class' => $class), $ctx);
            }
        }
        if (($top || $args['top_level_categories']) && !$cats) {
            # Otherwise, use the top level categories
            $cats = _fetch_categories(array('blog_id' => $blog_id, 'top_level_categories' => 1, 'show_empty' => 1, 'sort_order' => $sort_order, 'class' => $class), $ctx);
        }
        if (!$cats) {
            $ctx->restore($localvars);
            $repeat = false;
            return '';
        }

        $ctx->stash('__categories', $cats);
        # Be sure the regular MT tags know we're in a category context
        $ctx->stash('inside_mt_categories', 1);
        $ctx->stash('subCatsSortOrder', $sort_order);
        $ctx->stash('subCatsSortMethod', $sort_method);
        $ctx->stash('_subcats_counter', 0);
        $count = 0;
    } else {
        # Init variables
        $cats = $ctx->stash('__categories');
        $count = $ctx->stash('_subcats_counter');
    }

    # Loop through the immediate children (or the current cat,
    # depending on the arguments
    if ($count < count($cats)) {
        $category = $cats[$count];
        $ctx->stash('category', $category);
        $ctx->stash('entries', null);
        $ctx->stash('subCatIsFirst', $count == 0);
        $ctx->stash('subCatIsLast', $count == (count($cats) - 1));
        $ctx->stash('subFolderHead', $count == 0);
        $ctx->stash('subFolderFoot', $count == (count($cats) - 1));
        $ctx->stash('_subcats_counter', $count + 1);
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;

}

function _fetch_categories($args, $ctx) {
        # load categories
        if ($blog_filter = $ctx->mt->db->include_exclude_blogs($args)) {
             $blog_filter = 'and category_blog_id '. $blog_filter;
        } elseif (isset($args['blog_id'])) {
            $blog_filter = 'and category_blog_id = '.intval($args['blog_id']);
        }
        if (isset($args['parent'])) {
            $parent = $args['parent'];
            if (is_array($parent)) {
                $parent_filter = 'and category_parent in (' . implode(',', $parent) . ')';
            } else {
                $parent_filter = 'and category_parent = '.intval($parent);
            }
        }
        if (isset($args['category_id'])) {
            if (isset($args['children'])) {
                if (isset($ctx->mt->db->_cat_id_cache['c'.$args['category_id']])) {
                    $cat = $ctx->mt->db->_cat_id_cache['c'.$args['category_id']];
                    if (isset($cat['_children'])) {
                        $children = $cat['_children'];
                        if ($children === false) {
                            return null;
                        } else {
                            return $children;
                        }
                    }
                }

                $cat_filter = 'and category_parent = '.intval($args['category_id']);
            } else {
                $cat_filter = 'and category_id = '.intval($args['category_id']);
                $limit = 1;
            }
        } elseif (isset($args['label'])) {
            if (is_array($args['label'])) {
                $labels = '';
                foreach ($args['label'] as $c) {
                    if ($labels != '')
                        $labels .= ',';
                    $labels .= "'".$ctx->mt->db->escape($c)."'";
                }
                $cat_filter = 'and category_label in ('.$labels.')';
            } else {
                $cat_filter = 'and category_label = \''.$ctx->mt->db->escape($args['label']).'\'';
            }
        } else {
            $limit = $args['lastn'];
            if (isset($args['sort_order'])) {
                if ($args['sort_order'] == 'ascend') {
                    $sort_order = 'asc';
                } elseif ($args['sort_order'] == 'descend') {
                    $sort_order = 'desc';
                }
            } else {
                $sort_order = '';
            }
        }

        $count_column = 'placement_id';
        if ($args['show_empty']) {
            $join_clause = 'left outer join mt_placement on placement_category_id = category_id';
            if (isset($args['entry_id'])) {
                $join_clause .= ' left outer join mt_entry on placement_entry_id = entry_id and entry_id = '.intval($args['entry_id']);
            } else {
                $join_clause .= ' left outer join mt_entry on placement_entry_id = entry_id and entry_status = 2';
            }
            $count_column = 'entry_id';
        } else {
            $join_clause = ', mt_entry, mt_placement';
            $cat_filter .= ' and placement_category_id = category_id';
            if (isset($args['entry_id'])) {
                $entry_filter = 'and placement_entry_id = entry_id and placement_entry_id = '.intval($args['entry_id']);
            } else {
                $entry_filter = 'and placement_entry_id = entry_id and entry_status = 2';
            }
        }

        if (isset($args['class'])) {
            $class = $ctx->mt->db->escape($args['class']);
        } else {
            $class = "category";
        }
        $class_filter = "and category_class='$class'";

        $sql = "
            select category_id, count($count_column) as category_count
              from mt_category $join_clause
             where 1 = 1
                   $cat_filter
                   $entry_filter
                   $blog_filter
                   $parent_filter
                   $class_filter
             group by category_id
                   <LIMIT>
        ";
        $sql = $ctx->mt->db->apply_limit_sql($sql, $limit, $offset);

        $categories = $ctx->mt->db->get_results($sql, ARRAY_A);


        if (!$categories) {
            return null;
        }
        if (isset($args['children']) && isset($parent_cat)) {
            $parent_cat['_children'] =& $categories;
        } else {
            $ids = array();
            $counts = array();
            foreach ($categories as $cid => $cat) {
                $counts[$cat['category_id']] = $cat['category_count'];
                $ids[] = $cat['category_id'];
            }
            $list = implode(",", $ids);
            $sql2 = "
                select mt_category.*, mt_trackback.*
                    from mt_category left outer join mt_trackback on trackback_category_id = category_id
                   where category_id in ($list)
                order by category_order_number $sort_order
            ";
            $categories = $ctx->mt->db->get_results($sql2, ARRAY_A);
            $id_list = array();
            foreach ($categories as $cid => $cat) {
                $cat_id = $cat['category_id'];
                $categories[$cid]['category_count'] = $counts[$cat_id];
                if (isset($args['top_level_categories']) || !isset($ctx->mt->db->_cat_id_cache['c'.$cat_id])) {
                    $id_list[] = $cat_id;
                    $ctx->mt->db->_cat_id_cache['c'.$cat_id] = $categories[$cid];
                }
                if (isset($args['top_level_categories'])) {
                    $ctx->mt->db->_cat_id_cache['c'.$cat_id]['_children'] = false;
                }
            }

            $top_cats = array();
            foreach ($categories as $cid => $cat) {
                if ($cat['category_parent'] > 0) {
                    $parent_id = $cat['category_parent'];
                    if (isset($ctx->mt->db->_cat_id_cache['c'.$parent_id])) {
                        if (isset($args['top_level_categories'])) {
                            $parent =& $ctx->mt->db->fetch_category($categories[$cid]['category_parent']);
                            if (!isset($parent['_children']) || ($parent['_children'] === false)) {
                                $parent['_children'] = array(&$categories[$cid]);
                            } else {
                                $parent['_children'][] = $categories[$cid];
                            }
                        }
                    }
                }
                if ((!$cat['category_parent']) && (isset($args['top_level_categories']))) {
                    $top_cats[] = $categories[$cid];
                }
            }
            $ctx->mt->db->cache_category_links($id_list);
            if (isset($args['top_level_categories'])) {
                return $top_cats;
            }
        }
        return $categories;
}
?>
