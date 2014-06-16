COMPONENT=TestNetworkLplAppC
CONTRIBDIR=$(shell pwd)

PFLAGS += -DCC2420_DEF_CHANNEL=26

CFLAGS += -DLOW_POWER_LISTENING
CFLAGS += -DLPL_DEF_LOCAL_WAKEUP=1024
CFLAGS += -DLPL_DEF_REMOTE_WAKEUP=1024
CFLAGS += -DDELAY_AFTER_RECEIVE=20

#TWIST = 1

ifdef TWIST
CFLAGS += -DSINK_ID=153
CFLAGS += -DCC2420_DEF_RFPOWER=3
else
CFLAGS += -DSINK_ID=1
endif

#CFLAGS += -DCC2420_DEF_CHANNEL=12
CFLAGS += -I.
CFLAGS += -I../TestNetwork

CTPDIR = $(TOSDIR)/lib/net/ctp

CFLAGS += -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/drip \
          -I$(TOSDIR)/lib/net/4bitle \
          -I$(CONTRIBDIR)/tos/chips/cc2420/interfaces \
          -I$(CONTRIBDIR)/tos/chips/cc2420/lpl \
          -I$(CONTRIBDIR)/tos/chips/cc2420/dc \
          -I$(CONTRIBDIR)/tos/chips/cc2420/receive \
          -I$(CONTRIBDIR)/tos/lib/net/ctp #-DNO_DEBUG
		  

TFLAGS += -I$(TOSDIR)/../apps/tests/TestDissemination \
          -I$(TOSDIR)/../support/sdk/c \
          -I$(TOSDIR)/types \
          -I.

LIBMOTE = $(TOSDIR)/../support/sdk/c/libmote.a
#BUILD_EXTRA_DEPS += tn-injector #tn-listener
LISTEN_OBJS = collection_msg.o test_network_msg.o tn-listener.o $(LIBMOTE)
INJECT_OBJS = set_rate_msg.o tn-injector.o collection_debug_msg.o $(LIBMOTE)

BUILD_EXTRA_DEPS +=   dummy.class Collection_Debug.class #TestNetworkMsg.class
CLEAN_EXTRA = *.class *.java

dummy.java: dummy.h
	mig -target=telosb -I$(TOSDIR)/lib/net/ctp  -java-classname=dummy java dummy.h dummy -o $@

dummy.class: dummy.java
	javac -source 1.4 -target 1.4  dummy.java

Collection_Debug.java: $(CTPDIR)/CtpDebugMsg.h
	mig -target=telosb -I$(TOSDIR)/lib/net/ctp -java-classname=Collection_Debug java  Collection_Debug.h Collection_Debug -o $@

Collection_Debug.class: Collection_Debug.java
	javac -source 1.4 -target 1.4  Collection_Debug.java

TestNetworkMsg.java: TestNetwork.h
	mig -target=telosb -I$TOSDIR/lib/CC2420Radio  -java-classname=TestNetworkMsg java TestNetwork.h TestNetworkMsg -o $@

TestNetworkMsg.class: TestNetworkMsg.java
	javac -source 1.4 -target 1.4  TestNetworkMsg.java


# arguments: output filename stem, input filename, struct name
define mig_templ
MIGFILES += $(1).c $(1).h $(1).java $(1).o
$(1).c:
	mig -o $(1).h c -target=$$(PLATFORM) $$(CFLAGS) $$(TFLAGS) $(2) $(3)
$(1).java:
	mig -o $(1).java java -target=$$(PLATFORM) $$(CFLAGS) $$(TFLAGS) $(2) $(3)
endef

$(eval $(call mig_templ,test_network_msg,TestNetwork.h,TestNetworkMsg))
$(eval $(call mig_templ,set_rate_msg,$(TOSDIR)/lib/net/DisseminationEngine.h,dissemination_message))
$(eval $(call mig_templ,collection_debug_msg,$(TOSDIR)/lib/net/collection/CollectionDebugMsg.h,CollectionDebugMsg))

%.o: %.c
	gcc -v  $(TFLAGS) $(CFLAGS) -c -o $@ $<

tn-listener: $(LISTEN_OBJS)
	gcc -v $(TFLAGS) $(CFLAGS) -o $@ $(LISTEN_OBJS)

tn-injector: $(INJECT_OBJS)
	gcc -v $(TFLAGS) $(CFLAGS) -o $@ $(INJECT_OBJS)

#tn-listener.o: tn-listener.c
#	gcc $(TFLAGS) $(CFLAGS) -c -o $@ $<

tn-injector.o: tn-injector.c test_network_msg.c
	gcc $(TFLAGS) $(CFLAGS) -c -o $@ $<

#test_network_msg.c:
#	mig -o test_network_msg.h c -target=$(PLATFORM) $(CFLAGS) $(TFLAGS) TestNetwork.h TestNetworkMsg 

#set_rate_msg.c:
#	mig -o set_rate_msg.h c -target=$(PLATFORM) $(CFLAGS) $(TFLAGS) $(TOSDIR)/lib/net/DisseminationEngine.h dissemination_message

#set_rate_msg.o: set_rate_msg.c
#	gcc $(CFLAGS) $(TFLAGS) -c -o $@ $<

#test_network_msg.o: test_network_msg.c
#	gcc $(CFLAGS) $(TFLAGS) -c -o $@ $<

#collection_msg.c:
#	mig -o collection_msg.h c -target=$(PLATFORM) $(CFLAGS) $(TFLAGS) $(TOSDIR)/lib/net/collection/ForwardingEngine.h collection_header

include $(MAKERULES)

migclean:
	rm -rf $(MIGFILES)
