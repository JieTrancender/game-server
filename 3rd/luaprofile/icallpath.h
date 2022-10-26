#ifndef _ICALLPATH_H_
#define _ICALLPATH_H_

#include <unistd.h>
#include <stdint.h>

struct icallpath_context;

struct icallpath_context* icallpath_create(uint64_t key, void* value);
void icallpath_free(struct icallpath_context* icallpath);

struct icallpath_context* icallpath_get_child(struct icallpath_context* icallpath, uint64_t key);
struct icallpath_context* icallpath_add_child(struct icallpath_context* icallpath, uint64_t key, void* value);
void* icallpath_getvalue(struct icallpath_context* icallpath);

typedef void(*observer)(uint64_t key, void* value, void* ud);
void icallpath_dump_children(struct icallpath_context* icallpath, observer observer_cb, void* ud);
size_t icallpath_children_size(struct icallpath_context* icallpath);


#endif
