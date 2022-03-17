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

dirs:
	@echo "Creating directories"
	@mkdir -p $(dir $(OBJS))

debug: CFLAGS=-g -Wall 
debug: clean
debug: dirs
debug: $(BIN)

release: CFLAGS=-Wall -O2 -DNDEBUG 
release: clean
release: dirs
release: $(BIN)

$(TEST)/bin:
	mkdir $@

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TEST)/bin/%: $(TEST)/%.c
	$(CC) $(CFLAGS) $< $(TESTOBJS) -o $@ -L/opt/homebrew/Cellar/criterion/2.4.0/lib -I /opt/homebrew/Cellar/criterion/2.4.0/include -lcriterion

test: clean $(TESTOBJS) $(TEST)/bin $(TESTBINS)
	for test in $(TESTBINS) ; do ./$$test ; done

clean:
	$(RM) -r $(BINDIR)/* $(OBJ)/* $(TESTBIN)/*
