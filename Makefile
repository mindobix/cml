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
TESTS=$(wildcard $(TEST)/*.c)
TESTBINS=$(patsubst $(TEST)/%.$(SRC_EXT), $(TEST)/bin/%, $(TESTS))
TESTOBJS=$(TESTSRCS:$(TEST)/%.$(SRC_EXT)=$(TEST)/bin/%)
TESTBIN = $(TEST)/bin

INCLUDE=include

dirs:
	@echo "Creating directories"
	@mkdir -p $(dir $(OBJS))
	@mkdir -p $(INCLUDE)
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
	$(CC) $(CFLAGS) $< $(TESTOBJS) -o $@ -L include/criterion/criterion-2.4.0/lib -I include/criterion/criterion-2.4.0/include -lcriterion

test: dirs clean $(TESTOBJS) $(TEST)/bin $(TESTBINS)
	for test in $(TESTBINS) ; do ./$$test ; done

clean:
	$(RM) -r $(BINDIR)/* $(OBJ)/* $(TESTBIN)/*

criterion: dirs
criterion: 
	curl -sSL https://github.com/mindobix/c-macos-libs/archive/refs/tags/criterion-v2.4.0.zip | tar -xj -C include --strip-components=1
	cd  $(INCLUDE)/criterion/criterion-2.4.0/lib | ln -s libcriterion.3.dylib libcriterion.dylib
	mv libcriterion.dylib $(INCLUDE)/criterion/criterion-2.4.0/lib/libcriterion.dylib