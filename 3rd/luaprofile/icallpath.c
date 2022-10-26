#include "profile.h"
#include "icallpath.h"
#include "imap.h"

struct icallpath_context {
    uint64_t key;
    void* value;
    struct imap_context* children;
};

struct icallpath_context* icallpath_create(uint64_t key, void* value) {
    struct icallpath_context* icallpath = (struct icallpath_context*)pmalloc(sizeof(*icallpath));
    icallpath->key = key;
    icallpath->value = value;
    icallpath->children = imap_create();

    return icallpath;
}

void icallpath_free_child(uint64_t key, void* value, void* ud) {
    icallpath_free((struct icallpath_context*)value);
}
void icallpath_free(struct icallpath_context* icallpath) {
    if (icallpath->value) {
        pfree(icallpath->value);
        icallpath->value = NULL;
    }
    imap_dump(icallpath->children, icallpath_free_child, NULL);
    imap_free(icallpath->children);
    pfree(icallpath);
}

struct icallpath_context* icallpath_get_child(struct icallpath_context* icallpath, uint64_t key) {
    void* child_path = imap_query(icallpath->children, key);
    return (struct icallpath_context*)child_path;
}

struct icallpath_context* icallpath_add_child(struct icallpath_context* icallpath, uint64_t key, void* value) {
    struct icallpath_context* child_path = icallpath_create(key, value);
    imap_set(icallpath->children, key, child_path);
    return child_path;
}

void* icallpath_getvalue(struct icallpath_context* icallpath) {
    return icallpath->value;
}

void icallpath_dump_children(struct icallpath_context* icallpath, observer observer_cb, void* ud) {
    imap_dump(icallpath->children, observer_cb, ud);
}

size_t icallpath_children_size(struct icallpath_context* icallpath) {
    return imap_size(icallpath->children);
}