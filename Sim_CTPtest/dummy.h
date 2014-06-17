#ifndef TEST_NETWORK_H
#define TEST_NETWORK_H

#include <AM.h>
#include "TestNetworkC.h"
#include "Ctp.h"

typedef nx_struct dummy {
  nx_ctp_options_t    options;
  nx_uint8_t          thl;
  nx_uint16_t         etx;
  nx_am_addr_t        origin;
  nx_uint8_t          originSeqNo;
  nx_collection_id_t  type;
  nx_am_addr_t source;
  nx_uint16_t seqno;
  nx_am_addr_t parent;
  nx_uint16_t metric;
  nx_uint16_t data;
  nx_uint8_t hopcount;
  nx_uint16_t sendCount;
  nx_uint16_t sendSuccessCount;
} TestNetworkMsg;

#endif
