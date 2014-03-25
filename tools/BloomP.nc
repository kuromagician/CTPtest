/*
 * Actual implementation of bloom filter
 * Using SAX (Shift-and-Xor) as hashing functions
 */
#include "Bloom.h"

module BloomP{
	provides interface Init;
	provides interface bloom;
}

implementation{
	uint64_t curr_hash;
	BloomF bf;
	
	/* Initializes a double bloom filter when tinyos booted*/
	command error_t Init.init() {
		memset(&bf, 0, sizeof(BloomF));
	}
	
	void init_hash(unsigned char *ptr, int size) {
		int i;
		curr_hash = *((uint64_t*)(ptr+8));
		for(i=0; i<size; i++) {
			curr_hash ^= ( curr_hash << 5 ) + ( curr_hash >> 2 ) + ptr[i];
		}
	}
	
	uint16_t get_next_hash() {
		uint16_t ret = curr_hash;
		curr_hash >>= BLOOM_HASH_SHIFT;
		return ret;
	}
	/* Bit manipulation */

	void setbit(int i) {
		/* Always set in both filters */
		bf[i/8] |= 1 << (i%8);
		}

	int getbit(int i) {
		/* Get in the active filter */
		return (bf[i/8] & (1 << (i%8))) != 0;
	}

	/*** Bloom filter implementation. Works with any hash. ***/


	/* Inserts an element in a double bloom filter */
	command BloomF* bloom.bloom_insert(unsigned char *ptr, int size) {
		int k;
		//  printf("Bloom: inserting %u\n", node_id_from_ipaddr(ptr));
		init_hash(ptr, size);
		/* For each hash, set a bit in the double bloom filter */
		for(k=0; k<BLOOM_FILTER_K; k++) {
			setbit(get_next_hash() % BLOOM_FILTER_SIZE);
		}
		return &bf;
	}
}