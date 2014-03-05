#ifndef DEBUG_H
#define DEBUG_H
#include <AM.h>
#include <Collection.h>
typedef nx_struct Collection_Debug {
    nx_uint8_t type;
    nx_union {
        nx_uint16_t arg;
        nx_struct {
            nx_uint16_t msg_uid;   
            nx_am_addr_t origin;
            nx_am_addr_t other_node;
        } msg;
        nx_struct {
            nx_am_addr_t parent;
            nx_uint8_t hopcount;
            nx_uint16_t metric;
        } route_info;
        nx_struct {
            nx_uint16_t a;
            nx_uint16_t b;
            nx_uint16_t c;
        } dbg;
    } data;
    nx_uint16_t seqno;
} Collection_Debug;
#endif
