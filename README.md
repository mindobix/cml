
brew install 

cml input load -csv '\document\test.csv'  --> /input/test_input.cml


cml input | output list

cml input | output default 'test.cdb'

cml input | output search 'water'

cml input | output row count
cml input | output row all
cml input | output row 1-5
cml input | output row 1

cml input | output col count

cml input | output col headers

cml input | output col 1-2 row 1-5
cml input | output col 1 
cml input | output col 2 row 4

cml ml linear | l

cml ml logistic | log

cml ml decisiontree | dt

cml ml svm 

cml ml naivebayes | nb

cml ml knn

cml ml kmeans

cml ml randomforest | rf 

cml ml list

cml run linear | l on 'test1'


gcc -g -Wall cml.c lib/argparser/argparser.c learn/static.c -o cml

c lang







_________________________________________________________________________

// printf() displays the string inside quotation
   // int i = 0;
   // printf("Hello, World!\n");
   // int a, b, c, sum;
   // a = 1;  b = 2;  c = 3;
   // sum = a + b + c;
   // printf("sum is %d\n", sum);
   // char d;
   // d = getchar();
   // putchar(d);
   // return 0;

    int i,n,I;
   float sumx, sumxsq, sumy, sumxy, x, y, a0, a1, denom;
   printf("enter the n value");
   scanf("%d", &n);
   sumx = 0;
   sumxsq = 0;
   sumy = 0;
   sumxy = 0;
   for(i = 0; i < n; i++)
   {
      scanf("%f %f", &x, &y);
      sumx += x;
      sumxsq += pow(x, 2);
      sumy += y;
      sumxy += x * y;
   }
   denom = n * sumxsq - pow(sumx, 2);
   a0 = (sumy * sumxsq - sumx * sumxy) / denom;
   a1 = (n * sumxy - sumx * sumy) / denom;




CC=gcc
CFLAGS=-g -Wall
SRC=src
SOURCES := $(shell find $(SRC) -type f -name *.c)
SRCS=$(wildcard $(SRC)/*.c)

SOURCES = $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(SRCEXTS))))
OBJ=obj
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.$(OBJEXT)))
#OBJS=$(patsubst $(SRC)/%.c, $(OBJ)/%.o, $(SRCS))
BINDIR=bin
BIN = $(BINDIR)/main

debug: CFLAGS=-g -Wall
debug: clean
debug: $(BIN)

release: CFLAGS=-Wall -O2 -DNDEBUG
release: clean
release: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) -r $(BINDIR)/* $(OBJ)/*
	
