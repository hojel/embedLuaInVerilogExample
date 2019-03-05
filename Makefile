CDS_INST_DIR := $(shell xmroot)
CC = gcc
INCLUDE  = -I$(CDS_INST_DIR)/tools/include
OPT      = -Wall -fpic -shared
CFLAGS   = $(OPT) $(INCLUDE)
ifdef LUA_HOME
INCLUDE  += -I$(LUA_HOME)/include
LIBS     += -L$(LUA_HOME)/lib
endif
LIBS     += -llua

SHLIB = libdpi.so
CSRCS = luaEmbedded.c
VSRCS = luaEmbedded.sv

run:: $(SHLIB)
	xrun -sv $(VSRCS) -sv_lib $(SHLIB)

sim:: xcelium.d $(SHLIB)
	xmsim -messages worklib.top

xcelium.d: $(VSRCS)
	xmvlog -messages -sv $(VSRCS)
	xmelab -messages -access +RWC worklib.top
	touch $@

$(SHLIB): $(CSRCS)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

clean::
	$(RM) $(SHLIB)
	$(RM) -r xcelium.d
	$(RM) xm*.log
