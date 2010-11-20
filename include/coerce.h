#ifndef __COERCE_H__
#define __COERCE_H__

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

#ifdef __COERE_USE_GC__

void *GC_malloc(size_t);
void *GC_calloc(size_t, size_t);
void *GC_realloc(void *, size_t);
void GC_free(void *);

#define YY_ALLOC(N, D)      GC_malloc(N)
#define YY_CALLOC(N, S, D)  GC_malloc((N) * (S))
#define YY_REALLOC(B, N, D) GC_realloc(B, N)
#define YY_FREE             GC_free

#else

#define YY_ALLOC(N, D)      malloc(N)
#define YY_CALLOC(N, S, D)  calloc(N, S)
#define YY_REALLOC(B, N, D) realloc(B, N)
#define YY_FREE             free

#endif

//int vars[26];

typedef struct {
    void *next;
    void *prev;
} LList;

typedef struct {
    unsigned int length;
    char *string;
} CoereString;

typedef struct {
    double num;
    String string;
} CoereValue;

#endif
