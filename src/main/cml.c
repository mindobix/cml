#include <stdio.h>
#include<math.h>
#include "../lib/argparser/argparser.h"
#include "../learn/static.h"

int main(int argc, char** argv) {
   
   struct ArgStruct argStruct = runArgParser(argc, argv);
   printf("%s\n", argStruct.command1);
   printf("%s\n", argStruct.command2);
   printf("%s\n", argStruct.command3);

   printf("%d", staticCount(1));
   printf("%d", staticCount(2));
}