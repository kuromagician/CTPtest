#ifndef BLOOM_H
#define BLOOM_H

#define BLOOM_M 512
#define BLOOM_K 3

#define BLOOM_FILTER_SIZE          BLOOM_M   /* Bloom filter size (in bits) */

#if BLOOM_FILTER_SIZE > 848
#error BLOOM_FILTER_SIZE greater than 848
#elif BLOOM_FILTER_SIZE > 512
#define BLOOM_HASH_SHIFT 10
#elif BLOOM_FILTER_SIZE > 256
#define BLOOM_HASH_SHIFT 9
#else
#define BLOOM_HASH_SHIFT 8
#endif

/* 108 bytes (864 bits) is the max we manage to fit in our 15.4 payload */
#if BLOOM_K == 0
#define OMNISCIENT_BLOOM 1
#define BLOOM_FILTER_K                      1   /* Number of hashs */
#else
#define OMNISCIENT_BLOOM 0
#define BLOOM_FILTER_K                      BLOOM_K   /* Number of hashs */
#endif

/* We implement aging through double-buffering */
typedef unsigned char BloomF[BLOOM_FILTER_SIZE / 8] ;

#endif