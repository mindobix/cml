CC=gcc
CFLAGS=-g -Wall

BINDIR=bin
BIN = $(BINDIR)/main

SRC=src
SRC_EXT = c
SRCS = $(shell find $(SRC) -name '*.$(SRC_EXT)' | sort -k 1nr | cut -f2-)

TESTSRCS = $(shell find ./$(SRC) -name '*.$(SRC_EXT)' ! -path './src/main/*' | sort -k 1nr | cut -f2-)

rwildcard = $(foreach d, $(wildcard $1*), $(call rwildcard,$d/,$2) \
						$(filter $(subst *,%,$2), $d))
ifeq ($(SRCS),)
	SRCS := $(call rwildcard, $(SRC), *.$(SRC_EXT))
endif

OBJ=obj
OBJS = $(SRCS:$(SRC)/%.$(SRC_EXT)=$(OBJ)/%.o)

ifeq ($(TESTSRCS),)
	TESTSRCS := $(call rwildcard, $(SRC), *.$(SRC_EXT))
endif

$(info TESTSRCS = $(TESTSRCS))

TEST=tests
TESTSC=$(wildcard $(TEST)/*.c)
TESTBINS=$(patsubst $(TEST)/%.$(SRC_EXT), $(TEST)/bin/%, $(TESTSC))
TESTOBJS=$(TESTSRCS:$(TEST)/%.$(SRC_EXT)=$(TEST)/bin/%)
TESTBIN = $(TEST)/bin

INCLUDES=includes

CRITERION=criterion
CRITERION_VER=2.4.0
CRITERION_LIB_DIR=$(INCLUDES)/$(CRITERION)/$(CRITERION)-$(CRITERION_VER)/lib
CRITERION_INCLUDE_DIR=$(INCLUDES)/$(CRITERION)/$(CRITERION)-$(CRITERION_VER)/include

dirs:
	@echo "Creating directories"
	@mkdir -p $(dir $(OBJS))
	@mkdir -p $(INCLUDES)
	@mkdir -p $(TESTBIN)

debug: CFLAGS=-g -Wall 
debug: clean
debug: dirs
debug: $(BIN)

release: CFLAGS=-Wall -O2 -DNDEBUG 
release: clean
release: dirs
release: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TEST)/bin/%: $(TEST)/%.c
	$(CC) $(CFLAGS) $< $(TESTOBJS) -o $@ -L$(CRITERION_LIB_DIR) -I$(CRITERION_INCLUDE_DIR) -l$(CRITERION)

tests: dirs clean $(TESTOBJS) $(TEST)/bin $(TESTBINS)
	for test in $(TESTBINS) ; do ./$$test ; done

clean:
	$(RM) -r $(BINDIR)/* $(OBJ)/* $(TESTBIN)/*

includes: dirs
includes: 
	$(RM) -r  $(INCLUDES)/*
	curl -sSL https://github.com/mindobix/c-macos-libs/archive/refs/tags/$(CRITERION)-v$(CRITERION_VER).zip | tar -xj -C $(INCLUDES) --strip-components=1
	cd  $(CRITERION_LIB_DIR) | ln -s libcriterion.3.dylib libcriterion.dylib
	mv libcriterion.dylib $(INCLUDES)/$(CRITERION)/$(CRITERION)-$(CRITERION_VER)/lib/libcriterion.dylib
	$(RM) -r $(INCLUDES)/README.md