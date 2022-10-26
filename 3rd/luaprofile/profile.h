#ifndef _PROFILE_H_
#define _PROFILE_H_

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <lauxlib.h>
#include <time.h> 
#include <assert.h>
#include <stdbool.h>
#include <string.h>

#include <lua.h>

#define prealloc  realloc
#define pmalloc   malloc
#define pfree  free
#define pcalloc calloc

#endif